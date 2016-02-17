-------------------------------------------------------------------------------
--
-- Title       : LL_Blocker_8
-- Design      : Common_HDL
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_Blocker_8.vhd
-- Generated   : Thu Jun 30 16:37:50 2011
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
--{entity {LL_Blocker_8} architecture {RTL}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library COMMON_HDL;
use common_hdl.telops.all;

entity LL_Blocker_8 is
   port(
      RX_MOSI : in t_ll_mosi8;
      RX_MISO : out t_ll_miso;
      TX_MOSI : out t_ll_mosi8;
      TX_MISO : in t_ll_miso;
      HOLD : in STD_LOGIC
      );
end LL_Blocker_8;

--}} End of automatically maintained section

architecture RTL of LL_Blocker_8 is

	-- Component declaration of the "ll_blocker(rtl)" unit defined in
	-- file: "./../LocalLink/LL_Blocker.vhd"
	component ll_blocker
	generic(
		DATA_LEN : NATURAL := 16;
		DREM_LEN : NATURAL := 2);
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
		HOLD : in STD_LOGIC);
	end component;
--	for all: ll_blocker use entity work.ll_blocker(rtl);


begin
   
   -- enter your statements here --
blocker : ll_blocker
   generic map(
      DATA_LEN => 8,
      DREM_LEN => 1
   )
   port map(
      RX_MOSI_DVAL => RX_MOSI.DVAL,
      RX_MOSI_EOF => RX_MOSI.EOF,
      RX_MOSI_SOF => RX_MOSI.SOF,
      RX_MOSI_SUPPORT_BUSY => RX_MOSI.SUPPORT_BUSY,
      RX_MOSI_DATA => RX_MOSI.DATA,
      RX_MOSI_DREM => (others => '0'),
      RX_MISO_AFULL => RX_MISO.AFULL,
      RX_MISO_BUSY => RX_MISO.BUSY,
      TX_MOSI_DVAL => TX_MOSI.DVAL,
      TX_MOSI_EOF => TX_MOSI.EOF,
      TX_MOSI_SOF => TX_MOSI.SOF,
      TX_MOSI_SUPPORT_BUSY => TX_MOSI.SUPPORT_BUSY,
      TX_MOSI_DATA => TX_MOSI.DATA,
      TX_MOSI_DREM => open,
      TX_MISO_AFULL => TX_MISO.AFULL,
      TX_MISO_BUSY => TX_MISO.BUSY,
      HOLD => HOLD
   );   
end RTL;
