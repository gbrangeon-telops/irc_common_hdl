set curdir=%~dp0
cd  D:\Telops\Common_HDL\DDR_Ctrl\ddr_wrapper_128d_27a_r1\

del *.ngc
del *.lso
del *_vhdl.prj
del *.lib~
rmdir /s /q xst

xst -ifn make.xst -ofn log.txt
make_netgen.bat

del *.lso
del *_vhdl.prj
del *.lib~
rmdir /s /q xst

cd %curdir%