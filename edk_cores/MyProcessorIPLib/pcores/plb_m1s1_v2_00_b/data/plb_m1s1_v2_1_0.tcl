###################################################################
##
##     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
##     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
##     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
##     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
##     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS
##     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
##     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
##     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
##     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
##     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
##     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
##     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
##     FOR A PARTICULAR PURPOSE.
##     
##     (c) Copyright 2005 Xilinx, Inc.
##     All rights reserved.
##
###################################################################
##
## DO NOT COPY OR MODIFY THIS FILE. 
## THIS IS IN AN EXPERIMENTAL STAGE AND MIGHT CHANGE IN FUTURE RELEASE.
##
## plb_m1s1_v2_1_0.tcl
##
##########################################################################


#***--------------------------------***------------------------------------***
#
#			     SYSLEVEL_DRC_PROC
#
#***--------------------------------***------------------------------------***

#
# check signal DCR_ABus/DCR_Read/DCR_Write/DCR_DBus is connected if C_DCR_INTFCE=1
#
proc check_syslevel_settings {mhsinst} {

    # check port connectivity
    set ipname       [xget_value $mhsinst "option" "ipname"]
    set instname       [xget_value $mhsinst "parameter" "INSTANCE"]
    set dcr_intfce   [xget_value $mhsinst "parameter" "C_DCR_INTFCE"]
    set dcr_busif    [xget_value $mhsinst "bus_interface" "SDCR"]

#    if {([string length $dcr_busif] == 0 && $dcr_intfce)} {
#        puts  "WARNING: $instname DCR bus interface is not set"
#	
#    }

#    if {([string length $dcr_busif] != 0 && !$dcr_intfce)} {
#        error  "$instname DCR bus interface is not enabled. Please check parameter C_DCR_INTFCE." "" "libgen_error"
#
#    }
    if {([string length $dcr_busif] != 0)} {
        error  "$instname DCR bus interface is not implemented. Do not connect to it." "" "libgen_error"
	
    }

#   for {set i 0} {$i < 4} {incr i} {
# 
#        set portname  [lindex $portList $i]
#        set connector [xget_value $mhsinst "port" $portname]
#    puts "i=$i"
#    puts "port=[lindex $portList $i]"
#    puts "connector=$connector"
#
#   	if {([string length $connector] == 0 && $dcr_intfce) || ([string length $connector] != 0 && !$dcr_intfce)} {
#
#	    error  "$ipname port $portname is not connected" "" "libgen_error"
#	
#	}
#    }
}
 

