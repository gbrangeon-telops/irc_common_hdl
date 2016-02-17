-------------------------------------------------------------------------------
--
-- Title       : PPC405
-- Design      : uc2
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\UltraController-II\Virtex-4\PPC405_ADV.vhd
-- Generated   : Tue Dec 11 16:58:01 2007
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PPC405_ADV is
	 port(
		 JTGC405TCK : in std_logic;
		 JTGC405TMS : in std_logic;
		 JTGC405TDI : in std_logic;
		 C405JTGTDO : out std_logic;
		 C405JTGTDOEN : out STD_LOGIC
	     );
end PPC405_ADV;

--}} End of automatically maintained section

architecture blackbox of PPC405_ADV is
begin

	 -- enter your statements here --

end blackbox;
