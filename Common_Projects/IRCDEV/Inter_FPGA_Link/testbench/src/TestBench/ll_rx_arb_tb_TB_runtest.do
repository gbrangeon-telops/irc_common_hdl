setactivelib work
comp -include "$COMMON_HDL/Common_Projects/IRCDEV/Inter_FPGA_Link/src/LL_RX_arbiter.vhd"
comp -include "$dsn/src/LL_TX_arbiter_TB.bde"
comp -include "$dsn/compile/LL_RX_arb_TB.vhd" 
comp -include "$dsn/src/TestBench/ll_rx_arb_tb_TB.vhd" 
asim TESTBENCH_FOR_ll_rx_arb_tb 

open -wave $dsn/src/LL_RX_arb_TB.awf 
run 2 us

#wave 
#wave -noreg CLK
#wave -noreg RANDOM
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn/src/TestBench/ll_rx_arb_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_rx_arb_tb 
