--------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package sim_pkg is

   type calib_sim_t is
   record
      SB_Min         : unsigned(15 downto 0);
      SB_Max         : unsigned(15 downto 0);      
   end record;
   signal sim : calib_sim_t;
      
end sim_pkg;

package body sim_pkg is
  
end package body sim_pkg;