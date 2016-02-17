---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: spi_slave.vhd
--  Hierarchy: Sub-module file
--  Use: SSI / SPI slave serial interface
--	By: Olivier Bourgois
--
--  Revision history:  (use SVN for exact code history)
--    OBO : Nov 26, 2006 - original implementation
--
--  References:
--    SPI and Microwire protocols
--
--  Notes:
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity spi_slave is
generic(
    REG_WIDTH  : integer := 24);
port(
    CLK        : in    std_logic;
    RST        : in    std_logic;
	DOUT       : in    std_logic_vector(REG_WIDTH-1 downto 0);
	DIN        : out   std_logic_vector(REG_WIDTH-1 downto 0);
    STB        : out   std_logic;
	SPI_SCK    : in    std_logic;
	SPI_MOSI   : in    std_logic;
	SPI_MISO   : out   std_logic;
	SPI_SSn    : in    std_logic);
end entity spi_slave;

architecture rtl of spi_slave is

signal spi_mosi_q : std_logic;
signal spi_sck_q : std_logic;
signal spi_ssn_q : std_logic;
signal sck_rise : std_logic;
signal sck_fall : std_logic;
signal rx_reg : std_logic_vector(REG_WIDTH-1 downto 0);
signal tx_reg : std_logic_vector(REG_WIDTH-1 downto 0);

type spi_state_t is (IDLE, XMIT);
signal spi_state : spi_state_t;

begin
    
-- map tx_reg high bit to MISO
SPI_MISO <= tx_reg(REG_WIDTH-1);

-- map rx_reg to DIN;
DIN <= rx_reg;
    
-- Double buffer asynchronous inputs
input_dbuf : process(CLK)
variable spi_mosi_hist : std_logic_vector(1 downto 0);
variable spi_sck_hist : std_logic_vector(1 downto 0);
variable spi_ssn_hist : std_logic_vector(1 downto 0);
begin
    if (CLK'event and CLK = '1') then
        spi_mosi_hist(1) := spi_mosi_hist(0);
        spi_mosi_hist(0) := To_X01(SPI_MOSI);
        spi_mosi_q <= spi_mosi_hist(1);
        spi_sck_hist(1) := spi_sck_hist(0);
        spi_sck_hist(0) := To_X01(SPI_SCK);
        spi_sck_q <= spi_sck_hist(1);
        spi_ssn_hist(1) := spi_ssn_hist(0);
        spi_ssn_hist(0) := To_X01(SPI_SSn);
        spi_ssn_q <= spi_ssn_hist(1);
    end if;
end process input_dbuf;

-- SPI rising clock detection
spi_clock_rise : process(CLK)
variable sck_hist : std_logic_vector(1 downto 0);
begin
    if (CLK'event and CLK = '1') then
        sck_hist(1) := sck_hist(0);
        sck_hist(0) := spi_sck_q;
        case sck_hist is
            when "01" =>
                sck_rise <= '1';
            when "10" =>
                sck_fall <= '1';
            when others =>
                sck_rise <= '0';
                sck_fall <= '0';
        end case;
    end if;
end process spi_clock_rise;

-- main state machine
spi_slave_sm : process(CLK)
begin
    if (CLK'event and CLK = '1') then
        if (RST = '1') then
            spi_state <= IDLE;
        else
            case spi_state is
                when IDLE =>
                    STB <= '0';
                    if spi_ssn_q = '0' then
                        spi_state <= XMIT;
                        tx_reg <= DOUT;
                    end if;
                when XMIT =>
                    if sck_rise = '1' then
                        rx_reg <= rx_reg(REG_WIDTH-2 downto 0) & spi_mosi_q;    
                    end if;
                    if sck_fall = '1' then
                        tx_reg <= tx_reg(REG_WIDTH-2 downto 0) & '0';
                    end if;
                    if spi_ssn_q = '1' then
                        spi_state <= IDLE;
                        STB <= '1';
                    end if;
            end case;
        end if;
    end if;
end process spi_slave_sm;

end rtl;
