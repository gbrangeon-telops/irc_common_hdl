readme.txt
Aurora Core version 2.7.1
Date:  $Date$
File:  $RCSfile: readme.ejava,v $
Rev:  $Revision$
==============================================================================================


    Thank you for choosing the Aurora Core. This file contains
    information specific to the module you have just generated.  Refer to
    the LogiCORE Aurora User Guide (ug061.pdf) and the LogiCORE Aurora Getting Started
    Guide (ug173.pdf) for detailed information.


==============================================================================================

    Contents:


    (1)     Summary of the parameters used to generate your Aurora core 


    (2)     Overview of the Aurora core directory structure


    (3)     Quick start recommendations


    (4)     Troubleshooting Guide


    (5)     Links to useful resources


    (6)     Setting up the shell environment


    (7)     Errata


===============================================================================================


    Section (1) : Summary of the parameters used to generate your Aurora Core Module
    --------------------------------------------------------------------------------------------


    Parameters
    ----------
    HDL used                    :   VHDL
    Top level module            :   src/aurora_402_1gb_v4_core.vhd
    Lanes (MGTs) in channel     :   2
    Bytes in parallel interface :   4
    Interface mode              :   Framing (LocalLink)
    Duplex or Simplex           :   Duplex
    Device used                 :   xc4vfx60
    Flow control used           :   Native Flow Control (NFC)
    Native Flow Control mode    :   Immediate (TX stops sending data immediately when NFC message arrives)


    Mgt Placement
    -------------
    * Lane 1 of 2 uses MGT X0Y0. Its reference clock is REF_CLK1_LEFT
    * Lane 2 of 2 uses MGT X0Y1. Its reference clock is REF_CLK1_LEFT



===============================================================================================


    Section (2)  Overview of the Aurora Core directory structure
    ------------------------------------------------------------------------


    The files for your Aurora module are arranged in the following file structure:

    COREGEN_project_directory
    |
    |---aurora_402_1gb_v4_core
        |
        |---src/
        |   |
        |   |---aurora_402_1gb_v4_core.vhd
        |   |
        |   |---[remaining Aurora module VHDL source code]
        |
        |---ucf/
        |   |
        |   |---aurora_402_1gb_v4_core.ucf    [Contraints for Aurora module. Include these in your final design]
        |   |
        |   |---aurora_sample.ucf               [Contraints for the Aurora sample example design]
        |
        |---examples/
        |   |
        |   |---aurora_sample.vhd
        |   |
        |   |---[remaining VHDL source code for submodules used in the example design,
        |        not including the cc_manager]
        |
        |---scripts/
        |   |
        |   |---make_aurora.pl
        |   |
        |   |---config.csh
        |
        |---cc_manager/
        |   |
        |   |---standard_cc_module.vhd
        |
        |---ug061.pdf           [This is the user guide]
        |
        |---readme.txt          [This is the file you are currently reading]


===============================================================================================


    Section (3)     Quick start recommendations
    ------------------------------------------------


    After generating an Aurora module, you may want to do one of the following:

    (a) Build an Aurora module to try the flow and see it working in hardware

    (b) Integrate the Aurora module with your own design



    The Getting Started guide has chapters which will step you through building an Aurora Module.
    
    The User Guide explains the module in detail to help you connect it to your design and use it
    in your system.





