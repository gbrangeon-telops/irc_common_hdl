setactivelib work
open -wave "$DSN/src/Calibration/AddSub_float32/Testbench/AddSub_float32_tb.awf"	   

acom $DSN/src/Calibration/AddSub_float32/AddSub_float32.vhd  
acom $DSN/src/Calibration/AddSub_float32/Testbench/AddSub_float32_tb.bde
acom $DSN/src/Calibration/AddSub_float32/Testbench/AddSub_float32_tb_TB.vhd

cd $DSN/src/Calibration/AddSub_float32/Testbench   
asim -ses -callbacks -ieee_nowarn AddSub_float32_tb_tb      
run 10 ms

# Rouler analyze_results.m dans Matlab après pour l'analyse

