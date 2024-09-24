@onerror
{
goto end
}														

do "$COMMON_HDL/ZBT_Ctrl/src/compile_rtl.do" ZBT_Ctrl

# Testbench stuff	
acom  "$COMMON_HDL/Utilities/gen_areset.vhd"
acom  "$COMMON_HDL/Utilities/dcm_reset.vhd"
acom  "$COMMON_HDL/Utilities/SRL_Reset.vhd"
acom  "D:/Telops/FIR-00186/src/Clocks/main_dcm.vhd"
acom  "D:/Telops/FIR-00186/src/Clocks/zbt_clk_intern.vhd"
acom  "D:/Telops/FIR-00186/src/Clocks/zbt_clk_extern.vhd"
acom $COMMON_HDL/ZBT_Ctrl/Active-HDL/src/ZBT_Ctrl_Top_Level.bde
	   	  
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/conversions.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/gen_utils.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/package_utility.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/cy7c1372c.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/idt71v65803.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/Testbench/mt55l256l32p.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/generic_zbt.vhd"	
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/zbt_wrapper.vhd"	
acom "$COMMON_HDL/Utilities/wiredly.vhd"

acom  "$dsn/src/Testbench/top_level_tb.bde"

asim -ses top_level_tb	 

--do "$dsn/src/Testbench/wave_signals.do"
--do "$dsn/src/Testbench/stimulators.do"

run 800 ns



