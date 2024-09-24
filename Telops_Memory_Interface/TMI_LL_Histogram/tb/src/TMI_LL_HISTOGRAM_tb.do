setactivelib work	  

asim -ses +access +r ll_tmi_histogram_1024_tb 

onerror { resume }
transcript off

do "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/tb/src/ll_tmi_histogram_1024_tb_stim.do"
do "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/tb/src/ll_tmi_histogram_1024_tb_wave.do"

run 1.5 ms
