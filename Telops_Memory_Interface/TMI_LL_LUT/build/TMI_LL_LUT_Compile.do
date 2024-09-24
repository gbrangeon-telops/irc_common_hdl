--------------------------------------------------------------------------------------------------
--
-- Title       : TMI_LL_LUT_Compile.do
-- Author      : Patrick Daraiche
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : Script to compile the TMI_LL_LUT Controler Entity
--               
--
---------------------------------------------------------------------------------------------------

-- optimization level			 
set OPT -O3
-- compile with debug information
set OPT -dbg					



#acom "$COMMON_HDL/Telops_Memory_Interface/LL_TMI_bridge/src/LL_TMI_Read.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/LL_TMI_bridge/src/LL_TMI_read_d32.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/LL_TMI_bridge/src/LL_TMI_read_a21_d32.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/LL_TMI_bridge/src/LL_TMI_read_a10_d24.vhd"

acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/X_to_ADD.bde"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/X_to_ADD_ADV.bde"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/LUT_Ctrl.vhd"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/TMI_LL_LUT_a21_d32.bde"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/TMI_LL_LUT_a21_d32_adv.bde"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/TMI_LL_LUT_a10_d24.bde"

-- fix point version
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/sysgen/x_to_add_fix_mcw_sim.vhd"
#acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/sysgen/netlist/x_to_add_fix.vhd"
#acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/sysgen/netlist/x_to_add_fix_mcw.vhd"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/sysgen/LL_SysGenIN_Wrap16.vhd"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/sysgen/LL_SysGenOUT_Wrap16.vhd"
acom -work Common_HDL "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_LUT/src/X_to_ADD_fix_16.bde"
