setactivelib work

#setenv LIBPATH "$DSN/.."
setenv LIBPATH "$COMMON_HDL"

comp -include "$LIBPATH/RS232/LL_Uart_IRCDEV.bde" 
comp -include "$LIBPATH/RS232/Testbench/ll_uart_IRCDEV_TB.vhd" 
asim TESTBENCH_FOR_ll_uart_IRCDEV 
open -wave "$LIBPATH/RS232/Testbench/ll_uart_IRCDEV.awf"

# Simulation should stop automatically
run
endsim

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN/src/TestBench/ll_uart_bridge_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_uart_bridge 
