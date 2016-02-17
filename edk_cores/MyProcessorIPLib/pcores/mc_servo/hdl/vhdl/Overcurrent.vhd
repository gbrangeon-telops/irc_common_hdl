-------------------------------------------------------------------------------
--
-- Title       : Overcurrent
-- Design      : MC_Servo
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : Overcurrent.vhd
-- Generated   : Thu Jun 22 15:42:36 2006
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-- This system verifies if there is an overcurrent when the current in the both
-- heating loop is measured. If an error occurs, the Servo loop is blocked until 
-- a manual reset.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity Overcurrent is
	generic(
		I1_max : std_logic_vector(15 downto 0) := x"FFFF";	-- max value for the zone 1 current
		I2_max : std_logic_vector(15 downto 0) := x"FFFF"	-- max value for the zone 2 current
		);
	port(
		CLK : in std_logic;
		RST : in std_logic;
		Error_1 : out STD_LOGIC;
		Error_2 : out STD_LOGIC;
		ADR : in STD_LOGIC_VECTOR(3 downto 0);	-- Address of the mesaure (multiplexer channel)
		DAT : in STD_LOGIC_VECTOR(15 downto 0)
		);
end Overcurrent;


architecture RTL of Overcurrent is 
	
	signal rst_sync   : std_logic; 		-- synchronised reset
	
begin
	
	process(CLK)
		
		variable I1_meas : std_logic_vector(15 downto 0); -- Zone 1 current measure
		variable I2_meas : std_logic_vector(15 downto 0); -- Zone 2 current measure		
	begin  
		if rising_edge(CLK) then
			if rst_sync = '1' then
				Error_1 <= '0';
				Error_2 <= '0';	
				I1_meas := x"0000";
				I2_meas := x"0000";
			else
				if ADR <= x"C" then	-- Zone 1 current is the 13th channel of the multiplexer
					I1_meas := DAT;
					If I1_meas > I1_max then
						Error_1 <= '1';
					end if;	
				end if;
				if ADR <= x"D" then -- Zone 2 current is the 14th channel of the multiplexer
					I2_meas := DAT;
					If I2_meas > I2_max then
						Error_2 <= '1';
					end if;	
				end if;
			end if;
		end if;	
	end process;
	
	-- Potentially asynchronous reset local double buffering
	rst_dbuf : process(CLK)
		variable rst_hist : std_logic_vector(1 downto 0);
	begin
		if (CLK'event and CLK = '1') then
			rst_hist(1) := rst_hist(0);
			rst_hist(0) := To_X01(RST);
			rst_sync <= rst_hist(1);
		end if;
	end process rst_dbuf;
	
end RTL;
