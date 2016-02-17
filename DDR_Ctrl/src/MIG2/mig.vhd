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
--  /   /        Filename           : mig.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description     : It is the top most module which interfaces with the system
--                         and the memory.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig is
  port (
      cntrl0_ddr_dq                 : inout std_logic_vector(71 downto 0);
      cntrl0_ddr_a                  : out   std_logic_vector(12 downto 0);
      cntrl0_ddr_ba                 : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_cke                : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_cs_n               : out   std_logic_vector(1 downto 0);
      cntrl0_ddr_ras_n              : out   std_logic;
      cntrl0_ddr_cas_n              : out   std_logic;
      cntrl0_ddr_we_n               : out   std_logic;
      cntrl0_ddr_reset_n            : out   std_logic;
      init_done                     : out   std_logic;
      sys_reset_in_n                : in    std_logic;
      cntrl0_clk_tb                 : out   std_logic;
      cntrl0_reset_tb               : out   std_logic;
      cntrl0_wdf_almost_full        : out   std_logic;
      cntrl0_af_almost_full         : out   std_logic;
      cntrl0_read_data_valid        : out   std_logic;
      cntrl0_app_wdf_wren           : in    std_logic;
      cntrl0_app_af_wren            : in    std_logic;
      cntrl0_burst_length_div2      : out   std_logic_vector(2 downto 0);
      cntrl0_app_af_addr            : in    std_logic_vector(35 downto 0);
      cntrl0_app_wdf_data           : in    std_logic_vector(143 downto 0);
      cntrl0_read_data_fifo_out     : out   std_logic_vector(143 downto 0);
      clk_0                         : in    std_logic;
      clk_90                        : in    std_logic;
      clk_200                       : in    std_logic;
      dcm_lock                      : in    std_logic;
      cntrl0_ddr_dqs                : inout std_logic_vector(17 downto 0);
      cntrl0_ddr_ck                 : out   std_logic_vector(0 downto 0);
      cntrl0_ddr_ck_n               : out   std_logic_vector(0 downto 0)
      );
end mig;

architecture arc_mem_interface_top of mig is

        attribute X_CORE_INFO : string;
        attribute X_CORE_INFO of arc_mem_interface_top : architecture IS
        "mig_v2_3_b1_ddr_v4, Coregen 10.1.02";

        attribute CORE_GENERATION_INFO : string;
        attribute CORE_GENERATION_INFO of arc_mem_interface_top : architecture IS
        "ddr_v4,mig_v2_3,{component_name=mig, data_width=72,  data_strobe_width=18, data_mask_width=9, clk_width=1, fifo_16=5, row_address=13, memory_width=4, cs_width=1, data_mask=0, reset_port=1, cke_width=1, reg_enable=1, mask_enable=0, column_address=11, bank_address=2, load_mode_register=0000001100001, ext_load_mode_register=0000000000000, chip_address=1, reset_active_low=1, rcd_count_value=001, ras_count_value=0011, tmrd_count_value=000, rp_count_value=001, rfc_count_value=000110, twr_count_value=110, twtr_count_value=100, max_ref_width=10, max_ref_cnt=1011111000}";

