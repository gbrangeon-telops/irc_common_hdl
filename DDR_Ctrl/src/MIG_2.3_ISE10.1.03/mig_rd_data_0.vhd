--*****************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a
-- license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as-is" solely for use in developing programs and
-- solutions for Xilinx devices, with no obligation on the
-- part of Xilinx to provide support. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are
-- done at the user's sole risk and will be unsupported.
--
-- Copyright (c) 2005-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part
-- of this text at all times.
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : 2.3
--  \   \        Application        : MIG
--  /   /        Filename           : mig_rd_data_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: The delay between the read data with respect to the command
--              issued is calculted in terms of no. of clocks. This data is
--              then stored into the FIFOs and then read back and given as
--              the ouput for comparison.
-- Revision History:
--   Rev 1.1 - Changes for V4 no edge straddle calibration scheme. Added
--             PER_BIT_SKEW input, DELAY_ENABLE output and
--             CAL_FIRST_LOOP output. Various other changes. JYO. 6/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_rd_data_0 is
  port(
    clk                 : in  std_logic;
    reset               : in  std_logic;
    ctrl_rden           : in  std_logic;
    per_bit_skew        : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    read_data_rise      : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    read_data_fall      : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
    read_data_fifo_rise : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    read_data_fifo_fall : out std_logic_vector(DATA_WIDTH - 1 downto 0);
    delay_enable        : out std_logic_vector(DATA_WIDTH-1 downto 0);
    comp_done           : out std_logic;
    read_data_valid     : out std_logic;
    cal_first_loop      : out std_logic;

      -- Debug Signals
      dbg_first_rising   : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_cal_first_loop : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_comp_done      : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_comp_error     : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0)
    );
end mig_rd_data_0;

architecture arch of mig_rd_data_0 is

  constant ONES  : std_logic_vector(DATA_STROBE_WIDTH downto 0) := (others => '1');
  constant ZEROS : std_logic_vector(DATA_STROBE_WIDTH downto 0) := (others => '0');

  component mig_rd_data_fifo_0
    port(
      clk                  : in  std_logic;
      reset                : in  std_logic;
      read_en_delayed_rise : in  std_logic;
      read_en_delayed_fall : in  std_logic;
      first_rising         : in  std_logic;
      read_data_rise       : in  std_logic_vector(MEMORY_WIDTH - 1 downto 0);
      read_data_fall       : in  std_logic_vector(MEMORY_WIDTH - 1 downto 0);
      fifo_rd_enable       : in  std_logic;
      read_data_fifo_rise  : out std_logic_vector(MEMORY_WIDTH - 1 downto 0);
      read_data_fifo_fall  : out std_logic_vector(MEMORY_WIDTH - 1 downto 0);
      read_data_valid      : out std_logic
      );
  end component;

  component mig_pattern_compare8
    port(
      clk            : in  std_logic;
      rst            : in  std_logic;
      calib_done     : in  std_logic;
      ctrl_rden      : in  std_logic;
      rd_data_rise   : in  std_logic_vector(7 downto 0);
      rd_data_fall   : in  std_logic_vector(7 downto 0);
      per_bit_skew   : in  std_logic_vector(7 downto 0);
      comp_done      : out std_logic;
      comp_error     : out std_logic;
      first_rising   : out std_logic;
      rd_en_rise     : out std_logic;
      rd_en_fall     : out std_logic;
      cal_first_loop : out std_logic;
      delay_enable   : out std_logic_vector(7 downto 0)
      );
  end component;

  component mig_pattern_compare4
    port(
      clk            : in  std_logic;
      rst            : in  std_logic;
      calib_done     : in  std_logic;
      ctrl_rden      : in  std_logic;
      rd_data_rise   : in  std_logic_vector(3 downto 0);
      rd_data_fall   : in  std_logic_vector(3 downto 0);
      per_bit_skew   : in  std_logic_vector(3 downto 0);
      comp_done      : out std_logic;
      comp_error     : out std_logic;
      first_rising   : out std_logic;
      rd_en_rise     : out std_logic;
      rd_en_fall     : out std_logic;
      cal_first_loop : out std_logic;
      delay_enable   : out std_logic_vector(3 downto 0)

      );
  end component;

  signal cal_first_loop_i     : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
  signal cal_first_loop_r2    : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
  signal calib_done           : std_logic;
  signal comp_done_i          : std_logic;
  signal comp_error           : std_logic;
  signal comp_error_i         : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
  signal comp_done_int        : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
  signal gen_cal_loop         : std_logic;
  signal gen_comp_err         : std_logic;
  signal first_rising_int     : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
  signal fifo_rd_enable1      : std_logic;
  signal fifo_rd_enable       : std_logic;
  signal rst_r                : std_logic;
  signal read_data_valid_i    : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
  signal read_en_delayed_rise : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
  signal read_en_delayed_fall : std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);

  attribute equivalent_register_removal : string;
  attribute syn_preserve                : boolean;
  attribute equivalent_register_removal of rst_r : signal is "no";
  attribute syn_preserve of rst_r                : signal is true;

