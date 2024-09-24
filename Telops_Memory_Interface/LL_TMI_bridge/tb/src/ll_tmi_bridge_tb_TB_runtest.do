setactivelib work
comp -include "$dsn/compile/LL_TMI_Bridge_TB.vhd" 
comp -include "$dsn/src/TestBench/ll_tmi_bridge_tb_TB.vhd" 
asim TESTBENCH_FOR_ll_tmi_bridge_tb 





# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn/src/TestBench/ll_tmi_bridge_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_tmi_bridge_tb 
