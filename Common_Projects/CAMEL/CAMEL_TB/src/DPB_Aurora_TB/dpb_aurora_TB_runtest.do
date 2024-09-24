setactivelib work
acom $DSN/src/DPB_Aurora_TB/dpb_aurora.bde
acom $DSN/src/DPB_Aurora_TB/dpb_aurora_TB.vhd
open -wave $DSN/src/DPB_Aurora_TB/dpb_aurora_TB.awf

asim -advdataflow -ses TESTBENCH_FOR_dpb_aurora 					   
run 50 us

