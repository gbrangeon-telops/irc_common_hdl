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
--  /   /        Filename           : mig_data_path_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: This module instantiates data, data strobe and the data mask
--              iobs.
-- Revision History:
--   Rev 1.1 - DM_IOB instance made based on USE_DM_PORT value . PK. 25/6/08
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_data_path_iobs_0 is
  port (
    clk             : in    std_logic;
    clk90           : in    std_logic;
    reset0          : in    std_logic;
    dqs_rst         : in    std_logic;
    dqs_en          : in    std_logic;
    data_idelay_inc : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    data_idelay_ce  : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    data_idelay_rst : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    delay_enable    : in    std_logic_vector(DATA_WIDTH-1 downto 0);
    wr_data_rise    : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    wr_data_fall    : in    std_logic_vector((DATA_WIDTH - 1) downto 0);
    wr_en           : in    std_logic;
    mask_data_rise  : in    std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    mask_data_fall  : in    std_logic_vector((DATA_MASK_WIDTH - 1) downto 0);
    ddr_dq          : inout std_logic_vector((DATA_WIDTH - 1) downto 0);
    ddr_dqs         : inout std_logic_vector((DATA_STROBE_WIDTH - 1) downto 0);
    rd_data_rise    : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
    rd_data_fall    : out   std_logic_vector((DATA_WIDTH - 1) downto 0);
    ddr_dm          : out   std_logic_vector((DATA_MASK_WIDTH - 1) downto 0)
    );
end mig_data_path_iobs_0;

architecture arch of mig_data_path_iobs_0 is

  component mig_v4_dqs_iob
    port(
      clk               : in std_logic;
      reset0            : in std_logic;
      ctrl_dqs_rst      : in std_logic;
      ctrl_dqs_en       : in std_logic;
      ddr_dqs           : inout std_logic
      );
  end component;

  component mig_v4_dm_iob
    port(
      clk90             : in std_logic;
      mask_data_rise    : in std_logic;
      mask_data_fall    : in std_logic;
      ddr_dm            : out std_logic
      );
  end component;

  component mig_v4_dq_iob
    port (
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
      read_data_rise  : out   std_logic;
      read_data_fall  : out   std_logic;
      ddr_dq          : inout std_logic
      );
  end component;

  component mig_idelay_rd_en_io_0
    port(
      clk              : in  std_logic;
      clk90            : in  std_logic;
      data_dlyinc      : in  std_logic;
      data_dlyce       : in  std_logic;
      data_dlyrst      : in  std_logic;
      ctrl_rd_en       : in  std_logic;
      read_en_in       : in  std_logic;
      read_en_out      : out std_logic;
      rd_en_delayed_r1 : out std_logic;
      rd_en_delayed_r2 : out std_logic
      );
  end component;

begin

  --***************************************************************************

  --***************************************************************************
  -- DQS instances
  --***************************************************************************
  gen_dqs: for dqs_i in 0 to DATA_STROBE_WIDTH-1 generate
    v4_dqs_iob  : mig_v4_dqs_iob
      port map (
        clk          => clk,
        reset0       => reset0,
        ctrl_dqs_rst => dqs_rst,
        ctrl_dqs_en  => dqs_en,
        ddr_dqs      => ddr_dqs(dqs_i)
        );
  end generate;

  --***************************************************************************
  --                    DM instances
  --***************************************************************************

  gen_dm_inst: if (USE_DM_PORT = 1) generate
    gen_dm : for dm_i in 0 to DATA_MASK_WIDTH-1 generate
      v4_dm_iob : mig_v4_dm_iob
        port map (
          clk90           => clk90,
          mask_data_rise  => mask_data_rise(dm_i),
          mask_data_fall  => mask_data_fall(dm_i),
          ddr_dm          => ddr_dm(dm_i)
          );
    end generate;
  end generate;

  --***************************************************************************
  -- DQ IOB instances
  --***************************************************************************

  gen_dq: for dq_i in 0 to DATA_WIDTH-1 generate
    v4_dq_iob : mig_v4_dq_iob
      port map (
        clk             => clk,
        clk90           => clk90,
        reset0          => reset0,
        data_dlyinc     => data_idelay_inc(dq_i),
        data_dlyce      => data_idelay_ce(dq_i),
        data_dlyrst     => data_idelay_rst(dq_i),
        write_data_rise => wr_data_rise(dq_i),
        write_data_fall => wr_data_fall(dq_i),
        ctrl_wren       => wr_en,
        delay_enable    => delay_enable(dq_i),
        ddr_dq          => ddr_dq(dq_i),
        read_data_rise  => rd_data_rise(dq_i),
        read_data_fall  => rd_data_fall(dq_i)
        );
  end generate;


end arch;
