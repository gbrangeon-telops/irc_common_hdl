-------------------------------------------------------------------------------
--
-- Title       : sync_pulse
-- Design      : CRYOM
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : sync_pulse.vhd
-- Generated   : Wed Jan 24 18:43:53 2007
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : The purpose of this block is to detect rising of pulses
-- even if they are narrower than a clock period. 
--
--
--  Revision history:  (use SVN for exact code history)
--    BCO: Jan 18, 2007
--
--  Notes: 
--
--  $Revision$ 
--  $Author$
--  $LastChangedDate$

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity sync_pulse is
	 port(
		 Pulse : in STD_LOGIC;
		 Clk : in STD_LOGIC;
		 Pulse_out_sync : out STD_LOGIC
	     );
end sync_pulse;


architecture RTL of sync_pulse is 
signal Pulse_hold : std_logic := '0'; 
signal Pulse_hold_1p : std_logic := '0';
signal Pulse_hold_2p : std_logic := '0';
signal Pulse_hold_3p : std_logic := '0';
signal Pulse_out_sync_int : std_logic := '0';


begin
	
	Pulse_out_sync <= Pulse_out_sync_int; 
	 
	sync_pulse_process : process(Pulse, Clk)
	begin
		if (rising_edge(Pulse)) then
			Pulse_hold <= not Pulse_hold_2p;
		end if;
		if (rising_edge(Clk)) then
			Pulse_hold_1p <= Pulse_hold;
			Pulse_hold_2p <= Pulse_hold_1p;
			Pulse_hold_3p <= Pulse_hold_2p;	
			Pulse_out_sync_int <= Pulse_hold_2p xor  Pulse_hold_3p;
		end if;	
	end process;
	 
end RTL;
