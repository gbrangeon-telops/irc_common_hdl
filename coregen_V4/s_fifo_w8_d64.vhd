--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: J.33
--  \   \         Application: netgen
--  /   /         Filename: s_fifo_w8_d64.vhd
-- /___/   /\     Timestamp: Tue Jul 31 13:38:36 2007
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -w -sim -ofmt vhdl D:\telops\coregen\tmp\_cg\s_fifo_w8_d64.ngc D:\telops\coregen\tmp\_cg\s_fifo_w8_d64.vhd 
-- Device	: 4vfx100ff1152-10
-- Input file	: D:/telops/coregen/tmp/_cg/s_fifo_w8_d64.ngc
-- Output file	: D:/telops/coregen/tmp/_cg/s_fifo_w8_d64.vhd
-- # of Entities	: 1
-- Design Name	: s_fifo_w8_d64
-- Xilinx	: D:\Xilinx91i
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


-- synopsys translate_off
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity s_fifo_w8_d64 is
  port (
    valid : out STD_LOGIC; 
    rd_en : in STD_LOGIC := 'X'; 
    wr_en : in STD_LOGIC := 'X'; 
    full : out STD_LOGIC; 
    empty : out STD_LOGIC; 
    clk : in STD_LOGIC := 'X'; 
    rst : in STD_LOGIC := 'X'; 
    dout : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    din : in STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end s_fifo_w8_d64;

architecture STRUCTURE of s_fifo_w8_d64 is
  signal NlwRenamedSig_OI_empty : STD_LOGIC; 
  signal NlwRenamedSig_OI_full : STD_LOGIC; 
  signal BU2_N2 : STD_LOGIC; 
  signal BU2_srst : STD_LOGIC; 
  signal BU2_wr_rst : STD_LOGIC; 
  signal BU2_backup : STD_LOGIC; 
  signal BU2_wr_clk : STD_LOGIC; 
  signal BU2_rd_rst : STD_LOGIC; 
  signal BU2_rd_clk : STD_LOGIC; 
  signal BU2_almost_empty : STD_LOGIC; 
  signal BU2_backup_marker : STD_LOGIC; 
  signal BU2_sbiterr : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N445 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N444 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N443 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N442 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N441 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N440 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N439 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N438 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N437 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N436 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N435 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N434 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N433 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N432 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N431 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N430 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_N429 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map35 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map78 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map65 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map42 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map76 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map53 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map39 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map35 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map75 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map62 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map39 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map73 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map50 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map34 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map22 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map21 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map10 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_wr_rst_q_2 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N73 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N71 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N69 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N67 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N63 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N61 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N65 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N59 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N57 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N53 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N51 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N55 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N49 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N47 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N43 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N41 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N45 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N39 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N37 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N33 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N31 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N35 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N29 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N27 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N23 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N21 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N25 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N17 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N15 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N19 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N11 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N13 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_inblk_wr_rst_int_4 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_inblk_rd_rst_int_6 : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN : STD_LOGIC; 
  signal BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN : STD_LOGIC; 
  signal NLW_VCC_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_GND_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem31_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem30_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem29_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem28_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem26_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem25_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem27_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem24_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem23_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem21_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem20_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem22_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem19_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem18_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem16_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem15_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem17_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem14_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem13_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem11_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem10_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem12_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem9_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem8_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem6_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem5_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem7_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem3_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem2_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem4_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem1_SPO_UNCONNECTED : STD_LOGIC; 
  signal din_7 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal dout_8 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_prog_empty_thresh : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_prog_empty_thresh_negate : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_prog_full_thresh : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_prog_full_thresh_assert : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_prog_full_thresh_negate : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_prog_empty_thresh_assert : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_U0_gen_ss_ss_DEBUG_RD_PNTR : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r : STD_LOGIC_VECTOR ( 5 downto 0 ); 
  signal BU2_U0_gen_ss_ss_DEBUG_WR_PNTR : STD_LOGIC_VECTOR ( 5 downto 0 ); 
begin
  full <= NlwRenamedSig_OI_full;
  empty <= NlwRenamedSig_OI_empty;
  dout(7) <= dout_8(7);
  dout(6) <= dout_8(6);
  dout(5) <= dout_8(5);
  dout(4) <= dout_8(4);
  dout(3) <= dout_8(3);
  dout(2) <= dout_8(2);
  dout(1) <= dout_8(1);
  dout(0) <= dout_8(0);
  din_7(7) <= din(7);
  din_7(6) <= din(6);
  din_7(5) <= din(5);
  din_7(4) <= din(4);
  din_7(3) <= din(3);
  din_7(2) <= din(2);
  din_7(1) <= din(1);
  din_7(0) <= din(0);
  VCC_0 : VCC
    port map (
      P => NLW_VCC_P_UNCONNECTED
    );
  GND_1 : GND
    port map (
      G => NLW_GND_G_UNCONNECTED
    );
  BU2_XST_VCC : VCC
    port map (
      P => BU2_N2
    );
  BU2_XST_GND : GND
    port map (
      G => BU2_sbiterr
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i113 : LUT4_L
    generic map(
      INIT => X"FF6F"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      I3 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map34,
      LO => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map35
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i113 : LUT4_L
    generic map(
      INIT => X"FF6F"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      I3 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map34,
      LO => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map35
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i236 : LUT4_L
    generic map(
      INIT => X"8421"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(3),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(2),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      I3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      LO => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map65
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i230 : LUT4_L
    generic map(
      INIT => X"8421"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(3),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(2),
      I2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      LO => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map62
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i65 : LUT4_L
    generic map(
      INIT => X"7BDE"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      I2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      LO => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map21
    );
  BU2_U0_gen_ss_ss_XST_VCC : VCC
    port map (
      P => BU2_U0_gen_ss_ss_N445
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : INV
    port map (
      I => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : INV
    port map (
      I => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : INV
    port map (
      I => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : INV
    port map (
      I => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX7_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N71,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N73,
      O => BU2_U0_gen_ss_ss_N444
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX7_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N67,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N69,
      O => BU2_U0_gen_ss_ss_N443
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX7_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N443,
      I1 => BU2_U0_gen_ss_ss_N444,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(7)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX6_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N63,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N65,
      O => BU2_U0_gen_ss_ss_N442
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX6_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N59,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N61,
      O => BU2_U0_gen_ss_ss_N441
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX6_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N441,
      I1 => BU2_U0_gen_ss_ss_N442,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(6)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX5_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N55,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N57,
      O => BU2_U0_gen_ss_ss_N440
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX5_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N51,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N53,
      O => BU2_U0_gen_ss_ss_N439
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX5_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N439,
      I1 => BU2_U0_gen_ss_ss_N440,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(5)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX4_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N47,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N49,
      O => BU2_U0_gen_ss_ss_N438
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX4_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N43,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N45,
      O => BU2_U0_gen_ss_ss_N437
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX4_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N437,
      I1 => BU2_U0_gen_ss_ss_N438,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(4)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX3_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N39,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N41,
      O => BU2_U0_gen_ss_ss_N436
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX3_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N35,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N37,
      O => BU2_U0_gen_ss_ss_N435
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX3_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N435,
      I1 => BU2_U0_gen_ss_ss_N436,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(3)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX2_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N31,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N33,
      O => BU2_U0_gen_ss_ss_N434
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX2_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N27,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N29,
      O => BU2_U0_gen_ss_ss_N433
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX2_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N433,
      I1 => BU2_U0_gen_ss_ss_N434,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(2)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N15,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N17,
      O => BU2_U0_gen_ss_ss_N432
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N11,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N13,
      O => BU2_U0_gen_ss_ss_N431
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N431,
      I1 => BU2_U0_gen_ss_ss_N432,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(0)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX1_2_f5_G : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N23,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N25,
      O => BU2_U0_gen_ss_ss_N430
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX1_2_f5_F : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N19,
      I2 => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N21,
      O => BU2_U0_gen_ss_ss_N429
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_LPM_MUX1_2_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_ss_ss_N429,
      I1 => BU2_U0_gen_ss_ss_N430,
      S => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(1)
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i156 : LUT4
    generic map(
      INIT => X"00C4"
    )
    port map (
      I0 => rd_en,
      I1 => wr_en,
      I2 => NlwRenamedSig_OI_empty,
      I3 => NlwRenamedSig_OI_full,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map42
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i150 : LUT4
    generic map(
      INIT => X"0C04"
    )
    port map (
      I0 => wr_en,
      I1 => rd_en,
      I2 => NlwRenamedSig_OI_empty,
      I3 => NlwRenamedSig_OI_full,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map39
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_write_ctrl3 : LUT4
    generic map(
      INIT => X"0800"
    )
    port map (
      I0 => wr_en,
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_write_ctrl2 : LUT4
    generic map(
      INIT => X"0020"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      I2 => wr_en,
      I3 => NlwRenamedSig_OI_full,
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_write_ctrl1 : LUT4
    generic map(
      INIT => X"0200"
    )
    port map (
      I0 => wr_en,
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_write_ctrl : LUT4
    generic map(
      INIT => X"0002"
    )
    port map (
      I0 => wr_en,
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      O => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6
    );
  BU2_U0_gen_ss_ss_flblk_ram_wr_en_i1 : LUT2
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => wr_en,
      I1 => NlwRenamedSig_OI_full,
      O => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i299 : LUT4
    generic map(
      INIT => X"EEEC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map39,
      I1 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map78,
      I2 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map35,
      I3 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map22,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i287 : LUT4
    generic map(
      INIT => X"8000"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map42,
      I1 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map53,
      I2 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map65,
      I3 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map76,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map78
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i269 : LUT4
    generic map(
      INIT => X"8421"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(1),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(0),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      I3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map76
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i189 : LUT4
    generic map(
      INIT => X"8241"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(4),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(5),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      I3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      O => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map53
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i141 : LUT3
    generic map(
      INIT => X"A2"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_wr_rst_q_2,
      I2 => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG_i_map39
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i293 : LUT4
    generic map(
      INIT => X"EEEC"
    )
    port map (
      I0 => NlwRenamedSig_OI_empty,
      I1 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map75,
      I2 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map35,
      I3 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map22,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i281 : LUT4
    generic map(
      INIT => X"8000"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map39,
      I1 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map50,
      I2 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map62,
      I3 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map73,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map75
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i263 : LUT4
    generic map(
      INIT => X"8421"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(1),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(0),
      I2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map73
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i183 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(4),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      I2 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(5),
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5),
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map50
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i110 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map34
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i66 : LUT2
    generic map(
      INIT => X"E"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map10,
      I1 => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map21,
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map22
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i32 : LUT4
    generic map(
      INIT => X"7BDE"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      I3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      O => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG_i_map10
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count1211 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count1211 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(0),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(1),
      I2 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(2),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count1211 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      I2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count1211 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(0),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(1),
      I2 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(2),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count151 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      I3 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count151 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(4),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(5),
      I2 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(3),
      I3 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count151 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5),
      I2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      I3 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count151 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(4),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(5),
      I2 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(3),
      I3 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count122 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4),
      I2 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count122 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(3),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(4),
      I2 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count122 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4),
      I2 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count122 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(3),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(4),
      I2 => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12_bdd0,
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      I3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(2),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(3),
      I2 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(1),
      I3 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      I2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      I3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(2),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(3),
      I2 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(1),
      I3 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(0),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      I2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(0),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(2),
      I2 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      I2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(0),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(2),
      I2 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(0),
      I1 => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      I1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(0),
      I1 => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(1),
      O => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3
    );
  BU2_U0_gen_ss_ss_olblk_gv_validl_VALID_mux00011 : LUT2
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => rd_en,
      I1 => NlwRenamedSig_OI_empty,
      O => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15,
      Q => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(5)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12,
      Q => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(4)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9,
      Q => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6,
      Q => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3,
      Q => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count,
      Q => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15,
      Q => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(5)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12,
      Q => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(4)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9,
      Q => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6,
      Q => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3,
      Q => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count,
      Q => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12,
      Q => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(4)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9,
      Q => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(3)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15,
      Q => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(5)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3,
      Q => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(1)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count,
      PRE => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      Q => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(0)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6,
      Q => BU2_U0_gen_ss_ss_debug_rd_pntr_plus1_r(2)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count12,
      Q => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(4)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count9,
      Q => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(3)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count15,
      Q => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(5)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count3,
      Q => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(1)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count,
      PRE => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      Q => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(0)
    );
  BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      D => BU2_U0_gen_ss_ss_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count6,
      Q => BU2_U0_gen_ss_ss_debug_wr_pntr_plus1_w(2)
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_wr_rst_q : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => BU2_almost_empty,
      PRE => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      Q => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_wr_rst_q_2
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_flogic_RAM_FULL_i : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_ss_ss_flblk_thrmod_flogic_FULL_NONREG,
      PRE => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      Q => NlwRenamedSig_OI_full
    );
  BU2_U0_gen_ss_ss_flblk_thrmod_elogic_RAM_EMPTY_i : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_ss_ss_flblk_thrmod_elogic_EMPTY_NONREG,
      PRE => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      Q => NlwRenamedSig_OI_empty
    );
  BU2_U0_gen_ss_ss_olblk_gv_validl_VALID : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      Q => valid
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem31 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(7),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem31_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N73
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem30 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(7),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem30_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N71
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem29 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(7),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem29_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N69
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem28 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(7),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem28_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N67
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem26 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(6),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem26_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N63
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem25 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(6),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem25_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N61
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem27 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(6),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem27_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N65
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem24 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(6),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem24_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N59
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem23 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(5),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem23_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N57
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem21 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(5),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem21_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N53
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem20 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(5),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem20_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N51
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem22 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(5),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem22_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N55
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem19 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(4),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem19_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N49
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem18 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(4),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem18_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N47
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem16 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(4),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem16_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N43
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem15 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(3),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem15_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N41
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem17 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(4),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem17_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N45
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem14 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(3),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem14_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N39
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem13 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(3),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem13_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N37
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem11 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(2),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem11_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N33
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem10 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(2),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem10_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N31
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem12 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(3),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem12_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N35
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem9 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(2),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem9_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N29
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem8 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(2),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem8_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N27
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem6 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(1),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem6_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N23
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem5 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(1),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem5_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N21
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem7 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(1),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem7_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N25
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem3 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(0),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N9,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem3_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N17
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem2 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(0),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N8,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem2_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N15
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem4 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(1),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem4_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N19
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(0),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N6,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N11
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem1 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_ss_ss_DEBUG_WR_PNTR(3),
      D => din_7(0),
      DPRA0 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_ss_ss_DEBUG_RD_PNTR(3),
      WCLK => clk,
      WE => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N7,
      SPO => NLW_BU2_U0_gen_ss_ss_memblk_mem0_distinst_inst_Mram_mem1_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_ss_ss_memblk_mem0_distinst_N13
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(7),
      Q => dout_8(7)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(6),
      Q => dout_8(6)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(5),
      Q => dout_8(5)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(4),
      Q => dout_8(4)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(3),
      Q => dout_8(3)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(2),
      Q => dout_8(2)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(1),
      Q => dout_8(1)
    );
  BU2_U0_gen_ss_ss_memblk_mem0_distinst_dob_i_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      D => BU2_U0_gen_ss_ss_memblk_mem0_distinst_varindex0000(0),
      Q => dout_8(0)
    );
  BU2_U0_gen_ss_ss_inblk_wr_rst_int : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3,
      PRE => rst,
      Q => BU2_U0_gen_ss_ss_inblk_wr_rst_int_4
    );
  BU2_U0_gen_ss_ss_inblk_rd_rst_int : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      D => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5,
      PRE => rst,
      Q => BU2_U0_gen_ss_ss_inblk_rd_rst_int_6
    );
  BU2_U0_gen_ss_ss_inblk_wr_rst_reg : FDPE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_inblk_wr_rst_int_4,
      D => BU2_almost_empty,
      PRE => rst,
      Q => BU2_U0_gen_ss_ss_inblk_wr_rst_reg_3
    );
  BU2_U0_gen_ss_ss_inblk_rd_rst_reg : FDPE
    generic map(
      INIT => '0'
    )
    port map (
      C => clk,
      CE => BU2_U0_gen_ss_ss_inblk_rd_rst_int_6,
      D => BU2_almost_empty,
      PRE => rst,
      Q => BU2_U0_gen_ss_ss_inblk_rd_rst_reg_5
    );
  BU2_U0_gen_ss_ss_XST_GND : GND
    port map (
      G => BU2_almost_empty
    );

end STRUCTURE;

-- synopsys translate_on
