-------------------------------------------------------------------------------
--
-- Title       : LL_Fanout16
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

entity LL_Fanout16 is
   generic(
      use_fifos   : boolean := false
      );
   port(
      RX_MOSI  : in  t_ll_mosi;
      RX_MISO  : out t_ll_miso;
      
      TX1_MOSI : out t_ll_mosi;
      TX1_MISO : in  t_ll_miso;
      
      TX2_MOSI : out t_ll_mosi;
      TX2_MISO : in  t_ll_miso;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end LL_Fanout16;

architecture RTL of LL_Fanout16 is
signal RX_BUSYi : std_logic; 
   signal fifo_ll_mosi : t_ll_mosi;
   signal fifo1_ll_miso : t_ll_miso;
   signal fifo2_ll_miso : t_ll_miso;   
begin
   
   no_fifos : if not use_fifos generate            
      RX_MISO.AFULL <= TX1_MISO.AFULL or TX2_MISO.AFULL;
      RX_BUSYi <= TX1_MISO.BUSY or TX2_MISO.BUSY;
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
   end generate no_fifos;
   
   fifos : if use_fifos generate
      RX_MISO.AFULL <= fifo1_ll_miso.AFULL or fifo2_ll_miso.AFULL;
      RX_BUSYi <= fifo1_ll_miso.BUSY or fifo2_ll_miso.BUSY;
      RX_MISO.BUSY <= RX_BUSYi; 
      
      fifo_ll_mosi.SUPPORT_BUSY <= '1';
      fifo_ll_mosi.SOF <= RX_MOSI.SOF;
      fifo_ll_mosi.EOF <= RX_MOSI.EOF;
      fifo_ll_mosi.DATA <= RX_MOSI.DATA;
      fifo_ll_mosi.DVAL <= RX_MOSI.DVAL and not RX_BUSYi;
      
      fifo1 : entity locallink_fifo
      generic map(
         FifoSize => 16,
         Latency => 0,
         ASYNC => false)
      port map(
         RX_LL_MOSI => fifo_ll_mosi,
         RX_LL_MISO => fifo1_ll_miso,
         CLK_RX => CLK,
         FULL => open,
         WR_ERR => open,
         TX_LL_MOSI => TX1_MOSI,
         TX_LL_MISO => TX1_MISO,
         CLK_TX => CLK,
         EMPTY => open,
         ARESET => ARESET);    
      
      fifo2 : entity locallink_fifo
      generic map(
         FifoSize => 16,
         Latency => 0,
         ASYNC => false)
      port map(
         RX_LL_MOSI => fifo_ll_mosi,
         RX_LL_MISO => fifo2_ll_miso,
         CLK_RX => CLK,
         FULL => open,
         WR_ERR => open,
         TX_LL_MOSI => TX2_MOSI,
         TX_LL_MISO => TX2_MISO,
         CLK_TX => CLK,
         EMPTY => open,
         ARESET => ARESET);       
   end generate fifos;
   
   -- pragma translate_off 
   assert_proc : process(ARESET)
   begin       
      if ARESET = '0' then
         assert (RX_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;          
      end if;
   end process;
   -- pragma translate_on   
   
end RTL;
