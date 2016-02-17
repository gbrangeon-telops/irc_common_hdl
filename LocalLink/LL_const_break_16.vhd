-------------------------------------------------------------------------------
--
-- Title       : LL_const_break_16
-- Design      : Common_HDL
-- Author      : Patrick Daraiche
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_const_break_16.vhd
-- Generated   : Mon Aug  8 08:06:26 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This block permits to toggle DVAL with two different signal.
--                use with ll_const_value component
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {LL_const_break} architecture {RTL}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.telops.all;

entity LL_const_break_16 is
   port(
		 CLK : in STD_LOGIC;
		 ARESET : in STD_LOGIC;

       RX_MOSI : in t_ll_mosi;
       RX_MISO : out t_ll_miso;
       TX_MOSI : out t_ll_mosi;
       TX_MISO : in t_ll_miso;
       
       START : in STD_LOGIC;
       STOP : in STD_LOGIC
     );
end LL_const_break_16;

--}} End of automatically maintained section

architecture RTL of LL_const_break_16 is

	-- Component declaration of the "ll_const_break(rtl)" unit defined in
	component ll_const_break
	generic(
		DLEN : INTEGER := 16
--		DREM_LEN : INTEGER := 2
   );
	port(
		CLK : in STD_LOGIC;
		ARESET : in STD_LOGIC;
		RX_MOSI_SOF : in STD_LOGIC;
		RX_MOSI_EOF : in STD_LOGIC;
		RX_MOSI_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
--		RX_MOSI_DREM : in STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		RX_MOSI_DVAL : in STD_LOGIC;
		RX_MOSI_SUPPORT_BUSY : in STD_LOGIC;
		RX_MISO_AFULL : out STD_LOGIC;
		RX_MISO_BUSY : out STD_LOGIC;
		TX_MOSI_SOF : out STD_LOGIC;
		TX_MOSI_EOF : out STD_LOGIC;
		TX_MOSI_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
--		TX_MOSI_DREM : out STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		TX_MOSI_DVAL : out STD_LOGIC;
		TX_MOSI_SUPPORT_BUSY : out STD_LOGIC;
		TX_MISO_AFULL : in STD_LOGIC;
		TX_MISO_BUSY : in STD_LOGIC;
		START : in STD_LOGIC;
		STOP : in STD_LOGIC);
	end component;

   begin

   -- enter your statements here --
const_break : ll_const_break
   generic map(
      DLEN => 16
      --DREM_LEN => DREM_LEN
   )
   port map(
      CLK => CLK,
      ARESET => ARESET,
      RX_MOSI_SOF => RX_MOSI.SOF,
      RX_MOSI_EOF => RX_MOSI.EOF,
      RX_MOSI_DATA => RX_MOSI.DATA,
      --RX_MOSI_DREM => (others => '0'),
      RX_MOSI_DVAL => RX_MOSI.DVAL,
      RX_MOSI_SUPPORT_BUSY => RX_MOSI.SUPPORT_BUSY,
      RX_MISO_AFULL => RX_MISO.AFULL,
      RX_MISO_BUSY => RX_MISO.BUSY,
      TX_MOSI_SOF => TX_MOSI.SOF,
      TX_MOSI_EOF => TX_MOSI.EOF,
      TX_MOSI_DATA => TX_MOSI.DATA,
      --TX_MOSI_DREM => TX_MOSI.DREM,
      TX_MOSI_DVAL => TX_MOSI.DVAL,
      TX_MOSI_SUPPORT_BUSY => TX_MOSI.SUPPORT_BUSY,
      TX_MISO_AFULL => TX_MISO.AFULL,
      TX_MISO_BUSY => TX_MISO.BUSY,
      START => START,
      STOP => STOP
   );
   
   end RTL;
