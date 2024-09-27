@onerror
{
goto end
}

design activate common_hdl

#! clean_lib.bat

setenv LIBPATH "$COMMON_HDL"

------------------------------------------------------
-- Compile library Common_HDL
------------------------------------------------------
alib Common_HDL "$LIBPATH/Active-HDL/Common_HDL.lib"
amap -global Common_HDL "$LIBPATH/Active-HDL/Common_HDL.lib"
setlibrarymode -rw Common_HDL 

------------------------------------------------------
-- Compile CoreGen components						  
------------------------------------------------------
# Needed for CameraLink
do "$LIBPATH/Active-HDL/src/do_compile_coregenV2_lib.do"
#do "$LIBPATH/Active-HDL/src/do_compile_coregenV4_lib.do"
#do "$LIBPATH/Active-HDL/src/do_compile_coregenS3_lib.do"

------------------------------------------------------
-- Compile library ieee_proposed
------------------------------------------------------
#alib IEEE_proposed "$LIBPATH/VHDL-200x/IEEE_proposed/IEEE_proposed.lib"
#amap -global IEEE_proposed "$LIBPATH/VHDL-200x/IEEE_proposed/IEEE_proposed.lib"
#setlibrarymode -rw IEEE_proposed	 	   
#do "$COMMON_HDL/VHDL-200x/IEEE_proposed/src/compile_lib.do"			   

alib IEEE_proposed_2010 "$LIBPATH/VHDL-2008/IEEE_proposed_2010/IEEE_proposed_2010.lib"
amap -global IEEE_proposed_2010 "$LIBPATH/VHDL-2008/IEEE_proposed_2010/IEEE_proposed_2010.lib"
setlibrarymode -rw IEEE_proposed_2010
do "$COMMON_HDL/VHDL-2008/IEEE_proposed_2010/src/compile_lib.do"			   

------------------------------------------------------
-- Compile library Common_HDL
------------------------------------------------------
setlibrarymode -rw Common_HDL 

-- Set to 1 to use post-synthesis models, 0 otherwise
setenv POST_SYNTH_MODELS 0

acom  -work Common_HDL "$LIBPATH/Telops.vhd" 
acom  -work Common_HDL "$LIBPATH/LFSR/image_pb.vhd"
acom  -work Common_HDL "$LIBPATH/LFSR/LfsrStd.vhd"

-- Utilities
acom  -work Common_HDL "$LIBPATH/Utilities/daisychain_fd.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/clk_divider_pulse.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/Clk_Divider.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/double_sync.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/sync_reset.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/fast_fifo_reader.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/fifo_2byte.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/double_sync_vector.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/Pulse_gen.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/LocalLink_FifoX.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/div_gen_dval.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/Pwr_ON_Reset.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/SRL_Reset.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/idelay_ctrl_gen.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/ram_dist.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/ram_dist_dp.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/pwm.vhd" 
acom  -work Common_HDL "$LIBPATH/Utilities/sp_ram.vhd" 
acom  -work Common_HDL "$LIBPATH/Utilities/dp_ram.vhd" 
acom  -work Common_HDL "$LIBPATH/Utilities/dp_ram_dualclock.vhd" 
acom  -work Common_HDL "$LIBPATH/Utilities/gen_areset.vhd" 
acom  -work Common_HDL "$LIBPATH/Utilities/dcm_reset.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/sync_rising_edge.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/sync_pulse.vhd"		   
acom  -work Common_HDL "$LIBPATH/Utilities/sfifo.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/fifo_lib.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/SVN_Extractor.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/shift_reg.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/telops_testing.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/rand_sequence.vhd"	   	 
acom  -work Common_HDL "$LIBPATH/Utilities/oddr_clkout.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/oddr_clkout_diff.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/ofddr_clkout.vhd"

-- Fast simulation memory
acom  -work Common_HDL "$LIBPATH/Utilities/simple_mem.vhd"	
								
