---------------------------------------------------------------------------------------------------
--
-- Title       : double_sync
-- Design      : VP7
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
--------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- pragma translate_off
library unisim;
-- pragma translate_on

entity double_sync is
   generic(
      INIT_VALUE : bit := '0'
   );
	port(
		D : in STD_LOGIC;
		Q : out STD_LOGIC := '0';
		RESET : in STD_LOGIC;
		CLK : in STD_LOGIC
		);
end double_sync;

architecture RTL of double_sync is
	signal temp : std_logic := '0';
	component fd
		generic ( INIT : bit := '0' );
		port (
			Q : out std_ulogic;
			C : in std_ulogic;
			D : in std_ulogic
			);
	end component;	 
	-- pragma translate_off
	for all: fd use entity unisim.fd;
	-- pragma translate_on
	
   attribute ASYNC_REG : string;
   attribute ASYNC_REG of flop1: label is "TRUE";	
   attribute ASYNC_REG of flop2: label is "TRUE";
   
begin
	
	flop1: FD generic map(INIT => INIT_VALUE) port map (D => D, C => CLK, Q => temp);
	flop2: FD generic map(INIT => INIT_VALUE) port map (D => temp, C => CLK, Q => Q); 
	
end RTL;
