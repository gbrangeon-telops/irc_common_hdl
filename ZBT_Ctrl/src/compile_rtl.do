@onerror
{
goto end
}						   

acom -work $1 "D:\Telops\Common_HDL\LFSR\image_pb.vhd"
acom -work $1 "D:\Telops\Common_HDL\LFSR\lfsrstd.vhd"

acom -work $1 "d:\telops\COMMON_HDL\ZBT_Ctrl\src\Memory_Rqst_Fifo_interface.vhd"	
acom -work $1 "d:\telops\COMMON_HDL\ZBT_Ctrl\src\ZBT_Ctrl_Interface.vhd"
acom -work $1 "d:\telops\COMMON_HDL\ZBT_Ctrl\src\ZBT_Std_ctrler.vhd"
acom -work $1 "d:\telops\COMMON_HDL\ZBT_Ctrl\src\ZBT_CONTROL.bde" 

label end