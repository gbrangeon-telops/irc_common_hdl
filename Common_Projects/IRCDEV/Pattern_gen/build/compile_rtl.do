@onerror
{
goto end
} 

#savealltabs
#SetActiveLib -work
#clearlibrary


#acom D:\Telops\Common_HDL\Common_Projects\Camel_define.vhd
#acom D:\Telops\Common_HDL\Common_Projects\CAMEL\dpb_define.vhd
#acom D:\Telops\Common_HDL\Utilities\sync_reset.vhd
acom -work $1 D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\hot_bb_igm.vhd
acom -work $1 D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\cold_bb_igm.vhd
acom -work $1 D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\scene_igm.vhd
acom -work $1 D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\igm_generator.vhd
acom -work $1 D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\pattern_gen_32.vhd
acom -work $1 D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\patgen_wb_interface.vhd	
acom -work $1 D:\Telops\Common_HDL\Common_Projects\CAMEL\Pattern_gen\src\patgen_32_wb.bde

label end