# MIG Core
#do D:\telops\Common_HDL\DDR_Ctrl\src\MIG_dualrank_stable_100Mhz\compile_MIG.do
#do D:\telops\Common_HDL\DDR_Ctrl\src\MIG\compile_MIG.do
do D:\telops\Common_HDL\DDR_Ctrl\src\MIG2\compile_MIG.do

# Tester
do D:\telops\Common_HDL\DDR_Ctrl\src\DDR_tester\compile_tester.do

# Interface
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\DDR_Interface\DDR_Interface_FSM.vhd"
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\DDR_Interface\DDR_Interface.vhd"
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\DDR_Interface\mig_adapt.vhd"
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\DDR_Interface\ddr_wishbone.vhd"
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\DDR_Interface\ddr_top.bde"
