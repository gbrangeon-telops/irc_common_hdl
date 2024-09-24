# script added by OBO to automatically launch testbench simulation
setactivelib work

do $COMMON_HDL/DDR_Ctrl/Active-HDL/IFTIRS_dataproc/compile.do

asim -ses ddr_tb_cfg_rtl 
open -wave $COMMON_HDL/DDR_Ctrl/Active-HDL/IFTIRS_dataproc/src/Testbench/RTL_debug.awf
run 250 us

