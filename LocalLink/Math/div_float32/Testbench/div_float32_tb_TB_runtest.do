SetActiveLib -work
open -wave "$DSN\src\Calibration\div_float32\Testbench\div_float32_tb.awf"	   

acom $DSN/src/Calibration/div_float32/div_float32.vhd  
acom $DSN/src/Calibration/div_float32/Testbench/div_float32_tb.bde
acom $DSN/src/Calibration/div_float32/Testbench/div_float32_tb_TB.vhd

cd $DSN\src\Calibration\div_float32\Testbench
#asim -ses -callbacks -ieee_nowarn TESTBENCH_FOR_div_float32_tb      
asim -ses -callbacks -ieee_nowarn div_float32_tb_tb      
run 50 us

# Rouler analyze_results.m dans Matlab après pour l'analyse

