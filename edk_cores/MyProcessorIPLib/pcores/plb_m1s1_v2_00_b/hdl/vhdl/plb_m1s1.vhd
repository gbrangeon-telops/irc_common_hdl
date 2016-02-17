------------------------------------------------------------------
--
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--     FOR A PARTICULAR PURPOSE.
--
--     (c) Copyright 2005 Xilinx, Inc.
--     All rights reserved.
--
---------------------------------------------------------------------------
-- plb_m1s1.vhd - entity/architecture pair
---------------------------------------------------------------------------
-- Filename:        plb_m1s1.vhd
-- Version:         v1.00a
-- Description:     This file is the top-level VHDL file for the Xilinx PLB
--                  arbiter. It instantiates the necessary components to 
--                  build the Xilinx PLB Arbiter Design for a single master
--                  single slave
-- 
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--          plb_m1s1.vhd
--
-------------------------------------------------------------------------------
-- Author:      LCH
-- History:
--  LCH         03/01/04        -- First version, taken from plb_v34 v1.01a
--  JRL         05/10/06        -- Corrected PAValid logic so that it will not
--                                 be asserted while SAValid should be
--                                 asserted.
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_cmb" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
-- Port Declaration
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Generics:
--          C_PLB_NUM_MASTERS   -- number of masters on the PLB
--          C_PLB_NUM_SLAVES    -- number of slaves on the PLB
--          C_PLB_MID_WIDTH     -- number of bits to encode the number of masters
--          C_PLB_AWIDTH        -- PLB address bus width
--          C_PLB_DWIDTH        -- PLB data bus width
--          C_DCR_INTFCE        -- include DCR interface
--          C_BASEADDR          -- DCR base address
--          C_HIGHADDR          -- DCR high address
--          C_DCR_AWIDTH        -- DCR address bus width
--          C_DCR_DWIDTH        -- DCR data bus width
--          C_EXT_RESET_HIGH    -- external reset is active high
--          C_IRQ_ACTIVE        -- active interrupt edge (rising or falling)
--
-- Definition of Ports:
--
--      -- DCR signals
--          input DCR_ABus     
--          input DCR_Read          
--          input DCR_Write 
--          input DCR_DBus
--          output PLB_dcrAck 
--          output PLB_dcrDBus
--  
--      -- Master signals
--          input M_ABus            
--          input M_BE              
--          input M_RNW             
--          input M_abort           
--          input M_busLock         
--          input M_compress        
--          input M_guarded         
--          input M_lockErr         
--          input M_MSize           
--          input M_ordered         
--          input M_priority        
--          input M_rdBurst         
--          input M_request         
--          input M_size            
--          input M_type            
--          input M_wrBurst         
--          input M_wrDBus          
--  
--      -- PLB signals
--          output PLB_ABus             
--          output PLB_BE           
--          output PLB_MAddrAck         
--          output PLB_MBusy        
--          output PLB_MErr             
--          output PLB_MRdBTerm         
--          output PLB_MRdDAck      
--          output PLB_MRdDBus      
--          output PLB_MRdWdAddr    
--          output PLB_MRearbitrate 
--          output PLB_MWrBTerm         
--          output PLB_MWrDAck      
--          output PLB_MSSize           
--          output PLB_PAValid      
--          output PLB_RNW          
--          output PLB_SAValid      
--          output PLB_abort        
--          output PLB_busLock      
--          output PLB_compress         
--          output PLB_guarded      
--          output PLB_lockErr      
--          output PLB_masterID         
--          output PLB_MSize        
--          output PLB_ordered      
--          output PLB_pendPri      
--          output PLB_pendReq      
--          output PLB_rdBurst      
--          output PLB_rdPrim       
--          output PLB_reqPri       
--          output PLB_size             
--          output PLB_type             
--          output PLB_wrBurst      
--          output PLB_wrDBus       
--          output PLB_wrPrim       
--  
--      -- Slave signals
--          input Sl_MBusy          
--          input Sl_MErr           
--          input Sl_addrAck        
--          input Sl_rdBTerm        
--          input Sl_rdComp         
--          input Sl_rdDAck         
--          input Sl_rdDBus         
--          input Sl_rdWdAddr       
--          input Sl_rearbitrate    
--          input Sl_SSize          
--          input Sl_wait           
--          input Sl_wrBTerm        
--          input Sl_wrComp         
--          input Sl_wrDAck        
--
--      -- Output from Slave OR gates
--          output PLB_SaddrAck     
--          output PLB_SMErr        
--          output PLB_SMBusy       
--          output PLB_SrdBTerm     
--          output PLB_SrdComp      
--          output PLB_SrdDAck      
--          output PLB_SrdDBus      
--          output PLB_SrdWdAddr    
--          output PLB_Srearbitrate 
--          output PLB_Sssize       
--          output PLB_Swait        
--          output PLB_SwrBTerm     
--          output PLB_SwrComp      
--          output PLB_SwrDAck      
--
--      -- arbiter output indicating either PAValid or SAValid is asserted
--          output ArbAddrVldReg    
--                      
--      -- Clock, Interrupt, and Resets
--          input PLB_Clk
--          input SYS_Rst
--          output Bus_Error_Det
--          output PLB_Rst
--
-------------------------------------------------------------------------------
 
