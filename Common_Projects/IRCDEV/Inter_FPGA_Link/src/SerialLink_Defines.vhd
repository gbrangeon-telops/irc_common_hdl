---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--
-- Title       : IRC_Define
-- Author      : Khalid Bensadek
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package SerialLink_Defines is

constant CLOSE_ALLDVAL : std_logic_vector(5 downto 0):="000000";
constant SLINK_CH1   : std_logic_vector(5 downto 0):="000001";
constant SLINK_CH2   : std_logic_vector(5 downto 0):="000010";
constant SLINK_CH3   : std_logic_vector(5 downto 0):="000100";
constant SLINK_CH4   : std_logic_vector(5 downto 0):="001000";
constant SLINK_CH5   : std_logic_vector(5 downto 0):="010000";
constant SLINK_CH6   : std_logic_vector(5 downto 0):="100000";


end SerialLink_Defines;

package body SerialLink_Defines is
end package body SerialLink_Defines;