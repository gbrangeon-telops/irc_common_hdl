-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_top_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the main design logic of memory interface and
--              interfaces with the user.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_top_0 is
  generic(
    REGISTERED_DIMM      : std_logic := '1'
  );
  port(
    clk_0              : in    std_logic;
    clk_90             : in    std_logic;
    idelay_ctrl_rdy    : in    std_logic;
    sys_rst            : in    std_logic;
    sys_rst90          : in    std_logic;
    DDR_RAS_N          : out   std_logic;
    DDR_CAS_N          : out   std_logic;
    DDR_WE_N           : out   std_logic;
    DDR_CKE            : out   std_logic_vector(cke_width-1 downto 0);
    DDR_CS_N           : out   std_logic_vector(cs_width-1 downto 0);
    DDR_DQ             : inout std_logic_vector((data_width-1) downto 0);
    DDR_DQS            : inout std_logic_vector((data_strobe_width-1) downto 0);

DDR_RESET_N            : out std_logic;
    DDR_CK             : out   std_logic_vector((clk_width-1) downto 0);
    DDR_CK_N           : out   std_logic_vector((clk_width-1) downto 0);
    DDR_BA             : out   std_logic_vector((bank_address-1) downto 0);
    DDR_A              : out   std_logic_vector((row_address-1) downto 0);
    WDF_ALMOST_FULL    : out   std_logic;
    AF_ALMOST_FULL     : out   std_logic;
    BURST_LENGTH       : out   std_logic_vector(2 downto 0);
    READ_DATA_VALID    : out   std_logic;
    READ_DATA_FIFO_OUT : out   std_logic_vector((data_width*2 -1) downto 0);
    APP_AF_ADDR        : in    std_logic_vector(35 downto 0);
    APP_AF_WREN        : in    std_logic;
    APP_WDF_DATA       : in    std_logic_vector((data_width*2 -1) downto 0);
    APP_WDF_WREN       : in    std_logic;
    init_done          : out   std_logic;
    CLK_TB             : out   std_logic;
    RESET_TB           : out   std_logic
    );
end mem_interface_top_top_0;

