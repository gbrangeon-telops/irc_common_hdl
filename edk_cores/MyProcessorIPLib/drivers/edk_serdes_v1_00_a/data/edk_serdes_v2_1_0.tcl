##############################################################################
## Filename:          D:\telops\edk_cores\MyProcessorIPLib/drivers/edk_serdes_v1_00_a/data/edk_serdes_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Tue Jan 08 09:14:48 2008 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "edk_serdes" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
