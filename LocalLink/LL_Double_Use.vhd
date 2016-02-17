-------------------------------------------------------------------------------
--
-- Title       : LL_Double_Use
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : This module creates two valid outputs (which are the same) for 
--               each input, thus the name "Double_Use".
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_Double_Use is
   port(   
      RX_LL_MOSI  : in  t_ll_mosi32;
      RX_LL_MISO  : out t_ll_miso;
      
      TX_LL_MOSI  : out t_ll_mosi32; 
      TX_LL_MISO  : in  t_ll_miso;
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC		 
      );
end LL_Double_Use;

architecture RTL of LL_Double_Use is
   signal FetchNewRX : std_logic;
   signal PipeEmpty  : std_logic;
   signal TXSentOnce : std_logic;
   signal RX_BUSYi   : std_logic; 
   signal TX_DVALi   : std_logic; 
   signal TX_SOFi    : std_logic;
   signal TX_EOFi    : std_logic;
begin
   RX_LL_MISO.AFULL <= TX_LL_MISO.AFULL;
   RX_BUSYi <= not FetchNewRX;
   RX_LL_MISO.BUSY <= RX_BUSYi;
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   TX_LL_MOSI.DVAL <= TX_DVALi;
   
   FetchNewRX <= (TXSentOnce and TX_DVALi and not TX_LL_MISO.BUSY) or PipeEmpty;
   
   TX_LL_MOSI.SOF <= TX_SOFi when TXSentOnce = '0' else '0';
   TX_LL_MOSI.EOF <= TX_EOFi when TXSentOnce = '1' else '0';
   
   process(CLK, ARESET)
      
   begin
      if ARESET = '1' then
         PipeEmpty <= '1';
         TXSentOnce <= '0';
         TX_DVALi <= '0';
      elsif rising_edge(CLK) then
         if TX_DVALi='1' and TX_LL_MISO.BUSY='0' then
            if TXSentOnce = '0' then
               TXSentOnce <= '1';   
            else
               TXSentOnce <= '0'; 
               PipeEmpty <= '1';
            end if;
         end if;
         
         if RX_LL_MOSI.DVAL='1' and RX_BUSYi='0' then
            PipeEmpty <= '0';
         end if;         
         
         if TX_DVALi='1' and TX_LL_MISO.BUSY='0' and TXSentOnce='1' then
            TX_DVALi <= '0';
         end if;         
         
         if RX_LL_MOSI.DVAL='1' and RX_BUSYi='0' then
            TX_SOFi <= RX_LL_MOSI.SOF   ;
            TX_EOFi <= RX_LL_MOSI.EOF   ;
            TX_LL_MOSI.DATA <= RX_LL_MOSI.DATA  ;
            TX_DVALi <= '1';
         end if;         
         
         
         -- pragma translate_off
         assert (RX_LL_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;               
         -- pragma translate_on
      end if;
      
   end process;
   
end RTL;
