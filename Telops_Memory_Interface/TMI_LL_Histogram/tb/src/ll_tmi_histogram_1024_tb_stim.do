force -freeze {/ARESET} 1 0 ns, 0 30 ns
force -freeze -r 5.000000 ns {/LL_CLK} 0 0 ns, 1 2.5 ns
force -freeze {/STALL} 0 0 ns,1 150 us, 0 180 us
-- force -freeze {/CLEAR_MEM} 0 0 ns,0 500 us, 0 180 us
force -freeze {/RANDOM} 0 0 ns , 0 5 ms
force -freeze {/FALL} 0 0 ns, 1 5 ms




