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

acom "$DSN/../../../camel_define.vhd"
acom "$DSN/../../dpb_define.vhd"
acom "$DSN/../src/pattern_gen_32.vhd"
acom "$DSN/../src/patgen_wb_interface.vhd"
-- acom "$DSN/src/pixel_decoder.vhd"
acom "$DSN/../src/patgen_32_wb.bde"

acom "$DSN/../../../../wishbone/mem0001a.vhd"
acom "$DSN/../../../../wishbone/rs232_syscon/rs232_syscon.vhd"
acom "$DSN/../../../../wishbone/wb_intercon_8s.vhd"
acom "$DSN/../../../../wishbone/uc2_wb_master.vhd"
acom "$DSN/../../../../ultracontroller-ii/uc2_block_8s.bde"
acom "$DSN/src/test_bench/patgen_32_wb_tb.bde"
 
label end