-- gh_vhdl_lib								
acom  -work Common_HDL "$LIBPATH/gh_vhdl_lib/custom_MSI/gh_stretch.vhd"
acom  -work Common_HDL "$LIBPATH/gh_vhdl_lib/custom_MSI/gh_edge_det.vhd"
acom  -work Common_HDL "$LIBPATH/gh_vhdl_lib/custom_MSI/gh_edge_det_XCD.vhd"
acom  -work Common_HDL "$LIBPATH/gh_vhdl_lib/custom_MSI/gh_PWM.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/err_sync.vhd"


-- UART
acom  -work Common_HDL "$LIBPATH/RS232/uarts.vhd"
acom  -work Common_HDL "$LIBPATH/RS232/kcuart_lib.vhd"
acom  -work Common_HDL "$LIBPATH/RS232/UART_Block.bde"
acom  -work Common_HDL "$LIBPATH/RS232/UART_Block_Large.bde"
acom  -work Common_HDL "$LIBPATH/RS232/UART_Block_Large_RX.bde"

-- Wishbone												   
acom  -work Common_HDL "$LIBPATH/Wishbone/wb_8i8o.VHD"
acom  -work Common_HDL "$LIBPATH/Wishbone/uc2_wb_master.vhd"
acom  -work Common_HDL "$LIBPATH/Wishbone/ARB0001a.VHD"
acom  -work Common_HDL "$LIBPATH/Wishbone/MEM0001a.VHD"	   
acom  -work Common_HDL "$LIBPATH/Wishbone/WB_bram.VHD"	
acom  -work Common_HDL "$LIBPATH/Wishbone/WB_bram32.VHD"	
acom  -work Common_HDL "$LIBPATH/Wishbone/wb_intercon_8s.vhd"
acom  -work Common_HDL "$LIBPATH/Wishbone/WB_demux2.vhd"
#alog  -work Common_HDL "$LIBPATH/Wishbone/rs232_syscon/auto_baud_with_tracking.v" 
#alog  -work Common_HDL "$LIBPATH/Wishbone/rs232_syscon/serial.v" 
#alog  -work Common_HDL "$LIBPATH/Wishbone/rs232_syscon/rs232_syscon.v"	  

-- UltraController-II (for simulation)
#acom  -work Common_HDL $DSN/../UltraController-II/uc2_model.vhd	 
acom  -work Common_HDL "$LIBPATH/UltraController-II/uc2_sim.vhd" 

-- Whisbone RS232
acom  -work Common_HDL "$LIBPATH/Wishbone/rs232_syscon/rs232_syscon.vhd"
do "$COMMON_HDL/Wishbone/wb_uart_lite/build/do_compile.do"

-- I2C
acom  -work Common_HDL "$LIBPATH/I2C/i2c_master.vhd"
acom  -work Common_HDL "$LIBPATH/I2C/temp_reader.vhd" 

-- SPI
acom  -work Common_HDL "$LIBPATH/SPI/spi_master.vhd" 
acom  -work Common_HDL "$LIBPATH/SPI/DAC8581_iface.vhd" 
acom  -work Common_HDL "$LIBPATH/SPI/ads8320_driver.vhd"
acom  -work Common_HDL "$LIBPATH/SPI/new_spi_master.vhd"

-- McBSP
acom  -work Common_HDL "$LIBPATH/McBSP/mcbsp_rx.vhd"
acom  -work Common_HDL "$LIBPATH/McBSP/mcbsp_tx.vhd"
-- acom  -work Common_HDL "$LIBPATH/McBSP/mcbsp_fast_tx.vhd"	  

-- SerDes
acom  -work Common_HDL "$LIBPATH/SerDes/sync_des.vhd"	  
acom  -work Common_HDL "$LIBPATH/SerDes/sync_ser.vhd"	  
acom  -work Common_HDL "$LIBPATH/SerDes/serializer.vhd"
acom  -work Common_HDL "$LIBPATH/SerDes/deserializer.vhd"

-- TMI FIFO
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_aFifo.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_aFifo_a10_d21.vhd"

-- Locallink
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_ram.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_ram_32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_rx_stub.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_rx_stub8.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_rx_stub_32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_tx_stub.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_tx_stub8.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_tx_stub21.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_tx_stub32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_rand.vhd"	 
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_sync_flow.vhd"	

