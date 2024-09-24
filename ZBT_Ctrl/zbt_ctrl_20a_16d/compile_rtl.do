@onerror
{
goto end
}						   

savealltabs
setactivelib work
clearlibrary 	

acom "$COMMON_HDL/ZBT_Ctrl/src/Memory_Rqst_Fifo_interface.vhd"	
acom  "$COMMON_HDL/ZBT_Ctrl/src/ZBT_Ctrl_Interface.vhd"
acom  "$COMMON_HDL/ZBT_Ctrl/src/ZBT_Std_ctrler.vhd"
acom "$COMMON_HDL/ZBT_Ctrl/src/ZBT_CONTROL.bde" 
acom  "$COMMON_HDL/ZBT_Ctrl/zbt_ctrl_20a_16d/zbt_ctrl_20a_16d.vhd"


label end