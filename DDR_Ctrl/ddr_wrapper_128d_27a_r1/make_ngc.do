@onerror
{
goto end
}	 	

# Delete vhd file generated from bde to make sure that we regenerate (and use) fresh ones:
!del D:\Telops\Common_HDL\DDR_Ctrl\Active-HDL\IFTIRS_dataproc\compile\*.* /F /Q

cd  D:\Telops\Common_HDL\DDR_Ctrl\ddr_wrapper_128d_27a_r1\

do compile_complete.do

#!del *.ngc /F /Q
#!del *.lso /F /Q
#!del *_vhdl.prj /F /Q
#!del *.lib~ /F /Q
#!del *.ngo /F /Q
#!rmdir /s /q xst
#
#!xst -ifn make.xst -ofn log.txt
#!make_netgen.bat
#
#!del *.lso /F /Q
#!del *_vhdl.prj /F /Q
#!del *.lib~ /F /Q
#!del *.ngo /F /Q
#!rmdir /s /q xst

label end