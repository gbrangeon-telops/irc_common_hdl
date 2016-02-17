-------------------------------------------------------------------------------
--
-- Title       : LL_Hole32
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : This is a LocalLink "hole". When FALL is asserted, the data
--               just "falls" in a hole, it is not transmitted to the TX port.
--               When FALL is 0, data flows through normally.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all; 

entity LL_Hole32 is
   port(     
      RX_MOSI  : in  t_ll_mosi32; 
      RX_MISO  : out t_ll_miso;
      
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso; 
      
      FALL        : in std_logic
      );
end LL_Hole32;

architecture RTL of LL_Hole32 is
begin
   
   RX_MISO.AFULL <= TX_MISO.AFULL when FALL='0' else '0';
   RX_MISO.BUSY <= TX_MISO.BUSY when FALL='0' else '0';
   
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   TX_MOSI.SOF <= RX_MOSI.SOF;
   TX_MOSI.EOF <= RX_MOSI.EOF;
   TX_MOSI.DATA <= RX_MOSI.DATA;
   TX_MOSI.DVAL <= RX_MOSI.DVAL when FALL='0' else '0';
   
end RTL;
