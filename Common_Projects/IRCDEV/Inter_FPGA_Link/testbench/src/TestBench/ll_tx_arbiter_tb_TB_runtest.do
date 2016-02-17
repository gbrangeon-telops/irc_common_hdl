SetActiveLib -work
comp -include "d:\Telops\Common_HDL\LocalLink\LL_RandomMiso8.vhd" 								  
comp -include "d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\coregen\ch_fifo_w10d16.vhd" 
comp -include "d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\Ch_RX_FIFO.vhd" 
comp -include "d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\LL_TX_arbiter.vhd" 
comp -include "d:\Telops\Common_HDL\Matlab\LL_file_output_8.vhd" 
comp -include "d:\Telops\Common_HDL\Matlab\LL_file_input_8.vhd" 
comp -include "$dsn\src\LL_TX_arbiter_TB.bde" 
comp -include "$dsn\src\TestBench\ll_tx_arbiter_tb_TB.vhd" 
asim -ses TESTBENCH_FOR_ll_tx_arbiter_tb   

open -wave $dsn\src\LL_TX_arb_TB_2.awf 

run 10 us

#wave 
#wave -noreg CLK
#wave -noreg RANDOM
#wave -noreg RST
#wave -noreg Unused_RX_MOSI
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\ll_tx_arbiter_tb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_tx_arbiter_tb 
