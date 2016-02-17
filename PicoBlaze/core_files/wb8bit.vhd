---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006-2007
--
--  File: wb8bit.vhd
--  Use:  library of useful 8bit wishbone compliant cores and stuff useful for PicoBlaze
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package wb8bit_define is
    
    -- This package defines an 8bit subset of the Wishbone interface useable with PicoBlaze
    -- any unused signals will be optimized away by the synthesis tools.
    type wb8bit_mosi_t is
    record
        ADR  : std_logic_vector(7 downto 0);
        DAT  : std_logic_vector(7 downto 0);
        STB  : std_logic;
        SEL  : std_logic;  -- 8 bit bus has only one sel line
        WE   : std_logic;
        CYC  : std_logic;
        TGC  : std_logic;  -- cycle type tag (for special interrupt_ack cycles
    end record;
    
    type wb8bit_miso_t is
    record
        DAT   : std_logic_vector(7 downto 0);
        ACK  : std_logic;
        INT   : std_logic;
    end record;
    
    -- TGC constants
    constant std_cycle    : std_logic := '0';
    constant intack_cycle : std_logic := '1';
    
    type wb8bit_miso_v_t is array(natural range <>) of wb8bit_miso_t;
    type wb8bit_mosi_v_t is array(natural range <>) of wb8bit_mosi_t;
    
end package wb8bit_define;

---------------------------------------------------------------------------------------------------
-- PICOBlaze bus to WISHBONE bus bridge
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.wb8bit_define.all;

entity pico_wb_bridge is
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
end pico_wb_bridge;

architecture rtl of pico_wb_bridge is
    
begin
    
    -- map master-out / slave-in signals
    wb_mosi_vect_gen : for i in WB_MOSI_V'range generate
        WB_MOSI_V(i).ADR <= PORT_ID;
        WB_MOSI_V(i).DAT <= OUT_PORT;
        WB_MOSI_V(i).STB <= WRITE_STROBE or READ_STROBE;
        WB_MOSI_V(i).CYC <= WRITE_STROBE or READ_STROBE or INTERRUPT_ACK;
        WB_MOSI_V(i).WE  <= WRITE_STROBE;
        WB_MOSI_V(i).TGC <= intack_cycle when (INTERRUPT_ACK = '1') else std_cycle; -- tag interrupt_ack cycles
        WB_MOSI_V(i).SEL <= '1'; -- this 8bit bridge has a single data lane!
    end generate;
    
    -- map master-in / slave-out signals
    wb_miso_vect_dec : process(WB_MISO_V)
        variable dat_temp: std_logic_vector(7 downto 0);
        variable int_temp : std_logic;
    begin
        dat_temp := x"00";
        int_temp := '0';
        for i in SLAVES-1 downto 0 loop
            dat_temp := dat_temp or WB_MISO_V(i).DAT;
            int_temp := int_temp or WB_MISO_V(i).INT;
        end loop;
        IN_PORT <= dat_temp;
        INTERRUPT <= int_temp;
    end process wb_miso_vect_dec;
    
    -- note: ack is not mapped in this bridge PicoBlaze expects implicit ack at the end of its bus
    -- cycle and thus all wishbone peripherals used with this bridge must have valid data within
    -- a single clock cycle. ie. there is no way to insert wait states in the PicoBlaze bus cycle
    -- so be careful about the wishbone cores you use.
    -- a multi-cycle bridge may be added later for longer latency peripherals at the expense of simplicity
    
end rtl;

---------------------------------------------------------------------------------------------------
-- 8bit wishbone Bus addressable register core
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use work.wb8bit_define.all;

entity wb8bit_reg is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
    port(
        CLK : in std_logic;
        DOUT : out std_logic_vector(7 downto 0);
        DIN  : in std_logic_vector(7 downto 0);
        WB_MISO : out wb8bit_miso_t;
        WB_MOSI : in wb8bit_mosi_t);
end wb8bit_reg;

architecture rtl of wb8bit_reg is
    
    signal adr_q : std_logic_vector(7 downto 0); -- registered version of WB_MOSI.ADR
    
begin
    
    -- we must pipeline port_id to break critical timing path
    pipeline : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            adr_q <= WB_MOSI.ADR;
        end if;
    end process pipeline;
    
    -- generate a bus cycle ack at the right instant
    ack_gen : process(adr_q, WB_MOSI.STB, WB_MOSI.CYC, WB_MOSI.SEL)
    begin
        if (adr_q = port_id and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1') then
            WB_MISO.ACK <= '1';
        else
            WB_MISO.ACK <= '0';
        end if;
    end process ack_gen;
    
    reg_write : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (adr_q = port_id and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1' and WB_MOSI.WE = '1') then
                DOUT <= WB_MOSI.DAT;
            end if;
        end if;
    end process reg_write;
    
    -- purely combinational read because we had to register adr to break the critical path
    reg_read : process(adr_q, DIN)
    begin
        if (adr_q = port_id) then
            WB_MISO.DAT <= DIN;
        else
            WB_MISO.DAT <= x"00"; -- all in ports will be "ORed" at uC so drive low when not solicitated
        end if;
    end process reg_read;
    
    -- do not drive the interrupt pin
    WB_MISO.INT <= '0'; 
    
end rtl;

---------------------------------------------------------------------------------------------------
-- 8bit wishbone Bus interface single port 8bitx16 deep LUT based ram infered memory
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.wb8bit_define.all;

entity wb8bit_ram_d16 is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
    port(
        CLK : in std_logic;
        WB_MISO : out wb8bit_miso_t;
        WB_MOSI : in wb8bit_mosi_t);
end wb8bit_ram_d16;

architecture rtl of wb8bit_ram_d16 is
    
    signal we : std_logic;
    signal addr : std_logic_vector(3 downto 0);
    signal wr_data : std_logic_vector(7 downto 0);
    signal rd_data : std_logic_vector(7 downto 0);
    signal adr_q : std_logic_vector(7 downto 0);
    
    type ram_w8xd16_t is array (15 downto 0) of std_logic_vector (7 downto 0);
    signal ram_w8xd16 : ram_w8xd16_t;
    
begin
    
    -- address pipelineing
    addr_pipe : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            adr_q <= WB_MOSI.adr; 
        end if;
    end process addr_pipe;
    
    -- generate a bus cycle ack at the right instant
    ack_gen : process(adr_q, WB_MOSI.STB, WB_MOSI.CYC, WB_MOSI.SEL)
    begin
        if (adr_q(7 downto 4) = port_id(7 downto 4) and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1') then
            WB_MISO.ACK <= '1';
        else
            WB_MISO.ACK <= '0';
        end if;
    end process ack_gen;
    
    -- data writing
    data_write : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (adr_q(7 downto 4) = port_id(7 downto 4) and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1' and WB_MOSI.WE = '1') then
                we <= '1';
                wr_data <= WB_MOSI.DAT;
            else
                we <= '0';
            end if;
        end if;
    end process data_write;
    
    -- data reading
    data_read: process(adr_q, rd_data, WB_MOSI)
    begin
        addr <= adr_q(3 downto 0);
        if (adr_q(7 downto 4) = port_id(7 downto 4) and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1') then
            WB_MISO.DAT <= rd_data;
        else
            WB_MISO.DAT <= x"00"; -- all in ports will be "ORed" at uC so drive low when not solicitated
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
    WB_MISO.INT <= '0'; 
    
end rtl;

---------------------------------------------------------------------------------------------------
-- Complete wishbone compliant UART using picoblaze kcuart components
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.wb8bit_define.all;
-- translate_off
use work.telops_testing.all;
-- translate_on

entity wb8bit_uart is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"; -- decode address
        bps : integer := 115200; -- 115200bps
        fclk : integer := 100E6); -- 100MHz
    port(
        CLK : in std_logic;
        RST : in std_logic;
        BAUD_16X : in std_logic;
        TX : out std_logic;
        RX : in std_logic;
        WB_MISO : out wb8bit_miso_t;
        WB_MOSI : in wb8bit_mosi_t);
end wb8bit_uart;

architecture rtl of wb8bit_uart is
    
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
    signal dat0 : std_logic_vector(7 downto 0);
    signal dat1 : std_logic_vector(7 downto 0);
    signal adr_q : std_logic_vector(7 downto 0);
    
    -- example baud rate calc: 10ns * 54 * 16 = 8680ns ~115200bps (115740bps really)
    -- remember need to feed pico_uart at 16x its operating baud rate 
    constant baud_ratio : integer := integer(fclk/(16*bps))-1; -- calculate the clock division factor
    
    ---------------------------------------------------------------------------------------------------
    -- Hide the following definitions from the synthesizer
    -- translate_off
    ---------------------------------------------------------------------------------------------------
    signal bps_ok : boolean := true;
    type mem_t is array (0 to 15) of std_logic_vector(7 downto 0);
    signal rx_fifo_mem : mem_t;
    signal rx_wr_ptr : integer range 0 to 15;
    signal tx_fifo_mem : mem_t;
    signal tx_rd_ptr : integer range 0 to 15;
    ---------------------------------------------------------------------------------------------------
    -- re-enable synthesis
    -- translate_on
    ---------------------------------------------------------------------------------------------------
    
begin
    
    ---------------------------------------------------------------------------------------------------
    -- The following section is used for speeding up simulation up to bit rates faster than
    -- the system clock and is not supported by real hardware! => be careful of implications
    -- you can run up to a bps = 10*fclk after that your system will not be able to keep up even
    -- if 1 byte is consumed at the rx for each system clock tick!
    -- translate_off
    --------------------------------------------------------------------------------------------------- 
    sim_model : if (baud_ratio < 0) generate
        begin
        
        bps_ok <= false;
        assert bps_ok report "pico_uart_bps: => Generating simulation model because the baud rate setting is too high for the given fclk" severity warning;
        assert (bps <= 10*fclk) report "pico_uart_bps => Too fast bps setting! The RX Fifo will overflow even if you read at every clock tick" severity failure;
        
        -- simulated UART receiver
        rxloop : process
            variable byte : std_logic_vector(7 downto 0);
        begin
            rx_wr_ptr <= 0;
            loop
                rx_uart(byte,bps,RX);
                rx_fifo_mem(rx_wr_ptr) <= byte;
                if rx_wr_ptr < 15 then
                    rx_wr_ptr <= rx_wr_ptr + 1;
                else
                    rx_wr_ptr <= 0;
                end if;
            end loop;
            wait;
        end process rxloop;
        rx_half <= '0';
        
        -- simulated UART receiver fifo
        rx_sync : process(CLK)
            variable rd_ptr : integer range 0 to 15 := 0;
            variable level : integer range 0 to 15;
        begin
            if (CLK'event and CLK = '1') then
                -- fifo reading;
                rx_data <= rx_fifo_mem(rd_ptr); -- data fall through
                if level > 0 and rx_rd = '1' then
                    if rd_ptr < 15 then
                        rd_ptr := rd_ptr + 1;
                    else
                        rd_ptr := 0;
                    end if;
                end if;
                
                -- update fifo level
                if rd_ptr = 15 and rx_wr_ptr = 0 then
                    level := 1;
                elsif rx_wr_ptr >= rd_ptr then
                    level := rx_wr_ptr - rd_ptr;
                else
                    level := rd_ptr - rx_wr_ptr;
                end if;
                
                -- udate data present flag
                if level > 0 then
                    rx_flag <= '1';
                else
                    rx_flag <= '0';
                end if;
                
                -- update full flag
                if level = 15 then
                    rx_full <= '1';
                else
                    rx_full <= '0';
                end if;
                
            end if;
        end process rx_sync;
        
        -- simulated transmitter (no fifo has yet been coded for this case)
        txloop : process
            variable data : std_logic_vector(7 downto 0);
        begin
            tx_full <= '0';
            TX <= '1';
            loop
                wait until CLK'event and CLK = '0' and tx_wr = '1';
                data := tx_data;
                tx_full <= '1';
                tx_uart(data, bps, TX);
                tx_full <= '0';
            end loop;
            wait;
        end process txloop;
        tx_half <= '0';
        
    end generate sim_model;
    ---------------------------------------------------------------------------------------------------
    -- re-enable synthesis
    -- translate_on
    ---------------------------------------------------------------------------------------------------
    
    ---------------------------------------------------------------------------------------------------
    -- The following section is the real part model and is generated when decent
    -- bps settings are given
    ---------------------------------------------------------------------------------------------------
    real_model : if (baud_ratio >= 0) generate
        begin
        
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
        
    end generate real_model;
    
    -- map stat_reg
    stat_reg(0) <= '0';
    stat_reg(1) <= rx_full;
    stat_reg(2) <= tx_full;
    stat_reg(3) <= '0';
    stat_reg(4) <= rx_flag;
    stat_reg(5) <= rx_half;
    stat_reg(6) <= tx_half;
    stat_reg(7) <= '0';
    
    -- we must pipeline port_id to break critical timing path
    pipeline : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            adr_q <= WB_MOSI.ADR;
        end if;
    end process pipeline;
    
    -- generate a bus cycle ack at the right instant
    ack_gen : process(adr_q, WB_MOSI.STB, WB_MOSI.CYC, WB_MOSI.SEL)
    begin
        if (adr_q(7 downto 1) = port_id(7 downto 1) and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1') then
            WB_MISO.ACK <= '1';
        else
            WB_MISO.ACK <= '0';
        end if;
    end process ack_gen;
    
    -- stat_read
    stat_read : process(adr_q, stat_reg)
    begin
        if (adr_q = port_id(7 downto 1) & '0') then
            dat0 <= stat_reg;
        else
            dat0 <= x"00"; -- all in ports will be "ORed" at uC so drive low when not solicitated
        end if;
    end process stat_read;
    
    tx_write : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            tx_data <= WB_MOSI.DAT;
            if (adr_q = port_id(7 downto 1) & '1' and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1' and WB_MOSI.WE = '1') then
                tx_wr <= '1';
            else
                tx_wr <= '0';
            end if;
        end if;
    end process tx_write;
    
    -- data_read
    rx_read : process(adr_q, rx_data, WB_MOSI.STB, WB_MOSI.CYC, WB_MOSI.SEL)
    begin
        if (adr_q = port_id(7 downto 1) & '1') and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1' then
            dat1 <= rx_data;
            rx_rd <= '1';
        else
            dat1 <= x"00"; -- all in ports will be "ORed" at bridge so drive low when not solicitated
            rx_rd <= '0';
        end if;
    end process rx_read;
    
    -- map bus interface
    WB_MISO.DAT <= dat0 or dat1;
    WB_MISO.INT <= '0'; -- do not drive the interrupt pin
    
end rtl;

---------------------------------------------------------------------------------------------------
-- Wishbone 8 bit interval timer
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library work;
use work.wb8bit_define.all;

entity wb8bit_timer is
    generic(
        port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
    port(
        CLK : in std_logic;
        RST : in std_logic;
        TICK : out std_logic;
        WB_MISO : out wb8bit_miso_t;
        WB_MOSI : in wb8bit_mosi_t);
end wb8bit_timer;

architecture rtl of wb8bit_timer is
    
    component wb8bit_reg
        generic(
            port_id : std_logic_vector(7 downto 0) := X"00"); -- decode address
        port(
            CLK : in std_logic;
            DOUT : out std_logic_vector(7 downto 0);
            DIN  : in std_logic_vector(7 downto 0);
            WB_MISO : out wb8bit_miso_t;
            WB_MOSI : in wb8bit_mosi_t);
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
    signal wb8bit_miso_vect : wb8bit_miso_v_t(1 downto 0);
    
begin
    
    -- map tick output
    TICK <= tick_local;
    
    -- map MISO ports
    WB_MISO.DAT <= wb8bit_miso_vect(0).DAT or wb8bit_miso_vect(1).DAT;
    WB_MISO.ACK <= wb8bit_miso_vect(0).ACK or wb8bit_miso_vect(1).ACK;
    
    -- manage interupts
    interrupt_proc : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (RST = '1' or (WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1' and WB_MOSI.TGC = intack_cycle)) then
                WB_MISO.INT <= '0';
            elsif (tick_local = '1' and int_enable = '1') then
                WB_MISO.INT <= '1';
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
        variable adr_q : std_logic_vector(7 downto 0);
    begin
        if (CLK'event and CLK = '1') then
            if ((adr_q = port_id(7 downto 1)) and WB_MOSI.STB = '1' and WB_MOSI.CYC = '1' and WB_MOSI.SEL = '1' and WB_MOSI.WE = '0') then
                tick_q <= '0';
            elsif (tick_local = '1') then
                tick_q <= '1';
            end if;
            adr_q := WB_MOSI.ADR; -- pipeline the address (infer register)
        end if;
    end process tick_q_proc;
    
    -- map the registers
    int_enable <= rout1(7);
    term_cnt(14 downto 8) <= rout1(6 downto 0);
    term_cnt(7 downto 0) <= rout0;
    
    rin1 <= tick_q & counter(14 downto 8);
    rin0 <= counter(7 downto 0);
    
    inst_reg0 : wb8bit_reg
    generic map(
        port_id => port_id(7 downto 1) & '0')
    port map(
        CLK => CLK,
        DOUT => rout0,
        DIN  => rin0,
        WB_MISO => wb8bit_miso_vect(0),
        WB_MOSI => WB_MOSI);
    
    inst_reg1 : wb8bit_reg
    generic map(
        port_id => port_id(7 downto 1) & '1')
    port map(
        CLK => CLK,
        DOUT => rout1,
        DIN  => rin1,
        WB_MISO => wb8bit_miso_vect(1),
        WB_MOSI => WB_MOSI);
    
end rtl;