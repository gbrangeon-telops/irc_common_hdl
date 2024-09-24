@onerror
{
goto end
}	 

cd  $COMMON_HDL/Common_Projects/CAMEL/Header_extractor/build\

acom $COMMON_HDL/Common_Projects/Camel_define.vhd
acom $COMMON_HDL/Common_Projects/CAMEL/dpb_define.vhd
#acom $COMMON_HDL/Utilities/sync_reset.vhd
do compile_rtl.do Header_extractor	

make_ngc.bat

label end