library ieee;
use ieee.std_logic_1164.all;

-- UNISIM library contains the SRL16 and FDS primitives required for the power-on
-- reset logic
library unisim;
use unisim.all;

-------------------------------------------------------------------------------
-- Entity Section
-------------------------------------------------------------------------------
entity plb_m1s1 is
    generic (
             C_PLB_NUM_MASTERS  : integer := 4;  
             C_PLB_NUM_SLAVES   : integer := 8;
             C_PLB_MID_WIDTH    : integer := 2;
             C_PLB_AWIDTH       : integer := 32;  
             C_PLB_DWIDTH       : integer := 64; 
             C_DCR_INTFCE       : integer := 1;
             -- set BASEADDR and HIGHADDR defaults to unused state
             C_BASEADDR         : std_logic_vector := "1111111111"; 
             C_HIGHADDR         : std_logic_vector := "0000000000";
             C_DCR_AWIDTH       : integer := 10;
             C_DCR_DWIDTH       : integer := 32;
             C_EXT_RESET_HIGH   : integer   := 1;
             C_IRQ_ACTIVE       : std_logic := '1'
             );
    port (
          DCR_ABus          : in std_logic_vector(0 to C_DCR_AWIDTH - 1 );
          DCR_DBus          : in std_logic_vector(0 to C_DCR_DWIDTH - 1 );
          DCR_Read          : in std_logic;
          DCR_Write         : in std_logic;
          PLB_dcrAck        : out std_logic;
          PLB_dcrDBus       : out std_logic_vector(0 to C_DCR_DWIDTH - 1 );
          M_ABus            : in std_logic_vector(0 to (C_PLB_NUM_MASTERS * C_PLB_AWIDTH) - 1 );
          M_BE              : in std_logic_vector(0 to (C_PLB_NUM_MASTERS * (C_PLB_DWIDTH / 8)) - 1 );
          M_RNW             : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_abort           : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_busLock         : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_compress        : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_guarded         : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_lockErr         : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_MSize           : in std_logic_vector(0 to (C_PLB_NUM_MASTERS * 2) - 1 );
          M_ordered         : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_priority        : in std_logic_vector(0 to (C_PLB_NUM_MASTERS * 2) - 1 );
          M_rdBurst         : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_request         : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_size            : in std_logic_vector(0 to (C_PLB_NUM_MASTERS * 4) - 1 );
          M_type            : in std_logic_vector(0 to (C_PLB_NUM_MASTERS * 3) - 1 );
          M_wrBurst         : in std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          M_wrDBus          : in std_logic_vector(0 to (C_PLB_NUM_MASTERS * C_PLB_DWIDTH) - 1 );
          PLB_ABus          : out std_logic_vector(0 to C_PLB_AWIDTH - 1 );
          PLB_BE            : out std_logic_vector(0 to (C_PLB_DWIDTH / 8) - 1 );
          PLB_MAddrAck      : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MBusy         : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MErr          : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MRdBTerm      : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MRdDAck       : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MRdDBus       : out std_logic_vector(0 to (C_PLB_NUM_MASTERS*C_PLB_DWIDTH)-1);
          PLB_MRdWdAddr     : out std_logic_vector(0 to (C_PLB_NUM_MASTERS * 4) - 1 );
          PLB_MRearbitrate  : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MWrBTerm      : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MWrDAck       : out std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
          PLB_MSSize        : out std_logic_vector(0 to (C_PLB_NUM_MASTERS * 2) - 1 );
          PLB_PAValid       : out std_logic;
          PLB_RNW           : out std_logic;
          PLB_SAValid       : out std_logic;
          PLB_abort         : out std_logic;
          PLB_busLock       : out std_logic;
          PLB_compress      : out std_logic;
          PLB_guarded       : out std_logic;
          PLB_lockErr       : out std_logic;
          PLB_masterID      : out std_logic_vector(0 to C_PLB_MID_WIDTH-1);
          PLB_MSize         : out std_logic_vector(0 to 1 );
          PLB_ordered       : out std_logic;
          PLB_pendPri       : out std_logic_vector(0 to 1 );
          PLB_pendReq       : out std_logic;
          PLB_rdBurst       : out std_logic;
          PLB_rdPrim        : out std_logic;
          PLB_reqPri        : out std_logic_vector(0 to 1 );
          PLB_size          : out std_logic_vector(0 to 3 );
          PLB_type          : out std_logic_vector(0 to 2 );
          PLB_wrBurst       : out std_logic;
          PLB_wrDBus        : out std_logic_vector(0 to C_PLB_DWIDTH - 1 );
          PLB_wrPrim        : out std_logic;
          
          Sl_addrAck        : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1 );
          Sl_MErr           : in std_logic_vector(0 to C_PLB_NUM_SLAVES*C_PLB_NUM_MASTERS - 1 );
          Sl_MBusy          : in std_logic_vector(0 to C_PLB_NUM_SLAVES*C_PLB_NUM_MASTERS - 1 );
          Sl_rdBTerm        : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1);
          Sl_rdComp         : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1);
          Sl_rdDAck         : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1);
          Sl_rdDBus         : in std_logic_vector(0 to C_PLB_NUM_SLAVES*C_PLB_DWIDTH - 1 );
          Sl_rdWdAddr       : in std_logic_vector(0 to C_PLB_NUM_SLAVES*4 - 1 );
          Sl_rearbitrate    : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1 );
          Sl_SSize          : in std_logic_vector(0 to C_PLB_NUM_SLAVES*2 - 1 );
          Sl_wait           : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1 );
          Sl_wrBTerm        : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1 );
          Sl_wrComp         : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1 );
          Sl_wrDAck         : in std_logic_vector(0 to C_PLB_NUM_SLAVES - 1 );

          -- Outputs of Slave OR gates are only used in simulation to connect
          -- to the IBM PLB Monitor
          PLB_SaddrAck      : out std_logic;
          PLB_SMErr         : out std_logic_vector(0 to C_PLB_NUM_MASTERS-1);   
          PLB_SMBusy        : out std_logic_vector(0 to C_PLB_NUM_MASTERS-1);   
          PLB_SrdBTerm      : out std_logic;   
          PLB_SrdComp       : out std_logic;
          PLB_SrdDAck       : out std_logic;
          PLB_SrdDBus       : out std_logic_vector(0 to C_PLB_DWIDTH-1);   
          PLB_SrdWdAddr     : out std_logic_vector(0 to 3);
          PLB_Srearbitrate  : out std_logic;
          PLB_Sssize        : out std_logic_vector(0 to 1);
          PLB_Swait         : out std_logic;
          PLB_SwrBTerm      : out std_logic;
          PLB_SwrComp       : out std_logic;
          PLB_SwrDAck       : out std_logic;

          ArbAddrVldReg     : out std_logic;
          SYS_Rst           : in std_logic;
          Bus_Error_Det     : out std_logic;
          PLB_Rst           : out std_logic;
          PLB_Clk           : in std_logic
          );
 
    -- fan-out attributes for Synplicity
    attribute syn_maxfan                  : integer;
    attribute syn_maxfan   of PLB_Clk     : signal is 10000;
    attribute syn_maxfan   of PLB_Rst     : signal is 10000;
    --fan-out attributes for XST
    attribute MAX_FANOUT                  : string;
    attribute MAX_FANOUT   of PLB_Clk     : signal is "10000";
    attribute MAX_FANOUT   of PLB_Rst     : signal is "10000";
 