architecture arch of mem_interface_top_top_0 is

  component mem_interface_top_data_path_0
    port(
      CLK                  : in  std_logic;
      CLK90                : in  std_logic;
      RESET0               : in  std_logic;
      RESET90              : in  std_logic;
      idelay_ctrl_rdy      : in  std_logic;
      CTRL_DUMMYREAD_START : in  std_logic;
      WDF_DATA             : in  std_logic_vector((data_width*2 -1) downto 0);
      MASK_DATA            : in  std_logic_vector((data_mask_width*2 -1) downto 0);
      CTRL_WREN            : in  std_logic;
      CTRL_DQS_RST         : in  std_logic;
      CTRL_DQS_EN          : in  std_logic;
      CTRL_DUMMY_WR_SEL    : in  std_logic;
      dummy_write_flag     : in  std_logic;
      dqs_delayed          : in  std_logic_vector((data_strobe_width -1) downto 0);
      calibration_dq       : in  std_logic_vector((data_width - 1) downto 0);
      data_idelay_inc      : out std_logic_vector((data_width - 1) downto 0);
      data_idelay_ce       : out std_logic_vector((data_width - 1) downto 0);
      data_idelay_rst      : out std_logic_vector((data_width - 1) downto 0);
      dqs_idelay_inc       : out std_logic_vector((data_strobe_width - 1) downto 0);
      dqs_idelay_ce        : out std_logic_vector((data_strobe_width - 1) downto 0);
      dqs_idelay_rst       : out std_logic_vector((data_strobe_width - 1) downto 0);
      SEL_DONE             : out std_logic;
      dqs_rst              : out std_logic;
      dqs_en               : out std_logic;
      wr_en                : out std_logic;
      wr_data_rise         : out std_logic_vector((data_width -1) downto 0);
      wr_data_fall         : out std_logic_vector((data_width -1) downto 0);
      mask_data_rise       : out std_logic_vector((data_mask_width -1) downto 0);
      mask_data_fall       : out std_logic_vector((data_mask_width -1) downto 0)
      );
  end component;

  component mem_interface_top_iobs_0
    port(
      DDR_CK           : out   std_logic_vector((clk_width-1) downto 0);
      DDR_CK_N         : out   std_logic_vector((clk_width-1) downto 0);
      CLK              : in    std_logic;
      CLK90            : in    std_logic;
      RESET0           : in    std_logic;
      dqs_idelay_inc   : in    std_logic_vector((data_strobe_width-1) downto 0);
      dqs_idelay_ce    : in    std_logic_vector((data_strobe_width-1) downto 0);
      dqs_idelay_rst   : in    std_logic_vector((data_strobe_width-1) downto 0);
      data_idelay_inc  : in    std_logic_vector((data_width-1) downto 0);
      data_idelay_ce   : in    std_logic_vector((data_width-1) downto 0);
      data_idelay_rst  : in    std_logic_vector((data_width-1) downto 0);
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
      ctrl_ddr_cs_L    : in    std_logic_vector(cs_width-1 downto 0);
      ctrl_ddr_cke     : in    std_logic_vector(cke_width-1 downto 0);
      DDR_ADDRESS      : out   std_logic_vector((row_address-1) downto 0);
      DDR_BA           : out   std_logic_vector((bank_address-1) downto 0);
      DDR_RAS_L        : out   std_logic;
      DDR_CAS_L        : out   std_logic;
      DDR_WE_L         : out   std_logic;
      DDR_CKE          : out   std_logic_vector(cke_width-1 downto 0);
      ddr_cs_L         : out   std_logic_vector(cs_width-1 downto 0)
      );
  end component;

  component mem_interface_top_user_interface_0
    port(
      CLK                : in  std_logic;
      clk90              : in  std_logic;
      RESET              : in  std_logic;
      ctrl_rden          : in  std_logic;
      READ_DATA_RISE     : in  std_logic_vector((data_width -1) downto 0);
      READ_DATA_FALL     : in  std_logic_vector((data_width -1) downto 0);
      READ_DATA_FIFO_OUT : out std_logic_vector((data_width*2 -1) downto 0);
      comp_done          : out std_logic;
      READ_DATA_VALID    : out std_logic;
      AF_EMPTY           : out std_logic;
      AF_ALMOST_FULL     : out std_logic;
      APP_AF_ADDR        : in  std_logic_vector(35 downto 0);
      APP_AF_WREN        : in  std_logic;
      CTRL_AF_RDEN       : in  std_logic;
      AF_ADDR            : out std_logic_vector(35 downto 0);
      APP_WDF_DATA       : in  std_logic_vector((data_width*2 -1) downto 0);
      APP_MASK_DATA      : in  std_logic_vector((data_mask_width*2 -1) downto 0);
      APP_WDF_WREN       : in  std_logic;
      CTRL_WDF_RDEN      : in  std_logic;
      WDF_DATA           : out std_logic_vector((data_width*2 -1) downto 0);
      MASK_DATA          : out std_logic_vector((data_mask_width*2 -1) downto 0);
      WDF_ALMOST_FULL    : out std_logic
      );
  end component;

  component mem_interface_top_ddr_controller_0
    generic(
      REGISTERED_DIMM      : std_logic := '1'
    );
    port(
      clk_0                : in  std_logic;
      rst                  : in  std_logic;
      af_addr              : in  std_logic_vector(35 downto 0);
      af_empty             : in  std_logic;
      comp_done            : in  std_logic;
      phy_Dly_Slct_Done    : in  std_logic;
      ctrl_dummy_wr_sel    : out std_logic;
      ctrl_Dummyread_Start : out std_logic;
      ctrl_af_RdEn         : out std_logic;
      ctrl_Wdf_RdEn        : out std_logic;
      ctrl_Dqs_Rst         : out std_logic;
      ctrl_Dqs_En          : out std_logic;
      ctrl_WrEn            : out std_logic;
      ctrl_RdEn            : out std_logic;
      ctrl_ddr_address     : out std_logic_vector((row_address - 1) downto 0);
      ctrl_ddr_ba          : out std_logic_vector((bank_address - 1) downto 0);
      ctrl_ddr_ras_L       : out std_logic;
      ctrl_ddr_cas_L       : out std_logic;
      ctrl_ddr_we_L        : out std_logic;
      ctrl_ddr_cs_L        : out std_logic_vector(cs_width-1 downto 0);
      ctrl_ddr_cke         : out std_logic_vector(cke_width-1 downto 0);
      init_done            : out std_logic;
      dummy_write_flag     : out std_logic;
      burst_length         : out std_logic_vector(2 downto 0)
      );
  end component;



  signal wr_df_data          : std_logic_vector((data_width*2 -1) downto 0);
  signal mask_df_data        : std_logic_vector((data_mask_width*2 -1) downto 0);
  signal rd_data_rise        : std_logic_vector((data_width -1) downto 0);
  signal rd_data_fall        : std_logic_vector((data_width -1) downto 0);
  signal af_empty_w          : std_logic;
  signal dq_tap_sel_done     : std_logic;
  signal af_addr             : std_logic_vector(35 downto 0);
  signal ctrl_af_rden        : std_logic;
  signal ctrl_wr_df_rden     : std_logic;
  signal ctrl_dummy_rden     : std_logic;
  signal ctrl_dqs_enable     : std_logic;
  signal ctrl_dqs_reset      : std_logic;
  signal ctrl_wr_en          : std_logic;
  signal ctrl_rden           : std_logic;
  signal dqs_idelay_inc      : std_logic_vector((data_strobe_width-1) downto 0);
  signal dqs_idelay_ce       : std_logic_vector((data_strobe_width-1) downto 0);
  signal dqs_idelay_rst      : std_logic_vector((data_strobe_width-1) downto 0);
  signal data_idelay_inc     : std_logic_vector((data_width-1) downto 0);
  signal data_idelay_ce      : std_logic_vector((data_width-1) downto 0);
  signal data_idelay_rst     : std_logic_vector((data_width-1) downto 0);
  signal wr_en               : std_logic;
  signal dqs_rst             : std_logic;
  signal dqs_en              : std_logic;
  signal wr_data_rise        : std_logic_vector((data_width -1) downto 0);
  signal wr_data_fall        : std_logic_vector((data_width -1) downto 0);
  signal dqs_delayed         : std_logic_vector((data_strobe_width-1) downto 0);
  signal mask_data_fall      : std_logic_vector((data_mask_width-1) downto 0);
  signal mask_data_rise      : std_logic_vector((data_mask_width-1) downto 0);
  signal ctrl_ddr_address    : std_logic_vector((row_address - 1) downto 0);
  signal ctrl_ddr_ba         : std_logic_vector((bank_address - 1) downto 0);
  signal ctrl_ddr_ras_L      : std_logic;
  signal ctrl_ddr_cas_L      : std_logic;
  signal ctrl_ddr_we_L       : std_logic;
  signal ctrl_ddr_cs_L       : std_logic_vector(cs_width-1 downto 0);
  signal ctrl_ddr_cke        : std_logic_vector(cke_width-1 downto 0);
  signal ctrl_dummy_wr_sel   : std_logic;
  signal comp_done       : std_logic;

  signal dummy_write_flag  : std_logic;

