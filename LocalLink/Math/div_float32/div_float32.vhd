-------------------------------------------------------------------------------
--
-- Title       : div_float32
-- Design      : VP30
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity div_float32 is
   generic(
      SOF_EOF_Mode : natural := 0; -- 0: SOF_EOF taken from NUM, 1: SOF_EOF taken from DEN, 2, SOF from NUM, EOF from DEN
      Verbose : boolean := false
      );
   port(
      NUM_MOSI    : in  t_ll_mosi32;
      NUM_MISO    : out t_ll_miso;
      
      DEN_MOSI    : in  t_ll_mosi32;
      DEN_MISO    : out t_ll_miso;      
      
      QUOT_MOSI   : out t_ll_mosi32;
      QUOT_MISO   : in  t_ll_miso; 
      
      ERR         : out std_logic_vector(4 downto 0); -- ERR <= underflow & overflow & divide_by_zero & frame_sync_err & not_ready_err;
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC		 		 	
      );
end div_float32;        

-- pragma translate_off
library IEEE_proposed;
use ieee_proposed.float_pkg.all;
-- pragma translate_on


architecture RTL of div_float32 is 
   
   -- Declaration needed because this is a black box
   component fp_div_float32
      port (
         a: IN std_logic_VECTOR(31 downto 0);
         b: IN std_logic_VECTOR(31 downto 0);
         operation_nd: IN std_logic;
         operation_rfd: OUT std_logic;
         clk: IN std_logic;
         sclr: IN std_logic;
         ce: IN std_logic;
         result: OUT std_logic_VECTOR(31 downto 0);
         underflow: OUT std_logic;
         overflow: OUT std_logic;
         divide_by_zero: OUT std_logic;
         rdy: OUT std_logic);
   end component;                
   
   component ll_busybreak
      generic(
         DLEN : NATURAL := 32);
      port(
         RX_MOSI : in t_ll_mosi32;
         RX_MISO : out t_ll_miso;
         TX_MOSI : out t_ll_mosi32;
         TX_MISO : in t_ll_miso;
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC);
   end component;   
   
   -- Output just before BreakBusy
   signal OUT_MOSI         : t_ll_mosi32;
   signal OUT_MISO         : t_ll_miso;    
   
   -- Errors
   signal underflow        : std_logic;
   signal overflow         : std_logic;
   signal divide_by_zero   : std_logic;
   signal not_ready_err    : std_logic;
   signal frame_sync_err   : std_logic;
   
   -- Handshaking
   signal operation_nd     : std_logic;
   signal operation_rfd    : std_logic;  
   signal ce               : std_logic;  
   --signal ce_inv           : std_logic; 
   signal sync_busy        : std_logic;
   signal rdy              : std_logic; 
   signal div_dval         : std_logic;
   constant Latency        : integer := 28; -- WARNING: Latency was 27 for core v2.0 but is now 28 for core v3.0.
   
   -- Registers
   signal hold_dval        : std_logic;
   signal ce_reg           : std_logic;
   
   -- Buffers
   signal result           : std_logic_vector(31 downto 0);
   signal OUT_DVAL       : std_logic;
   signal NUM_BUSYi        : std_logic;
   signal DEN_BUSYi        : std_logic;
   
   -- Shift registers
   signal SOF_sr           : std_logic_vector(Latency downto 0);
   signal EOF_sr           : std_logic_vector(Latency downto 0);
   
   -- Misc
   signal RESET            : std_logic;      
   
   -- pragma translate_off
   signal a_real           : real;
   signal b_real           : real;
   signal result_real      : real;
   signal num_rx_cnt       : unsigned(31 downto 0);
   signal den_rx_cnt       : unsigned(31 downto 0);    
   -- pragma translate_on      
   
   signal a                : std_logic_vector(31 downto 0);
   signal b                : std_logic_vector(31 downto 0); 
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;   
   
   component ll_sync_flow
      port(
         RX0_DVAL : in std_logic;
         RX0_BUSY : out std_logic;
         RX0_AFULL : out std_logic;
         RX1_DVAL : in std_logic;
         RX1_BUSY : out std_logic;
         RX1_AFULL : out std_logic;
         SYNC_BUSY : in std_logic;
         SYNC_DVAL : out std_logic);
   end component;               
   
