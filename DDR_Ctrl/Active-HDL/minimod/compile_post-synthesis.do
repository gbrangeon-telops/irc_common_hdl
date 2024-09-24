@onerror
{
goto end
}

savealltabs
setactivelib -post-synthesis
acom  -work minimod_post_synthesis "$COMMON_HDL/DDR_Ctrl/src/Model/DDR_define.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/DDR_Ctrl/src/Model/DDR_Command_Decoder.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/DDR_Ctrl/src/Model/DDR_Registers.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/DDR_Ctrl/src/Model/mt46v32m8.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/coregen_V4/as_fifo_w128_d64.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/coregen_V4/as_fifo_w171_d32.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/coregen_V4/as_fifo_w144_d64.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/coregen_V4/as_fifo_w155_d32.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/coregen_V4/as_fifo_w27_d32.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/coregen_V4/fwft_fifo_w2_d64.vhd"
acom  -work minimod_post_synthesis "$dsn/synthesis/ddr_mig.vhd"
acom  -work minimod_post_synthesis "$COMMON_HDL/DDR_Ctrl/src/TestBench/ddr_tb_minimod.vhd"
setactivelib work
label end
