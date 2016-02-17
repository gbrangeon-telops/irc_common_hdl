---------------------------------------------------------------------------------------------------
--
-- Title       : dcm_reset
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- SVN modified fields:
-- $Revision: 4193 $
-- $Author: rd\pdubois $
-- $LastChangedDate: 2007-12-05 15:31:08 -0500 (mer., 05 déc. 2007) $
---------------------------------------------------------------------------------------------------
--
-- Description : Use this component to drive each DCM reset (it ensures that the DCM
--               gets reset properly). Use CLK_IN of the DCM as the CLK source for this
--               component.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity dcm_reset is
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
   
process(CLK, RST_IN)
begin
   if RST_IN = '1' then
      temp_rst <= (others => '1');
   elsif rising_edge(CLK) then
      temp_rst(3 downto 0) <= RST_IN & temp_rst(3 downto 1);
   end if;
end process;
   
end RTL;
