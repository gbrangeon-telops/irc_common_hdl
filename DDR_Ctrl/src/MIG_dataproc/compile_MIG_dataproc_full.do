# Wrapper
do D:\telops\Common_HDL\DDR_Ctrl\ddr_wrapper_128d_27a_r1\compile_complete.do

# DIMM model
do D:\telops\Common_HDL\DDR_Ctrl\src\Model\compile_ddr_model.do

# Simple Design Actual code
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\MIG_dataproc\ddr_dcm.vhd"
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\MIG_dataproc\main_dcm.vhd"
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\MIG_dataproc\intf_acces_gen.vhd"
acom  "D:\telops\Common_HDL\DDR_Ctrl\src\MIG_dataproc\MIG_dataproc_top.bde"

# Simnple Design Testbench
acom  "$DSN\src\Testbench\mig_dataproc_top_TB.vhd"



