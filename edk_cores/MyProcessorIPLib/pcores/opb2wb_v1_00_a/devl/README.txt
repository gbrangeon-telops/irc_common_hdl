TABLE OF CONTENTS
  1) Peripheral Summary
  2) Description of Generated Files
  3) Description of Used IPIC Signals
  4) Description of Top Level Generics


================================================================================
*                             1) Peripheral Summary                            *
================================================================================
Peripheral Summary:

  XPS project / EDK repository               : D:\telops\FIR-00142-RFILW\edk_project_v4
  logical library name                       : opb2wb_v1_00_a
  top name                                   : opb2wb
  version                                    : 1.00.a
  type                                       : OPB slave
  features                                   : slave attachement

Address Block for User Logic and IPIF Predefined Services

  User logic slave space service             : C_BASEADDR + 0x00000000
                                             : C_BASEADDR + 0x000000FF


================================================================================
*                          2) Description of Generated Files                   *
================================================================================
- HDL source file(s)
  D:\telops\FIR-00142-RFILW\edk_project_v4/pcores/opb2wb_v1_00_a/hdl

  vhdl/opb2wb.vhd

    This is the template file for your peripheral's top design entity. It
    configures and instantiates the corresponding IPIF unit in the way you
    indicated in the wizard GUI and hooks it up to the stub user logic where
    the actual functionalites should get implemented. You are not expected to
    modify this template file except certain marked places for adding user
    specific generics and ports.

  vhdl/user_logic.vhd

    This is the template file for the stub user logic design entity, either in
    VHDL or Verilog, where the actual functionalities should get implemented.
    Some sample code snippet may be provided for demonstration purpose.


- XPS interface file(s)
  D:\telops\FIR-00142-RFILW\edk_project_v4/pcores/opb2wb_v1_00_a/data

  opb2wb_v2_1_0.mpd

    This Microprocessor Peripheral Description file contains information of the
    interface of your peripheral, so that other EDK tools can recognize your
    peripheral.

  opb2wb_v2_1_0.pao

    This Peripheral Analysis Order file defines the analysis order of all the HDL
    source files that are used to compile your peripheral.


- ISE project file(s)
  D:\telops\FIR-00142-RFILW\edk_project_v4/pcores/opb2wb_v1_00_a/devl/projnav

  opb2wb.npl

    This is the ProjNavigator project file. It sets up the needed logical
    libraries and dependent library files for you to help you develop your
    peripheral using ProjNavigator.

  opb2wb.cli

    This is the TCL command line file used to generate the .npl file.


- XST synthesis file(s)
  D:\telops\FIR-00142-RFILW\edk_project_v4/pcores/opb2wb_v1_00_a/devl/synthesis

  opb2wb_xst.scr

    This is the XST synthesis script file to compile your peripheral.
    Note: you may want to modify the device part option for your target.

  opb2wb_xst.prj

    This is the XST synthesis project file used by the above script file to
    compile your peripheral.


- Driver source file(s)
  D:\telops\FIR-00142-RFILW\edk_project_v4/drivers/opb2wb_v1_00_a/src

  opb2wb.h

    This is the software driver header template file, which contains address offset of
    software addressable registers in your peripheral, as well as some common masks and
    simple register access macros or function declaration.

  opb2wb.c

    This is the software driver source template file, to define all applicable driver
    functions.

  opb2wb_selftest.c

    This is the software driver self test example file, which contain self test example
    code to test various hardware features of your peripheral.

  Makefile

    This is the software driver makefile to compile drivers.


- Driver interface file(s)
  D:\telops\FIR-00142-RFILW\edk_project_v4/drivers/opb2wb_v1_00_a/data

  opb2wb_v2_1_0.mdd

    This is the Microprocessor Driver Definition file.

  opb2wb_v2_1_0.tcl

    This is the Microprocessor Driver Command file.


- Other misc file(s)
  D:\telops\FIR-00142-RFILW\edk_project_v4/pcores/opb2wb_v1_00_a/devl

  ipwiz.opt

    This is the option setting file for the wizard batch mode, which should
    generate the same result as the wizard GUI mode.

  README.txt

    This README file for your peripheral.

  ipwiz.log

    This is the log file by operating on this wizard.


================================================================================
*                         3) Description of Used IPIC Signals                  *
================================================================================
For more information (usage, timing diagrams, etc.) regarding the IPIC signals
used in the templates, please refer to the following specifications (under
%XILINX_EDK%\doc for windows or $XILINX_EDK/doc for solaris and linux):
proc_ip_ref_guide.pdf - Processor IP Reference Guide (chapter 4 IPIF)
user_core_templates_ref_guide.pdf - User Core Templates Reference Guide

Bus2IP_Clk
    This is the clock input to the user logic. All IPIC signals are synchronous 
    to this clock. It is identical to the <bus>_Clk signal that is an input to 
    the user core. In an OPB core, Bus2IP_Clk is the same as OPB_Clk, and in a 
    PLB core, it is the same as PLB_Clk. No additional buffering is provided on 
    the clock; it is passed through as is. 