component mig_top_0
port(
        ddr_dq                : inout std_logic_vector(71 downto 0);
      ddr_a                 : out   std_logic_vector(12 downto 0);
      ddr_ba                : out   std_logic_vector(1 downto 0);
      ddr_cke               : out   std_logic_vector(1 downto 0);
      ddr_cs_n              : out   std_logic_vector(1 downto 0);
      ddr_ras_n             : out   std_logic;
      ddr_cas_n             : out   std_logic;
      ddr_we_n              : out   std_logic;
      ddr_reset_n           : out   std_logic;
      init_done             : out   std_logic;
      clk_tb                : out   std_logic;
      reset_tb              : out   std_logic;
      wdf_almost_full       : out   std_logic;
      af_almost_full        : out   std_logic;
      read_data_valid       : out   std_logic;
      app_wdf_wren          : in    std_logic;
      app_af_wren           : in    std_logic;
      burst_length_div2     : out   std_logic_vector(2 downto 0);
      app_af_addr           : in    std_logic_vector(35 downto 0);
      app_wdf_data          : in    std_logic_vector(143 downto 0);
      read_data_fifo_out    : out   std_logic_vector(143 downto 0);
      app_mask_data         : in    std_logic_vector(17 downto 0);
      ddr_dqs               : inout std_logic_vector(17 downto 0);
      ddr_ck                : out   std_logic_vector(0 downto 0);
      ddr_ck_n              : out   std_logic_vector(0 downto 0);
      ddr_dm                : out   std_logic_vector(8 downto 0);
      clk_0                 : in    std_logic;
      clk_90                : in    std_logic;
   
   sys_rst                        : in std_logic;   
   sys_rst90                      : in std_logic;   
      --Debug ports
      dbg_idel_up_all              : in   std_logic;
      dbg_idel_down_all            : in   std_logic;
      dbg_idel_up_dq               : in   std_logic;
      dbg_idel_down_dq             : in   std_logic;
      dbg_sel_idel_dq              : in   std_logic_vector(6 downto 0);
      dbg_sel_all_idel_dq          : in   std_logic;
      dbg_calib_dq_tap_cnt         : out   std_logic_vector(431 downto 0);
      dbg_data_tap_inc_done        : out   std_logic_vector(17 downto 0);
      dbg_sel_done                 : out   std_logic;
      dbg_first_rising             : out   std_logic_vector(17 downto 0);
      dbg_cal_first_loop           : out   std_logic_vector(17 downto 0);
      dbg_comp_done                : out   std_logic_vector(17 downto 0);
      dbg_comp_error               : out   std_logic_vector(17 downto 0);
      dbg_init_done                : out   std_logic
  );
end component;

  component mig_infrastructure
    port(
      idelay_ctrl_rdy                : in std_logic;
      sys_rst                        : out std_logic;
      sys_rst90                      : out std_logic;
      sys_rst_r1                     : out std_logic;
      sys_reset_in_n        : in    std_logic;
      clk_0                 : in    std_logic;
      clk_90                : in    std_logic;
      clk_200               : in    std_logic;
      dcm_lock              : in    std_logic
      );
  end component;

  component mig_idelay_ctrl
    port (
      clk200     : in  std_logic;
      reset      : in  std_logic;
      rdy_status : out std_logic
      );
  end component;



  signal sys_rst         : std_logic;
  signal sys_rst90       : std_logic;
  signal idelay_ctrl_rdy : std_logic;
  signal sys_rst_r1      : std_logic;

   signal dbg_idel_up_all              : std_logic;
  signal dbg_idel_down_all            : std_logic;
  signal dbg_idel_up_dq               : std_logic;
  signal dbg_idel_down_dq             : std_logic;
  signal dbg_sel_idel_dq              : std_logic_vector(6 downto 0);
  signal dbg_sel_all_idel_dq          : std_logic;
  signal dbg_calib_dq_tap_cnt         : std_logic_vector(431 downto 0);
  signal dbg_data_tap_inc_done        : std_logic_vector(17 downto 0);
  signal dbg_sel_done                 : std_logic;
  signal dbg_first_rising             : std_logic_vector(17 downto 0);
  signal dbg_cal_first_loop           : std_logic_vector(17 downto 0);
  signal dbg_comp_done                : std_logic_vector(17 downto 0);
  signal dbg_comp_error               : std_logic_vector(17 downto 0);
  signal dbg_init_done                : std_logic;

  --***********************************
  -- PHY Debug Port demo
  --***********************************
  signal cs_control0 : std_logic_vector(35 downto 0);
  signal cs_control1 : std_logic_vector(35 downto 0);
  signal cs_control2 : std_logic_vector(35 downto 0);
  signal vio0_in     : std_logic_vector(192 downto 0);
  signal vio1_in     : std_logic_vector(42 downto 0);
  signal vio2_out    : std_logic_vector(9 downto 0);

  attribute syn_useioff : boolean ;
  attribute syn_useioff of arc_mem_interface_top : architecture is true;

