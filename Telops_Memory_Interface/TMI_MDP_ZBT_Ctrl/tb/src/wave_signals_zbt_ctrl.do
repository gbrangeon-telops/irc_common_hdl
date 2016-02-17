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
add wave -noreg -hexadecimal -literal {/U4/SEL}
add wave -noreg -logic {/U4/U1/TST/START_TEST}
add wave -noreg -logic {/U4/U1/TST/TEST_DONE}
add wave -noreg -logic {/U4/U1/TST/TEST_PASS}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/test_pass_hist}
add wave -noreg -logic {/U4/U1/TUNE/test_pass_hold}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/test_done_hist}
add wave -noreg -logic {/U4/U1/TUNE/test_done_hold}
add wave -noreg -hexadecimal -literal {/U4/U1/TST/self_test_proc/data_golden}
add wave -noreg -logic {/U4/U1/TST/self_test_proc/test_phase}
add wave -noreg -logic {/U4/U1/TST/self_test_proc/error_found}
add wave -noreg -logic {/U4/U1/TST/TMI_IDLE}
add wave -noreg -logic {/U4/U1/TST/TMI_RNW}
add wave -noreg -hexadecimal -literal {/U4/U1/TST/TMI_ADD}
add wave -noreg -logic {/U4/U1/TST/TMI_DVAL}
add wave -noreg -logic {/U4/U1/TST/TMI_BUSY}
add wave -noreg -hexadecimal -literal {/U4/U1/TST/TMI_RD_DATA}
add wave -noreg -logic {/U4/U1/TST/TMI_RD_DVAL}
add wave -noreg -hexadecimal -literal {/U4/U1/TST/TMI_WR_DATA}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/TMI_WR_DATA_r2}
add wave -noreg -logic {/U4/U1/TST/request_st}
add wave -noreg -logic {/U4/U1/TST/busy}
add wave -noreg -hexadecimal -literal {/U4/U1/TST/self_test_proc/rd_add_test}
add wave -noreg -hexadecimal -literal {/U4/U1/TST/self_test_proc/rd_add_check}
add wave -noreg -literal {/U4/U1/TST/state}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/delay}
add wave -noreg -logic {/U4/U1/TUNE/auto_detect_proc/FinalDelay}
add wave -noreg -logic {/U4/U1/TUNE/auto_detect_proc/FinalCheck}
add wave -noreg -decimal -literal -signed2 {/U4/U1/TUNE/auto_detect_proc/DelayCnt}
add wave -noreg -logic {/U4/U1/TUNE/auto_detect_proc/previous_st_pass}
add wave -noreg -logic {/U4/U1/TUNE/auto_detect_proc/first_time}
add wave -noreg -logic {/U4/U1/TUNE/auto_detect_proc/first_pass}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/target_delay}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/best_delay}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/best_delay_temp}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/best_window}
add wave -noreg -logic {/U4/U1/TUNE/auto_detect_proc/best_extra_cycle}
add wave -noreg -hexadecimal -literal {/U4/U1/TUNE/auto_detect_proc/last_transition_delay}
add wave -noreg -logic {/U4/U1/TUNE/auto_detect_proc/currently_in_valid_window}
add wave -noreg -logic {/U4/U1/ZBT/CLK}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/zbt_data_delayed}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/zbt_data_oe}
add wave -noreg -logic {/U4/U1/ZBT/ZBT_WE_Ni2}
add wave -noreg -logic {/U4/U1/ZBT/valid_read_cmd}
add wave -noreg -logic {/U4/U1/ZBT/data_valid_out}
add wave -noreg -logic {/U4/U1/ZBT/we_n_reg_d}
add wave -noreg -logic {/U4/U1/ZBT/zbt_wr_delay1}
add wave -noreg -logic {/U4/U1/ZBT/DLY_CTRL_RDY}
add wave -noreg -logic {/U4/U1/ZBT/DLY_EN}
add wave -noreg -logic {/U4/U1/ZBT/DLY_INC}
add wave -noreg -logic {/U4/U1/ZBT/EXTRA_CYCLE}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/TMI_ADD}
add wave -noreg -logic {/U4/U1/ZBT/TMI_RNW}
add wave -noreg -logic {/U4/U1/ZBT/TMI_DVAL}
add wave -noreg -logic {/U4/U1/ZBT/TMI_BUSY}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/TMI_RD_DATA}
add wave -noreg -logic {/U4/U1/ZBT/TMI_RD_DVAL}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/TMI_WR_DATA}
add wave -noreg -logic {/U4/U1/ZBT/TMI_IDLE}
add wave -noreg -logic {/U4/U1/ZBT/TMI_ERROR}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/ZBT_ADD}
add wave -noreg -logic {/U4/U1/ZBT/ZBT_CE_N}
add wave -noreg -logic {/U4/U1/ZBT/ZBT_OE_N}
add wave -noreg -logic {/U4/U1/ZBT/ZBT_WE_N}
add wave -noreg -logic {/U4/U1/ZBT/ZBT_CKE_N}
add wave -noreg -logic {/U4/U1/ZBT/ZBT_CE2_N}
add wave -noreg -logic {/U4/U1/ZBT/ZBT_CE2}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/ZBT_DATA}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/idle_proc/dval_hist}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/read_proc/valid_read_cmd_in}
add wave -noreg -hexadecimal -literal {/U4/U1/ZBT/write_proc/data_delay}
cursor "Cursor 1" 887.5ns
transcript on
