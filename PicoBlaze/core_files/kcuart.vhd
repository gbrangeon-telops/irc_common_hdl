-- 'Bucket Brigade' FIFO  
-- 16 deep
-- 8-bit data
--
-- Version : 1.10 
-- Version Date : 3rd December 2003
-- Reason : '--translate' directives changed to '--synthesis translate' directives
--
-- Version : 1.00
-- Version Date : 14th October 2002
--
-- Start of design entry : 14th October 2002
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
--
-- chapman@xilinx.com
--
------------------------------------------------------------------------------------
--
-- NOTICE:
--
-- Copyright Xilinx, Inc. 2002.   This code may be contain portions patented by other 
-- third parties.  By providing this core as one possible implementation of a standard,
-- Xilinx is making no representation that the provided implementation of this standard 
-- is free from any claims of infringement by any third party.  Xilinx expressly 
-- disclaims any warranty with respect to the adequacy of the implementation, including 
-- but not limited to any warranty or representation that the implementation is free 
-- from claims of any third party.  Futhermore, Xilinx is providing this core as a 
-- courtesy to you and suggests that you contact all third parties to obtain the 
-- necessary rights to use this implementation.
--
------------------------------------------------------------------------------------
--
-- Library declarations
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;
--
------------------------------------------------------------------------------------
--
-- Main Entity for BBFIFO_16x8
--
entity bbfifo_16x8 is
    Port (       data_in : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0);
        reset : in std_logic;               
        write : in std_logic; 
        read : in std_logic;
        full : out std_logic;
        half_full : out std_logic;
        data_present : out std_logic;
        clk : in std_logic);
end bbfifo_16x8;
--
------------------------------------------------------------------------------------
--
-- Start of Main Architecture for BBFIFO_16x8
--	 
architecture low_level_definition of bbfifo_16x8 is
    --
    ------------------------------------------------------------------------------------
    --
    ------------------------------------------------------------------------------------
    --
    -- Signals used in BBFIFO_16x8
    --
    ------------------------------------------------------------------------------------
    --
    signal pointer             : std_logic_vector(3 downto 0);
    signal next_count          : std_logic_vector(3 downto 0);
    signal half_count          : std_logic_vector(3 downto 0);
    signal count_carry         : std_logic_vector(2 downto 0);
    
    signal pointer_zero        : std_logic;
    signal pointer_full        : std_logic;
    signal decode_data_present : std_logic;
    signal data_present_int    : std_logic;
    signal valid_write         : std_logic;
    --
    --
    ------------------------------------------------------------------------------------
    --
    -- Attributes to define LUT contents during implementation 
    -- The information is repeated in the generic map for functional simulation--
    --
    ------------------------------------------------------------------------------------
    --
    attribute INIT : string; 
    attribute INIT of zero_lut      : label is "0001";
    attribute INIT of full_lut      : label is "8000";
    attribute INIT of dp_lut        : label is "BFA0";
    attribute INIT of valid_lut     : label is "C4";
    --
    ------------------------------------------------------------------------------------
    --
    -- Start of BBFIFO_16x8 circuit description
    --
    ------------------------------------------------------------------------------------
    --	
begin
    
    -- SRL16E data storage
    
    data_width_loop: for i in 0 to 7 generate
        --
        attribute INIT : string; 
        attribute INIT of data_srl : label is "0000"; 
        --
        begin
        
        data_srl: SRL16E
        --synthesis translate_off
        generic map (INIT => X"0000")
        --synthesis translate_on
        port map(   D => data_in(i),
            CE => valid_write,
            CLK => clk,
            A0 => pointer(0),
            A1 => pointer(1),
            A2 => pointer(2),
            A3 => pointer(3),
            Q => data_out(i) );
        
    end generate data_width_loop;
    
    -- 4-bit counter to act as data pointer
    -- Counter is clock enabled by 'data_present'
    -- Counter will be reset when 'reset' is active
    -- Counter will increment when 'valid_write' is active
    
    count_width_loop: for i in 0 to 3 generate
        --
        attribute INIT : string; 
        attribute INIT of count_lut : label is "6606"; 
        --
        begin
        
        register_bit: FDRE
        port map ( D => next_count(i),
            Q => pointer(i),
            CE => data_present_int,
            R => reset,
            C => clk);
        
        count_lut: LUT4
        --synthesis translate_off
        generic map (INIT => X"6606")
        --synthesis translate_on
        port map( I0 => pointer(i),
            I1 => read,
            I2 => pointer_zero,
            I3 => write,
            O => half_count(i));
        
        lsb_count: if i=0 generate
            begin
            
            count_muxcy: MUXCY
            port map( DI => pointer(i),
                CI => valid_write,
                S => half_count(i),
                O => count_carry(i));
            
            count_xor: XORCY
            port map( LI => half_count(i),
                CI => valid_write,
                O => next_count(i));
            
        end generate lsb_count;
        
        mid_count: if i>0 and i<3 generate
            begin
            
            count_muxcy: MUXCY
            port map( DI => pointer(i),
                CI => count_carry(i-1),
                S => half_count(i),
                O => count_carry(i));
            
            count_xor: XORCY
            port map( LI => half_count(i),
                CI => count_carry(i-1),
                O => next_count(i));
            
        end generate mid_count;
        
        upper_count: if i=3 generate
            begin
            
            count_xor: XORCY
            port map( LI => half_count(i),
                CI => count_carry(i-1),
                O => next_count(i));
            
        end generate upper_count;
        
    end generate count_width_loop;
    
    
    -- Detect when pointer is zero and maximum
    
    zero_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"0001")
    --synthesis translate_on
    port map( I0 => pointer(0),
        I1 => pointer(1),
        I2 => pointer(2),
        I3 => pointer(3),
        O => pointer_zero );
    
    
    full_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"8000")
    --synthesis translate_on
    port map( I0 => pointer(0),
        I1 => pointer(1),
        I2 => pointer(2),
        I3 => pointer(3),
        O => pointer_full );
    
    
    -- Data Present status
    
    dp_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"BFA0")
    --synthesis translate_on
    port map( I0 => write,
        I1 => read,
        I2 => pointer_zero,
        I3 => data_present_int,
        O => decode_data_present );
    
    dp_flop: FDR
    port map ( D => decode_data_present,
        Q => data_present_int,
        R => reset,
        C => clk);
    
    -- Valid write signal
    
    valid_lut: LUT3
    --synthesis translate_off
    generic map (INIT => X"C4")
    --synthesis translate_on
    port map( I0 => pointer_full,
        I1 => write,
        I2 => read,
        O => valid_write );
    
    
    -- assign internal signals to outputs
    
    full <= pointer_full;  
    half_full <= pointer(3);  
    data_present <= data_present_int;
    
