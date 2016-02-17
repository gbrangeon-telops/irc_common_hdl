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
--  /   /        Filename           : mig_user_interface_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Interfaces with the user. The user should provide the data and
--              various commands.
-- Revision History:
--   Rev 1.1 - Changes for V4 no edge straddle calibration scheme. Added
--             PER_BIT_SKEW input, DELAY_ENABLE outputs.
--             Various other changes. JYO. 6/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_user_interface_0 is
  port(
    clk                : in  std_logic;
    clk90              : in  std_logic;
    reset              : in  std_logic;
    ctrl_rden          : in  std_logic;
    per_bit_skew       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    init_done          : in  std_logic;
    read_data_rise     : in  std_logic_vector((DATA_WIDTH - 1) downto 0);
    read_data_fall     : in  std_logic_vector((DATA_WIDTH - 1) downto 0);
    read_data_fifo_out : out std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    comp_done          : out std_logic;
    read_data_valid    : out std_logic;
    af_empty           : out std_logic;
    af_almost_full     : out std_logic;
    app_af_addr        : in  std_logic_vector(35 downto 0);
    app_af_wren        : in  std_logic;
    ctrl_af_rden       : in  std_logic;
    af_addr            : out std_logic_vector(35 downto 0);
    app_wdf_data       : in  std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    app_mask_data      : in  std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
    app_wdf_wren       : in  std_logic;
    ctrl_wdf_rden      : in  std_logic;
    delay_enable       : out std_logic_vector(DATA_WIDTH-1 downto 0);
    wdf_data           : out std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    mask_data          : out std_logic_vector;
    wdf_almost_full    : out std_logic;
    cal_first_loop     : out std_logic;

    -- Debug Signals
    dbg_first_rising   : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_cal_first_loop : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_comp_done      : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_comp_error     : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0)
    );
end mig_user_interface_0;

architecture arch of mig_user_interface_0 is

  component mig_rd_data_0
    port(
      clk                 : in  std_logic;
      reset               : in  std_logic;
      ctrl_rden           : in  std_logic;
      per_bit_skew        : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      read_data_rise      : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      read_data_fall      : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
      read_data_fifo_rise : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      read_data_fifo_fall : out std_logic_vector(DATA_WIDTH - 1 downto 0);
      delay_enable        : out std_logic_vector(DATA_WIDTH-1 downto 0);
      comp_done           : out std_logic;
      cal_first_loop      : out std_logic;
      read_data_valid     : out std_logic;
      -- Debug Signals
      dbg_first_rising    : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_cal_first_loop  : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_comp_done       : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_comp_error      : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0)
      );
  end component;

  component mig_backend_fifos_0
    port(
      clk0            : in  std_logic;
      clk90           : in  std_logic;
      rst             : in  std_logic;
      app_af_addr     : in  std_logic_vector(35 downto 0);
      app_af_wren     : in  std_logic;
      ctrl_af_rden    : in  std_logic;
      init_done       : in  std_logic;
      af_addr         : out std_logic_vector(35 downto 0);
      af_empty        : out std_logic;
      af_almost_full  : out std_logic;
      app_wdf_data    : in  std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
      app_mask_data   : in  std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
      app_wdf_wren    : in  std_logic;
      ctrl_wdf_rden   : in  std_logic;
      wdf_data        : out std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
      mask_data       : out std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
      wdf_almost_full : out std_logic
      );
  end component;

  signal read_data_fifo_rise_i : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal read_data_fifo_fall_i : std_logic_vector((DATA_WIDTH - 1) downto 0);

begin

  --***************************************************************************

  read_data_fifo_out <= read_data_fifo_rise_i & read_data_fifo_fall_i;

  rd_data_00 : mig_rd_data_0
    port map (
      clk                 => clk,
      reset               => reset,
      ctrl_rden           => ctrl_rden,
      per_bit_skew        => per_bit_skew,
      read_data_rise      => read_data_rise,
      read_data_fall      => read_data_fall,
      read_data_fifo_rise => read_data_fifo_rise_i,
      read_data_fifo_fall => read_data_fifo_fall_i,
      delay_enable        =>  delay_enable,
      comp_done           => comp_done,
      cal_first_loop      => cal_first_loop,
      read_data_valid     => read_data_valid,

      -- Debug Signals
      dbg_first_rising    => dbg_first_rising,
      dbg_cal_first_loop  => dbg_cal_first_loop,
      dbg_comp_done       => dbg_comp_done,
      dbg_comp_error      => dbg_comp_error
      );

  backend_fifos_00 : mig_backend_fifos_0
    port map (
      clk0            => clk,
      clk90           => clk90,
      rst             => reset,
      app_af_addr     => app_af_addr,
      app_af_wren     => app_af_wren,
      ctrl_af_rden    => ctrl_af_rden,
      init_done       => init_done,
      af_addr         => af_addr,
      af_empty        => af_empty,
      af_almost_full  => af_almost_full,
      app_wdf_data    => app_wdf_data,
      app_mask_data   => app_mask_data,
      app_wdf_wren    => app_wdf_wren,
      ctrl_wdf_rden   => ctrl_wdf_rden,
      wdf_data        => wdf_data,
      mask_data       => mask_data,
      wdf_almost_full => wdf_almost_full
      );

end arch;
