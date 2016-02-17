-------------------------------------------------------------------------------
--
-- Title       : ll_expand_16_32
-- Author      : Jean-Alexis Boulet
-- Company     : Telops
--
-------------------------------------------------------------------------------
--  $Revision$
--  $Author$
--  $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description : Expand the bus size from 16 to 32 bits
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use IEEE.numeric_std.all;

library common_hdl;
use common_hdl.telops.all;

entity ll_expand_16_32 is
   port(              
      --------------------------------
      -- LocalLink Interface RX   
      --------------------------------     
      RX_MOSI  : in t_ll_mosi;
      RX_MISO  : out  t_ll_miso;
      --------------------------------
      -- LocalLink Interface TX   
      --------------------------------     
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso
   
      );
end ll_expand_16_32;

architecture RTL of ll_expand_16_32 is      
   
begin			                  
   TX_MOSI.DATA(15 downto 0) <= RX_MOSI.DATA(15 downto 0);
   TX_MOSI.DATA(31 downto 16) <= (others => '0');
   TX_MOSI.DVAL <= RX_MOSI.DVAL;
   TX_MOSI.SOF <= RX_MOSI.SOF;
   TX_MOSI.EOF <= RX_MOSI.EOF;
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   RX_MISO.BUSY <= TX_MISO.BUSY;
   RX_MISO.AFULL <= TX_MISO.AFULL;
   
end RTL;
