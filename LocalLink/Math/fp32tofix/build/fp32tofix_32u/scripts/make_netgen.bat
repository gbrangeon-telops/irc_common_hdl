REM Use like this:
REM make_netgen.bat entity_name original_vhd_file.vhd

SET ENTITY=%1
set PATH=%PATH%;D:\Telops\Common_HDL\Utilities\std2rec
C:\Xilinx\10.1\ISE\bin\nt\netgen.exe -ofmt vhdl -intstyle xflow -w ..\netlist\%ENTITY%.ngc ..\vhm\%ENTITY%_sim.vhd
copy /y ..\vhm\%ENTITY%_sim.vhd ..\vhm\%ENTITY%.vhm
del ..\vhm\%ENTITY%_sim.*
std2rec.pl %2 ..\vhm\%ENTITY%.vhm
del ..\vhm\*bak