end low_level_definition;

------------------------------------------------------------------------------------
--
-- END OF FILE BBFIFO_16x8.VHD
--
------------------------------------------------------------------------------------


-- Constant (K) Compact UART Transmitter
--
-- Version : 1.10 
-- Version Date : 3rd December 2003
-- Reason : '--translate' directives changed to '--synthesis translate' directives
--
-- Version : 1.00
-- Version Date : 14th October 2002
--
-- Start of design entry : 2nd October 2002
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
--
-- chapman@xilinx.com
--
------------------------------------------------------------------------------------
--
-- NOTICE:
--
-- Copyright Xilinx, Inc. 2002.   This code may be contain portions patented by other 
-- third parties.  By providing this core as one possible implementation of a standard,
-- Xilinx is making no representation that the provided implementation of this standard 
-- is free from any claims of infringement by any third party.  Xilinx expressly 
-- disclaims any warranty with respect to the adequacy of the implementation, including 
-- but not limited to any warranty or representation that the implementation is free 
-- from claims of any third party.  Futhermore, Xilinx is providing this core as a 
-- courtesy to you and suggests that you contact all third parties to obtain the 
-- necessary rights to use this implementation.
--
------------------------------------------------------------------------------------
--
-- Library declarations
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;
--
------------------------------------------------------------------------------------
--
-- Main Entity for KCUART_TX
--
entity kcuart_tx is
    Port (        data_in : in std_logic_vector(7 downto 0);
        send_character : in std_logic;
        en_16_x_baud : in std_logic;
        serial_out : out std_logic;
        Tx_complete : out std_logic;
        clk : in std_logic);
end kcuart_tx;
--
------------------------------------------------------------------------------------
--
-- Start of Main Architecture for KCUART_TX
--	 
architecture low_level_definition of kcuart_tx is
    --
    ------------------------------------------------------------------------------------
    --
    ------------------------------------------------------------------------------------
    --
    -- Signals used in KCUART_TX
    --
    ------------------------------------------------------------------------------------
    --
    signal data_01            : std_logic;
    signal data_23            : std_logic;
    signal data_45            : std_logic;
    signal data_67            : std_logic;
    signal data_0123          : std_logic;
    signal data_4567          : std_logic;
    signal data_01234567      : std_logic;
    signal bit_select         : std_logic_vector(2 downto 0);
    signal next_count         : std_logic_vector(2 downto 0);
    signal mask_count         : std_logic_vector(2 downto 0);
    signal mask_count_carry   : std_logic_vector(2 downto 0);
    signal count_carry        : std_logic_vector(2 downto 0);
    signal ready_to_start     : std_logic;
    signal decode_Tx_start    : std_logic;
    signal Tx_start           : std_logic;
    signal decode_Tx_run      : std_logic;
    signal Tx_run             : std_logic;
    signal decode_hot_state   : std_logic;
    signal hot_state          : std_logic;
    signal hot_delay          : std_logic;
    signal Tx_bit             : std_logic;
    signal decode_Tx_stop     : std_logic;
    signal Tx_stop            : std_logic;
    signal decode_Tx_complete : std_logic;
    --
    --
    ------------------------------------------------------------------------------------
    --
    -- Attributes to define LUT contents during implementation 
    -- The information is repeated in the generic map for functional simulation--
    --
    ------------------------------------------------------------------------------------
    --
    attribute INIT : string; 
    attribute INIT of mux1_lut      : label is "E4FF";
    attribute INIT of mux2_lut      : label is "E4FF";
    attribute INIT of mux3_lut      : label is "E4FF";
    attribute INIT of mux4_lut      : label is "E4FF";
    attribute INIT of ready_lut     : label is "10";
    attribute INIT of start_lut     : label is "0190";
    attribute INIT of run_lut       : label is "1540";
    attribute INIT of hot_state_lut : label is "94";
    attribute INIT of delay14_srl   : label is "0000";
    attribute INIT of stop_lut      : label is "0180";
    attribute INIT of complete_lut  : label is "8";
    --
    ------------------------------------------------------------------------------------
    --
    -- Start of KCUART_TX circuit description
    --
    ------------------------------------------------------------------------------------
    --	
