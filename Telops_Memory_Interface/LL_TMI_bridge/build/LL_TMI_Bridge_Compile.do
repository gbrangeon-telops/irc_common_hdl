--------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_Bridge_Compile.do
-- Author      : Patrick Daraiche
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : Script to compile the LL_TMI_Bridge Entity
--               
--
---------------------------------------------------------------------------------------------------

-- optimization level			 
set OPT -O3
-- compile with debug information
set OPT -dbg					


acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/ll_tmi_pkg.vhd"


acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_AOI_Add_Gen.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_read.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_write.vhd"

acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_Read_AOI.bde"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_Write_AOI.bde"

acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_Read_AOI_1.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_Read_AOI_24.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_Read_AOI_32.vhd"

acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_Write_AOI_24.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/ll_tmi_bridge_a21_d24.bde"

acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_WB.vhd"

acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/ll_tmi_read_a10_d24.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/ll_tmi_read_a21_d32.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/ll_tmi_read_AOI_WB_a21_d32.bde"   

acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_WB_1WR_2RD.vhd"
acom -work Common_HDL "D:\telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge/src/LL_TMI_RD_SELEC.vhd"


