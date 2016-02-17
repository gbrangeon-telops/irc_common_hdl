--******************************************************************************
--	Destination: General VHDL (Not specific to a FPGA family)
--				
--
--	File: Pulse_gen.vhd
--	Hierarchy: Sub-module file
--	Use: Generates a pulse after xx delay for yy pulse width
--	Project: General Purpose module
--	By: Jean-Pierre Allard
--	Date: 6 November 2003	  
--
--******************************************************************************
-- Description
--******************************************************************************
-- This module generates a pulse after a rising edge on the Trigger input. The
-- delay to start the pulse after the Trigger and the pulse width are configurable
-- and expressed in term of Clock cycles.
--
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Pulse_gen is
	Generic (	
		Delay:		integer := 3;		-- Delay before pulse generation
		Duration:	integer := 2;		-- Pulse width
		Polarity:	boolean := true);	-- Pulse Polarity  
	Port (		
		Clock:		in STD_LOGIC;		-- Clock signal
		Reset:		in STD_LOGIC;		-- Resets all counters (Active High)
		Trigger:		in STD_LOGIC;		-- Reference signal (input)
		Pulse:		out STD_LOGIC);		-- Generated pulse (output)
end Pulse_gen;

architecture RTU of Pulse_gen is
	
	signal Counter: 			integer range 0 to (Delay + Duration) := 0;	-- Counts delay and pulse width
	signal Start_Count :		std_logic := '0';              				-- Start counter after trigger
	signal Stop_Count : 		std_logic := '0';              				-- Stop counter after delay + duration
	
	signal Pulse_Polarity:	std_logic := '1';								-- Logic state of the pulse
	
begin
	
	ClockEnable : process(Clock)   -- Enable the clock counter
		variable previous_Trig : std_logic;
	begin
		if(rising_edge(Clock)) then                
			if (Reset = '1') then
				Start_Count <= '0';
				previous_Trig := '0';
			else
				if Stop_Count = '1' then
					Start_Count <= '0';	
				elsif (Trigger='1' and previous_Trig='0') then -- rising edge on Trigger
					Start_Count <= '1';                    
				end if;
				previous_Trig := Trigger;
			end if;
		end if;
	end process;
	
	CounterProcess : process(Clock)   -- Counter
	begin
		if(falling_edge(Clock)) then                  -- on clk rising edge
			if (Reset = '1') then
				Counter <= 0;					                 -- reset counter
			else
				if Start_Count = '0' then
					Counter <= 0;	
				elsif (Counter < (Delay + Duration)) then
					Counter <= Counter + 1;                     -- count
				end if;
			end if;
		end if;
	end process;
	
	Stop_Counter : process(Clock)
	begin	
		if (rising_edge(Clock)) then
			if (Reset = '1') then
				Stop_Count <= '0';
			else
				if (Counter = (Delay + Duration)) then
					Stop_Count <= '1';
				else
					Stop_Count <= '0';
				end if;
			end if;
		end if;
	end process;
	
	Pulse_Polarity <= '1' when (Polarity) else
	'0';
	
	DelayZero : if (Delay=0) generate -- Pulse synchronized with Trigger
		
		Pulse <= 	Pulse_Polarity when Start_Count = '1' and Stop_Count = '0' else
		not Pulse_Polarity; 
	end generate;
	
	DelayNonZero : if (Delay /= 0) generate -- Pulse synchronized with Clock 
		
		PulseOut : process(Clock)        -- Generate pulse
		begin
			if(rising_edge(Clock)) then                                         -- Synchronize on clk rising edge
				if Reset = '1' then
					Pulse <=	not Pulse_Polarity;
				else
					if((Counter >= Delay) and (Counter < (Delay + Duration))) then    -- Time for pulse
						Pulse <= Pulse_Polarity;                                      -- Output pulse according to polarity
					else
						Pulse <= not Pulse_Polarity;                                  -- Everywhere else
					end if;
				end if;
			end if;
		end process;
	end generate;
	
end RTU;
