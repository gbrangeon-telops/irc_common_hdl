#savealltabs
#adel -all
#SetActiveLib -work
#clearlibrary 	

 
# sources FPa common 
acom -relax d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\ad5648_driver.vhd 
acom -nowarn DAGGEN_0523 -incr \
 d:\Telops\Common_HDL\SPI\ads1118_driver.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\signal_filter.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\fpa_trig_controller.vhd  \
 d:\Telops\FIR-00251-Proc\src\FPA\fpa_trig_precontroller.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\dfpa_hardw_stat_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\fpa_intf_sequencer.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\fpa_status_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\brd_id_reader.vhd      \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\adc_brd_id_reader.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\flex_brd_id_reader.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\LL8_ext_to_spi_tx.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\adc_brd_switch_ctrl.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\monitoring_adc_ctrl.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\spi_mux_ctler.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_services_ctrl.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_sample_counter.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_data_mux.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_int_signal_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_sample_mean.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_sample_selector.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_sample_sum.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_data_dispatcher.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\fpa_diag_line_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_real_mode_dval_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_diag_data_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_flow_mux.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_pixel_reorder.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\concat_1_to_8.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\LL8_ext_fifo8.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_hw_driver_ctrler.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\fleg_prog_ctler_kernel.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\fleG_dac_spi_feeder.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_chn_diversity_ctrler.vhd \
 d:\Telops\FIR-00251-Proc\src\QuadADC\HDL\quad_adc_ctrl.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_data_ctrl_map.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_fsync_mode_dval_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_lsync_mode_dval_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_sample_demux.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_faked_data_gen.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_elec_offset_ctrler.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_elec_offset_calc.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_elec_offset_mem.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\LL_ext_sync_flow.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_quad_add.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_quad_subtract.vhd \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_elec_offset_proc.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_real_data_gen.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_dval_gen.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_hsample_proc.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_vsample_proc.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_data_ctrl.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_data_ctrl_16chn.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\afpa_services.bde \
 d:\Telops\Common_HDL\Common_Projects\TEL2000\FPA_common\src\fleG_prog_ctrler.bde
