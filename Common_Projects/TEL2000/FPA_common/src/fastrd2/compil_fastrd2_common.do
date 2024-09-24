#savealltabs
#adel -all
#setactivelib work
#clearlibrary 	
 
# sources fastrd2 common 
acom -nowarn DAGGEN_0523 -incr \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_define.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_raw_area_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_user_area_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_clk_area_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_area_flow_gen_core.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_area_flow_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_misc_flags_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_imm_flags_tool.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_area_mem_ctler.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd2/fastrd2_area_info_mem.bde