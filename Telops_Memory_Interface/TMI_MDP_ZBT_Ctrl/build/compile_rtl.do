#@onerror
#{
#goto end
#}

#acom "$COMMON_HDL/LFSR/image_pb.vhd"
#acom "$COMMON_HDL/LFSR/lfsrstd.vhd"

#aco_HDL/Telops_Memory_Interface/TMI_a21_d32_to_d24.vhd"	
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_rand.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_idelay_tune.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_memtest.vhd"
#acom "$COMMON_HDL/Telops_Memory_Interface/TMI_SW_2_1.vhd"
acom "$COMMON_HDL/Telops_Memory_Interface/TMI_MDP_ZBT_Ctrl/src/TMI_ZBT_ctrl.vhd"
acom "$COMMON_HDL/Telops_Memory_Interface/TMI_MDP_ZBT_Ctrl/src/TMI_MDP_ZBT_Ctrl.bde"
acom "$COMMON_HDL/Telops_Memory_Interface/TMI_MDP_ZBT_Ctrl/src/TMI_MDP_ZBT_Ctrl_a21_d24.vhd"
acom "$COMMON_HDL/Telops_Memory_Interface/TMI_MDP_ZBT_Ctrl/src/TMI_MDP_ZBT_Ctrl_a21_d32.vhd"
#label end