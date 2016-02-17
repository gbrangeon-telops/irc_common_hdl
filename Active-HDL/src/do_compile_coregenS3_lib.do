 @onerror
{
goto end
}

#setenv LIBPATH "$DSN\.."
setenv LIBPATH "D:\Telops\Common_HDL"		 

setenv FAMILY "Spartan3"

-- optimization level
set OPT -O3
-- compile with debug information
set OPT -dbg


-- For LocalLink_Fifo8
acom  -work Common_HDL "$LIBPATH\coregen_S3\as_fifo_w10_d15.vhd"  
acom  -work Common_HDL "$LIBPATH\coregen_S3\s_fifo_w10_d16.vhd"  


label end     
#runscript "$LIBPATH\Active-HDL\src\beep.tcl"	   	  