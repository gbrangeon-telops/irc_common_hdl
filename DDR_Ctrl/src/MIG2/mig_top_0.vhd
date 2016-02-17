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
--  /   /        Filename           : mig_top_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the main design logic of memory interface and
--              interfaces with the user.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_top_0 is
  port(
    clk_0                         : in    std_logic;
    clk_90                        : in    std_logic;
    sys_rst                       : in    std_logic;
    sys_rst90                     : in    std_logic;
    ddr_ras_n                     : out   std_logic;
    ddr_cas_n                     : out   std_logic;
    ddr_we_n                      : out   std_logic;
    ddr_cke                       : out   std_logic_vector((CKE_WIDTH - 1) downto 0);
    ddr_cs_n                      : out   std_logic_vector((CS_WIDTH - 1) downto 0);
    ddr_dq                        : inout std_logic_vector((DATA_WIDTH - 1) downto 0);
    ddr_dqs                       : inout std_logic_vector((DATA_STROBE_WIDTH - 1) downto 0);
    ddr_dm                        : out   std_logic_vector((DATA_MASK_WIDTH-1) downto 0);
    app_mask_data                 : in    std_logic_vector((DATA_MASK_WIDTH*2 -1) downto 0);
ddr_reset_n            : out std_logic;
    ddr_ck                        : out   std_logic_vector((CLK_WIDTH - 1) downto 0);
    ddr_ck_n                      : out   std_logic_vector((CLK_WIDTH - 1) downto 0);
    ddr_ba                        : out   std_logic_vector((BANK_ADDRESS - 1) downto 0);
    ddr_a                         : out   std_logic_vector((ROW_ADDRESS - 1) downto 0);
    wdf_almost_full               : out   std_logic;
    af_almost_full                : out   std_logic;
    burst_length_div2             : out   std_logic_vector(2 downto 0);
    read_data_valid               : out   std_logic;
    read_data_fifo_out            : out   std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    app_af_addr                   : in    std_logic_vector(35 downto 0);
    app_af_wren                   : in    std_logic;
    app_wdf_data                  : in    std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
    app_wdf_wren                  : in    std_logic;
    init_done                     : out   std_logic;
    clk_tb                        : out   std_logic;
    reset_tb                      : out   std_logic;

    -- Debug Signals
    dbg_idel_up_all               : in  std_logic;
    dbg_idel_down_all             : in  std_logic;
    dbg_idel_up_dq                : in  std_logic;
    dbg_idel_down_dq              : in  std_logic;
    dbg_sel_idel_dq               : in  std_logic_vector(DQ_BITS-1 downto 0);
    dbg_sel_all_idel_dq           : in  std_logic;
    dbg_calib_dq_tap_cnt          : out std_logic_vector(((6*DATA_WIDTH)-1) downto 0);
    dbg_data_tap_inc_done         : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_sel_done                  : out std_logic;
    dbg_first_rising              : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_cal_first_loop            : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_comp_done                 : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_comp_error                : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
    dbg_init_done                 : out std_logic
    );
end mig_top_0;