begin

  --***************************************************************************

  --***************************************************************************
  -- Debug output ("dbg_*")
  -- NOTES:
  --  1. All debug outputs coming out of RD_DATA are clocked off CLK0,
  --     although they are also static after calibration is complete. This
  --     means the user can either connect them to a Chipscope ILA, or to
  --     either a sync/async VIO input block. Using an async VIO has the
  --     advantage of not requiring these paths to meet cycle-to-cycle timing.
  --  2. The widths of most of these debug buses are dependent on the # of
  --     DQS/DQ bits (e.g. first_rising = (# of DQS bits)
  -- SIGNAL DESCRIPTION:
  --  1. first_rising:   # of DQS bits - asserted for each byte if rise and 
  --                     fall data arrive "staggered" w/r to each other.
  --  2. cal_first_loop: # of DQS bits - deasserted ('0' )for corresponding byte 
  --                     if pattern calibrationn is not completed on 
  --                     first pattern read command.
  --  3. comp_done:      #of DQS bits - each one asserted as pattern calibration 
  --                     (second stage) is completed for corresponding byte.
  --  4. comp_error:     # of DQS bits - each one asserted when a calibration 
  --                     error encountered in pattern calibrtation stage for 
  --                     corresponding byte. 
  --***************************************************************************

  dbg_first_rising   <= first_rising_int;
  dbg_cal_first_loop <= cal_first_loop_r2;
  dbg_comp_done      <= comp_done_int;
  dbg_comp_error     <= comp_error_i;

  read_data_valid    <= read_data_valid_i(0);

  comp_done_i        <=  comp_done_int(0)  and  comp_done_int(1)  and  comp_done_int(2)  and  comp_done_int(3)  and  comp_done_int(4)  and  comp_done_int(5)  and  comp_done_int(6)  and  comp_done_int(7)  and  comp_done_int(8)  and  comp_done_int(9)  and  comp_done_int(10)  and  comp_done_int(11)  and  comp_done_int(12)  and  comp_done_int(13)  and  comp_done_int(14)  and  comp_done_int(15)  and  comp_done_int(16)  and  comp_done_int(17) ;
  comp_done          <= comp_done_i;

  pattern_0 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(3 downto 0),
            rd_data_fall    =>   read_data_fall(3 downto 0),
            per_bit_skew    =>   per_bit_skew(3 downto 0),
            delay_enable    =>   delay_enable(3 downto 0),
            comp_error      =>   comp_error_i(0),
            comp_done       =>   comp_done_int(0),
            first_rising    =>   first_rising_int(0),
            rd_en_rise      =>   read_en_delayed_rise(0),
            rd_en_fall      =>   read_en_delayed_fall(0),
            cal_first_loop  =>   cal_first_loop_i(0)
                    );

pattern_1 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(7 downto 4),
            rd_data_fall    =>   read_data_fall(7 downto 4),
            per_bit_skew    =>   per_bit_skew(7 downto 4),
            delay_enable    =>   delay_enable(7 downto 4),
            comp_error      =>   comp_error_i(1),
            comp_done       =>   comp_done_int(1),
            first_rising    =>   first_rising_int(1),
            rd_en_rise      =>   read_en_delayed_rise(1),
            rd_en_fall      =>   read_en_delayed_fall(1),
            cal_first_loop  =>   cal_first_loop_i(1)
                    );

