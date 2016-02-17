@onerror
{
goto end
}						   

savealltabs
SetActiveLib -work
clearlibrary 	

acom "d:\telops\COMMON_HDL\ZBT_Ctrl\src\Memory_Rqst_Fifo_interface.vhd"	
acom  "d:\telops\COMMON_HDL\ZBT_Ctrl\src\ZBT_Ctrl_Interface.vhd"
acom  "d:\telops\COMMON_HDL\ZBT_Ctrl\src\ZBT_Std_ctrler.vhd"
acom "d:\telops\COMMON_HDL\ZBT_Ctrl\src\ZBT_CONTROL.bde" 
acom  "d:\telops\COMMON_HDL\ZBT_Ctrl\zbt_ctrl_20a_16d\zbt_ctrl_20a_16d.vhd"


label end