setactivelib work
comp -include "$COMMON_HDL/Common_Projects/IRCDEV/Inter_FPGA_Link/coregen/ch_fifo_w10d16.vhd" 
comp -include "$COMMON_HDL/Common_Projects/IRCDEV/Inter_FPGA_Link/src/Ch_RX_FIFO.vhd" 
comp -include "$COMMON_HDL/LocalLink/LL_RandomMiso8.vhd" 
comp -include "$COMMON_HDL/Common_Projects/IRCDEV/Inter_FPGA_Link/src/LL_TX_arbiter.vhd" 
comp -include "$COMMON_HDL/Matlab/LL_file_output_8.vhd" 
comp -include "$dsn/src/LL_TX_arbiter_TB2.bde" 
comp -include "$dsn/src/TestBench/ll_tx_arbiter_tb2_TB.vhd" 
asim TESTBENCH_FOR_ll_tx_arbiter_tb2 
open -wave $dsn/src/LL_TX_arb_TB2.awf 

run 2 us

#wave 
#wave -noreg CLK
#wave -noreg RANDOM
#wave -noreg RST
#wave -noreg CH1_RX_MOSI
#wave -noreg CH2_RX_MOSI
#wave -noreg CH3_RX_MOSI
#wave -noreg Unused_RX_MOSI
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn/src/TestBench/ll_tx_arbiter_tb2_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_tx_arbiter_tb2 
