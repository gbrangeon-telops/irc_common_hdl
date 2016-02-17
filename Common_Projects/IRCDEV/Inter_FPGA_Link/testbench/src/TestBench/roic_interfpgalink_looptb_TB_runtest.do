SetActiveLib -work
																					  
# LL TX Arbiter and components
comp -include "d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\coregen\ch_fifo_w10d16.vhd" 
comp -include "d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\Ch_RX_FIFO.vhd" 
comp -include "d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\LL_TX_arbiter.vhd" 
# Serial TX
comp -include "D:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\SerialLink_TX.vhd"
comp -include "$dsn\compile\syncseriallink_tx.vhd"
# Serial RX
comp -include "D:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\SerialLink_RX.vhd"
comp -include "$dsn\compile\syncseriallink_rx.vhd"
# LL RX Arbiter and components
comp -include "D:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\LL_RX_arbiter.vhd"
#
comp -include "$dsn\compile\ROIC_InterFpgaLink_LoopTB.vhd" 
comp -include "$dsn\src\TestBench\roic_interfpgalink_looptb_TB.vhd" 
asim TESTBENCH_FOR_roic_interfpgalink_looptb 

open -wave $dsn\src\ROIC_InterFpgaLink_LoopTB.awf
run 10.4 us

#wave 
#wave -noreg CLK
#wave -noreg CLK_20MHz
#wave -noreg RST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\roic_interfpgalink_looptb_TB_tim_cfg.vhd" 
# asim TIMING_FOR_roic_interfpgalink_looptb 
