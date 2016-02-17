-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_v4_dq_iob.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Places the data in the IOBs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_v4_dq_iob is
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
end mem_interface_top_v4_dq_iob;

architecture arch of mem_interface_top_v4_dq_iob is

  signal dq_in         : std_logic;
  signal dq_out        : std_logic;
  signal dq_delayed    : std_logic;
  signal write_en_L    : std_logic;
  signal write_en_L_r1 : std_logic;
  signal vcc           : std_logic;
  signal gnd           : std_logic;


begin


  vcc <= '1';
  gnd <= '0';

  write_en_L <= not CTRL_WREN;

  oddr_dq : ODDR
    generic map(
      SRTYPE       => "SYNC",
      DDR_CLK_EDGE => "SAME_EDGE"
      )
    port map(
      Q  => dq_out,
      C  => CLK90,
      CE => vcc,
      D1 => WRITE_DATA_RISE,
      D2 => WRITE_DATA_FALL,
      R  => gnd,
      S  => gnd
      );

  tri_state_dq : FDCE
    port map(
      Q   => write_en_L_r1,
      C   => CLK90,
      CE  => vcc,
      CLR => gnd,
      D   => write_en_L
      );

  iobuf_dq : IOBUF port map
    (
      I  => dq_out,
      T  => write_en_L_r1,
      IO => DDR_DQ,
      O  => dq_in
      );

  idelay_dq : IDELAY
    generic map(
      IOBDELAY_TYPE  => "VARIABLE",
      IOBDELAY_VALUE => 0
      )
    port map(
      O   => dq_delayed,
      I   => dq_in,
      C   => CLK,
      CE  => DATA_DLYCE,
      INC => DATA_DLYINC,
      RST => DATA_DLYRST
      );

  iddr_dq : IDDR
    generic map(
      SRTYPE       => "SYNC",
      DDR_CLK_EDGE => "SAME_EDGE_PIPELINED"
      )
    port map (
      Q1 => READ_DATA_RISE,
      Q2 => READ_DATA_FALL,
      C  => CLK,
      CE => vcc,
      D  => dq_delayed,
      R  => gnd,
      S  => gnd
      );

end arch;
