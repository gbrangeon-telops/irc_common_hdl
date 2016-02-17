onerror { resume }
transcript off
add wave -noreg -logic {/U4/RESET_IN_N}
add wave -noreg -logic {/U4/ARESET}
add wave -noreg -logic {/U4/CLK100_in}
add wave -noreg -logic {/U4/CLK100_not_locked}
add wave -noreg -logic {/U4/CLK160}
add wave -noreg -logic {/U4/clk160_not_locked}
add wave -noreg -logic {/U4/CLK200}
add wave -noreg -logic {/U4/CLK_SYS}
add wave -noreg -hexadecimal -literal -unsigned {/U4/SEL}
add wave -noreg -hexadecimal -literal {/U1/TMI_ADD_1}
add wave -noreg -logic {/U1/TMI_RNW_1}
add wave -noreg -logic {/U1/TMI_DVAL_1}
add wave -noreg -logic {/U1/TMI_BUSY_1}
add wave -noreg -hexadecimal -literal {/U1/TMI_RD_DATA_1}
add wave -noreg -logic {/U1/TMI_RD_DVAL_1}
add wave -noreg -hexadecimal -literal {/U1/TMI_WR_DATA_1}
add wave -noreg -logic {/U1/TMI_IDLE_1}
add wave -noreg -logic {/U1/TMI_ERROR_1}
add wave -noreg -hexadecimal -literal {/U1/TMI_ADD_2}
add wave -noreg -logic {/U1/TMI_RNW_2}
add wave -noreg -logic {/U1/TMI_DVAL_2}
add wave -noreg -logic {/U1/TMI_BUSY_2}
add wave -noreg -hexadecimal -literal {/U1/TMI_RD_DATA_2}
add wave -noreg -logic {/U1/TMI_RD_DVAL_2}
add wave -noreg -hexadecimal -literal {/U1/TMI_WR_DATA_2}
add wave -noreg -logic {/U1/TMI_IDLE_2}
add wave -noreg -logic {/U1/TMI_ERROR_2}
add wave -noreg -logic {/U1/ARESET}
add wave -noreg -logic {/U1/CLK}
add wave -noreg -logic {/U4/U1/TST/START_TEST}
add wave -noreg -logic {/U4/U1/TST/TEST_DONE}
add wave -noreg -logic {/U4/U1/TST/TEST_PASS}
add wave -noreg -logic {/START_TEST1}
add wave -noreg -logic {/TEST_DONE1}
add wave -noreg -logic {/TEST_PASS1}
add wave -noreg -logic {/START_TEST2}
add wave -noreg -logic {/TEST_DONE2}
add wave -noreg -logic {/TEST_PASS2}
add wave -noreg -logic {/U4/TMI1_BUSY}
add wave -noreg -logic {/U4/TMI1_IDLE}
add wave -noreg -logic {/U4/TMI1_ERROR}
add wave -noreg -logic {/U4/TMI1_DVAL}
add wave -noreg -logic {/U4/TMI1_RNW}
add wave -noreg -hexadecimal -literal {/U4/TMI1_ADD}
add wave -noreg -hexadecimal -literal {/U4/TMI1_WR_DATA}
add wave -noreg -logic {/U4/TMI1_RD_DVAL}
add wave -noreg -hexadecimal -literal {/U4/TMI1_RD_DATA}
add wave -noreg -logic {/U4/TMI2_BUSY}
add wave -noreg -logic {/U4/TMI2_IDLE}
add wave -noreg -logic {/U4/TMI2_ERROR}
add wave -noreg -logic {/U4/TMI2_RNW}
add wave -noreg -hexadecimal -literal {/U4/TMI2_ADD}
add wave -noreg -hexadecimal -literal {/U4/TMI2_WR_DATA}
add wave -noreg -logic {/U4/TMI2_RD_DVAL}
add wave -noreg -hexadecimal -literal {/U4/TMI2_RD_DATA}
add wave -noreg -hexadecimal -literal {/U4/VALID_WINDOW}
add wave -noreg -logic {/U4/ZBT_WE_N}
add wave -noreg -hexadecimal -literal -signed2 {/U4/ZBT_ADD}
add wave -noreg -hexadecimal -literal {/U4/ZBT_DATA}
add wave -noreg -literal {/U4/U1/SW1/cs}
add wave -noreg -literal {/U4/U1/SW1/ns}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/SEL}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/sel_sync}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/sel_i}
add wave -noreg -logic {/U4/U1/SW1/TMI_BUSY}
add wave -noreg -logic {/U4/U1/SW1/TMI_RD_DVAL}
add wave -noreg -logic {/U4/U1/SW1/TMI_IDLE}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI1_ADD}
add wave -noreg -logic {/U4/U1/SW1/TMI1_RNW}
add wave -noreg -logic {/U4/U1/SW1/TMI1_DVAL}
add wave -noreg -logic {/U4/U1/SW1/TMI1_IDLE}
add wave -noreg -logic {/U4/U1/SW1/TMI1_BUSY}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI1_RD_DATA}
add wave -noreg -logic {/U4/U1/SW1/TMI1_RD_DVAL}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI1_WR_DATA}
add wave -noreg -logic {/U4/U1/SW1/TMI1_ERROR}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI2_ADD}
add wave -noreg -logic {/U4/U1/SW1/TMI2_RNW}
add wave -noreg -logic {/U4/U1/SW1/TMI2_IDLE}
add wave -noreg -logic {/U4/U1/SW1/TMI2_DVAL}
add wave -noreg -logic {/U4/U1/SW1/TMI2_BUSY}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI2_RD_DATA}
add wave -noreg -logic {/U4/U1/SW1/TMI2_RD_DVAL}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI2_WR_DATA}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI_ADD}
add wave -noreg -logic {/U4/U1/SW1/TMI_RNW}
add wave -noreg -logic {/U4/U1/SW1/TMI_DVAL}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI_RD_DATA}
add wave -noreg -hexadecimal -literal {/U4/U1/SW1/TMI_WR_DATA}
add wave -noreg -logic {/U4/U1/SW1/CLK}
add wave -noreg -logic {/U4/U1/TUNE/busy_ad}
add wave -noreg -literal {/U4/U1/TUNE/auto_detect_proc/detect_state}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/current_window}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/test_pass_hist}
add wave -noreg -logic {/U4/U1/TUNE/test_pass_hold}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/test_done_hist}
add wave -noreg -logic {/U4/U1/TUNE/test_done_hold}
add wave -noreg -logic {/MEMTEST_port1/SIM}
add wave -noreg -logic {/MEMTEST_port1/enable}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/long_seed_WR}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/long_seed_RD}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/LFSR_seed_WR}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/LFSR_seed_RD}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/random_vec}
add wave -noreg -logic {/MEMTEST_port1/busy}
add wave -noreg -logic {/MEMTEST_port1/request_st}
add wave -noreg -logic {/MEMTEST_port1/test_pass_i}
add wave -noreg -logic {/MEMTEST_port1/test_done_i}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/rd_data_i}
add wave -noreg -logic {/MEMTEST_port1/rd_dval_i}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/wr_data_i}
add wave -noreg -literal {/MEMTEST_port1/state}
add wave -noreg -logic {/MEMTEST_port1/START_TEST}
add wave -noreg -logic {/MEMTEST_port1/TEST_DONE}
add wave -noreg -logic {/MEMTEST_port1/TEST_PASS}
add wave -noreg -logic {/MEMTEST_port1/TMI_IDLE}
add wave -noreg -logic {/MEMTEST_port1/TMI_ERROR}
add wave -noreg -logic {/MEMTEST_port1/TMI_RNW}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/TMI_ADD}
add wave -noreg -logic {/MEMTEST_port1/TMI_DVAL}
add wave -noreg -logic {/MEMTEST_port1/TMI_BUSY}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/self_test_proc/wr_add_test}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/self_test_proc/rd_add_test}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/self_test_proc/rd_add_check}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/data_golden}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/data_golden_r1}
add wave -noreg -logic {/MEMTEST_port1/TMI_RD_DVAL}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/TMI_RD_DATA}
add wave -noreg -logic {/MEMTEST_port1/rd_dval_i_r1}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/rd_data_i_r1}
add wave -noreg -logic {/MEMTEST_port1/rd_dval_i_r2}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/rd_data_i_r2}
add wave -noreg -hexadecimal -literal {/MEMTEST_port1/TMI_WR_DATA}
add wave -noreg -logic {/MEMTEST_port1/ARESET}
add wave -noreg -logic {/MEMTEST_port1/CLK}
add wave -noreg -logic {/MEMTEST_port2/SIM}
add wave -noreg -logic {/MEMTEST_port2/enable}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/long_seed_WR}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/long_seed_RD}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/LFSR_seed_WR}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/LFSR_seed_RD}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/random_vec}
add wave -noreg -logic {/MEMTEST_port2/busy}
add wave -noreg -logic {/MEMTEST_port2/request_st}
add wave -noreg -logic {/MEMTEST_port2/test_pass_i}
add wave -noreg -logic {/MEMTEST_port2/test_done_i}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/rd_data_i}
add wave -noreg -logic {/MEMTEST_port2/rd_dval_i}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/wr_data_i}
add wave -noreg -literal {/MEMTEST_port2/state}
add wave -noreg -logic {/MEMTEST_port2/START_TEST}
add wave -noreg -logic {/MEMTEST_port2/TEST_DONE}
add wave -noreg -logic {/MEMTEST_port2/TEST_PASS}
add wave -noreg -logic {/MEMTEST_port2/TMI_IDLE}
add wave -noreg -logic {/MEMTEST_port2/TMI_ERROR}
add wave -noreg -logic {/MEMTEST_port2/TMI_RNW}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/TMI_ADD}
add wave -noreg -logic {/MEMTEST_port2/TMI_DVAL}
add wave -noreg -logic {/MEMTEST_port2/TMI_BUSY}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/self_test_proc/wr_add_test}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/self_test_proc/rd_add_test}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/self_test_proc/rd_add_check}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/data_golden}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/data_golden_r1}
add wave -noreg -logic {/MEMTEST_port2/TMI_RD_DVAL}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/TMI_RD_DATA}
add wave -noreg -logic {/MEMTEST_port2/rd_dval_i_r1}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/rd_data_i_r1}
add wave -noreg -logic {/MEMTEST_port2/rd_dval_i_r2}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/rd_data_i_r2}
add wave -noreg -hexadecimal -literal {/MEMTEST_port2/TMI_WR_DATA}
add wave -noreg -logic {/MEMTEST_port2/ARESET}
add wave -noreg -logic {/MEMTEST_port2/CLK}
cursor "Cursor 1" 218.537us
transcript on
