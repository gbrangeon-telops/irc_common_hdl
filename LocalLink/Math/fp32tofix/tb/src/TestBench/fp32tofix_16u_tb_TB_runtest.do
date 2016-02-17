SetActiveLib -work
acom "D:\Telops\Common_HDL\LocalLink\Math\fp32tofix\build\fp32tofix_16u\vhm\fp32tofix_16u.vhm"
comp -include "$dsn\src\fp32tofix_16u_TB.bde" 
comp -include "$dsn\src\TestBench\fp32tofix_16u_tb_TB.vhd" 
asim TESTBENCH_FOR_fp32tofix_16u_tb 
#wave 
#wave -noreg CLK
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fp32tofix_16u_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_fp32tofix_16u_tb 

open -wave "$dsn/src/Waveform2.awf"

run 8 us
