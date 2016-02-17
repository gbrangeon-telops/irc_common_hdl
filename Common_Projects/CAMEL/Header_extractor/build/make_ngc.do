@onerror
{
goto end
}	 

cd  D:\Telops\Common_HDL\Common_Projects\CAMEL\Header_extractor\build\

acom D:\Telops\Common_HDL\Common_Projects\Camel_define.vhd
acom D:\Telops\Common_HDL\Common_Projects\CAMEL\dpb_define.vhd
#acom D:\Telops\Common_HDL\Utilities\sync_reset.vhd
do compile_rtl.do Header_extractor	

make_ngc.bat

label end