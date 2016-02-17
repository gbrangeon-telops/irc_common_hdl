---------------------------------------------------------------------------------------------------
--
-- Title       : fp32tofi21_wrap
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
---------------------------------------------------------------------------------------------------
--
-- Description : This is a wrapper without generics.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.Telops.all; 

entity fp32tofi21_wrap is
   port(                                             
      EXTRA_EXPON : in  std_logic_vector(7 downto 0);
      EXPON1      : in  std_logic_vector(7 downto 0);
      EXPON2      : in  std_logic_vector(7 downto 0); -- 2nd exponent used for TDM flow
      
      SIGNED_FI   : in  std_logic;
      TDM_FLOW    : in  std_logic;
      FORCE_16BIT : in  std_logic;
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      
      RX_LL_MOSI  : in  t_ll_mosi32;
      RX_LL_MISO  : out t_ll_miso;
      
      TX_LL_MOSI  : out t_ll_mosi21;
      TX_LL_MISO  : in  t_ll_miso;   
      
      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC		 		 		 
      );
end fp32tofi21_wrap;     


architecture MAPPED of fp32tofi21_wrap is 

	-- Component declaration of the "fp32tofi21(rtl)" unit defined in
	-- file: "./../LocalLink/Math/fp32tofi21/fp32tofi21.vhd"
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

   
begin            

   U1 : fp32tofi21
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
   
end MAPPED;
