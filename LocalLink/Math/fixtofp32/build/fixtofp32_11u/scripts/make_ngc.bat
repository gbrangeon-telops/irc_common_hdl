rmdir /s /q work
del .\netlist\*.ngc
del .\vhm\*.vhm
mkdir .\work
cd work
%XILINX%\bin\nt\xst.exe -ifn ..\scripts\make.xst -ofn log.txt
copy /y fixtofp32_11u.ngc ..\netlist
call ..\scripts\make_netgen.bat fixtofp32_11u ..\src\fixtofp32_11u.vhd
cd ..