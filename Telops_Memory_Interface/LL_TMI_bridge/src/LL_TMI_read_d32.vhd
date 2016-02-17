---------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_read_d32
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : Ce module est simplement un wrapper 32 bits pour LL_TMI_read. Voir LL_TMI_read 
--               pour plus de détails.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;     

library Common_HDL;
use Common_HDL.telops.all;

entity LL_TMI_read_d32 is
   generic(          
      TMI_Latency : natural := 4;  -- Maximum number of clock cycles during which TMI can continue generating RD_DATA after read requests have stopped.
      ALEN : natural := 21);  
   port(  
      --------------------------------
      -- TMI Interface
      --------------------------------
      TMI_IDLE    : in  std_logic;
      TMI_ERROR   : in  std_logic;
      TMI_RNW     : out std_logic;
      TMI_ADD     : out std_logic_vector(ALEN-1 downto 0);
      TMI_DVAL    : out std_logic;
      TMI_BUSY    : in  std_logic;
      TMI_RD_DATA : in  std_logic_vector(31 downto 0);
      TMI_RD_DVAL : in  std_logic;      
      TMI_WR_DATA : out std_logic_vector(31 downto 0);   
      --------------------------------
      -- Incoming Addresses
      --------------------------------   
      ADD_LL_SOF	 : in  std_logic;
      ADD_LL_EOF	 : in  std_logic;
      ADD_LL_DATA  : in  std_logic_vector(ALEN-1 downto 0);      
      ADD_LL_DVAL	 : in  std_logic;
      ADD_LL_SUPPORT_BUSY : in std_logic;
      ADD_LL_BUSY  : out std_logic;      
      ADD_LL_AFULL : out std_logic;      
      --------------------------------
      -- Outgoing data from read requests
      --------------------------------   
      RD_MOSI     : out t_ll_mosi32;
      RD_MISO     : in  t_ll_miso;
      --------------------------------
      -- Others IOs
      --------------------------------     
      IDLE        : out std_logic;                 -- 1 when TMI_IDLE is 1 and all internal pipelines are empty.
      ERROR       : out std_logic;
      ARESET      : in  std_logic;
      CLK         : in  std_logic
      );
end LL_TMI_read_d32;

architecture RTL of LL_TMI_read_d32 is      
   
begin                      
   
   RD : entity ll_tmi_read
   generic map(
      TMI_Latency => TMI_Latency,
      DLEN => 32,
      ALEN => ALEN
      )
   port map(
      TMI_IDLE => TMI_IDLE,
      TMI_ERROR => TMI_ERROR,
      TMI_RNW => TMI_RNW,
      TMI_ADD => TMI_ADD,
      TMI_DVAL => TMI_DVAL,
      TMI_BUSY => TMI_BUSY,
      TMI_RD_DATA => TMI_RD_DATA,
      TMI_RD_DVAL => TMI_RD_DVAL,
      TMI_WR_DATA => TMI_WR_DATA,
      ADD_LL_SOF => ADD_LL_SOF,
      ADD_LL_EOF => ADD_LL_EOF,
      ADD_LL_DATA => ADD_LL_DATA,
      ADD_LL_DVAL => ADD_LL_DVAL,
      ADD_LL_SUPPORT_BUSY => ADD_LL_SUPPORT_BUSY,
      ADD_LL_BUSY => ADD_LL_BUSY,
      ADD_LL_AFULL => ADD_LL_AFULL,
      RD_LL_SOF => RD_MOSI.SOF,
      RD_LL_EOF => RD_MOSI.EOF,
      RD_LL_DATA => RD_MOSI.DATA,
      RD_LL_DVAL => RD_MOSI.DVAL,
      RD_LL_SUPPORT_BUSY => RD_MOSI.SUPPORT_BUSY,
      RD_LL_BUSY => RD_MISO.BUSY,
      RD_LL_AFULL => RD_MISO.AFULL,
      IDLE => IDLE,
      ERROR => ERROR,
      ARESET => ARESET,
      CLK => CLK
      );
   
end RTL;
