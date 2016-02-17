set curpath = %~dp0

del %curpath%*.ngc

xst -ifn %curpath%make.xst -ofn log.txt

del %curpath%*.lso
del %curpath%*_vhdl.prj
del %curpath%*.ngo
rmdir /s /q %curpath%xst