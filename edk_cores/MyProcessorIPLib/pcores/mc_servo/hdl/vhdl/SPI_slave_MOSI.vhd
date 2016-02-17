-------------------------------------------------------------------------------
--
-- Title       : SPI_slave_MOSI
-- Design      : PIC_interface
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : SPI_slave_MOSI.vhd
-- Generated   : Wed May 31 16:00:57 2006
-- From        : interface description file
-- By          : Loeiïza Noblesse
-- Revised by  : Hugues Dombrowski (august 07)
--
-------------------------------------------------------------------------------
--
-- Description :
-- SPI_slave_MOSI receives data byte by byte and transmit the data in a word.
-- Be carefull the PIC send data in byte but the TEMP_SET is a word.
-- The PIC should send the MSB byte then the LSB byte to set the temperature.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL;

entity SPI_slave_MOSI is
	port( 
		CLK : in std_logic;
		RST : in std_logic;
		SDO : in std_logic;
		SCK : in std_logic;
		CS_N : in std_logic;
		TEMP_SET_A : out std_logic_vector(15 downto 0);	-- Temparture setting for zone 1
		TEMP_SET_B : out std_logic_vector(15 downto 0) 	-- Temperature setting for zone 2
		);
end SPI_slave_MOSI;


architecture rtl of SPI_slave_MOSI is
	
	constant nb_bits : integer := 24;
	
	signal cpt : integer := nb_bits;	-- counts the bits of a word
	signal sck_old : std_logic;
	signal sck_rising : std_logic; 
	
	signal rst_sync   : std_logic;		-- synchronised reset
	
begin
	
	sck_rising <= SCK and not sck_old;	-- a pulse is generated on each rising 
	-- edge of SCK
	
	process (CLK)
		variable data_reg : std_logic_vector(23 downto 0);	 -- temporary
		-- register to store data on SDO line
		
	begin
		if rising_edge(CLK) then
			if rst_sync = '1' then 
				cpt <= nb_bits-1;
				data_reg := x"000000";
			else 
				sck_old <= SCK;
				if CS_N = '0'  and sck_rising = '1' then
					data_reg(cpt) := SDO;
					cpt <= cpt - 1;
				end if;
				if cpt < 0 then
					if data_reg(19 downto 16) = "0000" then
						-- only 1st DAC is selected
						TEMP_SET_A <= data_reg(15 downto 0);
					elsif data_reg(19 downto 16) = "0001" then
						-- only 2nd DAC is selected
						TEMP_SET_B <= data_reg(15 downto 0);
					elsif data_reg(19 downto 16) = "1111" then
						-- the both DACs are selected
						TEMP_SET_A <= data_reg(15 downto 0);
						TEMP_SET_B <= data_reg(15 downto 0);
					end if;
					cpt <= nb_bits-1;
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
	
end rtl;