begin
    
    -- 8 to 1 multiplexer to convert parallel data to serial
    
    mux1_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"E4FF")
    --synthesis translate_on
    port map( I0 => bit_select(0),
        I1 => data_in(0),
        I2 => data_in(1),
        I3 => Tx_run,
        O => data_01 );
    
    mux2_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"E4FF")
    --synthesis translate_on
    port map( I0 => bit_select(0),
        I1 => data_in(2),
        I2 => data_in(3),
        I3 => Tx_run,
        O => data_23 );
    
    mux3_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"E4FF")
    --synthesis translate_on
    port map( I0 => bit_select(0),
        I1 => data_in(4),
        I2 => data_in(5),
        I3 => Tx_run,
        O => data_45 );
    
    mux4_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"E4FF")
    --synthesis translate_on
    port map( I0 => bit_select(0),
        I1 => data_in(6),
        I2 => data_in(7),
        I3 => Tx_run,
        O => data_67 );
    
    mux5_muxf5: MUXF5
    port map(  I1 => data_23,
        I0 => data_01,
        S => bit_select(1),
        O => data_0123 );
    
    mux6_muxf5: MUXF5
    port map(  I1 => data_67,
        I0 => data_45,
        S => bit_select(1),
        O => data_4567 );
    
    mux7_muxf6: MUXF6
    port map(  I1 => data_4567,
        I0 => data_0123,
        S => bit_select(2),
        O => data_01234567 );
    
    -- Register serial output and force start and stop bits
    
    pipeline_serial: FDRS
    port map ( D => data_01234567,
        Q => serial_out,
        R => Tx_start,
        S => Tx_stop,
        C => clk);
    
    -- 3-bit counter
    -- Counter is clock enabled by en_16_x_baud
    -- Counter will be reset when 'Tx_start' is active
    -- Counter will increment when Tx_bit is active
    -- Tx_run must be active to count
    -- count_carry(2) indicates when terminal count (7) is reached and Tx_bit=1 (ie overflow)
    
    count_width_loop: for i in 0 to 2 generate
        --
        attribute INIT : string; 
        attribute INIT of count_lut : label is "8"; 
        --
        begin
        
        register_bit: FDRE
        port map ( D => next_count(i),
            Q => bit_select(i),
            CE => en_16_x_baud,
            R => Tx_start,
            C => clk);
        
        count_lut: LUT2
        --synthesis translate_off
        generic map (INIT => X"8")
        --synthesis translate_on
        port map( I0 => bit_select(i),
            I1 => Tx_run,
            O => mask_count(i));
        
        mask_and: MULT_AND
        port map( I0 => bit_select(i),
            I1 => Tx_run,
            LO => mask_count_carry(i));
        
        lsb_count: if i=0 generate
            begin
            
            count_muxcy: MUXCY
            port map( DI => mask_count_carry(i),
                CI => Tx_bit,
                S => mask_count(i),
                O => count_carry(i));
            
            count_xor: XORCY
            port map( LI => mask_count(i),
                CI => Tx_bit,
                O => next_count(i));
            
        end generate lsb_count;
        
        upper_count: if i>0 generate
            begin
            
            count_muxcy: MUXCY
            port map( DI => mask_count_carry(i),
                CI => count_carry(i-1),
                S => mask_count(i),
                O => count_carry(i));
            
            count_xor: XORCY
            port map( LI => mask_count(i),
                CI => count_carry(i-1),
                O => next_count(i));
            
        end generate upper_count;
        
    end generate count_width_loop;
    
    -- Ready to start decode
    
    ready_lut: LUT3
    --synthesis translate_off
    generic map (INIT => X"10")
    --synthesis translate_on
    port map( I0 => Tx_run,
        I1 => Tx_start,
        I2 => send_character,
        O => ready_to_start );
    
    -- Start bit enable
    
    start_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"0190")
    --synthesis translate_on
    port map( I0 => Tx_bit,
        I1 => Tx_stop,
        I2 => ready_to_start,
        I3 => Tx_start,
        O => decode_Tx_start );
    
    Tx_start_reg: FDE
    port map ( D => decode_Tx_start,
        Q => Tx_start,
        CE => en_16_x_baud,
        C => clk);
    
    
    -- Run bit enable
    
    run_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"1540")
    --synthesis translate_on
    port map( I0 => count_carry(2),
        I1 => Tx_bit,
        I2 => Tx_start,
        I3 => Tx_run,
        O => decode_Tx_run );
    
    Tx_run_reg: FDE
    port map ( D => decode_Tx_run,
        Q => Tx_run,
        CE => en_16_x_baud,
        C => clk);
    
    -- Bit rate enable
    
    hot_state_lut: LUT3
    --synthesis translate_off
    generic map (INIT => X"94")
    --synthesis translate_on
    port map( I0 => Tx_stop,
        I1 => ready_to_start,
        I2 => Tx_bit,
        O => decode_hot_state );
    
    hot_state_reg: FDE
    port map ( D => decode_hot_state,
        Q => hot_state,
        CE => en_16_x_baud,
        C => clk);
    
    delay14_srl: SRL16E
    --synthesis translate_off
    generic map (INIT => X"0000")
    --synthesis translate_on
    port map(   D => hot_state,
        CE => en_16_x_baud,
        CLK => clk,
        A0 => '1',
        A1 => '0',
        A2 => '1',
        A3 => '1',
        Q => hot_delay );
    
    Tx_bit_reg: FDE
    port map ( D => hot_delay,
        Q => Tx_bit,
        CE => en_16_x_baud,
        C => clk);
    
    -- Stop bit enable
    
    stop_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"0180")
    --synthesis translate_on
    port map( I0 => Tx_bit,
        I1 => Tx_run,
        I2 => count_carry(2),
        I3 => Tx_stop,
        O => decode_Tx_stop );
    
    Tx_stop_reg: FDE
    port map ( D => decode_Tx_stop,
        Q => Tx_stop,
        CE => en_16_x_baud,
        C => clk);
    
    -- Tx_complete strobe
    
    complete_lut: LUT2
    --synthesis translate_off
    generic map (INIT => X"8")
    --synthesis translate_on
    port map( I0 => count_carry(2),
        I1 => en_16_x_baud,
        O => decode_Tx_complete );
    
    Tx_complete_reg: FD
    port map ( D => decode_Tx_complete,
        Q => Tx_complete,
        C => clk);
    
    