pattern_2 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(11 downto 8),
            rd_data_fall    =>   read_data_fall(11 downto 8),
            per_bit_skew    =>   per_bit_skew(11 downto 8),
            delay_enable    =>   delay_enable(11 downto 8),
            comp_error      =>   comp_error_i(2),
            comp_done       =>   comp_done_int(2),
            first_rising    =>   first_rising_int(2),
            rd_en_rise      =>   read_en_delayed_rise(2),
            rd_en_fall      =>   read_en_delayed_fall(2),
            cal_first_loop  =>   cal_first_loop_i(2)
                    );

pattern_3 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(15 downto 12),
            rd_data_fall    =>   read_data_fall(15 downto 12),
            per_bit_skew    =>   per_bit_skew(15 downto 12),
            delay_enable    =>   delay_enable(15 downto 12),
            comp_error      =>   comp_error_i(3),
            comp_done       =>   comp_done_int(3),
            first_rising    =>   first_rising_int(3),
            rd_en_rise      =>   read_en_delayed_rise(3),
            rd_en_fall      =>   read_en_delayed_fall(3),
            cal_first_loop  =>   cal_first_loop_i(3)
                    );

pattern_4 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(19 downto 16),
            rd_data_fall    =>   read_data_fall(19 downto 16),
            per_bit_skew    =>   per_bit_skew(19 downto 16),
            delay_enable    =>   delay_enable(19 downto 16),
            comp_error      =>   comp_error_i(4),
            comp_done       =>   comp_done_int(4),
            first_rising    =>   first_rising_int(4),
            rd_en_rise      =>   read_en_delayed_rise(4),
            rd_en_fall      =>   read_en_delayed_fall(4),
            cal_first_loop  =>   cal_first_loop_i(4)
                    );

pattern_5 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(23 downto 20),
            rd_data_fall    =>   read_data_fall(23 downto 20),
            per_bit_skew    =>   per_bit_skew(23 downto 20),
            delay_enable    =>   delay_enable(23 downto 20),
            comp_error      =>   comp_error_i(5),
            comp_done       =>   comp_done_int(5),
            first_rising    =>   first_rising_int(5),
            rd_en_rise      =>   read_en_delayed_rise(5),
            rd_en_fall      =>   read_en_delayed_fall(5),
            cal_first_loop  =>   cal_first_loop_i(5)
                    );

pattern_6 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(27 downto 24),
            rd_data_fall    =>   read_data_fall(27 downto 24),
            per_bit_skew    =>   per_bit_skew(27 downto 24),
            delay_enable    =>   delay_enable(27 downto 24),
            comp_error      =>   comp_error_i(6),
            comp_done       =>   comp_done_int(6),
            first_rising    =>   first_rising_int(6),
            rd_en_rise      =>   read_en_delayed_rise(6),
            rd_en_fall      =>   read_en_delayed_fall(6),
            cal_first_loop  =>   cal_first_loop_i(6)
                    );

pattern_7 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(31 downto 28),
            rd_data_fall    =>   read_data_fall(31 downto 28),
            per_bit_skew    =>   per_bit_skew(31 downto 28),
            delay_enable    =>   delay_enable(31 downto 28),
            comp_error      =>   comp_error_i(7),
            comp_done       =>   comp_done_int(7),
            first_rising    =>   first_rising_int(7),
            rd_en_rise      =>   read_en_delayed_rise(7),
            rd_en_fall      =>   read_en_delayed_fall(7),
            cal_first_loop  =>   cal_first_loop_i(7)
                    );

pattern_8 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(35 downto 32),
            rd_data_fall    =>   read_data_fall(35 downto 32),
            per_bit_skew    =>   per_bit_skew(35 downto 32),
            delay_enable    =>   delay_enable(35 downto 32),
            comp_error      =>   comp_error_i(8),
            comp_done       =>   comp_done_int(8),
            first_rising    =>   first_rising_int(8),
            rd_en_rise      =>   read_en_delayed_rise(8),
            rd_en_fall      =>   read_en_delayed_fall(8),
            cal_first_loop  =>   cal_first_loop_i(8)
                    );

