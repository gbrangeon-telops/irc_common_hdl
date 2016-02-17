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


  v4_dqs_iob2 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(0),
            DLYCE           => dqs_idelay_ce(0),
            DLYRST          => dqs_idelay_rst(0),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(2),
            DQS_RISE        => dqs_delayed(2)
            );


  v4_dqs_iob3 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(0),
            DLYCE           => dqs_idelay_ce(0),
            DLYRST          => dqs_idelay_rst(0),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(3),
            DQS_RISE        => dqs_delayed(3)
            );


  v4_dqs_iob4 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(1),
            DLYCE           => dqs_idelay_ce(1),
            DLYRST          => dqs_idelay_rst(1),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(4),
            DQS_RISE        => dqs_delayed(4)
            );


  v4_dqs_iob5 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(1),
            DLYCE           => dqs_idelay_ce(1),
            DLYRST          => dqs_idelay_rst(1),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(5),
            DQS_RISE        => dqs_delayed(5)
            );


  v4_dqs_iob6 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(1),
            DLYCE           => dqs_idelay_ce(1),
            DLYRST          => dqs_idelay_rst(1),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(6),
            DQS_RISE        => dqs_delayed(6)
            );


  v4_dqs_iob7 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(1),
            DLYCE           => dqs_idelay_ce(1),
            DLYRST          => dqs_idelay_rst(1),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(7),
            DQS_RISE        => dqs_delayed(7)
            );


  v4_dqs_iob8 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(2),
            DLYCE           => dqs_idelay_ce(2),
            DLYRST          => dqs_idelay_rst(2),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(8),
            DQS_RISE        => dqs_delayed(8)
            );


  v4_dqs_iob9 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(2),
            DLYCE           => dqs_idelay_ce(2),
            DLYRST          => dqs_idelay_rst(2),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(9),
            DQS_RISE        => dqs_delayed(9)
            );


  v4_dqs_iob10 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(2),
            DLYCE           => dqs_idelay_ce(2),
            DLYRST          => dqs_idelay_rst(2),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(10),
            DQS_RISE        => dqs_delayed(10)
            );


  v4_dqs_iob11 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(2),
            DLYCE           => dqs_idelay_ce(2),
            DLYRST          => dqs_idelay_rst(2),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(11),
            DQS_RISE        => dqs_delayed(11)
            );


  v4_dqs_iob12 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(3),
            DLYCE           => dqs_idelay_ce(3),
            DLYRST          => dqs_idelay_rst(3),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(12),
            DQS_RISE        => dqs_delayed(12)
            );


  v4_dqs_iob13 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(3),
            DLYCE           => dqs_idelay_ce(3),
            DLYRST          => dqs_idelay_rst(3),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(13),
            DQS_RISE        => dqs_delayed(13)
            );


  v4_dqs_iob14 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(3),
            DLYCE           => dqs_idelay_ce(3),
            DLYRST          => dqs_idelay_rst(3),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(14),
            DQS_RISE        => dqs_delayed(14)
            );


  v4_dqs_iob15 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(3),
            DLYCE           => dqs_idelay_ce(3),
            DLYRST          => dqs_idelay_rst(3),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(15),
            DQS_RISE        => dqs_delayed(15)
            );


  v4_dqs_iob16 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(4),
            DLYCE           => dqs_idelay_ce(4),
            DLYRST          => dqs_idelay_rst(4),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(16),
            DQS_RISE        => dqs_delayed(16)
            );


  v4_dqs_iob17 : mem_interface_top_v4_dqs_iob
    port map (
            CLK             => CLK,
            DLYINC          => dqs_idelay_inc(4),
            DLYCE           => dqs_idelay_ce(4),
            DLYRST          => dqs_idelay_rst(4),
            CTRL_DQS_RST    => dqs_rst,
            CTRL_DQS_EN     => dqs_en,
            DDR_DQS         => DDR_DQS(17),
            DQS_RISE        => dqs_delayed(17)
            );


  --***************************************************************************
  --                    DM instances
  --***************************************************************************

  

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


  v4_dq_iob_16 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(16),
            WRITE_DATA_FALL     => wr_data_fall(16),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(16),
            READ_DATA_RISE      => rd_data_rise(16),
            READ_DATA_FALL      => rd_data_fall(16)
            );


  v4_dq_iob_17 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(17),
            WRITE_DATA_FALL     => wr_data_fall(17),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(17),
            READ_DATA_RISE      => rd_data_rise(17),
            READ_DATA_FALL      => rd_data_fall(17)
            );


  v4_dq_iob_18 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(18),
            WRITE_DATA_FALL     => wr_data_fall(18),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(18),
            READ_DATA_RISE      => rd_data_rise(18),
            READ_DATA_FALL      => rd_data_fall(18)
            );


  v4_dq_iob_19 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(19),
            WRITE_DATA_FALL     => wr_data_fall(19),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(19),
            READ_DATA_RISE      => rd_data_rise(19),
            READ_DATA_FALL      => rd_data_fall(19)
            );


  v4_dq_iob_20 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(20),
            WRITE_DATA_FALL     => wr_data_fall(20),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(20),
            READ_DATA_RISE      => rd_data_rise(20),
            READ_DATA_FALL      => rd_data_fall(20)
            );


  v4_dq_iob_21 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(21),
            WRITE_DATA_FALL     => wr_data_fall(21),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(21),
            READ_DATA_RISE      => rd_data_rise(21),
            READ_DATA_FALL      => rd_data_fall(21)
            );


  v4_dq_iob_22 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(22),
            WRITE_DATA_FALL     => wr_data_fall(22),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(22),
            READ_DATA_RISE      => rd_data_rise(22),
            READ_DATA_FALL      => rd_data_fall(22)
            );


  v4_dq_iob_23 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(23),
            WRITE_DATA_FALL     => wr_data_fall(23),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(23),
            READ_DATA_RISE      => rd_data_rise(23),
            READ_DATA_FALL      => rd_data_fall(23)
            );


  v4_dq_iob_24 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(24),
            WRITE_DATA_FALL     => wr_data_fall(24),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(24),
            READ_DATA_RISE      => rd_data_rise(24),
            READ_DATA_FALL      => rd_data_fall(24)
            );


  v4_dq_iob_25 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(25),
            WRITE_DATA_FALL     => wr_data_fall(25),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(25),
            READ_DATA_RISE      => rd_data_rise(25),
            READ_DATA_FALL      => rd_data_fall(25)
            );


  v4_dq_iob_26 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(26),
            WRITE_DATA_FALL     => wr_data_fall(26),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(26),
            READ_DATA_RISE      => rd_data_rise(26),
            READ_DATA_FALL      => rd_data_fall(26)
            );


  v4_dq_iob_27 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(27),
            WRITE_DATA_FALL     => wr_data_fall(27),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(27),
            READ_DATA_RISE      => rd_data_rise(27),
            READ_DATA_FALL      => rd_data_fall(27)
            );


  v4_dq_iob_28 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(28),
            WRITE_DATA_FALL     => wr_data_fall(28),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(28),
            READ_DATA_RISE      => rd_data_rise(28),
            READ_DATA_FALL      => rd_data_fall(28)
            );


  v4_dq_iob_29 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(29),
            WRITE_DATA_FALL     => wr_data_fall(29),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(29),
            READ_DATA_RISE      => rd_data_rise(29),
            READ_DATA_FALL      => rd_data_fall(29)
            );


  v4_dq_iob_30 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(30),
            WRITE_DATA_FALL     => wr_data_fall(30),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(30),
            READ_DATA_RISE      => rd_data_rise(30),
            READ_DATA_FALL      => rd_data_fall(30)
            );


  v4_dq_iob_31 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(1),
            DATA_DLYCE          => data_idelay_ce(1),
            DATA_DLYRST         => data_idelay_rst(1),
            WRITE_DATA_RISE     => wr_data_rise(31),
            WRITE_DATA_FALL     => wr_data_fall(31),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(31),
            READ_DATA_RISE      => rd_data_rise(31),
            READ_DATA_FALL      => rd_data_fall(31)
            );


  v4_dq_iob_32 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(32),
            WRITE_DATA_FALL     => wr_data_fall(32),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(32),
            READ_DATA_RISE      => rd_data_rise(32),
            READ_DATA_FALL      => rd_data_fall(32)
            );


  v4_dq_iob_33 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(33),
            WRITE_DATA_FALL     => wr_data_fall(33),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(33),
            READ_DATA_RISE      => rd_data_rise(33),
            READ_DATA_FALL      => rd_data_fall(33)
            );


  v4_dq_iob_34 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(34),
            WRITE_DATA_FALL     => wr_data_fall(34),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(34),
            READ_DATA_RISE      => rd_data_rise(34),
            READ_DATA_FALL      => rd_data_fall(34)
            );


  v4_dq_iob_35 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(35),
            WRITE_DATA_FALL     => wr_data_fall(35),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(35),
            READ_DATA_RISE      => rd_data_rise(35),
            READ_DATA_FALL      => rd_data_fall(35)
            );


  v4_dq_iob_36 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(36),
            WRITE_DATA_FALL     => wr_data_fall(36),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(36),
            READ_DATA_RISE      => rd_data_rise(36),
            READ_DATA_FALL      => rd_data_fall(36)
            );


  v4_dq_iob_37 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(37),
            WRITE_DATA_FALL     => wr_data_fall(37),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(37),
            READ_DATA_RISE      => rd_data_rise(37),
            READ_DATA_FALL      => rd_data_fall(37)
            );


  v4_dq_iob_38 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(38),
            WRITE_DATA_FALL     => wr_data_fall(38),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(38),
            READ_DATA_RISE      => rd_data_rise(38),
            READ_DATA_FALL      => rd_data_fall(38)
            );


  v4_dq_iob_39 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(39),
            WRITE_DATA_FALL     => wr_data_fall(39),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(39),
            READ_DATA_RISE      => rd_data_rise(39),
            READ_DATA_FALL      => rd_data_fall(39)
            );


  v4_dq_iob_40 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(40),
            WRITE_DATA_FALL     => wr_data_fall(40),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(40),
            READ_DATA_RISE      => rd_data_rise(40),
            READ_DATA_FALL      => rd_data_fall(40)
            );


  v4_dq_iob_41 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(41),
            WRITE_DATA_FALL     => wr_data_fall(41),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(41),
            READ_DATA_RISE      => rd_data_rise(41),
            READ_DATA_FALL      => rd_data_fall(41)
            );


  v4_dq_iob_42 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(42),
            WRITE_DATA_FALL     => wr_data_fall(42),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(42),
            READ_DATA_RISE      => rd_data_rise(42),
            READ_DATA_FALL      => rd_data_fall(42)
            );


  v4_dq_iob_43 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(43),
            WRITE_DATA_FALL     => wr_data_fall(43),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(43),
            READ_DATA_RISE      => rd_data_rise(43),
            READ_DATA_FALL      => rd_data_fall(43)
            );


  v4_dq_iob_44 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(44),
            WRITE_DATA_FALL     => wr_data_fall(44),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(44),
            READ_DATA_RISE      => rd_data_rise(44),
            READ_DATA_FALL      => rd_data_fall(44)
            );


  v4_dq_iob_45 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(45),
            WRITE_DATA_FALL     => wr_data_fall(45),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(45),
            READ_DATA_RISE      => rd_data_rise(45),
            READ_DATA_FALL      => rd_data_fall(45)
            );


  v4_dq_iob_46 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(46),
            WRITE_DATA_FALL     => wr_data_fall(46),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(46),
            READ_DATA_RISE      => rd_data_rise(46),
            READ_DATA_FALL      => rd_data_fall(46)
            );


  v4_dq_iob_47 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(2),
            DATA_DLYCE          => data_idelay_ce(2),
            DATA_DLYRST         => data_idelay_rst(2),
            WRITE_DATA_RISE     => wr_data_rise(47),
            WRITE_DATA_FALL     => wr_data_fall(47),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(47),
            READ_DATA_RISE      => rd_data_rise(47),
            READ_DATA_FALL      => rd_data_fall(47)
            );


  v4_dq_iob_48 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(48),
            WRITE_DATA_FALL     => wr_data_fall(48),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(48),
            READ_DATA_RISE      => rd_data_rise(48),
            READ_DATA_FALL      => rd_data_fall(48)
            );


  v4_dq_iob_49 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(49),
            WRITE_DATA_FALL     => wr_data_fall(49),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(49),
            READ_DATA_RISE      => rd_data_rise(49),
            READ_DATA_FALL      => rd_data_fall(49)
            );


  v4_dq_iob_50 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(50),
            WRITE_DATA_FALL     => wr_data_fall(50),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(50),
            READ_DATA_RISE      => rd_data_rise(50),
            READ_DATA_FALL      => rd_data_fall(50)
            );


  v4_dq_iob_51 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(51),
            WRITE_DATA_FALL     => wr_data_fall(51),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(51),
            READ_DATA_RISE      => rd_data_rise(51),
            READ_DATA_FALL      => rd_data_fall(51)
            );


  v4_dq_iob_52 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(52),
            WRITE_DATA_FALL     => wr_data_fall(52),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(52),
            READ_DATA_RISE      => rd_data_rise(52),
            READ_DATA_FALL      => rd_data_fall(52)
            );


  v4_dq_iob_53 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(53),
            WRITE_DATA_FALL     => wr_data_fall(53),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(53),
            READ_DATA_RISE      => rd_data_rise(53),
            READ_DATA_FALL      => rd_data_fall(53)
            );


  v4_dq_iob_54 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(54),
            WRITE_DATA_FALL     => wr_data_fall(54),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(54),
            READ_DATA_RISE      => rd_data_rise(54),
            READ_DATA_FALL      => rd_data_fall(54)
            );


  v4_dq_iob_55 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(55),
            WRITE_DATA_FALL     => wr_data_fall(55),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(55),
            READ_DATA_RISE      => rd_data_rise(55),
            READ_DATA_FALL      => rd_data_fall(55)
            );


  v4_dq_iob_56 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(56),
            WRITE_DATA_FALL     => wr_data_fall(56),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(56),
            READ_DATA_RISE      => rd_data_rise(56),
            READ_DATA_FALL      => rd_data_fall(56)
            );


  v4_dq_iob_57 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(57),
            WRITE_DATA_FALL     => wr_data_fall(57),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(57),
            READ_DATA_RISE      => rd_data_rise(57),
            READ_DATA_FALL      => rd_data_fall(57)
            );


  v4_dq_iob_58 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(58),
            WRITE_DATA_FALL     => wr_data_fall(58),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(58),
            READ_DATA_RISE      => rd_data_rise(58),
            READ_DATA_FALL      => rd_data_fall(58)
            );


  v4_dq_iob_59 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(59),
            WRITE_DATA_FALL     => wr_data_fall(59),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(59),
            READ_DATA_RISE      => rd_data_rise(59),
            READ_DATA_FALL      => rd_data_fall(59)
            );


  v4_dq_iob_60 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(60),
            WRITE_DATA_FALL     => wr_data_fall(60),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(60),
            READ_DATA_RISE      => rd_data_rise(60),
            READ_DATA_FALL      => rd_data_fall(60)
            );


  v4_dq_iob_61 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(61),
            WRITE_DATA_FALL     => wr_data_fall(61),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(61),
            READ_DATA_RISE      => rd_data_rise(61),
            READ_DATA_FALL      => rd_data_fall(61)
            );


  v4_dq_iob_62 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(62),
            WRITE_DATA_FALL     => wr_data_fall(62),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(62),
            READ_DATA_RISE      => rd_data_rise(62),
            READ_DATA_FALL      => rd_data_fall(62)
            );


  v4_dq_iob_63 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(3),
            DATA_DLYCE          => data_idelay_ce(3),
            DATA_DLYRST         => data_idelay_rst(3),
            WRITE_DATA_RISE     => wr_data_rise(63),
            WRITE_DATA_FALL     => wr_data_fall(63),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(63),
            READ_DATA_RISE      => rd_data_rise(63),
            READ_DATA_FALL      => rd_data_fall(63)
            );


  v4_dq_iob_64 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(64),
            WRITE_DATA_FALL     => wr_data_fall(64),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(64),
            READ_DATA_RISE      => rd_data_rise(64),
            READ_DATA_FALL      => rd_data_fall(64)
            );


  v4_dq_iob_65 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(65),
            WRITE_DATA_FALL     => wr_data_fall(65),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(65),
            READ_DATA_RISE      => rd_data_rise(65),
            READ_DATA_FALL      => rd_data_fall(65)
            );


  v4_dq_iob_66 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(66),
            WRITE_DATA_FALL     => wr_data_fall(66),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(66),
            READ_DATA_RISE      => rd_data_rise(66),
            READ_DATA_FALL      => rd_data_fall(66)
            );


  v4_dq_iob_67 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(67),
            WRITE_DATA_FALL     => wr_data_fall(67),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(67),
            READ_DATA_RISE      => rd_data_rise(67),
            READ_DATA_FALL      => rd_data_fall(67)
            );


  v4_dq_iob_68 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(68),
            WRITE_DATA_FALL     => wr_data_fall(68),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(68),
            READ_DATA_RISE      => rd_data_rise(68),
            READ_DATA_FALL      => rd_data_fall(68)
            );


  v4_dq_iob_69 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(69),
            WRITE_DATA_FALL     => wr_data_fall(69),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(69),
            READ_DATA_RISE      => rd_data_rise(69),
            READ_DATA_FALL      => rd_data_fall(69)
            );


  v4_dq_iob_70 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(70),
            WRITE_DATA_FALL     => wr_data_fall(70),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(70),
            READ_DATA_RISE      => rd_data_rise(70),
            READ_DATA_FALL      => rd_data_fall(70)
            );


  v4_dq_iob_71 : mem_interface_top_v4_dq_iob
    port map (
            CLK                 => CLK,
            CLK90               => CLK90,
            DATA_DLYINC         => data_idelay_inc(4),
            DATA_DLYCE          => data_idelay_ce(4),
            DATA_DLYRST         => data_idelay_rst(4),
            WRITE_DATA_RISE     => wr_data_rise(71),
            WRITE_DATA_FALL     => wr_data_fall(71),
            CTRL_WREN           => wr_en,
            DDR_DQ              => DDR_DQ(71),
            READ_DATA_RISE      => rd_data_rise(71),
            READ_DATA_FALL      => rd_data_fall(71)
            );



end arch;
