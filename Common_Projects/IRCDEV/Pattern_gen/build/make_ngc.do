@onerror
{
goto end
}	 

cd  $COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/build\

acom $COMMON_HDL/Common_Projects/Camel_define.vhd
acom $COMMON_HDL/Common_Projects/CAMEL/dpb_define.vhd
do compile_rtl.do Pattern_gen	

make_ngc.bat

label end