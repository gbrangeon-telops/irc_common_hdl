--------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_HISTOGRAM_1024.do
-- Author      : Jean-Alexis Boulet
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : Script to compile the LL_TMI_HISTOGRAM_1024 Entity
--               
--
---------------------------------------------------------------------------------------------------

#compile the sysgen top-lvl
acom -work Common_hdl "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/src/systemGen/netlist/histogram.vhd"

#compile the sysgen ngc top-lvl sim
acom -work Common_hdl "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/src/systemGen/histogram_mcw_sim.vhd"

#compile the wrappers
acom -work Common_hdl "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/src/LL_SysGen_HistoWrap.vhd"
acom -work Common_hdl "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/src/TMI_SysGen_Wrap.vhd"

#compile the histrogram top-lvl
acom -work Common_hdl "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/src/LL_TMI_Histogram_1024.bde"

#compile TMI FIFO
#acom "$COMMON_HDL/Telops_Memory_Interface/coregen_V4/afifo_w1_d16.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/coregen_V4/afifo_w9_d16.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/coregen_V4/afifo_w22_d16.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/coregen_V4/afifo_w32_d16.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_aFifo.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_aFifo_a10_d21.vhd"

#compile the TB
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_LL_Histogram/tb/src/tmi_histo_tb.vhd"
