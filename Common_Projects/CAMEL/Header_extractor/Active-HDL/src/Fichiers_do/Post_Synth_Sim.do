@onerror
{
goto end
}

savealltabs
setactivelib -post-synthesis
clearlibrary

#adel uc2_model
cd $DSN/src/systemc
buildc uc2_model.dlm	
addfile uc2_model.dll
addsc uc2_model.dll	

			   

acom "$COMMON_HDL/Common_Projects/CAMEL_define.vhd"
acom "$COMMON_HDL/Common_Projects/CAMEL/DPB_define.vhd"
#acom "$DSN/../../../../utilities/double_sync.vhd" 
#acom "$DSN/../../Pattern_gen/src/PatGen_WB_interface.vhd"
#acom "$DSN/../../Pattern_gen/src/pattern_gen_32.vhd"
#acom $DSN/../../Pattern_gen/Active-hdl/src/pixel_decoder.vhd
#acom "$DSN/../../Pattern_gen/src/PatGen_32_WB.bde"	



#VHM 
acom "$COMMON_HDL/Common_Projects/CAMEL/Pattern_gen/build/PatGen_32_WB.vhm"  

acom "$COMMON_HDL/Common_Projects/CAMEL/Header_extractor/build/Header_extractor_32_WB.vhm" 

acom "$COMMON_HDL/Wishbone/ARB0001a.VHD"
acom "$COMMON_HDL/Wishbone/rs232_syscon/rs232_syscon.VHD"
acom "$COMMON_HDL/Wishbone/wb_intercon_8s.vhd"
acom "$COMMON_HDL/Wishbone/uc2_wb_master.vhd"
acom "$COMMON_HDL/Active-HDL/compile/uc2_block_8s.vhd"

acom "$COMMON_HDL/Wishbone/MEM0001a.VHD" 
acom "$COMMON_HDL/LocalLink/LL_RandomBusy32.vhd"
acom "$COMMON_HDL/Common_Projects/CAMEL/Header_extractor/Active-HDL/src/Test_bench/Test_bench_files/LL_randomDREM_32.vhd"

acom "$COMMON_HDL/LocalLink/LL_SW_1_2_32.vhd"   			

acom $COMMON_HDL/LocalLink/LL_Hole.vhd


acom "$COMMON_HDL/LocalLink/LL_16_to_32.vhd"
acom "$COMMON_HDL/LocalLink/LL_32_to_16.vhd"

acom $COMMON_HDL/Common_Projects/CAMEL/Header_extractor/Active-HDL/src/Test_bench/Test_bench_files/PatternGen_Extract_TB.bde

open -wave "$COMMON_HDL/Common_Projects/CAMEL/Header_extractor/Active-HDL/src/Test_bench/Simulation/Simul_post_synth.awf"
asim -ses patterngen_extract_tb	 

force -freeze U9/RANDOM 0 
force -freeze -r 10.000000 ns CLK 0 0 ns 1 5 ns
force -deposit HEXTRACTOR/HX_32_KERNEL/TX_LL_MISO.AFULL 0
force -deposit HEXTRACTOR/HX_32_KERNEL/TX_LL_MISO.BUSY 0
force -freeze RST 1 0 ns, 0 40 ns
force -deposit U1/TX_MISO.AFULL 0
force -deposit U1/TX_MISO.BUSY 0


run 150 us

label end