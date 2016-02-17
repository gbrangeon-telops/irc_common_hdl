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
--  /   /        Filename           : mig_v4_dqs_iob.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Places the data stobes in the IOBs.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_v4_dqs_iob is
  port(
    clk          : in    std_logic;
    reset0       : in    std_logic;
    ctrl_dqs_rst : in    std_logic;
    ctrl_dqs_en  : in    std_logic;
    ddr_dqs      : inout std_logic
    );
end mig_v4_dqs_iob;

architecture arch of mig_v4_dqs_iob is

  signal dqs_in         : std_logic;
  signal dqs_out        : std_logic;
  signal dqs_out_l      : std_logic;
  signal ctrl_dqs_en_r1 : std_logic;
  signal vcc            : std_logic;
  signal gnd            : std_logic;
  signal clk180         : std_logic;
  signal data1          : std_logic;
  signal reset0_r1      : std_logic;

  attribute IOB : string;
  attribute IOB of tri_state_dqs : label is "true";
  attribute syn_useioff : boolean;
  attribute syn_useioff of tri_state_dqs : label is true;

  attribute equivalent_register_removal : string;
  attribute syn_preserve                : boolean;
  attribute equivalent_register_removal of reset0_r1 : signal is "no";
  attribute syn_preserve of reset0_r1                : signal is true;

begin

  --***************************************************************************

  vcc    <= '1';
  gnd    <= '0';
  clk180 <= not clk;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      reset0_r1 <= reset0;
    end if;
  end process;

  process(clk180)
  begin
    if(clk180'event and clk180 = '1') then
      if (ctrl_dqs_rst = '1') then
        data1 <= '0';
      else
        data1 <= '1';
      end if;
    end if;
  end process;


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

  tri_state_dqs : FDP
    port map (
      Q   => ctrl_dqs_en_r1,
      C   => clk180,
      D   => ctrl_dqs_en,
      PRE => gnd
      );

  iobuf_dqs : IOBUF
    port map (
      I  => dqs_out,
      T  => ctrl_dqs_en_r1,
      IO => ddr_dqs,
      O  => dqs_in
      );

end arch;