pattern_9 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(39 downto 36),
            rd_data_fall    =>   read_data_fall(39 downto 36),
            per_bit_skew    =>   per_bit_skew(39 downto 36),
            delay_enable    =>   delay_enable(39 downto 36),
            comp_error      =>   comp_error_i(9),
            comp_done       =>   comp_done_int(9),
            first_rising    =>   first_rising_int(9),
            rd_en_rise      =>   read_en_delayed_rise(9),
            rd_en_fall      =>   read_en_delayed_fall(9),
            cal_first_loop  =>   cal_first_loop_i(9)
                    );

pattern_10 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(43 downto 40),
            rd_data_fall    =>   read_data_fall(43 downto 40),
            per_bit_skew    =>   per_bit_skew(43 downto 40),
            delay_enable    =>   delay_enable(43 downto 40),
            comp_error      =>   comp_error_i(10),
            comp_done       =>   comp_done_int(10),
            first_rising    =>   first_rising_int(10),
            rd_en_rise      =>   read_en_delayed_rise(10),
            rd_en_fall      =>   read_en_delayed_fall(10),
            cal_first_loop  =>   cal_first_loop_i(10)
                    );

pattern_11 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(47 downto 44),
            rd_data_fall    =>   read_data_fall(47 downto 44),
            per_bit_skew    =>   per_bit_skew(47 downto 44),
            delay_enable    =>   delay_enable(47 downto 44),
            comp_error      =>   comp_error_i(11),
            comp_done       =>   comp_done_int(11),
            first_rising    =>   first_rising_int(11),
            rd_en_rise      =>   read_en_delayed_rise(11),
            rd_en_fall      =>   read_en_delayed_fall(11),
            cal_first_loop  =>   cal_first_loop_i(11)
                    );

pattern_12 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(51 downto 48),
            rd_data_fall    =>   read_data_fall(51 downto 48),
            per_bit_skew    =>   per_bit_skew(51 downto 48),
            delay_enable    =>   delay_enable(51 downto 48),
            comp_error      =>   comp_error_i(12),
            comp_done       =>   comp_done_int(12),
            first_rising    =>   first_rising_int(12),
            rd_en_rise      =>   read_en_delayed_rise(12),
            rd_en_fall      =>   read_en_delayed_fall(12),
            cal_first_loop  =>   cal_first_loop_i(12)
                    );

pattern_13 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(55 downto 52),
            rd_data_fall    =>   read_data_fall(55 downto 52),
            per_bit_skew    =>   per_bit_skew(55 downto 52),
            delay_enable    =>   delay_enable(55 downto 52),
            comp_error      =>   comp_error_i(13),
            comp_done       =>   comp_done_int(13),
            first_rising    =>   first_rising_int(13),
            rd_en_rise      =>   read_en_delayed_rise(13),
            rd_en_fall      =>   read_en_delayed_fall(13),
            cal_first_loop  =>   cal_first_loop_i(13)
                    );

pattern_14 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(59 downto 56),
            rd_data_fall    =>   read_data_fall(59 downto 56),
            per_bit_skew    =>   per_bit_skew(59 downto 56),
            delay_enable    =>   delay_enable(59 downto 56),
            comp_error      =>   comp_error_i(14),
            comp_done       =>   comp_done_int(14),
            first_rising    =>   first_rising_int(14),
            rd_en_rise      =>   read_en_delayed_rise(14),
            rd_en_fall      =>   read_en_delayed_fall(14),
            cal_first_loop  =>   cal_first_loop_i(14)
                    );

pattern_15 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(63 downto 60),
            rd_data_fall    =>   read_data_fall(63 downto 60),
            per_bit_skew    =>   per_bit_skew(63 downto 60),
            delay_enable    =>   delay_enable(63 downto 60),
            comp_error      =>   comp_error_i(15),
            comp_done       =>   comp_done_int(15),
            first_rising    =>   first_rising_int(15),
            rd_en_rise      =>   read_en_delayed_rise(15),
            rd_en_fall      =>   read_en_delayed_fall(15),
            cal_first_loop  =>   cal_first_loop_i(15)
                    );

pattern_16 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(67 downto 64),
            rd_data_fall    =>   read_data_fall(67 downto 64),
            per_bit_skew    =>   per_bit_skew(67 downto 64),
            delay_enable    =>   delay_enable(67 downto 64),
            comp_error      =>   comp_error_i(16),
            comp_done       =>   comp_done_int(16),
            first_rising    =>   first_rising_int(16),
            rd_en_rise      =>   read_en_delayed_rise(16),
            rd_en_fall      =>   read_en_delayed_fall(16),
            cal_first_loop  =>   cal_first_loop_i(16)
                    );

