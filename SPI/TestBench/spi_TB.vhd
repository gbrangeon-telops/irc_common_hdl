-------------------------------------------------------------------------------
--
-- Title       : Test Bench for spi_slave
-- Design      : FIR-00173
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\spi_slave_TB.vhd
-- Generated   : 2006-10-26, 15:20
-- From        : d:\telops\Common_HDL\SPI\spi_slave.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for spi_slave_tb
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
library Common_HDL;

	-- Add your library and packages declaration here ...

entity spi_tb is
end spi_tb;

architecture TB_ARCHITECTURE of spi_tb is
	-- Component declaration of the tested unit
	component spi_slave
		generic(
		REG_WIDTH : INTEGER := 24 );
	port(
		CLK : in std_logic;
		RST : in std_logic;
		DOUT : in std_logic_vector((REG_WIDTH-1) downto 0);
		DIN : out std_logic_vector((REG_WIDTH-1) downto 0);
		STB : out std_logic;
		SPI_SCK : in std_logic;
		SPI_MOSI : in std_logic;
		SPI_MISO : out std_logic;
		SPI_SSn : in std_logic );
	end component;
    
    component spi_master
		generic(
		SLAVES : NATURAL := 3 );
	port(
		CLK : in std_logic;
		ARST : in std_logic;
		SCL2XSRC : in std_logic;
		SPI_DIN : in std_logic_vector(23 downto 0);
		SPI_DOUT : out std_logic_vector(23 downto 0);
		SPI_STB : in std_logic;
		SPI_CPOL : in std_logic;
		SPI_CPHA : in std_logic;
		SPI_NBITS : in std_logic_vector(4 downto 0);
		SPI_EN_SSn : in std_logic_vector((SLAVES-1) downto 0);
		SPI_DNE : out std_logic;
		SPI_SCK : out std_logic;
		SPI_MOSI : out std_logic;
		SPI_MISO : in std_logic;
		SPI_SSn : out std_logic_vector((SLAVES-1) downto 0) );
	end component;
    
    -- Constants
    constant REG_WIDTH : natural := 24;
    constant SPI_NBITS : std_logic_vector(4 downto 0) := conv_std_logic_vector(REG_WIDTH,5);
    signal SPI_CPOL : std_logic := '0';
	signal SPI_CPHA : std_logic := '0';
    
	-- stimuli
    signal CLK : std_logic;
	signal ARST : std_logic;
	signal SCL2XSRC : std_logic;
	signal SPI_DIN : std_logic_vector(23 downto 0);
	signal SPI_STB : std_logic;
	signal SPI_DOUT : std_logic_vector(23 downto 0);
	signal SPI_DNE : std_logic;
    
    -- observed
	signal DOUT : std_logic_vector((REG_WIDTH-1) downto 0);
	signal SPI_SCK : std_logic;
	signal SPI_MOSI : std_logic;
	signal SPI_SSn : std_logic;
    signal SPI_SSn_vect : std_logic_vector(0 downto 0); -- yes this is weird but master can configure num slaves
    signal SPI_EN_SSn_vect : std_logic_vector(0 downto 0);
    signal DIN : std_logic_vector((REG_WIDTH-1) downto 0);
	signal STB : std_logic;
	signal SPI_MISO : std_logic;

begin
    
    -- signal mappings
    SPI_SSn <= SPI_SSn_vect(0);
    SPI_EN_SSn_vect(0) <= '0';
    
    -- register and loop back slave output to input
    loopback : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (STB = '1') then
                DOUT <= DIN;
            end if;
        end if;
    end process loopback;  
    
	-- Unit Under Test port map
	UUT : spi_slave
		generic map (
			REG_WIDTH => REG_WIDTH)

		port map (
			CLK => CLK,
			RST => ARST,
			DOUT => DOUT,
			DIN => DIN,
			STB => STB,
			SPI_SCK => SPI_SCK,
			SPI_MOSI => SPI_MOSI,
			SPI_MISO => SPI_MISO,
			SPI_SSn => SPI_SSn);
    
    -- instantiate a master to talk to UUT
	inst_spi_master : spi_master
		generic map (
			SLAVES => 1)

		port map (
			CLK => CLK,
			ARST => ARST,
			SCL2XSRC => SCL2XSRC,
			SPI_DIN => SPI_DIN,
			SPI_DOUT => SPI_DOUT,
			SPI_STB => SPI_STB,
			SPI_CPOL => SPI_CPOL,
			SPI_CPHA => SPI_CPHA,
			SPI_NBITS => SPI_NBITS,
			SPI_EN_SSn => SPI_EN_SSn_vect,
			SPI_DNE => SPI_DNE,
			SPI_SCK => SPI_SCK,
			SPI_MOSI => SPI_MOSI,
			SPI_MISO => SPI_MISO,
			SPI_SSn => SPI_SSn_vect);
        
   -- generate a clock source
   clock : process
   begin
      CLK <= '0';
      loop
         wait for 5 ns;
         CLK <= not CLK;
      end loop;
   end process clock;
   
   -- divide it for SCL2XSRC
   scl_gen : process(CLK)
   variable counter : std_logic_vector(3 downto 0) := x"0";
   begin
      if (CLK'event and CLK = '1') then
          SCL2XSRC <= counter(3);
          counter := counter + 1;
      end if;
   end process scl_gen;
   
   -- pulse the reset at start of simulation for 10 clock cycles
   reset : process(CLK)
   variable cnt : integer := 10;
   begin
      if (CLK'event and CLK = '1') then
         if cnt = 0 then
            ARST <= '0';
         else
            cnt := cnt -1;
            ARST <= '1';
         end if;
      end if;
   end process reset;
   
    -- generate a stimulus
    stimulus : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (ARST = '1') then
                SPI_DIN <= (others => '0');
            else
                SPI_STB <= '1';
                if SPI_DNE = '1' then
                    SPI_DIN <= SPI_DIN + 1;
                end if;
            end if;
        end if;
    end process stimulus;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_spi of spi_tb is
	for TB_ARCHITECTURE
		for UUT : spi_slave
			use entity work.spi_slave(rtl);
		end for;
	end for;
end TESTBENCH_FOR_spi;

