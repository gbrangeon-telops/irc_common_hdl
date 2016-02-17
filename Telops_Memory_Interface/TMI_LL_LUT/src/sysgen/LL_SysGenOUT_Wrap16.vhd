-------------------------------------------------------------------------------
--
-- Title       : LL_SysGen_Wrap_16
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Wraps a simple System Generator module in LocalLink
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;     
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_SysGenOUT_Wrap16 is 
   port(
      TX_MOSI     : out  t_ll_mosi; 
      TX_MISO     : in t_ll_miso; 
      
      SG_RX_DATA  : in std_logic_vector(15 downto 0);
      SG_RX_DVAL  : in std_logic;
      SG_RX_SOF   : in std_logic;
      SG_RX_EOF   : in std_logic;
      SG_RX_SUPPORT_BUSY   : in std_logic;

      SG_RX_BUSY  : out std_logic;
      SG_RX_AFULL  : out std_logic
      );
end LL_SysGenOUT_Wrap16;

architecture RTL of LL_SysGenOUT_Wrap16 is  

signal rx_busy : std_logic;
   
begin      
   
   TX_MOSI.DATA          <=   SG_RX_DATA;        
   TX_MOSI.DVAL          <=   SG_RX_DVAL;        
   TX_MOSI.SOF           <=   SG_RX_SOF;         
   TX_MOSI.EOF           <=   SG_RX_EOF;         
   TX_MOSI.SUPPORT_BUSY  <=   SG_RX_SUPPORT_BUSY;
     
   SG_RX_BUSY <=  TX_MISO.BUSY; 
   SG_RX_AFULL <=  TX_MISO.AFULL;

end RTL;