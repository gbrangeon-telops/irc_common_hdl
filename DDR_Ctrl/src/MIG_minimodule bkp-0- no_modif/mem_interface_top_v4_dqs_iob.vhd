-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_v4_dqs_iob.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Places the data stobes in the IOBs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_v4_dqs_iob is
  port(
    CLK          : in    std_logic;
    DLYINC       : in    std_logic;
    DLYCE        : in    std_logic;
    DLYRST       : in    std_logic;
    CTRL_DQS_RST : in    std_logic;
    CTRL_DQS_EN  : in    std_logic;
    DDR_DQS      : inout std_logic;
    DQS_RISE     : out   std_logic
    );
end mem_interface_top_v4_dqs_iob;

architecture arch of mem_interface_top_v4_dqs_iob is

  signal dqs_in         : std_logic;
  signal dqs_out        : std_logic;
  signal dqs_out_l      : std_logic;
  signal dqs_delayed    : std_logic;
  signal ctrl_dqs_en_r1 : std_logic;
  signal vcc            : std_logic;
  signal gnd            : std_logic;
  signal clk180         : std_logic;
  signal dqs_int        : std_logic;
  signal data1          : std_logic;

begin

  vcc    <= '1';
  gnd    <= '0';
  clk180 <= not CLK;

  process(clk180)
  begin
    if(clk180'event and clk180 = '1') then
      if (CTRL_DQS_RST = '1') then
        data1 <= '0';
      else
        data1 <= '1';
      end if;
    end if;
  end process;

  idelay_dqs : IDELAY
    generic map(
      IOBDELAY_TYPE  => "VARIABLE",
      IOBDELAY_VALUE => 0
      )
    port map(
      O   => dqs_delayed,
      I   => dqs_in,
      C   => CLK,
      CE  => DLYCE,
      INC => DLYINC,
      RST => DLYRST
      );

  dqs_pipe1 : FD
    port map(
      Q => dqs_int,
      C => CLK,
      D => dqs_delayed
      );

  dqs_pipe2 : FD
    port map
    (Q  => DQS_RISE,
      C => CLK,
      D => dqs_int
      );

  oddr_dqs : ODDR
    generic map(
      SRTYPE       => "SYNC",
      DDR_CLK_EDGE => "OPPOSITE_EDGE"
      )
    port map
    (Q   => dqs_out,
      C  => clk180,
      CE => vcc,
      D1 => data1,
      D2 => gnd,
      R  => gnd,
      S  => gnd
      );

  tri_state_dqs : FD
    port map (
      Q => ctrl_dqs_en_r1,
      C => clk180,
      D => CTRL_DQS_EN
      );

  iobuf_dqs : IOBUF
    port map (
      I  => dqs_out,
      T  => ctrl_dqs_en_r1,
      IO => DDR_DQS,
      O  => dqs_in
      );

end arch;
