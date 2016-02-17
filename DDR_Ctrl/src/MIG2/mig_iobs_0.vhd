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
--  /   /        Filename           : mig_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: This module instantiates all the iobs modules. It is the
--              interface between the main logic and the memory.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_iobs_0 is
  port(
    ddr_ck           : out   std_logic_vector((CLK_WIDTH - 1) downto 0);
    ddr_ck_n         : out   std_logic_vector((CLK_WIDTH - 1) downto 0);
    clk              : in    std_logic;
    clk90            : in    std_logic;
    reset0           : in    std_logic;
    data_idelay_inc  : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    data_idelay_ce   : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    data_idelay_rst  : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    delay_enable     : in    std_logic_vector(DATA_WIDTH-1 downto 0);
    dqs_rst          : in    std_logic;
    dqs_en           : in    std_logic;
    wr_en            : in    std_logic;
    wr_data_rise     : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    wr_data_fall     : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    mask_data_rise   : in    std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    mask_data_fall   : in    std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    rd_data_rise     : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
    rd_data_fall     : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
    ddr_dq           : inout std_logic_vector((DATA_WIDTH - 1) downto 0);
    ddr_dqs          : inout std_logic_vector((DATA_STROBE_WIDTH - 1) downto 0);
    ddr_dm           : out   std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    ctrl_ddr_address : in    std_logic_vector((ROW_ADDRESS - 1) downto 0);
    ctrl_ddr_ba      : in    std_logic_vector((BANK_ADDRESS - 1) downto 0);
    ctrl_ddr_ras_l   : in    std_logic;
    ctrl_ddr_cas_l   : in    std_logic;
    ctrl_ddr_we_l    : in    std_logic;
    ctrl_ddr_cs_l    : in    std_logic_vector((CS_WIDTH - 1) downto 0);
    ctrl_ddr_cke     : in    std_logic_vector((CKE_WIDTH - 1) downto 0);
    ddr_address      : out   std_logic_vector((ROW_ADDRESS - 1) downto 0);
    ddr_ba           : out   std_logic_vector((BANK_ADDRESS - 1) downto 0);
    ddr_ras_l        : out   std_logic;
    ddr_cas_l        : out   std_logic;
    ddr_we_l         : out   std_logic;
    ddr_cke          : out   std_logic_vector((CKE_WIDTH - 1) downto 0);
    ddr_cs_l         : out   std_logic_vector((CS_WIDTH - 1) downto 0)
    );

end mig_iobs_0;

