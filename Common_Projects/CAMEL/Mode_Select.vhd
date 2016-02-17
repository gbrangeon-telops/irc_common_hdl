---------------------------------------------------------------------------------------------------
--
-- Title       : Mode_Select
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : telops
--
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library Common_HDL;

entity Mode_Select is
	port(
		CLK 		: in 	STD_LOGIC;
		SEL 		: in 	STD_LOGIC;
		MODE1_IN	: in 	STD_LOGIC_VECTOR(2 downto 0);
		MODE0_IN : in 	STD_LOGIC_VECTOR(2 downto 0);
		MODE 		: out STD_LOGIC_VECTOR(2 downto 0)
		);
end Mode_Select;

architecture RTL of Mode_Select is
	signal MODE0 : std_logic_vector(2 downto 0);
	signal MODE1 : std_logic_vector(2 downto 0);	
begin		  
	
	sync_MODE0 : entity double_sync_vector
	port map( D => MODE0_IN,
		Q => MODE0,
		CLK => CLK);
	
	sync_MODE1 : entity double_sync_vector
	port map( D => MODE1_IN,
		Q => MODE1,
		CLK => CLK); 		
	
	MODE <= MODE0 when SEL = '0' else MODE1;
	
end RTL;
