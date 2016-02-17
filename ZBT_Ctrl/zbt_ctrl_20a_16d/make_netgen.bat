SET ENTITY=zbt_ctrl_20a_16d
netgen.exe -ofmt vhdl -intstyle xflow -w %ENTITY%.ngc %ENTITY%_sim.vhd
del %ENTITY%.vhm
copy %ENTITY%_sim.vhd %ENTITY%.vhm
del %ENTITY%_sim.*
std2rec %ENTITY%.vhd %ENTITY%.vhm


