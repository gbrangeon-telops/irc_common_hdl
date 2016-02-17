---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: pico_SoC.vhd
--  Hierarchy: Sub-module file
--  Use: Picoblaze System on Chip with a configurable number of slave peripheral hooks
--
--  Revision history:  (use SVN for exact code history)
--    OBO : Oct 13, 2006 - original implementation
--
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.pico_define.all;

entity pico_SoC is
    generic(
        SLAVES : natural := 1);
    port(
        CLK : in std_logic;
        RST : in std_logic;
        PICO_MISO : in pico_miso_vector_t(SLAVES-1 downto 0);
        PICO_MOSI : out pico_mosi_vector_t(SLAVES-1 downto 0));
end pico_SoC;

architecture rtl of pico_SoC is

component code_rom
    port (
        address : in std_logic_vector(9 downto 0);
        clk : in std_logic;
        instruction : out std_logic_vector(17 downto 0));
end component;

component kcpsm3
    port (
        clk : in std_logic;
        in_port : in std_logic_vector(7 downto 0);
        instruction : in std_logic_vector(17 downto 0);
        interrupt : in std_logic;
        reset : in std_logic;
        address : out std_logic_vector(9 downto 0);
        interrupt_ack : out std_logic;
        out_port : out std_logic_vector(7 downto 0);
        port_id : out std_logic_vector(7 downto 0);
        read_strobe : out std_logic;
        write_strobe : out std_logic);
end component;

-- picoblaze interfacing signals
signal address       : std_logic_vector(9 downto 0);
signal instruction   : std_logic_vector(17 downto 0);
signal port_id       : std_logic_vector(7 downto 0);
signal out_port      : std_logic_vector(7 downto 0);
signal write_strobe  : std_logic;
signal read_strobe   : std_logic;
signal interrupt_ack : std_logic;
signal in_port       : std_logic_vector(7 downto 0);
signal interrupt     : std_logic;

begin

-- configurable number of slaves port mapping trick =>

-- Slave input mux is simply an "OR" of the incoming data because un-addressed slaves drive x"00"
input_bus_mux : process(PICO_MISO)
variable in_port_temp: std_logic_vector(7 downto 0);
variable interrupt_temp : std_logic;
begin
    in_port_temp := x"00";
    interrupt_temp := '0';
    for i in SLAVES-1 downto 0 loop
        in_port_temp := in_port_temp or PICO_MISO(i).in_port;
        interrupt_temp := interrupt_temp or PICO_MISO(i).interrupt;
    end loop;
    in_port <= in_port_temp;
    interrupt <= interrupt_temp;
end process input_bus_mux;

-- Slave output muxes are simply a replication of the data since each slave has its own port_id decoder
output_bus_mux : for i in SLAVES-1 downto 0 generate
    PICO_MOSI(i).port_id <= port_id;
    PICO_MOSI(i).out_port <= out_port;
    PICO_MOSI(i).write_strobe <= write_strobe;
    PICO_MOSI(i).read_strobe <= read_strobe;
    PICO_MOSI(i).interrupt_ack <= interrupt_ack;
    PICO_MOSI(i).out_port <= out_port;    
end generate output_bus_mux;

-- instantiate the microcontroller
inst_uController : kcpsm3
    port map(
        clk => CLK,
        reset => RST,
        address => address,
        instruction => instruction,
        in_port => in_port,
        interrupt => interrupt,
        port_id => port_id,
        write_strobe => write_strobe,
        read_strobe => read_strobe,
        interrupt_ack => interrupt_ack,
        out_port => out_port);

inst_code_rom : code_rom
    port map(
       clk => CLK,
       address => address,
       instruction => instruction);
 
end rtl;
