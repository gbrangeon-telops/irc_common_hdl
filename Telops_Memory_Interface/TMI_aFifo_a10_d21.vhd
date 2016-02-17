-------------------------------------------------------------------------------
--
-- Title       : TMI_aFifo_a21_d32
-- Author      : Interface: PDU. Core: KBE
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-------------------------------------------------------------------------------
-- Description : This is simply a wrapper for TMI_aFifo
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;   
library Common_HDL;
use Common_HDL.Telops.all;

entity TMI_aFifo_a10_d21 is
   generic(ALEN : natural := 10;
           DLEN : natural := 21);
   port(
      --------------------------------
      -- Client Interface (aka MST or Master)
      --------------------------------
      MST_MOSI    : in  t_tmi_mosi_a10_d21;
      MST_MISO    : out t_tmi_miso_d21;
      MST_CLK     : in  std_logic;
      --------------------------------
      -- Controller Interface (aka SLV or Slave)
      --------------------------------      
      SLV_MOSI    : out t_tmi_mosi_a10_d21;
      SLV_MISO    : in  t_tmi_miso_d21; 
      SLV_CLK     : in  std_logic;
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET      : in  std_logic
      );
end TMI_aFifo_a10_d21;

architecture RTL of TMI_aFifo_a10_d21 is
   
begin 
   
   
   fifo : entity tmi_afifo
   generic map(
      DLEN => DLEN,
      ALEN => ALEN
      )
   port map(
      TMI_IN_ADD => MST_MOSI.ADD(ALEN-1 downto 0),
      TMI_IN_RNW => MST_MOSI.RNW,
      TMI_IN_DVAL => MST_MOSI.DVAL,
      TMI_IN_BUSY => MST_MISO.BUSY,
      TMI_IN_RD_DATA => MST_MISO.RD_DATA(DLEN-1 downto 0),
      TMI_IN_RD_DVAL => MST_MISO.RD_DVAL,
      TMI_IN_WR_DATA => MST_MOSI.WR_DATA(DLEN-1 downto 0),
      TMI_IN_IDLE => MST_MISO.IDLE,
      TMI_IN_ERROR => MST_MISO.ERROR,
      TMI_IN_CLK => MST_CLK,
      TMI_OUT_ADD => SLV_MOSI.ADD(ALEN-1 downto 0),
      TMI_OUT_RNW => SLV_MOSI.RNW,
      TMI_OUT_DVAL => SLV_MOSI.DVAL,
      TMI_OUT_BUSY => SLV_MISO.BUSY,
      TMI_OUT_RD_DATA => SLV_MISO.RD_DATA(DLEN-1 downto 0),
      TMI_OUT_RD_DVAL => SLV_MISO.RD_DVAL,
      TMI_OUT_WR_DATA => SLV_MOSI.WR_DATA(DLEN-1 downto 0),
      TMI_OUT_IDLE => SLV_MISO.IDLE,
      TMI_OUT_ERROR => SLV_MISO.ERROR,
      TMI_OUT_CLK => SLV_CLK,
      ARESET => ARESET
      );   
   
end RTL;