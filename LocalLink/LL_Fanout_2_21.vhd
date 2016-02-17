-------------------------------------------------------------------------------
--
-- Title       : LL_Fanout_2_21
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : This module is used to create a fanout of 2 from one LocalLink
--               signal. The same signal can thus feed two receivers.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_Fanout_2_21 is
   port(
      RX_LL_MOSI  : in  t_ll_mosi21;
      RX_LL_MISO  : out t_ll_miso;
      
      TX1_LL_MOSI : out t_ll_mosi21;
      TX1_LL_MISO : in  t_ll_miso;
      
      TX2_LL_MOSI : out t_ll_mosi21;
      TX2_LL_MISO : in  t_ll_miso;
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC
      );
end LL_Fanout_2_21;

architecture RTL of LL_Fanout_2_21 is
   signal RX_BUSYi : std_logic;   
begin
   
   RX_LL_MISO.AFULL <= TX1_LL_MISO.AFULL or TX2_LL_MISO.AFULL;
   RX_BUSYi <= TX1_LL_MISO.BUSY or TX2_LL_MISO.BUSY;
   RX_LL_MISO.BUSY <= RX_BUSYi; 
   
   TX1_LL_MOSI.SUPPORT_BUSY <= '1';
   TX1_LL_MOSI.SOF <= RX_LL_MOSI.SOF;
   TX1_LL_MOSI.EOF <= RX_LL_MOSI.EOF;
   TX1_LL_MOSI.DATA <= RX_LL_MOSI.DATA;
   TX1_LL_MOSI.DVAL <= RX_LL_MOSI.DVAL and not RX_BUSYi;
   
   TX2_LL_MOSI.SUPPORT_BUSY <= '1';
   TX2_LL_MOSI.SOF <= RX_LL_MOSI.SOF;
   TX2_LL_MOSI.EOF <= RX_LL_MOSI.EOF;
   TX2_LL_MOSI.DATA <= RX_LL_MOSI.DATA;
   TX2_LL_MOSI.DVAL <= RX_LL_MOSI.DVAL and not RX_BUSYi;        
   
   -- pragma translate_off 
   assert_proc : process(ARESET)
   begin       
      if ARESET = '0' then
         assert (RX_LL_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;          
      end if;
   end process;
   -- pragma translate_on   
   
end RTL;
