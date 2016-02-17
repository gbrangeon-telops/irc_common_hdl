-------------------------------------------------------------------------------
--
-- Title       : LL_24_to_16
-- Design      : Frame_Buffer_CoAdd
-- Author      : Telops
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_24_to_16.vhd
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
--{entity {LL_24_to_16} architecture {LL_24_to_16}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library common_hdl;
use common_hdl.telops.all;

entity LL_24_to_16 is    
	 port(
		 RX_MOSI : in t_ll_mosi24;
		 TX_MISO : in t_ll_miso;
		 TX_MOSI : out t_ll_mosi;
		 RX_MISO : out t_ll_miso
	     );
end LL_24_to_16;

--}} End of automatically maintained section

architecture LL_24_to_16 of LL_24_to_16 is
begin

	 -- enter your statements here --
	 
	-- MOSI -- 
	TX_MOSI.DATA <= RX_MOSI.DATA(15 DOWNTO 0);	   
   TX_MOSI.DVAL <= RX_MOSI.DVAL;
   TX_MOSI.EOF <= RX_MOSI.EOF;
   TX_MOSI.SOF <= RX_MOSI.SOF;  
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   
   -- MISO --
   RX_MISO <= TX_MISO;
   
end LL_24_to_16;