end plb_m1s1;
 
-------------------------------------------------------------------------------
-- Architecture Section
-------------------------------------------------------------------------------
architecture simulation of plb_m1s1 is

-----------------------------------------------------------------------------
-- Constant Declarations
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Signal Declarations
-----------------------------------------------------------------------------
-- internal arbiter registers
signal arbAddrSelReg        : std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
signal arbBurstReq          : std_logic;
signal arbPriRdMasterRegReg : std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );
signal arbPriWrMasterReg    : std_logic_vector(0 to C_PLB_NUM_MASTERS - 1 );

--   internal versions of output signals
signal plb_abus_i           : std_logic_vector(0 to C_PLB_AWIDTH - 1 );
signal plb_be_i             : std_logic_vector(0 to C_PLB_DWIDTH/8-1);
signal plb_size_i           : std_logic_vector(0 to 3 );
signal plb_type_i           : std_logic_vector(0 to 2);
signal plb_rst_i            : std_logic;

signal plb_saddrack_i       : std_logic;   
signal plb_smerr_i          : std_logic_vector(0 to C_PLB_NUM_MASTERS-1);
signal plb_smbusy_i         : std_logic_vector(0 to C_PLB_NUM_MASTERS-1);
signal plb_srdbterm_i       : std_logic;   
signal plb_srdcomp_i        : std_logic;
signal plb_srddack_i        : std_logic;
signal plb_srddbus_i        : std_logic_vector(0 to C_PLB_DWIDTH-1); 
signal plb_srdwdaddr_i      : std_logic_vector(0 to 3);
signal plb_srearbitrate_i   : std_logic;
signal plb_sssize_i         : std_logic_vector(0 to 1);
signal plb_swait_i          : std_logic;
signal plb_swrbterm_i       : std_logic;
signal plb_swrcomp_i        : std_logic;
signal plb_swrdack_i        : std_logic;

