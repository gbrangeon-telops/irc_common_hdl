---------------------------------------------------------------------------------------------------
--
-- Title       : PPC405
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Université Laval-Faculté des Sciences et de Génie
--
---------------------------------------------------------------------------------------------------
--
-- File        : D:\Telops\FIR-00085\VP30\src\uc2\PPC405.vhd
-- Generated   : Tue Aug 29 15:19:18 2006
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {PPC405} architecture {PPC405}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PPC405 is
	 port(
		 JTGC405TCK : in STD_LOGIC;
		 JTGC405TMS : in STD_LOGIC;
		 JTGC405TDI : in std_logic;
		 C405JTGTDO : out STD_LOGIC;
		 C405JTGTDOEN : out std_logic
	     );
end PPC405;

--}} End of automatically maintained section

architecture PPC405 of PPC405 is
begin

	 -- enter your statements here --

end PPC405;
