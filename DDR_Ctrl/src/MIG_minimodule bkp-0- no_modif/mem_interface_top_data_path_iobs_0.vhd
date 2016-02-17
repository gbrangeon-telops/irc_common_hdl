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
    dqs_idelay_inc  : in    std_logic_vector((ReadEnable - 1) downto 0);
    dqs_idelay_ce   : in    std_logic_vector((ReadEnable - 1) downto 0);
    dqs_idelay_rst  : in    std_logic_vector((ReadEnable - 1) downto 0);
    dqs_rst         : in    std_logic;
    dqs_en          : in    std_logic;
    data_idelay_inc : in    std_logic_vector((ReadEnable - 1) downto 0);
    data_idelay_ce  : in    std_logic_vector((ReadEnable - 1) downto 0);
    data_idelay_rst : in    std_logic_vector((ReadEnable - 1) downto 0);
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

  component mem_interface_top_idelay_rd_en_io_0
    port(
      CLK              : in  std_logic;
      CLK90            : in  std_logic;
      DATA_DLYINC      : in  std_logic;
      DATA_DLYCE       : in  std_logic;
      DATA_DLYRST      : in  std_logic;
      CTRL_RD_EN       : in  std_logic;
      READ_EN_IN       : in  std_logic;
      READ_EN_OUT      : out std_logic;
      rd_en_delayed_r1 : out std_logic;
      rd_en_delayed_r2 : out std_logic
      );
  end component;

begin

  --***************************************************************************
  --                    DQS instances
  --***************************************************************************

  
  v4_dqs_iob0 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(0),
            DLYCE           => dqs_idelay_ce(0),
            DLYRST          => dqs_idelay_rst(0),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(0),
            DQS_RISE        => dqs_delayed(0)
            );


  v4_dqs_iob1 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(0),
            DLYCE           => dqs_idelay_ce(0),
            DLYRST          => dqs_idelay_rst(0),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(1),
            DQS_RISE        => dqs_delayed(1)
            );


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

  
  v4_dq_iob_0 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(0),
            WRITE_DATA_FALL     => wr_data_fall(0),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(0),
            READ_DATA_RISE      => rd_data_rise(0),
            READ_DATA_FALL      => rd_data_fall(0)
            );


  v4_dq_iob_1 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(1),
            WRITE_DATA_FALL     => wr_data_fall(1),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(1),
            READ_DATA_RISE      => rd_data_rise(1),
            READ_DATA_FALL      => rd_data_fall(1)
            );


  v4_dq_iob_2 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(2),
            WRITE_DATA_FALL     => wr_data_fall(2),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(2),
            READ_DATA_RISE      => rd_data_rise(2),
            READ_DATA_FALL      => rd_data_fall(2)
            );


  v4_dq_iob_3 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(3),
            WRITE_DATA_FALL     => wr_data_fall(3),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(3),
            READ_DATA_RISE      => rd_data_rise(3),
            READ_DATA_FALL      => rd_data_fall(3)
            );


  v4_dq_iob_4 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(4),
            WRITE_DATA_FALL     => wr_data_fall(4),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(4),
            READ_DATA_RISE      => rd_data_rise(4),
            READ_DATA_FALL      => rd_data_fall(4)
            );


  v4_dq_iob_5 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(5),
            WRITE_DATA_FALL     => wr_data_fall(5),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(5),
            READ_DATA_RISE      => rd_data_rise(5),
            READ_DATA_FALL      => rd_data_fall(5)
            );


  v4_dq_iob_6 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(6),
            WRITE_DATA_FALL     => wr_data_fall(6),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(6),
            READ_DATA_RISE      => rd_data_rise(6),
            READ_DATA_FALL      => rd_data_fall(6)
            );


  v4_dq_iob_7 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(7),
            WRITE_DATA_FALL     => wr_data_fall(7),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(7),
            READ_DATA_RISE      => rd_data_rise(7),
            READ_DATA_FALL      => rd_data_fall(7)
            );


  v4_dq_iob_8 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(8),
            WRITE_DATA_FALL     => wr_data_fall(8),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(8),
            READ_DATA_RISE      => rd_data_rise(8),
            READ_DATA_FALL      => rd_data_fall(8)
            );


  v4_dq_iob_9 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(9),
            WRITE_DATA_FALL     => wr_data_fall(9),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(9),
            READ_DATA_RISE      => rd_data_rise(9),
            READ_DATA_FALL      => rd_data_fall(9)
            );


  v4_dq_iob_10 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(10),
            WRITE_DATA_FALL     => wr_data_fall(10),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(10),
            READ_DATA_RISE      => rd_data_rise(10),
            READ_DATA_FALL      => rd_data_fall(10)
            );


  v4_dq_iob_11 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(11),
            WRITE_DATA_FALL     => wr_data_fall(11),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(11),
            READ_DATA_RISE      => rd_data_rise(11),
            READ_DATA_FALL      => rd_data_fall(11)
            );


  v4_dq_iob_12 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(12),
            WRITE_DATA_FALL     => wr_data_fall(12),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(12),
            READ_DATA_RISE      => rd_data_rise(12),
            READ_DATA_FALL      => rd_data_fall(12)
            );


  v4_dq_iob_13 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(13),
            WRITE_DATA_FALL     => wr_data_fall(13),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(13),
            READ_DATA_RISE      => rd_data_rise(13),
            READ_DATA_FALL      => rd_data_fall(13)
            );


  v4_dq_iob_14 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(14),
            WRITE_DATA_FALL     => wr_data_fall(14),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(14),
            READ_DATA_RISE      => rd_data_rise(14),
            READ_DATA_FALL      => rd_data_fall(14)
            );


  v4_dq_iob_15 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(0),
            DATA_DLYCE          => data_idelay_ce(0),
            DATA_DLYRST         => data_idelay_rst(0),
            WRITE_DATA_RISE     => wr_data_rise(15),
            WRITE_DATA_FALL     => wr_data_fall(15),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(15),
            READ_DATA_RISE      => rd_data_rise(15),
            READ_DATA_FALL      => rd_data_fall(15)
            );



end arch;
