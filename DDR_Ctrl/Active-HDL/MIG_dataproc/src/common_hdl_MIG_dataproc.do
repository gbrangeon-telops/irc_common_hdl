#this is the project-specific common_hdl library compile script
#only modules necessary to MIG_dataproc are compiled
@onerror
{
goto end
}

setenv LIBPATH "D:\Telops\Common_HDL"

# optimization level
set OPT -O3
# compile with debug information
set OPT -dbg

------------------------------------------------------
-- Compile library Common_HDL
------------------------------------------------------
alib Common_HDL "$LIBPATH\Active-HDL\Common_HDL.lib"
setlibrarymode -rw Common_HDL

# simulation blocks
acom  -work Common_HDL "$LIBPATH\telops.vhd"
acom  -work Common_HDL "$LIBPATH\Utilities\telops_testing.vhd"
acom  -work Common_HDL "$LIBPATH\Utilities\simple_mem.vhd"

# synthesis blocks
acom  -work Common_HDL "$LIBPATH\Utilities\dcm_reset.vhd"
acom  -work Common_HDL "$LIBPATH\Utilities\srl_reset.vhd"
acom  -work Common_HDL "$LIBPATH\Utilities\gen_areset.vhd"
acom  -work Common_HDL "$LIBPATH\Utilities\double_sync.vhd"
acom  -work Common_HDL "$LIBPATH\Utilities\clk_divider.vhd"
acom  -work Common_HDL "$LIBPATH\coregen_V4\as_fifo_w128_d127.vhd"
acom  -work Common_HDL "$LIBPATH\coregen_V4\as_fifo_w171_d32.vhd"
acom  -work Common_HDL "$LIBPATH\coregen_V4\as_fifo_w144_d64.vhd"
acom  -work Common_HDL "$LIBPATH\coregen_V4\as_fifo_w27_d32.vhd"
acom  -work Common_HDL "$LIBPATH\coregen_V4\as_fifo_w155_d32.vhd"
acom  -work Common_HDL "$LIBPATH\coregen_V4\fwft_fifo_w2_d512.vhd"
#acom  -work Common_HDL "$LIBPATH\RS232\uarts.vhd"

label end     
runscript "$LIBPATH\Active-HDL\src\beep.tcl"
