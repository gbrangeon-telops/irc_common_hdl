library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.VComponents.all;

entity ce_merge is
   Port (
   ceN_in    : in  std_logic_vector(1 downto 0);
   oeN_in    : in  std_logic_vector(1 downto 0);
   ce_merged : out std_logic;
   ceN_out   : out std_logic;
   oeN_out   : out std_logic);
end ce_merge;

architecture Behavioral of ce_merge is

begin

   ce_merged <= '1' when ceN_in(0)='0' else
                '0' when ceN_in(1)='0' else
                '0';
   ceN_out <= ceN_in(0) and ceN_in(1);
   oeN_out <= oeN_in(0) and oeN_in(1);

end Behavioral;
