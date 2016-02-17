SetActiveLib -work
comp -include "$DSN\..\temp_reader.vhd" 
comp -include "$DSN\..\TestBench\temp_reader_TB.vhd" 
asim TESTBENCH_FOR_temp_reader 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg FPGA_TEMP
wave -noreg EXT_TEMP
wave -noreg VALID_TEMP
wave -noreg REG_ADR
wave -noreg REG_WE
wave -noreg REG_OUT
wave -noreg REG_IN
wave -noreg MAX1617_CONF
wave -noreg MAX1617_RATE   
wave -noreg I2C_SCL_PIN
wave -noreg I2C_SDA_PIN

wave -noreg UUT/cs_lp
wave -noreg UUT/cs_rem
wave -noreg UUT/scl4xsrc
wave -noreg UUT/i2c_stb
wave -noreg UUT/i2c_we 
wave -noreg UUT/i2c_act
wave -noreg UUT/i2c_ack
wave -noreg UUT/i2c_err
wave -noreg UUT/i2c_tx 
wave -noreg UUT/i2c_rx
wave -noreg UUT/din
wave -noreg UUT/dout
wave -noreg UUT/stb
wave -noreg UUT/ack
wave -noreg UUT/we

wave -noreg UUT/i2c_master_inst/sdi
wave -noreg UUT/i2c_master_inst/sc_lvl
wave -noreg UUT/i2c_master_inst/sd_lvl
wave -noreg UUT/i2c_master_inst/cs_sm

wave -noreg Fake_MAX1617/i2c_event
wave -noreg Fake_MAX1617/i2c_slvstat
wave -noreg Fake_MAX1617/slv_shr
wave -noreg Fake_MAX1617/bit_pos
wave -noreg Fake_MAX1617/rw_bit
wave -noreg Fake_MAX1617/sda_drv

run 50us 
  
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN\src\TestBench\temp_reader_TB_tim_cfg.vhd" 
# asim TIMING_FOR_temp_reader 
