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
--  /   /        Filename           : mig_v4_dq_iob.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Places the data in the IOBs.
-- Revision History:
--   Rev 1.1 - Changes for V4 no edge straddle calibration scheme.
--             Optional circuit to delay the bit by one bit time.
--             Various other changes. JYO. 6/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_v4_dq_iob is
  port(
    clk             : in    std_logic;
    clk90           : in    std_logic;
    reset0          : in    std_logic;
    data_dlyinc     : in    std_logic;
    data_dlyce      : in    std_logic;
    data_dlyrst     : in    std_logic;
    write_data_rise : in    std_logic;
    write_data_fall : in    std_logic;
    ctrl_wren       : in    std_logic;
    delay_enable    : in    std_logic;
    ddr_dq          : inout std_logic;
    read_data_rise  : out   std_logic;
    read_data_fall  : out   std_logic
    );
end mig_v4_dq_iob;

architecture arch of mig_v4_dq_iob is

  signal dq_in         : std_logic;
  signal dq_out        : std_logic;
  signal dq_delayed    : std_logic;
  signal write_en_l    : std_logic;
  signal write_en_l_r1 : std_logic;
  signal dq_q1         : std_logic;
  signal dq_q2         : std_logic;
  signal dq_q1_r       : std_logic;
  signal vcc           : std_logic;
  signal gnd           : std_logic;
  signal reset0_r1      : std_logic;

  attribute IOB : string;
  attribute IOB of tri_state_dq : label is "true";
  attribute syn_useioff : boolean;
  attribute syn_useioff of tri_state_dq : label is true;

  attribute equivalent_register_removal : string;
  attribute syn_preserve                : boolean;
  attribute equivalent_register_removal of reset0_r1 : signal is "no";
  attribute syn_preserve of reset0_r1                : signal is true;

begin

  --***************************************************************************

  vcc <= '1';
  gnd <= '0';

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      reset0_r1 <= reset0;
    end if;
  end process;

  write_en_l <= not ctrl_wren;

  oddr_dq : ODDR
    generic map(
      SRTYPE       => "SYNC",
      DDR_CLK_EDGE => "SAME_EDGE"
      )
    port map(
      Q  => dq_out,
      C  => clk90,
      CE => vcc,
      D1 => write_data_rise,
      D2 => write_data_fall,
      R  => gnd,
      S  => gnd
      );

  tri_state_dq : FDPE
    port map(
      Q   => write_en_l_r1,
      C   => clk90,
      D   => write_en_l,
      PRE => gnd,
      CE  => vcc
      );

  iobuf_dq : IOBUF port map
    (
      I  => dq_out,
      T  => write_en_l_r1,
      IO => ddr_dq,
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
      C   => clk,
      CE  => data_dlyce,
      INC => data_dlyinc,
      RST => data_dlyrst
      );

  iddr_dq : IDDR
    generic map(
      SRTYPE       => "SYNC",
      DDR_CLK_EDGE => "SAME_EDGE"
      )
    port map (
      Q1 => dq_q1,
      Q2 => dq_q2,
      C  => clk,
      CE => vcc,
      D  => dq_delayed,
      R  => gnd,
      S  => gnd
      );

   --*******************************************************************
   -- RC: Optional circuit to delay the bit by one bit time - may be
   -- necessary if there is bit-misalignment (e.g. rising edge of FPGA
   -- clock may be capturing bit[n] for DQ[0] but bit[n+1] for DQ[1])
   -- within a DQS group. The operation for delaying by one bit time
   -- involves delaying the Q1 (rise) output of the IDDR, and "flipping"
   -- the Q bits
   --*******************************************************************

   u_fd_dly_q1 : FDRSE
    port map (
      Q   => dq_q1_r,
      C   => clk,
      CE  => vcc,
      D   => dq_q1,
      R   => gnd,
      S   => gnd
      );

  read_data_rise <= dq_q2 when (delay_enable = '1') else dq_q1;
  read_data_fall <= dq_q1_r when (delay_enable = '1') else dq_q2  ;

end arch;
