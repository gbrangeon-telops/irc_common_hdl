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
-- Date:              Tue Nov 10 13:21:11 2009 (by Create and Import Peripheral Wizard)
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

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
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_NUM_MEM                      : integer              := 1
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    WB_CLK_O                       : out std_logic;
    WB_RST_O                       : out std_logic;
    WB_ADR_O                       : out std_logic_vector(0 to 31);
    WB_DAT_O                       : out std_logic_vector(0 to C_SLV_DWIDTH-1);
    WB_SEL_O                       : out std_logic_vector(0 to (C_SLV_DWIDTH/8)-1);
    WB_CYC_O                       : out std_logic;
    WB_STB_O                       : out std_logic;
    WB_WE_O                        : out std_logic;
    WB_DAT_I                       : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
    WB_ACK_I                       : in  std_logic;
    WB_ERR_I                       : in  std_logic;
    WB_RTY_I                       : in  std_logic;
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
  
  attribute keep : string;
  attribute keep of Bus2IP_Addr         : signal is "yes";    
  attribute keep of Bus2IP_CS           : signal is "yes";
  attribute keep of Bus2IP_RNW          : signal is "yes";
  attribute keep of Bus2IP_Data         : signal is "yes";
  attribute keep of Bus2IP_BE           : signal is "yes";
  attribute keep of IP2Bus_Data         : signal is "yes";
  attribute keep of IP2Bus_RdAck        : signal is "yes";
  attribute keep of IP2Bus_WrAck        : signal is "yes";
  attribute keep of IP2Bus_Error        : signal is "yes";
  

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --attribute keep_hierarchy : string;
  --attribute keep_hierarchy of user_logic: architecture is "yes";  

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic memory space example
  ------------------------------------------
  type BYTE_RAM_TYPE is array (0 to 255) of std_logic_vector(0 to 7);
  type DO_TYPE is array (0 to C_NUM_MEM-1) of std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal mem_data_out                   : DO_TYPE;
  signal mem_address                    : std_logic_vector(0 to 7);
  signal mem_select                     : std_logic_vector(0 to 0);
  signal mem_read_enable                : std_logic;
  signal mem_read_enable_dly1           : std_logic;
  signal mem_read_req                   : std_logic;
  signal mem_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal mem_read_ack_dly1              : std_logic;
  signal mem_read_ack                   : std_logic;
  signal mem_write_ack                  : std_logic;
  
  signal RdAck : std_logic;
  signal WrAck : std_logic;
  
  signal cyc : std_logic;

begin

   WB_CLK_O <= Bus2IP_Clk;
   IP2Bus_WrAck <= WrAck;
   IP2Bus_RdAck <= RdAck;
   IP2Bus_Error <= '0';         
   WB_RST_O <= Bus2IP_Reset;
   
   WB_STB_O <= cyc;
   WB_CYC_O <= cyc;
      
   process(Bus2IP_Clk)
   begin
      if rising_edge(Bus2IP_Clk) then
         -- WishBone MOSI mapping
         WB_ADR_O <= Bus2IP_Addr;
         --WB_CYC_O <= Bus2IP_CS(0);
         --WB_STB_O <= Bus2IP_CS(0);
         WB_SEL_O <= Bus2IP_BE;
         WB_WE_O <= not(Bus2IP_RNW);
         WB_DAT_O <= Bus2IP_Data;               
         
         -- WishBone MISO mapping
         IP2Bus_Data <= WB_DAT_I;   
                  
         -- We want to lower WB_CYC_O as soon as possible (as soon as we have an ack)
         if (Bus2IP_CS(0) = '1' and RdAck = '0' and WrAck = '0') then
            cyc <= '1';
         else
            cyc <= '0';
         end if;
         
         -- Ack MUST be one cycle, not longer. This code is to ensure that.
         if (Bus2IP_CS(0) = '1' and WB_ACK_I = '1' and Bus2IP_RNW = '1' and RdAck = '0') then              
            RdAck <= '1';
            cyc <= '0';
         else
            RdAck <= '0';
         end if;
         
         -- Ack MUST be one cycle, not longer. This code is to ensure that.
         if (Bus2IP_CS(0) = '1' and WB_ACK_I = '1' and Bus2IP_RNW = '0' and WrAck = '0') then              
            WrAck <= '1';
            cyc <= '0';
         else
            WrAck <= '0';
         end if;         
         
--         -- Stop Wishbone bus cycle
--         if WrAck = '1' or RdAck = '1' then
--            --WB_CYC_O <= '0';            
--            WB_STB_O <= '0';
--         end if;       
      
         if Bus2IP_Reset = '1' then
            RdAck <= '0';
            WrAck <= '0';
            cyc <= '0';        
         end if;
      end if;
   end process;
   
