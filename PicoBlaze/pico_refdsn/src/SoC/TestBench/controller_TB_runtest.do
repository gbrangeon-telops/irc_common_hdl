setactivelib work
comp -include "$DSN/compile/controller.vhd" 
comp -include "$DSN/src/controller/TestBench/controller_TB.vhd" 
asim TESTBENCH_FOR_controller 
wave 
wave -noreg CLK
wave -noreg RST

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN/src/controller/TestBench/controller_TB_tim_cfg.vhd" 
# asim TIMING_FOR_controller 
