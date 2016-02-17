--------------------------------------------------------------------------------
-- Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: K.39
--  \   \         Application: netgen
--  /   /         Filename: histogram_mcw_sim.vhd
-- /___/   /\     Timestamp: Mon Feb 13 09:30:49 2012
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -ofmt vhdl -intstyle xflow -w .\ngc_netlist\histogram_mcw.ngc histogram_mcw_sim.vhd 
-- Device	: 4vfx100ff1517-10
-- Input file	: ./ngc_netlist/histogram_mcw.ngc
-- Output file	: histogram_mcw_sim.vhd
-- # of Entities	: 1
-- Design Name	: histogram_mcw
-- Xilinx	: C:\Xilinx\10.1\ISE
--             
-- Purpose:    
--     This VHDL netlist is a verification model and uses simulation 
--     primitives which may not represent the true implementation of the 
--     device, however the netlist is functionally correct and should not 
--     be modified. This file cannot be synthesized and should only be used 
--     with supported simulation tools.
--             
-- Reference:  
--     Development System Reference Guide, Chapter 23
--     Synthesis and Simulation Design Guide, Chapter 6
--             
--------------------------------------------------------------------------------


-- synthesis translate_off
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity histogram_mcw is
  port (
    rx_mosi_sof : in STD_LOGIC := 'X'; 
    rx_mosi_eof : in STD_LOGIC := 'X'; 
    tmi_miso_rd_dval : out STD_LOGIC; 
    tmi_miso_error : out STD_LOGIC; 
    tmi_miso_busy : out STD_LOGIC; 
    tmi_miso_idle : out STD_LOGIC; 
    rx_miso_busy : in STD_LOGIC := 'X'; 
    clk_1 : in STD_LOGIC := 'X'; 
    clear_mem : in STD_LOGIC := 'X'; 
    areset : in STD_LOGIC := 'X'; 
    tmi_mosi_rnw : in STD_LOGIC := 'X'; 
    tmi_mosi_dval : in STD_LOGIC := 'X'; 
    histogram_rdy : out STD_LOGIC; 
    rx_mosi_dval : in STD_LOGIC := 'X'; 
    ext_data_out2 : out STD_LOGIC_VECTOR ( 31 downto 0 ); 
    ext_data_out : out STD_LOGIC_VECTOR ( 31 downto 0 ); 
    timestamp : out STD_LOGIC_VECTOR ( 31 downto 0 ); 
    tmi_miso_rd_data : out STD_LOGIC_VECTOR ( 20 downto 0 ); 
    ext_data_in : in STD_LOGIC_VECTOR ( 31 downto 0 ); 
    ext_data_in2 : in STD_LOGIC_VECTOR ( 31 downto 0 ); 
    tmi_mosi_add : in STD_LOGIC_VECTOR ( 9 downto 0 ); 
    rx_mosi_data : in STD_LOGIC_VECTOR ( 15 downto 0 ) 
  );
end histogram_mcw;

architecture STRUCTURE of histogram_mcw is
  signal N0 : STD_LOGIC; 
  signal N1 : STD_LOGIC; 
  signal N2 : STD_LOGIC; 
  signal N4 : STD_LOGIC; 
  signal NlwRenamedSig_OI_histogram_rdy : STD_LOGIC; 
  signal histogram_x0_and_y_net_x0 : STD_LOGIC; 
  signal histogram_x0_d11_q_net_x0 : STD_LOGIC; 
  signal histogram_x0_d12_q_net_x0 : STD_LOGIC; 
  signal histogram_x0_d13_q_net : STD_LOGIC; 
  signal histogram_x0_d5_q_net : STD_LOGIC; 
  signal histogram_x0_d6_q_net : STD_LOGIC; 
  signal histogram_x0_d7_q_net_x0 : STD_LOGIC; 
  signal histogram_x0_d8_q_net_x0 : STD_LOGIC; 
  signal histogram_x0_d9_q_net_x0 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_d1_q_net : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_d2_q_net : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_logical1_fully_2_1_bit1 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_logical11_y_net : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_logical6_fully_2_1_bit11 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit12_793 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit7_794 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_logical_y_net : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_1_rt_798 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_10_rt_800 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_11_rt_802 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_12_rt_804 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_13_rt_806 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_14_rt_808 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_15_rt_810 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_16_rt_812 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_17_rt_814 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_18_rt_816 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_19_rt_818 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_2_rt_820 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_20_rt_822 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_21_rt_824 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_22_rt_826 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_23_rt_828 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_24_rt_830 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_25_rt_832 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_26_rt_834 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_27_rt_836 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_28_rt_838 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_29_rt_840 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_3_rt_842 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_30_rt_844 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_4_rt_846 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_5_rt_848 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_6_rt_850 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_7_rt_852 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_8_rt_854 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_9_rt_856 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_31_rt_858 : STD_LOGIC; 
  signal histogram_x0_logical8_y_net_x0 : STD_LOGIC; 
  signal histogram_x0_logical9_y_net_x0 : STD_LOGIC; 
  signal histogram_x0_relational_op_mem_32_22_0_954 : STD_LOGIC; 
  signal histogram_x0_tmi_18c9eaa64d_and1_y_net : STD_LOGIC; 
  signal histogram_x0_tmi_18c9eaa64d_and5_y_net : STD_LOGIC; 
  signal histogram_x0_tmi_18c9eaa64d_d1_q_net : STD_LOGIC; 
  signal histogram_x0_tmi_18c9eaa64d_d5_q_net : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carryxortop_rt_40 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carrymux_rt_38 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carrymux_rt_35 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carrymux_rt_32 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carrymux_rt_29 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carrymux_rt_26 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carrymux_rt_23 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carrymux_rt_20 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carrymux_rt_16 : STD_LOGIC;
 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0 : STD_LOGIC; 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_thresh0 : STD_LOGIC; 
  signal histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr : STD_LOGIC; 
  signal histogram_x0_addsub_comp0_core_instance0_BU2_c_out : STD_LOGIC; 
  signal NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2_Q_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2_Q_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2_Q_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2_Q_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2_Q_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2_Q_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_GND_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_VCC_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_GND_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_VCC_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_31_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_30_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_29_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_28_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_27_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_26_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_25_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_24_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_23_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_22_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_21_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_20_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_19_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_18_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_17_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_16_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_31_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_30_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_29_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_28_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_27_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_26_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_25_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_24_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_23_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_22_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_21_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_20_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_19_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_18_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_17_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_16_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_3_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_2_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_3_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_2_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTA_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTB_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_31_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_30_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_29_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_28_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_27_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_26_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_25_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_24_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_23_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_22_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_21_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_20_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_19_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_18_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_17_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_16_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_15_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_14_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_13_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_12_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_11_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_10_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_9_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_7_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_6_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_5_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_4_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_3_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_2_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_31_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_30_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_29_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_28_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_27_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_26_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_25_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_24_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_23_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_22_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_21_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_20_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_19_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_18_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_17_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_16_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_15_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_14_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_13_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_12_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_11_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_10_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_9_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_7_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_6_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_5_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_4_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_3_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_2_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_3_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_2_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_1_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_0_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_3_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_2_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_1_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_0_UNCONNECTED : STD_LOGIC;
 
  signal NLW_histogram_x0_addsub_comp0_core_instance0_GND_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_histogram_x0_addsub_comp0_core_instance0_VCC_P_UNCONNECTED : STD_LOGIC; 
  signal histogram_x0_addsub_s_net : STD_LOGIC_VECTOR ( 20 downto 0 ); 
  signal histogram_x0_clrmem_cntr_op_net_x0 : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_d10_q_net : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_d14_q_net_x0 : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal histogram_x0_d15_q_net_x0 : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal histogram_x0_d1_q_net : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_d2_q_net : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_d3_q_net : STD_LOGIC_VECTOR ( 20 downto 0 ); 
  signal histogram_x0_d4_q_net : STD_LOGIC_VECTOR ( 15 downto 6 ); 
  signal histogram_x0_histogramstate_b889c8d767_Result : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal histogram_x0_histogramstate_b889c8d767_logical1_latency_pipe_5_26 : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy : STD_LOGIC_VECTOR ( 30 downto 0 ); 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_lut : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23 : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal histogram_x0_mux1_y_net : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_mux2_y_net : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_mux3_y_net : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_mux_y_net : STD_LOGIC_VECTOR ( 20 downto 0 ); 
  signal histogram_x0_relational_Mcompar_result_12_3_rel_0_cy : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal histogram_x0_relational_Mcompar_result_12_3_rel_0_lut : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal NlwRenamedSig_OI_tmi_miso_rd_data : STD_LOGIC_VECTOR ( 20 downto 0 ); 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s : STD_LOGIC_VECTOR ( 9 downto 0 ); 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal histogram_x0_dual_port_ram_comp0_core_instance0_douta : STD_LOGIC_VECTOR ( 20 downto 0 ); 
  signal histogram_x0_addsub_comp0_core_instance0_s : STD_LOGIC_VECTOR ( 21 downto 21 ); 
  signal histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum : STD_LOGIC_VECTOR ( 21 downto 0 ); 
  signal histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple : STD_LOGIC_VECTOR ( 20 downto 0 ); 
