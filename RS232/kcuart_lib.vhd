---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: kcuart_lib.vhd
--  Use: compact uart library based on PicoBlaze KCUART components by Ken Chapman
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Entities:
--     pico_uart : 
--        a complete TX/RX uart with 16 deep fifos needs to be fed with a clock enable
--        at 16X the baud rate
--
--     pico_uart_bps :
--        same as pico_uart but internal fixed baud rate generator based on bps and fclk generics
--
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- KCUART Blocks start here
---------------------------------------------------------------------------------------------------
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
   signal fifo_write         : std_logic;
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
---------------------------------------------------------------------------------------------------
-- KCUART Blocks end here
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Complete simple UART using picoblaze kcuart components
-- must be fed with a clock enable signal running at 16X the required baud rate.
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity pico_uart is
   port(
      -----------------------
      -- User Interface
      -----------------------
      CLK : in std_logic;
      BAUD_16X : in std_logic;
      RX_RD   : in std_logic;
      RX_DVAL : out std_logic;
      RX_DATA : out std_logic_vector(7 downto 0);
      RX_FULL : out std_logic;
      TX_WR   : in std_logic;
      TX_DATA : in std_logic_vector(7 downto 0);
      TX_FULL : out std_logic;
      TX_AFULL : out std_logic;
      -----------------------
      -- External Ìnterface
      -----------------------
      TX_PIN : out std_logic;
      RX_PIN : in std_logic);
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
   
   constant gnd : std_logic := '0';
   
begin
   
   -- instantiate TX block
   inst_tx : uart_tx
   port map(
      buffer_full => TX_FULL,
      buffer_half_full => TX_AFULL,
      clk => CLK,
      data_in => TX_DATA,
      en_16_x_baud => BAUD_16X,
      reset_buffer => gnd,
      serial_out => TX_PIN,
      write_buffer => TX_WR);
   
   -- instantiate RX block
   inst_rx : uart_rx
   port map(
      buffer_data_present => RX_DVAL,
      buffer_full => RX_FULL,
      buffer_half_full => open,
      clk => CLK,
      data_out => RX_DATA,
      en_16_x_baud => BAUD_16X,
      read_buffer => RX_RD,
      reset_buffer => gnd,
      serial_in => RX_PIN);
   
end rtl;

--------------------------------------------------------------------------------------------------
-- Complete simple UART using picoblaze kcuart components
-- This version is given the system clock frequency and the required Baud rate and it will
-- generate its own clock divider internally
-- Additionally it will generate a fast simulation model with one data per system clock transmition
-- if the bps to fclk ratio is imposible to achieve!
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
-- translate_off
library common_hdl;
use common_hdl.telops_testing.all;
-- translate_on

entity pico_uart_bps is
   generic(
      bps : integer := 115200; -- 115200bps
      fclk : integer := 100E6); -- 100MHz
   port(
      -----------------------
      -- User Interface
      -----------------------
      CLK : in std_logic;
      RX_RD   : in std_logic;
      RX_DVAL : out std_logic;
      RX_DATA : out std_logic_vector(7 downto 0);
      RX_FULL : out std_logic;
      TX_WR   : in std_logic;
      TX_DATA : in std_logic_vector(7 downto 0);
      TX_FULL : out std_logic;
      TX_AFULL : out std_logic;
      -----------------------
      -- External Ìnterface
      -----------------------
      TX_PIN : out std_logic;
      RX_PIN : in std_logic);
end pico_uart_bps;

