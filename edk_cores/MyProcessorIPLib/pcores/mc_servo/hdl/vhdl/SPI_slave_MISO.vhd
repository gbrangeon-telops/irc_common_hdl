-------------------------------------------------------------------------------
--
-- Title       : SPI_receiver_MISO
-- Design      : PIC_interface
-- Author      : Leoïza Noblesse
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : SPI_slave_MISO.vhd
-- Generated   : Thu Jun  1 12:04:59 2006
-- From        : interface description file
-- By          : Leoïza Noblesse
-- Revised by  : Hugues Dombrowski (august 07)
--
-------------------------------------------------------------------------------
--
-- Description :
-- This is a SPI slave whitch receives a data word and send it 
-- on SDI line to a SPI master in 2 sequences of 8 bits (MSB first). The
-- SPI slave sends each bit on rising edge of SPI clock.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL;

entity SPI_slave_MISO is
	port(
		SCK : in std_logic;
		RST : in std_logic;
		CLK : in std_logic;
		CS_N : in std_logic;
		DATA : in std_logic_vector(15 downto 0);
		SDI : out std_logic
		);
end SPI_slave_MISO;



architecture rtl of SPI_slave_MISO is
	
	constant nb_bits : integer := 16;
	
	signal cpt : integer := nb_bits;	-- counts the bits of a word
	signal sck_old : std_logic;
	signal sck_rising : std_logic;
	signal sck_falling : std_logic;	
	signal latch_data : std_logic;
	
	signal rst_sync   : std_logic; 		-- synchronised reset
	
begin
	
	sck_rising <= SCK and not sck_old; 	-- pulse generated on each rising edge
	sck_falling <= not SCK and sck_old;
	-- each bit is sent on SDI line on rising edge if SCK
	-- verify the compatibility with the SPi master
	-- in PIC18F8722, the both case ciuld be set.
	-- cf PIC18F8722 datasheet page 210
	
	
	process (CLK)
		
	variable  data_reg : std_logic_vector(15 downto 0);	
	-- tempory register to store data. The stored value is sent on SDI line
	begin
		if rising_edge(CLK) then
			if rst_sync = '1' then 
				cpt <= nb_bits-1;
				SDI <= '0';		
				latch_data <= '0';
			else 
				sck_old <= SCK;	 				
				if (CS_N = '0' and latch_data = '0' and sck_falling = '1') then						 
					latch_data <= '1';
					if cpt = nb_bits -1 then 
						data_reg := DATA;		--copy data on first falling edge					
					end if ;						   
				end if;				
				
				if CS_N = '0' and sck_rising = '1' then
					if cpt >= 0 then
						SDI <= data_reg(cpt);
						cpt <= cpt-1;
					end if;
				end if;	 
				
				if (CS_N = '1' and cpt < 0) then
					cpt <= nb_bits-1;
					latch_data <= '0';
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