pattern_17 : mig_pattern_compare4
 port map (
            clk             =>   clk,
            rst             =>   reset,
            calib_done      =>   calib_done,
            ctrl_rden       =>   ctrl_rden,
            rd_data_rise    =>   read_data_rise(71 downto 68),
            rd_data_fall    =>   read_data_fall(71 downto 68),
            per_bit_skew    =>   per_bit_skew(71 downto 68),
            delay_enable    =>   delay_enable(71 downto 68),
            comp_error      =>   comp_error_i(17),
            comp_done       =>   comp_done_int(17),
            first_rising    =>   first_rising_int(17),
            rd_en_rise      =>   read_en_delayed_rise(17),
            rd_en_fall      =>   read_en_delayed_fall(17),
            cal_first_loop  =>   cal_first_loop_i(17)
                    );


  process(clk)
  begin
    if(clk'event and clk = '1') then
      rst_r <= reset;
    end if;
  end process;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      calib_done <= comp_done_i;
    end if;
  end process;

  --***************************************************************************
  -- cal_first_loop: Flag for controller to issue a second pattern calibration
  -- read if the first one does not result in a successful calibration.
  -- Second pattern calibration command is issued to all DQS sets by NANDing
  -- of CAL_FIRST_LOOP from all PATTERN_COMPARE modules. The set calibrated on
  -- first pattern calibration command ignores the second calibration command,
  -- since it will in CAL_DONE state (in PATTERN_COMPARE module) for the ones
  -- calibrated. The set that is not calibrated on first pattern calibration
  -- command, is calibrated on second calibration command.
  --***************************************************************************

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      cal_first_loop_r2 <= cal_first_loop_i;
    end if;
  end process;

  gen_cal_loop <= '1' when (cal_first_loop_i = ONES) else '0';

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (rst_r = '1') then
        cal_first_loop <= '1';
      elsif ((cal_first_loop_r2 /= cal_first_loop_i) and ((not (gen_cal_loop)) = '1')) then
        cal_first_loop <= '0';
      else
        cal_first_loop <= '1';
      end if;
    end if;
  end process;

  gen_comp_err <= '1' when (comp_error_i /= ZEROS) else '0';

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      comp_error <= gen_comp_err;
    end if;
  end process;

  process(clk)
  begin
    if(clk'event and clk = '1') then
      if(rst_r = '1') then
        fifo_rd_enable1 <= '0';
        fifo_rd_enable  <= '0';
      else
        fifo_rd_enable1 <= read_en_delayed_rise(0);
        fifo_rd_enable  <= fifo_rd_enable1;
      end if;
    end if;
  end process;

  --***************************************************************************
  -- rd_data_fifo instances
  --***************************************************************************
  gen_fifo: for fifo_i in 0 to DATA_STROBE_WIDTH-1 generate
    u_rd_fifo : mig_rd_data_fifo_0
      port map (
        clk                  => clk,
        reset                => reset,
        fifo_rd_enable       => fifo_rd_enable,
        read_en_delayed_rise => read_en_delayed_rise(fifo_i),
        read_en_delayed_fall => read_en_delayed_fall(fifo_i),
        first_rising         => first_rising_int(fifo_i),
        read_data_rise       => read_data_rise((MEMORY_WIDTH*(fifo_i+1))-1
                                               downto MEMORY_WIDTH*fifo_i),
        read_data_fall       => read_data_fall((MEMORY_WIDTH*(fifo_i+1))-1
                                               downto MEMORY_WIDTH*fifo_i),
        read_data_fifo_rise  => read_data_fifo_rise((MEMORY_WIDTH*(fifo_i+1))-1
                                                    downto MEMORY_WIDTH*fifo_i),
        read_data_fifo_fall  => read_data_fifo_fall((MEMORY_WIDTH*(fifo_i+1))-1
                                                    downto MEMORY_WIDTH*fifo_i),
        read_data_valid      => read_data_valid_i(fifo_i)
        );
  end generate;

end arch;
