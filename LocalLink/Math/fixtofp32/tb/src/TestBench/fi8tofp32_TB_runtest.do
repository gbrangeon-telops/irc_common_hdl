SetActiveLib -work							 
#acom "D:\Telops\Common_HDL\LocalLink\Math\fixtofp32\src\fixtofp32.vhd" 
comp -include "$dsn\src\fixtofp32_8s_TB.bde" 
comp -include "$dsn\src\TestBench\fi8tofp32_TB.vhd" 
asim TESTBENCH_FOR_fi8tofp32 
#wave 
#wave -noreg CLK
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fi8tofp32_TB_tim_cfg.vhd" 
# asim TIMING_FOR_fi8tofp32 

open -wave Waveform1.awf

run 20 us