setactivelib work
#comp -include "$DSN/src/Aurora_TB/Aurora_TB_v4_only.bde" 
comp -include "$DSN/src/Aurora_TB/Aurora_TB.bde" 
#comp -include "$DSN/src/Aurora_TB/Aurora_TB_1Gb.bde" 
comp -include "$DSN/src/Aurora_TB/aurora_tb_TB.vhd" 
open -wave $DSN/src/Aurora_TB/Aurora_TB.awf
#open -wave $DSN/src/Aurora_TB/core.awf
asim -ses -advdataflow TESTBENCH_FOR_aurora_tb 
run 20 us	

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN/src/TestBench/aurora_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_aurora_tb 
