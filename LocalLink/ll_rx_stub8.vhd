---------------------------------------------------------------------------------------------------
--
-- Title       : ll_rx_stub
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

entity ll_rx_stub8 is
	 port(
		 RX_LL_MOSI : in t_ll_mosi8;
		 RX_LL_MISO : out t_ll_miso
	     );
end ll_rx_stub8;

architecture RTL of ll_rx_stub8 is
begin

   RX_LL_MISO.BUSY  <= '1';
   RX_LL_MISO.AFULL <= '1';

end RTL;
