---------------------------------------------------------------------------------------------------
--
-- Title       : LL_21_to_10
-- Author      : Jean-Alexis Boulet/Patrick Dubois
-- Company     : TELOPS
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;           
use IEEE.numeric_std.ALL;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_21_to_10 is      
   port(        
      --------------------------------
      -- RX Interface
      -------------------------------- 
      RX_MISO  : out t_ll_miso;
      RX_MOSI  : in  t_ll_mosi21;       
      
      --------------------------------
      -- TX Interface
      --------------------------------		 
      TX_MOSI  : out t_ll_mosi10;
      TX_MISO  : in  t_ll_miso     
      );
end LL_21_to_10;

architecture RTL of LL_21_to_10 is 

begin
   
   TX_MOSI.DATA <= RX_MOSI.DATA(TX_MOSI.DATA'range);
   TX_MOSI.SOF  <= RX_MOSI.SOF;
   TX_MOSI.EOF  <= RX_MOSI.EOF;
   TX_MOSI.DVAL <= RX_MOSI.DVAL;
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   RX_MISO.BUSY <= TX_MISO.BUSY;
   RX_MISO.AFULL <= TX_MISO.AFULL;                  

end RTL;
