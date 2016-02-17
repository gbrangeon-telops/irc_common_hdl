---------------------------------------------------------------------------------------------------
--
-- Title       : ll_tx_stub21
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

entity ll_tx_stub21 is
	 port(
		 TX_LL_MOSI : out t_ll_mosi21;
		 TX_LL_MISO : in  t_ll_miso
	     );
end ll_tx_stub21;

architecture RTL of ll_tx_stub21 is
begin

   TX_LL_MOSI.DVAL <= '0';
   TX_LL_MOSI.SUPPORT_BUSY <= '1'; -- Supports busy because this will never send data...

end RTL;
