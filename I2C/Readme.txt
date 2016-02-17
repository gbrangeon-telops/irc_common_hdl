Copyright (c) Telops Inc. 2006
By: Olivier Bourgois

This folder contains i2c/smb bus related cores

Main Folder:

1) i2c_master.vhd (status: hardware tested)
   - an I2C master implementation

2) i2c_slave.vhd (status: testbench tested)
   - an I2C slave implementation

3) temp_reader.vhd
   - a core for continuously reading external and local temperatures from
     a MAX1617 or ADM1023 temperature sensor chip via I2C. Uses i2c_master.vhd

Testbench Folder:

1) i2c_TB.vhd
   - a testbench for verifying i2c_master.vhd and i2c_slave.vhd together in a system

2) temp_reader_TB.vhd
   - a testbench for verifying temp_reader.vhd. It uses an i2c_slave component to fake a MAX1617.
     It return 0xB1 for the local temperature and 0xB2 for the external temperature.

AHDL_Proj Folder:
  - contains an AHDL project for testing these cores
  