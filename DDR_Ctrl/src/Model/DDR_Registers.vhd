---------------------------------------------------------------------------------------------------
--
-- Title       : DDR_Registers
-- Design      : VP30
-- Author      : Patrick
-- Company     : Telops
--
---------------------------------------------------------------------------------------------------
--
-- File        : d:\Telops\CAMEL\DPB\VP30\src\DDR_Registers.vhd
-- Generated   : Sun Apr 25 19:42:23 2004
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
--{entity {DDR_Registers} architecture {DDR_Registers}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;



entity DDR_Registers is
	port(
		CKE : in std_logic_vector(1 downto 0);
		S_N : in std_logic_vector(1 downto 0);
		RAS_N : in STD_LOGIC;
		WE_N : in STD_LOGIC;
		CAS_N : in STD_LOGIC;
		A : in STD_LOGIC_VECTOR(12 downto 0);
		BA : in STD_LOGIC_VECTOR(1 downto 0);
		
		CKEi : out std_logic_vector(1 downto 0);
		Si_N : out std_logic_vector(1 downto 0);
		RASi_N : out STD_LOGIC;
		WEi_N : out STD_LOGIC;
		CASi_N : out STD_LOGIC;
		Ai : out STD_LOGIC_VECTOR(12 downto 0);
		BAi : out STD_LOGIC_VECTOR(1 downto 0);
		
		RESET_N : in STD_LOGIC;
		CLK : in std_logic;
		CLK_N : in std_logic
		);
end DDR_Registers;

--}} End of automatically maintained section

architecture DDR_Registers of DDR_Registers is
begin	
	
	process (CLK, RESET_N)
	begin				
		if RESET_N = '0' then
			CKEi <= (others => '0'); 
			Si_N <= (others => '1'); 
			RASi_N <= '1';								 
			WEi_N <= '1'; 
			CASi_N <= '1';
			Ai <= (others => '0'); 
			BAi <= (others => '0');
		elsif rising_edge(CLK) then
			CKEi <= CKE after 1000 ps; 
			Si_N <= S_N after 1000 ps; 
			RASi_N <= RAS_N after 1000 ps;  				 
			WEi_N <= WE_N after 1000 ps; 
			CASi_N <= CAS_N after 1000 ps; 
			Ai <= A after 1000 ps; 
			BAi <= BA after 1000 ps; 
		end if;
	end process;
	
	-- enter your statements here --
	
end DDR_Registers;
