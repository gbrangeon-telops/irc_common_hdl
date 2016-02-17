-------------------------------------------------------------------------------
--
-- Title       : LL_SW_1_2_21
-- Author      : Patrick Dubois
-- Company     : Telops/COPL/LRTS
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Switch (demux) 1 to 2
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_SW_1_2_21 is 
   port(
      RX_MOSI  : in  t_ll_mosi21;
      RX_MISO  : out t_ll_miso;
      
      TX0_MOSI : out t_ll_mosi21;
      TX0_MISO : in  t_ll_miso;
      
      TX1_MOSI : out t_ll_mosi21;
      TX1_MISO : in  t_ll_miso;
      
      SEL         : in  std_logic_vector(1 downto 0)   
      );
end LL_SW_1_2_21;


architecture RTL of LL_SW_1_2_21 is 
   
   signal RESET      : std_logic;
   signal RX_BUSYi   : std_logic;
   signal RX_DVALi   : std_logic;
     
begin   
   
   TX0_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   TX1_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;    
   
   TX0_MOSI.SOF  <= RX_MOSI.SOF   ;
   TX0_MOSI.EOF  <= RX_MOSI.EOF   ;
   TX0_MOSI.DATA <= RX_MOSI.DATA  ;
   TX1_MOSI.SOF  <= RX_MOSI.SOF   ;
   TX1_MOSI.EOF  <= RX_MOSI.EOF   ;
   TX1_MOSI.DATA <= RX_MOSI.DATA  ;      
      
   RX_DVALi <= RX_MOSI.DVAL and not RX_BUSYi;
              
   TX0_MOSI.DVAL <= RX_DVALi when SEL = "00" or SEL = "10" else '0';
   TX1_MOSI.DVAL <= RX_DVALi when SEL = "01" or SEL = "10" else '0';
           
   busy_sel : with SEL select RX_BUSYi <=
   TX0_MISO.BUSY when "00",
   TX1_MISO.BUSY when "01",
   TX0_MISO.BUSY or TX1_MISO.BUSY when "10",
   '1' when others;
   RX_MISO.BUSY <= RX_BUSYi;
   
   afull_sel : with SEL select RX_MISO.AFULL <=
   TX0_MISO.AFULL when "00",
   TX1_MISO.AFULL when "01",
   TX0_MISO.AFULL or TX1_MISO.AFULL when "10",
   '1' when others;     
   
end RTL;
