@onerror
{
goto end
}
#setenv PROC_COMMON "$EDK\hw\XilinxProcessorIPLib\pcores\proc_common_v2_00_a\hdl\vhdl\"
setenv PROC_COMMON "$XILINX_EDK\hw\XilinxProcessorIPLib\pcores\proc_common_v2_00_a\hdl\vhdl\"

------------------------------------------------------
-- Compile proc_common_v2_00_a
------------------------------------------------------
alib proc_common_v2_00_a "D:\Telops\Common_HDL\Wishbone\wb_uart_lite\proc_common_v2_00_a.lib"
amap -global proc_common_v2_00_a "D:\Telops\Common_HDL\Wishbone\wb_uart_lite\proc_common_v2_00_a.lib"
setlibrarymode -rw proc_common_v2_00_a     

acom -work proc_common_v2_00_a "$PROC_COMMON$\proc_common_pkg.vhd"  
acom -work proc_common_v2_00_a "$PROC_COMMON$\family_support.vhd"
acom -work proc_common_v2_00_a "$PROC_COMMON$\cntr_incr_decr_addn_f.vhd" 
acom -work proc_common_v2_00_a "$PROC_COMMON$\muxf_struct_f.vhd"
acom -work proc_common_v2_00_a "$PROC_COMMON$\dynshreg_f.vhd"
acom -work proc_common_v2_00_a "$PROC_COMMON$\srl_fifo_rbu_f.vhd"
acom -work proc_common_v2_00_a "$PROC_COMMON$\srl_fifo_f.vhd"  
acom -work proc_common_v2_00_a "$PROC_COMMON$\dynshreg_i_f.vhd"

------------------------------------------------------
-- Compile uart core
------------------------------------------------------
acom "D:\Telops\Common_HDL\Wishbone\wb_uart_lite\src\baudrate.vhd"
acom "D:\Telops\Common_HDL\Wishbone\wb_uart_lite\src\uartlite_rx.vhd"
acom "D:\Telops\Common_HDL\Wishbone\wb_uart_lite\src\uartlite_tx.vhd"
acom "D:\Telops\Common_HDL\Wishbone\wb_uart_lite\src\uartlite_core.vhd"    
acom "D:\Telops\Common_HDL\Wishbone\wb_uart_lite\src\wb_uart_lite.vhd"