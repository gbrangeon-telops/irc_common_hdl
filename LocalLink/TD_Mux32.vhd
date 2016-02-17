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

entity TD_Mux32 is
   port(
      RX1_MOSI : in  t_ll_mosi32;
      RX1_MISO : out t_ll_miso;
      
      RX2_MOSI : in  t_ll_mosi32; 
      RX2_MISO : out t_ll_miso;
      
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end TD_Mux32;


architecture RTL of TD_Mux32 is
   signal Sel : std_logic;
   signal TX_DVALi : std_logic;   
   signal RX1_BUSYi : std_logic;
   signal RX_EOF_reg : std_logic;   
begin    
   
   TX_MOSI.SUPPORT_BUSY <= '1';   
   
   TX_MOSI.SOF <= RX1_MOSI.SOF when Sel = '0' else '0';
   TX_MOSI.EOF <= RX_EOF_reg when Sel = '1' else '0';   
     
   DATA_sel : with Sel select TX_MOSI.DATA <= 
   RX1_MOSI.DATA when '0',
   RX2_MOSI.DATA when others;
   
   TX_MOSI.DVAL <= TX_DVALi;
   DVAL_sel : with Sel select TX_DVALi <= 
   RX1_MOSI.DVAL when '0',   
   RX2_MOSI.DVAL when others;
  
   RX1_MISO.AFULL <= TX_MISO.AFULL;  
   RX2_MISO.AFULL <= TX_MISO.AFULL;   
   
   RX1_MISO.BUSY <= RX1_BUSYi;
   RX1_BUSYi <= TX_MISO.BUSY when Sel = '0' else '1';       
   RX2_MISO.BUSY <= TX_MISO.BUSY when Sel = '1' else '1';   
   
   process(CLK, ARESET)      
   begin
      if ARESET = '1' then
         Sel <= '0';
      elsif rising_edge(CLK) then
         if RX1_MOSI.DVAL='1' and RX1_BUSYi='0' then
            RX_EOF_reg <= RX1_MOSI.EOF;
         end if;
         if TX_DVALi='1' and TX_MISO.BUSY='0' then
            Sel <= not Sel;   
         end if;
         -- pragma translate_off
         assert (RX1_MOSI.SUPPORT_BUSY = '1') report "RX1 Upstream module must support the BUSY signal" severity FAILURE;               
         assert (RX2_MOSI.SUPPORT_BUSY = '1') report "RX2 Upstream module must support the BUSY signal" severity FAILURE;               
         -- pragma translate_on         
      end if;      
   end process;   
   
end RTL;
