------------------------------------------------------------------
--!   @file : oddr_clk_vector
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- translate_off
library UNISIM;
use UNISIM.vcomponents.all;
-- translate_on

entity oddr_clk_vector is
   generic(
      WIDTH : integer := 1
      );
   port(
      CLK_IN : in std_logic_vector(WIDTH-1 downto 0);
      CLK_O : out std_logic_vector(WIDTH-1 downto 0)
      );
end oddr_clk_vector;

architecture rtl of oddr_clk_vector is   
   
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
   
   oddr_array : for i in 0 to WIDTH-1 generate
      oddr_inst1 : ODDR
      generic map( INIT => '0',
         DDR_CLK_EDGE => "OPPOSITE_EDGE",
         SRTYPE => "SYNC")
      port map (C=>CLK_IN(i),
         CE=>'1',
         D1=>'1',
         D2=>'0',
         R=>'0',
         S=>'0',
         Q=>CLK_O(i));	
   end generate;
   
end rtl;