Bus2IP_Reset
    Signal to reset the User Logic; asserts whenever the <bus>_Rst signal does 
    and, if the Reset block is included, whenever there is a software-programmed 
    reset. 

Bus2IP_Addr
    This is the address bus from the IPIF to the user logic. This bus is the 
    same width as the host bus address bus. The Bus2IP_Addr bus can be used for 
    additional address decoding or as input to addressable memory devices. 

Bus2IP_Data
    This is the data bus from the IPIF to the user logic; it is used for both 
    master and slave transactions. It is used to access user logic registers. 

Bus2IP_BE
    The Bus2IP_BE is a bus of Byte Enable qualifiers from the IPIF to the user 
    logic. A bit in the Bus2IP_BE set to '1' indicates that the associated byte 
    lane contains valid data. For example, if Bus2IP_BE = 0011, this indicates 
    that byte lanes 2 and 3 contains valid data. 

Bus2IP_Burst
    The Bus2IP_Burst signal from the IPIF to the user logic indicates that the 
    current transaction is a burst transaction. 

Bus2IP_RNW
    Bus2IP_RNW is an input to the user logic that indicates the transaction type 
    (read or write). Bus2IP_RNW = 1 indicates a read transaction and Bus2IP_RNW 
    = 0 indicates a write transaction. It is valid whenever at least one 
    Bus2IP_CS is active. 

Bus2IP_CS
    Bus2IP_CS is a bus of "chip" select signals from the IPIF to the user core. 
    It indicates a decode within a block of addresses defined by a base address 
    and a high address. The first bit of Bus2IP_CS always indicates a decode 
    within the user logic address space. In the simplest reference designs, 
    there is only one Bus2IP_CS signal. 

Bus2IP_RdCE
    The Bus2IP_RdCE bus is an input to the user logic. It is Bus2IP_CE qualified 
    by a read transaction. 

Bus2IP_WrCE
    The Bus2IP_WrCE bus is an input to the user logic. It is Bus2IP_CE qualified 
    by a write transaction. 

IP2Bus_Data
    This is the data bus from the user logic to the IPIF; it is used for both 
    master and slave transactions. It is used to access user logic registers. 

IP2Bus_Ack
    The IP2Bus_Ack signal provide the read/write acknowledgement from the user 
    logic to the IPIF. For writes, it indicates the data has been taken by the 
    user logic. For reads, it indicates that valid data is available. For 
    immediate acknowledgement (such as for a register read/write), this signal 
    can be tied to '1'. Wait states can be inserted in the transaction by 
    delaying the assertion of the acknowledgement. If the IP2Bus_Ack for OPB 
    cores will be delayed more than 8 clocks, then the IP2Bus_ToutSup (timeout 
    suppress) signal must also be asserted to prevent a timeout on the host bus. 

IP2Bus_Retry
    IP2Bus_Retry is a response from the user logic to the IPIF that indicates 
    the currently requested transaction cannot be completed at this time and 
    that the requesting master should retry the operation. If the IP2Bus_Retry 
    signal will be delayed more than 8 clocks, then the IP2Bus_ToutSup (timeout 
    suppress) signal must also be asserted to prevent a timeout on the host bus. 
    Note: this signal is unused by PLB IPIF. 

IP2Bus_Error
    This signal from the user logic to the IPIF indicates an error has occurred 
    during the current transaction. It is valid when IP2Bus_Ack is asserted. 

IP2Bus_ToutSup
    The IP2Bus_ToutSup must be asserted by the user logic whenever its 
    acknowledgement or retry response will take longer than 8 clock cycles. 

IP2Bus_PostedWrInh
    This signal from the user logic to the IPIF indicates that posted writes 
    should be inhibited. Normally burst write operations are treated as posted 
    writes to improve performance, but assertion of the IP2Bus_PostedWrInh 
    signal indicates that all writes should be treated as acknowledged write 
    transactions. 

IP2Bus_AddrAck
    The IP2Bus_AddrAck signal advances the IPIF address counter and request 
    state during multiple data beat transfers, s.t. bursting. 

================================================================================
*                     4) Description of Top Level Generics                     *
================================================================================
C_BASEADDR/C_HIGHADDR
    These two generics are used to define the memory mapped address space for
    the peripheral registers, including Reset/MIR register, Interrupt Source
    Controller registers, Read/Write FIFO control/data registers, user logic
    software accessible registers and etc., but excluding those user logic
    address ranges if ever used. When instantiation, the address space size
    determined by these two generics must be a power of 2 (e.g. 2^k =
    C_HIGHADDR - C_BASEADDR + 1), a factor of C_BASEADDR and larger than the
    minimum size as indicated in the template.

C_OPB_DWIDTH
    This is the data bus width for On-chip Peripheral Bus (OPB). It should
    always be set to 32 as of today.

C_OPB_AWIDTH
    This is the address bus width for On-chip Peripheral Bus (OPB). It should
    always be set to 32 as of today.

C_FAMILY
    This is to set the target FPGA architecture, s.t. virtex2, virtex2p, etc.

