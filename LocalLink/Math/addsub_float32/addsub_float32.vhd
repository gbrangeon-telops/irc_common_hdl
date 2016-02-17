-------------------------------------------------------------------------------
--
-- Title       : addsub_float32
-- Design      : VP30
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.Telops.all;

entity addsub_float32 is
   generic(         
      SOF_EOF_Mode : natural := 0; -- 0: SOF_EOF taken from A, 1: SOF_EOF taken from B, 2, SOF from A, EOF from B      
      LATENCY : integer := 5;
      Verbose : boolean := false
      );
   port(
      A_MOSI   : in  t_ll_mosi32;
      A_MISO   : out t_ll_miso;
      
      B_MOSI   : in  t_ll_mosi32;
      B_MISO   : out t_ll_miso;      
      
      RES_MOSI : out t_ll_mosi32;
      RES_MISO : in  t_ll_miso; 
      
      ERR      : out std_logic_vector(3 downto 0); -- ERR <= underflow & overflow & frame_sync_err & not_ready_err;
      OP       : in std_logic; -- 0: Add, 1: Sub
      
      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC		 		 	
      );
end addsub_float32;        

-- pragma translate_off
library IEEE_proposed;
use ieee_proposed.float_pkg.all;
-- pragma translate_on


architecture RTL of addsub_float32 is 
   
   -- Declaration needed because this is a black box
   component fp_addsub_float32
      port (
         a: IN std_logic_VECTOR(31 downto 0);
         b: IN std_logic_VECTOR(31 downto 0);
         operation: IN std_logic_VECTOR(5 downto 0);
         operation_nd: IN std_logic;
         operation_rfd: OUT std_logic;
         clk: IN std_logic;
         sclr: IN std_logic;
         ce: IN std_logic;
         result: OUT std_logic_VECTOR(31 downto 0);
         underflow: OUT std_logic;
         overflow: OUT std_logic;
         rdy: OUT std_logic);
   end component;
   
   component fp_addsub_float32_l9
      port (
         a: IN std_logic_VECTOR(31 downto 0);
         b: IN std_logic_VECTOR(31 downto 0);
         operation: IN std_logic_VECTOR(5 downto 0);
         operation_nd: IN std_logic;
         operation_rfd: OUT std_logic;
         clk: IN std_logic;
         sclr: IN std_logic;
         ce: IN std_logic;
         result: OUT std_logic_VECTOR(31 downto 0);
         underflow: OUT std_logic;
         overflow: OUT std_logic;
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
   signal not_ready_err    : std_logic;
   signal frame_sync_err   : std_logic;
   
   -- Handshaking
   signal operation_nd     : std_logic;
   signal operation_rfd    : std_logic;  
   signal ce               : std_logic;  
   --signal ce_inv           : std_logic;  
   signal rdy              : std_logic; 
   signal addsub_dval      : std_logic;
   signal sync_busy        : std_logic;
   
   -- Registers
   signal hold_dval        : std_logic;
   signal ce_reg           : std_logic;
   
   -- Buffers
   signal result           : std_logic_vector(31 downto 0);
   signal OUT_DVALi        : std_logic;
   
   -- Shift registers
   signal SOF_sr           : std_logic_vector(LATENCY downto 0);
   signal EOF_sr           : std_logic_vector(LATENCY downto 0);
   
   -- Misc
   signal RESET            : std_logic;
   signal op_full          : std_logic_vector(5 downto 0);
   
   -- pragma translate_off
   signal a_real           : real;
   signal b_real           : real;
   signal result_real      : real;
   -- pragma translate_on       
   
   signal a                : std_logic_vector(31 downto 0);
   signal b                : std_logic_vector(31 downto 0);  
   
   signal FoundGenCase : boolean := FALSE; 
   
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
   
   not_ready_err <= operation_nd and not operation_rfd;
   frame_sync_err <= operation_nd and ((A_MOSI.SOF xor B_MOSI.SOF) or (A_MOSI.EOF xor B_MOSI.EOF));
   
   --ERR <= underflow or overflow or not_ready_err; 
   ERR <= underflow & overflow & frame_sync_err & not_ready_err;
   
   OUT_MOSI.SUPPORT_BUSY <= '1';
   OUT_DVALi <= addsub_dval or hold_dval;
   OUT_MOSI.DVAL <= OUT_DVALi;
   OUT_MOSI.DATA <= result;
   OUT_MOSI.SOF <= SOF_sr(LATENCY);
   OUT_MOSI.EOF <= EOF_sr(LATENCY);
   
   ce <= (not OUT_MISO.AFULL) and (not OUT_MISO.BUSY); 
   --ce_inv <= not ce; 
   addsub_dval <= rdy and ce_reg;
   
   SOF_EOF_0 : if (SOF_EOF_Mode = 0) generate
      SOF_sr(0) <= A_MOSI.SOF;
      EOF_sr(0) <= A_MOSI.EOF; 
   end generate SOF_EOF_0;
   
   SOF_EOF_1 : if (SOF_EOF_Mode = 1) generate
      SOF_sr(0) <= B_MOSI.SOF;
      EOF_sr(0) <= B_MOSI.EOF; 
   end generate SOF_EOF_1;
   
   SOF_EOF_2 : if (SOF_EOF_Mode = 2) generate
      SOF_sr(0) <= A_MOSI.SOF;
      EOF_sr(0) <= B_MOSI.EOF; 
   end generate SOF_EOF_2;   
   
   BB : ll_busybreak
   generic map(
      DLEN => 32
      )   
   port map(
      RX_MOSI => OUT_MOSI,
      RX_MISO => OUT_MISO,
      TX_MOSI => RES_MOSI,
      TX_MISO => RES_MISO,
      ARESET => ARESET,
      CLK => CLK
      );      
   
   sync_A_B : ll_sync_flow
   port map(
      RX0_DVAL => A_MOSI.DVAL,
      RX0_BUSY => A_MISO.BUSY,
      RX0_AFULL => A_MISO.AFULL,
      RX1_DVAL => B_MOSI.DVAL,
      RX1_BUSY => B_MISO.BUSY,
      RX1_AFULL => B_MISO.AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => operation_nd
      ); 
   sync_busy <= not ce or not operation_rfd;
   
   -- pragma translate_off      
   a_real <= to_real(to_float(A_MOSI.DATA));      
   b_real <= to_real(to_float(B_MOSI.DATA));      
   result_real <= to_real(to_float(result));      
   -- pragma translate_on   
   
   a <= Uto0(A_MOSI.DATA) when FALSE
   -- pragma translate_off
   or A_MOSI.DVAL = '0'
   -- pragma translate_on
   else A_MOSI.DATA;
   
   b <= Uto0(B_MOSI.DATA) when FALSE
   -- pragma translate_off
   or B_MOSI.DVAL = '0'
   -- pragma translate_on
   else B_MOSI.DATA;      
   
   op_full <= "00000" & OP;
   
   
   addsub_float_l5 : if LATENCY = 5 generate
      begin
      FoundGenCase <= true; 
      fp_fiv : fp_addsub_float32
      port map (
         a => a,
         b => b,
         operation => op_full,
         operation_nd => operation_nd,
         operation_rfd => operation_rfd,
         clk => CLK,
         sclr => RESET,
         ce => ce,
         result => result,
         underflow => underflow,
         overflow => overflow,      
         rdy => rdy);
   end generate;
   
   addsub_float_L9 : if LATENCY = 9 generate
      begin
      FoundGenCase <= true; 
      fp_fiv : fp_addsub_float32_l9
      port map (
         a => a,
         b => b,
         operation => op_full,
         operation_nd => operation_nd,
         operation_rfd => operation_rfd,
         clk => CLK,
         sclr => RESET,
         ce => ce,
         result => result,
         underflow => underflow,
         overflow => overflow,      
         rdy => rdy);
   end generate;
   
   main : process(CLK)      
      -- translate_off
      variable cnt_in, cnt_out : integer := 1;
      -- translate_on
   begin
      if rising_edge(CLK) then 
         ce_reg <= ce;
         
         -- DVALID latch (when destination is not ready, all we have to do is hold the DVal signal, the data stays valid at the core output)
         if RESET = '1' then
            hold_dval <= '0';
         else           
            hold_dval <= OUT_MISO.BUSY and OUT_DVALi;  
         end if;         
         
         -- SOF & EOF shift registers
         if ce = '1' then
            SOF_sr(LATENCY downto 1) <= SOF_sr(LATENCY-1 downto 0);
            EOF_sr(LATENCY downto 1) <= EOF_sr(LATENCY-1 downto 0);
         end if;
         
         if RESET = '0' then    
            -- translate_off
            assert (A_MOSI.SUPPORT_BUSY = '1') report "A Upstream module must support the BUSY signal" severity FAILURE;      
            assert (B_MOSI.SUPPORT_BUSY = '1') report "B Upstream module must support the BUSY signal" severity FAILURE;                  
            
            if Verbose then
               if addsub_dval = '1' then
                  assert (overflow = '0') report "AddSub overflow" severity ERROR;                              
                  assert (underflow = '0') report "AddSub underflow" severity ERROR;      
               end if; 
            end if;
            assert (not_ready_err = '0') report "AddSub not_ready_err" severity ERROR;                
            if operation_nd='1' and ce='1' then
               assert (operation_rfd='1') report "AddSub not ready!" severity ERROR;                
            end if;        
            
            -- translate_on
         end if;    
         
         -- Debug counters
         -- pragma translate_off           
         if operation_nd = '1' and ce = '1' then
            if A_MOSI.SOF = '1' then
               cnt_in := 2;               
            else
               cnt_in := cnt_in + 1;
            end if;
         end if;  
         if rdy = '1' and ce = '1' then
            if SOF_sr(LATENCY) = '1' then
               cnt_out := 2;               
            else
               cnt_out := cnt_out + 1;
            end if;
         end if;           
         -- pragma translate_on
      end if;
   end process;   	
   
end RTL;