--   Data ACKs and rdWdAddr from watchdog timer
signal wdtRdDAck            : std_logic;
signal wdtWrDAck            : std_logic;
signal plb_rdWdAddrWDT      : std_logic_vector(0 to 3);

-- Power-on reset signals and attributes
signal srl_time_out         : std_logic; 
signal ext_rst_i            : std_logic; 
signal por_FF_out           : std_logic; 

signal read_primary_active  : std_logic;
signal write_primary_active : std_logic;
signal PLB_PAValid_i        : std_logic;
signal PLB_RNW_i            : std_logic;
signal PLB_Abort_i          : std_logic;

attribute INIT              : string; 
attribute INIT of POR_SRL_I : label is "FFFF"; 

-----------------------------------------------------------------------------
-- Component Declarations
-----------------------------------------------------------------------------
-- SRL16 and FDS are used in the power-on reset circuit
component SRL16 is 
-- synthesis translate_off 
  generic ( 
        INIT : bit_vector ); 
-- synthesis translate_on 
  port (D    : in  std_logic; 
        CLK  : in  std_logic; 
        A0   : in  std_logic; 
        A1   : in  std_logic; 
        A2   : in  std_logic; 
        A3   : in  std_logic; 
        Q    : out std_logic); 
end component SRL16; 

component FDS is 
   port( 
      Q : out std_logic; 
      D : in  std_logic; 
      C : in  std_logic; 
      S : in  std_logic); 
end component FDS;



