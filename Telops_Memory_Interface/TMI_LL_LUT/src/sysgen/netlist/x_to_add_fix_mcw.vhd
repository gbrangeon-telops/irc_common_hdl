
-------------------------------------------------------------------
-- System Generator version 10.1.3 VHDL source file.
--
-- Copyright(C) 2008 by Xilinx, Inc.  All rights reserved.  This
-- text/file contains proprietary, confidential information of Xilinx,
-- Inc., is distributed under license from Xilinx, Inc., and may be used,
-- copied and/or disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc.  Xilinx hereby grants you a license to use
-- this text/file solely for design, simulation, implementation and
-- creation of design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly prohibited
-- and immediately terminates your license unless covered by a separate
-- agreement.
--
-- Xilinx is providing this design, code, or information "as is" solely
-- for use in developing programs and solutions for Xilinx devices.  By
-- providing this design, code, or information as one possible
-- implementation of this feature, application or standard, Xilinx is
-- making no representation that this implementation is free from any
-- claims of infringement.  You are responsible for obtaining any rights
-- you may require for your implementation.  Xilinx expressly disclaims
-- any warranty whatsoever with respect to the adequacy of the
-- implementation, including but not limited to warranties of
-- merchantability or fitness for a particular purpose.
--
-- Xilinx products are not intended for use in life support appliances,
-- devices, or systems.  Use in such applications is expressly prohibited.
--
-- Any modifications that are made to the source code are done at the user's
-- sole risk and will be unsupported.
--
-- This copyright and support notice must be retained as part of this
-- text at all times.  (c) Copyright 1995-2008 Xilinx, Inc.  All rights
-- reserved.
-------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use work.conv_pkg.all;

entity x_to_add_fix_mcw is
  port (
    clk_1: in std_logic; -- clock period = 7.5 ns (133.33333333333334 Mhz)
    end_add: in std_logic_vector(15 downto 0); 
    lut_size_m1: in std_logic_vector(15 downto 0); 
    sreset: in std_logic; 
    start_add: in std_logic_vector(15 downto 0); 
    x_min: in std_logic_vector(15 downto 0); 
    x_mosi_data: in std_logic_vector(15 downto 0); 
    x_mosi_dval: in std_logic; 
    x_mosi_eof: in std_logic; 
    x_mosi_sof: in std_logic; 
    x_mosi_support_busy: in std_logic; 
    x_range: in std_logic_vector(15 downto 0); 
    y_miso_afull: in std_logic; 
    y_miso_busy: in std_logic; 
    x_miso_afull: out std_logic; 
    x_miso_busy: out std_logic; 
    y_mosi_data: out std_logic_vector(15 downto 0); 
    y_mosi_dval: out std_logic; 
    y_mosi_eof: out std_logic; 
    y_mosi_sof: out std_logic; 
    y_mosi_support_busy: out std_logic
  );
end x_to_add_fix_mcw;

architecture structural of x_to_add_fix_mcw is
  signal clk_1_sg_x1: std_logic;
  signal end_add_net: std_logic_vector(15 downto 0);
  signal lut_size_m1_net: std_logic_vector(15 downto 0);
  signal sreset_net: std_logic;
  signal start_add_net: std_logic_vector(15 downto 0);
  signal x_min_net: std_logic_vector(15 downto 0);
  signal x_mosi_data_net: std_logic_vector(15 downto 0);
  signal x_mosi_dval_net: std_logic;
  signal x_mosi_eof_net: std_logic;
  signal x_mosi_sof_net: std_logic;
  signal x_mosi_support_busy_net: std_logic;
  signal x_range_net: std_logic_vector(15 downto 0);
  signal y_miso_afull_net: std_logic;
  signal y_miso_afull_net_x0: std_logic;
  signal y_miso_busy_net_x0: std_logic;
  signal y_miso_busy_net_x1: std_logic;
  signal y_mosi_data_net: std_logic_vector(15 downto 0);
  signal y_mosi_dval_net: std_logic;
  signal y_mosi_eof_net: std_logic;
  signal y_mosi_sof_net: std_logic;
  signal y_mosi_support_busy_net: std_logic;

begin
  clk_1_sg_x1 <= clk_1;
  end_add_net <= end_add;
  lut_size_m1_net <= lut_size_m1;
  sreset_net <= sreset;
  start_add_net <= start_add;
  x_min_net <= x_min;
  x_mosi_data_net <= x_mosi_data;
  x_mosi_dval_net <= x_mosi_dval;
  x_mosi_eof_net <= x_mosi_eof;
  x_mosi_sof_net <= x_mosi_sof;
  x_mosi_support_busy_net <= x_mosi_support_busy;
  x_range_net <= x_range;
  y_miso_afull_net <= y_miso_afull;
  y_miso_busy_net_x0 <= y_miso_busy;
  x_miso_afull <= y_miso_afull_net_x0;
  x_miso_busy <= y_miso_busy_net_x1;
  y_mosi_data <= y_mosi_data_net;
  y_mosi_dval <= y_mosi_dval_net;
  y_mosi_eof <= y_mosi_eof_net;
  y_mosi_sof <= y_mosi_sof_net;
  y_mosi_support_busy <= y_mosi_support_busy_net;

  x_to_add_fix_x0: entity work.x_to_add_fix
    port map (
      ce_1 => '1',
      clk_1 => clk_1_sg_x1,
      end_add => end_add_net,
      lut_size_m1 => lut_size_m1_net,
      sreset => sreset_net,
      start_add => start_add_net,
      x_min => x_min_net,
      x_mosi_data => x_mosi_data_net,
      x_mosi_dval => x_mosi_dval_net,
      x_mosi_eof => x_mosi_eof_net,
      x_mosi_sof => x_mosi_sof_net,
      x_mosi_support_busy => x_mosi_support_busy_net,
      x_range => x_range_net,
      y_miso_afull => y_miso_afull_net,
      y_miso_busy => y_miso_busy_net_x0,
      x_miso_afull => y_miso_afull_net_x0,
      x_miso_busy => y_miso_busy_net_x1,
      y_mosi_data => y_mosi_data_net,
      y_mosi_dval => y_mosi_dval_net,
      y_mosi_eof => y_mosi_eof_net,
      y_mosi_sof => y_mosi_sof_net,
      y_mosi_support_busy => y_mosi_support_busy_net
    );

end structural;