signal DDR_DM : std_logic_vector((data_mask_width-1) downto 0);
signal APP_MASK_DATA :  std_logic_vector((data_mask_width*2 -1) downto 0);
 

begin

  CLK_TB    <= clk_0;
  RESET_TB  <= sys_rst;
  APP_MASK_DATA <= (others => '0');


DDR_RESET_N <= not sys_rst;
 

  data_path_00 : mem_interface_top_data_path_0
    port map (
      CLK                  => clk_0,
      CLK90                => clk_90,
      RESET0               => sys_rst,
      RESET90              => sys_rst90,
      idelay_ctrl_rdy      => idelay_ctrl_rdy,
      CTRL_DUMMYREAD_START => ctrl_dummy_rden,
      WDF_DATA             => wr_df_data,
      MASK_DATA            => mask_df_data,
      CTRL_WREN            => ctrl_wr_en,
      CTRL_DQS_RST         => ctrl_dqs_reset,
      CTRL_DQS_EN          => ctrl_dqs_enable,
      dqs_delayed          => dqs_delayed,
      CTRL_DUMMY_WR_SEL    => ctrl_dummy_wr_sel,
      data_idelay_inc      => data_idelay_inc,
      data_idelay_ce       => data_idelay_ce,
      data_idelay_rst      => data_idelay_rst,
      dqs_idelay_inc       => dqs_idelay_inc,
      dqs_idelay_ce        => dqs_idelay_ce,
      dqs_idelay_rst       => dqs_idelay_rst,
      SEL_DONE             => dq_tap_sel_done,
      dqs_rst              => dqs_rst,
      dqs_en               => dqs_en,
      wr_en                => wr_en,
      wr_data_rise         => wr_data_rise,
      wr_data_fall         => wr_data_fall,
      mask_data_rise       => mask_data_rise,
      mask_data_fall       => mask_data_fall,
      dummy_write_flag     => dummy_write_flag,
      calibration_dq       => rd_data_rise
      );

  iobs_00 : mem_interface_top_iobs_0
    port map (
      DDR_CK           => DDR_CK,
      DDR_CK_N         => DDR_CK_N,
      CLK              => clk_0,
      CLK90            => clk_90,
      RESET0           => sys_rst,
      dqs_idelay_inc   => dqs_idelay_inc,
      dqs_idelay_ce    => dqs_idelay_ce,
      dqs_idelay_rst   => dqs_idelay_rst,
      data_idelay_inc  => data_idelay_inc,
      data_idelay_ce   => data_idelay_ce,
      data_idelay_rst  => data_idelay_rst,
      dqs_rst          => dqs_rst,
      dqs_en           => dqs_en,
      wr_en            => wr_en,
      wr_data_rise     => wr_data_rise,
      wr_data_fall     => wr_data_fall,
      mask_data_rise   => mask_data_rise,
      mask_data_fall   => mask_data_fall,
      rd_data_rise     => rd_data_rise,
      rd_data_fall     => rd_data_fall,
      dqs_delayed      => dqs_delayed,
      DDR_DQ           => DDR_DQ,
      DDR_DQS          => DDR_DQS,
      DDR_DM           => DDR_DM,
      ctrl_ddr_address => ctrl_ddr_address,
      ctrl_ddr_ba      => ctrl_ddr_ba,
      ctrl_ddr_ras_L   => ctrl_ddr_ras_L,
      ctrl_ddr_cas_L   => ctrl_ddr_cas_L,
      ctrl_ddr_we_L    => ctrl_ddr_we_L,
      ctrl_ddr_cs_L    => ctrl_ddr_cs_L,
      ctrl_ddr_cke     => ctrl_ddr_cke,
      DDR_ADDRESS      => DDR_A,
      DDR_BA           => DDR_BA,
      DDR_RAS_L        => DDR_RAS_N,
      DDR_CAS_L        => DDR_CAS_N,
      DDR_WE_L         => DDR_WE_N,
      DDR_CKE          => DDR_CKE,
      ddr_cs_L         => DDR_CS_N
      );

  user_interface_00 : mem_interface_top_user_interface_0
    port map (
      CLK                => clk_0,
      clk90              => clk_90,
      RESET              => sys_rst,
      ctrl_rden          => ctrl_rden,
      READ_DATA_RISE     => rd_data_rise,
      READ_DATA_FALL     => rd_data_fall,
      READ_DATA_FIFO_OUT => READ_DATA_FIFO_OUT,
      comp_done          => comp_done,
      READ_DATA_VALID    => READ_DATA_VALID,
      AF_EMPTY           => af_empty_w,
      AF_ALMOST_FULL     => AF_ALMOST_FULL,
      APP_AF_ADDR        => APP_AF_ADDR,
      APP_AF_WREN        => APP_AF_WREN,
      CTRL_AF_RDEN       => ctrl_af_rden,
      AF_ADDR            => af_addr,
      APP_WDF_DATA       => APP_WDF_DATA,
      APP_MASK_DATA      => APP_MASK_DATA,
      APP_WDF_WREN       => APP_WDF_WREN,
      CTRL_WDF_RDEN      => ctrl_wr_df_rden,
      WDF_DATA           => wr_df_data,
      MASK_DATA          => mask_df_data,
      WDF_ALMOST_FULL    => WDF_ALMOST_FULL
      );

  ddr_controller_00 : mem_interface_top_ddr_controller_0
    generic map(
      REGISTERED_DIMM      => REGISTERED_DIMM
    )
    port map (
      clk_0                => clk_0,
      rst                  => sys_rst,
      af_addr              => af_addr,
      af_empty             => af_empty_w,
      phy_Dly_Slct_Done    => dq_tap_sel_done,
      comp_done            => comp_done,
      ctrl_Dummyread_Start => ctrl_dummy_rden,
      ctrl_af_RdEn         => ctrl_af_rden,
      ctrl_Wdf_RdEn        => ctrl_wr_df_rden,
      ctrl_Dqs_Rst         => ctrl_dqs_reset,
      ctrl_Dqs_En          => ctrl_dqs_enable,
      ctrl_WrEn            => ctrl_wr_en,
      ctrl_RdEn            => ctrl_rden,
      ctrl_ddr_address     => ctrl_ddr_address,
      ctrl_ddr_ba          => ctrl_ddr_ba,
      ctrl_ddr_ras_L       => ctrl_ddr_ras_L,
      ctrl_ddr_cas_L       => ctrl_ddr_cas_L,
      ctrl_ddr_we_L        => ctrl_ddr_we_L,
      ctrl_ddr_cs_L        => ctrl_ddr_cs_L,
      ctrl_ddr_cke         => ctrl_ddr_cke,
      ctrl_dummy_wr_sel    => ctrl_dummy_wr_sel,
      init_done            => init_done,
      dummy_write_flag     => dummy_write_flag,
      burst_length         => BURST_LENGTH
      );


end arch;
