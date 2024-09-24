# compile the Simple Interface
do $COMMON_HDL/DDR_Ctrl/src/DDR_Interface/compile_DDR_Interface_simple.do

# Wrap it
acom  "$COMMON_HDL/DDR_Ctrl/ddr_wrapper_128d_27a_r1/ddr_wrapper_128d_27a_r1.vhd"
