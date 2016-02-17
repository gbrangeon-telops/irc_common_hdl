-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_v4_dm_iob.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Places the data mask signals into the IOBs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_v4_dm_iob is
  port(
    CLK90          : in  std_logic;
    MASK_DATA_RISE : in  std_logic;
    MASK_DATA_FALL : in  std_logic;
    DDR_DM         : out std_logic
    );
end mem_interface_top_v4_dm_iob;

architecture arch of mem_interface_top_v4_dm_iob is

  signal vcc       : std_logic;
  signal gnd       : std_logic;
  signal data_mask : std_logic;

begin

  vcc <= '1';
  gnd <= '0';

  oddr_dm : ODDR
    generic map(
      SRTYPE       => "SYNC",
      DDR_CLK_EDGE => "SAME_EDGE"
      )
    port map(
      Q  => data_mask,
      C  => CLK90,
      CE => vcc,
      D1 => MASK_DATA_RISE,
      D2 => MASK_DATA_FALL,
      R  => gnd,
      S  => gnd
      );

  DM_OBUF : OBUF
    port map (
      I => data_mask,
      O => DDR_DM
      );


end arch;
