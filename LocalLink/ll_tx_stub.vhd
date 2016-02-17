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

entity ll_tx_stub is
	 port(
		 TX_LL_MOSI : out t_ll_mosi;
		 TX_LL_MISO : in  t_ll_miso
	     );
end ll_tx_stub;

architecture RTL of ll_tx_stub is
begin

   TX_LL_MOSI.DVAL <= '0';
   TX_LL_MOSI.SUPPORT_BUSY <= '1'; -- Supports busy because this will never send data...

end RTL;
