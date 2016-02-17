---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: picoblaze.vhd
--  Use:  library of useful picoblaze cores and stuff
--
--  Revision history:  (use SVN for exact code history)
--    OBO : Oct 11, 2006 - original implementation
--
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package pico_define is

-- This package encapsulates the picoblaze bus into a couple of data structures
-- any unused signals will be optimized away by the synthesis tools.
type pico_mosi_t is
    record
        port_id      : std_logic_vector(7 downto 0);
        out_port     : std_logic_vector(7 downto 0);
        write_strobe : std_logic;
        read_strobe  : std_logic;
        interrupt_ack : std_logic;
    end record;
    
type pico_miso_t is
    record
        in_port   : std_logic_vector(7 downto 0);
        interrupt : std_logic;
    end record;
    
type pico_miso_vector_t is array(natural range <>) of pico_miso_t;
type pico_mosi_vector_t is array(natural range <>) of pico_mosi_t;
    
end package pico_define;

---------------------------------------------------------------------------------------------------
-- PICOBlaze Bus addressable register core
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.pico_define.all;

entity pico_reg is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
    port(
        CLK : in std_logic;
        DOUT : out std_logic_vector(7 downto 0);
        DIN  : in std_logic_vector(7 downto 0);
        PICO_MISO : out pico_miso_t;
        PICO_MOSI : in pico_mosi_t);
end pico_reg;

architecture rtl of pico_reg is

signal port_id_q : std_logic_vector(7 downto 0); -- registered version of port_id

begin

