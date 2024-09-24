setactivelib work
comp -include "$COMMON_HDL/Telops_Memory_Interface/LL_TMI_bridge/src/LL_TMI_read.vhd" 
comp -include "$dsn/src/ll_tmi_read_TB.vhd" 
asim TESTBENCH_FOR_ll_tmi_read 

open -wave "$dsn/src/ll_tmi_read_TB.wfm"
open -wave "$dsn/src/ll_tmi_read.wfm"

run

open -txt "$dsn/src/data_out.raw"

endsim
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn/src/ll_tmi_read_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_tmi_read 
