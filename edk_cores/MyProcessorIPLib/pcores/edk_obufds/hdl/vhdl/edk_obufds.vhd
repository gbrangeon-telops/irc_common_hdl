-------------------------------------------------------------------------------
--
-- Title       : edk_obufds
-- Author      : Olivier Bourgois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
library ieee;
-- translate_off
library unisim;
-- translate_on

use ieee.std_logic_1164.all;

entity edk_obufds is
   port (
      I : in std_ulogic;
      O : out std_ulogic;
      OB : out std_ulogic);
end entity edk_obufds;

architecture wrap of edk_obufds is
   
   component OBUFDS is
      -- translate_off
      generic(
         CAPACITANCE : STRING := "DONT_CARE";
         IOSTANDARD : STRING := "DEFAULT"
         );
      -- translate_on
      port (
         I : in std_ulogic;
         O : out std_ulogic;
         OB : out std_ulogic);
   end component;  
   
begin
   
   inst_obufds : obufds
   port map(
      I => I,
      O => O,
      OB => OB);
   
end wrap;
