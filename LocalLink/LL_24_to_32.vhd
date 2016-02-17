-------------------------------------------------------------------------------
--
-- Title       : LL_24_to_32
-- Design      : Frame_Buffer_CoAdd
-- Author      : Telops
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_24_to_32.vhd
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
--{entity {LL_24_to_32} architecture {LL_24_to_32}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library common_hdl;
use common_hdl.telops.all;

entity LL_24_to_32 is
    generic(SIGNED_g : boolean := false
         );
	 port(
		 RX_MOSI : in t_ll_mosi24;
		 TX_MISO : in t_ll_miso;
		 TX_MOSI : out t_ll_mosi32;
		 RX_MISO : out t_ll_miso
	     );
end LL_24_to_32;

--}} End of automatically maintained section

architecture LL_24_to_32 of LL_24_to_32 is
begin

	 -- enter your statements here --
	 
	-- MOSI -- 
	TX_MOSI.DATA(23 DOWNTO 0) <= RX_MOSI.DATA;
	
	gen_unsigned : if SIGNED_g = false generate
      TX_MOSI.DATA(31 DOWNTO 24) <= (others => '0');
   end generate gen_unsigned;   
   
   gen_signed : if SIGNED_g = true generate
      TX_MOSI.DATA(31 DOWNTO 24) <= (others => RX_MOSI.DATA(23));
   end generate gen_signed;   
   
   TX_MOSI.DVAL <= RX_MOSI.DVAL;
   TX_MOSI.EOF <= RX_MOSI.EOF;
   TX_MOSI.SOF <= RX_MOSI.SOF;  
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   
   -- MISO --
   RX_MISO <= TX_MISO;


end LL_24_to_32;
