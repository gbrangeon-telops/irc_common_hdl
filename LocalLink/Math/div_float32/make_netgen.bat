
netgen.exe -ofmt vhdl -intstyle xflow -w div_float32.ngc div_float32_sim.vhd
del div_float32.vhm
copy div_float32_sim.vhd div_float32.vhm
std2rec div_float32.vhd div_float32.vhm


