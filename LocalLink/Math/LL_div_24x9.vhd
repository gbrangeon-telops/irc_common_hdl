-------------------------------------------------------------------------------
--
-- Title       : LL_div_24x9
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
use Common_HDL.all;
use Common_HDL.Telops.all;

entity LL_div_24x9 is
   generic(
      SOF_EOF_Mode : natural := 0 -- 0: SOF_EOF taken from NUM, 1: SOF_EOF taken from DEN, 2, SOF from NUM, EOF from DEN
   );
   port(
      NUM_MOSI    : in  t_ll_mosi24;
      NUM_MISO    : out t_ll_miso;
      
      DEN_MOSI    : in  t_ll_mosi24;
      DEN_MISO    : out t_ll_miso;      
      
      QUOT_MOSI   : out t_ll_mosi24;
      QUOT_MISO   : in  t_ll_miso; 
      
            
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC	
      );
end LL_div_24x9;

architecture RTL of LL_div_24x9 is

   constant LATENCY : natural := 26;    
   -- Shift registers
   signal SOF_sr           : std_logic_vector(LATENCY downto 0);
   signal EOF_sr           : std_logic_vector(LATENCY downto 0);       
   
   signal div_ce  : std_logic; 
   signal div_rfd : std_logic;
   signal div_dval : std_logic;
   
   signal sync_busy  : std_logic;
   signal sync_dval  : std_logic; 
   
   signal Int_MOSI  : t_ll_mosi24;
   signal Int_MISO  : t_ll_miso;   
   
   signal RESET            : std_logic;
   
   component div_w24x9
	   port (
	   clk: IN std_logic;
	   ce: IN std_logic;
	   rfd: OUT std_logic;
	   dividend: IN std_logic_VECTOR(23 downto 0);
	   divisor: IN std_logic_VECTOR(8 downto 0);
	   quotient: OUT std_logic_VECTOR(23 downto 0);
	   fractional: OUT std_logic_VECTOR(8 downto 0));
   end component;
   
   component LL_BusyBreak_24
   port(
      RX_MOSI  : in  t_ll_mosi24; 
      RX_MISO  : out t_ll_miso; 
      
      TX_MOSI  : out t_ll_mosi24;
      TX_MISO  : in  t_ll_miso;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
   end component;

begin                                     
   
   sync_RST : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);                  
   
   div_ce <= (not Int_MISO.AFULL) and (not Int_MISO.BUSY); 
   Int_MOSI.SUPPORT_BUSY <= '1';
   
   -- SOF EOF management
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
   
   -- SOF & EOF shift registers   
   process(CLK)
   begin
      if rising_edge(CLK) then
         if div_ce = '1' then
            SOF_sr(LATENCY downto 1) <= SOF_sr(LATENCY-1 downto 0);
            EOF_sr(LATENCY downto 1) <= EOF_sr(LATENCY-1 downto 0);
         end if;
      end if;
   end process;
      
   Int_MOSI.SOF <= SOF_sr(LATENCY);    
   Int_MOSI.EOF <= EOF_sr(LATENCY);
        
   sync_A_B : entity ll_sync_flow
   port map(
      RX0_DVAL => NUM_MOSI.DVAL,
      RX0_BUSY => NUM_MISO.BUSY,
      RX0_AFULL => NUM_MISO.AFULL,
      RX1_DVAL => DEN_MOSI.DVAL,
      RX1_BUSY => DEN_MISO.BUSY,
      RX1_AFULL => DEN_MISO.AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => sync_dval
      ); 
   sync_busy <= not div_rfd or not div_ce;   
   
   divider : div_w24x9
		port map (
			clk => CLK,
			ce => div_ce,
			rfd => div_rfd,
			dividend => NUM_MOSI.DATA,
			divisor => DEN_MOSI.DATA(8 downto 0),
			quotient => Int_MOSI.DATA,
			fractional => open
			);
	      
   div_dval_inst : entity div_gen_dval
   generic map (     
      -- Now 26 instead of 24 because the divider now does one division per clock and the formula is M+2 = 24+2 = 26
      Latency => 26) 
   port map (
      CLK => CLK,
      RST => RESET,
      DIV_CE => div_ce,
      DIV_RFD => div_rfd,
      DIV_IN_DVAL => sync_dval,
      DIV_OUT_DVAL => div_dval);
      Int_MOSI.dval <= div_dval and div_ce;
            
   BB : LL_BusyBreak_24   
   port map(
      RX_MOSI => Int_MOSI,
      RX_MISO => Int_MISO,
      TX_MOSI => QUOT_MOSI,
      TX_MISO => QUOT_MISO,
      ARESET  => ARESET,
      CLK     => CLK
      );         
   
end RTL;
