rmdir /s /q work
del ..\netlist\*.ngc
del ..\vhm\*.*
mkdir .\work
cd work
%XILINX%\bin\nt\xst.exe -ifn ..\scripts\make.xst -ofn log.txt
copy /y fixtofp32_11s.ngc ..\netlist
call ..\scripts\make_netgen.bat fixtofp32_11s ..\src\fixtofp32_11s.vhd
cd ..