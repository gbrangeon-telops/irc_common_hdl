--******************************************************************************
-- Destination: FPGA XC2S200 FBGA456
--				
--
--	File: Clk_Divider.vhd
-- Hierarchy: Sub-module file
-- Use: Clock Divider
--	Project: General Purpose module
--	By: Found on internet
-- Date: 11th March 2003	  
--
--******************************************************************************
--Description
--******************************************************************************
--	This Entity divides the "Clock" input by an Odd or Even factor (specified as
-- the generic input "Factor").
--
-- When more than one entity is used within the same code, use the Reset signal
-- to synchronize the various clocks.
--******************************************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clk_Divider is
	Generic(	Factor:		integer := 2);			-- Division Factor (Default: 2)
	Port ( 	Clock: 		in std_logic;			-- Input Clock
		Reset:		in std_logic;			-- Resets the counters to 0 (Active Low)
		Clk_div:		out std_logic);		-- Divided Clock
end Clk_Divider;

architecture RTU of Clk_Divider is
	
	signal counter : integer range 0 to Factor-1;
	signal en_tff1: std_logic;
	signal en_tff2: std_logic;
	signal div1: std_logic;
	signal div2: std_logic;
	
begin
	
	gOne: if (Factor=1) generate -- pass clock through, gated low by reset 
		Clk_div <= Clock when reset = '0' else '0'; 
	end generate;
	
	gTwo: if (Factor=2) generate -- generate a T Flip-Flop 
		pTwo: process(Clock)
		begin
			if rising_edge(Clock) then 
				if reset = '1' then 
					div1 <= '0'; 
				else
					div1 <= not(div1); 
				end if; 						
			end if;
		end process;
		Clk_div <= div1; 
		
	end generate;
	
	-- Check if N is odd and greater than 2
	gOdd: if (((((Factor/2)*2)) = (Factor-1)) and (Factor>2)) generate 
		
		pOdd: process(Clock)
		begin 	
			if rising_edge(Clock) then 
				if (reset = '1') then 
					counter <= 0; 
				else
					if (counter = (Factor-1)) then 
						counter <= 0; 
					else 
						counter <= counter + 1; 
					end if; 
				end if;
			end if;
		end process;
		
		en_tff1 <= '1' when counter = 0 else '0';
		en_tff2 <= '1' when counter = (((Factor-1)/2)+1) else '0';
		
		pOddDiv1: process(Clock)
		begin 	 
			if rising_edge(Clock) then 
				if (reset = '1') then 
					div1 <= '1'; 
				else
					if (en_tff1 = '1') then 
						div1 <= not(div1); 
					end if; 
				end if; 						
			end if;
		end process;
		
		pOddDiv2: process(Clock)
		begin 	
			if falling_edge(Clock) then 
				if (reset = '1') then 
					div2 <= '1'; 
				else
					if (en_tff2 = '1') then 
						div2 <= not(div2); 
					end if; 
				end if;
			end if;
		end process;
		
		Clk_div <= div1 xor div2;
		
	end generate;
	
	-- Check if N is even and greater than 2 
	gEven: if (((((Factor/2)*2)) = Factor) and (Factor>2)) generate
		
		pEvenDiv: process(Clock)
		begin 	 
			if rising_edge(Clock) then 
				if (reset = '1') then 
					counter <= 0; 
				else
					if (counter = (Factor-1)) then 
						counter <= 0; 
					else 
						counter <= counter + 1; 
					end if; 
				end if; 						
			end if;
		end process;
		
		en_tff1 <= '1' when ( (counter = 0) or (counter = (Factor/2)) ) else '0';
		
		pEvenDiv1: process(Clock)
		begin 	 
			if rising_edge(Clock) then 
				if (Reset = '1') then 
					div1 <= '1'; 
				else
					if (en_tff1 = '1') then 
						div1 <= not(div1); 
					end if; 
				end if; 						
			end if;
		end process;
		Clk_div <= div1;
		
	end generate;
	
end RTU;

