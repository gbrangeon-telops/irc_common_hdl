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
--  /   /        Filename           : mig_data_tap_inc.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description : This module implements the tap selection for data
--               bits associated with a strobe.
-- Revision History:
--   Rev 1.1 - Changes for V4 no edge straddle calibration scheme. Added
--             PER_BIT_SKEW output and various other changes. JYO. 6/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_data_tap_inc_0 is
  port (
    clk                : in  std_logic;
    reset              : in  std_logic;
    calibration_dq     : in  std_logic_vector(DATABITSPERSTROBE-1 downto 0);
    ctrl_calib_start   : in  std_logic;
    dlyinc             : in  std_logic;
    dlyce              : in  std_logic;
    chan_done          : in  std_logic;
    dq_data            : out std_logic;
    data_dlyinc        : out std_logic_vector(DATABITSPERSTROBE-1 downto 0);
    data_dlyce         : out std_logic_vector(DATABITSPERSTROBE-1 downto 0);
    data_dlyrst        : out std_logic_vector(DATABITSPERSTROBE-1 downto 0);
    calib_done         : out std_logic;
    per_bit_skew       : out std_logic_vector(DATABITSPERSTROBE-1 downto 0)
    );
end entity;

architecture arc_data_tap_inc of mig_data_tap_inc_0 is

  signal muxout_d0d1       : std_logic;
  signal muxout_d2d3       : std_logic;
  signal muxout_d4d5       : std_logic;
  signal muxout_d6d7       : std_logic;
  signal muxout_d0_to_d3   : std_logic;
  signal muxout_d4_to_d7   : std_logic;
  signal data_dlyinc_int   : std_logic_vector(DATABITSPERSTROBE-1 downto 0);
  signal data_dlyce_int    : std_logic_vector(DATABITSPERSTROBE-1 downto 0);
  signal calib_done_int    : std_logic;
  signal calib_done_int_r1 : std_logic;
  signal calibration_dq_r  : std_logic_vector(DATABITSPERSTROBE-1 downto 0);

  signal chan_sel_int      : std_logic_vector(DATABITSPERSTROBE-1 downto 0);
  signal chan_sel          : std_logic_vector(DATABITSPERSTROBE-1 downto 0);

  signal reset_r1          : std_logic;

  attribute max_fanout : string;
  attribute syn_maxfan : integer;
  attribute max_fanout of calibration_dq_r : signal is "5";
  attribute syn_maxfan of calibration_dq_r : signal is 5;
  attribute max_fanout of chan_sel_int     : signal is "5";
  attribute syn_maxfan of chan_sel_int     : signal is 5;

  attribute equivalent_register_removal : string;
  attribute syn_preserve                : boolean;
  attribute equivalent_register_removal of reset_r1 : signal is "no";
  attribute syn_preserve of reset_r1                : signal is true;
  attribute equivalent_register_removal of calibration_dq_r : signal is "no";
  attribute syn_preserve of calibration_dq_r                : signal is true;

begin

  --***************************************************************************

  data_dlyinc <= data_dlyinc_int;
  data_dlyce  <= data_dlyce_int;
  data_dlyrst <= (reset_r1 & reset_r1 & reset_r1 & reset_r1 );
  calib_done  <= calib_done_int;

  process(clk)
  begin
    if (clk = '1' and clk'event) then
      reset_r1 <= reset;
    end if;
  end process;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      calibration_dq_r <= calibration_dq;
    end if;
  end process;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      calib_done_int_r1 <= calib_done_int;
    end if;
  end process;



   -- DQ Data Select Mux
   -- Stage 1 Muxes
   muxout_d0d1 <= calibration_dq_r(1) when (chan_sel(1) = '1')
                  else calibration_dq_r(0);
   muxout_d2d3 <= calibration_dq_r(3) when (chan_sel(3) = '1')
                  else calibration_dq_r(2);

   -- Stage 2 Muxes
   dq_data <= muxout_d2d3 when (chan_sel(2) = '1' or chan_sel(3) = '1')
              else muxout_d0d1;


  -- RC: After calibration is complete, the Q1 output of each IDDR in the DQS
  -- group is recorded. It should either be a static 1 or 0, depending on
  -- which bit time is aligned to the rising edge of the FPGA CLK. If some
  -- of the bits are 0, and some are 1 - this indicates there is "bit-
  -- misalignment" within that DQS group. This will be handled later during
  -- pattern calibration and by enabling the delay/swap circuit to delay
  -- certain IDDR outputs by one bit time. For now, just record this "offset
  -- pattern" and provide this to the pattern calibration logic.
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset_r1 = '1' or (not(calib_done_int)) = '1') then
        per_bit_skew <= (others => '0');
      elsif (calib_done_int = '1' and (not(calib_done_int_r1)) = '1') then
        -- Store offset pattern immediately after per-bit calib finished
        per_bit_skew <= calibration_dq;
      end if;
    end if;
  end process;

  dlyce_dlyinc : for i in 0 to DATABITSPERSTROBE-1 generate
  begin
    data_dlyce_int(i)  <= dlyce  when(chan_sel(i) = '1') else '0';
    data_dlyinc_int(i) <= dlyinc when(chan_sel(i) = '1') else '0';
  end generate dlyce_dlyinc;

  -- Module that controls the calib_done
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset_r1 = '1') then
        calib_done_int <= '0';
      elsif(ctrl_calib_start = '1') then
        if (chan_sel = ADD_CONST3(DATABITSPERSTROBE-1 downto 0)) then
          calib_done_int <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Module that controls the chan_sel
  process(clk)
  begin
    if (clk'event and clk = '1') then
      if (reset_r1 = '1') then
        chan_sel_int <= ADD_CONST6((DATABITSPERSTROBE-1) downto 0);
      elsif(ctrl_calib_start = '1') then
        if (chan_done = '1') then
          chan_sel_int((DATABITSPERSTROBE-1) downto 1) <= chan_sel_int((DATABITSPERSTROBE-2) downto 0);
          chan_sel_int(0) <= '0';
        end if;
      end if;
    end if;
  end process;

  chan_sel_gen : for j in 0 to DATABITSPERSTROBE-1 generate
  begin
    chan_sel(j) <= chan_sel_int(j);
  end generate chan_sel_gen;


end arc_data_tap_inc;
