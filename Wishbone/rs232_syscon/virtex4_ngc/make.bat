del *.ngc

xst -ifn make.xst -ofn log.txt

del *.lso
del *_vhdl.prj
rmdir /s /q xst

echo 