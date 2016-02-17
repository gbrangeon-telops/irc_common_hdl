@onerror
{
goto end
}

#setenv LIBPATH "$DSN\.."
setenv LIBPATH "D:\Telops\Common_HDL"  

setenv FAMILY "Virtex2"

# optimization level
set OPT -O3
# compile with debug information
set OPT -dbg

#-----------------------------------------------------
# Compile library Common_HDL
#-----------------------------------------------------
alib Common_HDL "$LIBPATH\Active-HDL\Common_HDL.lib"
amap -global Common_HDL "$LIBPATH\Active-HDL\Common_HDL.lib"
setlibrarymode -rw Common_HDL 
#clearlibrary Common_HDL

-- Coregen
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w128_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w8_d15.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w16_d15.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w16_d16383.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w16_d32767.vhd"	
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w18_d15.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w18_d63.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w18_d511.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w18_d8191.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w20_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w23_d63.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w23_d511.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\div_w21x6.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\div_w29_r4.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\div_w30x15.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\dpram_w16_d512.vhd"

#acom  -work Common_HDL "$LIBPATH\CoreGen\fwft_fifo_w1_d32.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\fwft_fifo_w3_d32.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\fwft_fifo_w21_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\fwft_fifo_w29_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\fwft_fifo_w128_d16.vhd"
--acom  -work Common_HDL "$LIBPATH\CoreGen\mult_20x22_42o.vhd" -- Conflicts with the Virtex-4 version.
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w6_d32.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w8_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w8_d1024.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w8_d2048.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w16_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w10_d256.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w18_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w18_d16384.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w23_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w23_d256.vhd"
acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w24_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w27_d16.vhd" 
-- currently implemented fifos for Localink_Fifo_32
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w36_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w36_d512.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w36_d15.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w36_d511.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w36_d16383.vhd"
-- currently implemented fifos for Localink_Fifo_64
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w72_d16.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\s_fifo_w72_d512.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w72_d15.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w72_d511.vhd"
#acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w72_d4095.vhd"
acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w72_d8191.vhd"   
acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w72_d16383.vhd"
acom  -work Common_HDL "$LIBPATH\CoreGen\as_fifo_w36_d8191.vhd"
edfcomp -work Common_HDL "$LIBPATH\CoreGen\ddr_core.edn"	   

#do "$LIBPATH\Active-HDL\src\do_compile_lib.do"

-- reactivate default work library at end of script
label end     
#runscript "$LIBPATH\Active-HDL\src\beep.tcl"

--setactivelib -work
