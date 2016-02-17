--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: J.33
--  \   \         Application: netgen
--  /   /         Filename: as_fifo_w32_d16.vhd
-- /___/   /\     Timestamp: Tue Jul 31 16:28:01 2007
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -w -sim -ofmt vhdl D:\telops\coregen\tmp\_cg\as_fifo_w32_d16.ngc D:\telops\coregen\tmp\_cg\as_fifo_w32_d16.vhd 
-- Device	: 4vfx100ff1152-10
-- Input file	: D:/telops/coregen/tmp/_cg/as_fifo_w32_d16.ngc
-- Output file	: D:/telops/coregen/tmp/_cg/as_fifo_w32_d16.vhd
-- # of Entities	: 1
-- Design Name	: as_fifo_w32_d16
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

entity as_fifo_w32_d16 is
  port (
    valid : out STD_LOGIC; 
    rd_en : in STD_LOGIC := 'X'; 
    wr_en : in STD_LOGIC := 'X'; 
    full : out STD_LOGIC; 
    empty : out STD_LOGIC; 
    wr_clk : in STD_LOGIC := 'X'; 
    rst : in STD_LOGIC := 'X'; 
    rd_clk : in STD_LOGIC := 'X'; 
    dout : out STD_LOGIC_VECTOR ( 31 downto 0 ); 
    din : in STD_LOGIC_VECTOR ( 31 downto 0 ) 
  );
end as_fifo_w32_d16;

