SetActiveLib -work
comp -include "d:\Telops\Common_HDL\Telops_Memory_Interface\LL_TMI_bridge\src\LL_AOI_Add_Gen.vhd" 
comp -include "$dsn\src\ll_aoi_add_gen_TB.vhd" 
asim TESTBENCH_FOR_ll_aoi_add_gen 
open -wave "$dsn\src\ll_aoi_add_gen.wfm"
open -wave "$dsn\src\ll_aoi_add_gen_TB.wfm"

run

open -txt "$dsn\src\add_out.raw"

endsim 

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\ll_aoi_add_gen_TB_tim_cfg.vhd" 
# asim TIMING_FOR_ll_aoi_add_gen 
