setactivelib work			  

cd $DSN/../LocalLink/ll_ram_tb
comp -include ll_ram_tb.bde
comp -include ll_ram_tb_TB.vhd 

asim -ses -callbacks -ieee_nowarn ll_ram_tb_TB  

open -wave ll_ram_tb.awf

run 2 us
