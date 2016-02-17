library ieee; 
use ieee.std_logic_1164.all;

-- translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- translate_on

entity oddr_clkout is  
   generic(
      Phase180 : boolean := false);
   port (
      CLK_I     : in std_logic;
      CLK_O     : out std_logic
      );
end oddr_clkout;

architecture rtl of oddr_clkout is
   
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
   
   gen0 : if (Phase180 = false) generate  
      
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
         Q=>CLK_O);	       
      
   end generate; 
   
   gen180 : if (Phase180) generate  
      
      ODDR_INST1 : ODDR
      generic map( INIT => '0',
         DDR_CLK_EDGE => "OPPOSITE_EDGE",
         SRTYPE => "SYNC")
      port map (C=>CLK_I,
         CE=>'1',
         D1=>GND_BIT,
         D2=>VCC_BIT,
         R=>'0',
         S=>'0',
         Q=>CLK_O);	       
      
   end generate;   
   
   
   
   
end rtl;