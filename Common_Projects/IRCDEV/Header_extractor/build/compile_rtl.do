@onerror
{
goto end
}

#savealltabs
#setactivelib work
#clearlibrary
#

#acom $COMMON_HDL/Common_Projects/Camel_define.vhd
#acom $COMMON_HDL/Common_Projects/CAMEL/dpb_define.vhd
#acom $COMMON_HDL/Utilities/sync_reset.vhd
acom -work $1 $COMMON_HDL/Common_Projects/CAMEL/Header_extractor/src/header_extractor32.vhd
acom -work $1 $COMMON_HDL/Common_Projects/CAMEL/Header_extractor/src/HX_WB_Interface.vhd 
acom -work $1 $COMMON_HDL/Common_Projects/CAMEL/Header_extractor/src/Header_Extractor_32_WB.bde

label end		 


