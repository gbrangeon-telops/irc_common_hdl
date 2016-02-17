---------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_read_a21_d32
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : Ce module est simplement un wrapper pour LL_TMI_read. Voir LL_TMI_read 
--               pour plus de détails.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;     

library Common_HDL;
use Common_HDL.telops.all;

entity LL_TMI_read_a21_d32 is
   generic(          
      TMI_Latency : natural := 4);  -- Maximum number of clock cycles during which TMI can continue generating RD_DATA after read requests have stopped.
   port(  
      --------------------------------
      -- TMI Interface
      --------------------------------      
      TMI_MOSI    : out t_tmi_mosi_a21_d32;
      TMI_MISO    : in  t_tmi_miso_d32;
      --------------------------------
      -- Incoming Addresses
      -------------------------------- 
      ADD_MOSI     : in  t_ll_mosi21;
      ADD_MISO     : out t_ll_miso;    
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
end LL_TMI_read_a21_d32;

architecture RTL of LL_TMI_read_a21_d32 is      
   
begin                      
   
   RD : entity ll_tmi_read
   generic map(
      TMI_Latency => TMI_Latency,
      DLEN => 32,
      ALEN => 21
      )
   port map(
      TMI_IDLE => TMI_MISO.IDLE,
      TMI_ERROR => TMI_MISO.ERROR,
      TMI_RNW => TMI_MOSI.RNW,
      TMI_ADD => TMI_MOSI.ADD,
      TMI_DVAL => TMI_MOSI.DVAL,
      TMI_BUSY => TMI_MISO.BUSY,
      TMI_RD_DATA => TMI_MISO.RD_DATA,
      TMI_RD_DVAL => TMI_MISO.RD_DVAL,
      TMI_WR_DATA => TMI_MOSI.WR_DATA,
      ADD_LL_SOF => ADD_MOSI.SOF,
      ADD_LL_EOF => ADD_MOSI.EOF,
      ADD_LL_DATA => ADD_MOSI.DATA,
      ADD_LL_DVAL => ADD_MOSI.DVAL,
      ADD_LL_SUPPORT_BUSY => ADD_MOSI.SUPPORT_BUSY,
      ADD_LL_BUSY => ADD_MISO.BUSY,
      ADD_LL_AFULL => ADD_MISO.AFULL,
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
