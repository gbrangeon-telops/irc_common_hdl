-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_data_path_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the tap logic and the data write modules. Gives
--              the rise and the fall data and the calibration information for
--              IDELAY elements.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_data_path_0 is
  port(
    CLK                  : in std_logic;
    CLK90                : in std_logic;
    RESET0               : in std_logic;
    RESET90              : in std_logic;
    idelay_ctrl_rdy      : in std_logic;
    CTRL_DUMMYREAD_START : in std_logic;
    WDF_DATA             : in std_logic_vector((data_width*2 -1) downto 0);
    MASK_DATA            : in std_logic_vector((data_mask_width*2-1) downto 0);
    CTRL_WREN            : in std_logic;
    CTRL_DQS_RST         : in std_logic;
    CTRL_DQS_EN          : in std_logic;
    dqs_delayed          : in std_logic_vector((data_strobe_width-1) downto 0);
    CTRL_DUMMY_WR_SEL    : in std_logic;
    dummy_write_flag     : in std_logic;
    calibration_dq       : in std_logic_vector((data_width - 1) downto 0);
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
end mem_interface_top_data_path_0;

architecture arch of mem_interface_top_data_path_0 is

  component mem_interface_top_data_write_0
    port(
      CLK                 : in std_logic;
      CLK90               : in std_logic;
      RESET90             : in std_logic;
      WDF_DATA            : in std_logic_vector((data_width*2 -1) downto 0);
      MASK_DATA           : in std_logic_vector((data_mask_width*2 -1) downto 0);
      CTRL_WREN           : in std_logic;
      CTRL_DQS_RST        : in std_logic;
      CTRL_DQS_EN         : in std_logic;
      dqs_rst             : out std_logic;
      dqs_en              : out std_logic;
      wr_en               : out std_logic;
      wr_data_rise        : out std_logic_vector((data_width -1) downto 0);
      wr_data_fall        : out std_logic_vector((data_width -1) downto 0);
      mask_data_rise      : out std_logic_vector((data_mask_width -1) downto 0);
      mask_data_fall      : out std_logic_vector((data_mask_width -1) downto 0)
      );
  end component;

  component mem_interface_top_tap_logic_0
    port(
      CLK                  : in std_logic;
      RESET0               : in std_logic;
      idelay_ctrl_rdy      : in std_logic;
      CTRL_DUMMYREAD_START : in std_logic;
      dqs_delayed          : in std_logic_vector((data_strobe_width-1) downto 0);
      calibration_dq       : in std_logic_vector((data_width - 1) downto 0);
      data_idelay_inc      : out std_logic_vector((data_width - 1) downto 0);
      data_idelay_ce       : out std_logic_vector((data_width - 1) downto 0);
      data_idelay_rst      : out std_logic_vector((data_width - 1) downto 0);
      dqs_idelay_inc       : out std_logic_vector((data_strobe_width - 1) downto 0);
      dqs_idelay_ce        : out std_logic_vector((data_strobe_width - 1) downto 0);
      dqs_idelay_rst       : out std_logic_vector((data_strobe_width - 1) downto 0);
      SEL_DONE             : out std_logic
      );
  end component;

begin

  data_write_10: mem_interface_top_data_write_0
    port map (
      CLK                  => CLK,
      CLK90                => CLK90,
      RESET90              => RESET90,
      WDF_DATA             => WDF_DATA,
      MASK_DATA            => MASK_DATA,
      CTRL_WREN            => CTRL_WREN,
      CTRL_DQS_RST         => CTRL_DQS_RST,
      CTRL_DQS_EN          => CTRL_DQS_EN,
      dqs_rst              => dqs_rst,
      dqs_en               => dqs_en,
      wr_en                => wr_en,
      wr_data_rise         => wr_data_rise,
      wr_data_fall         => wr_data_fall,
      mask_data_rise       => mask_data_rise,
      mask_data_fall       => mask_data_fall
      );

  tap_logic_00: mem_interface_top_tap_logic_0
    port map (
      CLK                   => CLK,
      RESET0                => RESET0,
      idelay_ctrl_rdy       => idelay_ctrl_rdy,
      CTRL_DUMMYREAD_START  => CTRL_DUMMYREAD_START,
      dqs_delayed           => dqs_delayed,
      calibration_dq        => calibration_dq,
      data_idelay_inc       => data_idelay_inc,
      data_idelay_ce        => data_idelay_ce,
      data_idelay_rst       => data_idelay_rst,
      dqs_idelay_inc        => dqs_idelay_inc,
      dqs_idelay_ce         => dqs_idelay_ce,
      dqs_idelay_rst        => dqs_idelay_rst,
      SEL_DONE              => SEL_DONE
      );

end arch;
