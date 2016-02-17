set curdir=%~dp0
cd D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\build\	

del *.ngc
del *.lso
del *_vhdl.prj
del *.lib~
rmdir /s /q xst

xst -ifn make.xst -ofn log.txt
make_netgen.bat PatGen_32_WB D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\Active-hdl\compile\PatGen_32_WB.vhd

del *.lso
del *_vhdl.prj
del *.lib~
rmdir /s /q xst

cd %curdir%