-- we must pipeline port_id to break critical timing path
pipeline : process(CLK)
begin
    if (CLK'event and CLK = '1') then
        port_id_q <= PICO_MOSI.port_id;
    end if;
end process pipeline;

reg_write : process(CLK)
begin
    if (CLK'event and CLK = '1') then
        if (port_id_q = port_id and PICO_MOSI.write_strobe = '1') then
            DOUT <= PICO_MOSI.out_port;
        end if;
    end if;
end process reg_write;

-- purely combinational read because we had to register port_id to break the critical path
reg_read : process(port_id_q, DIN)
begin
    if (port_id_q = port_id) then
        PICO_MISO.in_port <= DIN;
    else
        PICO_MISO.in_port <= x"00"; -- all in ports will be "ORed" at uC so drive low when not solicitated
    end if;
end process reg_read;

-- do not drive the interrupt pin
PICO_MISO.interrupt <= '0'; 

end rtl;

---------------------------------------------------------------------------------------------------
-- PICOBlaze interface single port 8bitx16 deep LUT based ram infered memory
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.pico_define.all;

entity pico_ram is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
    port(
        CLK : in std_logic;
        PICO_MISO : out pico_miso_t;
        PICO_MOSI : in pico_mosi_t);
end pico_ram;

architecture rtl of pico_ram is

signal we : std_logic;
signal addr : std_logic_vector(3 downto 0);
signal wr_data : std_logic_vector(7 downto 0);
signal rd_data : std_logic_vector(7 downto 0);
signal port_id_q : std_logic_vector(7 downto 0);

type ram_w8xd16_t is array (15 downto 0) of std_logic_vector (7 downto 0);
signal ram_w8xd16 : ram_w8xd16_t;

begin

-- address pipelineing
addr_pipe : process(CLK)
begin
    if (CLK'event and CLK = '1') then
         port_id_q <= PICO_MOSI.port_id; 
    end if;
end process addr_pipe;

-- data writing
data_write : process(CLK)
begin
    if (CLK'event and CLK = '1') then
        if (port_id_q(7 downto 4) = port_id(7 downto 4) and PICO_MOSI.write_strobe = '1') then
           we <= '1';
           wr_data <= PICO_MOSI.out_port;
        else
           we <= '0';
        end if;
    end if;
end process data_write;

-- data reading
data_read: process(port_id_q, rd_data)
begin
    addr <= port_id_q(3 downto 0);
    if (port_id_q(7 downto 4) = port_id(7 downto 4)) then
        PICO_MISO.in_port <= rd_data;
    else
        PICO_MISO.in_port <= x"00"; -- all in ports will be "ORed" at uC so drive low when not solicitated
    end if;
end process data_read;

-- async ram inference
async_ram_infer_proc : process (CLK)
begin
    if (CLK'event and CLK = '1') then
        if (we = '1') then
            ram_w8xd16(conv_integer(addr)) <= wr_data;  
        end if;
    end if;
end process async_ram_infer_proc;
rd_data <= ram_w8xd16(conv_integer(addr));

-- do not use interrupt line
PICO_MISO.interrupt <= '0'; 

end rtl;

---------------------------------------------------------------------------------------------------
-- Complete UART using picoblaze kcuart components
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.pico_define.all;

entity pico_uart is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
    port(
        CLK : in std_logic;
        RST : in std_logic;
        BAUD_16X : in std_logic;
        TX : out std_logic;
        RX : in std_logic;
        PICO_MISO : out pico_miso_t;
        PICO_MOSI : in pico_mosi_t);
end pico_uart;

architecture rtl of pico_uart is

component uart_rx
  port (
       clk : in std_logic;
       en_16_x_baud : in std_logic;
       read_buffer : in std_logic;
       reset_buffer : in std_logic;
       serial_in : in std_logic;
       buffer_data_present : out std_logic;
       buffer_full : out std_logic;
       buffer_half_full : out std_logic;
       data_out : out std_logic_VECTOR(7 downto 0)
  );
end component;

component uart_tx
  port (
       clk : in std_logic;
       data_in : in std_logic_vector(7 downto 0);
       en_16_x_baud : in std_logic;
       reset_buffer : in std_logic;
       write_buffer : in std_logic;
       buffer_full : out std_logic;
       buffer_half_full : out std_logic;
       serial_out : out std_logic);
end component;

signal rx_rd : std_logic;
signal tx_wr : std_logic;
signal tx_data : std_logic_vector(7 downto 0);
signal rx_flag : std_logic;
signal rx_full : std_logic;
signal rx_half : std_logic;
signal tx_full : std_logic;
signal tx_half : std_logic;
signal rx_data : std_logic_vector(7 downto 0);
signal stat_reg : std_logic_vector(7 downto 0);
signal pico_miso_vect : pico_miso_vector_t(1 downto 0);
signal port_id_q : std_logic_vector(7 downto 0);

begin

-- map bus interface (we may want to create a function for this)
PICO_MISO.in_port <= pico_miso_vect(0).in_port or pico_miso_vect(1).in_port;
PICO_MISO.interrupt <= '0';  -- for now we do not make use of interrupt functionality in this core

-- map stat_reg
stat_reg(0) <= '0';
stat_reg(1) <= rx_full;
stat_reg(2) <= tx_full;
stat_reg(3) <= '0';
stat_reg(4) <= rx_flag;
stat_reg(5) <= rx_half;
stat_reg(6) <= tx_half;
stat_reg(7) <= '0';

inst_tx : uart_tx
  port map(
       buffer_full => tx_full,
       buffer_half_full => tx_half,
       clk => CLK,
       data_in => tx_data,
       en_16_x_baud => BAUD_16X,
       reset_buffer => RST,
       serial_out => TX,
       write_buffer => tx_wr);

inst_rx : uart_rx
  port map(
       buffer_data_present => rx_flag,
       buffer_full => rx_full,
       buffer_half_full => rx_half,
       clk => CLK,
       data_out => rx_data,
       en_16_x_baud => BAUD_16X,
       read_buffer => rx_rd,
       reset_buffer => RST,
       serial_in => RX);
       
-- address pipelineing
addr_pipe : process(CLK)
begin
    if (CLK'event and CLK = '1') then
         port_id_q <= PICO_MOSI.port_id; 
    end if;
end process addr_pipe;

-- stat read
stat_read : process(port_id_q, stat_reg)
begin
    if (port_id_q = port_id(7 downto 1) & '0') then
        pico_miso_vect(0).in_port <= stat_reg;
    else
        pico_miso_vect(0).in_port <= x"00"; -- all in ports will be "ORed" at uC so drive low when not solicitated
    end if;
end process stat_read;
        
-- data write
tx_write : process(CLK)
begin
   if (CLK'event and CLK = '1') then
        tx_data <= PICO_MOSI.out_port;
        if (port_id_q = port_id(7 downto 1) & '1') and (PICO_MOSI.write_strobe = '1') then
           tx_wr <= '1';
        else
           tx_wr <= '0';
        end if;
    end if;
end process tx_write;

-- data read
rx_read : process(port_id_q, rx_data, PICO_MOSI.read_strobe)
begin
    if (port_id_q = port_id(7 downto 1) & '1') and (PICO_MOSI.read_strobe = '1') then
        pico_miso_vect(1).in_port <= rx_data;
        rx_rd <= '1';
    else
        pico_miso_vect(1).in_port <= x"00"; -- all in ports will be "ORed" at uC so drive low when not solicitated
        rx_rd <= '0';
    end if;
end process rx_read;


end rtl;

---------------------------------------------------------------------------------------------------
-- PICOBlaze interval timer
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.pico_define.all;

entity pico_timer is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
    port(
        CLK : in std_logic;
        RST : in std_logic;
        TICK : out std_logic;
        PICO_MISO : out pico_miso_t;
        PICO_MOSI : in pico_mosi_t);
end pico_timer;

architecture rtl of pico_timer is

component pico_reg
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00");
    port(
        CLK : in std_logic;
        DOUT : out std_logic_vector(7 downto 0);
        DIN  : in std_logic_vector(7 downto 0);
        PICO_MISO : out pico_miso_t;
        PICO_MOSI : in pico_mosi_t);
end component;

signal rin1 : std_logic_vector(7 downto 0);
signal rin0 : std_logic_vector(7 downto 0);
signal rout1 : std_logic_vector(7 downto 0);
signal rout0 : std_logic_vector(7 downto 0);
signal term_cnt : std_logic_vector(14 downto 0);
signal counter  : std_logic_vector(14 downto 0);
signal tick_local : std_logic;
signal tick_q : std_logic;
signal int_enable : std_logic;
signal pico_miso_vect : pico_miso_vector_t(1 downto 0);

begin

-- map tick output
TICK <= tick_local;

-- map in port
PICO_MISO.in_port <= pico_miso_vect(0).in_port or pico_miso_vect(1).in_port;

-- manage interupts
interrupt_proc : process(CLK)
begin
   if (CLK'event and CLK = '1') then
      if (RST = '1' or PICO_MOSI.interrupt_ack = '1') then
         PICO_MISO.interrupt <= '0';
      elsif (tick_local = '1' and int_enable = '1') then
         PICO_MISO.interrupt <= '1';
      end if;
   end if;
end process interrupt_proc;

-- timer counter
count_proc : process(CLK)
begin
   if (CLK'event and CLK = '1') then
        if (RST = '1' or (counter >= term_cnt)) then
           counter <= (0 => '1', others => '0');
           tick_local <= '1';
        else
           counter <= counter + 1;
           tick_local <= '0';
        end if;
    end if;
end process count_proc;

-- manage tick latching
tick_q_proc : process(CLK)
variable port_id_q : std_logic_vector(7 downto 0);
begin
   if (CLK'event and CLK = '1') then
      if ((port_id_q = port_id(7 downto 1)) and PICO_MOSI.read_strobe = '1') then
         tick_q <= '0';
      elsif (tick_local = '1') then
         tick_q <= '1';
      end if;
      port_id_q := PICO_MOSI.port_id; -- pipeline the address (infer register)
   end if;
end process tick_q_proc;

-- map the registers
int_enable <= rout1(7);
term_cnt(14 downto 8) <= rout1(6 downto 0);
term_cnt(7 downto 0) <= rout0;

rin1 <= tick_q & counter(14 downto 8);
rin0 <= counter(7 downto 0);

inst_reg0 : pico_reg
    generic map(
        port_id => port_id(7 downto 1) & '0')
    port map(
        CLK => CLK,
        DOUT => rout0,
        DIN  => rin0,
        PICO_MISO => pico_miso_vect(0),
        PICO_MOSI => PICO_MOSI);
        
inst_reg1 : pico_reg
    generic map(
        port_id => port_id(7 downto 1) & '1')
    port map(
        CLK => CLK,
        DOUT => rout1,
        DIN  => rin1,
        PICO_MISO => pico_miso_vect(1),
        PICO_MOSI => PICO_MOSI);

end rtl;