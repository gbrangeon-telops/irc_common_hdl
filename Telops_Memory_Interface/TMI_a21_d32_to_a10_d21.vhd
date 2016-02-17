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

entity TMI_a21_d32_to_a10_d21 is
	 port(
		 TMI_MST_MOSI : in t_tmi_mosi_a21_d32;
		 TMI_MST_MISO : out  t_tmi_miso_d32;
       TMI_SLV_MOSI : out t_tmi_mosi_a10_d21;
		 TMI_SLV_MISO : in  t_tmi_miso_d21
	     );
end TMI_a21_d32_to_a10_d21;

architecture RTL of TMI_a21_d32_to_a10_d21 is
begin

   TMI_SLV_MOSI.ADD     <= TMI_MST_MOSI.ADD(9 downto 0);
   TMI_SLV_MOSI.RNW     <= TMI_MST_MOSI.RNW;
   TMI_SLV_MOSI.DVAL    <= TMI_MST_MOSI.DVAL;
   TMI_SLV_MOSI.WR_DATA <= TMI_MST_MOSI.WR_DATA(20 downto 0);
   TMI_MST_MISO.IDLE    <= TMI_SLV_MISO.IDLE; 
   TMI_MST_MISO.BUSY    <= TMI_SLV_MISO.BUSY;
   TMI_MST_MISO.RD_DATA(20 downto 0) <= TMI_SLV_MISO.RD_DATA;
   TMI_MST_MISO.RD_DATA(31 downto 21) <= (others => '0');
   TMI_MST_MISO.RD_DVAL <= TMI_SLV_MISO.RD_DVAL;
   TMI_MST_MISO.ERROR   <= TMI_SLV_MISO.ERROR;

end RTL;
