-------------------------------------------------------------------------------
--
-- Title       : LL_32_to_24
-- Design      : Frame_Buffer_CoAdd
-- Author      : Telops
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_32_to_24.vhd
-- Generated   : Thu Jul 22 09:09:21 2010
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
--{entity {LL_32_to_24} architecture {LL_32_to_24}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library common_hdl;
use common_hdl.telops.all;

entity LL_32_to_24 is    
	 port(
		 RX_MOSI : in t_ll_mosi32;
		 TX_MISO : in t_ll_miso;
		 TX_MOSI : out t_ll_mosi24;
		 RX_MISO : out t_ll_miso
	     );
end LL_32_to_24;

--}} End of automatically maintained section

architecture LL_32_to_24 of LL_32_to_24 is
begin

	 -- enter your statements here --
	 
	-- MOSI -- 
	TX_MOSI.DATA <= RX_MOSI.DATA(23 DOWNTO 0);	   
   TX_MOSI.DVAL <= RX_MOSI.DVAL;
   TX_MOSI.EOF <= RX_MOSI.EOF;
   TX_MOSI.SOF <= RX_MOSI.SOF;  
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   
   -- MISO --
   RX_MISO <= TX_MISO;
   
end LL_32_to_24;
