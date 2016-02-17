-------------------------------------------------------------------------------
-- uc2_sim.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uc2 is
  port (
    sys_clk : in std_logic;
    sys_rst : in std_logic;
    gpio_in : in std_logic_vector(0 to 31);
    gpio_out : out std_logic_vector(0 to 31);
    interrupt : in std_logic;
    sys_rst_out : out std_logic;
    jtag_tck : in std_logic;
    jtag_tms : in std_logic;
    jtag_tdi : in std_logic;
    jtag_tdo : out std_logic;
    jtag_tdoen : out std_logic
  );
end uc2;

architecture INACTIVE of uc2 is
begin   
   
   gpio_out <= (others => 'Z');
   sys_rst_out <= 'Z';
   
end architecture INACTIVE;

