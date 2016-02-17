#do $DSN/src/compile_sources.do             

acom "$DSN/src/DPB_CLink/DPB_CLink.bde"	

if 1
	open -wave "$dsn\src\Waveforms\General.awf"
	open -wave "$dsn\src\Waveforms\RS232.awf"
	open -wave "$dsn\src\Waveforms\Pat_Gen.awf"
	#open -wave "$dsn\src\Waveforms\HeaderX.awf"
	open -wave "$dsn\src\Waveforms\Mem_Write.awf"  
	#open -wave "$dsn\src\Waveforms\ZBT.awf"
	#open -wave "$dsn\src\Waveforms\DDR.awf"
	#open -wave "$dsn\src\Waveforms\FFT.awf"
	#open -wave "$dsn\src\Waveforms\fft_scale.awf"
	#open -wave "$dsn\src\Waveforms\fft_core.awf"
	#open -wave "$dsn\src\Waveforms\fft_unloader_ctrl.awf"
	#open -wave "$dsn\src\Waveforms\DDR_Dimm.awf"
	open -wave "$dsn\src\Waveforms\Mem_Read.awf"
	#open -wave "$dsn\src\Waveforms\CLI.awf"
	open -wave "$dsn\src\Waveforms\FIR142.awf"
	open -wave "$dsn\src\Waveforms\FIR186.awf"
	#open -wave "$dsn\src\Waveforms\ROIC_Pat_Gen.awf"
	#open -wave "$dsn\src\Waveforms\Mem_Write_Simple.awf"
	#open -wave "$dsn\src\Waveforms\Calibration.awf"
	#open -wave "$dsn\src\Waveforms\Calib_core.awf"
	#open -wave "$dsn\src\Waveforms\Calib_ctrl.awf"
endif


#asim -ses dpb_clink -stack 256 -retval 128
asim -ses dpb_clink
#asim -ses -asdb  -asdbrefresh 10 dpb_clink sch	

#---------------------
# Pattern generator
#---------------------   
trace -rec DPB/FPGA1/S6/*   

#---------------------
# Header extractor
#--------------------- 
trace -rec DPB/FPGA1/S10/

#---------------------
# RS232 & UC2
#---------------------
#trace DPB/FPGA2/S5/U19/*
#trace DPB/FPGA2/S5/ROIC/*
#trace DPB/FPGA2/S5/CLINK/*
#trace DPB/FPGA2/S5/U21/*
#trace DPB/FPGA1/M0/*

#---------------------
# Averaging bug
#---------------------
#trace DPB/FPGA1/S1/*
trace -rec DPB/FPGA1/S1/NGC/Mem_Write_kernel/*
#trace DPB/FPGA1/DDR/*
#trace DPB/FPGA1/DDR/ddr/ddr_arbitrator/*
#trace DPB/FPGA1/DDR/ddr/ddr_test/*
#trace DPB/FPGA1/DDR/ddr/ddr_test/mem_test_controller/*	

#---------------------
# Mem read
#---------------------
#trace DPB/FPGA1/S2/*
#trace DPB/FPGA1/S2/big_process/*

#---------------------
# End Time Stamp bug
#---------------------
#trace DPB/FPGA1/S6/PATTERN_GEN_KERNEL/*
#trace DPB/FPGA1/S10/*
#trace DPB/FPGA1/S10/HEADER_EXT_WB/*
#trace DPB/FPGA1/S10/HX_32_KERNEL/*
#trace DPB/FPGA1/S4/*   
#trace CLINK/ODD_HX/*
#trace CLINK/CLINK_HDR/*

#---------------------
# Mem Write ZBT		  
#---------------------
#trace DPB/FPGA1/S1/ZBT_Ctler/ZBT_CONTRL_INTERFACE/auto_detect/auto_detect_proc/*
#trace DPB/FPGA1/S1/ZBT_Ctler/ZBT_CONTRL_INTERFACE/*
#trace DPB/ZBT1_2/*

#---------------------
# FFT ZBT			  
#---------------------
#trace DPB/FPGA1/S3/ZBT/ZBT_CONTRL_INTERFACE/*
#trace -rec DPB/FPGA1/S3/ZBT/ZBT_CONTRL_INTERFACE/auto_detect/* 			 
#trace DPB/ZBT1_1/*		

#---------------------
# FFT ZBT write		  
#---------------------
#trace -rec DPB/FPGA1/S3/NGC/U2/REAL_ADD_GEN/* 
					  
#---------------------					  
# FFT interface		  
#---------------------
#trace DPB/FPGA1/S3/* 

#---------------------
# FFT Scaling		  
#---------------------
#trace DPB/FPGA1/S3/NGC/U2/scaling/* 
#trace DPB/FPGA1/S3/NGC/U2/scaling/FFT_DataSender/* 
#trace DPB/FPGA1/S3/NGC/U2/CLIP/*

#---------------------
# FFT core			  
#---------------------
#trace DPB/FPGA1/S3/NGC/U3/*

run 5 ms; 