===============================================================================================


    Section (4)  Troubleshooting Guide
    -----------------------------------


    This section presents some common problems you may encounter implementing the Aurora
    core .



    (a) Lanes and Channel do not come up in simulation

        - The quickest way to debug these problems is to view the signals from one of the MGT
          instances that are not working

        - Make sure that the reference clock and user clocks are all toggling. Note that only one
          of the reference clocks should be toggling, the rest will be tied low.

        - Check to see that RECCLK is toggling. If you are using ProX, make sure TXOUTCLK is toggling.
          If they are not toggling, you may have to wait longer for the PMA to finish locking. You
          should typically wait about 5-7 us for channel up, unless you are using a ProX device with an
          older Smartmodel, where you will have to wait about 120-140 us to account for the power-up
          simulation

        - Make sure that TXN and TXP are toggling. If they are not, make sure you've waited long enough
          (see the previous bullet) and make sure you are not driving the TX signal with another signal

        - If you are using a ProX module, make sure the clock rate you are using is appropriate for the
          PMA_SPEED setting you are using. Also make sure that the PMA_SPEED setting you are using is
          appropriate for the lane width on your module. PMA_SPEED settings are described in chapter 5
          of ug061.pdf. They are described in more detail in the RocketIO X Transceiver User Guide

        - Check the DCM_NOT_LOCKED signal and the RESET signals on your design. If these are being held
          active, your Aurora module will not be able to initialize

        - Be sure you do not have the Powerdown signal asserted

        - Make sure the TXN and TXP signals from each MGT are connected to the appropriate RXN and RXP
          signals from the corresponding MGT on the other side of the channel

        - If you are simulating Verilog, you will need to instantiate the "glbl" module and use it to
          drive the power_up reset at the beginning of the simulation to simulate the reset that occurs
          after configuration. You should hold this reset for a few cycles. the code below can be used
          an an example:

              //Simultate the global reset that occurs after configuration at the beginning
              //of the simulation.
              assign glbl.GSR = gsr_r;
              assign glbl.GTS = gts_r;

              initial
                  begin
                      gts_r = 1'b0;
                      gsr_r = 1'b1;
                      #(16*CLOCKPERIOD_1);
                      gsr_r = 1'b0;
                  end

        - If you are using a multilane channnel, make sure all the MGTs on each side of the channel are
          connected in the correct order

    (b) Channel comes up in simulation but TX_DST_RDY_N is never asserted (never goes low)

        - If your module includes flow control but you are not using it, make sure the request signals
          are not currently driven low. NFC_REQ_N and TX_UFC_REQ_N are active low: if they are low,
          TX_DST_RDY_N will stay low because the channnel will be allocated for flow control

        - Make sure DO_CC is not being driven high continously. Whenever DO_CC is high on a positive
          clock edge, the channel is used to send clock correction characters, so TX_DST_RDY_N is
          deasserted

        - If you have NFC enabled, make sure the design on the other side of the channel did not send
          an NFC XOFF message. This will cut off the channel for normal data until the other side sends
          an NFC XON message to turn the flow on again. See chapter 4 of ug061.pdf for more details


    (c) Bytes and words are being lost as they travel through the Aurora channel

        - If you are using the LocalLink interface, make sure you are writing data correctly. The most common
          mistake is to assume words are written without looking at TX_DST_RDY_N. Also remember that all signals
          ending in _N are active low, and that the REM signal must be used to indicate which bytes are valid
          when TX_EOF_N is asserted

        - Make sure you are reading correctly from the RX interface. Data and framing signals are only valid
          when RX_SRC_RDY_N is asserted. Note that when using the LocalLink interface, certain frame patterns
          cause a 'stutter' at the output, where the final byte of a frame is seperated from the rest of the
          data by a 1-cycle gap



    (b) Problems while compiling the design

        - Make sure you include all the files from the src directory when compiling. If using VHDL, make sure to
          include the aurora_pkg.vhd file in your synthesis

        - If you have errors when running ngdbuild for a ProX step 0 module after synthesizing with XST, make
          sure that rom_extraction was set to "off" when you synthesized. Leaving this option enabled can
          sometimes cause the outputs of one of the blocks of the in-fabric clock correction module to be
          renamed, leaving constraints in the ucf file without a target


    (d) Channel does not come up or is flaky in hardware

        - Go through list (a) to make sure none of those conditions apply to your design. You can use ChipScope
          to bring out the outputs of the MGT

        - Make sure you are driving the reference clocks with the correct type of oscillator

        - Make sure you copied all the constraints from the aurora_402_1gb_v4_core/ucf/aurora_402_1gb_v4_core.ucf
          file to your top level ucf file. Also make sure that you set the period of the recovered clocks (rec_clk) to
          be less than or equal to the constraints used for your user clock. You can skip this check if you are
          debugging the aurora_sample design

        - If your line rate is greater than 2.5 Gbps, make sure you are using a BREF_CLK or BREF_CLK2 port for
          your reference clock

        - Don't use a DCM output to drive your reference clock

        - If your channel uses MGTs on both edges of the FPGA, make sure the reference clocks for each side are from
          the same physical source

        - If you are using a 4-byte lane module in V2Pro, make sure your USER_CLK_2X_N signal is exactly twice your
          USER_CLK signal, and aligned to its negative edge. Similarly, make sure your USER_CLK signal is exactly
          half of your reference clock. If you use the clock module provided in aurora_402_1gb_v4_core/clock_module,
          this will be taken care of automatically

        - Make sure you've connected the MGTs you are using in your design to the MGTs from the other side of
          the channel (they can be in loopback)

        - Be sure your reference clock is not below the *minimum* rate for the MGT. This is typically around 50 Mhz. See
          the RocketIO Transceiver User Guide or the RocketIO X Transceiver User Guide for specifics

        - If you synthesized a ProX step 0 design with XST, make sure signal_encoding was set to 'user'. If this is
          not done, the grey code used to transfer data across clock boundaries in the clock correction block is
          changed to a one-hot circuit, which fails under certain clocking conditions. If you are running XST from
          the command line, use

                    > xilperl make_aurora.pl

          to re-synthesize, or

                    > xilperl make_aurora.pl -files

          to generate a .scr file demonstrating the option

          This option is not currently available in Project Navigator, so Navigator users should either compile
          the netlist using the command line mode, or add the "signal_encodign" synthesis constraint to the source
          code as an attribute

        - If you are connecting to MGTs on another board, make sure the LOOPBACK port is driven low

        - If you are using the MGT's serial Loopback feature, make sure the MGTs are terminated correctly

        - Make sure your USER_CLK is derived from the same physical clock source as your reference clock. If the two
          clocks have even a slight frequency difference, you will eventually have hard errors due to TX Buffer overflows

        - Make sure you are using clock correction if the ends of your channel are using different clock sources. If hard
          errors are preventing your channel from working, you should check to make sure DO_CC is being asserted at least
          6 times every 5000 cycles for a 2-byte lane channel, or 3 times every 2500 cycles for a 4-byte lane channel

        - If you are using different clock sources on each end of your channel, make sure the frequency sources on each
          side are within 200 ppm of each other (+/- 100 ppm).

        - Download one of the free Xilinx BERT or XBERT designs to check the signal integrity of your physical connections

        - If you are not using a Xilinx MGT evaluation board, you should check to make sure the power supply filtering for
          your board was built according to the reccomentations in Chapter 3 of the RocketIO Transceiver user guide, or
          chapter 4 of the RocketIO X Transceiver user guide

        - Call Xilinx Hotline or visit http://support.xilinx.com to search for any recent errata that may impact your
          design. Search for COREGEN Aurora 2.2 Errata


