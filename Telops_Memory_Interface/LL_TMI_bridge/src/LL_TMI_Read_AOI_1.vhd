---------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_Read_AOI_1
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : This is simply a 24 bits wrapper for LL_TMI_Read_AOI. See LL_TMI_Read_AOI for a 
--               description of the ports.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;        
library Common_HDL;
use Common_HDL.telops.all;

entity LL_TMI_Read_AOI_1 is
   generic(          
      TMI_Latency : natural := 4;  
      -- Maximum number of clock cycles during which TMI can continue generating RD_DATA after read requests have stopped.
      XLEN : natural := 9;
      ALEN : natural := 21);  
   port(  
      --------------------------------
      -- Configuration port (can be mapped to Wishbone)
      --------------------------------   
      CFG_START_ADD  : in  std_logic_vector(ALEN-1 downto 0);  
      CFG_END_ADD    : in  std_logic_vector(ALEN-1 downto 0);
      CFG_STEP_ADD    : in  std_logic_vector(XLEN downto 0); 
      CFG_WIDTH      : in  std_logic_vector(XLEN-1 downto 0);  
      CFG_SKIP       : in  std_logic_vector(ALEN downto 0);  
      CFG_CONTROL    : in  std_logic_vector(2 downto 0);                                                                      
      CFG_DONE       : out std_logic;                          
      CFG_IN_PROGRESS: out std_logic;                          
      CFG_CONFIG     : in  std_logic_vector(4 downto 0);                                     
      --------------------------------
      -- TMI Interface
      --------------------------------
      TMI_IDLE    : in  std_logic;
      TMI_ERROR   : in  std_logic;
      TMI_RNW     : out std_logic;
      TMI_ADD     : out std_logic_vector(ALEN-1 downto 0);
      TMI_DVAL    : out std_logic;
      TMI_BUSY    : in  std_logic;
      TMI_RD_DATA : in  std_logic_vector(0 downto 0);
      TMI_RD_DVAL : in  std_logic;      
      TMI_WR_DATA : out std_logic_vector(0 downto 0);
      --------------------------------
      -- Outgoing data from read requests
      --------------------------------
      RD_MOSI     : out t_ll_mosi1; 
      RD_MISO     : in  t_ll_miso;      
      --------------------------------
      -- Others IOs
      -------------------------------- 
      ERROR       : out std_logic;
      ARESET      : in  std_logic;
      CLK_DATA    : in  std_logic;                 -- Clk domain for TMI and LocalLink ports
      CLK_CTRL    : in  std_logic                  -- Clk domain for CFG port
      );
end LL_TMI_Read_AOI_1;

architecture RTL of LL_TMI_Read_AOI_1 is 

signal rd_mosi_data_i : std_logic_vector(0 downto 0);
   
begin                      
   
  -- RD_MOSI.DATA(31 downto 1) <= (others => '0');
  RD_MOSI.DATA <= rd_mosi_data_i(0);
   
   U1 : entity LL_TMI_Read_AOI
   generic map(
      TMI_Latency => TMI_Latency,
      DLEN => 1,
      XLEN => XLEN,
      ALEN => ALEN
      )
   port map(
      CFG_START_ADD => CFG_START_ADD,
      CFG_END_ADD => CFG_END_ADD,
      CFG_STEP_ADD => CFG_STEP_ADD,
      CFG_WIDTH => CFG_WIDTH,
      CFG_SKIP => CFG_SKIP,
      CFG_CONTROL => CFG_CONTROL,
      CFG_DONE => CFG_DONE,
      CFG_IN_PROGRESS => CFG_IN_PROGRESS,
      CFG_CONFIG => CFG_CONFIG,
      TMI_IDLE => TMI_IDLE,
      TMI_ERROR => TMI_ERROR,
      TMI_RNW => TMI_RNW,
      TMI_ADD => TMI_ADD,
      TMI_DVAL => TMI_DVAL,
      TMI_BUSY => TMI_BUSY,
      TMI_RD_DATA => TMI_RD_DATA,
      TMI_RD_DVAL => TMI_RD_DVAL,
      TMI_WR_DATA => TMI_WR_DATA,
      RD_LL_SOF => RD_MOSI.SOF,
      RD_LL_EOF => RD_MOSI.EOF,
      RD_LL_DATA => rd_mosi_data_i,--RD_MOSI.DATA,
      RD_LL_DVAL => RD_MOSI.DVAL,
      RD_LL_SUPPORT_BUSY => RD_MOSI.SUPPORT_BUSY,
      RD_LL_BUSY => RD_MISO.BUSY,
      RD_LL_AFULL => RD_MISO.AFULL,
      ERROR => ERROR,
      ARESET => ARESET,
      CLK_DATA => CLK_DATA,
      CLK_CTRL => CLK_CTRL
      );   
   
end RTL;