architecture arch of mig_top_0 is

  component mig_data_path_0
    port(
      clk                         : in  std_logic;
      clk90                       : in  std_logic;
      reset0                      : in  std_logic;
      reset90                     : in  std_logic;
      ctrl_dummyread_start        : in  std_logic;
      wdf_data                    : in  std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
      mask_data                   : in  std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
      ctrl_wren                   : in  std_logic;
      ctrl_dqs_rst                : in  std_logic;
      ctrl_dqs_en                 : in  std_logic;
      data_idelay_inc             : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_ce              : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_rst             : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      sel_done                    : out std_logic;
      dqs_rst                     : out std_logic;
      dqs_en                      : out std_logic;
      wr_en                       : out std_logic;
      calibration_dq              : in  std_logic_vector((DATA_WIDTH - 1) downto 0);
      wr_data_rise                : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      wr_data_fall                : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      per_bit_skew                : out std_logic_vector(DATA_WIDTH-1 downto 0);
      mask_data_rise              : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
      mask_data_fall              : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);

      -- Debug Signals
      dbg_idel_up_all             : in  std_logic;
      dbg_idel_down_all           : in  std_logic;
      dbg_idel_up_dq              : in  std_logic;
      dbg_idel_down_dq            : in  std_logic;
      dbg_sel_idel_dq             : in  std_logic_vector(DQ_BITS-1 downto 0);
      dbg_sel_all_idel_dq         : in  std_logic;
      dbg_calib_dq_tap_cnt        : out std_logic_vector(((6*DATA_WIDTH)-1) downto 0);
      dbg_data_tap_inc_done       : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_sel_done                : out std_logic
   );
  end component;

  component mig_iobs_0
    port(
      ddr_ck                      : out   std_logic_vector((CLK_WIDTH - 1) downto 0);
      ddr_ck_n                    : out   std_logic_vector((CLK_WIDTH - 1) downto 0);
      clk                         : in    std_logic;
      clk90                       : in    std_logic;
      reset0                      : in    std_logic;
      data_idelay_inc             : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_ce              : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_rst             : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
      delay_enable                : in    std_logic_vector(DATA_WIDTH-1 downto 0);
      dqs_rst                     : in    std_logic;
      dqs_en                      : in    std_logic;
      wr_en                       : in    std_logic;
      wr_data_rise                : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
      wr_data_fall                : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
      mask_data_rise              : in    std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
      mask_data_fall              : in    std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
      rd_data_rise                : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
      rd_data_fall                : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
      ddr_dq                      : inout std_logic_vector((DATA_WIDTH - 1) downto 0);
      ddr_dqs                     : inout std_logic_vector((DATA_STROBE_WIDTH - 1) downto 0);
      ddr_dm                      : out   std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
      ctrl_ddr_address            : in    std_logic_vector((ROW_ADDRESS - 1) downto 0);
      ctrl_ddr_ba                 : in    std_logic_vector((BANK_ADDRESS - 1) downto 0);
      ctrl_ddr_ras_l              : in    std_logic;
      ctrl_ddr_cas_l              : in    std_logic;
      ctrl_ddr_we_l               : in    std_logic;
      ctrl_ddr_cs_l               : in    std_logic_vector((CS_WIDTH - 1) downto 0);
      ctrl_ddr_cke                : in    std_logic_vector((CKE_WIDTH - 1) downto 0);
      ddr_address                 : out   std_logic_vector((ROW_ADDRESS - 1) downto 0);
      ddr_ba                      : out   std_logic_vector((BANK_ADDRESS - 1) downto 0);
      ddr_ras_l                   : out   std_logic;
      ddr_cas_l                   : out   std_logic;
      ddr_we_l                    : out   std_logic;
      ddr_cke                     : out   std_logic_vector((CKE_WIDTH - 1) downto 0);
      ddr_cs_l                    : out   std_logic_vector((CS_WIDTH - 1) downto 0)
      );
  end component;

  component mig_user_interface_0
    port(
      clk                         : in  std_logic;
      clk90                       : in  std_logic;
      reset                       : in  std_logic;
      ctrl_rden                   : in  std_logic;
      init_done                   : in  std_logic;
      per_bit_skew                : in  std_logic_vector(DATA_WIDTH-1 downto 0);
      read_data_rise              : in  std_logic_vector((DATA_WIDTH - 1) downto 0);
      read_data_fall              : in  std_logic_vector((DATA_WIDTH - 1) downto 0);
      read_data_fifo_out          : out std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
      comp_done                   : out std_logic;
      read_data_valid             : out std_logic;
      af_empty                    : out std_logic;
      af_almost_full              : out std_logic;
      app_af_addr                 : in  std_logic_vector(35 downto 0);
      app_af_wren                 : in  std_logic;
      ctrl_af_rden                : in  std_logic;
      af_addr                     : out std_logic_vector(35 downto 0);
      app_wdf_data                : in  std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
      app_mask_data               : in  std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
      app_wdf_wren                : in  std_logic;
      ctrl_wdf_rden               : in  std_logic;
      wdf_data                    : out std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
      mask_data                   : out std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
      wdf_almost_full             : out std_logic;
      delay_enable                : out std_logic_vector(DATA_WIDTH-1 downto 0);
      cal_first_loop              : out std_logic;

      -- Debug Signals
      dbg_first_rising            : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_cal_first_loop          : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_comp_done               : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0);
      dbg_comp_error              : out std_logic_vector(DATA_STROBE_WIDTH-1 downto 0)
      );
  end component;

  component mig_ddr_controller_0
    port(
      clk_0                       : in  std_logic;
      rst                         : in  std_logic;
      af_addr                     : in  std_logic_vector(35 downto 0);
      af_empty                    : in  std_logic;
      comp_done                   : in  std_logic;
      phy_dly_slct_done           : in  std_logic;
      ctrl_dummyread_start        : out std_logic;
      ctrl_af_rden                : out std_logic;
      ctrl_wdf_rden               : out std_logic;
      ctrl_dqs_rst                : out std_logic;
      ctrl_dqs_en                 : out std_logic;
      ctrl_wren                   : out std_logic;
      ctrl_rden                   : out std_logic;
      ctrl_ddr_address            : out std_logic_vector((ROW_ADDRESS - 1) downto 0);
      ctrl_ddr_ba                 : out std_logic_vector((BANK_ADDRESS - 1) downto 0);
      ctrl_ddr_ras_l              : out std_logic;
      ctrl_ddr_cas_l              : out std_logic;
      ctrl_ddr_we_l               : out std_logic;
      ctrl_ddr_cs_l               : out std_logic_vector((CS_WIDTH - 1) downto 0);
      ctrl_ddr_cke                : out std_logic_vector((CKE_WIDTH - 1) downto 0);
      init_done                   : out std_logic;
      cal_first_loop              : in  std_logic;
      burst_length_div2           : out std_logic_vector(2 downto 0);

      -- Debug Signals
      dbg_init_done               : out std_logic

      );
  end component;

  signal wr_df_data               : std_logic_vector((DATA_WIDTH*2 - 1) downto 0);
  signal mask_df_data             : std_logic_vector((DATA_MASK_WIDTH*2 - 1) downto 0);
  signal rd_data_rise             : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal rd_data_fall             : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal af_empty_w               : std_logic;
  signal dq_tap_sel_done          : std_logic;
  signal af_addr                  : std_logic_vector(35 downto 0);
  signal ctrl_af_rden             : std_logic;
  signal ctrl_wr_df_rden          : std_logic;
  signal ctrl_dummy_rden          : std_logic;
  signal ctrl_dqs_enable          : std_logic;
  signal ctrl_dqs_reset           : std_logic;
  signal ctrl_wr_en               : std_logic;
  signal ctrl_rden                : std_logic;
  signal data_idelay_inc          : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal data_idelay_ce           : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal data_idelay_rst          : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal wr_en                    : std_logic;
  signal dqs_rst                  : std_logic;
  signal dqs_en                   : std_logic;
  signal wr_data_rise             : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal wr_data_fall             : std_logic_vector((DATA_WIDTH - 1) downto 0);
  signal mask_data_fall           : std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
  signal mask_data_rise           : std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
  signal ctrl_ddr_address         : std_logic_vector((ROW_ADDRESS - 1) downto 0);
  signal ctrl_ddr_ba              : std_logic_vector((BANK_ADDRESS - 1) downto 0);
  signal ctrl_ddr_ras_l           : std_logic;
  signal ctrl_ddr_cas_l           : std_logic;
  signal ctrl_ddr_we_l            : std_logic;
  signal ctrl_ddr_cs_l            : std_logic_vector((CS_WIDTH - 1) downto 0);
  signal ctrl_ddr_cke             : std_logic_vector((CKE_WIDTH - 1) downto 0);
  signal comp_done                : std_logic;
  signal init_done_i              : std_logic;
  signal per_bit_skew             : std_logic_vector((DATA_WIDTH-1) downto 0);
  signal delay_enable             : std_logic_vector((DATA_WIDTH-1) downto 0);
  signal cal_first_loop           : std_logic;

