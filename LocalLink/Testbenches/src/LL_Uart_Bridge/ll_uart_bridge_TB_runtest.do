SetActiveLib -work

#setenv LIBPATH "$DSN\.."
setenv LIBPATH "D:\Telops\Common_HDL"

comp -include "$LIBPATH\LocalLink\LL_Uart_Bridge.vhd" 
comp -include "$LIBPATH\LocalLink\Testbenches\src\LL_Uart_Bridge\ll_uart_bridge_TB.vhd" 
asim TESTBENCH_FOR_ll_uart_bridge 
open -wave "$LIBPATH\LocalLink\Testbenches\src\LL_Uart_Bridge\ll_uart_bridge.awf"

run
# Simulation should stop automatically

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\ll_uart_bridge_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_uart_bridge 
