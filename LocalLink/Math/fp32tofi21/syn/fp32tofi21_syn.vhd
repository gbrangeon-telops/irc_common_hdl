---------------------------------------------------------------------------------------------------
--
-- Title       : fp32tofi21_syn
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
---------------------------------------------------------------------------------------------------
--
-- Description : This is a wrapper for Synplicity Synplify. All ports are slv (no records).
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  

entity fp32tofi21_syn is
   port(        
      EXTRA_EXPON : in  std_logic_vector(7 downto 0);
      EXPON1      : in  std_logic_vector(7 downto 0);
      EXPON2      : in  std_logic_vector(7 downto 0); -- 2nd exponent used for TDM flow
      
      SIGNED_FI   : in  std_logic;
      TDM_FLOW    : in  std_logic;
      FORCE_16BIT : in  std_logic;
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      
      RX_LL_MOSI_slv : in std_logic_vector (35 downto 0);
      RX_LL_MISO_slv : out std_logic_vector (1 downto 0);
      
      TX_LL_MOSI_slv : out std_logic_vector (24 downto 0);
      TX_LL_MISO_slv : in std_logic_vector (1 downto 0);        
           
      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC		 		 		 
      );
end fp32tofi21_syn;     

library Common_HDL;
use Common_HDL.Telops.all; 

architecture SYN of fp32tofi21_syn is    

	component fp32tofi21
	generic(
		Support_Unsigned : BOOLEAN := TRUE;
		Support_16Bit : BOOLEAN := TRUE;
		Support_TDM : BOOLEAN := TRUE);
	port(
	   EXTRA_EXPON : in  std_logic_vector(7 downto 0);
		EXPON1 : in std_logic_vector(7 downto 0);
		EXPON2 : in std_logic_vector(7 downto 0);
		SIGNED_FI : in std_logic;
		TDM_FLOW : in std_logic;
		FORCE_16BIT : in std_logic;
		AVOID_ZERO  : in std_logic;
		RX_LL_MOSI : in t_ll_mosi32;
		RX_LL_MISO : out t_ll_miso;
		TX_LL_MOSI : out t_ll_mosi21;
		TX_LL_MISO : in t_ll_miso;
		OVERFLOW : out std_logic;
		UNDERFLOW : out std_logic;
		ARESET : in std_logic;
		CLK : in std_logic);
	end component;
	
	signal RX_LL_MOSI : t_ll_mosi32;
	signal RX_LL_MISO : t_ll_miso;
	signal TX_LL_MOSI : t_ll_mosi21;
	signal TX_LL_MISO : t_ll_miso;	


begin

   TX_LL_MISO.AFULL <= TX_LL_MISO_slv(1);
   TX_LL_MISO.BUSY <= TX_LL_MISO_slv(0);
   
   TX_LL_MOSI_slv <= TX_LL_MOSI.SOF & TX_LL_MOSI.EOF & TX_LL_MOSI.DATA & TX_LL_MOSI.DVAL & TX_LL_MOSI.SUPPORT_BUSY;
   
   
   RX_LL_MISO_slv <= RX_LL_MISO.AFULL & RX_LL_MISO.BUSY;
   
   RX_LL_MOSI.SOF <= RX_LL_MOSI_slv(35);
   RX_LL_MOSI.EOF <= RX_LL_MOSI_slv(34);
   RX_LL_MOSI.DATA <= RX_LL_MOSI_slv(33 downto 2);
   RX_LL_MOSI.DVAL <= RX_LL_MOSI_slv(1);
   RX_LL_MOSI.SUPPORT_BUSY <= RX_LL_MOSI_slv(0); 
   
   U1 : fp32tofi21
   generic map(
   	Support_Unsigned => TRUE, 
		Support_16Bit    => TRUE,
		Support_TDM      => TRUE
   )
   port map(
      EXTRA_EXPON => EXTRA_EXPON,
      EXPON1 => EXPON1,
      EXPON2 => EXPON2,
      SIGNED_FI => SIGNED_FI,
      TDM_FLOW => TDM_FLOW,
      FORCE_16BIT => FORCE_16BIT,
      AVOID_ZERO => AVOID_ZERO,
      RX_LL_MOSI => RX_LL_MOSI,
      RX_LL_MISO => RX_LL_MISO,
      TX_LL_MOSI => TX_LL_MOSI,
      TX_LL_MISO => TX_LL_MISO,
      OVERFLOW => OVERFLOW,
      UNDERFLOW => UNDERFLOW,
      ARESET => ARESET,
      CLK => CLK
   ); 
   
end SYN;
