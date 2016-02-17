---------------------------------------------------------------------------------------------------
--
-- Title       : LL_rx_stub_32
-- Design      : Common_HDL
-- Author      : Patrick Dubois
-- Company     : Université Laval-Faculté des Sciences et de Génie
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity LL_rx_stub_32 is
	 port(
		 RX_MOSI : in t_ll_mosi32;
		 RX_MISO : out t_ll_miso
	     );
end LL_rx_stub_32;

architecture RTL of LL_rx_stub_32 is
begin

   RX_MISO.BUSY  <= '1';
   RX_MISO.AFULL <= '1';

end RTL;
