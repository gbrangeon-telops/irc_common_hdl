force -freeze -r 10.000000 ns CLK 0 0 ns 1 5 ns
force -deposit HEXTRACTOR/HX_32_KERNEL/TX_LL_MISO.AFULL 0
force -deposit HEXTRACTOR/HX_32_KERNEL/TX_LL_MISO.BUSY 0
force -freeze RST 1 0 ns, 0 40 ns
force -deposit U1/TX_MISO.AFULL 0
force -deposit U1/TX_MISO.BUSY 0
