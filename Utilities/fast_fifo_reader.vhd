---------------------------------------------------------------------------------------------------
--
-- Title       : fast_fifo_reader
-- Design      : Global_SIM
-- Author      : telops
-- Company     : telops
--
---------------------------------------------------------------------------------------------------
--
-- File        : fast_fifo_reader.vhd
-- Generated   : Fri Oct  8 11:57:46 2004
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
---------------------------------------------------------------------------------------------------
--
-- Description : 	This module modifies the normal behavior of a fifo. It makes it so as soon as data
--						is present in the fifo this data is presented at the output port. The user interface
--						does not have a rd_en signal anymore, instead the signal is now SHIFT. When SHIFT is
--						asserted, the next available data is presented on the output port. If no new data is
--						available, there is no error. New data will simply be presented on the output port as
--						soon as it becomes ready.
--
---------------------------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {fast_fifo_reader} architecture {RTL}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity fast_fifo_reader is
	port(
		RESET 	: in 	STD_LOGIC;
		F_RD_ACK : in 	STD_LOGIC;	-- Connect on fifo "rd_ack" signal
		SHIFT 	: in 	STD_LOGIC; 	-- New user interface signal, see description above.
		F_RD_EN 	: out STD_LOGIC;	-- Connect on fifo "rd_en" signal	
		EMPTY_IN : in	std_logic;	-- Empty signal from fifo
		EMPTY_OUT: out	std_logic;	-- Modified (corrected) empty signal
		CLK		: in 	std_logic
		);
end fast_fifo_reader;

--}} End of automatically maintained section

architecture RTL of fast_fifo_reader is 
signal Need_New_Data : std_logic;
signal EMPTY_OUT_reg : std_logic;
begin			
	F_RD_EN <= (SHIFT or Need_New_Data) and (not(F_RD_ACK and not SHIFT));
	EMPTY_OUT <= '1' when (SHIFT = '1' and EMPTY_IN = '1') else EMPTY_OUT_reg;
	
	-- Need_New_Data SR latch (SET has priority)
	process (RESET, CLK)
	begin			
		if rising_edge(CLK) then
			if RESET = '1' then
				Need_New_Data <= '1'; 
				EMPTY_OUT_reg <= '1';	
			else
				if SHIFT = '1' then--and F_EMPTY = '1' then -- SET: Need new data as soon as fifo is non empty again
					Need_New_Data <= '1';
				elsif F_RD_ACK = '1' then -- RESET: Fifo now has data, can now process new data request
					Need_New_Data <= '0';	
				end if;
				
				--if F_RD_ACK = '1' and EMPTY_IN = '0' then
				if F_RD_ACK = '1' then
					EMPTY_OUT_reg <= '0';	
				--elsif F_RD_ACK = '1' and EMPTY_IN = '1' then
				elsif SHIFT = '1' and EMPTY_IN = '1' then
					EMPTY_OUT_reg <= '1';						
				end if;
				
			end if;
		end if;
	end process;  
	
end RTL;
