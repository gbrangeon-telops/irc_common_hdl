
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

entity histogram_mcw is
  port (
    areset: in std_logic; 
    clear_mem: in std_logic; 
    clk_1: in std_logic; -- clock period = 7.5 ns (133.33333333333334 Mhz)
    ext_data_in: in std_logic_vector(31 downto 0); 
    rx_miso_busy: in std_logic; 
    rx_mosi_data: in std_logic_vector(15 downto 0); 
    rx_mosi_dval: in std_logic; 
    rx_mosi_eof: in std_logic; 
    rx_mosi_sof: in std_logic; 
    tmi_mosi_add: in std_logic_vector(9 downto 0); 
    tmi_mosi_dval: in std_logic; 
    tmi_mosi_rnw: in std_logic; 
    ext_data_out: out std_logic_vector(31 downto 0); 
    histogram_rdy: out std_logic; 
    timestamp: out std_logic_vector(31 downto 0); 
    tmi_miso_busy: out std_logic; 
    tmi_miso_error: out std_logic; 
    tmi_miso_idle: out std_logic; 
    tmi_miso_rd_data: out std_logic_vector(20 downto 0); 
    tmi_miso_rd_dval: out std_logic
  );
end histogram_mcw;

architecture structural of histogram_mcw is
  signal areset_net: std_logic;
  signal clear_mem_net: std_logic;
  signal clk_1_sg_x2: std_logic;
  signal ext_data_in_net: std_logic_vector(31 downto 0);
  signal ext_data_out_net: std_logic_vector(31 downto 0);
  signal histogram_rdy_net: std_logic;
  signal rx_miso_busy_net: std_logic;
  signal rx_mosi_data_net: std_logic_vector(15 downto 0);
  signal rx_mosi_dval_net: std_logic;
  signal rx_mosi_eof_net: std_logic;
  signal rx_mosi_sof_net: std_logic;
  signal timestamp_net: std_logic_vector(31 downto 0);
  signal tmi_miso_busy_net: std_logic;
  signal tmi_miso_error_net: std_logic;
  signal tmi_miso_idle_net: std_logic;
  signal tmi_miso_rd_data_net: std_logic_vector(20 downto 0);
  signal tmi_miso_rd_dval_net: std_logic;
  signal tmi_mosi_add_net: std_logic_vector(9 downto 0);
  signal tmi_mosi_dval_net: std_logic;
  signal tmi_mosi_rnw_net: std_logic;

begin
  areset_net <= areset;
  clear_mem_net <= clear_mem;
  clk_1_sg_x2 <= clk_1;
  ext_data_in_net <= ext_data_in;
  rx_miso_busy_net <= rx_miso_busy;
  rx_mosi_data_net <= rx_mosi_data;
  rx_mosi_dval_net <= rx_mosi_dval;
  rx_mosi_eof_net <= rx_mosi_eof;
  rx_mosi_sof_net <= rx_mosi_sof;
  tmi_mosi_add_net <= tmi_mosi_add;
  tmi_mosi_dval_net <= tmi_mosi_dval;
  tmi_mosi_rnw_net <= tmi_mosi_rnw;
  ext_data_out <= ext_data_out_net;
  histogram_rdy <= histogram_rdy_net;
  timestamp <= timestamp_net;
  tmi_miso_busy <= tmi_miso_busy_net;
  tmi_miso_error <= tmi_miso_error_net;
  tmi_miso_idle <= tmi_miso_idle_net;
  tmi_miso_rd_data <= tmi_miso_rd_data_net;
  tmi_miso_rd_dval <= tmi_miso_rd_dval_net;

  histogram_x0: entity work.histogram
    port map (
      areset => areset_net,
      ce_1 => '1',
      clear_mem => clear_mem_net,
      clk_1 => clk_1_sg_x2,
      ext_data_in => ext_data_in_net,
      rx_miso_busy => rx_miso_busy_net,
      rx_mosi_data => rx_mosi_data_net,
      rx_mosi_dval => rx_mosi_dval_net,
      rx_mosi_eof => rx_mosi_eof_net,
      rx_mosi_sof => rx_mosi_sof_net,
      tmi_mosi_add => tmi_mosi_add_net,
      tmi_mosi_dval => tmi_mosi_dval_net,
      tmi_mosi_rnw => tmi_mosi_rnw_net,
      ext_data_out => ext_data_out_net,
      histogram_rdy => histogram_rdy_net,
      timestamp => timestamp_net,
      tmi_miso_busy => tmi_miso_busy_net,
      tmi_miso_error => tmi_miso_error_net,
      tmi_miso_idle => tmi_miso_idle_net,
      tmi_miso_rd_data => tmi_miso_rd_data_net,
      tmi_miso_rd_dval => tmi_miso_rd_dval_net
    );

end structural;
