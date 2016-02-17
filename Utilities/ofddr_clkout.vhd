library ieee; 
use ieee.std_logic_1164.all;

-- translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- translate_on

entity ofddr_clkout is  
   generic(
      Phase180 : boolean := false); -- If false, CLK_O is in phase with CLK_I, if true, CLK_O is in phase with CLK180_I.
   port (
      CLK_I     : in std_logic;
      CLK180_I  : in std_logic;
      CLK_O     : out std_logic
      );
end ofddr_clkout;

architecture rtl of ofddr_clkout is
   
   signal clkn_s: std_logic;
   signal GND_BIT         : std_logic;
   signal VCC_BIT         : std_logic;   
   

	component ofddrcpe
	port(
		Q : out STD_ULOGIC;
		C0 : in STD_ULOGIC;
		C1 : in STD_ULOGIC;
		CE : in STD_ULOGIC;
		CLR : in STD_ULOGIC;
		D0 : in STD_ULOGIC;
		D1 : in STD_ULOGIC;
		PRE : in STD_ULOGIC);
	end component; 
     
begin
   
   
   clkn_s <= not CLK_I; 
   GND_BIT <= '0';
   VCC_BIT <= '1';    
   
   gen0 : if (Phase180 = false) generate  
      
   OFDDR_INST : OFDDRCPE
   port map (
      C0    => CLK_I,
      C1    => CLK180_I,
      CLR   => '0',
      PRE   => '0',
      CE    => '1',
      D0    => '1',
      D1    => '0',
      Q     => CLK_O);                   
      
   end generate; 
   
   gen180 : if (Phase180) generate  
      
   OFDDR_INST : OFDDRCPE
   port map (
      C0    => CLK_I,
      C1    => CLK180_I,
      CLR   => '0',
      PRE   => '0',
      CE    => '1',
      D0    => '0',
      D1    => '1',
      Q     => CLK_O);	       
      
   end generate;   
   
   
   
   
end rtl;