--  ------------------------------------------
--  -- Example code to access user logic memory region
--  -- 
--  -- Note:
--  -- The example code presented here is to show you one way of using
--  -- the user logic memory space features. The Bus2IP_Addr, Bus2IP_CS,
--  -- and Bus2IP_RNW IPIC signals are dedicated to these user logic
--  -- memory spaces. Each user logic memory space has its own address
--  -- range and is allocated one bit on the Bus2IP_CS signal to indicated
--  -- selection of that memory space. Typically these user logic memory
--  -- spaces are used to implement memory controller type cores, but it
--  -- can also be used in cores that need to access additional address space
--  -- (non C_BASEADDR based), s.t. bridges. This code snippet infers
--  -- 1 256x32-bit (byte accessible) single-port Block RAM by XST.
--  ------------------------------------------
--  mem_select      <= Bus2IP_CS;
--  mem_read_enable <= ( Bus2IP_CS(0) ) and Bus2IP_RNW;
--  mem_read_ack    <= mem_read_ack_dly1;
--  mem_write_ack   <= ( Bus2IP_CS(0) ) and not(Bus2IP_RNW);
--  mem_address     <= Bus2IP_Addr(C_SLV_AWIDTH-10 to C_SLV_AWIDTH-3);
--
--  -- implement single clock wide read request
--  mem_read_req    <= mem_read_enable and not(mem_read_enable_dly1);
--  BRAM_RD_REQ_PROC : process( Bus2IP_Clk ) is
--  begin
--
--    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
--      if ( Bus2IP_Reset = '1' ) then
--        mem_read_enable_dly1 <= '0';
--      else
--        mem_read_enable_dly1 <= mem_read_enable;
--      end if;
--    end if;
--
--  end process BRAM_RD_REQ_PROC;
--
--  -- this process generates the read acknowledge 1 clock after read enable
--  -- is presented to the BRAM block. The BRAM block has a 1 clock delay
--  -- from read enable to data out.
--  BRAM_RD_ACK_PROC : process( Bus2IP_Clk ) is
--  begin
--
--    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
--      if ( Bus2IP_Reset = '1' ) then
--        mem_read_ack_dly1 <= '0';
--      else
--        mem_read_ack_dly1 <= mem_read_req;
--      end if;
--    end if;
--
--  end process BRAM_RD_ACK_PROC;
--
--  -- implement Block RAM(s)
--  BRAM_GEN : for i in 0 to C_NUM_MEM-1 generate
--    constant NUM_BYTE_LANES : integer := (C_SLV_DWIDTH+7)/8;
--  begin
--
--    BYTE_BRAM_GEN : for byte_index in 0 to NUM_BYTE_LANES-1 generate
--      signal ram           : BYTE_RAM_TYPE;
--      signal write_enable  : std_logic;
--      signal data_in       : std_logic_vector(0 to 7);
--      signal data_out      : std_logic_vector(0 to 7);
--      signal read_address  : std_logic_vector(0 to 7);
--    begin
--
--      write_enable <= not(Bus2IP_RNW) and
--                      Bus2IP_CS(i) and
--                      Bus2IP_BE(byte_index);
--
--      data_in <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
--      mem_data_out(i)(byte_index*8 to byte_index*8+7) <= data_out;
--
--      BYTE_RAM_PROC : process( Bus2IP_Clk ) is
--      begin
--
--        if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
--          if ( write_enable = '1' ) then
--            ram(CONV_INTEGER(mem_address)) <= data_in;
--          end if;
--          read_address <= mem_address;
--        end if;
--
--      end process BYTE_RAM_PROC;
--
--      data_out <= ram(CONV_INTEGER(read_address));
--
--    end generate BYTE_BRAM_GEN;
--
--  end generate BRAM_GEN;
--
--  -- implement Block RAM read mux
--  MEM_IP2BUS_DATA_PROC : process( mem_data_out, mem_select ) is
--  begin
--
--    case mem_select is
--      when "1" => mem_ip2bus_data <= mem_data_out(0);
--      when others => mem_ip2bus_data <= (others => '0');
--    end case;
--
--  end process MEM_IP2BUS_DATA_PROC;
--
--  ------------------------------------------
--  -- Example code to drive IP to Bus signals
--  ------------------------------------------
--  IP2Bus_Data  <= mem_ip2bus_data when mem_read_ack = '1' else
--                  (others => '0');
--
--  IP2Bus_WrAck <= mem_write_ack;
--  IP2Bus_RdAck <= mem_read_ack;
--  IP2Bus_Error <= '0';

end IMP;
