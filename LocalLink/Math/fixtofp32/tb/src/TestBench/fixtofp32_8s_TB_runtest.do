SetActiveLib -work
comp -include "d:\Telops\Common_HDL\LocalLink\Math\fixtofp32\src\fixtofp32.vhd" 
comp -include "$dsn\src\fixtofp32_8s.vhd" 
comp -include "$dsn\src\TestBench\fixtofp32_8s_TB.vhd" 
asim TESTBENCH_FOR_fixtofp32_8s 
wave 
wave -noreg RX_MOSI
wave -noreg RX_MISO
wave -noreg TX_MOSI
wave -noreg TX_MISO
wave -noreg ARESET
wave -noreg CLK
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fixtofp32_8s_TB_tim_cfg.vhd" 
# asim TIMING_FOR_fixtofp32_8s 
