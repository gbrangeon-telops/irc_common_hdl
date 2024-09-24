setactivelib work																						
comp -include "$COMMON_HDL/LocalLink/Math/fixtofp32/build/fixtofp32_16u/vhm/fixtofp32_16u.vhm" 
comp -include "$COMMON_HDL/LocalLink/Math/fixtofp32/build/fixtofp32_17s/vhm/fixtofp32_17s.vhm" 
comp -include "$COMMON_HDL/LocalLink/Math/fixtofp32/build/fixtofp32_12u/vhm/fixtofp32_12u.vhm" 
comp -include "$COMMON_HDL/LocalLink/Math/fixtofp32/build/fixtofp32_12s/vhm/fixtofp32_12s.vhm"
comp -include "$COMMON_HDL/LocalLink/Math/fixtofp32/build/fixtofp32_9s/vhm/fixtofp32_9s.vhm" 
comp -include "$COMMON_HDL/LocalLink/Math/fixtofp32/build/fixtofp32_11s/vhm/fixtofp32_11s.vhm" 
comp -include "$dsn/src/IRCDEV_setup_PostSynth_TB.bde" 
comp -include "$dsn/src/TestBench/ircdev_setup_postsynth_tb_TB.vhd" 
asim TESTBENCH_FOR_ircdev_setup_postsynth_tb 
#wave 
#wave -noreg CLK
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn/src/TestBench/ircdev_setup_postsynth_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ircdev_setup_postsynth_tb 

open -wave Waveform3.awf

run 100 us