architecture arch of mig_iobs_0 is

        attribute X_CORE_INFO : string;
        attribute X_CORE_INFO of arch : architecture IS
        "mig_v2_3_b1_ddr_v4, Coregen 10.1.02";

        attribute CORE_GENERATION_INFO : string;
        attribute CORE_GENERATION_INFO of arch : architecture IS
        "ddr_v4,mig_v2_3,{component_name=mig_iobs_0, data_width=72,  data_strobe_width=18, data_mask_width=9, clk_width=1, fifo_16=5, row_address=13, memory_width=4, cs_width=1, data_mask=0, reset_port=1, cke_width=1, reg_enable=1, mask_enable=0, column_address=11, bank_address=2, load_mode_register=0000001100001, ext_load_mode_register=0000000000000, chip_address=1, reset_active_low=1, rcd_count_value=001, ras_count_value=0011, tmrd_count_value=000, rp_count_value=001, rfc_count_value=000110, twr_count_value=110, twtr_count_value=100, max_ref_width=10, max_ref_cnt=1011111000}";

  component mig_infrastructure_iobs_0
    port(
      clk       : in std_logic;
      ddr_ck    : out std_logic_vector((CLK_WIDTH - 1) downto 0);
      ddr_ck_n  : out std_logic_vector((CLK_WIDTH - 1) downto 0)
      );
  end component;

  component mig_data_path_iobs_0
    port (
      clk             : in std_logic;
      clk90           : in std_logic;
      reset0          : in std_logic;
      dqs_rst         : in std_logic;
      dqs_en          : in std_logic;
      data_idelay_inc : in std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_ce  : in std_logic_vector((DATA_WIDTH - 1) downto 0);
      data_idelay_rst : in std_logic_vector((DATA_WIDTH - 1) downto 0);
      delay_enable    : in    std_logic_vector(DATA_WIDTH-1 downto 0);
      wr_data_rise    : in std_logic_vector((DATA_WIDTH - 1) downto 0);
      wr_data_fall    : in std_logic_vector((DATA_WIDTH - 1) downto 0);
      wr_en           : in std_logic;
      rd_data_rise    : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      rd_data_fall    : out std_logic_vector((DATA_WIDTH - 1) downto 0);
      mask_data_rise  : in std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
      mask_data_fall  : in std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
      ddr_dq          : inout std_logic_vector((DATA_WIDTH - 1) downto 0);
      ddr_dqs         : inout std_logic_vector((DATA_STROBE_WIDTH - 1) downto 0);
      ddr_dm          : out std_logic_vector((DATA_MASK_WIDTH - 1) downto 0)
      );
  end component;

  component mig_controller_iobs_0
    port (
      ctrl_ddr_address : in  std_logic_vector((ROW_ADDRESS - 1) downto 0);
      ctrl_ddr_ba      : in  std_logic_vector((BANK_ADDRESS - 1) downto 0);
      ctrl_ddr_ras_l   : in  std_logic;
      ctrl_ddr_cas_l   : in  std_logic;
      ctrl_ddr_we_l    : in  std_logic;
      ctrl_ddr_cs_l    : in  std_logic_vector((CS_WIDTH - 1) downto 0);
      ctrl_ddr_cke     : in  std_logic_vector((CKE_WIDTH - 1) downto 0);
      ddr_address      : out std_logic_vector((ROW_ADDRESS - 1) downto 0);
      ddr_ba           : out std_logic_vector((BANK_ADDRESS - 1) downto 0);
      ddr_ras_l        : out std_logic;
      ddr_cas_l        : out std_logic;
      ddr_we_l         : out std_logic;
      ddr_cke          : out std_logic_vector((CKE_WIDTH - 1) downto 0);
      ddr_cs_l         : out std_logic_vector((CS_WIDTH - 1) downto 0)
      );
  end component;

begin

  --***************************************************************************

  infrastructure_iobs_00: mig_infrastructure_iobs_0
    port map   (
      clk       => clk,
      ddr_ck    => ddr_ck,
      ddr_ck_n  => ddr_ck_n
      );

  data_path_iobs_00: mig_data_path_iobs_0
    port map    (
      clk                       => clk,
      clk90                     => clk90,
      reset0                    => reset0,
      dqs_rst                   => dqs_rst,
      dqs_en                    => dqs_en,
      data_idelay_inc           => data_idelay_inc,
      data_idelay_ce            => data_idelay_ce,
      data_idelay_rst           => data_idelay_rst,
      delay_enable              => delay_enable,
      wr_data_rise              => wr_data_rise,
      wr_data_fall              => wr_data_fall,
      wr_en                     => wr_en,
      rd_data_rise              => rd_data_rise,
      rd_data_fall              => rd_data_fall,
      mask_data_rise            => mask_data_rise,
      mask_data_fall            => mask_data_fall,
      ddr_dq                    => ddr_dq,
      ddr_dqs                   => ddr_dqs,
      ddr_dm                    => ddr_dm
      );

  controller_iobs_00: mig_controller_iobs_0
    port map     (
      ctrl_ddr_address => ctrl_ddr_address,
      ctrl_ddr_ba      => ctrl_ddr_ba,
      ctrl_ddr_ras_l   => ctrl_ddr_ras_l,
      ctrl_ddr_cas_l   => ctrl_ddr_cas_l,
      ctrl_ddr_we_l    => ctrl_ddr_we_l,
      ctrl_ddr_cs_l    => ctrl_ddr_cs_l,
      ctrl_ddr_cke     => ctrl_ddr_cke,
      ddr_address      => ddr_address,
      ddr_ba           => ddr_ba,
      ddr_ras_l        => ddr_ras_l,
      ddr_cas_l        => ddr_cas_l,
      ddr_we_l         => ddr_we_l,
      ddr_cke          => ddr_cke,
      ddr_cs_l         => ddr_cs_l
      );

end arch;
