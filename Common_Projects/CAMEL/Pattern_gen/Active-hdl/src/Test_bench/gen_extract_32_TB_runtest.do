setactivelib work
comp -include "$DSN/src/FIR_00142/pattern_gen_32.vhd"
comp -include "$DSN/src/FIR_00142/Header_Extractor32.vhd" 
comp -include "$DSN/src/TestBench/Misc_Test/gen_extract_32_TB.vhd" 
asim gen_extract_32_tb 
wave

-- pattern generator signals
wave -noreg FRAME_TRIG_gen
wave -noreg FRAME_TYPE_gen
wave -noreg ROIC_HEADER_gen
wave -noreg ROIC_FOOTER_gen
wave -noreg CLINK_CONF_gen
wave -noreg PROC_HEADER_gen
wave -noreg PROC_CONF_gen
wave -noreg DONE_gen
    
-- header extractor signals
wave -noreg NEW_CONFIG_ext
wave -noreg ROIC_HEADER_ext
wave -noreg ROIC_FOOTER_ext
wave -noreg CLINK_CONF_ext
wave -noreg PROC_HEADER_ext
wave -noreg PROC_CONF_ext
wave -noreg NEW_FRAME_ext
wave -noreg FRAME_TYPE_ext
    
-- common signals
wave -noreg CLK : std_logic;
wave -noreg LL_MISO_gen : t_ll_miso;
wave -noreg LL_MOSI_gen : t_ll_mosi32;
wave -noreg LL_MISO_ext : t_ll_miso;
wave -noreg LL_MOSI_ext : t_ll_mosi32;