do $DSN/src/compile_sources.do

open -wave "$dsn\src\Waveforms\General.awf"
open -wave "$dsn\src\Waveforms\RS232.awf"
#open -wave "$dsn\src\Waveforms\Pat_Gen.awf"
#open -wave "$dsn\src\Waveforms\HeaderX.awf"
#open -wave "$dsn\src\Waveforms\Mem_Write.awf"  
#open -wave "$dsn\src\Waveforms\ZBT.awf"
#open -wave "$dsn\src\Waveforms\DDR.awf"
open -wave "$dsn\src\Waveforms\FFT.awf"	
open -wave "$dsn\src\Waveforms\FFT_core.awf"
open -wave "$dsn\src\Waveforms\FFT_scale.awf"
#open -wave "$dsn\src\Waveforms\DDR_Dimm.awf"
#open -wave "$dsn\src\Waveforms\Mem_Read.awf"
#open -wave "$dsn\src\Waveforms\CLI.awf"


asim -ses DPB_Alone_TB
#asim -ses ddr_structure
run 100 us; 