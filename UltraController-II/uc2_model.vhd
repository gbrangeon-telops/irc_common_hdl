-------------------------------------------------------------------------------
-- uc2_model.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uc2_model is
  port (
    sys_clk : in std_logic;
    sys_rst : in std_logic;
    gpio_in : in std_logic_vector(0 to 31);
    gpio_out : out std_logic_vector(0 to 31);
    interrupt : in std_logic
  );
end uc2_model;

architecture PLACEHOLDER of uc2_model is
begin   
   
   gpio_out <= (others => 'Z');
   
end architecture PLACEHOLDER;