# bus split	 -- KBE 05/2010
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_bus_split.vhd"
acom  -work Common_HDL "$LIBPATH/Utilities/bus_split.vhd"


#if $FAMILY = "Virtex2"
	acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo64.vhd"	
#endif					  

acom  -work Common_HDL "$LIBPATH/LocalLink/LL_value.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll2matlab.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/matlab2ll.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Repeat_32.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Double_Use.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout_Generic.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Hole32.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Hole1.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Hole16.vhd" 	  
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Hole21.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Hole24.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_RandomMiso8.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_RandomMiso16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_RandomMiso8.vhd"	 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_RandomMiso24.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_RandomMiso32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_ShiftReg_32.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_BusyBreak.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_BusyBreak_1.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_BusyBreak_8.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_BusyBreak_16.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_BusyBreak_21.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_BusyBreak_24.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_BusyBreak_32.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/TD_DeMux.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/TD_Mux16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/TD_Mux21.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/TD_Mux32.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/TD_Mux36.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_random_gen.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Uart_Bridge.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Merge8.vhd" 	  
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_const_32.vhd" 	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_const_24.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_const_16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_const_break.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_const_break_16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_const_break_32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_const_sync_32.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_SOF_EOF_Merger.vhd" 	  
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_min_21.vhd" 	  
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Blocker.vhd" 	  
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Blocker_8.vhd" 	  
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Blocker_16.vhd" 	  

acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo8.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo21.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo24.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo32.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo36.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo64.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LocalLink_Fifo1.vhd"

acom  -work Common_HDL "$LIBPATH/LocalLink/LL_1_fanout2.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_1_Fanout3.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout16.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout21.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout_2_21.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout_2_24.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout_2_16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout_3_16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout_4_16.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout3.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Fanout4.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_8_Fanout2.vhd" 

-- PDU: On désactive la compilation pcq LL_serial ne compile pas dans Active-HDL v8. À régler éventuellement...
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_serial_32.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_Uart_Bridge.vhd"
acom  -work Common_HDL "$LIBPATH/RS232/LL_UART_IRCDEV.bde"

acom  -work Common_HDL "$LIBPATH/LocalLink/LL_32_to_16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_21_to_16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_21_to_10.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_clipper21.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_expand_16_32.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_16_to_32.vhd"	
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_32_to_64.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_64_to_16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_32_merge_64.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_fill_void_64.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_counter16.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_counter24.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_counter32.vhd"			 
acom  -work Common_HDL "$LIBPATH/LocalLink/ll_counter64.vhd"			 

acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input.vhd"
#acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input_bfp.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output.vhd"  

-- The following are deprecated:
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input_8.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output_8.vhd" 
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input_16.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input_8.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output_16.vhd" 	
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output_24.vhd" 
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output_8.vhd" 
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input_21.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output_21.vhd"		
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input_32.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output_32.vhd" 	
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output_36.vhd" 
-- Generic in/out files  KBE 5/2010
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_output.vhd"
acom  -work Common_HDL "$LIBPATH/Matlab/LL_file_input_bfp.vhd"



-- Locallink switches
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_4_1.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_3_1.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_3_1_21.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_3_1_32.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1.vhd    
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1_16.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1_21.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1_24.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1_32.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_2.vhd   
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_2_1.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_2_8.vhd  
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_2_16.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_2_32.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_2_21.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_2_24.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_3_21.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_3_24.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_3_32.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_3_16.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_1_3_21_multi.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1_64.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1_8.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_2_1_16_clk.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_SW_FAN_1_2_1.vhd 

-- Locallink utilities
acom  -work Common_HDL $LIBPATH/LocalLink/LL_random_gen_8.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_random_gen_16.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_random_gen.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_Comparator_16.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_32_split_2x16.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/ll_16_merge_32.vhd
acom  -work Common_HDL $LIBPATH/LocalLink/LL_BERT_16.vhd 
acom  -work Common_HDL $LIBPATH/LocalLink/LL_BERT_32.vhd

