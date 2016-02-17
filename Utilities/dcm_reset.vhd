---------------------------------------------------------------------------------------------------
--
-- Title       : dcm_reset
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- SVN modified fields:
-- $Revision$
-- $Author$
-- $LastChangedDate$
---------------------------------------------------------------------------------------------------
--
-- Description : Use this component to drive each DCM reset (it ensures that the DCM
--               gets reset properly). Use CLK_IN of the DCM as the CLK source for this
--               component.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity dcm_reset is
   generic ( 
      RESET200ms : boolean := false;   -- generate a 200 ms reset if TRUE (see Virtex-4 FPGA Data Sheet: DC and Switching Characteristics v3.7)
      CLKIN_PERIOD : real := 10.0      -- nanoseconds
      );
   port(
      RST_IN   : in STD_LOGIC;            -- The reset that would normally reset the DCM if you didn't use this component.
      DCM_RST  : out STD_LOGIC := '1';    -- The signal that you should connect to the DCM reset.
      CLK      : in STD_LOGIC             -- The clock signal that goes IN the DCM.
      );
end dcm_reset;

architecture RTL of dcm_reset is
   signal temp_rst : std_logic_vector(3 downto 0) := (others => '1');       
begin                    
   
   DCM_RST <= temp_rst(0);
   
   RST200ms_FALSE : if RESET200ms = FALSE generate
      process(CLK, RST_IN)
      begin
         if RST_IN = '1' then
            temp_rst <= (others => '1');
         elsif rising_edge(CLK) then
            temp_rst(3 downto 0) <= RST_IN & temp_rst(3 downto 1);
         end if;
      end process;
   end generate;
   
   RST200ms_TRUE : if RESET200ms = true generate
      process(CLK, RST_IN)
         constant reset_period_ns : real := 200.0e6;
         constant numbits : integer := integer(ceil(log(reset_period_ns/CLKIN_PERIOD)/MATH_LOG_OF_2));
         constant all_ones : unsigned(numbits-1 downto 0) := (others => '1');
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
