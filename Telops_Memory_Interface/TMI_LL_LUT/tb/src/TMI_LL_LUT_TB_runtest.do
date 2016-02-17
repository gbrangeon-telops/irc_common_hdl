SetActiveLib -work

setenv FIR180 "D:\Telops\FIR-00180-IRC"

# Wishbone interconnect
acom  "$FIR180\src\Wishbone\wb_intercon.vhd"

do "$dsn\..\build\tmi_ll_lut_Compile.do"

acom "$dsn\..\..\tmi_bram.vhd"

# SystemC testbench                                      
adel uct_model
cd $dsn\src\
buildc tmi_ll_lut_tb.dlm	

# SystemC to UCT wrapper
acom  "$FIR180\src\TestBench\UCT.vhd"

# Testbench Top Level
acom  "$dsn\src\tmi_ll_lut_tb.bde" 

# Testbench with stimuli
acom  "$dsn\src\tmi_ll_lut_tb_tb.vhd"
                          
# Lauch sim                         
asim TESTBENCH_FOR_tmi_ll_lut_tb 

open -wave "$dsn\src\sub_xmin.awf"
open -wave "$dsn\src\div_xrange.awf"
open -wave "$dsn\src\mult_lut_size.awf"
open -wave "$dsn\src\float_to_fixed.awf"
open -wave "$dsn\src\start_address.awf"
open -wave "$dsn\src\minimum.awf"

open -wave "$dsn\src\x_to_add.awf"
open -wave "$dsn\src\tmi_ll_lut_a21_d32.awf"

run

endsim
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\ll_tmi_read_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_tmi_read 