-- Aurora
#acom  -work Common_HDL "$LIBPATH/Aurora/Aurora_401_Merge.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_401_2gb_full/aurora_401_2gb_full_merge.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_401_2gb_full/aurora_401_2gb_full_wrapper.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_201_1gb_full/aurora_201_1gb_full_wrapper.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_201_1gb_full/aurora_201_1gb_full_merge.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/Aurora_NFC.asf"

acom  -work Common_HDL "$LIBPATH/Aurora/aurora_reader_32.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/Aurora_Rst.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_sim_reset_on_config.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/Aurora_Init_Ctrl.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/standard_cc_module_402_v3.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/standard_cc_module_402.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/ck_aurora_401.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_dcm.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/Aurora_201_reader.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_201.bde"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_401.bde"  
acom  -work Common_HDL "$LIBPATH/Aurora/Aurora_Clocks_V4.vhd" 
#acom  -work Common_HDL "$LIBPATH/Aurora/Aurora_Clocks_V4_1Gb.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_2gb_v4_core/aurora_402_2gb_v4_merged.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_2gb_v4_core/aurora_402_2gb_v4_sim.vhd" 
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_1gb_v4_core/aurora_402_1gb_v4_merged.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_v4.bde"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_1gb_v4.bde"

-- V2Pro version of Aurora_402 added by OBO
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_dcm_402_v2p.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_2gb_v2p/Aurora_402_v2p_merged.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_2gb_v2p/Aurora_402_v2p_sim.vhd"
#acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_2gb_v2p/aurora_402_2gb_v2p_wrapper.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_v2p.bde"
#New version of v2p_v1 that supports the reset of fifo but don't reset the aurora core (jumbo frame for ircdev
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_v2p_v1.bde"

acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_1gb_v2p/aurora_402_1gb_v2p_merged.vhd"
acom  -work Common_HDL "$LIBPATH/Aurora/aurora_402_1gb_v2p.bde"

-- Locallink Math 
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/LL_addsub/LL_addsub.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/LL_addsub_21.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/LL_addsub_24.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/LL_div_21x6.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/LL_div_24x9.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/coregen_V4/fp_sqrt_float32_L26.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/coregen_V4/fix32tofp32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/sqrt_float32/src/LL_sqrt_float32.vhd"        
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/src/fixtofp32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/src/fix32utofloat32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_8s/src/fixtofp32_8s.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_9s/src/fixtofp32_9s.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_10u/src/fixtofp32_10u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_11u/src/fixtofp32_11u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_11s/src/fixtofp32_11s.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_12s/src/fixtofp32_12s.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_12u/src/fixtofp32_12u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_16u/src/fixtofp32_16u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_16s/src/fixtofp32_16s.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_17s/src/fixtofp32_17s.vhd" 
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_21u/src/fixtofp32_21u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_32u/src/fixtofp32_32u.vhd"

acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofix/src/fp32tofix.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofix/build/fp32tofix_16u/src/fp32tofix_16u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofix/build/fp32tofix_21u/src/fp32tofix_21u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofix/build/fp32tofix_32u/src/fp32tofix_32u.vhd"

# width converters
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_32_to_24.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_24_to_32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_16_to_24.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/LL_24_to_16.vhd"


-- Must compile ieee_proposed first	

-- Floating point cores	  
acom  -work Common_HDL "$LIBPATH/LocalLink/CoreGen_V4/fp_addsub_float32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/CoreGen_V4/fp_addsub_float32_L9.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/addsub_float32/addsub_float32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/neg_float32/neg_float32.vhd"

if $POST_SYNTH_MODELS = 1
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/ll_fp32_max/syn/rev1/ll_fp32_max_syn.vhm"
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/ll_fp32_max/syn/ll_fp32_max_syn.vhd"
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/ll_fp32_max/syn/ll_fp32_max_wrap.vhd"
else
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/ll_fp32_max/ll_fp32_max.vhd"
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/ll_fp32_max/ll_fp32_max_wrap.vhd"
endif

