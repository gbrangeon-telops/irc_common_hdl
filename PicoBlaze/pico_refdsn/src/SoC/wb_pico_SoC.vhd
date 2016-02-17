---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: wb_pico_SoC.vhd
--  Use: Picoblaze System on Chip with a configurable number of slave peripheral hooks
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.wb8bit_define.all;

entity wb_pico_SoC is
    generic(
        SLAVES : natural := 1);
    port(
        CLK : in std_logic;
        RST : in std_logic;
        WB_MISO_V : in wb8bit_miso_v_t(SLAVES-1 downto 0);
        WB_MOSI_V : out wb8bit_mosi_v_t(SLAVES-1 downto 0));
end wb_pico_SoC;

architecture rtl of wb_pico_SoC is

component code_rom
    port (
        address : in std_logic_vector(9 downto 0);
        clk : in std_logic;
        proc_reset : out std_logic;
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

component pico_wb_bridge is
    generic(
        SLAVES : integer);
    port(
        PORT_ID       : in std_logic_vector(7 downto 0);        -- PicoBlaze side
        OUT_PORT      : in std_logic_vector(7 downto 0);
        WRITE_STROBE  : in std_logic;
        READ_STROBE   : in std_logic;
        INTERRUPT_ACK : in std_logic;
        IN_PORT       : out std_logic_vector(7 downto 0);
        INTERRUPT     : out std_logic;
        WB_MISO_V     : in wb8bit_miso_v_t(SLAVES-1 downto 0); -- Wishbone side
        WB_MOSI_V     : out wb8bit_mosi_v_t(SLAVES-1 downto 0));
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
signal proc_reset    : std_logic;
signal jtag_reset    : std_logic;

begin

-- manage the reset signals from multiple sources
proc_reset <= jtag_reset or RST;

-- instantiate the microcontroller
inst_uController : kcpsm3
    port map(
        clk => CLK,
        reset => proc_reset,
        address => address,
        instruction => instruction,
        in_port => in_port,
        interrupt => interrupt,
        port_id => port_id,
        write_strobe => write_strobe,
        read_strobe => read_strobe,
        interrupt_ack => interrupt_ack,
        out_port => out_port);

-- instantiate the code ROM
inst_code_rom : code_rom
    port map(
       clk => CLK,
       address => address,
       proc_reset => jtag_reset,
       instruction => instruction);
              
-- instantiate the PicoBlaze to wishbone bridge
inst_wb8bit_bridge : pico_wb_bridge
    generic map(
        SLAVES => SLAVES)
    port map(
        PORT_ID => port_id, 
        OUT_PORT => out_port,
        WRITE_STROBE => write_strobe,
        READ_STROBE => read_strobe,
        INTERRUPT_ACK => interrupt_ack,
        IN_PORT => in_port,
        INTERRUPT => interrupt,
        WB_MISO_V => WB_MISO_V,
        WB_MOSI_V => WB_MOSI_V);
        
end rtl;