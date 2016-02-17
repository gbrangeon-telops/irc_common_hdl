SET ENTITY=ddr_wrapper_128d_26a_r1
netgen.exe -ofmt vhdl -intstyle xflow -w %ENTITY%.ngc %ENTITY%_sim.vhd
del %ENTITY%.vhm
copy %ENTITY%_sim.vhd %ENTITY%.vhm
del %ENTITY%_sim.*
std2rec %ENTITY%.vhd %ENTITY%.vhm


