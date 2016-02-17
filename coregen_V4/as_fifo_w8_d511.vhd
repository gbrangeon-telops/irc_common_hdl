--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
--------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version: J.40
--  \   \         Application: netgen
--  /   /         Filename: as_fifo_w8_d511.vhd
-- /___/   /\     Timestamp: Tue Sep 02 15:53:27 2008
-- \   \  /  \ 
--  \___\/\___\
--             
-- Command	: -intstyle ise -w -sim -ofmt vhdl D:\Telops\Common_HDL\coregen_V4\tmp\_cg\as_fifo_w8_d511.ngc D:\Telops\Common_HDL\coregen_V4\tmp\_cg\as_fifo_w8_d511.vhd 
-- Device	: 4vfx100ff1152-10
-- Input file	: D:/Telops/Common_HDL/coregen_V4/tmp/_cg/as_fifo_w8_d511.ngc
-- Output file	: D:/Telops/Common_HDL/coregen_V4/tmp/_cg/as_fifo_w8_d511.vhd
-- # of Entities	: 1
-- Design Name	: as_fifo_w8_d511
-- Xilinx	: C:\Xilinx
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

entity as_fifo_w8_d511 is
  port (
    almost_empty : out STD_LOGIC; 
    valid : out STD_LOGIC; 
    rd_en : in STD_LOGIC := 'X'; 
    wr_en : in STD_LOGIC := 'X'; 
    full : out STD_LOGIC; 
    empty : out STD_LOGIC; 
    wr_clk : in STD_LOGIC := 'X'; 
    wr_ack : out STD_LOGIC; 
    rst : in STD_LOGIC := 'X'; 
    almost_full : out STD_LOGIC; 
    rd_clk : in STD_LOGIC := 'X'; 
    rd_data_count : out STD_LOGIC_VECTOR ( 8 downto 0 ); 
    wr_data_count : out STD_LOGIC_VECTOR ( 8 downto 0 ); 
    dout : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    din : in STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end as_fifo_w8_d511;

architecture STRUCTURE of as_fifo_w8_d511 is
  signal NlwRenamedSig_OI_empty : STD_LOGIC; 
  signal NlwRenamedSig_OI_full : STD_LOGIC; 
  signal BU2_N2 : STD_LOGIC; 
  signal BU2_overflow : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N424 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N224 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N324 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N524 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N615 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N913 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N713 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N813 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1013 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1113 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1413 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1213 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1313 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1513 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1613 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N322 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1713 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N222 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N614 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N422 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N522 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N912 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N712 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N812 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1012 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1112 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1412 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1212 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1312 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1512 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1612 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N320 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1712 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N220 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N420 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N520 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N811 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N613 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N711 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1111 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N911 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1011 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1411 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1211 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1311 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1511 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1611 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N318 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1711 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N218 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N418 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N518 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N810 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N612 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N710 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N910 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1010 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1310 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1110 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1210 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1410 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1510 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N216 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1610 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1710 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N316 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N416 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N78 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N516 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N611 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N88 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N98 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N128 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N108 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N118 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N138 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N148 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N178 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N158 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N168 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N414 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N214 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N314 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N76 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N514 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N610 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N86 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N96 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N126 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N106 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N116 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N136 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N146 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N176 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N156 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N166 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N212 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N312 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N68 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N412 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N512 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N84 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N94 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N114 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N124 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N74 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N104 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N134 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N164 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N174 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N144 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N154 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N210 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N510 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N66 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N310 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N410 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N72 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N102 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N112 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N82 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N132 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N142 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N92 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N162 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N172 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N122 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N152 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_3_f7_2 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f7_3 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_3_f7_4 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f7_5 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_3_f7_6 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f7_7 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_3_f7_8 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f7_9 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_3_f7_10 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f7_11 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_3_f7_12 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f7_13 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_3_f7_14 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f7_15 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_3_f7_16 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f7_17 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f6_18 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f5_19 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f5_20 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f6_21 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f5_22 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f6_23 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_8_f5_24 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f6_25 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f5_26 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f5_27 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f6_28 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f5_29 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f6_30 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_8_f5_31 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f6_32 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f5_33 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f5_34 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f6_35 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f5_36 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f6_37 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_8_f5_38 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f6_39 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f5_40 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f5_41 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f6_42 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f5_43 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f6_44 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_8_f5_45 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f6_46 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f5_47 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f5_48 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f6_49 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f5_50 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f6_51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_8_f5_52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f6_53 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f5_54 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f5_55 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f6_56 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f5_57 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f6_58 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_8_f5_59 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f6_60 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f5_61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f5_62 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f6_63 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f5_64 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f6_65 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_8_f5_66 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f6_67 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f5_68 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f5_69 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f6_70 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f5_71 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f6_72 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_8_f5_73 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N232 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N224 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N698 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N222 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N220 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N218 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N697 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N696 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N695 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N694 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N192 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N190 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N188 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N186 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N693 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N692 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N691 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N690 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0006_bdd0 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0006_bdd0 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N6 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N7 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N8 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00004 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N9 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00006 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N10 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00008 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N11 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000010 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N12 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000012 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N13 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000014 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N14 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N15 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N16 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N17 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00004 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N18 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00006 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N19 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00008 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N20 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000010 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N21 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000012 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N22 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000014 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_N23 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0007 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0006 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0005 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0004 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0003 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0007 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0006 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0005 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0004 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0003 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0007 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0006 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0005 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0004 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0003 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0007 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0006 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0005 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0004 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0003 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0001 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_almost_full_i_or0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_FULL_inv : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_comp_af2 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_comp_af1 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_almost_empty_i_or0000 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_EMPTY_inv : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_comp_ae2 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_comp_ae1 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp_full2 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp_full1 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_comp2out : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_comp1out : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_74 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_75 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_76 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_77 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_78 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_79 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_80 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_81 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_82 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_83 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_84 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_85 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_86 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_87 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_88 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_89 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_90 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_91 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_92 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_93 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_94 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_95 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_96 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_97 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_98 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_99 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_100 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_101 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_102 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_103 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_104 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_105 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_106 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_107 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_108 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_109 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_110 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_111 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_112 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_113 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_114 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_115 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_116 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_117 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_118 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_119 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_120 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_121 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_122 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_123 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_124 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_125 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_126 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_127 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_128 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_129 : STD_LOGIC;
 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N577 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N575 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N573 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N571 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N569 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N567 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N565 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N563 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N561 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N559 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N557 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N555 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N553 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N551 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N549 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N547 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N545 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N543 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N541 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N539 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N537 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N535 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N531 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N529 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N533 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N527 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N525 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N523 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N521 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N519 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N517 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N515 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N513 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N511 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N509 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N507 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N505 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N503 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N501 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N499 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N497 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N495 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N493 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N491 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N489 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N487 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N485 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N483 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N481 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N479 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N477 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N475 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N473 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N471 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N469 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N465 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N463 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N467 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N461 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N459 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N457 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N455 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N453 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N451 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N449 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N447 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N445 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N443 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N441 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N439 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N437 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N435 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N433 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N431 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N429 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N427 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N425 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N423 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N421 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N419 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N417 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N415 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N413 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N411 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N409 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N407 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N405 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N403 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N399 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N397 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N401 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N395 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N393 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N391 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N389 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N387 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N385 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N383 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N381 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N379 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N377 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N375 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N373 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N371 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N369 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N367 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N365 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N363 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N361 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N359 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N357 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N355 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N353 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N351 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N349 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N347 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N345 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N343 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N341 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N339 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N337 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N333 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N331 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N335 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N329 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N327 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N325 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N323 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N321 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N319 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N317 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N315 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N313 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N311 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N309 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N307 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N305 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N303 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N301 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N299 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N297 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N295 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N293 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N291 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N289 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N287 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N285 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N283 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N281 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N279 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N277 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N275 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N273 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N271 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N267 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N265 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N269 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N263 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N261 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N259 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N257 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N255 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N253 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N251 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N249 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N247 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N245 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N243 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N241 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N239 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N237 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N235 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N233 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N231 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N229 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N227 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N225 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N223 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N221 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N219 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N217 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N215 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N213 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N211 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N209 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N207 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N205 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N201 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N199 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N203 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N197 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N195 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N193 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N191 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N189 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N187 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N185 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N183 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N181 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N179 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N177 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N175 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N173 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N171 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N169 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N167 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N165 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N163 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N161 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N159 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N157 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N155 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N153 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N151 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N149 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N147 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N145 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N143 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N141 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N139 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N135 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N133 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N137 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N131 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N129 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N127 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N125 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N123 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N121 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N119 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N117 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N115 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N113 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N111 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N109 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N107 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N105 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N101 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N99 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N103 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N97 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N95 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N93 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N91 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N89 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N87 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N85 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N83 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N81 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N79 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N77 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N75 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N73 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N71 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N67 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N69 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg_130 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg_132 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_N1 : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN : STD_LOGIC; 
  signal BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN : STD_LOGIC; 
  signal NLW_VCC_P_UNCONNECTED : STD_LOGIC; 
  signal NLW_GND_G_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem255_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem254_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem253_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem252_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem251_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem250_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem249_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem248_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem247_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem246_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem245_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem244_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem243_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem242_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem241_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem240_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem239_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem238_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem237_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem236_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem235_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem234_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem232_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem231_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem233_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem230_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem229_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem228_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem227_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem226_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem225_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem224_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem223_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem222_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem221_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem220_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem219_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem218_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem217_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem216_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem215_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem214_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem213_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem212_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem211_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem210_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem209_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem208_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem207_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem206_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem205_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem204_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem203_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem202_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem201_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem199_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem198_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem200_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem197_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem196_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem195_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem194_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem193_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem192_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem191_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem190_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem189_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem188_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem187_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem186_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem185_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem184_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem183_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem182_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem181_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem180_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem179_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem178_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem177_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem176_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem175_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem174_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem173_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem172_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem171_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem170_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem169_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem168_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem166_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem165_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem167_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem164_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem163_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem162_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem161_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem160_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem159_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem158_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem157_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem156_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem155_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem154_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem153_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem152_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem151_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem150_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem149_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem148_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem147_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem146_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem145_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem144_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem143_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem142_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem141_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem140_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem139_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem138_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem137_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem136_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem135_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem133_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem132_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem134_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem131_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem130_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem129_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem128_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem127_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem126_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem125_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem124_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem123_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem122_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem121_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem120_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem119_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem118_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem117_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem116_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem115_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem114_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem113_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem112_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem111_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem110_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem109_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem108_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem107_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem106_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem105_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem104_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem103_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem102_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem100_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem99_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem101_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem98_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem97_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem96_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem95_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem94_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem93_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem92_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem91_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem90_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem89_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem88_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem87_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem86_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem85_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem84_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem83_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem82_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem81_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem80_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem79_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem78_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem77_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem76_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem75_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem74_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem73_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem72_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem71_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem70_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem69_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem67_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem66_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem68_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem65_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem64_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem63_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem62_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem61_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem60_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem59_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem58_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem57_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem56_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem55_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem54_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem53_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem52_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem51_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem50_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem49_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem48_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem47_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem46_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem45_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem44_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem43_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem42_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem41_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem40_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem39_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem38_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem37_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem36_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem34_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem33_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem35_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem32_SPO_UNCONNECTED : STD_LOGIC; 
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
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem17_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem16_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem18_SPO_UNCONNECTED : STD_LOGIC; 
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
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem_SPO_UNCONNECTED : STD_LOGIC; 
  signal NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem1_SPO_UNCONNECTED : STD_LOGIC; 
  signal din_133 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal dout_134 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal rd_data_count_135 : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal wr_data_count_136 : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_prog_empty_thresh : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_prog_empty_thresh_negate : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_prog_full_thresh : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_prog_full_thresh_assert : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_prog_full_thresh_negate : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_prog_empty_thresh_assert : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_data_count : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_tmp_pntr_w_diff : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add0000_cy : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_tmp_pntr_r_diff : STD_LOGIC_VECTOR ( 0 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub0000_cy : STD_LOGIC_VECTOR ( 1 downto 1 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2 : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2 : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1 : STD_LOGIC_VECTOR ( 4 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet : STD_LOGIC_VECTOR ( 3 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000 : STD_LOGIC_VECTOR ( 7 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_rd_pntr_w : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_DEBUG_RD_PNTR : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_DEBUG_WR_PNTR : STD_LOGIC_VECTOR ( 8 downto 0 ); 
  signal BU2_U0_gen_as_fgas_debug_wr_pntr_r : STD_LOGIC_VECTOR ( 8 downto 0 ); 
begin
  rd_data_count(8) <= rd_data_count_135(8);
  rd_data_count(7) <= rd_data_count_135(7);
  rd_data_count(6) <= rd_data_count_135(6);
  rd_data_count(5) <= rd_data_count_135(5);
  rd_data_count(4) <= rd_data_count_135(4);
  rd_data_count(3) <= rd_data_count_135(3);
  rd_data_count(2) <= rd_data_count_135(2);
  rd_data_count(1) <= rd_data_count_135(1);
  rd_data_count(0) <= rd_data_count_135(0);
  wr_data_count(8) <= wr_data_count_136(8);
  wr_data_count(7) <= wr_data_count_136(7);
  wr_data_count(6) <= wr_data_count_136(6);
  wr_data_count(5) <= wr_data_count_136(5);
  wr_data_count(4) <= wr_data_count_136(4);
  wr_data_count(3) <= wr_data_count_136(3);
  wr_data_count(2) <= wr_data_count_136(2);
  wr_data_count(1) <= wr_data_count_136(1);
  wr_data_count(0) <= wr_data_count_136(0);
  full <= NlwRenamedSig_OI_full;
  empty <= NlwRenamedSig_OI_empty;
  dout(7) <= dout_134(7);
  dout(6) <= dout_134(6);
  dout(5) <= dout_134(5);
  dout(4) <= dout_134(4);
  dout(3) <= dout_134(3);
  dout(2) <= dout_134(2);
  dout(1) <= dout_134(1);
  dout(0) <= dout_134(0);
  din_133(7) <= din(7);
  din_133(6) <= din(6);
  din_133(5) <= din(5);
  din_133(4) <= din(4);
  din_133(3) <= din(3);
  din_133(2) <= din(2);
  din_133(1) <= din(1);
  din_133(0) <= din(0);
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
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl23_SW0 : LUT4_D
    generic map(
      INIT => X"8000"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I3 => wr_en,
      LO => BU2_U0_gen_as_fgas_N698,
      O => BU2_U0_gen_as_fgas_N232
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl19_SW0 : LUT4_D
    generic map(
      INIT => X"7FFF"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I3 => wr_en,
      LO => BU2_U0_gen_as_fgas_N697,
      O => BU2_U0_gen_as_fgas_N224
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl18_SW0 : LUT4_D
    generic map(
      INIT => X"FF7F"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I2 => wr_en,
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      LO => BU2_U0_gen_as_fgas_N696,
      O => BU2_U0_gen_as_fgas_N222
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl17_SW0 : LUT4_D
    generic map(
      INIT => X"FF7F"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I2 => wr_en,
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      LO => BU2_U0_gen_as_fgas_N695,
      O => BU2_U0_gen_as_fgas_N220
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl16_SW0 : LUT4_D
    generic map(
      INIT => X"FFBF"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I2 => wr_en,
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      LO => BU2_U0_gen_as_fgas_N694,
      O => BU2_U0_gen_as_fgas_N218
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl3_SW0 : LUT4_D
    generic map(
      INIT => X"FF7F"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I2 => wr_en,
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      LO => BU2_U0_gen_as_fgas_N693,
      O => BU2_U0_gen_as_fgas_N192
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl2_SW0 : LUT4_D
    generic map(
      INIT => X"FFBF"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I2 => wr_en,
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      LO => BU2_U0_gen_as_fgas_N692,
      O => BU2_U0_gen_as_fgas_N190
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl1_SW0 : LUT4_D
    generic map(
      INIT => X"FFBF"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I2 => wr_en,
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      LO => BU2_U0_gen_as_fgas_N691,
      O => BU2_U0_gen_as_fgas_N188
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl_SW0 : LUT4_D
    generic map(
      INIT => X"FFEF"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I2 => wr_en,
      I3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      LO => BU2_U0_gen_as_fgas_N690,
      O => BU2_U0_gen_as_fgas_N186
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_EMPTY_inv1_INV_0 : INV
    port map (
      I => NlwRenamedSig_OI_empty,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_EMPTY_inv
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_FULL_inv1_INV_0 : INV
    port map (
      I => NlwRenamedSig_OI_full,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_FULL_inv
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_lut_0_INV_0 : INV
    port map (
      I => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_lut_0_INV_0 : INV
    port map (
      I => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_lut_0_INV_0 : INV
    port map (
      I => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_lut_0_INV_0 : INV
    port map (
      I => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_lut_0_INV_0 : 
INV
    port map (
      I => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(0),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_lut_0_INV_0 : INV
    port map (
      I => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_lut_0_INV_0 : 
INV
    port map (
      I => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(0),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_almost_empty_i_or00001 : LUT4
    generic map(
      INIT => X"AEAA"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_comp_ae1,
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_comp_ae2,
      I2 => NlwRenamedSig_OI_empty,
      I3 => rd_en,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_almost_empty_i_or0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_almost_full_i_or00001 : LUT4
    generic map(
      INIT => X"AEAA"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_comp_af1,
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_comp_af2,
      I2 => NlwRenamedSig_OI_full,
      I3 => wr_en,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_almost_full_i_or0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG_i1 : LUT4
    generic map(
      INIT => X"FF20"
    )
    port map (
      I0 => rd_en,
      I1 => NlwRenamedSig_OI_empty,
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_comp2out,
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_comp1out,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_EMPTY_NONREG
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG_i1 : LUT4
    generic map(
      INIT => X"AEAA"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp_full1,
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp_full2,
      I2 => NlwRenamedSig_OI_full,
      I3 => wr_en,
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N324,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N224,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f5_19
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N524,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N424,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f5_20
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N913,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N813,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f5_22
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1313,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1213,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N713,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N615,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1113,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1013,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1513,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1413,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N322,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N222,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f5_26
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N522,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N422,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f5_27
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1713,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1613,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_8_f5_24
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N712,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N614,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N912,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N812,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f5_29
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1112,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1012,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1512,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1412,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1312,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1212,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1712,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1612,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_8_f5_31
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N320,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N220,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f5_33
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N711,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N613,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N911,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N811,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f5_36
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N520,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N420,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f5_34
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1111,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1011,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1511,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1411,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1711,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1611,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_8_f5_38
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N318,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N218,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f5_40
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1311,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1211,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N518,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N418,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f5_41
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N910,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N810,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f5_43
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1110,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1010,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1510,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1410,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N710,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N612,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1310,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1210,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1710,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1610,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_8_f5_45
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N516,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N416,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f5_48
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N98,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N88,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f5_50
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N316,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N216,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f5_47
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N118,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N108,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N158,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N148,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N78,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N611,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N178,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N168,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_8_f5_52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N314,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N214,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f5_54
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N138,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N128,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N76,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N610,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N514,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N414,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f5_55
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N116,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N106,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N136,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N126,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N96,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N86,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f5_57
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N156,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N146,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N176,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N166,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_8_f5_59
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N512,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N412,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f5_62
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N74,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N68,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N312,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N212,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f5_61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N94,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N84,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f5_64
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N114,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N104,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N154,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N144,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N174,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N164,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_8_f5_66
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N134,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N124,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N310,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N210,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f5_68
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N510,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N410,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f5_69
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N92,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N82,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f5_71
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N112,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N102,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N72,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N66,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f5_0 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N132,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N122,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f5_1 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N152,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N142,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_8_f5 : MUXF5
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N172,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N162,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_8_f5_73
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N567,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N569,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N424
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N575,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N577,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N224
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N571,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N573,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N324
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N563,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N565,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N524
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N559,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N561,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N615
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N547,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N549,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N913
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N555,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N557,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N713
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N551,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N553,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N813
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N543,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N545,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1013
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N539,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N541,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1113
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N527,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N529,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1413
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N535,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N537,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1213
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N531,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N533,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1313
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N523,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N525,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1513
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N519,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N521,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1613
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N507,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N509,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N322
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N515,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N517,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1713
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N511,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N513,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N222
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N495,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N497,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N614
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N503,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N505,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N422
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N499,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N501,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N522
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N483,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N485,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N912
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N491,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N493,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N712
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N487,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N489,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N812
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N479,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N481,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1012
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N475,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N477,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1112
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N463,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N465,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1412
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N471,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N473,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1212
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N467,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N469,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1312
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N459,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N461,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1512
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N455,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N457,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1612
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N443,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N445,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N320
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N451,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N453,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1712
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N447,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N449,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N220
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N439,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N441,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N420
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N435,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N437,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N520
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N423,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N425,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N811
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N431,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N433,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N613
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N427,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N429,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N711
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N411,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N413,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1111
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N419,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N421,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N911
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N415,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N417,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1011
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N399,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N401,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1411
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N407,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N409,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1211
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N403,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N405,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1311
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N395,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N397,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1511
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N391,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N393,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1611
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N379,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N381,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N318
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N387,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N389,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1711
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N383,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N385,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N218
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N375,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N377,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N418
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N371,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N373,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N518
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N359,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N361,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N810
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N367,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N369,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N612
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N363,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N365,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N710
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N355,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N357,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N910
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N351,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N353,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1010
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N339,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N341,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1310
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N347,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N349,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1110
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N343,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N345,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1210
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N335,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N337,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1410
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N331,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N333,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1510
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N319,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N321,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N216
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N327,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N329,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1610
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N323,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N325,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N1710
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N315,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N317,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N316
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N311,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N313,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N416
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N299,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N301,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N78
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N307,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N309,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N516
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N303,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N305,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N611
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N295,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N297,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N88
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N291,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N293,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N98
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N279,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N281,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N128
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N287,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N289,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N108
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N283,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N285,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N118
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N275,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N277,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N138
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N271,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N273,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N148
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N259,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N261,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N178
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N267,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N269,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N158
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N263,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N265,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N168
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N247,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N249,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N414
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N255,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N257,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N214
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N251,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N253,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N314
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N235,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N237,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N76
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N243,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N245,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N514
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N239,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N241,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N610
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N231,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N233,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N86
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N227,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N229,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N96
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N215,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N217,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N126
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N223,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N225,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N106
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N219,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N221,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N116
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N211,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N213,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N136
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N207,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N209,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N146
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N195,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N197,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N176
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N203,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N205,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N156
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N199,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N201,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N166
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N127,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N129,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N212
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N123,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N125,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N312
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N111,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N113,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N68
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N119,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N121,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N412
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N115,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N117,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N512
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N103,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N105,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N84
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N99,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N101,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N94
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N91,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N93,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N114
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N87,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N89,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N124
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N107,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N109,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N74
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N95,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N97,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N104
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N83,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N85,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N134
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N71,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N73,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N164
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N67,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N69,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N174
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N79,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N81,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N144
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N75,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N77,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N154
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N191,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N193,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N210
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_8 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N179,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N181,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N510
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_72 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N175,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N177,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N66
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N187,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N189,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N310
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_71 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N183,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N185,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N410
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_81 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N171,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N173,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N72
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_73 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N159,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N161,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N102
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_83 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N155,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N157,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N112
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_82 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N167,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N169,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N82
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_91 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N147,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N149,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N132
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_85 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N143,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N145,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N142
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_9 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N163,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N165,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N92
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_93 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N135,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N137,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N162
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_10 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N131,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N133,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N172
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_84 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N151,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N153,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N122
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_92 : LUT3
    generic map(
      INIT => X"E4"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N139,
      I2 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N141,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N152
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f7_3,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_3_f7_2,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(7)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f7_5,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_3_f7_4,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(6)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f7_7,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_3_f7_6,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(5)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f7_9,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_3_f7_8,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(4)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f7_11,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_3_f7_10,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(3)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f7_13,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_3_f7_12,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(2)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f7_15,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_3_f7_14,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(0)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_2_f8 : MUXF8
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f7_17,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_3_f7_16,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_varindex0000(1)
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f6_21,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f6_18,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_3_f7_2
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f6_23,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f7_3
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f6_28,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f6_25,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_3_f7_4
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f6_30,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f7_5
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f6_35,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f6_32,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_3_f7_6
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f6_37,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f7_7
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f6_42,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f6_39,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_3_f7_8
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f6_44,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f7_9
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f6_49,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f6_46,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_3_f7_10
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f6_51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f7_11
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f6_56,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f6_53,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_3_f7_12
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f6_58,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f7_13
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f6_63,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f6_60,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_3_f7_14
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f6_65,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f7_15
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_3_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f6_70,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f6_67,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_3_f7_16
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f7 : MUXF7
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f6_72,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f7_17
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f5_20,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f5_19,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_4_f6_18
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f5_22,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f6_21
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_8_f5_24,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX7_6_f6_23
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f5_27,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f5_26,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_4_f6_25
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f5_29,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f6_28
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_8_f5_31,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX6_6_f6_30
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f5_34,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f5_33,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_4_f6_32
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f5_36,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f6_35
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_8_f5_38,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX5_6_f6_37
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f5_41,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f5_40,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_4_f6_39
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f5_43,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f6_42
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_8_f5_45,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX4_6_f6_44
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f5_48,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f5_47,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_4_f6_46
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f5_50,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f6_49
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_8_f5_52,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX3_6_f6_51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f5_55,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f5_54,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_4_f6_53
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f5_57,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f6_56
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_8_f5_59,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX2_6_f6_58
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f5_62,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f5_61,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_4_f6_60
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f5_64,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f6_63
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_8_f5_66,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX_6_f6_65
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f5_69,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f5_68,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_4_f6_67
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f5_71,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f51,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f6_70
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f6_0 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f51,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_5_f61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f6 : MUXF6
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_8_f5_73,
      I1 => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_7_f52,
      S => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_LPM_MUX1_6_f6_72
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl31 : LUT4
    generic map(
      INIT => X"0800"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N232,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl30 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N222,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl29 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N220,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl28 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N218,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl27 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N224,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl26 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N222,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl25 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N220,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl24 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N218,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl23 : LUT4
    generic map(
      INIT => X"1000"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I1 => NlwRenamedSig_OI_full,
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N698,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl22 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I3 => BU2_U0_gen_as_fgas_N222,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl21 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I3 => BU2_U0_gen_as_fgas_N220,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl20 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I3 => BU2_U0_gen_as_fgas_N218,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl19 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N697,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl18 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N696,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl17 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N695,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl16 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N694,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl15 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N192,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl14 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N190,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl13 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N188,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl12 : LUT4
    generic map(
      INIT => X"0008"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => NlwRenamedSig_OI_full,
      I3 => BU2_U0_gen_as_fgas_N186,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl11 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N192,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl10 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N190,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl9 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N188,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl8 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N186,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl7 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I3 => BU2_U0_gen_as_fgas_N192,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl6 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I3 => BU2_U0_gen_as_fgas_N190,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl5 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I3 => BU2_U0_gen_as_fgas_N188,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl4 : LUT4
    generic map(
      INIT => X"0004"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I3 => BU2_U0_gen_as_fgas_N186,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl3 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N693,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl2 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N692,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl1 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N691,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_write_ctrl : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I3 => BU2_U0_gen_as_fgas_N690,
      O => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_74
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_82
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(8),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_90
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(8),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_98
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(8),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_106

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(8),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_114
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(8),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_122

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_75
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_76
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_77
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_78
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_79
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_80
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_81
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_83
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_84
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_85
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_86
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_87
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_88
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_89
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(7),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_91
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(6),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_92
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(5),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_93
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(4),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_94
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(3),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_95
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(2),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_96
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_97
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(7),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_99
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(6),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_100
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(5),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_101
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(4),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_102
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(3),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_103
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(2),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_104
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_105
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(7),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_107

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(6),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_108

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(5),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_109

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(4),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_110

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(3),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_111

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(2),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_112

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(1),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_113

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(7),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_115
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(6),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_116
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(5),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_117
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(4),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_118
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(3),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_119
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(2),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_120
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt : LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_121
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(7),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_123

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(6),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_124

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(5),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_125

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(4),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_126

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(3),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_127

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(2),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_128

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt : 
LUT1
    generic map(
      INIT => X"2"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(1),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_129

    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor000611 : LUT4
    generic map(
      INIT => X"9669"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(4),
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0006_bdd0
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor000611 : LUT4
    generic map(
      INIT => X"9669"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(2),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(4),
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0006_bdd0
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00071 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(0),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(1),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0006_bdd0,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0007
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00071 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(0),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(1),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0006_bdd0,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0007
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00062 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(1),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0006_bdd0,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0006
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00062 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(1),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0006_bdd0,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0006
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1_0_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1_0_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(0),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(1),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1_0_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1_0_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(0),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(1),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1_0_and00001 : LUT4
    generic map(
      INIT => X"8241"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      I2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      I3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1_0_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(0),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1_0_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1_0_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(0),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1_1_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(2),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(3),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1_1_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(2),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(3),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1_1_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(2),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(3),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1_1_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(2),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(3),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1_1_and00001 : LUT4
    generic map(
      INIT => X"8421"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      I2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      I3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1_1_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(2),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1_1_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(2),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(3),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1_1_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(2),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(3),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(4),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(4),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(5),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(4),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(4),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(5),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(4),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(4),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(5),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(4),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(4),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(5),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(4),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(5),
      I3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(4),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(4),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(5),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(4),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(4),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(5),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1_2_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(4),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(4),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(5),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(6),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(6),
      I2 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(7),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(6),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(6),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(7),
      I3 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(6),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(6),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(7),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(6),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(6),
      I2 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(7),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(7),
      I3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(6),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(6),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(7),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(6),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(6),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(7),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1_3_and00001 : LUT4
    generic map(
      INIT => X"9009"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(6),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(6),
      I2 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(7),
      I3 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(8),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(8),
      I1 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(8),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(8),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(8),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(8),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(8),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1_4_not00001 : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(8),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00051 : LUT4
    generic map(
      INIT => X"6996"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(2),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002,
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0005
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00051 : LUT4
    generic map(
      INIT => X"6996"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(2),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002,
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0005
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00041 : LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002,
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(4),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0004
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00041 : LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002,
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(4),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0004
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00032 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(4),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0003
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00032 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(4),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002,
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0003
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00021 : LUT4
    generic map(
      INIT => X"6996"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(6),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(5),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(8),
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00021 : LUT4
    generic map(
      INIT => X"6996"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(6),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(5),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(8),
      I3 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00011 : LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(8),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(7),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(6),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00011 : LUT3
    generic map(
      INIT => X"96"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(8),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(7),
      I2 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(6),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0000_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0001_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0002_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0003_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0003
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0004_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0004
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0005_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0005
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0006_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0006
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_Mxor_pntr_gc_xor0007_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0007
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0000_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0001_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0001
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0002_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0003_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0003
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0004_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0004
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0005_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0005
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0006_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0006
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_Mxor_pntr_gc_xor0007_Result1 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0007
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor00001 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(7),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0000
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor00001 : LUT2
    generic map(
      INIT => X"6"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(7),
      I1 => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0000
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
  BU2_U0_gen_as_fgas_normgen_olblk_gwa_wrackl_WR_ACK_and00001 : LUT2
    generic map(
      INIT => X"4"
    )
    port map (
      I0 => NlwRenamedSig_OI_full,
      I1 => wr_en,
      O => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_tmp_pntr_w_diff(0),
      Q => wr_data_count_136(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add0000_cy(1),
      Q => wr_data_count_136(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00002,
      Q => wr_data_count_136(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00004,
      Q => wr_data_count_136(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00006,
      Q => wr_data_count_136(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00008,
      Q => wr_data_count_136(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000010,
      Q => wr_data_count_136(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000012,
      Q => wr_data_count_136(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_wr_data_count_i_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000014,
      Q => wr_data_count_136(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_tmp_pntr_r_diff(0),
      Q => rd_data_count_135(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub0000_cy(1),
      Q => rd_data_count_135(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00002,
      Q => rd_data_count_135(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00004,
      Q => rd_data_count_135(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00006,
      Q => rd_data_count_135(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00008,
      Q => rd_data_count_135(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000010,
      Q => rd_data_count_135(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000012,
      Q => rd_data_count_135(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_rd_data_count_i_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000014,
      Q => rd_data_count_135(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_0_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N6
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_0_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N6,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_0_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N6,
      O => BU2_U0_gen_as_fgas_normgen_flblk_tmp_pntr_w_diff(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_1_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N7
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_1_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(0),
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N7,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_1_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(0),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N7,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add0000_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_2_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N8
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_2_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(1),
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N8,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_2_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(1),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N8,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_3_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N9
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_3_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(2),
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N9,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_3_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(2),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N9,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00004
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_4_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N10
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_4_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(3),
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N10,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_4_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(3),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N10,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00006
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_5_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N11
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_5_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(4),
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N11,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_5_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(4),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N11,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add00008
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_6_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(6),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N12
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_6_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(5),
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N12,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_6_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(5),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N12,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000010
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_7_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N13
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy_7_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(6),
      DI => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N13,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_7_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(6),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N13,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000012
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_lut_8_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      I1 => BU2_U0_gen_as_fgas_debug_rd_pntr_w(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N14
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_xor_8_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_w_diff_cy(7),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N14,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_wr_data_count_i_add000014
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_0_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N15
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_0_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N15,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_0_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N15,
      O => BU2_U0_gen_as_fgas_normgen_flblk_tmp_pntr_r_diff(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_1_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N16
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_1_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(0),
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N16,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_1_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(0),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N16,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub0000_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_2_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N17
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_2_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(1),
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N17,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_2_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(1),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N17,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00002
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_3_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N18
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_3_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(2),
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N18,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_3_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(2),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N18,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00004
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_4_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(4),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N19
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_4_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(3),
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(4),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N19,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_4_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(3),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N19,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00006
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_5_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(5),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N20
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_5_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(4),
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(5),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N20,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_5_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(4),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N20,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub00008
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_6_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(6),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N21
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_6_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(5),
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(6),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N21,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_6_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(5),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N21,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000010
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_7_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(7),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N22
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy_7_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(6),
      DI => BU2_U0_gen_as_fgas_debug_wr_pntr_r(7),
      S => BU2_U0_gen_as_fgas_normgen_flblk_N22,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_7_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(6),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N22,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000012
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_lut_8_Q : LUT2
    generic map(
      INIT => X"9"
    )
    port map (
      I0 => BU2_U0_gen_as_fgas_debug_wr_pntr_r(8),
      I1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      O => BU2_U0_gen_as_fgas_normgen_flblk_N23
    );
  BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_xor_8_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_Msub_tmp_pntr_r_diff_cy(7),
      LI => BU2_U0_gen_as_fgas_normgen_flblk_N23,
      O => BU2_U0_gen_as_fgas_normgen_flblk_Madd_alt_rd_data_count_i_addsub000014
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0007,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0006,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0005,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0004,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0003,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0002,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0001,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_xor0000,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(8)
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
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(4),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(5),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(6),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(7),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc(8),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(8)
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
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(4),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(5),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(6),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(7),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x(8),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0007,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0006,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0005,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0004,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0003,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0002,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0001,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_xor0000,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_PNTR_B_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_wrx_pntr_gc_x2(8),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_r(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0007,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0006,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0005,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0004,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0003,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0002,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0001,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_xor0000,
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(0),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(2),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(4),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(5),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(6),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(7),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc(8),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(0),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(1),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(2),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(3),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(4),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(5),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(6),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(7),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x(8),
      Q => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_0 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0007,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_1 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0006,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_2 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0005,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_3 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0004,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_4 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0003,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(4)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_5 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0002,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(5)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_6 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0001,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(6)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_7 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_xor0000,
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(7)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_PNTR_B_8 : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_flblk_clkmod_cx_rdx_pntr_gc_x2(8),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_w(8)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_almost_full_i : FDPE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_FULL_inv,
      D => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_almost_full_i_or0000,
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      Q => almost_full
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_comp_af2
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf2_carrynet(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_comp_af1
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aflogic_caf1_carrynet(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_almost_empty_i : FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_EMPTY_inv,
      D => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_almost_empty_i_or0000,
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      Q => almost_empty
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_comp_ae2
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae2_carrynet(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_comp_ae1
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_aelogic_cae1_carrynet(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_RAM_FULL_i : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      D => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_FULL_NONREG,
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      Q => NlwRenamedSig_OI_full
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp_full2
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp2_carrynet(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp_full1
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_flogic_comp1_carrynet(0)
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
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_comp2out
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c2_carrynet(0)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_eqcase_big_mlp_4_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(4),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_comp1out
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_eqcase_big_mlp_3_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(3),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(3)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_eqcase_big_mlp_2_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(2),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(2)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_eqcase_big_mlp_1_mid_mcy : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(1),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(1)
    );
  BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_eqcase_big_mlp_0_fst_mfirst : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_N1,
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_v1(0),
      O => BU2_U0_gen_as_fgas_normgen_flblk_thrmod_elogic_c1_carrynet(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_74,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_7_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_75,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_75,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_6_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_76,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_76,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_5_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_77,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_77,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_4_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_78,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_78,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_79,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_79,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_80,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_80,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_81,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_81,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_0_Q : MUXCY
    port map (
      CI => BU2_overflow,
      DI => BU2_U0_gen_as_fgas_N1,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_8 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4),
      Q => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(4)
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
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_82,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_7_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_83,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_83,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_6_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_84,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_84,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_5_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_85,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_85,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_4_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_86,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_86,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_87,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_87,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_88,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_88,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      LI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_89,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      DI => BU2_overflow,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_89,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_0_Q : MUXCY
    port map (
      CI => BU2_overflow,
      DI => BU2_U0_gen_as_fgas_N1,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_8 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      Q => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_90,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_7_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_91,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_91,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_6_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_92,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_92,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_5_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_93,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_93,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_4_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_94,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_94,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_95,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_95,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_96,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_96,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_97,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_97,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_0_Q : MUXCY
    port map (
      CI => BU2_overflow,
      DI => BU2_U0_gen_as_fgas_N1,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_8 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6),
      Q => BU2_U0_gen_as_fgas_debug_rd_pntr_plus1_r(6)
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
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_98,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_7_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_99,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_99,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_6_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_100,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_100,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_5_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_101,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_101,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_4_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_102,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_102,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_103,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_103,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_104,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_104,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_105,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_105,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_0_Q : MUXCY
    port map (
      CI => BU2_overflow,
      DI => BU2_U0_gen_as_fgas_N1,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_8 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus1_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus1_w(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_106
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_7_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_107
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_107
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_6_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_108
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_108
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_5_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_109
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_109
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_4_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_110
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_110
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_111
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_111
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_112
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_112
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_113
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_113
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_0_Q : 
MUXCY
    port map (
      CI => BU2_overflow,
      DI => BU2_U0_gen_as_fgas_N1,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_8 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_7 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_6 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : 
FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_RD_EN,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_rd_cntr_plus2_bld_rd_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_114,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_7_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_115,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_115,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_6_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_116,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_116,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_5_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_117,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_117,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_4_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_118,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_118,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_119,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_119,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_120,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_120,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_Q : XORCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_121,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_Q : MUXCY
    port map (
      CI => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0),
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_121,
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_0_Q : MUXCY
    port map (
      CI => BU2_overflow,
      DI => BU2_U0_gen_as_fgas_N1,
      S => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      O => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_8 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_7 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_6 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6),
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus2_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
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
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      Q => BU2_U0_gen_as_fgas_debug_wr_pntr_plus2_w(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_8_rt_122
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_7_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_123
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_7_rt_123
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(7)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_6_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_124
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_6_rt_124
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(6)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_5_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_125
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_5_rt_125
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(5)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_4_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_126
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_4_rt_126
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(4)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_3_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_127
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_3_rt_127
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(3)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_2_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_128
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_2_rt_128
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(2)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_xor_1_Q : 
XORCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
,
      LI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_129
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_Q : 
MUXCY
    port map (
      CI => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)
,
      DI => BU2_overflow,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_1_rt_129
,
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(1)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy_0_Q : 
MUXCY
    port map (
      CI => BU2_overflow,
      DI => BU2_U0_gen_as_fgas_N1,
      S => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      O => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Mcount_count_cy(0)

    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_8 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(8),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(8)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_7 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(7),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(7)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_5 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(5),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(5)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_4 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(4),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(4)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_6 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(6),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(6)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_3 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(3),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(3)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_2 : 
FDCE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(2),
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(2)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_0 : 
FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(0),
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(0)
    );
  BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count_1 : 
FDPE
    generic map(
      INIT => '1'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      D => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_Result(1),
      PRE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      Q => 
BU2_U0_gen_as_fgas_normgen_cntblk_gen_cntr_gen_wr_cntr_plus3_bld_wr_cntr_plus3_gen_bin_cnt_top_bin_cnt_top_gen_bsc_bin_cnt_bld_bin_cnt_count(1)
    );
  BU2_U0_gen_as_fgas_normgen_olblk_gwa_wrackl_WR_ACK : FDC
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CLR => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_U0_gen_as_fgas_DEBUG_RAM_WR_EN,
      Q => wr_ack
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
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem255 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem255_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N577
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem254 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem254_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N575
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem253 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem253_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N573
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem252 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem252_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N571
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem251 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem251_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N569
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem250 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem250_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N567
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem249 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem249_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N565
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem248 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem248_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N563
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem247 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem247_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N561
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem246 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem246_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N559
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem245 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem245_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N557
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem244 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem244_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N555
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem243 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem243_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N553
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem242 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem242_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N551
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem241 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem241_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N549
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem240 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem240_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N547
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem239 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem239_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N545
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem238 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem238_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N543
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem237 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem237_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N541
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem236 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem236_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N539
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem235 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem235_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N537
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem234 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem234_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N535
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem232 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem232_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N531
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem231 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem231_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N529
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem233 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem233_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N533
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem230 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem230_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N527
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem229 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem229_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N525
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem228 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem228_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N523
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem227 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem227_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N521
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem226 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem226_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N519
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem225 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem225_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N517
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem224 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(7),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem224_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N515
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem223 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem223_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N513
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem222 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem222_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N511
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem221 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem221_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N509
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem220 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem220_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N507
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem219 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem219_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N505
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem218 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem218_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N503
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem217 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem217_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N501
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem216 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem216_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N499
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem215 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem215_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N497
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem214 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem214_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N495
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem213 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem213_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N493
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem212 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem212_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N491
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem211 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem211_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N489
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem210 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem210_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N487
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem209 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem209_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N485
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem208 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem208_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N483
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem207 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem207_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N481
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem206 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem206_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N479
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem205 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem205_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N477
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem204 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem204_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N475
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem203 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem203_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N473
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem202 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem202_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N471
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem201 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem201_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N469
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem199 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem199_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N465
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem198 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem198_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N463
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem200 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem200_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N467
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem197 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem197_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N461
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem196 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem196_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N459
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem195 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem195_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N457
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem194 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem194_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N455
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem193 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem193_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N453
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem192 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(6),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem192_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N451
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem191 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem191_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N449
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem190 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem190_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N447
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem189 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem189_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N445
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem188 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem188_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N443
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem187 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem187_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N441
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem186 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem186_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N439
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem185 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem185_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N437
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem184 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem184_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N435
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem183 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem183_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N433
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem182 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem182_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N431
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem181 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem181_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N429
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem180 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem180_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N427
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem179 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem179_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N425
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem178 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem178_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N423
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem177 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem177_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N421
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem176 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem176_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N419
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem175 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem175_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N417
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem174 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem174_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N415
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem173 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem173_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N413
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem172 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem172_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N411
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem171 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem171_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N409
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem170 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem170_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N407
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem169 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem169_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N405
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem168 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem168_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N403
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem166 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem166_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N399
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem165 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem165_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N397
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem167 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem167_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N401
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem164 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem164_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N395
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem163 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem163_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N393
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem162 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem162_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N391
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem161 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem161_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N389
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem160 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(5),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem160_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N387
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem159 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem159_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N385
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem158 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem158_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N383
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem157 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem157_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N381
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem156 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem156_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N379
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem155 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem155_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N377
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem154 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem154_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N375
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem153 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem153_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N373
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem152 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem152_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N371
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem151 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem151_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N369
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem150 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem150_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N367
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem149 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem149_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N365
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem148 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem148_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N363
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem147 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem147_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N361
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem146 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem146_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N359
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem145 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem145_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N357
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem144 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem144_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N355
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem143 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem143_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N353
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem142 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem142_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N351
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem141 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem141_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N349
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem140 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem140_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N347
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem139 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem139_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N345
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem138 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem138_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N343
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem137 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem137_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N341
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem136 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem136_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N339
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem135 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem135_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N337
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem133 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem133_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N333
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem132 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem132_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N331
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem134 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem134_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N335
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem131 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem131_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N329
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem130 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem130_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N327
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem129 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem129_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N325
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem128 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(4),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem128_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N323
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem127 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem127_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N321
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem126 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem126_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N319
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem125 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem125_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N317
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem124 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem124_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N315
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem123 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem123_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N313
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem122 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem122_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N311
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem121 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem121_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N309
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem120 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem120_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N307
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem119 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem119_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N305
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem118 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem118_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N303
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem117 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem117_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N301
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem116 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem116_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N299
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem115 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem115_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N297
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem114 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem114_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N295
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem113 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem113_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N293
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem112 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem112_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N291
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem111 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem111_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N289
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem110 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem110_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N287
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem109 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem109_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N285
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem108 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem108_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N283
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem107 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem107_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N281
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem106 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem106_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N279
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem105 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem105_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N277
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem104 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem104_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N275
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem103 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem103_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N273
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem102 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem102_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N271
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem100 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem100_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N267
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem99 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem99_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N265
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem101 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem101_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N269
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem98 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem98_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N263
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem97 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem97_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N261
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem96 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(3),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem96_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N259
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem95 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem95_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N257
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem94 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem94_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N255
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem93 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem93_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N253
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem92 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem92_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N251
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem91 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem91_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N249
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem90 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem90_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N247
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem89 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem89_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N245
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem88 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem88_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N243
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem87 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem87_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N241
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem86 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem86_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N239
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem85 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem85_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N237
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem84 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem84_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N235
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem83 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem83_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N233
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem82 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem82_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N231
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem81 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem81_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N229
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem80 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem80_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N227
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem79 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem79_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N225
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem78 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem78_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N223
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem77 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem77_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N221
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem76 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem76_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N219
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem75 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem75_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N217
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem74 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem74_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N215
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem73 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem73_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N213
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem72 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem72_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N211
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem71 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem71_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N209
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem70 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem70_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N207
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem69 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem69_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N205
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem67 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem67_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N201
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem66 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem66_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N199
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem68 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem68_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N203
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem65 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem65_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N197
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem64 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(2),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem64_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N195
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem63 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem63_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N193
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem62 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem62_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N191
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem61 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem61_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N189
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem60 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem60_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N187
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem59 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem59_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N185
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem58 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem58_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N183
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem57 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem57_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N181
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem56 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem56_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N179
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem55 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem55_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N177
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem54 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem54_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N175
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem53 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem53_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N173
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem52 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem52_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N171
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem51 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem51_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N169
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem50 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem50_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N167
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem49 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem49_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N165
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem48 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem48_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N163
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem47 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem47_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N161
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem46 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem46_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N159
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem45 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem45_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N157
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem44 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem44_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N155
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem43 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem43_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N153
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem42 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem42_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N151
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem41 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem41_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N149
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem40 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem40_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N147
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem39 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem39_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N145
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem38 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem38_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N143
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem37 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem37_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N141
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem36 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem36_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N139
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem34 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem34_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N135
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem33 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem33_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N133
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem35 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem35_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N137
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem32 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(1),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem32_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N131
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem31 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N65,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem31_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N129
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem30 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N64,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem30_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N127
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem29 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N63,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem29_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N125
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem28 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N62,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem28_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N123
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem27 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N61,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem27_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N121
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem26 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N60,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem26_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N119
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem25 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N59,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem25_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N117
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem24 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N58,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem24_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N115
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem23 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N57,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem23_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N113
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem22 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N56,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem22_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N111
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem21 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N55,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem21_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N109
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem20 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N54,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem20_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N107
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem19 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N53,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem19_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N105
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem17 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N51,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem17_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N101
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem16 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N50,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem16_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N99
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem18 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N52,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem18_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N103
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem15 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N49,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem15_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N97
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem14 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N48,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem14_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N95
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem13 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N47,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem13_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N93
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem12 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N46,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem12_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N91
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem11 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N45,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem11_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N89
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem10 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N44,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem10_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N87
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem9 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N43,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem9_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N85
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem8 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N42,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem8_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N83
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem7 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N41,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem7_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N81
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem6 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N40,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem6_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N79
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem5 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N39,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem5_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N77
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem4 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N38,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem4_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N75
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem3 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N37,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem3_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N73
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem2 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N36,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem2_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N71
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N34,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N67
    );
  BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem1 : RAM16X1D
    port map (
      A0 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(0),
      A1 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(1),
      A2 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(2),
      A3 => BU2_U0_gen_as_fgas_DEBUG_WR_PNTR(3),
      D => din_133(0),
      DPRA0 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(0),
      DPRA1 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(1),
      DPRA2 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(2),
      DPRA3 => BU2_U0_gen_as_fgas_DEBUG_RD_PNTR(3),
      WCLK => wr_clk,
      WE => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N35,
      SPO => NLW_BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_inst_Mram_mem1_SPO_UNCONNECTED,
      DPO => BU2_U0_gen_as_fgas_normgen_memblk_mem0_distinst_N69
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
      Q => dout_134(7)
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
      Q => dout_134(6)
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
      Q => dout_134(5)
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
      Q => dout_134(4)
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
      Q => dout_134(3)
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
      Q => dout_134(2)
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
      Q => dout_134(1)
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
      Q => dout_134(0)
    );
  BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg : FDPE
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      CE => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb,
      D => BU2_overflow,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg_132
    );
  BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      D => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg_130,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131
    );
  BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg : FDPE
    generic map(
      INIT => '0'
    )
    port map (
      C => wr_clk,
      CE => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_fb_131,
      D => BU2_overflow,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_wr_rst_reg_130
    );
  BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_int_0 : FDP
    generic map(
      INIT => '0'
    )
    port map (
      C => rd_clk,
      D => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_reg_132,
      PRE => rst,
      Q => BU2_U0_gen_as_fgas_normgen_inblk_rd_rst_fb
    );
  BU2_U0_gen_as_fgas_XST_VCC : VCC
    port map (
      P => BU2_U0_gen_as_fgas_N1
    );
  BU2_U0_gen_as_fgas_XST_GND : GND
    port map (
      G => BU2_overflow
    );

end STRUCTURE;

-- synopsys translate_on
