-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: This module instantiates all the iobs modules. It is the
--              interface between the main logic and the memory.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_iobs_0 is
  port(
    DDR_CK           : out   std_logic_vector((clk_width-1) downto 0);
    DDR_CK_N         : out   std_logic_vector((clk_width-1) downto 0);
    CLK              : in    std_logic;
    CLK90            : in    std_logic;
    dqs_idelay_inc   : in    std_logic_vector((ReadEnable-1) downto 0);
    dqs_idelay_ce    : in    std_logic_vector((ReadEnable-1) downto 0);
    dqs_idelay_rst   : in    std_logic_vector((ReadEnable-1) downto 0);
    data_idelay_inc  : in    std_logic_vector((ReadEnable-1) downto 0);
    data_idelay_ce   : in    std_logic_vector((ReadEnable-1) downto 0);
    data_idelay_rst  : in    std_logic_vector((ReadEnable-1) downto 0);
    dqs_rst          : in    std_logic;
    dqs_en           : in    std_logic;
    wr_en            : in    std_logic;
    wr_data_rise     : in    std_logic_vector((data_width-1) downto 0);
    wr_data_fall     : in    std_logic_vector((data_width-1) downto 0);
    mask_data_rise   : in    std_logic_vector((data_mask_width-1) downto 0);
    mask_data_fall   : in    std_logic_vector((data_mask_width-1) downto 0);
    rd_data_rise     : out   std_logic_vector((data_width-1) downto 0);
    rd_data_fall     : out   std_logic_vector((data_width-1) downto 0);
    dqs_delayed      : out   std_logic_vector((data_strobe_width-1) downto 0);
    DDR_DQ           : inout std_logic_vector((data_width-1) downto 0);
    DDR_DQS          : inout std_logic_vector((data_strobe_width-1) downto 0);
    DDR_DM           : out   std_logic_vector((data_mask_width-1) downto 0);
    ctrl_ddr_address : in    std_logic_vector((row_address-1) downto 0);
    ctrl_ddr_ba      : in    std_logic_vector((bank_address-1) downto 0);
    ctrl_ddr_ras_L   : in    std_logic;
    ctrl_ddr_cas_L   : in    std_logic;
    ctrl_ddr_we_L    : in    std_logic;
    ctrl_ddr_cs_L    : in    std_logic;
    ctrl_ddr_cke     : in    std_logic;
    DDR_ADDRESS      : out   std_logic_vector((row_address-1) downto 0);
    DDR_BA           : out   std_logic_vector((bank_address-1) downto 0);
    DDR_RAS_L        : out   std_logic;
    DDR_CAS_L        : out   std_logic;
    DDR_WE_L         : out   std_logic;
    DDR_CKE          : out   std_logic;
    ddr_cs_L         : out   std_logic
    );
end mem_interface_top_iobs_0;

