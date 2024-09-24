# script added by OBO to automatically launch testbench simulation
setactivelib work
#comp -include "$COMMON_HDL/DDR_Ctrl/src/TestBench/ddr_tb.vhd"
#comp -include "$COMMON_HDL/DDR_Ctrl/src/TestBench/ddr_tb_cfg_simple.vhd" 

do $COMMON_HDL/DDR_Ctrl/Active-HDL/IFTIRS_dataproc/compile.do

# Now use simple model instead
do $COMMON_HDL/DDR_Ctrl/src/User-Interface/compile_ddr_top_simple.do

asim ddr_tb_cfg_simple
wave
