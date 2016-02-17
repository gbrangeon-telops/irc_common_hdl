-------------------------------------------------------------------------------
--
-- Title       : LL_BusyBreak_8
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Breaks the busy combinatorial feedback. Use this block to
--               improve timing closure.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_BusyBreak_8 is 
   port(
      RX_MOSI  : in  t_ll_mosi8; 
      RX_MISO  : out t_ll_miso; 
      
      TX_MOSI  : out t_ll_mosi8;
      TX_MISO  : in  t_ll_miso;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end LL_BusyBreak_8;

architecture RTL of LL_BusyBreak_8 is  

   attribute KEEP_HIERARCHY : string;
   attribute KEEP_HIERARCHY of RTL: architecture is "false";
   
   signal RX_MOSI32  : t_ll_mosi32;
   signal TX_MOSI32  : t_ll_mosi32;
   
   component ll_busybreak
      generic(
         DLEN : NATURAL := 32);
      port(
         RX_MOSI : in t_ll_mosi32;
         RX_MISO : out t_ll_miso;
         TX_MOSI : out t_ll_mosi32;
         TX_MISO : in t_ll_miso;
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC);
   end component;    
   
begin      
   
   RX_MOSI32.SOF  <= RX_MOSI.SOF;
   RX_MOSI32.EOF  <= RX_MOSI.EOF;
   RX_MOSI32.DATA <= std_logic_vector(resize(unsigned(RX_MOSI.DATA),32));
   RX_MOSI32.DVAL <= RX_MOSI.DVAL;
   RX_MOSI32.DREM <= "11";
   RX_MOSI32.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   
   TX_MOSI.SOF  <= TX_MOSI32.SOF;
   TX_MOSI.EOF  <= TX_MOSI32.EOF;
   TX_MOSI.DATA <= TX_MOSI32.DATA(TX_MOSI.DATA'range);
   TX_MOSI.DVAL <= TX_MOSI32.DVAL;   
   TX_MOSI.SUPPORT_BUSY <=TX_MOSI32.SUPPORT_BUSY;   
   
   BB : ll_busybreak
   generic map(
      DLEN => 8
      )
   port map(
      RX_MOSI => RX_MOSI32,
      RX_MISO => RX_MISO,
      TX_MOSI => TX_MOSI32,
      TX_MISO => TX_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   
   
end RTL;