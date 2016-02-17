---------------------------------------------------------------------------------------------------
--
-- Title       : ll_rx_stub8
-- Design      : Common_HDL
-- Author      : Patrick Daraiche
-- Company     : Telops
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

entity ll_tx_stub8 is
	 port(
		 TX_LL_MOSI : out t_ll_mosi8;
		 TX_LL_MISO : in  t_ll_miso
	     );
end ll_tx_stub8;

architecture RTL of ll_tx_stub8 is
begin

   TX_LL_MOSI.DVAL <= '0';
   TX_LL_MOSI.SUPPORT_BUSY <= '1'; -- Supports busy because this will never send data...

end RTL;