architecture STRUCTURE of as_fifo_w32_d16 is
  signal NlwRenamedSig_OI_empty : STD_LOGIC; 
  signal NlwRenamedSig_OI_full : STD_LOGIC; 
  signal BU2_N2 : STD_LOGIC; 
  signal BU2_almost_empty : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N281 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N279 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N277 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map45 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map34 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map22 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map4 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map45 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map34 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map22 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map4 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg_2 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg_4 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN : STD_LOGIC; 
  signal NLW_VCC_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_GND_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem31_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem30_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem29_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem28_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem27_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem26_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem25_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem24_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem23_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem22_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem21_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem20_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem19_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem18_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem17_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem16_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem15_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem14_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem13_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem12_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem11_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem10_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem9_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem8_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem7_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem6_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem5_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem4_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem3_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem2_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem1_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem_SPO_UNCONNECTED : STD_LOGIC; 
  signal din_5 : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal dout_6 : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal BU2_prog_empty_thresh : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_prog_empty_thresh_negate : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_prog_full_thresh : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_prog_full_thresh_assert : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_prog_full_thresh_negate : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_prog_empty_thresh_assert : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_data_count : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2 : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2 : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000 : STD_LOGIC_VECTOR ( 31 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_rd_pntr_w : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_DEBUG_RD_PNTR : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_DEBUG_WR_PNTR : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_wr_pntr_r : STD_LOGIC_VECTOR ( 3 downto 0 ); 
begin
  full <= NlwRenamedSig_OI_full;
  empty <= NlwRenamedSig_OI_empty;
  dout(31) <= dout_6(31);
  dout(30) <= dout_6(30);
  dout(29) <= dout_6(29);
  dout(28) <= dout_6(28);
  dout(27) <= dout_6(27);
  dout(26) <= dout_6(26);
  dout(25) <= dout_6(25);
  dout(24) <= dout_6(24);
  dout(23) <= dout_6(23);
  dout(22) <= dout_6(22);
  dout(21) <= dout_6(21);
  dout(20) <= dout_6(20);
  dout(19) <= dout_6(19);
  dout(18) <= dout_6(18);
  dout(17) <= dout_6(17);
  dout(16) <= dout_6(16);
  dout(15) <= dout_6(15);
  dout(14) <= dout_6(14);
  dout(13) <= dout_6(13);
  dout(12) <= dout_6(12);
  dout(11) <= dout_6(11);
  dout(10) <= dout_6(10);
  dout(9) <= dout_6(9);
  dout(8) <= dout_6(8);
  dout(7) <= dout_6(7);
  dout(6) <= dout_6(6);
  dout(5) <= dout_6(5);
  dout(4) <= dout_6(4);
  dout(3) <= dout_6(3);
  dout(2) <= dout_6(2);
  dout(1) <= dout_6(1);
  dout(0) <= dout_6(0);
  din_5(31) <= din(31);
  din_5(30) <= din(30);
  din_5(29) <= din(29);
  din_5(28) <= din(28);
  din_5(27) <= din(27);
  din_5(26) <= din(26);
  din_5(25) <= din(25);
  din_5(24) <= din(24);
  din_5(23) <= din(23);
  din_5(22) <= din(22);
  din_5(21) <= din(21);
  din_5(20) <= din(20);
  din_5(19) <= din(19);
  din_5(18) <= din(18);
  din_5(17) <= din(17);
  din_5(16) <= din(16);
  din_5(15) <= din(15);
  din_5(14) <= din(14);
  din_5(13) <= din(13);
  din_5(12) <= din(12);
  din_5(11) <= din(11);
  din_5(10) <= din(10);
  din_5(9) <= din(9);
  din_5(8) <= din(8);
  din_5(7) <= din(7);
  din_5(6) <= din(6);
  din_5(5) <= din(5);
  din_5(4) <= din(4);
  din_5(3) <= din(3);
  din_5(2) <= din(2);
  din_5(1) <= din(1);
  din_5(0) <= din(0);
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
      G => BU2_data_count(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i168_SW0 : LUT4_L
    generic map(
      INIT => X"9000"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(3),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map22,
      I3 => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      LO => BU2_U0_gen_as_fgas_N279
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i168_SW0 : LUT4_L
    generic map(
      INIT => X"9000"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map22,
      I3 => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      LO => BU2_U0_gen_as_fgas_N277
    );
  BU2_U0_gen_as_fgas_XST_VCC : VCC
    port map (
      P => BU2_U0_gen_as_fgas_N281
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : INV
    port map (
      I => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : 
INV
    port map (
      I => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : INV
    port map (
      I => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : 
INV
    port map (
      I => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_0_11_INV_0 : 
INV
    port map (
      I => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_PNTR_B_xor0002_Result1 : LUT4
    generic map(
      INIT => X"6996"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(1),
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_PNTR_B_xor0002_Result1 : LUT4
    generic map(
      INIT => X"6996"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(1),
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_PNTR_B_xor0001_Result1 : LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_PNTR_B_xor0001_Result1 : LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i168 : LUT4
    generic map(
      INIT => X"F888"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map45,
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map34,
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map4,
      I3 => BU2_U0_gen_as_fgas_N279,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i168 : LUT4
    generic map(
      INIT => X"F888"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map45,
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map34,
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map4,
      I3 => BU2_U0_gen_as_fgas_N277,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_PNTR_B_xor0000_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_PNTR_B_xor0000_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wpremod_RAM_WR_EN1 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => wr_en,
      O => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i152 : LUT4
    generic map(
      INIT => X"8421"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      I2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      I3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map45
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i119 : LUT4
    generic map(
      INIT => X"8421"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      I2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      I3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map34
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i72 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map22
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i10 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(2),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i_map4
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i152 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map45
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i119 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(2),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map34
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i72 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map22
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i10 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i_map4
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      I2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      I3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(3),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(2),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(3),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(2),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_11 : LUT4
    generic map(
      INIT => X"6CCC"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(3),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(2),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      I2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(2),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(2),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_11 : LUT3
    generic map(
      INIT => X"6C"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(2),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_11 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0000_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0001_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0002_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0000_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0001_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0002_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_olblk_gv_p1v_validl_VALID_and00001 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => NlwRenamedSig_OI_empty,
      I1 => rd_en,
      O => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0001,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0000,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(0),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(2),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(0),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(2),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0001,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0000,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0001,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0000,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(0),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(2),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(0),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(2),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0001,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0000,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_RAM_FULL_i : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      D => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG,
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      Q => NlwRenamedSig_OI_full
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_RAM_EMPTY_i : FDP
    generic map(
      INIT => '1'
    )
    port map (
      C => rd_clk,
      D => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG,
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      Q => NlwRenamedSig_OI_empty
    );
  BU2_U0_gen_as_fgas_normgen_olblk_gv_p1v_validl_VALID : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      Q => valid
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem31 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(31),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem31_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(31)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem30 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(30),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem30_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(30)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem29 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(29),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem29_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(29)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem28 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(28),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem28_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(28)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem27 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(27),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem27_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(27)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem26 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(26),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem26_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(26)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem25 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(25),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem25_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(25)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem24 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(24),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem24_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(24)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem23 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(23),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem23_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(23)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem22 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(22),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem22_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(22)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem21 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(21),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem21_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(21)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem20 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(20),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem20_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(20)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem19 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(19),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem19_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(19)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem18 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(18),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem18_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(18)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem17 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(17),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem17_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(17)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem16 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(16),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem16_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(16)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem15 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(15),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem15_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(15)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem14 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(14),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem14_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(14)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem13 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(13),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem13_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(13)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem12 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(12),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem12_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(12)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem11 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(11),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem11_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(11)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem10 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(10),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem10_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(10)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem9 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(9),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem9_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(9)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem8 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(8),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem8_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(8)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem7 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem7_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(7)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem6 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem6_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(6)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem5 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem5_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(5)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem4 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem4_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(4)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem3 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem3_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(3)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem2 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem2_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(2)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem1 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem1_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(1)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_5(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(0)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_31 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(31),
      Q => dout_6(31)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_30 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(30),
      Q => dout_6(30)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_29 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(29),
      Q => dout_6(29)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_28 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(28),
      Q => dout_6(28)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_27 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(27),
      Q => dout_6(27)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_26 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(26),
      Q => dout_6(26)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_25 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(25),
      Q => dout_6(25)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_24 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(24),
      Q => dout_6(24)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_23 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(23),
      Q => dout_6(23)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_22 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(22),
      Q => dout_6(22)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_21 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(21),
      Q => dout_6(21)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_20 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(20),
      Q => dout_6(20)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_19 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(19),
      Q => dout_6(19)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_18 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(18),
      Q => dout_6(18)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_17 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(17),
      Q => dout_6(17)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_16 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(16),
      Q => dout_6(16)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_15 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(15),
      Q => dout_6(15)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_14 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(14),
      Q => dout_6(14)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_13 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(13),
      Q => dout_6(13)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_12 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(12),
      Q => dout_6(12)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_11 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(11),
      Q => dout_6(11)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_10 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(10),
      Q => dout_6(10)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_9 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(9),
      Q => dout_6(9)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_8 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(8),
      Q => dout_6(8)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(7),
      Q => dout_6(7)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(6),
      Q => dout_6(6)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(5),
      Q => dout_6(5)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(4),
      Q => dout_6(4)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(3),
      Q => dout_6(3)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_2 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(2),
      Q => dout_6(2)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(1),
      Q => dout_6(1)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_dob_i_0 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(0),
      Q => dout_6(0)
    );
  BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg : FDPE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_almost_empty,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg_4
    );
  BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      D => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg_2,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3
    );
  BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg : FDPE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_3,
      D => BU2_almost_empty,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg_2
    );
  BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_int_0 : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      D => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg_4,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb
    );
  BU2_U0_gen_as_fgas_XST_GND : GND
    port map (
      G => BU2_almost_empty
    );

end STRUCTURE;

-- synopsys translate_on