architecture rtl of pico_uart_bps is
   
   component pico_uart is
      port(
         CLK : in std_logic;
         BAUD_16X : in std_logic;
         RX_RD   : in std_logic;
         RX_DVAL : out std_logic;
         RX_DATA : out std_logic_vector(7 downto 0);
         RX_FULL : out std_logic;
         TX_WR   : in std_logic;
         TX_DATA : in std_logic_vector(7 downto 0);
         TX_FULL : out std_logic;
         TX_AFULL : out std_logic;
         TX_PIN : out std_logic;
         RX_PIN : in std_logic);
   end component;
   
   -- example baud rate calc: 10ns * 54 * 16 = 8680ns ~115200bps (115740bps really)
   -- remember need to feed pico_uart at 16x its operating baud rate 
   constant baud_ratio : integer := integer(fclk/(16*bps))-1; -- calculate the clock division factor
   signal baud16x : std_logic;
   signal wr_en : std_logic;
   signal tx_full_i : std_logic;
   
   ---------------------------------------------------------------------------------------------------
   -- Hide the following definitions from the synthesizer
   -- translate_off
   ---------------------------------------------------------------------------------------------------
   signal bps_ok : boolean := true;
   constant FIFO_SIZE : integer := 20000; -- PDU : Enough to avoid bugs!   
   type mem_t is array (0 to FIFO_SIZE-1) of std_logic_vector(7 downto 0); 

   signal rx_fifo_mem : mem_t;
   signal rx_wr_ptr : integer range 0 to FIFO_SIZE-1 := 0;

   signal tx_byte : std_logic_vector(7 downto 0);
   signal tx_req : std_logic := '1';
   signal tx_done : std_logic := '1';
   
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
            rx_uart(byte,bps,RX_PIN);
            rx_fifo_mem(rx_wr_ptr) <= byte;
            if rx_wr_ptr < (FIFO_SIZE-1) then
               rx_wr_ptr <= rx_wr_ptr + 1;
            else
               rx_wr_ptr <= 0;         
               assert false report "Warning, the fifo crossed a boundary. Behavior might be erronueous!!!" severity WARNING;
            end if;
         end loop;
         wait;
      end process rxloop;
      
      -- simulated UART receiver fifo
      rx_sync : process(CLK)
         variable rd_ptr : integer range 0 to (FIFO_SIZE-1) := 0;
         variable level : integer range 0 to (FIFO_SIZE-1);
      begin
         if (CLK'event and CLK = '1') then
            -- fifo reading;
            if level > 0 and RX_RD = '1' then
               RX_DVAL <= '1';
               RX_DATA <= rx_fifo_mem(rd_ptr);
               if rd_ptr < (FIFO_SIZE-1) then
                  rd_ptr := rd_ptr + 1;
               else
                  rd_ptr := 0;
               end if;
            else
               RX_DVAL <= '0';
            end if;
            
            -- update fifo level
            if rd_ptr = (FIFO_SIZE-1) and rx_wr_ptr = 0 then
               level := 1;
            elsif rx_wr_ptr >= rd_ptr then
               level := rx_wr_ptr - rd_ptr;
            else
               level := rd_ptr - rx_wr_ptr;
            end if;
            
            -- update full flag
            if level = (FIFO_SIZE-1) then
               RX_FULL <= '1';
            else
               RX_FULL <= '0';
            end if;
            
         end if;
      end process rx_sync;
      
      tx_sim : process
      begin
         TX_PIN <= '1';
         loop
            tx_done <= '1';
            wait until tx_req = '1';
            tx_done <= '0';
            wait until tx_req = '0';
            tx_uart(tx_byte, bps, TX_PIN);
            tx_done <= '1';
         end loop;
         wait;
      end process tx_sim;
      
      -- simulated UART transmitter fifo
      tx_fifo : process(CLK)
         variable tx_fifo_mem : mem_t;
         variable level : integer range 0 to FIFO_SIZE := 0;
      begin
         if (CLK'event and CLK = '1') then
            
            -- fifo writing;
            if wr_en = '1' and level < FIFO_SIZE then
               tx_fifo_mem(level) := TX_DATA;
               level := level + 1;
            end if;
            
            -- fifo reading
            if level > 0 and tx_done = '1' then
               tx_byte <= tx_fifo_mem(0);
               tx_fifo_mem(0 to FIFO_SIZE-2) := tx_fifo_mem(1 to (FIFO_SIZE-1));
               tx_req <= '1';
               level := level - 1;
            else
               tx_req <= '0';
            end if;

            -- update full flag
            if (wr_en = '1' and level = (FIFO_SIZE-1)) or level = FIFO_SIZE then
               tx_full_i <= '1';
            else
               tx_full_i <= '0';
            end if;
         end if;
      end process tx_fifo;
      
      -- only write to fifo when it is not full!
      wr_en <= TX_WR when(tx_full_i = '0') else '0';
      TX_FULL <= tx_full_i;
      TX_AFULL <= tx_full_i;
      
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
      -- divide the system clock to get appropriate Baud Rate
      clock_div : process(CLK)
         variable cnt : integer range 0 to 255 := 0;
      begin
         if CLK'event and CLK = '1' then
            if cnt = 0 then
               cnt := baud_ratio;
               baud16x <= '1';
            else
               cnt := cnt - 1;
               baud16x <= '0';
            end if;
         end if;
      end process clock_div;
      
      -- only write to fifo when it is not full!
      wr_en <= TX_WR when(tx_full_i = '0') else '0';
      TX_FULL <= tx_full_i;
      
      -- instantiate a pico_uart
      uart_inst : pico_uart
      port map(
         CLK => CLK,
         BAUD_16X => baud16x,
         RX_RD   => RX_RD,
         RX_DVAL => RX_DVAL,
         RX_DATA => RX_DATA,
         RX_FULL => RX_FULL,
         TX_WR   => wr_en,
         TX_DATA => TX_DATA,
         TX_FULL => tx_full_i,
         TX_AFULL => TX_AFULL,
         TX_PIN => TX_PIN,
         RX_PIN => RX_PIN);
      
   end generate real_model;
   
end rtl;