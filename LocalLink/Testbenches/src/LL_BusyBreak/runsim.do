setactivelib work		 
endsim
acom "$COMMON_HDL/Utilities/fifo_2byte.vhd"
acom "$COMMON_HDL/LocalLink/LL_BusyBreak.vhd"
acom "$COMMON_HDL/LocalLink/Testbenches/src/LL_BusyBreak/LL_BusyBreak_tb.bde"

asim LL_BusyBreak_tb 													   
do "$COMMON_HDL/LocalLink/Testbenches/src/LL_BusyBreak/wave.do"
do "$COMMON_HDL/LocalLink/Testbenches/src/LL_BusyBreak/stimulators.do"
   
run 10 us
