@onerror
{
goto end
}														

do "$COMMON_HDL/Telops_Memory_Interface/TMI_MDP_ZBT_Ctrl/build/compile_rtl.do" 

# Testbench stuff	
acom "$COMMON_HDL/Utilities/gen_areset.vhd"
acom "$COMMON_HDL/Utilities/dcm_reset.vhd"
acom "$COMMON_HDL/Utilities/SRL_Reset.vhd"
acom "D:/Telops/FIR-00186/src/Clocks/main_dcm.vhd"
acom "D:/telops/FIR-00180-IRC/src/Clocks/locallink_clk_dcm.vhd"
	 
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/conversions.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/gen_utils.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/package_utility.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/cy7c1372c.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/idt71v65803.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/Testbench/mt55l256l32p.vhd"
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/generic_zbt.vhd"	
acom "$COMMON_HDL/zbt_ctrl/active-hdl/src/zbt_models/zbt_wrapper.vhd"	
acom "$COMMON_HDL/Utilities/wiredly.vhd"

acom "$dsn/src/clk160_dcm.vhd" 
acom "$COMMON_HDL/Utilities/rand_sequence.vhd" 
acom "$dsn/src/TMI_MDP_ZBT_top_level.bde" 
acom "$dsn/src/TMI_MDP_ZBT_top_level2.bde" 

acom "$COMMON_HDL/Telops_Memory_Interface/TMI_BusyBreak.vhd"

acom "$dsn/src/top_level_tb.bde"
acom "$dsn/src/top_level_tb2.bde"

asim -ses top_level_tb2	 

#do "$dsn/src/wave_signals.do"
#do "$dsn/src/wave_signals_self_tests.do"
do "$dsn/src/wave_more_signals.do"
#do "$dsn/src/wave_signals_zbt_ctrl.do"
do "$dsn/src/stimulators.do"

--run 475ns
run 540us