begin
  histogram_rdy <= NlwRenamedSig_OI_histogram_rdy;
  tmi_miso_rd_data(20) <= NlwRenamedSig_OI_tmi_miso_rd_data(20);
  tmi_miso_rd_data(19) <= NlwRenamedSig_OI_tmi_miso_rd_data(19);
  tmi_miso_rd_data(18) <= NlwRenamedSig_OI_tmi_miso_rd_data(18);
  tmi_miso_rd_data(17) <= NlwRenamedSig_OI_tmi_miso_rd_data(17);
  tmi_miso_rd_data(16) <= NlwRenamedSig_OI_tmi_miso_rd_data(16);
  tmi_miso_rd_data(15) <= NlwRenamedSig_OI_tmi_miso_rd_data(15);
  tmi_miso_rd_data(14) <= NlwRenamedSig_OI_tmi_miso_rd_data(14);
  tmi_miso_rd_data(13) <= NlwRenamedSig_OI_tmi_miso_rd_data(13);
  tmi_miso_rd_data(12) <= NlwRenamedSig_OI_tmi_miso_rd_data(12);
  tmi_miso_rd_data(11) <= NlwRenamedSig_OI_tmi_miso_rd_data(11);
  tmi_miso_rd_data(10) <= NlwRenamedSig_OI_tmi_miso_rd_data(10);
  tmi_miso_rd_data(9) <= NlwRenamedSig_OI_tmi_miso_rd_data(9);
  tmi_miso_rd_data(8) <= NlwRenamedSig_OI_tmi_miso_rd_data(8);
  tmi_miso_rd_data(7) <= NlwRenamedSig_OI_tmi_miso_rd_data(7);
  tmi_miso_rd_data(6) <= NlwRenamedSig_OI_tmi_miso_rd_data(6);
  tmi_miso_rd_data(5) <= NlwRenamedSig_OI_tmi_miso_rd_data(5);
  tmi_miso_rd_data(4) <= NlwRenamedSig_OI_tmi_miso_rd_data(4);
  tmi_miso_rd_data(3) <= NlwRenamedSig_OI_tmi_miso_rd_data(3);
  tmi_miso_rd_data(2) <= NlwRenamedSig_OI_tmi_miso_rd_data(2);
  tmi_miso_rd_data(1) <= NlwRenamedSig_OI_tmi_miso_rd_data(1);
  tmi_miso_rd_data(0) <= NlwRenamedSig_OI_tmi_miso_rd_data(0);
  XST_GND : GND
    port map (
      G => N0
    );
  XST_VCC : VCC
    port map (
      P => N1
    );
  histogram_x0_histogramstate_b889c8d767_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_histogramstate_b889c8d767_logical_y_net,
      Q => histogram_x0_histogramstate_b889c8d767_d2_q_net
    );
  histogram_x0_histogramstate_b889c8d767_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_and_y_net_x0,
      Q => histogram_x0_histogramstate_b889c8d767_d1_q_net
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_0 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(0),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(0)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_1 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(1),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(1)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_2 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(2),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(2)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_3 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(3),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(3)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_4 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(4),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(4)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_5 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(5),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(5)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_6 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(6),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(6)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_7 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(7),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(7)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_8 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(8),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(8)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_9 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(9),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(9)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_10 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(10),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(10)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_11 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(11),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(11)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_12 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(12),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(12)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_13 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(13),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(13)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_14 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(14),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(14)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_15 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(15),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(15)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_16 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(16),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(16)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_17 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(17),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(17)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_18 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(18),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(18)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_19 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(19),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(19)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_20 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(20),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(20)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_21 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(21),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(21)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_22 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(22),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(22)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_23 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(23),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(23)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_24 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(24),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(24)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_25 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(25),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(25)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_26 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(26),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(26)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_27 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(27),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(27)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_28 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(28),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(28)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_29 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(29),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(29)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_30 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(30),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(30)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23_31 : FD
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_Result(31),
      Q => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(31)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_0_Q : MUXCY
    port map (
      CI => N0,
      DI => N1,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_lut(0),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(0)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_0_Q : XORCY
    port map (
      CI => N0,
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_lut(0),
      O => histogram_x0_histogramstate_b889c8d767_Result(0)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_1_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(0),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_1_rt_798,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(1)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_1_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(0),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_1_rt_798,
      O => histogram_x0_histogramstate_b889c8d767_Result(1)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_2_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(1),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_2_rt_820,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(2)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_2_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(1),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_2_rt_820,
      O => histogram_x0_histogramstate_b889c8d767_Result(2)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_3_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(2),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_3_rt_842,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(3)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_3_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(2),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_3_rt_842,
      O => histogram_x0_histogramstate_b889c8d767_Result(3)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_4_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(3),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_4_rt_846,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(4)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_4_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(3),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_4_rt_846,
      O => histogram_x0_histogramstate_b889c8d767_Result(4)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_5_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(4),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_5_rt_848,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(5)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_5_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(4),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_5_rt_848,
      O => histogram_x0_histogramstate_b889c8d767_Result(5)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_6_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(5),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_6_rt_850,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(6)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_6_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(5),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_6_rt_850,
      O => histogram_x0_histogramstate_b889c8d767_Result(6)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_7_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(6),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_7_rt_852,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(7)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_7_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(6),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_7_rt_852,
      O => histogram_x0_histogramstate_b889c8d767_Result(7)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_8_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(7),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_8_rt_854,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(8)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_8_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(7),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_8_rt_854,
      O => histogram_x0_histogramstate_b889c8d767_Result(8)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_9_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(8),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_9_rt_856,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(9)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_9_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(8),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_9_rt_856,
      O => histogram_x0_histogramstate_b889c8d767_Result(9)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_10_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(9),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_10_rt_800,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(10)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_10_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(9),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_10_rt_800,
      O => histogram_x0_histogramstate_b889c8d767_Result(10)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_11_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(10),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_11_rt_802,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(11)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_11_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(10),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_11_rt_802,
      O => histogram_x0_histogramstate_b889c8d767_Result(11)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_12_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(11),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_12_rt_804,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(12)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_12_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(11),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_12_rt_804,
      O => histogram_x0_histogramstate_b889c8d767_Result(12)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_13_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(12),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_13_rt_806,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(13)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_13_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(12),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_13_rt_806,
      O => histogram_x0_histogramstate_b889c8d767_Result(13)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_14_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(13),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_14_rt_808,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(14)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_14_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(13),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_14_rt_808,
      O => histogram_x0_histogramstate_b889c8d767_Result(14)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_15_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(14),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_15_rt_810,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(15)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_15_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(14),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_15_rt_810,
      O => histogram_x0_histogramstate_b889c8d767_Result(15)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_16_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(15),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_16_rt_812,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(16)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_16_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(15),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_16_rt_812,
      O => histogram_x0_histogramstate_b889c8d767_Result(16)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_17_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(16),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_17_rt_814,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(17)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_17_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(16),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_17_rt_814,
      O => histogram_x0_histogramstate_b889c8d767_Result(17)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_18_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(17),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_18_rt_816,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(18)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_18_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(17),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_18_rt_816,
      O => histogram_x0_histogramstate_b889c8d767_Result(18)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_19_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(18),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_19_rt_818,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(19)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_19_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(18),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_19_rt_818,
      O => histogram_x0_histogramstate_b889c8d767_Result(19)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_20_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(19),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_20_rt_822,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(20)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_20_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(19),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_20_rt_822,
      O => histogram_x0_histogramstate_b889c8d767_Result(20)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_21_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(20),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_21_rt_824,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(21)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_21_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(20),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_21_rt_824,
      O => histogram_x0_histogramstate_b889c8d767_Result(21)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_22_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(21),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_22_rt_826,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(22)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_22_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(21),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_22_rt_826,
      O => histogram_x0_histogramstate_b889c8d767_Result(22)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_23_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(22),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_23_rt_828,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(23)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_23_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(22),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_23_rt_828,
      O => histogram_x0_histogramstate_b889c8d767_Result(23)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_24_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(23),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_24_rt_830,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(24)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_24_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(23),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_24_rt_830,
      O => histogram_x0_histogramstate_b889c8d767_Result(24)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_25_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(24),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_25_rt_832,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(25)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_25_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(24),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_25_rt_832,
      O => histogram_x0_histogramstate_b889c8d767_Result(25)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_26_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(25),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_26_rt_834,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(26)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_26_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(25),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_26_rt_834,
      O => histogram_x0_histogramstate_b889c8d767_Result(26)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_27_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(26),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_27_rt_836,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(27)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_27_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(26),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_27_rt_836,
      O => histogram_x0_histogramstate_b889c8d767_Result(27)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_28_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(27),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_28_rt_838,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(28)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_28_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(27),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_28_rt_838,
      O => histogram_x0_histogramstate_b889c8d767_Result(28)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_29_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(28),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_29_rt_840,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(29)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_29_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(28),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_29_rt_840,
      O => histogram_x0_histogramstate_b889c8d767_Result(29)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_30_Q : MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(29),
      DI => N0,
      S => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_30_rt_844,
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(30)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_30_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(29),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_30_rt_844,
      O => histogram_x0_histogramstate_b889c8d767_Result(30)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_31_Q : XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy(30),
      LI => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_31_rt_858,
      O => histogram_x0_histogramstate_b889c8d767_Result(31)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_31_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(31),
      Q => timestamp(31)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_30_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(30),
      Q => timestamp(30)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_29_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(29),
      Q => timestamp(29)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_28_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(28),
      Q => timestamp(28)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_27_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(27),
      Q => timestamp(27)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_26_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(26),
      Q => timestamp(26)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_25_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(25),
      Q => timestamp(25)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_24_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(24),
      Q => timestamp(24)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_23_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(23),
      Q => timestamp(23)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_22_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(22),
      Q => timestamp(22)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_21_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(21),
      Q => timestamp(21)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_20_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(20),
      Q => timestamp(20)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_19_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(19),
      Q => timestamp(19)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_18_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(18),
      Q => timestamp(18)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_17_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(17),
      Q => timestamp(17)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_16_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(16),
      Q => timestamp(16)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_15_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(15),
      Q => timestamp(15)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_14_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(14),
      Q => timestamp(14)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_13_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(13),
      Q => timestamp(13)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_12_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(12),
      Q => timestamp(12)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_11_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(11),
      Q => timestamp(11)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_10_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(10),
      Q => timestamp(10)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(9),
      Q => timestamp(9)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(8),
      Q => timestamp(8)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(7),
      Q => timestamp(7)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(6),
      Q => timestamp(6)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(5),
      Q => timestamp(5)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(4),
      Q => timestamp(4)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(3),
      Q => timestamp(3)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(2),
      Q => timestamp(2)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(1),
      Q => timestamp(1)
    );
  histogram_x0_histogramstate_b889c8d767_reg1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(0),
      Q => timestamp(0)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_31_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(31),
      Q => ext_data_out(31)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_30_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(30),
      Q => ext_data_out(30)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_29_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(29),
      Q => ext_data_out(29)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_28_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(28),
      Q => ext_data_out(28)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_27_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(27),
      Q => ext_data_out(27)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_26_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(26),
      Q => ext_data_out(26)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_25_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(25),
      Q => ext_data_out(25)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_24_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(24),
      Q => ext_data_out(24)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_23_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(23),
      Q => ext_data_out(23)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_22_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(22),
      Q => ext_data_out(22)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_21_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(21),
      Q => ext_data_out(21)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_20_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(20),
      Q => ext_data_out(20)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_19_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(19),
      Q => ext_data_out(19)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_18_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(18),
      Q => ext_data_out(18)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_17_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(17),
      Q => ext_data_out(17)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_16_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(16),
      Q => ext_data_out(16)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_15_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(15),
      Q => ext_data_out(15)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_14_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(14),
      Q => ext_data_out(14)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_13_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(13),
      Q => ext_data_out(13)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_12_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(12),
      Q => ext_data_out(12)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_11_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(11),
      Q => ext_data_out(11)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_10_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(10),
      Q => ext_data_out(10)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(9),
      Q => ext_data_out(9)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(8),
      Q => ext_data_out(8)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(7),
      Q => ext_data_out(7)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(6),
      Q => ext_data_out(6)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(5),
      Q => ext_data_out(5)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(4),
      Q => ext_data_out(4)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(3),
      Q => ext_data_out(3)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(2),
      Q => ext_data_out(2)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(1),
      Q => ext_data_out(1)
    );
  histogram_x0_histogramstate_b889c8d767_reg2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d14_q_net_x0(0),
      Q => ext_data_out(0)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_31_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(31),
      Q => ext_data_out2(31)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_30_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(30),
      Q => ext_data_out2(30)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_29_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(29),
      Q => ext_data_out2(29)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_28_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(28),
      Q => ext_data_out2(28)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_27_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(27),
      Q => ext_data_out2(27)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_26_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(26),
      Q => ext_data_out2(26)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_25_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(25),
      Q => ext_data_out2(25)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_24_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(24),
      Q => ext_data_out2(24)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_23_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(23),
      Q => ext_data_out2(23)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_22_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(22),
      Q => ext_data_out2(22)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_21_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(21),
      Q => ext_data_out2(21)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_20_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(20),
      Q => ext_data_out2(20)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_19_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(19),
      Q => ext_data_out2(19)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_18_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(18),
      Q => ext_data_out2(18)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_17_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(17),
      Q => ext_data_out2(17)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_16_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(16),
      Q => ext_data_out2(16)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_15_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(15),
      Q => ext_data_out2(15)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_14_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(14),
      Q => ext_data_out2(14)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_13_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(13),
      Q => ext_data_out2(13)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_12_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(12),
      Q => ext_data_out2(12)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_11_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(11),
      Q => ext_data_out2(11)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_10_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(10),
      Q => ext_data_out2(10)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(9),
      Q => ext_data_out2(9)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(8),
      Q => ext_data_out2(8)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(7),
      Q => ext_data_out2(7)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(6),
      Q => ext_data_out2(6)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(5),
      Q => ext_data_out2(5)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(4),
      Q => ext_data_out2(4)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(3),
      Q => ext_data_out2(3)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(2),
      Q => ext_data_out2(2)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(1),
      Q => ext_data_out2(1)
    );
  histogram_x0_histogramstate_b889c8d767_reg3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => histogram_x0_histogramstate_b889c8d767_logical11_y_net,
      D => histogram_x0_d15_q_net_x0(0),
      Q => ext_data_out2(0)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(0),
      Q => histogram_x0_d3_q_net(0)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(1),
      Q => histogram_x0_d3_q_net(1)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(2),
      Q => histogram_x0_d3_q_net(2)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(3),
      Q => histogram_x0_d3_q_net(3)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(4),
      Q => histogram_x0_d3_q_net(4)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(5),
      Q => histogram_x0_d3_q_net(5)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(6),
      Q => histogram_x0_d3_q_net(6)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(7),
      Q => histogram_x0_d3_q_net(7)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(8),
      Q => histogram_x0_d3_q_net(8)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(9),
      Q => histogram_x0_d3_q_net(9)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_10_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(10),
      Q => histogram_x0_d3_q_net(10)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_11_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(11),
      Q => histogram_x0_d3_q_net(11)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_12_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(12),
      Q => histogram_x0_d3_q_net(12)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_13_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(13),
      Q => histogram_x0_d3_q_net(13)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_14_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(14),
      Q => histogram_x0_d3_q_net(14)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_15_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(15),
      Q => histogram_x0_d3_q_net(15)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_16_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(16),
      Q => histogram_x0_d3_q_net(16)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_17_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(17),
      Q => histogram_x0_d3_q_net(17)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_18_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(18),
      Q => histogram_x0_d3_q_net(18)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_19_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(19),
      Q => histogram_x0_d3_q_net(19)
    );
  histogram_x0_d3_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_20_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_addsub_s_net(20),
      Q => histogram_x0_d3_q_net(20)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(0),
      Q => histogram_x0_d15_q_net_x0(0)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(1),
      Q => histogram_x0_d15_q_net_x0(1)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(2),
      Q => histogram_x0_d15_q_net_x0(2)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(3),
      Q => histogram_x0_d15_q_net_x0(3)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(4),
      Q => histogram_x0_d15_q_net_x0(4)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(5),
      Q => histogram_x0_d15_q_net_x0(5)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(6),
      Q => histogram_x0_d15_q_net_x0(6)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(7),
      Q => histogram_x0_d15_q_net_x0(7)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(8),
      Q => histogram_x0_d15_q_net_x0(8)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(9),
      Q => histogram_x0_d15_q_net_x0(9)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_10_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(10),
      Q => histogram_x0_d15_q_net_x0(10)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_11_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(11),
      Q => histogram_x0_d15_q_net_x0(11)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_12_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(12),
      Q => histogram_x0_d15_q_net_x0(12)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_13_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(13),
      Q => histogram_x0_d15_q_net_x0(13)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_14_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(14),
      Q => histogram_x0_d15_q_net_x0(14)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_15_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(15),
      Q => histogram_x0_d15_q_net_x0(15)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_16_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(16),
      Q => histogram_x0_d15_q_net_x0(16)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_17_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(17),
      Q => histogram_x0_d15_q_net_x0(17)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_18_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(18),
      Q => histogram_x0_d15_q_net_x0(18)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_19_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(19),
      Q => histogram_x0_d15_q_net_x0(19)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_20_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(20),
      Q => histogram_x0_d15_q_net_x0(20)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_21_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(21),
      Q => histogram_x0_d15_q_net_x0(21)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_22_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(22),
      Q => histogram_x0_d15_q_net_x0(22)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_23_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(23),
      Q => histogram_x0_d15_q_net_x0(23)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_24_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(24),
      Q => histogram_x0_d15_q_net_x0(24)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_25_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(25),
      Q => histogram_x0_d15_q_net_x0(25)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_26_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(26),
      Q => histogram_x0_d15_q_net_x0(26)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_27_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(27),
      Q => histogram_x0_d15_q_net_x0(27)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_28_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(28),
      Q => histogram_x0_d15_q_net_x0(28)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_29_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(29),
      Q => histogram_x0_d15_q_net_x0(29)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_30_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(30),
      Q => histogram_x0_d15_q_net_x0(30)
    );
  histogram_x0_d15_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_31_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in2(31),
      Q => histogram_x0_d15_q_net_x0(31)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(0),
      Q => histogram_x0_d14_q_net_x0(0)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(1),
      Q => histogram_x0_d14_q_net_x0(1)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(2),
      Q => histogram_x0_d14_q_net_x0(2)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(3),
      Q => histogram_x0_d14_q_net_x0(3)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(4),
      Q => histogram_x0_d14_q_net_x0(4)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(5),
      Q => histogram_x0_d14_q_net_x0(5)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(6),
      Q => histogram_x0_d14_q_net_x0(6)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(7),
      Q => histogram_x0_d14_q_net_x0(7)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(8),
      Q => histogram_x0_d14_q_net_x0(8)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(9),
      Q => histogram_x0_d14_q_net_x0(9)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_10_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(10),
      Q => histogram_x0_d14_q_net_x0(10)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_11_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(11),
      Q => histogram_x0_d14_q_net_x0(11)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_12_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(12),
      Q => histogram_x0_d14_q_net_x0(12)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_13_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(13),
      Q => histogram_x0_d14_q_net_x0(13)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_14_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(14),
      Q => histogram_x0_d14_q_net_x0(14)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_15_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(15),
      Q => histogram_x0_d14_q_net_x0(15)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_16_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(16),
      Q => histogram_x0_d14_q_net_x0(16)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_17_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(17),
      Q => histogram_x0_d14_q_net_x0(17)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_18_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(18),
      Q => histogram_x0_d14_q_net_x0(18)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_19_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(19),
      Q => histogram_x0_d14_q_net_x0(19)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_20_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(20),
      Q => histogram_x0_d14_q_net_x0(20)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_21_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(21),
      Q => histogram_x0_d14_q_net_x0(21)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_22_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(22),
      Q => histogram_x0_d14_q_net_x0(22)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_23_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(23),
      Q => histogram_x0_d14_q_net_x0(23)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_24_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(24),
      Q => histogram_x0_d14_q_net_x0(24)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_25_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(25),
      Q => histogram_x0_d14_q_net_x0(25)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_26_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(26),
      Q => histogram_x0_d14_q_net_x0(26)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_27_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(27),
      Q => histogram_x0_d14_q_net_x0(27)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_28_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(28),
      Q => histogram_x0_d14_q_net_x0(28)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_29_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(29),
      Q => histogram_x0_d14_q_net_x0(29)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_30_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(30),
      Q => histogram_x0_d14_q_net_x0(30)
    );
  histogram_x0_d14_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_31_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => ext_data_in(31),
      Q => histogram_x0_d14_q_net_x0(31)
    );
  histogram_x0_tmi_18c9eaa64d_d5_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_tmi_18c9eaa64d_and1_y_net,
      Q => histogram_x0_tmi_18c9eaa64d_d5_q_net
    );
  histogram_x0_tmi_18c9eaa64d_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_tmi_18c9eaa64d_and5_y_net,
      Q => histogram_x0_tmi_18c9eaa64d_d1_q_net
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_cy_4_Q : MUXCY
    port map (
      CI => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(3),
      DI => N0,
      S => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(4),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(4)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_lut_4_Q : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => histogram_x0_d1_q_net(8),
      I1 => histogram_x0_mux2_y_net(8),
      I2 => histogram_x0_d1_q_net(9),
      I3 => histogram_x0_mux2_y_net(9),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(4)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_cy_3_Q : MUXCY
    port map (
      CI => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(2),
      DI => N0,
      S => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(3),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(3)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_lut_3_Q : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => histogram_x0_d1_q_net(6),
      I1 => histogram_x0_mux2_y_net(6),
      I2 => histogram_x0_d1_q_net(7),
      I3 => histogram_x0_mux2_y_net(7),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(3)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_cy_2_Q : MUXCY
    port map (
      CI => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(1),
      DI => N0,
      S => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(2),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(2)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_lut_2_Q : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => histogram_x0_d1_q_net(4),
      I1 => histogram_x0_mux2_y_net(4),
      I2 => histogram_x0_d1_q_net(5),
      I3 => histogram_x0_mux2_y_net(5),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(2)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_cy_1_Q : MUXCY
    port map (
      CI => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(0),
      DI => N0,
      S => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(1),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(1)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_lut_1_Q : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => histogram_x0_d1_q_net(2),
      I1 => histogram_x0_mux2_y_net(2),
      I2 => histogram_x0_d1_q_net(3),
      I3 => histogram_x0_mux2_y_net(3),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(1)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_cy_0_Q : MUXCY
    port map (
      CI => N1,
      DI => N0,
      S => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(0),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(0)
    );
  histogram_x0_relational_Mcompar_result_12_3_rel_0_lut_0_Q : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => histogram_x0_d1_q_net(0),
      I1 => histogram_x0_mux2_y_net(0),
      I2 => histogram_x0_d1_q_net(1),
      I3 => histogram_x0_mux2_y_net(1),
      O => histogram_x0_relational_Mcompar_result_12_3_rel_0_lut(0)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(0),
      Q => NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2_Q_UNCONNECTED
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(1),
      Q => NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2_Q_UNCONNECTED
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(2),
      Q => NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2_Q_UNCONNECTED
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(3),
      Q => NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2_Q_UNCONNECTED
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(4),
      Q => NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2_Q_UNCONNECTED
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(5),
      Q => NLW_histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2_Q_UNCONNECTED
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(6),
      Q => histogram_x0_d4_q_net(6)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(7),
      Q => histogram_x0_d4_q_net(7)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(8),
      Q => histogram_x0_d4_q_net(8)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(9),
      Q => histogram_x0_d4_q_net(9)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_10_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(10),
      Q => histogram_x0_d4_q_net(10)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_11_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(11),
      Q => histogram_x0_d4_q_net(11)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_12_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(12),
      Q => histogram_x0_d4_q_net(12)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_13_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(13),
      Q => histogram_x0_d4_q_net(13)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_14_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(14),
      Q => histogram_x0_d4_q_net(14)
    );
  histogram_x0_d4_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_15_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_data(15),
      Q => histogram_x0_d4_q_net(15)
    );
  histogram_x0_d11_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_rnw,
      Q => histogram_x0_d11_q_net_x0
    );
  histogram_x0_d12_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_dval,
      Q => histogram_x0_d12_q_net_x0
    );
  histogram_x0_d13_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_logical8_y_net_x0,
      Q => histogram_x0_d13_q_net
    );
  histogram_x0_d5_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_dval,
      Q => histogram_x0_d5_q_net
    );
  histogram_x0_d6_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_miso_busy,
      Q => histogram_x0_d6_q_net
    );
  histogram_x0_d7_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_sof,
      Q => histogram_x0_d7_q_net_x0
    );
  histogram_x0_d8_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => rx_mosi_eof,
      Q => histogram_x0_d8_q_net_x0
    );
  histogram_x0_d9_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => clear_mem,
      Q => histogram_x0_d9_q_net_x0
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(0),
      Q => histogram_x0_d1_q_net(0)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(1),
      Q => histogram_x0_d1_q_net(1)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(2),
      Q => histogram_x0_d1_q_net(2)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(3),
      Q => histogram_x0_d1_q_net(3)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(4),
      Q => histogram_x0_d1_q_net(4)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(5),
      Q => histogram_x0_d1_q_net(5)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(6),
      Q => histogram_x0_d1_q_net(6)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(7),
      Q => histogram_x0_d1_q_net(7)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(8),
      Q => histogram_x0_d1_q_net(8)
    );
  histogram_x0_d1_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux2_y_net(9),
      Q => histogram_x0_d1_q_net(9)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(0),
      Q => histogram_x0_d10_q_net(0)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(1),
      Q => histogram_x0_d10_q_net(1)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(2),
      Q => histogram_x0_d10_q_net(2)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(3),
      Q => histogram_x0_d10_q_net(3)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(4),
      Q => histogram_x0_d10_q_net(4)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(5),
      Q => histogram_x0_d10_q_net(5)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(6),
      Q => histogram_x0_d10_q_net(6)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(7),
      Q => histogram_x0_d10_q_net(7)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(8),
      Q => histogram_x0_d10_q_net(8)
    );
  histogram_x0_d10_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => tmi_mosi_add(9),
      Q => histogram_x0_d10_q_net(9)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_0_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(0),
      Q => histogram_x0_d2_q_net(0)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_1_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(1),
      Q => histogram_x0_d2_q_net(1)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_2_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(2),
      Q => histogram_x0_d2_q_net(2)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_3_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(3),
      Q => histogram_x0_d2_q_net(3)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_4_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(4),
      Q => histogram_x0_d2_q_net(4)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_5_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(5),
      Q => histogram_x0_d2_q_net(5)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_6_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(6),
      Q => histogram_x0_d2_q_net(6)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_7_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(7),
      Q => histogram_x0_d2_q_net(7)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_8_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(8),
      Q => histogram_x0_d2_q_net(8)
    );
  histogram_x0_d2_srl_delay_synth_reg_srl_inst_partial_one_last_srl17e_reg_array_9_fde_used_u2 : FDE
    port map (
      C => clk_1,
      CE => N1,
      D => histogram_x0_mux1_y_net(9),
      Q => histogram_x0_d2_q_net(9)
    );
  histogram_x0_relational_op_mem_32_22_0 : FDE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical8_y_net_x0,
      D => histogram_x0_relational_Mcompar_result_12_3_rel_0_cy(4),
      Q => histogram_x0_relational_op_mem_32_22_0_954
    );
  histogram_x0_tmi_18c9eaa64d_mux2_unregy_join_6_11 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => areset,
      I1 => histogram_x0_tmi_18c9eaa64d_d1_q_net,
      O => tmi_miso_rd_dval
    );
  histogram_x0_tmi_18c9eaa64d_mux3_unregy_join_6_11 : LUT3
    generic map(
      INIT => X"04"
    )
    port map (
      I0 => histogram_x0_d11_q_net_x0,
      I1 => histogram_x0_d12_q_net_x0,
      I2 => areset,
      O => tmi_miso_error
    );
  histogram_x0_tmi_18c9eaa64d_and1_fully_2_1_bit1 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => histogram_x0_d12_q_net_x0,
      I1 => histogram_x0_d11_q_net_x0,
      O => histogram_x0_tmi_18c9eaa64d_and1_y_net
    );
  histogram_x0_histogramstate_b889c8d767_logical8_fully_2_1_bit1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_histogramstate_b889c8d767_d2_q_net,
      I2 => histogram_x0_histogramstate_b889c8d767_d1_q_net,
      O => histogram_x0_logical8_y_net_x0
    );
  histogram_x0_histogramstate_b889c8d767_logical11_fully_2_1_bit1 : LUT4
    generic map(
      INIT => X"0020"
    )
    port map (
      I0 => histogram_x0_d7_q_net_x0,
      I1 => NlwRenamedSig_OI_histogram_rdy,
      I2 => histogram_x0_and_y_net_x0,
      I3 => histogram_x0_histogramstate_b889c8d767_d2_q_net,
      O => histogram_x0_histogramstate_b889c8d767_logical11_y_net
    );
  histogram_x0_histogramstate_b889c8d767_logical_fully_2_1_bit : LUT4
    generic map(
      INIT => X"0405"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_histogramstate_b889c8d767_d2_q_net,
      I2 => histogram_x0_histogramstate_b889c8d767_logical1_latency_pipe_5_26(0),
      I3 => N2,
      O => histogram_x0_histogramstate_b889c8d767_logical_y_net
    );
  histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit7 : LUT3
    generic map(
      INIT => X"FE"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(1),
      I1 => histogram_x0_clrmem_cntr_op_net_x0(2),
      I2 => histogram_x0_d9_q_net_x0,
      O => histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit7_794
    );
  histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit12 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(6),
      I1 => histogram_x0_clrmem_cntr_op_net_x0(5),
      I2 => histogram_x0_clrmem_cntr_op_net_x0(4),
      I3 => histogram_x0_clrmem_cntr_op_net_x0(3),
      O => histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit12_793
    );
  histogram_x0_and_x0_fully_2_1_bit1 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      O => histogram_x0_and_y_net_x0
    );
  histogram_x0_mux3_unregy_join_6_1_9_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(9),
      I2 => histogram_x0_mux1_y_net(9),
      O => histogram_x0_mux3_y_net(9)
    );
  histogram_x0_mux3_unregy_join_6_1_8_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(8),
      I2 => histogram_x0_mux1_y_net(8),
      O => histogram_x0_mux3_y_net(8)
    );
  histogram_x0_mux3_unregy_join_6_1_7_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(7),
      I2 => histogram_x0_mux1_y_net(7),
      O => histogram_x0_mux3_y_net(7)
    );
  histogram_x0_mux3_unregy_join_6_1_6_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(6),
      I2 => histogram_x0_mux1_y_net(6),
      O => histogram_x0_mux3_y_net(6)
    );
  histogram_x0_mux3_unregy_join_6_1_5_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(5),
      I2 => histogram_x0_mux1_y_net(5),
      O => histogram_x0_mux3_y_net(5)
    );
  histogram_x0_mux3_unregy_join_6_1_4_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(4),
      I2 => histogram_x0_mux1_y_net(4),
      O => histogram_x0_mux3_y_net(4)
    );
  histogram_x0_mux3_unregy_join_6_1_3_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(3),
      I2 => histogram_x0_mux1_y_net(3),
      O => histogram_x0_mux3_y_net(3)
    );
  histogram_x0_mux3_unregy_join_6_1_2_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(2),
      I2 => histogram_x0_mux1_y_net(2),
      O => histogram_x0_mux3_y_net(2)
    );
  histogram_x0_mux3_unregy_join_6_1_1_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(1),
      I2 => histogram_x0_mux1_y_net(1),
      O => histogram_x0_mux3_y_net(1)
    );
  histogram_x0_mux3_unregy_join_6_1_0_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => histogram_x0_logical9_y_net_x0,
      I1 => histogram_x0_clrmem_cntr_op_net_x0(0),
      I2 => histogram_x0_mux1_y_net(0),
      O => histogram_x0_mux3_y_net(0)
    );
  histogram_x0_mux1_unregy_join_6_1_0_1 : LUT3
    generic map(
      INIT => X"D8"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_d10_q_net(0),
      I2 => histogram_x0_mux2_y_net(0),
      O => histogram_x0_mux1_y_net(0)
    );
  histogram_mcw_TIMESPEC_XST : TIMESPEC
