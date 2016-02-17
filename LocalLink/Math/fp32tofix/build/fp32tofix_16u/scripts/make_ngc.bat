rmdir /s /q work
del .\netlist\*.ngc
del .\vhm\*.vhm
mkdir .\work
cd work
C:\Xilinx\10.1\ISE\bin\nt\xst.exe -ifn ..\scripts\make.xst -ofn log.txt
copy /y fp32tofix_16u.ngc ..\netlist
call ..\scripts\make_netgen.bat fp32tofix_16u ..\src\fp32tofix_16u.vhd
cd ..