architecture arch of mem_interface_top_iobs_0 is

  component mem_interface_top_infrastructure_iobs_0
    port(
      CLK       : in std_logic;
      DDR_CK    : out std_logic_vector((clk_width-1) downto 0);
      DDR_CK_N  : out std_logic_vector((clk_width-1) downto 0)
      );
  end component;

  component mem_interface_top_data_path_iobs_0
    port (
      CLK             : in std_logic;
      CLK90           : in std_logic;
      dqs_idelay_inc  : in std_logic_vector((ReadEnable - 1) downto 0);
      dqs_idelay_ce   : in std_logic_vector((ReadEnable - 1) downto 0);
      dqs_idelay_rst  : in std_logic_vector((ReadEnable - 1) downto 0);
      dqs_rst         : in std_logic;
      dqs_en          : in std_logic;
      dqs_delayed     : out std_logic_vector((data_strobe_width -1) downto 0);
      data_idelay_inc : in std_logic_vector((ReadEnable - 1) downto 0);
      data_idelay_ce  : in std_logic_vector((ReadEnable - 1) downto 0);
      data_idelay_rst : in std_logic_vector((ReadEnable - 1) downto 0);
      wr_data_rise    : in std_logic_vector((data_width -1) downto 0);
      wr_data_fall    : in std_logic_vector((data_width -1) downto 0);
      wr_en           : in std_logic;
      rd_data_rise    : out std_logic_vector((data_width -1) downto 0);
      rd_data_fall    : out std_logic_vector((data_width -1) downto 0);
      mask_data_rise  : in std_logic_vector((data_mask_width -1) downto 0);
      mask_data_fall  : in std_logic_vector((data_mask_width -1) downto 0);
      DDR_DQ          : inout std_logic_vector((data_width -1) downto 0);
      DDR_DQS         : inout std_logic_vector((data_strobe_width -1) downto 0);
      DDR_DM          : out std_logic_vector((data_mask_width -1) downto 0)
      );
  end component;

  component mem_interface_top_controller_iobs_0
    port (
      ctrl_ddr_address : in  std_logic_vector((row_address - 1) downto 0);
      ctrl_ddr_ba      : in  std_logic_vector((bank_address - 1) downto 0);
      ctrl_ddr_ras_L   : in  std_logic;
      ctrl_ddr_cas_L   : in  std_logic;
      ctrl_ddr_we_L    : in  std_logic;
      ctrl_ddr_cs_L    : in  std_logic;
      ctrl_ddr_cke     : in  std_logic;
      DDR_ADDRESS      : out std_logic_vector((row_address - 1) downto 0);
      DDR_BA           : out std_logic_vector((bank_address - 1) downto 0);
      DDR_RAS_L        : out std_logic;
      DDR_CAS_L        : out std_logic;
      DDR_WE_L         : out std_logic;
      DDR_CKE          : out std_logic;
      ddr_cs_L         : out std_logic
      );
  end component;

begin

  infrastructure_iobs_00: mem_interface_top_infrastructure_iobs_0
    port map   (
      CLK       => CLK,
      DDR_CK    => DDR_CK,
      DDR_CK_N  => DDR_CK_N
      );

  data_path_iobs_00: mem_interface_top_data_path_iobs_0
    port map    (
      CLK                       => CLK,
      CLK90                     => CLK90,
      dqs_idelay_inc            => dqs_idelay_inc,
      dqs_idelay_ce             => dqs_idelay_ce,
      dqs_idelay_rst            => dqs_idelay_rst,
      dqs_rst                   => dqs_rst,
      dqs_en                    => dqs_en,
      dqs_delayed               => dqs_delayed,
      data_idelay_inc           => data_idelay_inc,
      data_idelay_ce            => data_idelay_ce,
      data_idelay_rst           => data_idelay_rst,
      wr_data_rise              => wr_data_rise,
      wr_data_fall              => wr_data_fall,
      wr_en                     => wr_en,
      rd_data_rise              => rd_data_rise,
      rd_data_fall              => rd_data_fall,
      mask_data_rise            => mask_data_rise,
      mask_data_fall            => mask_data_fall,
      DDR_DQ                    => DDR_DQ,
      DDR_DQS                   => DDR_DQS,
      DDR_DM                    => DDR_DM
      );

  controller_iobs_00: mem_interface_top_controller_iobs_0
    port map     (
      ctrl_ddr_address => ctrl_ddr_address,
      ctrl_ddr_ba      => ctrl_ddr_ba,
      ctrl_ddr_ras_L   => ctrl_ddr_ras_L,
      ctrl_ddr_cas_L   => ctrl_ddr_cas_L,
      ctrl_ddr_we_L    => ctrl_ddr_we_L,
      ctrl_ddr_cs_L    => ctrl_ddr_cs_L,
      ctrl_ddr_cke     => ctrl_ddr_cke,
      DDR_ADDRESS      => DDR_ADDRESS,
      DDR_BA           => DDR_BA,
      DDR_RAS_L        => DDR_RAS_L,
      DDR_CAS_L        => DDR_CAS_L,
      DDR_WE_L         => DDR_WE_L,
      DDR_CKE          => DDR_CKE,
      ddr_cs_L         => ddr_cs_L
      );

end arch;
