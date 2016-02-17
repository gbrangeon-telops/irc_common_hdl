@onerror
{
goto end
}	 

cd  D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\build\

acom D:\Telops\Common_HDL\Common_Projects\Camel_define.vhd
acom D:\Telops\Common_HDL\Common_Projects\CAMEL\dpb_define.vhd
do compile_rtl.do Pattern_gen	

make_ngc.bat

label end