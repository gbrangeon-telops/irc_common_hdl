onerror { resume }
transcript off
add wave -noreg -logic {/ARESET}
add wave -noreg -logic {/LL_CLK}
add wave -noreg -hexadecimal -literal {/U2/TX_MOSI}
add wave -noreg -logic {/STALL}
add wave -noreg -hexadecimal -literal {/U1/RX_MOSI}
add wave -noreg -logic {/U1/HISTOGRAM_RDY}
add wave -noreg -logic -unsigned {/CLEAR_MEM}
add wave -noreg -hexadecimal -literal -unsigned {/U1/TMI_MOSI.ADD}
add wave -noreg -logic {/U1/TMI_MOSI.RNW}
add wave -noreg -logic {/U1/TMI_MOSI.DVAL}
add wave -noreg -logic -unsigned {/U1/TMI_MISO.BUSY}
add wave -noreg -decimal -literal -unsigned {/U1/TMI_MISO.RD_DATA}
add wave -noreg -logic {/U1/TMI_MISO.RD_DVAL}
add wave -noreg -logic {/U1/TMI_MISO.IDLE}
add wave -noreg -logic {/U1/TMI_MISO.ERROR}
add wave -noreg -hexadecimal -literal {/U1/TMI_MOSI.WR_DATA}
add wave -noreg -hexadecimal -literal {/timestamp}
add wave -noreg -hexadecimal -literal -unsigned {/U4/add}
add wave -noreg -hexadecimal -literal {/U4/count}
add wave -noreg -hexadecimal -literal {/U1/U3/histogram_x0/dual_port_ram/wea}
add wave -noreg -hexadecimal -literal {/U1/U3/histogram_x0/dual_port_ram/addra}
add wave -noreg -hexadecimal -literal {/U1/U3/histogram_x0/dual_port_ram/dina}
add wave -noreg -hexadecimal -literal {/U1/U3/histogram_x0/dual_port_ram/addrb}
add wave -noreg -hexadecimal -literal {/U1/U3/histogram_x0/dual_port_ram/douta}
cursor "Cursor 1" 43.192us
transcript on
