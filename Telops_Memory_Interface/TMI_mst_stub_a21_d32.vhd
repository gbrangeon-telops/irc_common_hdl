---------------------------------------------------------------------------------------------------
--
-- Title       : tmi_mst_stub_a21_d32
-- Design      : Common_HDL
-- Author      : Jean-Alexis Boulet
-- Company     : Telops
-- 
-------------------------------------------------------------------------------
--  $Revision$
--  $Author$
--  $LastChangedDate$
---------------------------------------------------------------------------------------------------
--
-- Description :  Dummy master tmi bloc 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity tmi_mst_stub_a21_d32 is
	 port(
		 TMI_MOSI : out t_tmi_mosi_a21_d32;
		 TMI_MISO : in  t_tmi_miso_d32
	     );
end tmi_mst_stub_a21_d32;

architecture RTL of tmi_mst_stub_a21_d32 is
begin

   TMI_MOSI.ADD <= (others => '0');
   TMI_MOSI.RNW <= '0';
   TMI_MOSI.DVAL <= '0';
   TMI_MOSI.WR_DATA <= (others => '0');

end RTL;
