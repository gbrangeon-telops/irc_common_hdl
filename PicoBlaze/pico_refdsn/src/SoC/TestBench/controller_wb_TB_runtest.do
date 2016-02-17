SetActiveLib -work
comp -include "$DSN\compile\controller_wb.vhd" 
comp -include "$DSN\src\controller\TestBench\controller_wb_TB.vhd" 
asim TESTBENCH_FOR_controller_wb 
wave 
wave -noreg CLK
wave -noreg RST