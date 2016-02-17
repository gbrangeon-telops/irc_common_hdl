-------------------------------------------------------------------------------
--
-- Title       : LL_BusyBreak_32
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

entity LL_BusyBreak_32 is 
   port(
      RX_MOSI  : in  t_ll_mosi32; 
      RX_MISO  : out t_ll_miso; 
      
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end LL_BusyBreak_32;

architecture RTL of LL_BusyBreak_32 is
   
   attribute KEEP_HIERARCHY : string;
   attribute KEEP_HIERARCHY of RTL: architecture is "false";
   
   --signal RX_MOSI32  : t_ll_mosi32;
   --signal TX_MOSI32  : t_ll_mosi32;
   
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
      
   BB : ll_busybreak
   generic map(
      DLEN => 32
      )
   port map(
      RX_MOSI => RX_MOSI,
      RX_MISO => RX_MISO,
      TX_MOSI => TX_MOSI,
      TX_MISO => TX_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   
   
end RTL;