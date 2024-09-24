# MIG Core
#do $COMMON_HDL/DDR_Ctrl/src/MIG_dualrank_stable_100Mhz/compile_MIG.do
#do $COMMON_HDL/DDR_Ctrl/src/MIG/compile_MIG.do
do $COMMON_HDL/DDR_Ctrl/src/MIG2/compile_MIG.do

# Tester
do $COMMON_HDL/DDR_Ctrl/src/DDR_tester/compile_tester.do

# Interface
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/DDR_Interface_FSM.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/DDR_Interface.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/mig_adapt.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/ddr_wishbone.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/DDR_Interface/ddr_top.bde"