;
  histogram_x0_histogramstate_b889c8d767_logical1_latency_pipe_5_26_0 : FDR
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_logical1_fully_2_1_bit1,
      R => NlwRenamedSig_OI_histogram_rdy,
      Q => histogram_x0_histogramstate_b889c8d767_logical1_latency_pipe_5_26(0)
    );
  histogram_x0_histogramstate_b889c8d767_mux_pipe_16_22_0 : FDRS
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      D => histogram_x0_histogramstate_b889c8d767_logical6_fully_2_1_bit11,
      R => histogram_x0_logical9_y_net_x0,
      S => NlwRenamedSig_OI_histogram_rdy,
      Q => NlwRenamedSig_OI_histogram_rdy
    );
  histogram_x0_histogramstate_b889c8d767_logical6_fully_2_1_bit111 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_d2_q_net,
      I1 => histogram_x0_histogramstate_b889c8d767_logical1_latency_pipe_5_26(0),
      O => histogram_x0_histogramstate_b889c8d767_logical6_fully_2_1_bit11
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(1),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_1_rt_798
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(2),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_2_rt_820
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(3),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_3_rt_842
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(4),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_4_rt_846
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(5),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_5_rt_848
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(6),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_6_rt_850
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(7),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_7_rt_852
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(8),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_8_rt_854
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_9_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(9),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_9_rt_856
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_10_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(10),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_10_rt_800
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_11_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(11),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_11_rt_802
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_12_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(12),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_12_rt_804
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_13_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(13),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_13_rt_806
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_14_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(14),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_14_rt_808
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_15_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(15),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_15_rt_810
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_16_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(16),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_16_rt_812
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_17_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(17),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_17_rt_814
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_18_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(18),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_18_rt_816
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_19_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(19),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_19_rt_818
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_20_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(20),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_20_rt_822
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_21_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(21),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_21_rt_824
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_22_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(22),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_22_rt_826
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_23_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(23),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_23_rt_828
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_24_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(24),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_24_rt_830
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_25_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(25),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_25_rt_832
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_26_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(26),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_26_rt_834
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_27_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(27),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_27_rt_836
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_28_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(28),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_28_rt_838
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_29_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(29),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_29_rt_840
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_30_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(30),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_cy_30_rt_844
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_31_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(31),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_xor_31_rt_858
    );
  histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit21_SW0 : LUT3
    generic map(
      INIT => X"FE"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(8),
      I1 => histogram_x0_clrmem_cntr_op_net_x0(7),
      I2 => histogram_x0_clrmem_cntr_op_net_x0(0),
      O => N4
    );
  histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit21 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit7_794,
      I1 => histogram_x0_histogramstate_b889c8d767_logical9_fully_2_1_bit12_793,
      I2 => histogram_x0_clrmem_cntr_op_net_x0(9),
      I3 => N4,
      O => histogram_x0_logical9_y_net_x0
    );
  histogram_x0_mux1_unregy_join_6_1_9_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(15),
      I3 => histogram_x0_d10_q_net(9),
      O => histogram_x0_mux1_y_net(9)
    );
  histogram_x0_mux1_unregy_join_6_1_8_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(14),
      I3 => histogram_x0_d10_q_net(8),
      O => histogram_x0_mux1_y_net(8)
    );
  histogram_x0_mux1_unregy_join_6_1_7_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(13),
      I3 => histogram_x0_d10_q_net(7),
      O => histogram_x0_mux1_y_net(7)
    );
  histogram_x0_mux1_unregy_join_6_1_6_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(12),
      I3 => histogram_x0_d10_q_net(6),
      O => histogram_x0_mux1_y_net(6)
    );
  histogram_x0_mux1_unregy_join_6_1_5_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(11),
      I3 => histogram_x0_d10_q_net(5),
      O => histogram_x0_mux1_y_net(5)
    );
  histogram_x0_mux1_unregy_join_6_1_4_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(10),
      I3 => histogram_x0_d10_q_net(4),
      O => histogram_x0_mux1_y_net(4)
    );
  histogram_x0_mux1_unregy_join_6_1_3_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(9),
      I3 => histogram_x0_d10_q_net(3),
      O => histogram_x0_mux1_y_net(3)
    );
  histogram_x0_mux1_unregy_join_6_1_2_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(8),
      I3 => histogram_x0_d10_q_net(2),
      O => histogram_x0_mux1_y_net(2)
    );
  histogram_x0_mux1_unregy_join_6_1_1_1 : LUT4
    generic map(
      INIT => X"EA40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_and_y_net_x0,
      I2 => histogram_x0_d4_q_net(7),
      I3 => histogram_x0_d10_q_net(1),
      O => histogram_x0_mux1_y_net(1)
    );
  histogram_x0_mux2_unregy_join_6_1_0_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(6),
      O => histogram_x0_mux2_y_net(0)
    );
  histogram_x0_histogramstate_b889c8d767_logical_fully_2_1_bit_SW0 : LUT3
    generic map(
      INIT => X"F7"
    )
    port map (
      I0 => histogram_x0_d5_q_net,
      I1 => histogram_x0_d7_q_net_x0,
      I2 => histogram_x0_d6_q_net,
      O => N2
    );
  histogram_x0_tmi_18c9eaa64d_and5_fully_2_1_bit1 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => histogram_x0_d12_q_net_x0,
      I1 => histogram_x0_d11_q_net_x0,
      I2 => NlwRenamedSig_OI_histogram_rdy,
      O => histogram_x0_tmi_18c9eaa64d_and5_y_net
    );
  histogram_x0_histogramstate_b889c8d767_logical1_fully_2_1_bit11 : LUT4
    generic map(
      INIT => X"0800"
    )
    port map (
      I0 => histogram_x0_d8_q_net_x0,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d6_q_net,
      I3 => histogram_x0_histogramstate_b889c8d767_d2_q_net,
      O => histogram_x0_histogramstate_b889c8d767_logical1_fully_2_1_bit1
    );
  histogram_x0_mux_unregy_join_6_1_0_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(0),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(0),
      O => histogram_x0_mux_y_net(0)
    );
  histogram_x0_mux_unregy_join_6_1_1_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(1),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(1),
      O => histogram_x0_mux_y_net(1)
    );
  histogram_x0_mux_unregy_join_6_1_2_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(2),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(2),
      O => histogram_x0_mux_y_net(2)
    );
  histogram_x0_mux_unregy_join_6_1_3_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(3),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(3),
      O => histogram_x0_mux_y_net(3)
    );
  histogram_x0_mux_unregy_join_6_1_4_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(4),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(4),
      O => histogram_x0_mux_y_net(4)
    );
  histogram_x0_mux_unregy_join_6_1_5_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(5),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(5),
      O => histogram_x0_mux_y_net(5)
    );
  histogram_x0_mux_unregy_join_6_1_6_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(6),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(6),
      O => histogram_x0_mux_y_net(6)
    );
  histogram_x0_mux_unregy_join_6_1_7_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(7),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(7),
      O => histogram_x0_mux_y_net(7)
    );
  histogram_x0_mux_unregy_join_6_1_8_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(8),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(8),
      O => histogram_x0_mux_y_net(8)
    );
  histogram_x0_mux_unregy_join_6_1_9_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(9),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(9),
      O => histogram_x0_mux_y_net(9)
    );
  histogram_x0_mux_unregy_join_6_1_10_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(10),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(10),
      O => histogram_x0_mux_y_net(10)
    );
  histogram_x0_mux_unregy_join_6_1_11_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(11),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(11),
      O => histogram_x0_mux_y_net(11)
    );
  histogram_x0_mux_unregy_join_6_1_12_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(12),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(12),
      O => histogram_x0_mux_y_net(12)
    );
  histogram_x0_mux_unregy_join_6_1_13_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(13),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(13),
      O => histogram_x0_mux_y_net(13)
    );
  histogram_x0_mux_unregy_join_6_1_14_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(14),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(14),
      O => histogram_x0_mux_y_net(14)
    );
  histogram_x0_mux_unregy_join_6_1_15_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(15),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(15),
      O => histogram_x0_mux_y_net(15)
    );
  histogram_x0_mux_unregy_join_6_1_16_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(16),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(16),
      O => histogram_x0_mux_y_net(16)
    );
  histogram_x0_mux_unregy_join_6_1_17_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(17),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(17),
      O => histogram_x0_mux_y_net(17)
    );
  histogram_x0_mux_unregy_join_6_1_18_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(18),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(18),
      O => histogram_x0_mux_y_net(18)
    );
  histogram_x0_mux_unregy_join_6_1_19_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(19),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(19),
      O => histogram_x0_mux_y_net(19)
    );
  histogram_x0_mux_unregy_join_6_1_20_1 : LUT4
    generic map(
      INIT => X"EC4C"
    )
    port map (
      I0 => histogram_x0_relational_op_mem_32_22_0_954,
      I1 => NlwRenamedSig_OI_tmi_miso_rd_data(20),
      I2 => histogram_x0_d13_q_net,
      I3 => histogram_x0_d3_q_net(20),
      O => histogram_x0_mux_y_net(20)
    );
  histogram_x0_tmi_18c9eaa64d_mux1_unregy_join_6_11 : LUT4
    generic map(
      INIT => X"0105"
    )
    port map (
      I0 => histogram_x0_tmi_18c9eaa64d_d5_q_net,
      I1 => histogram_x0_d11_q_net_x0,
      I2 => areset,
      I3 => histogram_x0_d12_q_net_x0,
      O => tmi_miso_idle
    );
  histogram_x0_tmi_18c9eaa64d_mux_unregy_join_6_11 : LUT4
    generic map(
      INIT => X"FF40"
    )
    port map (
      I0 => NlwRenamedSig_OI_histogram_rdy,
      I1 => histogram_x0_d12_q_net_x0,
      I2 => histogram_x0_d11_q_net_x0,
      I3 => areset,
      O => tmi_miso_busy
    );
  histogram_x0_mux2_unregy_join_6_1_1_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(7),
      O => histogram_x0_mux2_y_net(1)
    );
  histogram_x0_mux2_unregy_join_6_1_3_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(9),
      O => histogram_x0_mux2_y_net(3)
    );
  histogram_x0_mux2_unregy_join_6_1_2_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(8),
      O => histogram_x0_mux2_y_net(2)
    );
  histogram_x0_mux2_unregy_join_6_1_5_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(11),
      O => histogram_x0_mux2_y_net(5)
    );
  histogram_x0_mux2_unregy_join_6_1_4_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(10),
      O => histogram_x0_mux2_y_net(4)
    );
  histogram_x0_mux2_unregy_join_6_1_7_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(13),
      O => histogram_x0_mux2_y_net(7)
    );
  histogram_x0_mux2_unregy_join_6_1_6_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(12),
      O => histogram_x0_mux2_y_net(6)
    );
  histogram_x0_mux2_unregy_join_6_1_9_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(15),
      O => histogram_x0_mux2_y_net(9)
    );
  histogram_x0_mux2_unregy_join_6_1_8_1 : LUT3
    generic map(
      INIT => X"40"
    )
    port map (
      I0 => histogram_x0_d6_q_net,
      I1 => histogram_x0_d5_q_net,
      I2 => histogram_x0_d4_q_net(14),
      O => histogram_x0_mux2_y_net(8)
    );
  histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_lut_0_INV_0 : INV
    port map (
      I => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_count_reg_20_23(0),
      O => histogram_x0_histogramstate_b889c8d767_timestamp_cntr_Mcount_count_reg_20_23_lut(0)
    );
  histogram_mcw_TIMESPEC_NCF : TIMESPEC
