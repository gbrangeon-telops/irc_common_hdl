do $COMMON_HDL/DDR_Ctrl/src/MIG/compile_MIG.do

do $COMMON_HDL/DDR_Ctrl/src/Tester/compile_tester.do

do $COMMON_HDL/DDR_Ctrl/src/User-Interface/compile_ddr_top.do

do $COMMON_HDL/DDR_Ctrl/src/Model/compile_ddr_model.do

#acom  "$COMMON_HDL/DDR_Ctrl/src/NGC/ddr_wrapper_128d_26a_r1.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/NGC/ddr_wrapper_128d_27a_r1.vhd"
acom  "$COMMON_HDL/DDR_Ctrl/src/NGC/ddr_wrapper_144d_27a_r1.vhd"

do $COMMON_HDL/DDR_Ctrl/src/TestBench/compile_tb.do

