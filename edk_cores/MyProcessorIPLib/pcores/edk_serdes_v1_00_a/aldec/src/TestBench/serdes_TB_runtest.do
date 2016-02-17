SetActiveLib -work
asim TESTBENCH_FOR_serdes 
wave 
wave -noreg TCLK
wave -noreg RCLK
wave -noreg RST
wave -noreg DIN
wave -noreg TDVAL
wave -noreg BSY
wave -noreg SCLK
wave -noreg SDAT
wave -noreg DVAL
wave -noreg DOUT
wave -noreg /UUT1/state
wave -noreg /UUT1/dreg
wave -noreg /UUT1/tx_cnt
wave -noreg /UUT2/state
wave -noreg /UUT2/dreg
wave -noreg /UUT2/rx_cnt