end low_level_definition;

------------------------------------------------------------------------------------
--
-- END OF FILE KCUART_TX.VHD
--
------------------------------------------------------------------------------------


-- UART Transmitter with integral 16 byte FIFO buffer
--
-- 8 bit, no parity, 1 stop bit
--
-- Version : 1.00
-- Version Date : 14th October 2002
--
-- Start of design entry : 14th October 2002
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
--
-- chapman@xilinx.com
--
------------------------------------------------------------------------------------
--
-- NOTICE:
--
-- Copyright Xilinx, Inc. 2002.   This code may be contain portions patented by other 
-- third parties.  By providing this core as one possible implementation of a standard,
-- Xilinx is making no representation that the provided implementation of this standard 
-- is free from any claims of infringement by any third party.  Xilinx expressly 
-- disclaims any warranty with respect to the adequacy of the implementation, including 
-- but not limited to any warranty or representation that the implementation is free 
-- from claims of any third party.  Futhermore, Xilinx is providing this core as a 
-- courtesy to you and suggests that you contact all third parties to obtain the 
-- necessary rights to use this implementation.
--
------------------------------------------------------------------------------------
--
-- Library declarations
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;
--
------------------------------------------------------------------------------------
--
-- Main Entity for UART_TX
--
entity uart_tx is
    Port (            data_in : in std_logic_vector(7 downto 0);
        write_buffer : in std_logic;
        reset_buffer : in std_logic;
        en_16_x_baud : in std_logic;
        serial_out : out std_logic;
        buffer_full : out std_logic;
        buffer_half_full : out std_logic;
        clk : in std_logic);
end uart_tx;
--
------------------------------------------------------------------------------------
--
-- Start of Main Architecture for UART_TX
--	 
architecture macro_level_definition of uart_tx is
    --
    ------------------------------------------------------------------------------------
    --
    -- Components used in UART_TX and defined in subsequent entities.
    --	
    ------------------------------------------------------------------------------------
    --
    -- Constant (K) Compact UART Transmitter
    --
    component kcuart_tx 
        Port (        data_in : in std_logic_vector(7 downto 0);
            send_character : in std_logic;
            en_16_x_baud : in std_logic;
            serial_out : out std_logic;
            Tx_complete : out std_logic;
            clk : in std_logic);
    end component;
    --
    -- 'Bucket Brigade' FIFO 
    --
    component bbfifo_16x8 
        Port (       data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0);
            reset : in std_logic;               
            write : in std_logic; 
            read : in std_logic;
            full : out std_logic;
            half_full : out std_logic;
            data_present : out std_logic;
            clk : in std_logic);
    end component;
    --
    ------------------------------------------------------------------------------------
    --
    -- Signals used in UART_TX
    --
    ------------------------------------------------------------------------------------
    --
    signal fifo_data_out      : std_logic_vector(7 downto 0);
    signal fifo_data_present  : std_logic;
    signal fifo_read          : std_logic;
    --
    ------------------------------------------------------------------------------------
    --
    -- Start of UART_TX circuit description
    --
    ------------------------------------------------------------------------------------
    --	
