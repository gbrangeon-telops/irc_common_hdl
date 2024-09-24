 @onerror
{
goto end
}

#setenv LIBPATH "$DSN/.."
setenv LIBPATH "$COMMON_HDL"		 

setenv FAMILY "Virtex4"

-- optimization level
set OPT -O3
-- compile with debug information
set OPT -dbg

------------------------------------------------------
-- Compile library Common_HDL
------------------------------------------------------
#alib Common_HDL "$LIBPATH/Active-HDL/Common_HDL.lib"
#amap -global Common_HDL "$LIBPATH/Active-HDL/Common_HDL.lib"
#setlibrarymode -rw Common_HDL 
--clearlibrary Common_HDL

-- Coregen														   
## For DDR_Ctrl
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w128_d64.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w144_d64.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w155_d32.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w171_d32.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w27_d32.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w2_d64.vhd"
#
#-- For ZBT ctrl
acom   -work Common_HDL "$LIBPATH/CoreGen_v4/fwft_fifo_w21_d16.vhd" 
acom   -work Common_HDL "$LIBPATH/CoreGen_v4/fwft_fifo_w57_d16.vhd"
acom   -work Common_HDL "$LIBPATH/CoreGen_v4/fwft_fifo_w37_d16.vhd"
#acom   -work Common_HDL "$LIBPATH/CoreGen_v4/as_fifo_w16_d31.vhd"
#acom   -work Common_HDL "$LIBPATH/CoreGen_v4/as_fifo_w36_d31.vhd"
 
-- For LocalLink_Fifo24 
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w26_d15.vhd"  

-- For LocalLink_Fifo32
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d16.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d64.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d512.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d2048.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d4096.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d65536.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d15.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d511.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d8191.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d32767.vhd"	 

-- other fifos
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w128_d511.vhd"  
--acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w128_d64.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w144_d64.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w155_d32.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w16_d15.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w171_d32.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w18_d15.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w18_d1023.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w18_d1024.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w18_d63.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w18_d8191.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w23_d511.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w23_d63.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w27_d32.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w32_d16.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d15.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d32767.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d511.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w36_d8191.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w64_d15.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w64_d32.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w8_d128.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w8_d15.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w8_d16.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w10_d15.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w2_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w2_d32.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w2_d512.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w23_d16.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w33_d64.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w34_d64.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w44_d64.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w64_d16.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w85_d16.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w87_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w85_d128.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w128_d16.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w16_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w16_d64.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w18_d16.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w18_d8192.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w2_d16.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w2_d32.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w21_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w23_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w23_d32.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w23_d256.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w24_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w29_d64.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w34_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w34_d256.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d1024.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d16.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w36_d512.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w42_d128.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w44_d64.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w64_d16.vhd"
--acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w8_d1024.vhd" -- la lib xilinxcorelib de active-hdl 8.1 sp1 ne supporte pas fifo_generator_v2_3
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w8_d2048.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w8_d16.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w8_d64.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w88_d16.vhd"  
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w64_d64.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w23_d32.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w2_d64.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w83_d64.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w32_d16.vhd"	
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w6_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w40_d16.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w40_d512.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w40_d15.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w40_d511.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w40_d8191.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w40_d32767.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w81_d256.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w88_d128.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/fwft_fifo_w87_d128.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w85_d128.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w64_d256.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w87_d128.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w16_d15.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w67_d64.vhd"
#acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w32_d32.vhd" 

acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w72_d16.vhd"      
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w72_d512.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w72_d511.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w72_d2047.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w72_d4095.vhd"  
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w72_d15.vhd"	  
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w72_d16383.vhd"  	
acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w72_d8191.vhd"  	

#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w10_d15.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d16.vhd"	
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d64.vhd"	
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d256.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d1024.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w3_d1024.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w3_d512.vhd"
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w3_d64.vhd"	  

acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d512.vhd" 
#acom  -work Common_HDL "$LIBPATH/coregen_V4/as_fifo_w10_d15.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d512.vhd" 
acom  -work Common_HDL "$LIBPATH/coregen_V4/s_fifo_w10_d512.vhd" 


-- Multipliers 
acom  -work Common_HDL "$LIBPATH/coregen_V4/mult_20x22_42o.vhd"


-- dividers 
--acom  -work Common_HDL "$LIBPATH/coregen_V4/div_w21x6.vhd" -- la lib xilinxcorelib de active-hdl 8.1 sp1 ne supporte pas sdivider_v3_0
acom  -work Common_HDL "$COMMON_HDL/LocalLink/coregen_V4/div_w24x9.vhd"
--acom  -work Common_HDL "$LIBPATH/coregen_V4/div_w21x6.vhd"

#do "$LIBPATH/Active-HDL/src/do_compile_lib.do"

#do "$LIBPATH/Active-HDL/src/do_compile_coregenV2_lib.do"

label end     
#runscript "$LIBPATH/Active-HDL/src/beep.tcl"	   	  