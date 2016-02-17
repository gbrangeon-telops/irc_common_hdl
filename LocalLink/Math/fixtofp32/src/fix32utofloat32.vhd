-------------------------------------------------------------------------------
--
-- Title       : fix32utofp32
-- Design      : IRCDEV
-- Author      : Patrick Daraiche
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

entity fix32utofp32 is
   generic(
      LATENCY : integer := 6;
      Verbose : boolean := false
      );
   port(
      FIX_MOSI   : in  t_ll_mosi32;
      FIX_MISO   : out t_ll_miso;
      
      FP_MOSI   : out  t_ll_mosi32;
      FP_MISO   : in t_ll_miso;      
      
      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC		 		 	
      );
end fix32utofp32;        

-- pragma translate_off
library IEEE_proposed;
use ieee_proposed.float_pkg.all;
-- pragma translate_on


architecture RTL of fix32utofp32 is 
   
   -- Declaration needed because this is a black box
   component fix32tofp32
      port (
      a: IN std_logic_VECTOR(31 downto 0);
      operation_nd: IN std_logic;
      operation_rfd: OUT std_logic;
      clk: IN std_logic;
      sclr: IN std_logic;
      ce: IN std_logic;
      result: OUT std_logic_VECTOR(31 downto 0);
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
   signal sync_busy        : std_logic;
   signal rdy              : std_logic; 
   signal hold_dval        : std_logic;
   
   -- Registers
   signal fix_dval        : std_logic;
   signal ce_reg           : std_logic;
   
   -- Buffers
   signal result           : std_logic_vector(31 downto 0);
   signal OUT_DVALi        : std_logic;
   
   -- Shift registers
   signal SOF_sr           : std_logic_vector(LATENCY downto 0);
   signal EOF_sr           : std_logic_vector(LATENCY downto 0);
   
   -- Misc
   signal RESET            : std_logic;
   
   -- pragma translate_off
   signal a_real           : real;
   signal b_real           : real;
   signal result_real      : real;
   -- pragma translate_on   
   
   signal fix                : std_logic_vector(31 downto 0);
   signal fp                : std_logic_vector(31 downto 0);
   
   signal FoundGenCase : boolean := FALSE; 
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;   
   
begin                                     
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);   
   
   --frame_sync_err <= operation_nd and ((A_MOSI.SOF xor B_MOSI.SOF) or (A_MOSI.EOF xor B_MOSI.EOF));
   not_ready_err <= operation_nd and not operation_rfd;
   --ERR <= underflow & overflow & frame_sync_err & not_ready_err;
   
   OUT_MOSI.SUPPORT_BUSY <= '1';
   OUT_DVALi <= fix_dval or hold_dval;
   OUT_MOSI.DVAL <= OUT_DVALi;
   OUT_MOSI.DATA <= result;
   OUT_MOSI.SOF <= SOF_sr(LATENCY);
   OUT_MOSI.EOF <= EOF_sr(LATENCY);
   OUT_MOSI.DREM <= (others => '1');
   
   ce <= (not OUT_MISO.AFULL) and (not OUT_MISO.BUSY); 
   --ce_inv <= not ce; 
   fix_dval <= rdy and ce_reg;
   
   SOF_sr(0) <= FIX_MOSI.SOF;
   EOF_sr(0) <= FIX_MOSI.EOF; 
   
   
   BB : ll_busybreak
   generic map(
      DLEN => 32
      )    
   port map(
      RX_MOSI => OUT_MOSI,
      RX_MISO => OUT_MISO,
      TX_MOSI => FP_MOSI,
      TX_MISO => FP_MISO,
      ARESET => ARESET,
      CLK => CLK
      );      
   
   sync_busy <= not ce or not operation_rfd;
   FIX_MISO.BUSY <= sync_busy;
   FIX_MISO.AFULL <= '0';
   
   -- pragma translate_off      
   a_real <= to_real(to_float(FIX_MOSI.DATA));      
   -- pragma translate_on 
   
   fix <= Uto0(FIX_MOSI.DATA) when FALSE
   -- pragma translate_off
   or FIX_MOSI.DVAL = '0'
   -- pragma translate_on
   else FIX_MOSI.DATA;
   
fix_to_fp : fix32tofp32
		port map (
			a => fix,
			operation_nd => operation_nd,
			operation_rfd => operation_rfd,
			clk => CLK,
			sclr => RESET,
			ce => ce,
			result => result,
			rdy => rdy);
   

   main : process(CLK)      
      -- pragma translate_off
      variable cnt_in, cnt_out : integer := 1;
      -- pragma translate_on
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
            assert (FIX_MOSI.SUPPORT_BUSY = '1') report "A Upstream module must support the BUSY signal" severity FAILURE;      
            if Verbose then
               if hold_dval = '1' then
--                  assert (underflow = '0') report "Multiplier underflow" severity ERROR;                
--                  assert (overflow = '0') report "Multiplier overflow" severity ERROR;                              
               end if;        
            end if;
            assert (not_ready_err = '0') report "Multiplier not_ready_err" severity ERROR;                
            -- translate_on
         end if;    
         
         -- Debug counters
         -- translate_off           
         if operation_nd = '1' and ce = '1' then
            if FIX_MOSI.SOF = '1' then
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
         -- translate_on
      end if;
   end process;   	
   
end RTL;