begin

  --***************************************************************************

 top_00 :    mig_top_0
    port map (
      ddr_dq                => cntrl0_ddr_dq,
      ddr_a                 => cntrl0_ddr_a,
      ddr_ba                => cntrl0_ddr_ba,
      ddr_cke               => cntrl0_ddr_cke,
      ddr_cs_n              => cntrl0_ddr_cs_n,
      ddr_ras_n             => cntrl0_ddr_ras_n,
      ddr_cas_n             => cntrl0_ddr_cas_n,
      ddr_we_n              => cntrl0_ddr_we_n,
      ddr_reset_n           => cntrl0_ddr_reset_n,
      init_done             => init_done,
      clk_tb                => cntrl0_clk_tb,
      reset_tb              => cntrl0_reset_tb,
      wdf_almost_full       => cntrl0_wdf_almost_full,
      af_almost_full        => cntrl0_af_almost_full,
      read_data_valid       => cntrl0_read_data_valid,
      app_wdf_wren          => cntrl0_app_wdf_wren,
      app_af_wren           => cntrl0_app_af_wren,
      burst_length_div2     => cntrl0_burst_length_div2,
      app_af_addr           => cntrl0_app_af_addr,
      app_wdf_data          => cntrl0_app_wdf_data,
      read_data_fifo_out    => cntrl0_read_data_fifo_out,
      app_mask_data         => (others => '0'),
      ddr_dqs               => cntrl0_ddr_dqs,
      ddr_ck                => cntrl0_ddr_ck,
      ddr_ck_n              => cntrl0_ddr_ck_n,
      ddr_dm               => open,
      clk_0                 => clk_0,
      clk_90                => clk_90,
   
   sys_rst                        => sys_rst,
   sys_rst90                      => sys_rst90,

    --Debug signals
      dbg_idel_up_all              => dbg_idel_up_all,
      dbg_idel_down_all            => dbg_idel_down_all,
      dbg_idel_up_dq               => dbg_idel_up_dq,
      dbg_idel_down_dq             => dbg_idel_down_dq,
      dbg_sel_idel_dq              => dbg_sel_idel_dq,
      dbg_sel_all_idel_dq          => dbg_sel_all_idel_dq,
      dbg_calib_dq_tap_cnt         => dbg_calib_dq_tap_cnt,
      dbg_data_tap_inc_done        => dbg_data_tap_inc_done,
      dbg_sel_done                 => dbg_sel_done,
      dbg_first_rising             => dbg_first_rising,
      dbg_cal_first_loop           => dbg_cal_first_loop,
      dbg_comp_done                => dbg_comp_done,
      dbg_comp_error               => dbg_comp_error,
      dbg_init_done                => dbg_init_done
   );


  infrastructure0 : mig_infrastructure
    port map (
      idelay_ctrl_rdy                => idelay_ctrl_rdy,
      sys_rst                        => sys_rst,
      sys_rst90                      => sys_rst90,
      sys_rst_r1                     => sys_rst_r1,
      sys_reset_in_n        => sys_reset_in_n,
      clk_0                 => clk_0,
      clk_90                => clk_90,
      clk_200               => clk_200,
      dcm_lock              => dcm_lock
      );

  --***************************************************************************
  -- IDELAYCTRL instantiation
  --***************************************************************************

  idelay_ctrl0 : mig_idelay_ctrl
    port map (
            clk200 => clk_200,
      reset      => sys_rst_r1,
      rdy_status => idelay_ctrl_rdy
      );

  --*************************************************************************
  -- Hooks to prevent sim/syn compilation errors. When DEBUG_EN = 0, all the
  -- debug input signals are floating. To avoid this, they are connected to
  -- all zeros.
  --*************************************************************************
  dbg_idel_up_all       <= '0';
  dbg_idel_down_all     <= '0';
  dbg_idel_up_dq        <= '0';
  dbg_idel_down_dq      <= '0';
  dbg_sel_idel_dq       <= (others => '0');
  dbg_sel_all_idel_dq   <= '0';


end arc_mem_interface_top;
