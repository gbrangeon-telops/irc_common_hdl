setactivelib work
endsim
acom "$COMMON_HDL/LocalLink/LL_Merge8.vhd"
comp -include "$DSN/src/LL_Merge8/LL_Merge8_TB.bde" 
comp -include "$DSN/src/LL_Merge8/ll_merge8_tb_TB.vhd" 
asim TESTBENCH_FOR_ll_merge8_tb 
open -wave "$DSN/src/LL_Merge8/waveform_1.awf"
#wave -noreg CLK
#wave -noreg RANDOM_IN
#wave -noreg RANDOM_OUT
#wave -noreg RST
#wave -noreg FILE_IN1
#wave -noreg FILE_IN2
#wave -noreg FILE_OUT1      
#wave -noreg UUT/DUT
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN/src/TestBench/ll_merge8_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_merge8_tb     
run 1us
