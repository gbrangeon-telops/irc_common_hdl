#savealltabs
#adel -all
#setactivelib work
#clearlibrary 	

 
# sources fastrd common 
acom -nowarn DAGGEN_0523 -incr \
 $COMMON_HDL/SPI/ads1118_driver.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_clk_mem_ctrler.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_raw_area_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_stretching_area_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_user_area_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_waste_area_gen.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_wdow_info_rate_core.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_wdow_mem_input_ctler.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_wdow_mem_output_ctler.vhd \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_clks_memory.bde \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_wdow_info_rate_ctrler.bde \
 $COMMON_HDL/Common_Projects/TEL2000/FPA_common/src/fastrd_wdow_mem.bde 