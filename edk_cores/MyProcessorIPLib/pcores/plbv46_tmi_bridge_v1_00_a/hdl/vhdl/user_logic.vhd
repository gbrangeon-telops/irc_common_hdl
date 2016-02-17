------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.            **
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
-- Date:              Wed Mar 24 14:42:01 2010 (by Create and Import Peripheral Wizard)
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

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   

library proc_common_v2_00_a;
use proc_common_v2_00_a.proc_common_pkg.all;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_MEM                    -- Number of memory spaces
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select for user logic memory selection
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
   generic
      (
      -- ADD USER GENERICS BELOW THIS LINE ---------------
      C_TMI_ALEN                    : natural := 21;
      -- ADD USER GENERICS ABOVE THIS LINE ---------------

      -- DO NOT EDIT BELOW THIS LINE ---------------------
      -- Bus protocol parameters, do not add to or delete
      C_SLV_AWIDTH                  : integer              := 32;
      C_SLV_DWIDTH                  : integer              := 32;
      C_NUM_MEM                     : integer              := 1
      -- DO NOT EDIT ABOVE THIS LINE ---------------------
      );
   port
      (
      -- ADD USER PORTS BELOW THIS LINE ------------------
      TMI_IDLE                      : in  std_logic;
      TMI_ERROR                     : in  std_logic;
      TMI_RNW                       : out std_logic;
      TMI_ADD                       : out std_logic_vector(C_TMI_ALEN-1 downto 0);
      TMI_DVAL                      : out std_logic;
      TMI_BUSY                      : in  std_logic;
      TMI_RD_DATA                   : in  std_logic_vector(31 downto 0);
      TMI_RD_DVAL                   : in  std_logic;
      TMI_WR_DATA                   : out std_logic_vector(31 downto 0);
      TMI_CLK                       : out  std_logic;
      -- ADD USER PORTS ABOVE THIS LINE ------------------

      -- DO NOT EDIT BELOW THIS LINE ---------------------
      -- Bus protocol ports, do not add to or delete
      Bus2IP_Clk                     : in  std_logic;
      Bus2IP_Reset                   : in  std_logic;
      Bus2IP_Addr                    : in  std_logic_vector(0 to C_SLV_AWIDTH-1);
      Bus2IP_CS                      : in  std_logic_vector(0 to C_NUM_MEM-1);
      Bus2IP_RNW                     : in  std_logic;
      Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
      Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
      IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
      IP2Bus_RdAck                   : out std_logic;
      IP2Bus_WrAck                   : out std_logic;
      IP2Bus_Error                   : out std_logic
      -- DO NOT EDIT ABOVE THIS LINE ---------------------
      );

   attribute SIGIS : string;
   attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
   attribute SIGIS of Bus2IP_Reset  : signal is "RST";
   attribute keep_hierarchy : string;
   attribute keep_hierarchy of user_logic: entity is "yes";    

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

   --USER signal declarations added here, as needed for user logic
	signal tmi_dval_s 					: std_logic;
	signal tmi_busy_Fedge_s 			: std_logic;	
	signal mem_select_dly1 				: std_logic;
	signal tmi_busy_dly1                : std_logic;
	signal mem_select_Redge             : std_logic;
   ------------------------------------------
   -- Signals for user logic memory space example
   ------------------------------------------   
   signal mem_select                     : std_logic_vector(0 to 0);   
   signal mem_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);   
   signal mem_read_ack                   : std_logic;
   signal mem_write_ack                  : std_logic;

begin

   --USER logic implementation added here
   ------------------------------------------
   
   --Ignored signals list:
   -- TMI_IDLE
   -- TMI_ERROR        
   -----------------------------------------
   -- ena/valid signal for memory. Should be
   -- one clock pulse if not TMI_BUSY.	
   -----------------------------------------
   mem_select      <= Bus2IP_CS;
   
   -- Falling edge detector
   process( Bus2IP_Clk ) is   
   begin
     if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
        if ( Bus2IP_Reset = '1' ) then
           tmi_busy_dly1 <= '0';
        else
           tmi_busy_dly1 <= TMI_BUSY;
        end if;
     end if;
   end process;
   tmi_busy_Fedge_s <= not(TMI_BUSY) and tmi_busy_dly1;  
   
   -- Rising edge detector
   process( Bus2IP_Clk ) is   
   begin
     if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
        if ( Bus2IP_Reset = '1' ) then
           mem_select_dly1 <= '0';
        else
           mem_select_dly1 <= mem_select(0);
        end if;
     end if;
   end process;
   mem_select_Redge <= mem_select(0) and not(mem_select_dly1);  
              
      
   TMI_DVAL <= ((mem_select_Redge and not(TMI_BUSY))or tmi_busy_Fedge_s) and mem_select(0);
      
   -- R not W
   TMI_RNW	<= Bus2IP_RNW;
   
   -- Memory address line signal.   
   TMI_ADD	<= Bus2IP_Addr(C_SLV_AWIDTH-(C_TMI_ALEN+2) to C_SLV_AWIDTH-3);
   
   -- Read ack for plb
   mem_read_ack <= TMI_RD_DVAL;
   
   -- Write data.
   TMI_WR_DATA <= Bus2IP_Data;
   
   -- Write ack.
   mem_write_ack   <= ( Bus2IP_CS(0) ) and not(Bus2IP_RNW) and not(TMI_BUSY);
   
   -- Clock out to drive the R/W client side logic
   TMI_CLK <= Bus2IP_Clk;
   
   ------------------------------------------
   -- Example code to access user logic memory region
   --
   -- Note:
   -- The example code presented here is to show you one way of using
   -- the user logic memory space features. The Bus2IP_Addr, Bus2IP_CS,
   -- and Bus2IP_RNW IPIC signals are dedicated to these user logic
   -- memory spaces. Each user logic memory space has its own address
   -- range and is allocated one bit on the Bus2IP_CS signal to indicated
   -- selection of that memory space. Typically these user logic memory
   -- spaces are used to implement memory controller type cores, but it
   -- can also be used in cores that need to access additional address space
   -- (non C_BASEADDR based), s.t. bridges. This code snippet infers
   -- 1 256x32-bit (byte accessible) single-port Block RAM by XST.
   ------------------------------------------

   -- implement Block RAM read mux
   MEM_IP2BUS_DATA_PROC : process( TMI_RD_DATA, mem_select ) is
   begin

      case mem_select is
         when "1" => mem_ip2bus_data <= TMI_RD_DATA;
         when others => mem_ip2bus_data <= (others => '0');
      end case;

   end process MEM_IP2BUS_DATA_PROC;

   ------------------------------------------
   -- Example code to drive IP to Bus signals
   ------------------------------------------
   IP2Bus_Data  <= mem_ip2bus_data when mem_read_ack = '1' else
   (others => '0');

   IP2Bus_WrAck <= mem_write_ack;
   IP2Bus_RdAck <= mem_read_ack;
   IP2Bus_Error <= '0';

end IMP;
