setactivelib work
comp -include "$dsn/compile/TMI_LL_LUT_tb.vhd" 
comp -include "$dsn/src/TestBench/tmi_ll_lut_tb_TB.vhd" 
asim TESTBENCH_FOR_tmi_ll_lut_tb 
wave 
wave -noreg ARESET
wave -noreg CLK_CTRL
wave -noreg CLK_DATA
wave -noreg STALL
wave -noreg FILENAME_IN
wave -noreg FILENAME_OUT
wave -noreg ERROR
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn/src/TestBench/tmi_ll_lut_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_tmi_ll_lut_tb 
