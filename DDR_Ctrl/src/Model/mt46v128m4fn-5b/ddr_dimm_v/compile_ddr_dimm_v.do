
#alib ddr_dimm_v "D:\Telops\Common_HDL\DDR_Ctrl\src\Model\mt46v128m4fn-5b\ddr_dimm.lib"
amap -global ddr_dimm_v "D:\Telops\Common_HDL\DDR_Ctrl\src\Model\mt46v128m4fn-5b\ddr_dimm_v\ddr_dimm_v.lib"
setlibrarymode -rw ddr_dimm_v 
clearlibrary 		

acom -o -work ddr_dimm_v D:\Telops\Common_HDL\DDR_Ctrl\src\Model\ddr_define.vhd
acom -o -work ddr_dimm_v D:\Telops\Common_HDL\DDR_Ctrl\src\Model\ddr_registers.vhd
acom -o -work ddr_dimm_v D:\Telops\Common_HDL\DDR_Ctrl\src\Model\ddr_command_decoder.vhd

#alog  "D:\Telops\Common_HDL\DDR_Ctrl\src\Model\mt46v128m4fn-5b\ddr_parameters.vh"
alog  -w ddr_dimm_v "D:/Telops/Common_HDL/DDR_Ctrl/src/Model/mt46v128m4fn-5b/mt46v128m4fn_5b.v"
 
acom -o -work ddr_dimm_v D:\Telops\Common_HDL\DDR_Ctrl\src\Model\mt46v128m4fn-5b\MT36VDDF25672.bde
setlibrarymode -ro ddr_dimm_v