begin
    
    -- 8 to 1 multiplexer to convert parallel data to serial
    
    kcuart: kcuart_tx
    port map (        data_in => fifo_data_out,
        send_character => fifo_data_present,
        en_16_x_baud => en_16_x_baud,
        serial_out => serial_out,
        Tx_complete => fifo_read,
        clk => clk);
    
    
    buf: bbfifo_16x8 
    port map (       data_in => data_in,
        data_out => fifo_data_out,
        reset => reset_buffer,              
        write => write_buffer,
        read => fifo_read,
        full => buffer_full,
        half_full => buffer_half_full,
        data_present => fifo_data_present,
        clk => clk);
    
end macro_level_definition;

------------------------------------------------------------------------------------
--
-- END OF FILE UART_TX.VHD
--
------------------------------------------------------------------------------------


-- Constant (K) Compact UART Receiver
--
-- Version : 1.10 
-- Version Date : 3rd December 2003
-- Reason : '--translate' directives changed to '--synthesis translate' directives
--
-- Version : 1.00
-- Version Date : 16th October 2002
--
-- Start of design entry : 16th October 2002
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
--
-- chapman@xilinx.com
--
------------------------------------------------------------------------------------
--
-- NOTICE:
--
-- Copyright Xilinx, Inc. 2002.   This code may be contain portions patented by other 
-- third parties.  By providing this core as one possible implementation of a standard,
-- Xilinx is making no representation that the provided implementation of this standard 
-- is free from any claims of infringement by any third party.  Xilinx expressly 
-- disclaims any warranty with respect to the adequacy of the implementation, including 
-- but not limited to any warranty or representation that the implementation is free 
-- from claims of any third party.  Futhermore, Xilinx is providing this core as a 
-- courtesy to you and suggests that you contact all third parties to obtain the 
-- necessary rights to use this implementation.
--
------------------------------------------------------------------------------------
--
-- Library declarations
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;
--
------------------------------------------------------------------------------------
--
-- Main Entity for KCUART_RX
--
entity kcuart_rx is
    Port (      serial_in : in std_logic;  
        data_out : out std_logic_vector(7 downto 0);
        data_strobe : out std_logic;
        en_16_x_baud : in std_logic;
        clk : in std_logic);
end kcuart_rx;
--
------------------------------------------------------------------------------------
--
-- Start of Main Architecture for KCUART_RX
--	 
architecture low_level_definition of kcuart_rx is
    --
    ------------------------------------------------------------------------------------
    --
    ------------------------------------------------------------------------------------
    --
    -- Signals used in KCUART_RX
    --
    ------------------------------------------------------------------------------------
    --
    signal sync_serial        : std_logic;
    signal stop_bit           : std_logic;
    signal data_int           : std_logic_vector(7 downto 0);
    signal data_delay         : std_logic_vector(7 downto 0);
    signal start_delay        : std_logic;
    signal start_bit          : std_logic;
    signal edge_delay         : std_logic;
    signal start_edge         : std_logic;
    signal decode_valid_char  : std_logic;
    signal valid_char         : std_logic;
    signal decode_purge       : std_logic;
    signal purge              : std_logic;
    signal valid_srl_delay    : std_logic_vector(8 downto 0);
    signal valid_reg_delay    : std_logic_vector(8 downto 0);
    signal decode_data_strobe : std_logic;
    --
    --
    ------------------------------------------------------------------------------------
    --
    -- Attributes to define LUT contents during implementation 
    -- The information is repeated in the generic map for functional simulation--
    --
    ------------------------------------------------------------------------------------
    --
    attribute INIT : string; 
    attribute INIT of start_srl     : label is "0000";
    attribute INIT of edge_srl      : label is "0000";
    attribute INIT of valid_lut     : label is "0040";
    attribute INIT of purge_lut     : label is "54";
    attribute INIT of strobe_lut    : label is "8";
    --
    ------------------------------------------------------------------------------------
    --
    -- Start of KCUART_RX circuit description
    --
    ------------------------------------------------------------------------------------
    --	
