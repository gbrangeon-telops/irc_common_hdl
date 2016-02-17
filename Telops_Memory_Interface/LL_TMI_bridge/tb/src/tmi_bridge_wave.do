onerror { resume }
transcript off
add wave -noreg -hexadecimal -literal {/UUT/WB_MOSI}
add wave -noreg -hexadecimal -literal {/UUT/WB_MISO}
add wave -named_row "TMI_WB"
add wave -noreg -hexadecimal -literal {/UUT/WS_ADD}
add wave -noreg -hexadecimal -literal {/UUT/WE_ADD}
add wave -noreg -hexadecimal -literal {/UUT/WSTEP_ADD}
add wave -noreg -hexadecimal -literal {/UUT/WW}
add wave -noreg -hexadecimal -literal {/UUT/WS}
add wave -noreg -logic {/UUT/w_done}
add wave -noreg -hexadecimal -literal {/UUT/W_Conf}
add wave -noreg -hexadecimal -literal {/UUT/w_CTRL}
add wave -noreg -hexadecimal -literal {/UUT/RS_ADD}
add wave -noreg -hexadecimal -literal {/UUT/RE_ADD}
add wave -noreg -hexadecimal -literal {/UUT/RSTEP_ADD}
add wave -noreg -hexadecimal -literal {/UUT/RW}
add wave -noreg -hexadecimal -literal {/UUT/RS}
add wave -noreg -hexadecimal -literal {/UUT/R_CONF}
add wave -noreg -hexadecimal -literal {/UUT/R_CTRL}
add wave -noreg -logic {/UUT/r_done}
add wave -named_row "Write"
add wave -noreg -hexadecimal -literal {/UUT/TMI1_ADD}
add wave -noreg -logic {/UUT/W_tmi_rnw}
add wave -noreg -logic {/UUT/w_tmi_dval}
add wave -noreg -logic {/UUT/w_tmi_busy}
add wave -noreg -decimal -literal -unsigned {/UUT/TMI1_WR_DATA}
add wave -noreg -logic {/UUT/w_tmi_idle}
add wave -noreg -logic {/UUT/w_tmi_error}
add wave -named_row "Read"
add wave -noreg -hexadecimal -literal {/UUT/TMI2_ADD}
add wave -noreg -logic {/UUT/r_tmi_rnw}
add wave -noreg -logic {/UUT/r_tmi_dval}
add wave -noreg -logic {/UUT/r_tmi_busy}
add wave -noreg -logic {/UUT/r_tmi_rd_dval}
add wave -noreg -hexadecimal -literal -unsigned {/UUT/TMI2_RD_DATA}
add wave -noreg -hexadecimal -literal {/UUT/TMI2_WR_DATA}
add wave -noreg -logic {/UUT/r_tmi_idle}
add wave -noreg -logic {/UUT/r_tmi_error}
add wave -named_row "Switch"
add wave -noreg -hexadecimal -literal {/UUT/add}
add wave -noreg -logic {/UUT/sw_tmi_rnw}
add wave -noreg -logic {/UUT/sw_tmi_dval}
add wave -noreg -logic {/UUT/sw_tmi_busy}
add wave -noreg -hexadecimal -literal -unsigned {/UUT/RD_DATA}
add wave -noreg -logic {/UUT/sw_tmi_rd_dval}
add wave -noreg -hexadecimal -literal -unsigned {/UUT/WR_DATA}
add wave -noreg -logic {/UUT/sw_tmi_idle}
add wave -noreg -logic {/UUT/sw_tmi_error}
add wave -named_row "DATA"
add wave -noreg -hexadecimal -literal {/UUT/RD_MISO_32}
add wave -noreg -hexadecimal -literal {/UUT/RD_MOSI_32}
add wave -noreg -hexadecimal -literal {/UUT/WR_MISO_32}
add wave -noreg -hexadecimal -literal {/UUT/WR_MOSI_32}
cursor "Cursor 1" 1353.86us
transcript on
