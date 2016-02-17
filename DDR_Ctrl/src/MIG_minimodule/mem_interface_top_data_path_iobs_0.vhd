-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_data_path_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: This module instantiates data, data strobe and the data mask
--              iobs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_data_path_iobs_0 is
  port (
    CLK             : in    std_logic;
    CLK90           : in    std_logic;
    RESET0          : in    std_logic;
    dqs_idelay_inc  : in    std_logic_vector((data_strobe_width - 1) downto 0);
    dqs_idelay_ce   : in    std_logic_vector((data_strobe_width - 1) downto 0);
    dqs_idelay_rst  : in    std_logic_vector((data_strobe_width - 1) downto 0);
    dqs_rst         : in    std_logic;
    dqs_en          : in    std_logic;
    data_idelay_inc : in    std_logic_vector((data_width - 1) downto 0);
    data_idelay_ce  : in    std_logic_vector((data_width - 1) downto 0);
    data_idelay_rst : in    std_logic_vector((data_width - 1) downto 0);
    wr_data_rise    : in    std_logic_vector((data_width -1) downto 0);
    wr_data_fall    : in    std_logic_vector((data_width -1) downto 0);
    wr_en           : in    std_logic;
    mask_data_rise  : in    std_logic_vector((data_mask_width -1) downto 0);
    mask_data_fall  : in    std_logic_vector((data_mask_width -1) downto 0);
    DDR_DQ          : inout std_logic_vector((data_width -1) downto 0);
    DDR_DQS         : inout std_logic_vector((data_strobe_width -1) downto 0);
    dqs_delayed     : out   std_logic_vector((data_strobe_width -1) downto 0);
    rd_data_rise    : out   std_logic_vector((data_width -1) downto 0);
    rd_data_fall    : out   std_logic_vector((data_width -1) downto 0);
    DDR_DM          : out   std_logic_vector((data_mask_width -1) downto 0)
    );
end mem_interface_top_data_path_iobs_0;

architecture arch of mem_interface_top_data_path_iobs_0 is

  component mem_interface_top_v4_dqs_iob
    port(
      CLK               : in std_logic;
      RESET             : in std_logic;
      DLYINC            : in std_logic;
      DLYCE             : in std_logic;
      DLYRST            : in std_logic;
      CTRL_DQS_RST      : in std_logic;
      CTRL_DQS_EN       : in std_logic;
      DDR_DQS           : inout std_logic;
      DQS_RISE  : out std_logic
      );
  end component;

  component mem_interface_top_v4_dm_iob
    port(
      CLK90             : in std_logic;
      MASK_DATA_RISE    : in std_logic;
      MASK_DATA_FALL    : in std_logic;
      DDR_DM            : out std_logic
      );
  end component;

  component mem_interface_top_v4_dq_iob
    port(
      CLK             : in    std_logic;
      CLK90           : in    std_logic;
      DATA_DLYINC     : in    std_logic;
      DATA_DLYCE      : in    std_logic;
      DATA_DLYRST     : in    std_logic;
      WRITE_DATA_RISE : in    std_logic;
      WRITE_DATA_FALL : in    std_logic;
      CTRL_WREN       : in    std_logic;
      DDR_DQ          : inout std_logic;
      READ_DATA_RISE  : out   std_logic;
      READ_DATA_FALL  : out   std_logic
      );
  end component;

begin

  --***************************************************************************
  --                    DQS instances
  --***************************************************************************

v4_dqs_iob_gen: for i in 0 to (data_strobe_width-1) generate
  v4_dqs_iob0 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            RESET           => RESET0,
            DLYINC          => dqs_idelay_inc(i),
            DLYCE           => dqs_idelay_ce(i),
            DLYRST          => dqs_idelay_rst(i),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(i),
            DQS_RISE        => dqs_delayed(i)
            );
end generate;

  --***************************************************************************
  --                    DM instances
  --***************************************************************************

  
  v4_dm_iob0 : mem_interface_top_v4_dm_iob
    port map (
            CLK90           => CLK90,
            MASK_DATA_RISE  => mask_data_rise(0),
            MASK_DATA_FALL  => mask_data_fall(0),
            DDR_DM          => DDR_DM(0)
            );


  v4_dm_iob1 : mem_interface_top_v4_dm_iob
    port map (
            CLK90           => CLK90,
            MASK_DATA_RISE  => mask_data_rise(1),
            MASK_DATA_FALL  => mask_data_fall(1),
            DDR_DM          => DDR_DM(1)
            );


  --***************************************************************************
  --                    DQ_IOB4 instances
  --***************************************************************************

v4_dq_iob_gen: for i in 0 to (data_width-1) generate
  v4_dq_iob_0 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(i),
            DATA_DLYCE          => data_idelay_ce(i),
            DATA_DLYRST         => data_idelay_rst(i),
            WRITE_DATA_RISE     => wr_data_rise(i),
            WRITE_DATA_FALL     => wr_data_fall(i),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(i),
            READ_DATA_RISE      => rd_data_rise(i),
            READ_DATA_FALL      => rd_data_fall(i)
            );
end generate;

end arch;
