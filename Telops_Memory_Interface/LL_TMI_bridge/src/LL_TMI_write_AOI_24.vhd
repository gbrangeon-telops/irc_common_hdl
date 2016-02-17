---------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_Write_AOI_24
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : This is simply a 24 bits wrapper for LL_TMI_Write_AOI. See LL_TMI_Write_AOI for
--               description of the ports.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;        
library Common_HDL;
use Common_HDL.telops.all;

entity LL_TMI_Write_AOI_24 is
   generic( 
      XLEN : natural := 9;
      ALEN : natural := 21);  
   port(  
      --------------------------------
      -- Configuration port (can be mapped to Wishbone)
      --------------------------------   
      CFG_START_ADD  : in  std_logic_vector(ALEN-1 downto 0);  
      CFG_END_ADD    : in  std_logic_vector(ALEN-1 downto 0);
      CFG_STEP_ADD   : in  std_logic_vector(XLEN downto 0); 
      CFG_WIDTH      : in  std_logic_vector(XLEN-1 downto 0);  
      CFG_SKIP       : in  std_logic_vector(ALEN downto 0);  
      CFG_CONTROL    : in  std_logic_vector(2 downto 0);                                                                      
      CFG_CONFIG     : in  std_logic_vector(0 downto 0);       
      CFG_DONE       : out std_logic;                          
      CFG_IN_PROGRESS: out std_logic;                          
      --------------------------------
      -- TMI Interface
      --------------------------------
      TMI_IDLE    : in  std_logic;
      TMI_ERROR   : in  std_logic;
      TMI_RNW     : out std_logic;
      TMI_ADD     : out std_logic_vector(ALEN-1 downto 0);
      TMI_DVAL    : out std_logic;
      TMI_BUSY    : in  std_logic;
      TMI_WR_DATA : out std_logic_vector(23 downto 0);
      --------------------------------
      -- Incoming data for write requests
      --------------------------------   
      WR_MOSI     : in  t_ll_mosi24;           
      WR_MISO     : out t_ll_miso;      
      --------------------------------
      -- Others IOs
      -------------------------------- 
      ERROR       : out std_logic;
      ARESET      : in  std_logic;
      
      CLK_DATA    : in  std_logic;                             -- Clk domain for TMI and LocalLink ports
      CLK_CTRL    : in  std_logic                              -- Clk domain for CFG port
      );
end LL_TMI_Write_AOI_24;

architecture RTL of LL_TMI_Write_AOI_24 is    
   
signal config : std_logic_vector(4 downto 0);

begin               

   config <= "0000" & CFG_CONFIG;
   
   U1 : entity LL_TMI_Write_AOI
   generic map(
      DLEN => 24,
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
      CFG_CONFIG => config,
      CFG_DONE => CFG_DONE,
      CFG_IN_PROGRESS => CFG_IN_PROGRESS,
      TMI_IDLE => TMI_IDLE,
      TMI_ERROR => TMI_ERROR,
      TMI_RNW => TMI_RNW,
      TMI_ADD => TMI_ADD,
      TMI_DVAL => TMI_DVAL,
      TMI_BUSY => TMI_BUSY,
      TMI_WR_DATA => TMI_WR_DATA,
      WR_LL_SOF => WR_MOSI.SOF,
      WR_LL_EOF => WR_MOSI.EOF,
      WR_LL_DATA => WR_MOSI.DATA,
      WR_LL_DVAL => WR_MOSI.DVAL,
      WR_LL_SUPPORT_BUSY => WR_MOSI.SUPPORT_BUSY,
      WR_LL_BUSY => WR_MISO.BUSY,
      WR_LL_AFULL => WR_MISO.AFULL,
      ERROR => ERROR,
      ARESET => ARESET,
      CLK_DATA => CLK_DATA,
      CLK_CTRL => CLK_CTRL
      );
   
end RTL;
