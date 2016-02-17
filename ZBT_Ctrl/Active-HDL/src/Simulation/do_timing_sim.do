@onerror
{
goto end
}

savealltabs
SetActiveLib -timing 

acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/conversions.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/gen_utils.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/package_utility.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/cy7c1372c/cy7c1372c.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/idt71v65803/idt71v65803.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/Testbench/mt55l256l32p.vhd"
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/generic_zbt.vhd"	
acom "D:/Telops/Common_HDL/zbt_ctrl/active-hdl/src/zbt_models/zbt_wrapper.vhd"	
acom "D:\Telops\Common_HDL\Utilities/wiredly.vhd"


acom  -work ZBT_Ctrl_timing "$dsn\IMPLEMENT\TIME_SIM.VHD"
acom  -work ZBT_Ctrl_timing "$dsn\src\Testbench\mt55l256l32p.vhd"
acom  -work ZBT_Ctrl_timing "$dsn\src\Testbench\top_level_tb.bde"
asim -advdataflow top_level_tb -sdftyp -AUTO="$dsn\IMPLEMENT\TIME_SIM.SDF" 
#open -wave "$dsn\src\Simulation\Timing_simulation.awf"	
#run 10 us
label end