===============================================================================================


    Section (5) : Links to useful resources
    ----------------------------------------

    You may find the following resources useful


        Core Generator Guide:               http://toolbox.xilinx.com/docsan/xilinx6/books/docs/cgn/cgn.pdf

        Rocket IO Transceiver Guide:        http://www.xilinx.com/bvdocs/userguides/ug024.pdf

        Rocket IO X Transceiver Guide:      http://www.xilinx.com/bvdocs/userguides/ug035.pdf

        LocalLink Interface Specification:  http://www.xilinx.com/aurora

        Aurora Protocol Specification:      http://www.xilinx.com/aurora

        Multi-Gigabit Signaling Resources:  http://www.xilinx.com/products/design_resources/highspeed_design/resource/si_gig.htm

        Xilinx on Board:                    http://www.xilinx.com/xlnx/xebiz/search/boardsrch.jsp?sGlobalNavPick=PRODUCTS&sSecondaryNavPick=Design+Tools
                                            (Search for Development boards)

        Xilinx Support:                     http://support.xilinx.com



===============================================================================================


    Section (6) : Setting up the shell environment
    -----------------------------------------------


    If you are using the Xilinx ISE tools on Linux or Unix, as long as you have the bin directory
    from your Xilinx installation in your PATH, you should be able to use your shell windows to
    run Xilinx tools


    If you are using a PC with either Windows XP or Windows 2000, the Xilinx bin directory should
    have been added to your path when you installed the XILINX tools. To make sure, open a command
    prompt window and type

        > echo %PATH%

    to see your current path settings. Make sure that the path to your Xilinx bin directory
    from ISE is included. If not, you will need to go to Start->Control Panel -> System Properties ->
    Advanced -> Environment Variables to add it to your PATH variable. Be careful not to remove any
    of the existing paths

    Once your PATH variable is set, you can open another command prompt window, and use it to run xilperl


===============================================================================================


    Section (7) : Errata
    -----------------------------------------------

    (a) There is a bug in Xilinx's ngdbuild and map tools that prevents Virtex-2 ProX modules
        using REFCLK from being processed correctly. To work around this issue, the BREFCLKNIN
        and BREFCLKPIN signals from all the MGTs must be connected to pins at the top level of
        the module. REFCLK will still be used as the reference clock for the MGT.

    Section (8): DISCLAIMER
    ------------------------------------------------
Source code provided as part of a Reference Core or Design

The following text should be found in all Source Code that is part of a Reference Design or a Reference core, where this source code is provided as part of a "Free" reference design or reference core. This would include Source code that is included as part of the EDK software product. It would also include any Source code provided as part of an Application note or Reference design.

NOTE: The Copyright date range shown below is an example only. The range you use should start with the year of the original release of the IP product and end with the current year.


 DISCLAIMER OF LIABILITY
 
This text/file contains proprietary, confidential
information of Xilinx, Inc., is distributed under license
from Xilinx, Inc., and may be used, copied and/or
disclosed only pursuant to the terms of a valid license
agreement with Xilinx, Inc. Xilinx hereby grants you a 
license to use this text/file solely for design, simulation, 
implementation and creation of design files limited 
to Xilinx devices or technologies. Use with non-Xilinx 
devices or technologies is expressly prohibited and 
immediately terminates your license unless covered by
a separate agreement.

Xilinx is providing this design, code, or information 
"as-is" solely for use in developing programs and 
solutions for Xilinx devices, with no obligation on the 
part of Xilinx to provide support. By providing this design, 
code, or information as one possible implementation of 
this feature, application or standard, Xilinx is making no 
representation that this implementation is free from any 
claims of infringement. You are responsible for 
obtaining any rights you may require for your implementation. 
Xilinx expressly disclaims any warranty whatsoever with 
respect to the adequacy of the implementation, including 
but not limited to any warranties or representations that this
implementation is free from claims of infringement, implied 
warranties of merchantability or fitness for a particular 
purpose.

Xilinx products are not intended for use in life support
appliances, devices, or systems. Use in such applications is
expressly prohibited.

Any modifications that are made to the Source Code are 
done at the user?s sole risk and will be unsupported.


Copyright (c) 2001, 2002, 2003, 2004, 2005, 2007 Xilinx, Inc. All rights reserved.

This copyright and support notice must be retained as part 
of this text at all times. 


