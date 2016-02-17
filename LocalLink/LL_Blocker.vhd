-------------------------------------------------------------------------------
--
-- Title       : LL_Blocker
-- Design      : Common_HDL
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_Blocker.vhd
-- Generated   : Thu Jun 30 16:21:44 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {LL_Blocker} architecture {RTL}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity LL_Blocker is
   generic(
   DATA_LEN : natural :=16;
   DREM_LEN : natural :=2
   );
   port(
      RX_MOSI_DVAL : in STD_LOGIC;
      RX_MOSI_EOF : in STD_LOGIC;
      RX_MOSI_SOF : in STD_LOGIC;
      RX_MOSI_SUPPORT_BUSY : in STD_LOGIC;
      RX_MOSI_DATA : in STD_LOGIC_VECTOR(DATA_LEN-1 downto 0);
      RX_MOSI_DREM : in STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
      RX_MISO_AFULL : out STD_LOGIC;
      RX_MISO_BUSY : out STD_LOGIC;
      TX_MOSI_DVAL : out STD_LOGIC;
      TX_MOSI_EOF : out STD_LOGIC;
      TX_MOSI_SOF : out STD_LOGIC;
      TX_MOSI_SUPPORT_BUSY : out STD_LOGIC;
      TX_MOSI_DATA : out STD_LOGIC_VECTOR(DATA_LEN-1 downto 0);
      TX_MOSI_DREM : out STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
      TX_MISO_AFULL : in STD_LOGIC;
      TX_MISO_BUSY : in STD_LOGIC;
      HOLD : in STD_LOGIC
      );
end LL_Blocker;

--}} End of automatically maintained section

architecture RTL of LL_Blocker is
begin
   
   -- enter your statements here --
   TX_MOSI_DVAL <= RX_MOSI_DVAL when HOLD = '0' else '0';
   TX_MOSI_DATA <= RX_MOSI_DATA;
   TX_MOSI_EOF <= RX_MOSI_EOF;
   TX_MOSI_SOF <= RX_MOSI_SOF;
   TX_MOSI_SUPPORT_BUSY <= RX_MOSI_SUPPORT_BUSY;
   TX_MOSI_DREM <= RX_MOSI_DREM;
   
   RX_MISO_AFULL <= TX_MISO_AFULL;
   RX_MISO_BUSY <= TX_MISO_BUSY when HOLD = '0' else '1';
   
end RTL;
