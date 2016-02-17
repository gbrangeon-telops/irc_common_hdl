SetActiveLib -work
acom "D:\Telops\Common_HDL\LocalLink\Math\fp32tofix\src\fp32tofix.vhd"
comp -include "$dsn\src\fp32tofix_single_tb.bde" 
comp -include "$dsn\src\TestBench\fp32tofix_single_tb_TB.vhd" 
asim -ses TESTBENCH_FOR_fp32tofix_single_tb 
#wave 
#wave -noreg CLK
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fp32tofix_single_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_fp32tofix_single_tb 


open -wave "$dsn/src/Waveform1.awf"

run 1 us