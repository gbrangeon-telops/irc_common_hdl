# Tester
do $COMMON_HDL/DDR_Ctrl/src/DDR_tester/compile_tester.do

acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/DDR_Interface_FSM.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/DDR_Interface.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/mig_adapt_sim.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/ddr_wishbone.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/ddr_top.bde"
