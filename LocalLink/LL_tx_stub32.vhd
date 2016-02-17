---------------------------------------------------------------------------------------------------
--
-- Title       : ll_tx_stub32
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

entity ll_tx_stub32 is
	 port(
		 TX_MOSI : out t_ll_mosi32;
		 TX_MISO : in  t_ll_miso
	     );
end ll_tx_stub32;

architecture RTL of ll_tx_stub32 is
begin

   TX_MOSI.DVAL <= '0';
   TX_MOSI.SUPPORT_BUSY <= '1'; -- Supports busy because this will never send data...

end RTL;
