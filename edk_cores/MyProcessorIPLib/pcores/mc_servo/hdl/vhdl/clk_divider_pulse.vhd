---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: clk_divider_pulse.vhd
--  Hierarchy: Sub-module file
--  Use: integer div ratio synthesizable clock divider 
--	 Project: GATORADE2 - Temperature control loop
--	 By: Olivier Bourgois
--  Date: October 7, 2005
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity clk_divider_pulse is
  generic(
    FACTOR : integer);
  port(
    CLOCK     : in  std_logic;
    RESET     : in  std_logic;
    PULSE     : out std_logic);
end entity clk_divider_pulse;

architecture rtl of clk_divider_pulse is

  -- function to convert an integer to an appropriately sized std_logic_vector;
  function vect_value (value : integer) return std_logic_vector is
  variable width   : integer := 0;
  variable intval  : integer;
  begin
    intval := value;
    L1: loop
      width := width + 1;
	  exit L1 when 2**width >= intval;
    end loop L1;
    return conv_std_logic_vector(intval,width);
  end function vect_value;

  constant ratio     : std_logic_vector := vect_value(FACTOR -1);

  signal div_cnt     : std_logic_vector(ratio'range);
  signal term_cnt    : std_logic;
  signal pulse_local : std_logic;

begin

-- drive the output clock
  PULSE <= pulse_local;
-- detect the clock divider terminal count
  term_cnt <= '1' when (div_cnt = ratio ) else '0';

-- divide incoming clock to generate slower clock
  clk_divider_pulse_proc : process(CLOCK)
  begin
    if (CLOCK'event) and (CLOCK = '1') then
      if (RESET = '1') then
        for i in div_cnt'range loop
          div_cnt(i) <= '0';
        end loop;
        pulse_local <= '0';
      elsif (term_cnt = '1') then
        for i in div_cnt'range loop
          div_cnt(i) <= '0';
        end loop;
        pulse_local <= '1';
      else
        div_cnt <= div_cnt + 1;
		  pulse_local <= '0';
      end if;
    end if;
  end process clk_divider_pulse_proc;

end rtl;
