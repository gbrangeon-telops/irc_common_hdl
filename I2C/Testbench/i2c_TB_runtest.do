setactivelib work
comp -include "$DSN/../i2c_master.vhd"
comp -include "$DSN/../i2c_slave.vhd" 
comp -include "$DSN/../TestBench/i2c_TB.vhd" 
asim TESTBENCH_FOR_i2c
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg I2C_STB
wave -noreg I2C_WE
wave -noreg I2C_ACKDRV
wave -noreg I2C_ACT
wave -noreg I2C_RDY
wave -noreg I2C_ACK
wave -noreg I2C_ERR
wave -noreg I2C_ACT
wave -noreg I2C_ADR
wave -noreg I2C_TX
wave -noreg I2C_RX
wave -noreg I2C_SCL_PIN
wave -noreg I2C_SDA_PIN
wave -noreg REG_ADR
wave -noreg REG_WE
wave -noreg REG_IN
wave -noreg REG_OUT

wave -noreg UUT_master/clk4x_en
wave -noreg UUT_master/cs_sm
wave -noreg UUT_master/tx_byte
wave -noreg UUT_master/sdi
wave -noreg UUT_master/sd_lvl
wave -noreg UUT_master/sc_lvl
wave -noreg UUT_master/bitdrv
wave -noreg UUT_master/sc_en
wave -noreg UUT_master/sd_en
wave -noreg UUT_master/clk4x_en
wave -noreg UUT_master/rx_byte
wave -noreg UUT_master/tx_byte
wave -noreg UUT_master/we
wave -noreg UUT_master/ack
wave -noreg UUT_master/adrcyc

wave -noreg UUT_slave1/i2c_event
wave -noreg UUT_slave1/i2c_slvstat
wave -noreg UUT_slave1/slv_shr
wave -noreg UUT_slave1/bit_pos
wave -noreg UUT_slave1/rw_bit

run 40us

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN/src/TestBench/i2c_TB_tim_cfg.vhd" 
# asim TIMING_FOR_i2c 
