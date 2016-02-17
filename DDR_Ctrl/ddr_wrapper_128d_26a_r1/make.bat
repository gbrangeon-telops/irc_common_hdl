@set XIL_XST_HIDEMESSAGE=hdl_and_low_levels

del *.ngc

xst -ifn make.xst -ofn log.txt

del *.lso
del *_vhdl.prj
del *.ngo
rmdir /s /q xst         

call make_netgen.bat    

pause