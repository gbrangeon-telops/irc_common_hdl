SetActiveLib -work

#acom "D:\Telops\Common_HDL\LocalLink\Math\fixtofp32\src\fixtofp32.vhd"
comp -include "$dsn\src\IRCDEV_setup_TB.bde" 
comp -include "$dsn\src\TestBench\ircdev_setup_tb_TB.vhd" 
asim TESTBENCH_FOR_ircdev_setup_tb 
#wave 
#wave -noreg CLK
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\ircdev_setup_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ircdev_setup_tb 

open -wave Waveform2.awf

run 100 us