SetActiveLib -work
comp -include "$dsn\src\sqrt_float32_tb.bde" 
comp -include "$dsn\src\TestBench\fp32_sqrt_tb_TB.vhd" 
asim TESTBENCH_FOR_fp32_sqrt_tb 
#wave 
#wave -noreg CLK
#wave -noreg RANDOM
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fp32_sqrt_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_fp32_sqrt_tb 

open -wave "$dsn/src/Waveform1.awf"

run 10 us