-------------------------------------------------------------------------------
-- Begin architecture
-------------------------------------------------------------------------------
begin

   -- DCR
   PLB_dcrAck <= '0';
   PLB_dcrDBus <= X"00000000";

   -- PLB signals
   PLB_ABus <= M_ABus(0 to (C_PLB_AWIDTH - 1));
   PLB_BE <= M_BE(0 to (C_PLB_DWIDTH / 8) - 1);
   PLB_MAddrAck <= Sl_addrAck(0 to 0);
   PLB_MBusy <= Sl_MBusy(0 to 0);
   PLB_MErr <= Sl_MErr(0 to 0);
   PLB_MRdBTerm <= Sl_rdBTerm(0 to 0);
   PLB_MRdDAck <= Sl_rdDAck(0 to 0);
   PLB_MRdDBus <= Sl_rdDBus(0 to C_PLB_DWIDTH - 1);
   PLB_MRdWdAddr <= Sl_rdWdAddr(0 to 3);
   PLB_MRearbitrate <= Sl_rearbitrate(0 to 0);
   PLB_MWrBTerm <= Sl_wrBTerm(0 to 0);
   PLB_MWrDAck <= Sl_wrDAck(0 to 0);
   PLB_MSSize <= Sl_SSize(0 to 1);
   PLB_PAValid_i <= M_request(0) and
                  ((M_RNW(0) and not(read_primary_active)) or
                   (not(M_RNW(0)) and not(write_primary_active)));
   PLB_PAValid <= PLB_PAValid_i;
   PLB_RNW_i <= M_RNW(0);
   PLB_RNW <= PLB_RNW_i;
   PLB_SAValid <= '0';                     -- unused
   PLB_abort_i <= M_abort(0) and PLB_PAValid_i;
   PLB_abort <= PLB_abort_i;
   PLB_busLock <= M_busLock(0);
   PLB_compress <= M_compress(0);
   PLB_guarded <= M_guarded(0);
   PLB_lockErr <= M_lockErr(0);
   PLB_masterID <= (others => '0');
   PLB_MSize <= M_MSize(0 to 1);
   PLB_ordered <= M_ordered(0);
   PLB_pendPri <= "00";
   PLB_pendReq <= M_request(0);
   PLB_rdBurst <= '0';
   PLB_rdPrim <= '0';
   PLB_reqPri <= "00";
   PLB_size <= M_size(0 to 3);
   PLB_type <= M_type(0 to 2);
   PLB_wrBurst <= M_wrBurst(0);
   PLB_wrDBus <= M_wrDBus(0 to C_PLB_DWIDTH - 1);
   PLB_wrPrim <= '0';


   read_primary_active_PROCESS: process (PLB_Clk)
   begin
     if PLB_Clk'event and PLB_Clk = '1' then 
       if plb_rst_i = '1' then
         read_primary_active <= '0';
       elsif ((PLB_PAValid_i = '1') and (PLB_RNW_i = '1') and (Sl_addrAck(0) = '1') and (PLB_abort_i = '0') and (Sl_rdComp(0) = '0')) then
         read_primary_active <= '1';
       elsif (Sl_rdComp(0) = '1') then
         read_primary_active <= '0';
       else
         read_primary_active <= read_primary_active;
       end if;
     end if;
   end process read_primary_active_PROCESS;

   write_primary_active_PROCESS: process (PLB_Clk)
   begin
     if PLB_Clk'event and PLB_Clk = '1' then 
       if plb_rst_i = '1' then
         write_primary_active <= '0';
       elsif ((PLB_PAValid_i = '1') and (PLB_RNW_i = '0') and (Sl_addrAck(0) = '1') and (PLB_abort_i = '0') and (Sl_wrComp(0) = '0')) then
         write_primary_active <= '1';
       elsif (Sl_wrComp(0) = '1') then
         write_primary_active <= '0';
       else
         write_primary_active <= write_primary_active;
       end if;
     end if;
   end process write_primary_active_PROCESS;

 PLB_SaddrAck     <= Sl_addrAck(0);
 PLB_SMErr(0)     <= Sl_MErr(0);   
 PLB_SMBusy(0)    <= Sl_MBusy(0);
 PLB_SrdBTerm     <= Sl_rdBTerm(0);   
 PLB_SrdComp      <= Sl_rdComp(0);   
 PLB_SrdDAck      <= Sl_rdDAck(0);    
 PLB_SrdDBus(0 to C_PLB_DWIDTH-1) <= Sl_rdDBus(0 to C_PLB_DWIDTH-1);   
 PLB_SrdWdAddr(0 to 3) <= Sl_rdWdAddr(0 to 3); 
 PLB_Srearbitrate <= Sl_rearbitrate(0);
 PLB_Sssize(0 to 1) <= Sl_ssize(0 to 1);  
 PLB_Swait        <= Sl_wait(0);
 PLB_SwrBTerm     <= Sl_wrBTerm(0); 
 PLB_SwrComp      <= Sl_wrComp(0);
 PLB_SwrDAck      <= Sl_wrDAck(0);

PLB_Rst     <= plb_rst_i;

-----------------------------------------------------------------------------
-- Power-on Reset Process
-----------------------------------------------------------------------------
-- This process starts with a flip-flop that is set upon configuration or
-- power-up which outputs the reset for the PLB bus. This flip-flop is also
-- synchronously set by an external reset if one is available. A zero is 
-- shifted through an SRL16 so that 16 clocks later, the flip-flop clocks
-- in a zero and the reset is negated. The output of this flip-flop is 
-- registered once more to insure synchronization with the PLB_Clk. Note that
-- this power-up reset does not take into account if the DCMs are Locked. It
-- is assumed that the external reset signal has accounted for this.
-----------------------------------------------------------------------------
PLB_RST_PROCESS: process (SYS_Rst) is 
    variable ext_rst_input : std_logic; 
begin 
    if C_EXT_RESET_HIGH = 0 then 
      ext_rst_input := not(SYS_Rst); 
    else 
      ext_rst_input := SYS_Rst; 
    end if; 
    ext_rst_i <= ext_rst_input; 
end process PLB_RST_PROCESS; 
  
POR_SRL_I: SRL16 
-- synthesis translate_off 
    generic map ( 
      INIT => X"FFFF") 
-- synthesis translate_on 
    port map ( 
      D   => '0', 
      CLK => PLB_Clk, 
      A0  => '1', 
      A1  => '1', 
      A2  => '1', 
      A3  => '1', 
      Q   => srl_time_out); 
  
  POR_FF1_I: FDS 
    port map ( 
      Q   => por_FF_out, 
      D   => srl_time_out, 
      C   => PLB_Clk, 
      S   => ext_rst_i); 

  POR_FF2_I: FDS 
    port map ( 
      Q   => plb_rst_i, 
      D   => por_FF_out, 
      C   => PLB_Clk, 
      S   => '0'); 
 
-----------------------------------------------------------------------------
-- Component Instantiations
----------------------------------------------------------------------------- 

end simulation;

