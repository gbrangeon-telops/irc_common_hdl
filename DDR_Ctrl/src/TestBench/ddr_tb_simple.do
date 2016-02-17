# script added by OBO to automatically launch testbench simulation
SetActiveLib -work
#comp -include "D:\telops\Common_HDL\DDR_Ctrl\src\TestBench\ddr_tb.vhd"
#comp -include "D:\telops\Common_HDL\DDR_Ctrl\src\TestBench\ddr_tb_cfg_simple.vhd" 

do D:\Telops\Common_HDL\DDR_Ctrl\Active-HDL\IFTIRS_dataproc\compile.do

# Now use simple model instead
do D:\telops\Common_HDL\DDR_Ctrl\src\User-Interface\compile_ddr_top_simple.do

asim ddr_tb_cfg_simple
wave