begin
    
    -- Synchronise input serial data to system clock
    
    sync_reg: FD
    port map ( D => serial_in,
        Q => sync_serial,
        C => clk);
    
    stop_reg: FD
    port map ( D => sync_serial,
        Q => stop_bit,
        C => clk);
    
    
    -- Data delays to capture data at 16 time baud rate
    -- Each SRL16E is followed by a flip-flop for best timing
    
    data_loop: for i in 0 to 7 generate
        begin
        
        lsbs: if i<7 generate
            --
            attribute INIT : string; 
            attribute INIT of delay15_srl : label is "0000"; 
            --
            begin
            
            delay15_srl: SRL16E
            --synthesis translate_off
            generic map (INIT => X"0000")
            --synthesis translate_on
            port map(   D => data_int(i+1),
                CE => en_16_x_baud,
                CLK => clk,
                A0 => '0',
                A1 => '1',
                A2 => '1',
                A3 => '1',
                Q => data_delay(i) );
            
        end generate lsbs;
        
        msb: if i=7 generate
            --
            attribute INIT : string; 
            attribute INIT of delay15_srl : label is "0000"; 
            --
            begin
            
            delay15_srl: SRL16E
            --synthesis translate_off
            generic map (INIT => X"0000")
            --synthesis translate_on
            port map(   D => stop_bit,
                CE => en_16_x_baud,
                CLK => clk,
                A0 => '0',
                A1 => '1',
                A2 => '1',
                A3 => '1',
                Q => data_delay(i) );
            
        end generate msb;
        
        data_reg: FDE
        port map ( D => data_delay(i),
            Q => data_int(i),
            CE => en_16_x_baud,
            C => clk);
        
    end generate data_loop;
    
    -- Assign internal signals to outputs
    
    data_out <= data_int;
    
    -- Data delays to capture start bit at 16 time baud rate
    
    start_srl: SRL16E
    --synthesis translate_off
    generic map (INIT => X"0000")
    --synthesis translate_on
    port map(   D => data_int(0),
        CE => en_16_x_baud,
        CLK => clk,
        A0 => '0',
        A1 => '1',
        A2 => '1',
        A3 => '1',
        Q => start_delay );
    
    start_reg: FDE
    port map ( D => start_delay,
        Q => start_bit,
        CE => en_16_x_baud,
        C => clk);
    
    
    -- Data delays to capture start bit leading edge at 16 time baud rate
    -- Delay ensures data is captured at mid-bit position
    
    edge_srl: SRL16E
    --synthesis translate_off
    generic map (INIT => X"0000")
    --synthesis translate_on
    port map(   D => start_bit,
        CE => en_16_x_baud,
        CLK => clk,
        A0 => '1',
        A1 => '0',
        A2 => '1',
        A3 => '0',
        Q => edge_delay );
    
    edge_reg: FDE
    port map ( D => edge_delay,
        Q => start_edge,
        CE => en_16_x_baud,
        C => clk);
    
    -- Detect a valid character 
    
    valid_lut: LUT4
    --synthesis translate_off
    generic map (INIT => X"0040")
    --synthesis translate_on
    port map( I0 => purge,
        I1 => stop_bit,
        I2 => start_edge,
        I3 => edge_delay,
        O => decode_valid_char );  
    
    valid_reg: FDE
    port map ( D => decode_valid_char,
        Q => valid_char,
        CE => en_16_x_baud,
        C => clk);
    
    -- Purge of data status 
    
    purge_lut: LUT3
    --synthesis translate_off
    generic map (INIT => X"54")
    --synthesis translate_on
    port map( I0 => valid_reg_delay(8),
        I1 => valid_char,
        I2 => purge,
        O => decode_purge );  
    
    purge_reg: FDE
    port map ( D => decode_purge,
        Q => purge,
        CE => en_16_x_baud,
        C => clk);
    
    -- Delay of valid_char pulse of length equivalent to the time taken 
    -- to purge data shift register of all data which has been used.
    -- Requires 9x16 + 8 delays which is achieved by packing of SRL16E with 
    -- up to 16 delays and utilising the dedicated flip flop in each stage.
    
    valid_loop: for i in 0 to 8 generate
        begin
        
        lsb: if i=0 generate
            --
            attribute INIT : string; 
            attribute INIT of delay15_srl : label is "0000"; 
            --
            begin
            
            delay15_srl: SRL16E
            --synthesis translate_off
            generic map (INIT => X"0000")
            --synthesis translate_on
            port map(   D => valid_char,
                CE => en_16_x_baud,
                CLK => clk,
                A0 => '0',
                A1 => '1',
                A2 => '1',
                A3 => '1',
                Q => valid_srl_delay(i) );
            
        end generate lsb;
        
        msbs: if i>0 generate
            --
            attribute INIT : string; 
            attribute INIT of delay16_srl : label is "0000"; 
            --
            begin
            
            delay16_srl: SRL16E
            --synthesis translate_off
            generic map (INIT => X"0000")
            --synthesis translate_on
            port map(   D => valid_reg_delay(i-1),
                CE => en_16_x_baud,
                CLK => clk,
                A0 => '1',
                A1 => '1',
                A2 => '1',
                A3 => '1',
                Q => valid_srl_delay(i) );
            
        end generate msbs;
        
        data_reg: FDE
        port map ( D => valid_srl_delay(i),
            Q => valid_reg_delay(i),
            CE => en_16_x_baud,
            C => clk);
        
    end generate valid_loop;
    
    -- Form data strobe
    
    strobe_lut: LUT2
    --synthesis translate_off
    generic map (INIT => X"8")
    --synthesis translate_on
    port map( I0 => valid_char,
        I1 => en_16_x_baud,
        O => decode_data_strobe );
    
    strobe_reg: FD
    port map ( D => decode_data_strobe,
        Q => data_strobe,
        C => clk);
    
end low_level_definition;

