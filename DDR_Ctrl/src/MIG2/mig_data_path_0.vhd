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
--  /   /        Filename           : mig_data_path_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the tap logic and the data write modules. Gives
--              the rise and the fall data and the calibration information for
--              IDELAY elements.
-- Revision History:
--   Rev 1.1 - Changes for V4 no edge straddle calibration scheme. Added
--             PER_BIT_SKEW output. Various other changes. JYO. 05/26/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_data_path_0 is
  port(
    clk                             : in std_logic;
    clk90                           : in std_logic;
    reset0                          : in std_logic;
    reset90                         : in std_logic;
    ctrl_dummyread_start            : in std_logic;
    wdf_data                        : in std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    mask_data                       : in std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
    ctrl_wren                       : in std_logic;
    ctrl_dqs_rst                    : in std_logic;
    ctrl_dqs_en                     : in std_logic;
    calibration_dq                  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    data_idelay_inc                 : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    data_idelay_ce                  : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    data_idelay_rst                 : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    sel_done                        : out std_logic;
    dqs_rst                         : out std_logic;
    dqs_en                          : out std_logic;
    wr_en                           : out std_logic;
    wr_data_rise                    : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    wr_data_fall                    : out std_logic_vector((DATA_WIDTH - 1) downto 0);
    mask_data_rise                  : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    mask_data_fall                  : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    per_bit_skew                    : out std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Debug Signals
    dbg_idel_up_all                 : in  std_logic;
    dbg_idel_down_all               : in  std_logic;
    dbg_idel_up_dq                  : in  std_logic;
    dbg_idel_down_dq                : in  std_logic;
    dbg_sel_idel_dq                 : in  std_logic_vector(DQ_BITS-1 downto 0);
    dbg_sel_all_idel_dq             : in  std_logic;
    dbg_calib_dq_tap_cnt            : out std_logic_vector(((6*DATA_WIDTH)-1) downto 0);
    dbg_data_tap_inc_done           : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_sel_done                    : out std_logic
   );
end mig_data_path_0;

architecture arch of mig_data_path_0 is

  component mig_data_write_0
    port(
      clk                           : in std_logic;
      clk90                         : in std_logic;
      reset90                       : in std_logic;
      wdf_data                      : in std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
      mask_data                     : in std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
      ctrl_wren                     : in std_logic;
      ctrl_dqs_rst                  : in std_logic;
      ctrl_dqs_en                   : in std_logic;
      dqs_rst                       : out std_logic;
      dqs_en                        : out std_logic;
      wr_en                         : out std_logic;
      wr_data_rise                  : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      wr_data_fall                  : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      mask_data_rise                : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
      mask_data_fall                : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0)
      );
  end component;

  component mig_tap_logic_0
    port(
      clk                           : in std_logic;
      reset0                        : in std_logic;
      ctrl_dummyread_start          : in std_logic;
      calibration_dq                : in std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_inc               : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_ce                : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_rst               : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      sel_done                      : out std_logic;
      per_bit_skew                  : out std_logic_vector(DATA_WIDTH-1 downto 0);

      -- Debug Signals
      dbg_idel_up_all               : in  std_logic;
      dbg_idel_down_all             : in  std_logic;
      dbg_idel_up_dq                : in  std_logic;
      dbg_idel_down_dq              : in  std_logic;
      dbg_sel_idel_dq               : in  std_logic_vector(DQ_BITS-1 downto 0);
      dbg_sel_all_idel_dq           : in  std_logic;
      dbg_calib_dq_tap_cnt          : out std_logic_vector(((6*DATA_WIDTH)-1) downto 0);
      dbg_data_tap_inc_done         : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_sel_done                  : out std_logic

    );
  end component;

begin

  --***************************************************************************

  data_write_10: mig_data_write_0
    port map (
      clk                           => clk,
      clk90                         => clk90,
      reset90                       => reset90,
      wdf_data                      => wdf_data,
      mask_data                     => mask_data,
      ctrl_wren                     => ctrl_wren,
      ctrl_dqs_rst                  => ctrl_dqs_rst,
      ctrl_dqs_en                   => ctrl_dqs_en,
      dqs_rst                       => dqs_rst,
      dqs_en                        => dqs_en,
      wr_en                         => wr_en,
      wr_data_rise                  => wr_data_rise,
      wr_data_fall                  => wr_data_fall,
      mask_data_rise                => mask_data_rise,
      mask_data_fall                => mask_data_fall
      );

  tap_logic_00: mig_tap_logic_0
    port map (
      clk                           => clk,
      reset0                        => reset0,
      ctrl_dummyread_start          => ctrl_dummyread_start,
      calibration_dq                => calibration_dq,
      data_idelay_inc               => data_idelay_inc,
      data_idelay_ce                => data_idelay_ce,
      data_idelay_rst               => data_idelay_rst,
      sel_done                      => sel_done,
      per_bit_skew                  => per_bit_skew,

      -- Debug Signals
      dbg_idel_up_all               => dbg_idel_up_all,
      dbg_idel_down_all             => dbg_idel_down_all,
      dbg_idel_up_dq                => dbg_idel_up_dq,
      dbg_idel_down_dq              => dbg_idel_down_dq,
      dbg_sel_idel_dq               => dbg_sel_idel_dq,
      dbg_sel_all_idel_dq           => dbg_sel_all_idel_dq,
      dbg_calib_dq_tap_cnt          => dbg_calib_dq_tap_cnt,
      dbg_data_tap_inc_done         => dbg_data_tap_inc_done,
      dbg_sel_done                  => dbg_sel_done

      );

end arch;
