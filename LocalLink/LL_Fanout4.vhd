-------------------------------------------------------------------------------
--
-- Title       : LL_Fanout
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

entity LL_Fanout4 is
   port(
      RX_MOSI  : in  t_ll_mosi32;
      RX_MISO  : out t_ll_miso;
      
      TX1_MOSI : out t_ll_mosi32;
      TX1_MISO : in  t_ll_miso;
      
      TX2_MOSI : out t_ll_mosi32;
      TX2_MISO : in  t_ll_miso; 
      
      TX3_MOSI : out t_ll_mosi32;
      TX3_MISO : in  t_ll_miso; 
      
      TX4_MOSI : out t_ll_mosi32;
      TX4_MISO : in  t_ll_miso;      
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC
      );
end LL_Fanout4;

architecture RTL of LL_Fanout4 is
   signal RX_BUSYi : std_logic;
begin
   
   -- There is no pipelining but it could be added to improve performance if needed.
   
   RX_MISO.AFULL <= TX1_MISO.AFULL or TX2_MISO.AFULL or TX3_MISO.AFULL or TX4_MISO.AFULL;
   RX_BUSYi <= TX1_MISO.BUSY or TX2_MISO.BUSY or TX3_MISO.BUSY or TX4_MISO.BUSY;
   RX_MISO.BUSY <= RX_BUSYi; 
   
   TX1_MOSI.SUPPORT_BUSY <= '1';
   TX1_MOSI.SOF <= RX_MOSI.SOF;
   TX1_MOSI.EOF <= RX_MOSI.EOF;
   TX1_MOSI.DATA <= RX_MOSI.DATA;
   TX1_MOSI.DVAL <= RX_MOSI.DVAL and not RX_BUSYi;
   
   TX2_MOSI.SUPPORT_BUSY <= '1';
   TX2_MOSI.SOF <= RX_MOSI.SOF;
   TX2_MOSI.EOF <= RX_MOSI.EOF;
   TX2_MOSI.DATA <= RX_MOSI.DATA;
   TX2_MOSI.DVAL <= RX_MOSI.DVAL and not RX_BUSYi; 
   
   TX3_MOSI.SUPPORT_BUSY <= '1';
   TX3_MOSI.SOF <= RX_MOSI.SOF;
   TX3_MOSI.EOF <= RX_MOSI.EOF;
   TX3_MOSI.DATA <= RX_MOSI.DATA;
   TX3_MOSI.DVAL <= RX_MOSI.DVAL and not RX_BUSYi; 
   
   TX4_MOSI.SUPPORT_BUSY <= '1';
   TX4_MOSI.SOF <= RX_MOSI.SOF;
   TX4_MOSI.EOF <= RX_MOSI.EOF;
   TX4_MOSI.DATA <= RX_MOSI.DATA;
   TX4_MOSI.DVAL <= RX_MOSI.DVAL and not RX_BUSYi;   
   
   -- pragma translate_off 
   assert_proc : process(ARESET)
   begin       
      if ARESET = '0' then
         assert (RX_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;          
      end if;
   end process;
   -- pragma translate_on    
   
end RTL;
