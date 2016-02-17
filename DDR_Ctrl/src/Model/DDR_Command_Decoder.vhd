---------------------------------------------------------------------------------------------------
--
-- Title       : DDR_Command_Decoder
-- Design      : Global_SIM
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- File        : D:\Telops\CAMEL\VP30\src\DDR_Command_Decoder.vhd
-- Generated   : Fri May  7 09:30:06 2004
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
--{entity {DDR_Command_Decoder} architecture {DDR_Command_Decoder}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.DDR_Define.all;


entity DDR_Command_Decoder is
	port(
		CAS_N : in std_logic;
		RAS_N : in std_logic;
		WE_N : in std_logic;
		S_N : in std_logic_vector(1 downto 0);
		BA : in std_logic_vector(1 downto 0);
		bank0rank0 : out t_DIMM_CMD;
		bank0rank1 : out t_DIMM_CMD;
		bank1rank0 : out t_DIMM_CMD;
		bank1rank1 : out t_DIMM_CMD; 
		bank2rank0 : out t_DIMM_CMD;
		bank2rank1 : out t_DIMM_CMD;
		bank3rank0 : out t_DIMM_CMD;
		bank3rank1 : out t_DIMM_CMD
		);
end DDR_Command_Decoder;

--}} End of automatically maintained section

architecture DDR_Command_Decoder of DDR_Command_Decoder is
	signal cmd : std_logic_vector(2 downto 0);
begin
	cmd <= RAS_N & CAS_N & WE_N;
	
	bank0rank0 <= NOP when BA /= "00" or  S_N(0) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;
	
	bank0rank1 <= NOP when BA /= "00" or  S_N(1) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;
	
	bank1rank0 <= NOP when BA /= "01" or  S_N(0) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;
	
	bank1rank1 <= NOP when BA /= "01" or  S_N(1) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;	
	
	bank2rank0 <= NOP when BA /= "10" or  S_N(0) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;
	
	bank2rank1 <= NOP when BA /= "10" or  S_N(1) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;
	
	bank3rank0 <= NOP when BA /= "11" or  S_N(0) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;
	
	bank3rank1 <= NOP when BA /= "11" or  S_N(1) /= '0' else
	NOP when cmd = "111" else
	ACT when cmd = "011" else
	RD when cmd = "101" else
	WR when cmd = "100" else
	B_END when cmd = "110" else
	PRECH when cmd = "010" else
	RFRSH when cmd = "001" else
	LOAD when cmd = "000" else
	UNKNOWN;
	
end DDR_Command_Decoder;