------------------------------------------------------------------------------------
--
-- END OF FILE KCUART_RX.VHD
--
------------------------------------------------------------------------------------


-- UART Receiver with integral 16 byte FIFO buffer
--
-- 8 bit, no parity, 1 stop bit
--
-- Version : 1.00
-- Version Date : 16th October 2002
--
-- Start of design entry : 16th October 2002
--
-- Ken Chapman
-- Xilinx Ltd
-- Benchmark House
-- 203 Brooklands Road
-- Weybridge
-- Surrey KT13 ORH
-- United Kingdom
--
-- chapman@xilinx.com
--
------------------------------------------------------------------------------------
--
-- NOTICE:
--
-- Copyright Xilinx, Inc. 2002.   This code may be contain portions patented by other 
-- third parties.  By providing this core as one possible implementation of a standard,
-- Xilinx is making no representation that the provided implementation of this standard 
-- is free from any claims of infringement by any third party.  Xilinx expressly 
-- disclaims any warranty with respect to the adequacy of the implementation, including 
-- but not limited to any warranty or representation that the implementation is free 
-- from claims of any third party.  Futhermore, Xilinx is providing this core as a 
-- courtesy to you and suggests that you contact all third parties to obtain the 
-- necessary rights to use this implementation.
--
------------------------------------------------------------------------------------
--
-- Library declarations
--
-- The Unisim Library is used to define Xilinx primitives. It is also used during
-- simulation. The source can be viewed at %XILINX%\vhdl\src\unisims\unisim_VCOMP.vhd
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
use unisim.vcomponents.all;
--
------------------------------------------------------------------------------------
--
-- Main Entity for UART_RX
--
entity uart_rx is
    Port (            serial_in : in std_logic;
        data_out : out std_logic_vector(7 downto 0);
        read_buffer : in std_logic;
        reset_buffer : in std_logic;
        en_16_x_baud : in std_logic;
        buffer_data_present : out std_logic;
        buffer_full : out std_logic;
        buffer_half_full : out std_logic;
        clk : in std_logic);
end uart_rx;
--
------------------------------------------------------------------------------------
--
-- Start of Main Architecture for UART_RX
--	 
architecture macro_level_definition of uart_rx is
    --
    ------------------------------------------------------------------------------------
    --
    -- Components used in UART_RX and defined in subsequent entities.
    --	
    ------------------------------------------------------------------------------------
    --
    -- Constant (K) Compact UART Receiver
    --
    component kcuart_rx 
        Port (      serial_in : in std_logic;  
            data_out : out std_logic_vector(7 downto 0);
            data_strobe : out std_logic;
            en_16_x_baud : in std_logic;
            clk : in std_logic);
    end component;
    --
    -- 'Bucket Brigade' FIFO 
    --
    component bbfifo_16x8 
        Port (       data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0);
            reset : in std_logic;               
            write : in std_logic; 
            read : in std_logic;
            full : out std_logic;
            half_full : out std_logic;
            data_present : out std_logic;
            clk : in std_logic);
    end component;
    --
    ------------------------------------------------------------------------------------
    --
    -- Signals used in UART_RX
    --
    ------------------------------------------------------------------------------------
    --
    signal uart_data_out      : std_logic_vector(7 downto 0);
    signal fifo_write          : std_logic;
    --
    ------------------------------------------------------------------------------------
    --
    -- Start of UART_RX circuit description
    --
    ------------------------------------------------------------------------------------
    --	
begin
    
    -- 8 to 1 multiplexer to convert parallel data to serial
    
    kcuart: kcuart_rx
    port map (     serial_in => serial_in,
        data_out => uart_data_out,
        data_strobe => fifo_write,
        en_16_x_baud => en_16_x_baud,
        clk => clk );
    
    
    buf: bbfifo_16x8 
    port map (       data_in => uart_data_out,
        data_out => data_out,
        reset => reset_buffer,              
        write => fifo_write,
        read => read_buffer,
        full => buffer_full,
        half_full => buffer_half_full,
        data_present => buffer_data_present,
        clk => clk);
    
end macro_level_definition;

------------------------------------------------------------------------------------
--
-- END OF FILE UART_RX.VHD
--
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
-- UART Debugging console to communicate with core via UART type interface
-- For simulation purposes only.
------------------------------------------------------------------------------------
-- translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library std;
use std.textio.all;

entity console is
    generic(
        delay : time := 100us;
        bps : integer := 9600;                -- baud rate of interface
        in_file : string := "std_input";      -- input vector file
        out_file : string := "std_output");   -- output vector file
    port(
        TX : out std_logic;                   -- UART Tx line
        RX : in std_logic);                   -- UART Rx line
    
end console;

