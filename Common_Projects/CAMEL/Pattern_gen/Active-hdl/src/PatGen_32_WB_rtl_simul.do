@onerror
{
goto end
}

savealltabs
setactivelib work
clearlibrary

adel uc2_model
cd $DSN/src/systemc
buildc uc2_model.dlm	
addfile uc2_model.dll
addsc uc2_model.dll	

acom "$COMMON_HDL/Common_Projects/CAMEL_define.vhd"
acom "$COMMON_HDL/Common_Projects/CAMEL/DPB_define.vhd"
#acom "$COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/src/pattern_gen_32.vhd"
#acom "$COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/src/PatGen_WB_interface.vhd"
#acom "$DSN/src/pixel_decoder.vhd"
#acom "$COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/src/patgen_32_wb.bde"

do "$COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/build/compile_rtl.do" Pattern_gen

acom "$COMMON_HDL/Wishbone/MEM0001a.VHD"
acom "$COMMON_HDL/Wishbone/rs232_syscon/rs232_syscon.VHD"
acom "$COMMON_HDL/Wishbone/wb_intercon_8s.vhd"
acom "$COMMON_HDL/Wishbone/uc2_wb_master.vhd"
acom "$COMMON_HDL/Active-HDL/compile/uc2_block_8s.vhd"
acom "$COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/Active-hdl/src/Testbench/PatGen_32_WB_tb.bde" 


open -wave "$COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/Active-hdl/src/Testbench/Simulation/PatGen_32_WB_RTL_TB.awf" 
#do $COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/Active-hdl/src/patgen_32_wb_tb_stimuli.do
asim -ses patgen_32_wb_tb
run 125 us

label end

 
label end