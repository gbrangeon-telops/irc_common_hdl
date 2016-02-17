SetActiveLib -work

asim gen_extract_32_tb 
wave

-- pattern generator signals
wave -noreg FRAME_TYPE_gen
wave -noreg FRAME_TRIG_gen
wave -noreg PG_CONF_gen
wave -noreg ROIC_HEADER_gen
wave -noreg ROIC_FOOTER_gen
wave -noreg CLINK_CONF_gen
wave -noreg PROC_HEADER_gen
wave -noreg PROC_CONF_gen
wave -noreg DONE_gen
    
-- header extractor signals
wave -noreg NEW_CONFIG_ext
wave -noreg CLINK_CONF_ext
wave -noreg PROC_HEADER_ext
wave -noreg PROC_CONF_ext
wave -noreg NEW_FRAME_ext
wave -noreg FRAME_TYPE_ext
wave -noreg WB_MISO_ext
wave -noreg WB_MOSI_ext

-- common signals
wave -noreg CLK : std_logic;
wave -noreg LL_MISO_gen
wave -noreg LL_MOSI_gen
wave -noreg LL_MISO_ext
wave -noreg LL_MOSI_ext
