setactivelib work

setenv FIR180 "D:/Telops/FIR-00180-IRC"

# Wishbone interconnect
acom  "$FIR180/src/Wishbone/wb_intercon.vhd"

do "$dsn/../build/ll_tmi_bridge_Compile.do"

# SystemC testbench                                      
adel uct_model
cd $dsn/src\
buildc ll_tmi_bridge_tb.dlm	

# SystemC to UCT wrapper
acom  "$FIR180/src/TestBench/UCT.vhd"

acom "$dsn/../../tmi_bram.vhd"

# Testbench Top Level
acom  "$dsn/src/ll_tmi_bridge_tb.bde" 

# Testbench with stimuli
acom  "$dsn/src/ll_tmi_bridge_tb_tb.vhd"
                          
# Lauch sim                         
asim TESTBENCH_FOR_ll_tmi_bridge_tb 


#asim TESTBENCH_FOR_ll_tmi_read 

#open -wave "$dsn/src/ll_tmi_read_TB.wfm"
#open -wave "$dsn/src/ll_tmi_read.wfm"

do "$COMMON_HDL/Telops_Memory_Interface/LL_TMI_bridge/tb/src/tmi_bridge_wave.do"

run



endsim
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn/src/ll_tmi_read_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_tmi_read 
