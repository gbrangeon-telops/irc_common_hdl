setactivelib work
comp -include "$DSN/compile/MIG_dataproc_top.vhd" 
comp -include "$DSN/src/TestBench/mig_dataproc_top_TB.vhd" 
asim TESTBENCH_FOR_mig_dataproc_top 
wave 
wave -noreg CLK100_IN_N
wave -noreg CLK100_IN_P
wave -noreg RESET_IN_N
wave -noreg DDR_CAS_N
wave -noreg DDR_CLK_N
wave -noreg DDR_CLK_P
wave -noreg DDR_RAS_N
wave -noreg DDR_RESET_N
wave -noreg DDR_WE_N
wave -noreg DDR_ADD
wave -noreg DDR_BA
wave -noreg DDR_CKE
wave -noreg DDR_CS_N
wave -noreg DDR_DQ
wave -noreg DDR_DQS
wave -noreg UUT/DDR/ddr/FIFO_ERR
wave -noreg UUT/DDR/ddr/DDRT_STAT
wave -noreg UUT/DDR/ddr/CORE_DATA_VLD
wave -noreg UUT/DDR/ddr/CORE_DATA_RD
wave -noreg UUT/DDR/ddr/CORE_AFULL
wave -noreg UUT/DDR/ddr/CORE_DATA_WR
wave -noreg UUT/DDR/ddr/CORE_ADDR
wave -noreg UUT/DDR/ddr/CORE_CMD
wave -noreg UUT/DDR/ddr/CORE_CMD_VALID
wave -noreg UUT/DDR/ddr/CORE_INITDONE

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$DSN/src/TestBench/mig_dataproc_top_TB_tim_cfg.vhd" 
# asim TIMING_FOR_mig_dataproc_top 
