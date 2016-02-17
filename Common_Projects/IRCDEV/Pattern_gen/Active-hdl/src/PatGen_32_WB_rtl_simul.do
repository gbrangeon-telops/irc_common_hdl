@onerror
{
goto end
}

savealltabs
SetActiveLib -work
clearlibrary

adel uc2_model
cd $DSN/src/systemc
buildc uc2_model.dlm	
addfile uc2_model.dll
addsc uc2_model.dll	

acom "D:\Telops\Common_HDL\Common_Projects\CAMEL_define.vhd"
acom "D:\Telops\Common_HDL\Common_Projects\CAMEL\DPB_define.vhd"
#acom "D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\pattern_gen_32.vhd"
#acom "D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\PatGen_WB_interface.vhd"
#acom "$DSN/src/pixel_decoder.vhd"
#acom "D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\patgen_32_wb.bde"

do "D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\build\compile_rtl.do" Pattern_gen

acom "D:\Telops\Common_HDL\Wishbone\MEM0001a.VHD"
acom "D:\Telops\Common_HDL\Wishbone\rs232_syscon\rs232_syscon.VHD"
acom "D:\Telops\Common_HDL\Wishbone\wb_intercon_8s.vhd"
acom "D:\Telops\Common_HDL\Wishbone\uc2_wb_master.vhd"
acom "D:\Telops\Common_HDL\Active-HDL\compile\uc2_block_8s.vhd"
acom "D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\Active-hdl\src\Testbench\PatGen_32_WB_tb.bde" 


open -wave "D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\Active-hdl\src\Testbench\Simulation\PatGen_32_WB_RTL_TB.awf" 
#do D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\Active-hdl\src\patgen_32_wb_tb_stimuli.do
asim -ses patgen_32_wb_tb
run 125 us

label end

 
label end