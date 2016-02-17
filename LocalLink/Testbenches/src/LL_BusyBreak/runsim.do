SetActiveLib -work		 
endsim
acom "d:\Telops\Common_HDL\Utilities\fifo_2byte.vhd"
acom "d:\Telops\Common_HDL\LocalLink\LL_BusyBreak.vhd"
acom "D:\Telops\Common_HDL\LocalLink\Testbenches\src\LL_BusyBreak\LL_BusyBreak_tb.bde"

asim LL_BusyBreak_tb 													   
do "D:\Telops\Common_HDL\LocalLink\Testbenches\src\LL_BusyBreak\wave.do"
do "D:\Telops\Common_HDL\LocalLink\Testbenches\src\LL_BusyBreak\stimulators.do"
   
run 10 us
