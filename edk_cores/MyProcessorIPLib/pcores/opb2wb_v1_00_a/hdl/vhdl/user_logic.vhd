------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Wed Jan 16 14:12:27 2008 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library proc_common_v2_00_a;
use proc_common_v2_00_a.proc_common_pkg.all;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_AWIDTH                     -- User logic address bus width
--   C_DWIDTH                     -- User logic data bus width
--   C_NUM_CS                     -- User logic chip select bus width
--   C_NUM_CE                     -- User logic chip enable bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_Data                  -- Bus to IP data bus for user logic
--   Bus2IP_BE                    -- Bus to IP byte enables for user logic
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_CS                    -- Bus to IP chip select for user logic
--   Bus2IP_RdCE                  -- Bus to IP read chip enable for user logic
--   Bus2IP_WrCE                  -- Bus to IP write chip enable for user logic
--   IP2Bus_Data                  -- IP to Bus data bus for user logic
--   IP2Bus_Ack                   -- IP to Bus acknowledgement
--   IP2Bus_Retry                 -- IP to Bus retry response
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_ToutSup               -- IP to Bus timeout suppress
--   IP2Bus_PostedWrInh           -- IP to Bus posted write inhibit
--   IP2Bus_AddrAck               -- IP to Bus address acknowledgement
--   WB_CLK                       -- WishBone Slave Interfacing Signals
--   WB_ADDR_O
--   WB_DATA_O
--   WB_CYC_O
--   WB_STB_O
--   WB_SEL_O
--   WB_WE_O
--   WB_DATA_I
--   WB_ACK_I
--   WB_ERR_I
--   WB_RTY_I
------------------------------------------------------------------------------

entity user_logic is
   generic
      (
      -- Bus protocol parameters, do not add to or delete
      C_AWIDTH                       : integer              := 32;
      C_DWIDTH                       : integer              := 32;
      C_NUM_CS                       : integer              := 1;
      C_NUM_CE                       : integer              := 1
      );
   
   port
      (
      Bus2IP_Clk                     : in  std_logic;
      Bus2IP_Reset                   : in  std_logic;
      Bus2IP_Addr                    : in  std_logic_vector(0 to C_AWIDTH-1);
      Bus2IP_Data                    : in  std_logic_vector(0 to C_DWIDTH-1);
      Bus2IP_BE                      : in  std_logic_vector(0 to C_DWIDTH/8-1);
      Bus2IP_Burst                   : in  std_logic;
      Bus2IP_CS                      : in  std_logic_vector(0 to C_NUM_CS-1);
      Bus2IP_RNW                     : in  std_logic;
      IP2Bus_Data                    : out std_logic_vector(0 to C_DWIDTH-1);
      IP2Bus_Ack                     : out std_logic;
      IP2Bus_Retry                   : out std_logic;
      IP2Bus_Error                   : out std_logic;
      IP2Bus_ToutSup                 : out std_logic;
      IP2Bus_PostedWrInh             : out std_logic;
      IP2Bus_AddrAck                 : out std_logic;
      WB_CLK                         : out std_logic;
      WB_ADDR_O                      : out std_logic_vector(0 to C_AWIDTH-1);
      WB_DATA_O                      : out std_logic_vector(0 to C_DWIDTH-1);
      WB_CYC_O                       : out std_logic;
      WB_STB_O                       : out std_logic;
      WB_SEL_O                       : out std_logic_vector(0 to C_DWIDTH/8-1);
      WB_WE_O                        : out std_logic;
      WB_DATA_I                      : in std_logic_vector(0 to C_DWIDTH-1);
      WB_ACK_I                       : in std_logic;
      WB_ERR_I                       : in std_logic; 
      WB_RTY_I                       : in std_logic
      );
end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is
   
begin

   -- WishBone CLK mapping
   WB_CLK <= Bus2IP_Clk;
   
   -- WishBone MOSI mapping
   WB_ADDR_O <= Bus2IP_Addr;
   WB_CYC_O <= Bus2IP_CS(0);
   WB_STB_O <= Bus2IP_CS(0);
   WB_SEL_O <= Bus2IP_BE;
   WB_WE_O <= not(Bus2IP_RNW) and Bus2IP_CS(0);
   WB_DATA_O <= Bus2IP_Data;
   
   -- WishBone MISO mapping
   IP2Bus_Data <= WB_DATA_I;
   IP2Bus_Ack <= WB_ACK_I;
   IP2Bus_Error <= WB_ERR_I;
   IP2Bus_Retry <= WB_RTY_I;
   
   -- Other IPIF signals
   IP2Bus_AddrAck <= '1';
   IP2Bus_ToutSup <= '1';
   IP2Bus_PostedWrInh <= '1'; -- request full handshake
   
end IMP;
