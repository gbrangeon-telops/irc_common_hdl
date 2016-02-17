library ieee; 
use ieee.std_logic_1164.all;

-- translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- translate_on

entity oddr_clkout_diff is
   port (
      CLK_I     : in std_logic;
      CLK_O_P   : out std_logic;
      CLK_O_N   : out std_logic
      );
end oddr_clkout_diff;

architecture rtl of oddr_clkout_diff is
   
   signal clkn_s: std_logic;
   signal GND_BIT         : std_logic;
   signal VCC_BIT         : std_logic; 
   
   component ODDR
      generic( INIT : bit :=  '0';
         DDR_CLK_EDGE : string :=  "OPPOSITE_EDGE";
         SRTYPE : string :=  "SYNC");
      port ( D1 : in    std_logic; 
         D2 : in    std_logic; 
         CE : in    std_logic; 
         C  : in    std_logic; 
         S  : in    std_logic; 
         R  : in    std_logic; 
         Q  : out   std_logic);
   end component;  
   
begin
   
   
   clkn_s <= not CLK_I; 
   GND_BIT <= '0';
   VCC_BIT <= '1'; 
   
   
   ODDR_INST1 : ODDR
   generic map( INIT => '0',
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      SRTYPE => "SYNC")
   port map (C=>CLK_I,
      CE=>'1',
      D1=>VCC_BIT,
      D2=>GND_BIT,
      R=>'0',
      S=>'0',
      Q=>CLK_O_P);	    
   
   ODDR_INST2 : ODDR
   generic map( INIT => '0',
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      SRTYPE => "SYNC")
   port map (C=>clkn_s,
      CE=>'1',
      D1=>VCC_BIT,
      D2=>GND_BIT,
      R=>'0',
      S=>'0',
      Q=>CLK_O_N);	         
   
end rtl;