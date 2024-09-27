force -freeze -r 10.000000 ns {/CLK_100_IN_P} 0 0 ns, 1 5 ns
force -freeze {/RESET_IN_N} 0 0 ns, 1 43 ns
force -freeze {/TMI1_DVAL} 0 0 ns
-- force -freeze {/SEL} "01" 0 ns

force -freeze {/START_TEST1} 1 0 ns
force -freeze {/START_TEST2} 0 0 ns, 1 12us