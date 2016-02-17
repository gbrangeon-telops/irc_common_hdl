-------------------------------------------------------------------------------
--
-- Title       : edk_ibufgds
-- Author      : Olivier Bourgois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
library ieee;
-- translate_off
library unisim;
-- translate_on

use ieee.std_logic_1164.all;

entity edk_ibufgds is
   port (
      I : in std_ulogic;
      IB : in std_ulogic;
      O : out std_ulogic);
end entity edk_ibufgds;

architecture wrap of edk_ibufgds is
   
   component IBUFGDS
      -- translate_off
      generic(
         CAPACITANCE : STRING := "DONT_CARE";
         DIFF_TERM : BOOLEAN := FALSE;
         IBUF_DELAY_VALUE : STRING := "0";
         IOSTANDARD : STRING := "DEFAULT"
         );
      -- translate_on
      port (
         I : in std_ulogic;
         IB : in std_ulogic;
         O : out std_ulogic
         );
   end component;
   
begin
   
   inst_ibufgds : ibufgds
   port map(
      I => I,
      IB => IB,
      O => O);
   
end wrap;
