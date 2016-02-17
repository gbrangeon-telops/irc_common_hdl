---------------------------------------------------------------------------------------------------
--
-- Title       : reset_extension
-- Author      : SSA
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- SVN modified fields:
-- $Revision$
-- $Author$
-- $LastChangedDate$
---------------------------------------------------------------------------------------------------
--
-- Description : extend the reset pulse for a configurable period of time (typically used for dcms and idelayctrl).
--                if HOLD_PERIOD is set to 0 (default), the pulse will be sync'ed/extended for 4 CLK periods
--                HOLD_PERIOD is a minimum target, the pulse will always be held longer
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity reset_extension is
   generic ( 
      HOLD_PERIOD : real := 0.0;   -- hold time [ns]
      CLKIN_PERIOD : real := 10.0  -- nanoseconds
      );
   port(
      RST_IN   : in STD_LOGIC;            -- The reset that would normally reset the DCM if you didn't use this component.
      RST_OUT  : out STD_LOGIC := '1';    -- The signal that you should connect to the DCM reset.
      CLK      : in STD_LOGIC             -- The clock signal that goes IN the DCM.
      );
end reset_extension;

architecture RTL of reset_extension is
   signal temp_rst : std_logic_vector(3 downto 0) := (others => '1');       
begin                    
   
   RST_OUT <= temp_rst(0);
   
   NO_EXTEND : if HOLD_PERIOD = 0.0 generate
      process(CLK, RST_IN)
      begin
         if RST_IN = '1' then
            temp_rst <= (others => '1');
         elsif rising_edge(CLK) then
            temp_rst(3 downto 0) <= RST_IN & temp_rst(3 downto 1);
         end if;
      end process;
   end generate;
   
   EXTEND : if HOLD_PERIOD > 0.0 generate
      process(CLK, RST_IN)
         constant numbits : integer := integer(ceil(log(HOLD_PERIOD/CLKIN_PERIOD)/MATH_LOG_OF_2));
         constant all_ones : unsigned(numbits-1 downto 0) := to_unsigned(integer(ceil(HOLD_PERIOD/CLKIN_PERIOD)), numbits);
         variable counter : unsigned(numbits-1 downto 0) := (others => '0');
      begin
         if RST_IN = '1' then
            temp_rst <= (others => '1');
            counter := (others => '0');
         elsif rising_edge(CLK) then
            if counter = all_ones then
               temp_rst(3 downto 0) <= RST_IN & temp_rst(3 downto 1);
            else
               temp_rst(0) <= '1';
               counter := counter + 1;
            end if;
         end if;
      end process;
   end generate;
end RTL;
