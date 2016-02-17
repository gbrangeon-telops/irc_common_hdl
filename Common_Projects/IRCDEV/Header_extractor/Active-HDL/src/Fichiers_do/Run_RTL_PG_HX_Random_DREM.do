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


 # chemins  explicites
#acom "$DSN/../../../camel_define.vhd"
#acom "$DSN/../../dpb_define.vhd"
#acom "$DSN/../../../../utilities/double_sync.vhd" 
#acom "$DSN/../../Pattern_gen/src/PatGen_WB_interface.vhd"
#acom "$DSN/../../Pattern_gen/src/pattern_gen_32.vhd"
#acom "$DSN/../../Pattern_gen/src/PatGen_32_WB.bde"	  
do D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\build\compile_rtl.do

do D:\Telops\Common_HDL\Common_Projects\CAMEL\Header_extractor\build\compile_rtl.do

#acom "$DSN/../src/header_extractor32.vhd"
#acom "$DSN/../src/HX_WB_Interface.vhd"
#acom "$DSN/../src/Header_Extractor_32_WB.bde" 

acom "D:\Telops\Common_HDL\Wishbone\ARB0001a.VHD"
acom "D:\Telops\Common_HDL\Wishbone\rs232_syscon\rs232_syscon.VHD"
acom "D:\Telops\Common_HDL\Wishbone\wb_intercon_8s.vhd"
acom "D:\Telops\Common_HDL\Wishbone\uc2_wb_master.vhd"
acom "D:\Telops\Common_HDL\Active-HDL\compile\uc2_block_8s.vhd"

acom "D:\Telops\Common_HDL\Wishbone\MEM0001a.VHD" 
acom "D:\Telops\Common_HDL\LocalLink\LL_RandomBusy32.vhd"

acom "D:\Telops\Common_HDL\LocalLink\LL_SW_1_2_32.vhd"   			

acom D:\Telops\Common_HDL\LocalLink\LL_Hole.vhd


acom "D:\Telops\Common_HDL\LocalLink\LL_16_to_32.vhd"
acom "D:\Telops\Common_HDL\LocalLink\LL_32_to_16.vhd"


acom "D:\Telops\Common_HDL\Common_Projects\CAMEL\Header_extractor\Active-HDL\src\Test_bench\Test_bench_files\LL_randomDREM_32.vhd"

acom "D:\Telops\Common_HDL\Common_Projects\CAMEL\Header_extractor\Active-HDL\src\Test_bench\Test_bench_files\PatternGen_Extract_TB.bde"	

asim -ses patterngen_extract_tb
force -freeze U9/RANDOM 1 
open -wave "D:\Telops\Common_HDL\Common_Projects\CAMEL\Header_extractor\Active-HDL\src\Test_bench\Simulation\PG_HX_RTL_simul.awf"
#force -freeze U9/RANDOM 0 
force -freeze -r 10.000000 ns CLK 0 0 ns 1 5 ns
force -deposit HEXTRACTOR/HX_32_KERNEL/TX_LL_MISO.AFULL 0
force -deposit HEXTRACTOR/HX_32_KERNEL/TX_LL_MISO.BUSY 0
force -freeze RST 1 0 ns, 0 40 ns
force -deposit U1/TX_MISO.AFULL 0
force -deposit U1/TX_MISO.BUSY 0



run 125 us

label end