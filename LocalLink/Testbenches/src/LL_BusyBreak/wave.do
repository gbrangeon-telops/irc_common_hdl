onerror { resume }
transcript off
add wave -noreg -logic {/CLK}
add wave -noreg -logic {/RANDOM}
add wave -noreg -logic {/RST}
add wave -noreg -logic {/STALL}
add wave -noreg -hexadecimal -literal {/DUT/RX_MOSI}
add wave -noreg -hexadecimal -literal {/DUT/RX_MISO}
add wave -noreg -hexadecimal -literal {/DUT/TX_MOSI}
add wave -noreg -hexadecimal -literal {/DUT/TX_MISO}
cursor "Cursor 1" 1000ns
transcript on
