-------------------------------------------------------------------------------
--
-- Title       : TD_Mux
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : Time Division Multiplexer.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library Common_HDL;
use Common_HDL.Telops.all;

entity TD_Mux21 is
   port(
      RX1_LL_MOSI : in  t_ll_mosi21;
      RX1_LL_MISO : out t_ll_miso;
      
      RX2_LL_MOSI : in  t_ll_mosi21; 
      RX2_LL_MISO : out t_ll_miso;
      
      TX_LL_MOSI  : out t_ll_mosi21;
      TX_LL_MISO  : in  t_ll_miso;
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC
      );
end TD_Mux21;


architecture RTL of TD_Mux21 is
   signal Sel : std_logic;
   signal TX_DVALi : std_logic;   
   signal RX1_BUSYi : std_logic;
   signal RX_EOF_reg : std_logic;   
begin    
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';   
   
   TX_LL_MOSI.SOF <= RX1_LL_MOSI.SOF when Sel = '0' else '0';
   TX_LL_MOSI.EOF <= RX_EOF_reg when Sel = '1' else '0';   
     
   DATA_sel : with Sel select TX_LL_MOSI.DATA <= 
   RX1_LL_MOSI.DATA when '0',
   RX2_LL_MOSI.DATA when others;
   
   TX_LL_MOSI.DVAL <= TX_DVALi;
   DVAL_sel : with Sel select TX_DVALi <= 
   RX1_LL_MOSI.DVAL when '0',   
   RX2_LL_MOSI.DVAL when others;
  
   RX1_LL_MISO.AFULL <= TX_LL_MISO.AFULL;  
   RX2_LL_MISO.AFULL <= TX_LL_MISO.AFULL;   
   
   RX1_LL_MISO.BUSY <= RX1_BUSYi;
   RX1_BUSYi <= TX_LL_MISO.BUSY when Sel = '0' else '1';       
   RX2_LL_MISO.BUSY <= TX_LL_MISO.BUSY when Sel = '1' else '1';   
   
   process(CLK, ARESET)      
   begin
      if ARESET = '1' then
         Sel <= '0';
      elsif rising_edge(CLK) then
         if RX1_LL_MOSI.DVAL='1' and RX1_BUSYi='0' then
            RX_EOF_reg <= RX1_LL_MOSI.EOF;
         end if;
         if TX_DVALi='1' and TX_LL_MISO.BUSY='0' then
            Sel <= not Sel;   
         end if;
         -- pragma translate_off
         assert (RX1_LL_MOSI.SUPPORT_BUSY = '1') report "RX1 Upstream module must support the BUSY signal" severity FAILURE;               
         assert (RX2_LL_MOSI.SUPPORT_BUSY = '1') report "RX2 Upstream module must support the BUSY signal" severity FAILURE;               
         -- pragma translate_on         
      end if;      
   end process;   
   
end RTL;
