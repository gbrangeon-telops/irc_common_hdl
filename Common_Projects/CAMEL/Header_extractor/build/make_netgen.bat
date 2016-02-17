REM Use like this:
REM make_netgen.bat entity_name original_vhd_file.vhd

SET ENTITY=%1
set PATH=%PATH%;D:\Telops\Common_HDL\Utilities\std2rec
netgen.exe -ofmt vhdl -intstyle xflow -w %ENTITY%.ngc %ENTITY%_sim.vhd
del %ENTITY%.vhm
copy %ENTITY%_sim.vhd %ENTITY%.vhm
del %ENTITY%_sim.*
std2rec %2 %ENTITY%.vhm


