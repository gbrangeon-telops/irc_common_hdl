@onerror
{
goto end
}

savealltabs
SetActiveLib -post-synthesis
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\DDR_Ctrl\src\Model\DDR_define.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\DDR_Ctrl\src\Model\DDR_Command_Decoder.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\DDR_Ctrl\src\Model\DDR_Registers.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\DDR_Ctrl\src\Model\mt46v128m4.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\DDR_Ctrl\src\Model\MT36VDDF25672G.bde"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\coregen_V4\as_fifo_w128_d64.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\coregen_V4\as_fifo_w171_d32.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\coregen_V4\as_fifo_w144_d64.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\coregen_V4\as_fifo_w155_d32.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\coregen_V4\as_fifo_w27_d32.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\coregen_V4\fwft_fifo_w2_d64.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "$dsn\synthesis\ddr_mig.vhd"
acom  -work IFTIRS_dataproc_post_synthesis "D:\telops\Common_HDL\DDR_Ctrl\src\TestBench\ddr_tb_ml461.vhd"
SetActiveLib -work
label end
