-------------------------------------------------------------------------------
--
-- Title       : ram_dist
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : Distributed RAM with Asynchronous Read, directly
--               mapped onto LUT. Heavily inspired by the XST user guide.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

entity ram_dist is
   -- Mapped onto distributed (LUT) ram
   generic (
      D_WIDTH : integer := 16;
      A_WIDTH : integer := 8);
   port (
      CLK : in std_logic;
      WE : in std_logic;
      A : in std_logic_vector(A_WIDTH-1 downto 0);
      DI : in std_logic_vector(D_WIDTH-1 downto 0);
      DO : out std_logic_vector(D_WIDTH-1 downto 0));
end ram_dist;

architecture syn of ram_dist is
   type ram_type is array ((2**A_WIDTH)-1 downto 0) of std_logic_vector (D_WIDTH-1 downto 0);
   signal RAM : ram_type;
   attribute ram_style: string;
   attribute ram_style of RAM: signal is "distributed";    
begin
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (WE = '1') then
            RAM(conv_integer(A)) <= DI;
         end if;
      end if;
   end process;
   DO <= RAM(conv_integer(A));
end syn;