@onerror
{
goto end
}														

do "D:\Telops\Common_HDL\ZBT_Ctrl\src\compile_rtl.do" ZBT_Ctrl

# Testbench stuff	
acom  "D:\Telops\Common_HDL\Utilities\gen_areset.vhd"
acom  "D:\Telops\Common_HDL\Utilities\dcm_reset.vhd"
acom  "D:\Telops\Common_HDL\Utilities\SRL_Reset.vhd"
acom  "D:\Telops\FIR-00186\src\Clocks\main_dcm.vhd"
acom  "D:\Telops\FIR-00186\src\Clocks\zbt_clk_intern.vhd"
acom  "D:\Telops\FIR-00186\src\Clocks\zbt_clk_extern.vhd"
acom D:\Telops\Common_HDL\ZBT_Ctrl\Active-HDL\src\ZBT_Ctrl_Top_Level.bde
	   	  
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/conversions.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/gen_utils.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/package_utility.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/cy7c1372c.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/idt71v65803.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/Testbench/mt55l256l32p.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/generic_zbt.vhd"	
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/zbt_wrapper.vhd"	
acom "D:\Telops\Common_HDL\Utilities/wiredly.vhd"

acom  "$dsn\src\Testbench\top_level_tb.bde"

asim -ses top_level_tb	 

--do "$dsn\src\Testbench\wave_signals.do"
--do "$dsn\src\Testbench\stimulators.do"

run 800 ns



