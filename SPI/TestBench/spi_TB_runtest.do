setactivelib work
asim TESTBENCH_FOR_spi 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg DOUT
wave -noreg DIN
wave -noreg STB
wave -noreg SPI_SCK
wave -noreg SPI_MOSI
wave -noreg SPI_MISO
wave -noreg SPI_SSn
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN/src/TestBench/spi_slave_TB_tim_cfg.vhd" 
# asim TIMING_FOR_spi_slave 