architecture sim of console is
    
    -- use low level tx and rx uart modules without fifos
    component kcuart_tx 
        port(
            data_in : in std_logic_vector(7 downto 0);
            send_character : in std_logic;
            en_16_x_baud : in std_logic;
            serial_out : out std_logic;
            Tx_complete : out std_logic;
            clk : in std_logic);
    end component;
    
    component kcuart_rx 
        port(
            serial_in : in std_logic;  
            data_out : out std_logic_vector(7 downto 0);
            data_strobe : out std_logic;
            en_16_x_baud : in std_logic;
            clk : in std_logic);
    end component;
    
    file in_vect : text open read_mode is in_file;
    file out_vect : text open write_mode is out_file;
    
    signal tx_data : std_logic_vector(7 downto 0);
    signal tx_stb : std_logic;
    signal tx_done : std_logic;
    signal rx_data : std_logic_vector(7 downto 0);
    signal rx_valid : std_logic;
    signal clk : std_logic;
    
    constant half_period : time := 1000ms/(32.0*real(bps)); -- we must clock at 16 times the baud rate
    constant en_16_x_baud : std_logic := '1';    -- always enabled with this clock period
    
begin
    
    -- generate a clock source
    clock : process
    begin
        clk <= '0';
        loop
            wait for half_period;
            clk <= not clk;
        end loop;
    end process clock;
    
    -- transmit the data over the serial link
    inst_tx_module: kcuart_tx
    port map(
        data_in => tx_data,
        send_character => tx_stb,
        en_16_x_baud => en_16_x_baud,
        serial_out => TX,
        Tx_complete => tx_done,
        clk => clk);
    
    -- receive the data over the serial link
    inst_rx_module: kcuart_rx
    port map(
        serial_in => RX,
        data_out => rx_data,
        data_strobe => rx_valid,
        en_16_x_baud => en_16_x_baud,
        clk => clk );
    
    -- read and transmit the input file until eof
    read_console : process
        function To_Nibble(ch : in character) return std_logic_vector is
            variable nibble : std_logic_vector(3 downto 0);
        begin
            case ch is
                when '0' => nibble := x"0";
                when '1' => nibble := x"1";
                when '2' => nibble := x"2";
                when '3' => nibble := x"3";
                when '4' => nibble := x"4";
                when '5' => nibble := x"5";
                when '6' => nibble := x"6";
                when '7' => nibble := x"7";
                when '8' => nibble := x"8";
                when '9' => nibble := x"9";
                when 'A' | 'a' => nibble := x"A";
                when 'B' | 'b' => nibble := x"B";
                when 'C' | 'c' => nibble := x"C";
                when 'D' | 'd' => nibble := x"D";
                when 'E' | 'e' => nibble := x"E";
                when 'F' | 'f' => nibble := x"F";
                when others => nibble := "UUUU";
            end case;
            return nibble;
        end To_Nibble;
        
        variable L : line;
        variable ch : character := ';';
        variable nibble : std_logic_vector(3 downto 0) := "UUUU";
        variable high_nibble : boolean := true;
        
    begin
        tx_data <= x"00";
        tx_stb <= '0';
        
        loop
            -- read the nibble
            if ch = ';' then -- eof reached or read a new line as required
                if endfile(in_vect) then
                    wait until clk'event and clk = '1' and tx_done = '1';
                    tx_stb <= '0';
                    wait; -- for eternity 
                else
                    readline(in_vect,L);
                end if;
            end if;
            
            if L'length = 0 then                      -- end of line exceptions
                ch := ';';
            else
                read(L,ch);                           -- read a character
                if (ch = '@') then      -- check for special delay escape symbol
                    wait for delay;
                end if;
            end if;
            
            -- convert valid nibbles to hex
            nibble := To_Nibble(ch);
            if (nibble /= "UUUU") then
                if high_nibble then
                    tx_data(7 downto 4) <= nibble;
                    high_nibble := false;
                else
                    tx_data(3 downto 0) <= nibble;
                    wait until clk'event and clk = '1';
                    tx_stb <= '1';
                    wait until clk'event and clk = '1' and tx_done = '1';
                    tx_stb <= '0';
                    high_nibble := true;
                end if;
            end if;
            
        end loop;
    end process;
    
    -- receive data and write to the output file
    write_console : process(clk)
        function To_Hex(nibble : in std_logic_vector(3 downto 0)) return character is
            variable ch : character;
        begin
            case nibble is
                when x"0" => ch := '0';
                when x"1" => ch := '1';
                when x"2" => ch := '2';
                when x"3" => ch := '3';
                when x"4" => ch := '4';
                when x"5" => ch := '5';
                when x"6" => ch := '6'; 
                when x"7" => ch := '7';
                when x"8" => ch := '8';
                when x"9" => ch := '9';
                when x"A" => ch := 'A';
                when x"B" => ch := 'B'; 
                when x"C" => ch := 'C';
                when x"D" => ch := 'D';
                when x"E" => ch := 'E';
                when x"F" => ch := 'F';
                when others => ch := 'X';
            end case;
            return ch;
        end To_Hex;
        
        variable L : line;
        
    begin
        if (clk'event and clk = '1') then
            if rx_valid = '1' then
                write(L,To_Hex(rx_data(7 downto 4)));
                write(L,To_Hex(rx_data(3 downto 0)));
                writeline(out_vect,L);
            end if;
        end if;
    end process;   
    
end sim;
-- translate_on