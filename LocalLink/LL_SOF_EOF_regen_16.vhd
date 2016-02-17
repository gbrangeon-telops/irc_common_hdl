-------------------------------------------------------------------------------
--
-- Title       : LL_SOF_EOF_regen_16
-- Author      : Patrick Dubois
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This module will regenerate SOF and EOF in a LocalLink flow in
--               case some data chunk with SOF or EOF are dropped. For example,
--               if we filter out bad pixels from a LL flow and the first pixel
--               of an image is bad, the SOF will be lost. We therefore "spy"
--               on the RAW data flow on which the SOF and EOF are intact and
--               ensure that the we reintroduce those SOF and EOF on the 
--               SUBSET data flow.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;    
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_SOF_EOF_regen_16 is 
   port(
      RAW_MOSI    : in  t_ll_mosi;
      RAW_MISO    : in  t_ll_miso;
   
      SUBSET_MOSI : in  t_ll_mosi; 
      SUBSET_MISO : out t_ll_miso; 
      
      TX_MOSI     : out t_ll_mosi;
      TX_MISO     : in  t_ll_miso;
      
      ARESET   : in  std_logic;
      CLK      : in  std_logic
      );
end LL_SOF_EOF_regen_16;

architecture RTL of LL_SOF_EOF_regen_16 is
   
   
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
      
   
end RTL;