begin                                     
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);   
   
   frame_sync_err <= operation_nd and ((NUM_MOSI.SOF xor DEN_MOSI.SOF) or (NUM_MOSI.EOF xor DEN_MOSI.EOF));
   not_ready_err <= operation_nd and not operation_rfd;
   ERR <= underflow & overflow & divide_by_zero & frame_sync_err & not_ready_err;
   
   OUT_MOSI.SUPPORT_BUSY <= '1';
   OUT_DVAL <= div_dval or hold_dval;
   OUT_MOSI.DVAL <= OUT_DVAL;
   OUT_MOSI.DATA <= result;
   OUT_MOSI.SOF <= SOF_sr(Latency);
   OUT_MOSI.EOF <= EOF_sr(Latency);
   
   ce <= (not OUT_MISO.AFULL) and (not OUT_MISO.BUSY) and not RESET; 
   
   div_dval <= rdy and ce_reg;
   
   SOF_EOF_0 : if (SOF_EOF_Mode = 0) generate
      SOF_sr(0) <= NUM_MOSI.SOF;
      EOF_sr(0) <= NUM_MOSI.EOF; 
   end generate SOF_EOF_0;
   
   SOF_EOF_1 : if (SOF_EOF_Mode = 1) generate
      SOF_sr(0) <= DEN_MOSI.SOF;
      EOF_sr(0) <= DEN_MOSI.EOF; 
   end generate SOF_EOF_1;
   
   SOF_EOF_2 : if (SOF_EOF_Mode = 2) generate
      SOF_sr(0) <= NUM_MOSI.SOF;
      EOF_sr(0) <= DEN_MOSI.EOF; 
   end generate SOF_EOF_2;    
   
   NUM_MISO.BUSY <= NUM_BUSYi;
   DEN_MISO.BUSY <= DEN_BUSYi;
   sync_num_den : ll_sync_flow
   port map(
      RX0_DVAL => NUM_MOSI.DVAL,
      RX0_BUSY => NUM_BUSYi,
      RX0_AFULL => NUM_MISO.AFULL,
      RX1_DVAL => DEN_MOSI.DVAL,
      RX1_BUSY => DEN_BUSYi,
      RX1_AFULL => DEN_MISO.AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => operation_nd
      );                 
   --sync_busy <= not ce or not operation_rfd;
   sync_busy <= OUT_MISO.AFULL or OUT_MISO.BUSY or not operation_rfd;    
   
   BB : ll_busybreak
   generic map(
      DLEN => 32
      )    
   port map(
      RX_MOSI => OUT_MOSI,
      RX_MISO => OUT_MISO,
      TX_MOSI => QUOT_MOSI,
      TX_MISO => QUOT_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   
   
   -- pragma translate_off      
   a_real <= to_real(to_float(NUM_MOSI.DATA));      
   b_real <= to_real(to_float(DEN_MOSI.DATA));      
   result_real <= to_real(to_float(result));      
   -- pragma translate_on    
   
   a <= Uto0(NUM_MOSI.DATA) when FALSE
   -- pragma translate_off
   or NUM_MOSI.DVAL = '0'
   -- pragma translate_on
   else NUM_MOSI.DATA;
   
   b <= Uto0(DEN_MOSI.DATA) when FALSE
   -- pragma translate_off
   or DEN_MOSI.DVAL = '0'
   -- pragma translate_on
   else DEN_MOSI.DATA;    
   
   fp_fiv : fp_div_float32
   port map (
      a => a,
      b => b,
      operation_nd => operation_nd,
      operation_rfd => operation_rfd,
      clk => CLK,
      sclr => RESET,
      ce => ce,
      result => result,
      underflow => underflow,
      overflow => overflow,
      divide_by_zero => divide_by_zero,
      rdy => rdy);  
   
   main : process(CLK)      
      -- pragma translate_off
      variable cnt_in, cnt_out : integer := 1;
      -- pragma translate_on
   begin
      if rising_edge(CLK) then 
         ce_reg <= ce;
         
         -- DVALID latch (when destination is not ready, all we have to do is hold the DVal signal, the data stays valid at the divider output)
         if RESET = '1' then
            hold_dval <= '0';
         else           
            hold_dval <= OUT_MISO.BUSY and OUT_DVAL;  
         end if;         
         
         -- SOF & EOF shift registers
         if ce = '1' then
            SOF_sr(Latency downto 1) <= SOF_sr(Latency-1 downto 0);
            EOF_sr(Latency downto 1) <= EOF_sr(Latency-1 downto 0);
         end if;
         
         -- translate_off
         if RESET = '0' then    
            
            assert (NUM_MOSI.SUPPORT_BUSY = '1') report "NUM Upstream module must support the BUSY signal" severity FAILURE;      
            assert (DEN_MOSI.SUPPORT_BUSY = '1') report "DEN Upstream module must support the BUSY signal" severity FAILURE;                  
            if Verbose then
               if div_dval = '1' then
                  assert (underflow = '0') report "Divider underflow" severity ERROR;                
                  assert (overflow = '0') report "Divider overflow" severity ERROR;                
                  assert (divide_by_zero = '0') report "Divider divide_by_zero" severity ERROR;                
               end if;        
            end if;
            assert (not_ready_err = '0') report "Divider not_ready_err" severity ERROR;
         else
            num_rx_cnt <= (others => '0');  
            den_rx_cnt <= (others => '0');
            
         end if;  
         -- translate_on
         
         -- Debug counters
         -- pragma translate_off           
         if operation_nd = '1' and ce = '1' then
            if NUM_MOSI.SOF = '1' then
               cnt_in := 2;               
            else
               cnt_in := cnt_in + 1;
            end if;
         end if;  
         if rdy = '1' and ce = '1' then
            if SOF_sr(Latency) = '1' then
               cnt_out := 2;               
            else
               cnt_out := cnt_out + 1;
            end if;
         end if; 
         if NUM_MOSI.DVAL='1' and NUM_BUSYi='0' then
            num_rx_cnt <= num_rx_cnt + 1;
         end if; 
         if DEN_MOSI.DVAL='1' and DEN_BUSYi='0' then
            den_rx_cnt <= den_rx_cnt + 1;
         end if;         
         -- pragma translate_on
      end if;
   end process;      
   
end RTL;