;
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_GND : GND
    port map (
      G => NLW_histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_GND_G_UNCONNECTED
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_VCC : VCC
    port map (
      P => NLW_histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_VCC_P_UNCONNECTED
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum_not00001_INV_0 : 
INV
    port map (
      I => histogram_x0_clrmem_cntr_op_net_x0(0),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(0)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carryxortop_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(9),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carryxortop_rt_40

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(1),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carrymux_rt_38

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(2),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carrymux_rt_35

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(3),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carrymux_rt_32

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(4),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carrymux_rt_29

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(5),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carrymux_rt_26

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(6),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carrymux_rt_23

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(7),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carrymux_rt_20

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carrymux_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => histogram_x0_clrmem_cntr_op_net_x0(8),
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carrymux_rt_16

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_1 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(0)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(0)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_2 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(1)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(1)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_3 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(2)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(2)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_4 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(3)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(3)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_5 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(4)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(4)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_6 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(5)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(5)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_7 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(6)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(6)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_8 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(7)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(7)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_9 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(8)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(8)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_q_i_simple_qreg_fd_output_10 : 
FDRE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk_1,
      CE => histogram_x0_logical9_y_net_x0,
      D => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(9)
,
      R => N0,
      Q => histogram_x0_clrmem_cntr_op_net_x0(9)
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_need_mux_carrymux0 : 
MUXCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_thresh0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(0)
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(0)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_carryxor0 : 
XORCY
    port map (
      CI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(0)
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(0)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carryxortop : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(8)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carryxortop_rt_40
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(9)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(0)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carrymux_rt_38
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(1)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(0)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carrymux_rt_38
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(1)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(1)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carrymux_rt_35
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(2)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(1)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carrymux_rt_35
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(2)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(2)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carrymux_rt_32
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(3)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(2)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carrymux_rt_32
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(3)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(3)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carrymux_rt_29
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(4)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(3)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carrymux_rt_29
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(4)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(4)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carrymux_rt_26
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(5)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(4)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carrymux_rt_26
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(5)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(5)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carrymux_rt_23
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(6)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(5)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carrymux_rt_23
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(6)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(6)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carrymux_rt_20
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(7)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(6)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carrymux_rt_20
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(7)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carrymux : 
MUXCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(7)
,
      DI => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0,
      S => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carrymux_rt_16
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(8)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carryxor : 
XORCY
    port map (
      CI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(7)
,
      LI => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carrymux_rt_16
,
      O => 
histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_U0_i_baseblox_i_baseblox_counter_the_addsub_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_s(8)

    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_XST_VCC : VCC
    port map (
      P => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_thresh0
    );
  histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_XST_GND : GND
    port map (
      G => histogram_x0_histogramstate_b889c8d767_clrmem_cntr_comp0_core_instance0_BU2_N0
    );
  histogram_x0_dual_port_ram_comp0_core_instance0_GND : GND
    port map (
      G => NLW_histogram_x0_dual_port_ram_comp0_core_instance0_GND_G_UNCONNECTED
    );
  histogram_x0_dual_port_ram_comp0_core_instance0_VCC : VCC
    port map (
      P => NLW_histogram_x0_dual_port_ram_comp0_core_instance0_VCC_P_UNCONNECTED
    );
  histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP : RAMB16
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      SRVAL_A => X"000000000",
      INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_FILE => "NONE",
      INVERT_CLK_DOA_REG => FALSE,
      INVERT_CLK_DOB_REG => FALSE,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      READ_WIDTH_A => 18,
      READ_WIDTH_B => 18,
      SIM_COLLISION_CHECK => "ALL",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "READ_FIRST",
      WRITE_WIDTH_A => 18,
      WRITE_WIDTH_B => 18,
      SRVAL_B => X"000000000"
    )
    port map (
      CASCADEINA => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      CASCADEINB => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      CLKA => clk_1,
      CLKB => clk_1,
      ENA => N1,
      REGCEA => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      REGCEB => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ENB => N1,
      SSRA => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      SSRB => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      CASCADEOUTA => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTA_UNCONNECTED
,
      CASCADEOUTB => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTB_UNCONNECTED
,
      ADDRA(14) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(13) => histogram_x0_d2_q_net(9),
      ADDRA(12) => histogram_x0_d2_q_net(8),
      ADDRA(11) => histogram_x0_d2_q_net(7),
      ADDRA(10) => histogram_x0_d2_q_net(6),
      ADDRA(9) => histogram_x0_d2_q_net(5),
      ADDRA(8) => histogram_x0_d2_q_net(4),
      ADDRA(7) => histogram_x0_d2_q_net(3),
      ADDRA(6) => histogram_x0_d2_q_net(2),
      ADDRA(5) => histogram_x0_d2_q_net(1),
      ADDRA(4) => histogram_x0_d2_q_net(0),
      ADDRA(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(1) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(0) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(14) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(13) => histogram_x0_mux3_y_net(9),
      ADDRB(12) => histogram_x0_mux3_y_net(8),
      ADDRB(11) => histogram_x0_mux3_y_net(7),
      ADDRB(10) => histogram_x0_mux3_y_net(6),
      ADDRB(9) => histogram_x0_mux3_y_net(5),
      ADDRB(8) => histogram_x0_mux3_y_net(4),
      ADDRB(7) => histogram_x0_mux3_y_net(3),
      ADDRB(6) => histogram_x0_mux3_y_net(2),
      ADDRB(5) => histogram_x0_mux3_y_net(1),
      ADDRB(4) => histogram_x0_mux3_y_net(0),
      ADDRB(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(1) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(0) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(31) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(30) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(29) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(28) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(27) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(26) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(25) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(24) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(23) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(22) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(21) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(20) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(19) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(18) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(17) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(16) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(15) => histogram_x0_addsub_s_net(16),
      DIA(14) => histogram_x0_addsub_s_net(15),
      DIA(13) => histogram_x0_addsub_s_net(14),
      DIA(12) => histogram_x0_addsub_s_net(13),
      DIA(11) => histogram_x0_addsub_s_net(12),
      DIA(10) => histogram_x0_addsub_s_net(11),
      DIA(9) => histogram_x0_addsub_s_net(10),
      DIA(8) => histogram_x0_addsub_s_net(9),
      DIA(7) => histogram_x0_addsub_s_net(7),
      DIA(6) => histogram_x0_addsub_s_net(6),
      DIA(5) => histogram_x0_addsub_s_net(5),
      DIA(4) => histogram_x0_addsub_s_net(4),
      DIA(3) => histogram_x0_addsub_s_net(3),
      DIA(2) => histogram_x0_addsub_s_net(2),
      DIA(1) => histogram_x0_addsub_s_net(1),
      DIA(0) => histogram_x0_addsub_s_net(0),
      DIB(31) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(30) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(29) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(28) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(27) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(26) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(25) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(24) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(23) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(22) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(21) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(20) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(19) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(18) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(17) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(16) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(15) => N0,
      DIB(14) => N0,
      DIB(13) => N0,
      DIB(12) => N0,
      DIB(11) => N0,
      DIB(10) => N0,
      DIB(9) => N0,
      DIB(8) => N0,
      DIB(7) => N0,
      DIB(6) => N0,
      DIB(5) => N0,
      DIB(4) => N0,
      DIB(3) => N0,
      DIB(2) => N0,
      DIB(1) => N0,
      DIB(0) => N0,
      DIPA(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPA(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPA(1) => histogram_x0_addsub_s_net(17),
      DIPA(0) => histogram_x0_addsub_s_net(8),
      DIPB(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPB(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPB(1) => N0,
      DIPB(0) => N0,
      WEA(3) => histogram_x0_logical8_y_net_x0,
      WEA(2) => histogram_x0_logical8_y_net_x0,
      WEA(1) => histogram_x0_logical8_y_net_x0,
      WEA(0) => histogram_x0_logical8_y_net_x0,
      WEB(3) => histogram_x0_logical9_y_net_x0,
      WEB(2) => histogram_x0_logical9_y_net_x0,
      WEB(1) => histogram_x0_logical9_y_net_x0,
      WEB(0) => histogram_x0_logical9_y_net_x0,
      DOA(31) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_31_UNCONNECTED
,
      DOA(30) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_30_UNCONNECTED
,
      DOA(29) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_29_UNCONNECTED
,
      DOA(28) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_28_UNCONNECTED
,
      DOA(27) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_27_UNCONNECTED
,
      DOA(26) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_26_UNCONNECTED
,
      DOA(25) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_25_UNCONNECTED
,
      DOA(24) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_24_UNCONNECTED
,
      DOA(23) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_23_UNCONNECTED
,
      DOA(22) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_22_UNCONNECTED
,
      DOA(21) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_21_UNCONNECTED
,
      DOA(20) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_20_UNCONNECTED
,
      DOA(19) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_19_UNCONNECTED
,
      DOA(18) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_18_UNCONNECTED
,
      DOA(17) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_17_UNCONNECTED
,
      DOA(16) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_16_UNCONNECTED
,
      DOA(15) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(16),
      DOA(14) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(15),
      DOA(13) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(14),
      DOA(12) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(13),
      DOA(11) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(12),
      DOA(10) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(11),
      DOA(9) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(10),
      DOA(8) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(9),
      DOA(7) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(7),
      DOA(6) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(6),
      DOA(5) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(5),
      DOA(4) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(4),
      DOA(3) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(3),
      DOA(2) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(2),
      DOA(1) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(1),
      DOA(0) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(0),
      DOB(31) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_31_UNCONNECTED
,
      DOB(30) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_30_UNCONNECTED
,
      DOB(29) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_29_UNCONNECTED
,
      DOB(28) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_28_UNCONNECTED
,
      DOB(27) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_27_UNCONNECTED
,
      DOB(26) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_26_UNCONNECTED
,
      DOB(25) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_25_UNCONNECTED
,
      DOB(24) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_24_UNCONNECTED
,
      DOB(23) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_23_UNCONNECTED
,
      DOB(22) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_22_UNCONNECTED
,
      DOB(21) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_21_UNCONNECTED
,
      DOB(20) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_20_UNCONNECTED
,
      DOB(19) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_19_UNCONNECTED
,
      DOB(18) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_18_UNCONNECTED
,
      DOB(17) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_17_UNCONNECTED
,
      DOB(16) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_16_UNCONNECTED
,
      DOB(15) => NlwRenamedSig_OI_tmi_miso_rd_data(16),
      DOB(14) => NlwRenamedSig_OI_tmi_miso_rd_data(15),
      DOB(13) => NlwRenamedSig_OI_tmi_miso_rd_data(14),
      DOB(12) => NlwRenamedSig_OI_tmi_miso_rd_data(13),
      DOB(11) => NlwRenamedSig_OI_tmi_miso_rd_data(12),
      DOB(10) => NlwRenamedSig_OI_tmi_miso_rd_data(11),
      DOB(9) => NlwRenamedSig_OI_tmi_miso_rd_data(10),
      DOB(8) => NlwRenamedSig_OI_tmi_miso_rd_data(9),
      DOB(7) => NlwRenamedSig_OI_tmi_miso_rd_data(7),
      DOB(6) => NlwRenamedSig_OI_tmi_miso_rd_data(6),
      DOB(5) => NlwRenamedSig_OI_tmi_miso_rd_data(5),
      DOB(4) => NlwRenamedSig_OI_tmi_miso_rd_data(4),
      DOB(3) => NlwRenamedSig_OI_tmi_miso_rd_data(3),
      DOB(2) => NlwRenamedSig_OI_tmi_miso_rd_data(2),
      DOB(1) => NlwRenamedSig_OI_tmi_miso_rd_data(1),
      DOB(0) => NlwRenamedSig_OI_tmi_miso_rd_data(0),
      DOPA(3) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_3_UNCONNECTED
,
      DOPA(2) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_2_UNCONNECTED
,
      DOPA(1) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(17),
      DOPA(0) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(8),
      DOPB(3) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_3_UNCONNECTED
,
      DOPB(2) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_0_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_2_UNCONNECTED
,
      DOPB(1) => NlwRenamedSig_OI_tmi_miso_rd_data(17),
      DOPB(0) => NlwRenamedSig_OI_tmi_miso_rd_data(8)
    );
  histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP : RAMB16
    generic map(
      DOA_REG => 0,
      DOB_REG => 0,
      INIT_A => X"000000000",
      INIT_B => X"000000000",
      INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      SRVAL_A => X"000000000",
      INIT_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",
      INIT_FILE => "NONE",
      INVERT_CLK_DOA_REG => FALSE,
      INVERT_CLK_DOB_REG => FALSE,
      RAM_EXTENSION_A => "NONE",
      RAM_EXTENSION_B => "NONE",
      READ_WIDTH_A => 18,
      READ_WIDTH_B => 18,
      SIM_COLLISION_CHECK => "ALL",
      INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
      INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
      WRITE_MODE_A => "READ_FIRST",
      WRITE_MODE_B => "READ_FIRST",
      WRITE_WIDTH_A => 18,
      WRITE_WIDTH_B => 18,
      SRVAL_B => X"000000000"
    )
    port map (
      CASCADEINA => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      CASCADEINB => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      CLKA => clk_1,
      CLKB => clk_1,
      ENA => N1,
      REGCEA => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      REGCEB => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ENB => N1,
      SSRA => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      SSRB => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      CASCADEOUTA => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTA_UNCONNECTED
,
      CASCADEOUTB => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_CASCADEOUTB_UNCONNECTED
,
      ADDRA(14) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(13) => histogram_x0_d2_q_net(9),
      ADDRA(12) => histogram_x0_d2_q_net(8),
      ADDRA(11) => histogram_x0_d2_q_net(7),
      ADDRA(10) => histogram_x0_d2_q_net(6),
      ADDRA(9) => histogram_x0_d2_q_net(5),
      ADDRA(8) => histogram_x0_d2_q_net(4),
      ADDRA(7) => histogram_x0_d2_q_net(3),
      ADDRA(6) => histogram_x0_d2_q_net(2),
      ADDRA(5) => histogram_x0_d2_q_net(1),
      ADDRA(4) => histogram_x0_d2_q_net(0),
      ADDRA(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(1) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRA(0) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(14) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(13) => histogram_x0_mux3_y_net(9),
      ADDRB(12) => histogram_x0_mux3_y_net(8),
      ADDRB(11) => histogram_x0_mux3_y_net(7),
      ADDRB(10) => histogram_x0_mux3_y_net(6),
      ADDRB(9) => histogram_x0_mux3_y_net(5),
      ADDRB(8) => histogram_x0_mux3_y_net(4),
      ADDRB(7) => histogram_x0_mux3_y_net(3),
      ADDRB(6) => histogram_x0_mux3_y_net(2),
      ADDRB(5) => histogram_x0_mux3_y_net(1),
      ADDRB(4) => histogram_x0_mux3_y_net(0),
      ADDRB(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(1) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      ADDRB(0) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(31) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(30) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(29) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(28) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(27) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(26) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(25) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(24) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(23) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(22) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(21) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(20) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(19) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(18) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(17) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(16) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(15) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(14) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(13) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(12) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(11) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(10) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(9) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(8) => histogram_x0_addsub_s_net(20),
      DIA(7) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(6) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(5) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(4) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIA(1) => histogram_x0_addsub_s_net(19),
      DIA(0) => histogram_x0_addsub_s_net(18),
      DIB(31) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(30) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(29) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(28) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(27) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(26) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(25) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(24) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(23) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(22) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(21) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(20) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(19) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(18) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(17) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(16) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(15) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(14) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(13) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(12) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(11) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(10) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(9) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(8) => N0,
      DIB(7) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(6) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(5) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(4) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIB(1) => N0,
      DIB(0) => N0,
      DIPA(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPA(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPA(1) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPA(0) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPB(3) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPB(2) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPB(1) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      DIPB(0) => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr,
      WEA(3) => histogram_x0_logical8_y_net_x0,
      WEA(2) => histogram_x0_logical8_y_net_x0,
      WEA(1) => histogram_x0_logical8_y_net_x0,
      WEA(0) => histogram_x0_logical8_y_net_x0,
      WEB(3) => histogram_x0_logical9_y_net_x0,
      WEB(2) => histogram_x0_logical9_y_net_x0,
      WEB(1) => histogram_x0_logical9_y_net_x0,
      WEB(0) => histogram_x0_logical9_y_net_x0,
      DOA(31) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_31_UNCONNECTED
,
      DOA(30) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_30_UNCONNECTED
,
      DOA(29) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_29_UNCONNECTED
,
      DOA(28) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_28_UNCONNECTED
,
      DOA(27) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_27_UNCONNECTED
,
      DOA(26) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_26_UNCONNECTED
,
      DOA(25) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_25_UNCONNECTED
,
      DOA(24) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_24_UNCONNECTED
,
      DOA(23) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_23_UNCONNECTED
,
      DOA(22) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_22_UNCONNECTED
,
      DOA(21) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_21_UNCONNECTED
,
      DOA(20) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_20_UNCONNECTED
,
      DOA(19) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_19_UNCONNECTED
,
      DOA(18) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_18_UNCONNECTED
,
      DOA(17) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_17_UNCONNECTED
,
      DOA(16) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_16_UNCONNECTED
,
      DOA(15) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_15_UNCONNECTED
,
      DOA(14) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_14_UNCONNECTED
,
      DOA(13) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_13_UNCONNECTED
,
      DOA(12) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_12_UNCONNECTED
,
      DOA(11) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_11_UNCONNECTED
,
      DOA(10) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_10_UNCONNECTED
,
      DOA(9) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_9_UNCONNECTED
,
      DOA(8) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(20),
      DOA(7) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_7_UNCONNECTED
,
      DOA(6) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_6_UNCONNECTED
,
      DOA(5) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_5_UNCONNECTED
,
      DOA(4) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_4_UNCONNECTED
,
      DOA(3) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_3_UNCONNECTED
,
      DOA(2) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOA_2_UNCONNECTED
,
      DOA(1) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(19),
      DOA(0) => histogram_x0_dual_port_ram_comp0_core_instance0_douta(18),
      DOB(31) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_31_UNCONNECTED
,
      DOB(30) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_30_UNCONNECTED
,
      DOB(29) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_29_UNCONNECTED
,
      DOB(28) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_28_UNCONNECTED
,
      DOB(27) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_27_UNCONNECTED
,
      DOB(26) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_26_UNCONNECTED
,
      DOB(25) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_25_UNCONNECTED
,
      DOB(24) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_24_UNCONNECTED
,
      DOB(23) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_23_UNCONNECTED
,
      DOB(22) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_22_UNCONNECTED
,
      DOB(21) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_21_UNCONNECTED
,
      DOB(20) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_20_UNCONNECTED
,
      DOB(19) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_19_UNCONNECTED
,
      DOB(18) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_18_UNCONNECTED
,
      DOB(17) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_17_UNCONNECTED
,
      DOB(16) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_16_UNCONNECTED
,
      DOB(15) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_15_UNCONNECTED
,
      DOB(14) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_14_UNCONNECTED
,
      DOB(13) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_13_UNCONNECTED
,
      DOB(12) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_12_UNCONNECTED
,
      DOB(11) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_11_UNCONNECTED
,
      DOB(10) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_10_UNCONNECTED
,
      DOB(9) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_9_UNCONNECTED
,
      DOB(8) => NlwRenamedSig_OI_tmi_miso_rd_data(20),
      DOB(7) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_7_UNCONNECTED
,
      DOB(6) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_6_UNCONNECTED
,
      DOB(5) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_5_UNCONNECTED
,
      DOB(4) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_4_UNCONNECTED
,
      DOB(3) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_3_UNCONNECTED
,
      DOB(2) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOB_2_UNCONNECTED
,
      DOB(1) => NlwRenamedSig_OI_tmi_miso_rd_data(19),
      DOB(0) => NlwRenamedSig_OI_tmi_miso_rd_data(18),
      DOPA(3) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_3_UNCONNECTED
,
      DOPA(2) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_2_UNCONNECTED
,
      DOPA(1) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_1_UNCONNECTED
,
      DOPA(0) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPA_0_UNCONNECTED
,
      DOPB(3) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_3_UNCONNECTED
,
      DOPB(2) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_2_UNCONNECTED
,
      DOPB(1) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_1_UNCONNECTED
,
      DOPB(0) => 
NLW_histogram_x0_dual_port_ram_comp0_core_instance0_BU2_U0_blk_mem_generator_valid_cstr_ramloop_1_ram_r_v4_ram_TRUE_DP_SINGLE_PRIM_TDP_DOPB_0_UNCONNECTED

    );
  histogram_x0_dual_port_ram_comp0_core_instance0_BU2_XST_GND : GND
    port map (
      G => histogram_x0_dual_port_ram_comp0_core_instance0_BU2_sbiterr
    );
  histogram_x0_addsub_comp0_core_instance0_GND : GND
    port map (
      G => NLW_histogram_x0_addsub_comp0_core_instance0_GND_G_UNCONNECTED
    );
  histogram_x0_addsub_comp0_core_instance0_VCC : VCC
    port map (
      P => NLW_histogram_x0_addsub_comp0_core_instance0_VCC_P_UNCONNECTED
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_0_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N1,
      I1 => histogram_x0_mux_y_net(0),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(0)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_1_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(1),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(1)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_2_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(2),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(2)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_3_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(3),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(3)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_4_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(4),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(4)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_5_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(5),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(5)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_6_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(6),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(6)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_7_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(7),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(7)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_8_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(8),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(8)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_9_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(9),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(9)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_10_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(10),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(10)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_11_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(11),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(11)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_12_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(12),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(12)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_13_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(13),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(13)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_14_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(14),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(14)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_15_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(15),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(15)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_16_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(16),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(16)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_17_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(17),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(17)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_18_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(18),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(18)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_19_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(19),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(19)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_20_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => histogram_x0_mux_y_net(20),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(20)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_Mxor_halfsum_Result_21_1 : 
LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => N0,
      I1 => N0,
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(21)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_need_mux_carrymux0 : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_c_out,
      DI => histogram_x0_mux_y_net(0),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(0),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(0)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_carryxor0 : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_c_out,
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(0),
      O => histogram_x0_addsub_s_net(0)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carryxortop : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(20),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(21),
      O => histogram_x0_addsub_comp0_core_instance0_s(21)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(0),
      DI => histogram_x0_mux_y_net(1),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(1),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(1)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_1_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(0),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(1),
      O => histogram_x0_addsub_s_net(1)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(1),
      DI => histogram_x0_mux_y_net(2),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(2),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(2)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_2_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(1),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(2),
      O => histogram_x0_addsub_s_net(2)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(2),
      DI => histogram_x0_mux_y_net(3),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(3),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(3)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_3_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(2),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(3),
      O => histogram_x0_addsub_s_net(3)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(3),
      DI => histogram_x0_mux_y_net(4),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(4),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(4)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_4_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(3),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(4),
      O => histogram_x0_addsub_s_net(4)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(4),
      DI => histogram_x0_mux_y_net(5),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(5),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(5)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_5_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(4),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(5),
      O => histogram_x0_addsub_s_net(5)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(5),
      DI => histogram_x0_mux_y_net(6),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(6),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(6)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_6_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(5),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(6),
      O => histogram_x0_addsub_s_net(6)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(6),
      DI => histogram_x0_mux_y_net(7),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(7),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(7)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_7_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(6),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(7),
      O => histogram_x0_addsub_s_net(7)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(7),
      DI => histogram_x0_mux_y_net(8),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(8),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(8)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_8_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(7),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(8),
      O => histogram_x0_addsub_s_net(8)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_9_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(8),
      DI => histogram_x0_mux_y_net(9),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(9),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(9)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_9_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(8),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(9),
      O => histogram_x0_addsub_s_net(9)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_10_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(9),
      DI => histogram_x0_mux_y_net(10),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(10),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(10)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_10_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(9),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(10),
      O => histogram_x0_addsub_s_net(10)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_11_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(10),
      DI => histogram_x0_mux_y_net(11),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(11),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(11)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_11_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(10),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(11),
      O => histogram_x0_addsub_s_net(11)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_12_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(11),
      DI => histogram_x0_mux_y_net(12),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(12),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(12)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_12_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(11),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(12),
      O => histogram_x0_addsub_s_net(12)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_13_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(12),
      DI => histogram_x0_mux_y_net(13),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(13),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(13)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_13_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(12),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(13),
      O => histogram_x0_addsub_s_net(13)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_14_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(13),
      DI => histogram_x0_mux_y_net(14),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(14),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(14)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_14_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(13),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(14),
      O => histogram_x0_addsub_s_net(14)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_15_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(14),
      DI => histogram_x0_mux_y_net(15),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(15),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(15)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_15_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(14),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(15),
      O => histogram_x0_addsub_s_net(15)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_16_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(15),
      DI => histogram_x0_mux_y_net(16),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(16),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(16)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_16_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(15),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(16),
      O => histogram_x0_addsub_s_net(16)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_17_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(16),
      DI => histogram_x0_mux_y_net(17),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(17),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(17)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_17_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(16),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(17),
      O => histogram_x0_addsub_s_net(17)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_18_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(17),
      DI => histogram_x0_mux_y_net(18),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(18),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(18)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_18_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(17),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(18),
      O => histogram_x0_addsub_s_net(18)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_19_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(18),
      DI => histogram_x0_mux_y_net(19),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(19),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(19)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_19_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(18),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(19),
      O => histogram_x0_addsub_s_net(19)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_20_carrymux : 
MUXCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(19),
      DI => histogram_x0_mux_y_net(20),
      S => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(20),
      O => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(20)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_i_simple_model_i_gt_1_carrychaingen_20_carryxor : 
XORCY
    port map (
      CI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_carry_simple(19),
      LI => histogram_x0_addsub_comp0_core_instance0_BU2_U0_addsub_v9_1_i_addsub_v9_1_no_pipelining_the_addsub_i_lut4_i_lut4_addsub_halfsum(20),
      O => histogram_x0_addsub_s_net(20)
    );
  histogram_x0_addsub_comp0_core_instance0_BU2_XST_GND : GND
    port map (
      G => histogram_x0_addsub_comp0_core_instance0_BU2_c_out
    );

end STRUCTURE;

-- synthesis translate_on
