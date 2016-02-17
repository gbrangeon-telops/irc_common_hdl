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

entity LL_SysGen_Wrap_16 is 
   port(
      RX_MOSI     : in  t_ll_mosi; 
      RX_MISO     : out t_ll_miso; 
      
      TX_MOSI     : out t_ll_mosi;
      TX_MISO     : in  t_ll_miso;
      
      SG_CE       : out std_logic;  
      SG_EN       : out std_logic;    
      SG_RX_SOF   : out std_logic;
      SG_RX_EOF   : out std_logic;
      SG_RX_DATA  : out std_logic_vector(15 downto 0);
      SG_RX_DVAL  : out std_logic;  
      
      SG_TX_SOF   : in  std_logic;
      SG_TX_EOF   : in  std_logic;      
      SG_TX_DATA  : in  std_logic_vector(15 downto 0);
      SG_TX_DVAL  : in  std_logic;      
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC
      );
end LL_SysGen_Wrap_16;

architecture RTL of LL_SysGen_Wrap_16 is  

signal rx_busy : std_logic;
   
begin      
   
   
   SG_RX_SOF  <= RX_MOSI.SOF;
   SG_RX_EOF  <= RX_MOSI.EOF;
   SG_RX_DATA <= RX_MOSI.DATA;
   SG_RX_DVAL <= RX_MOSI.DVAL and not rx_busy;   
   RX_MISO.BUSY <= rx_busy; 
   RX_MISO.AFULL <= '0'; --TX_MISO.AFULL;
   rx_busy <= TX_MISO.BUSY;      
   
   SG_EN <= not rx_busy;
   SG_CE <= '1';
   
   TX_MOSI.SOF  <= SG_TX_SOF;
   TX_MOSI.EOF  <= SG_TX_EOF;
   TX_MOSI.DATA <= SG_TX_DATA;
   TX_MOSI.DVAL <= SG_TX_DVAL and not ARESET;      
   
   TX_MOSI.SUPPORT_BUSY <= '1';   
     
end RTL;