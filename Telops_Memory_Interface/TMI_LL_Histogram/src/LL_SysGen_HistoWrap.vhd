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

entity LL_SysGen_HistoWrap is 
   port(
      RX_MOSI     : in  t_ll_mosi; 
      RX_MISO     : in t_ll_miso; 
      
      SG_RX_DATA  : out std_logic_vector(15 downto 0);
      SG_RX_SOF   : out std_logic;
      SG_RX_EOF   : out std_logic;
      SG_RX_DVAL  : out std_logic;
      SG_RX_BUSY  : out std_logic;    

      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC
      );
end LL_SysGen_HistoWrap;

architecture RTL of LL_SysGen_HistoWrap is  

signal rx_busy : std_logic;
   
begin      
   
   
   SG_RX_SOF  <= RX_MOSI.SOF;
   SG_RX_EOF  <= RX_MOSI.EOF;
   SG_RX_DATA <= RX_MOSI.DATA;
   SG_RX_DVAL <= RX_MOSI.DVAL;  
   SG_RX_BUSY <= RX_MISO.BUSY;   

end RTL;