if $POST_SYNTH_MODELS = 1
--   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/mult_float32/mult_float32.vhm"  This model has record ports
--   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/mult_float32/mult_float32_sim.vhd"  This model has slv ports
else
   acom  -work Common_HDL "$LIBPATH/LocalLink/CoreGen_V4/fp_mult_float32.vhd"  
   acom  -work Common_HDL "$LIBPATH/LocalLink/CoreGen_V4/fp_mult_float32_l5.vhd"  
   acom  -work Common_HDL "$LIBPATH/LocalLink/CoreGen_V4/fp_mult_float32_l8.vhd"  
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/mult_float32/mult_float32.vhd"
endif

if $POST_SYNTH_MODELS = 1   
--   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/div_float32/div_float32.vhm"	 This model has record ports
--   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/div_float32/div_float32_sim.vhd"  This model has slv ports
else 
   acom  -work Common_HDL "$LIBPATH/LocalLink/CoreGen_V4/fp_div_float32.vhd"
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/div_float32/div_float32.vhd"
endif

if $POST_SYNTH_MODELS = 1 
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/syn_signed/fi21tofp32_syn_signed.vhd"
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/syn_signed/rev_1/fi21tofp32_syn_signed.vhm" 
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/syn_signed/fi21tofp32_signed.vhd"

   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/syn_unsigned/fi21tofp32_syn_unsigned.vhd"
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/syn_unsigned/rev_1/fi21tofp32_syn_unsigned.vhm"   
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/syn_unsigned/fi21tofp32_unsigned.vhd"
else
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/fi21tofp32.vhd"
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/fi21tofp32_signed.vhd"
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fi21tofp32/fi21tofp32_unsigned.vhd"
   # Generic Fix width to 32 floating point converter. KBE 05/2010																		
   acom -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/src/fixtofp32.vhd" 
   acom -work Common_HDL "$LIBPATH/LocalLink/Math//fp32tofix/src/fp32tofix.vhd" 
endif

acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofi21/sim_pkg.vhd"	   
if $POST_SYNTH_MODELS = 1 
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofi21/syn/rev_1/fp32tofi21_syn.vhm"	   
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofi21/syn/fp32tofi21_wrap.vhd"
else 
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofi21/fp32tofi21.vhd"	            
   acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofi21/fp32tofi21_wrap.vhd"
endif

acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/src/fixtofp32.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fixtofp32/build/fixtofp32_16u/src/fixtofp32_16u.vhd"
acom  -work Common_HDL "$LIBPATH/LocalLink/Math/fp32tofix/src/fp32tofix.vhd"

-- Telops Memory Interface
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/coregen_v4/afifo_w1_d16.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/coregen_v4/afifo_w9_d16.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/coregen_v4/afifo_w22_d16.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/coregen_v4/afifo_w32_d16.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_rand.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_idelay_tune.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_memtest.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_memtest_a21_d32.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_BusyBreak.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_BusyBreak_a21_d24.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_aFifo.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_aFifo_a10_d21.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_aFifo_a21_d32.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_bram.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_bram_v2.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_bram_a21_d32.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_bram_a17_d1.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_SW_2_1.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_SW_2_1_a21_d32.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_IDELAY_tune.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_arbiter_2.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_mst_stub_a21_d32.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_a21_d32_to_a10_d21.vhd"
acom  -work Common_HDL "$LIBPATH/Telops_Memory_Interface/TMI_a21_d32_to_d24.vhd"

do "$LIBPATH/Telops_Memory_Interface/LL_TMI_bridge/build/LL_TMI_Bridge_Compile.do"
do "$LIBPATH/Telops_Memory_Interface/TMI_LL_Histogram/build/LL_TMI_HISTOGRAM_1024_compile.do"
do "$LIBPATH/Telops_Memory_Interface/TMI_LL_LUT/build/TMI_LL_LUT_compile.do"
do "$LIBPATH/Telops_Memory_Interface/TMI_MDP_ZBT_Ctrl/build/compile_rtl.do"


#symbols must be compiled after their entity/architecture pair
acom  -work Common_HDL $LIBPATH/LocalLink/LocalLink_Symbols.bde

importbdesymbols -lib common_hdl $COMMON_HDL/symbols/*.bds -overwrite




label end     
runscript "$LIBPATH/Active-HDL/src/beep.tcl"