begin

  --***************************************************************************

  clk_tb    <= clk_0;
  reset_tb  <= sys_rst;
  init_done <= init_done_i;


ddr_reset_n <= not sys_rst;
 

  data_path_00 : mig_data_path_0
    port map (
      clk                           => clk_0,
      clk90                         => clk_90,
      reset0                        => sys_rst,
      reset90                       => sys_rst90,
      ctrl_dummyread_start          => ctrl_dummy_rden,
      wdf_data                      => wr_df_data,
      mask_data                     => mask_df_data,
      ctrl_wren                     => ctrl_wr_en,
      ctrl_dqs_rst                  => ctrl_dqs_reset,
      ctrl_dqs_en                   => ctrl_dqs_enable,
      data_idelay_inc               => data_idelay_inc,
      data_idelay_ce                => data_idelay_ce,
      data_idelay_rst               => data_idelay_rst,
      sel_done                      => dq_tap_sel_done,
      dqs_rst                       => dqs_rst,
      dqs_en                        => dqs_en,
      wr_en                         => wr_en,
      calibration_dq                => rd_data_rise,
      per_bit_skew                  => per_bit_skew,
      wr_data_rise                  => wr_data_rise,
      wr_data_fall                  => wr_data_fall,
      mask_data_rise                => mask_data_rise,
      mask_data_fall                => mask_data_fall,

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

  iobs_00 : mig_iobs_0
    port map (
      ddr_ck                        => ddr_ck,
      ddr_ck_n                      => ddr_ck_n,
      clk                           => clk_0,
      clk90                         => clk_90,
      reset0                        => sys_rst,
      data_idelay_inc               => data_idelay_inc,
      data_idelay_ce                => data_idelay_ce,
      data_idelay_rst               => data_idelay_rst,
      delay_enable                  => delay_enable,
      dqs_rst                       => dqs_rst,
      dqs_en                        => dqs_en,
      wr_en                         => wr_en,
      wr_data_rise                  => wr_data_rise,
      wr_data_fall                  => wr_data_fall,
      mask_data_rise                => mask_data_rise,
      mask_data_fall                => mask_data_fall,
      rd_data_rise                  => rd_data_rise,
      rd_data_fall                  => rd_data_fall,
      ddr_dq                        => ddr_dq,
      ddr_dqs                       => ddr_dqs,
      ddr_dm                        => ddr_dm,
      ctrl_ddr_address              => ctrl_ddr_address,
      ctrl_ddr_ba                   => ctrl_ddr_ba,
      ctrl_ddr_ras_l                => ctrl_ddr_ras_l,
      ctrl_ddr_cas_l                => ctrl_ddr_cas_l,
      ctrl_ddr_we_l                 => ctrl_ddr_we_l,
      ctrl_ddr_cs_l                 => ctrl_ddr_cs_l,
      ctrl_ddr_cke                  => ctrl_ddr_cke,
      ddr_address                   => ddr_a,
      ddr_ba                        => ddr_ba,
      ddr_ras_l                     => ddr_ras_n,
      ddr_cas_l                     => ddr_cas_n,
      ddr_we_l                      => ddr_we_n,
      ddr_cke                       => ddr_cke,
      ddr_cs_l                      => ddr_cs_n
      );

  user_interface_00 : mig_user_interface_0
    port map (
      clk                           => clk_0,
      clk90                         => clk_90,
      reset                         => sys_rst,
      ctrl_rden                     => ctrl_rden,
      cal_first_loop                => cal_first_loop,
      delay_enable                  => delay_enable,
      per_bit_skew                  => per_bit_skew,
      init_done                     => init_done_i,
      read_data_rise                => rd_data_rise,
      read_data_fall                => rd_data_fall,
      read_data_fifo_out            => read_data_fifo_out,
      comp_done                     => comp_done,
      read_data_valid               => read_data_valid,
      af_empty                      => af_empty_w,
      af_almost_full                => af_almost_full,
      app_af_addr                   => app_af_addr,
      app_af_wren                   => app_af_wren,
      ctrl_af_rden                  => ctrl_af_rden,
      af_addr                       => af_addr,
      app_wdf_data                  => app_wdf_data,
      app_mask_data                 => app_mask_data,
      app_wdf_wren                  => app_wdf_wren,
      ctrl_wdf_rden                 => ctrl_wr_df_rden,
      wdf_data                      => wr_df_data,
      mask_data                     => mask_df_data,
      wdf_almost_full               => wdf_almost_full,

      -- Debug Signals
      dbg_first_rising              => dbg_first_rising,
      dbg_cal_first_loop            => dbg_cal_first_loop,
      dbg_comp_done                 => dbg_comp_done,
      dbg_comp_error                => dbg_comp_error
      );

  ddr_controller_00 : mig_ddr_controller_0
    port map (
      clk_0                         => clk_0,
      rst                           => sys_rst,
      af_addr                       => af_addr,
      af_empty                      => af_empty_w,
      phy_dly_slct_done             => dq_tap_sel_done,
      comp_done                     => comp_done,
      ctrl_dummyread_start          => ctrl_dummy_rden,
      ctrl_af_rden                  => ctrl_af_rden,
      ctrl_wdf_rden                 => ctrl_wr_df_rden,
      ctrl_dqs_rst                  => ctrl_dqs_reset,
      ctrl_dqs_en                   => ctrl_dqs_enable,
      ctrl_wren                     => ctrl_wr_en,
      ctrl_rden                     => ctrl_rden,
      ctrl_ddr_address              => ctrl_ddr_address,
      ctrl_ddr_ba                   => ctrl_ddr_ba,
      ctrl_ddr_ras_l                => ctrl_ddr_ras_l,
      ctrl_ddr_cas_l                => ctrl_ddr_cas_l,
      ctrl_ddr_we_l                 => ctrl_ddr_we_l,
      ctrl_ddr_cs_l                 => ctrl_ddr_cs_l,
      ctrl_ddr_cke                  => ctrl_ddr_cke,
      init_done                     => init_done_i,
      cal_first_loop                => cal_first_loop,
      burst_length_div2             => burst_length_div2,

      -- Debug Signals
      dbg_init_done                 => dbg_init_done

      );


end arch;
