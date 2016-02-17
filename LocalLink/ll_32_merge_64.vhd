---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  Author: Olivier Bourgois
--
--  File: ll_32_merge_64.vhd
--  Use:  Block for merging two 32 bit Localink Buses into a 64 bit LocalLink Bus
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity ll_32_merge_64 is
   port(
      CLK       : in  std_logic;
      RX0_MOSI  : in  t_ll_mosi32;
      RX0_MISO  : out t_ll_miso;
      RX1_MOSI  : in  t_ll_mosi32;
      RX1_MISO  : out t_ll_miso;
      TX_MOSI   : out t_ll_mosi64;
      TX_MISO   : in  t_ll_miso);
end ll_32_merge_64;

architecture rtl of ll_32_merge_64 is
   
begin
   
   -- miso mappings
   RX0_MISO.BUSY <= (RX0_MOSI.DVAL and not RX1_MOSI.DVAL) or TX_MISO.BUSY;
   RX1_MISO.BUSY <= (RX1_MOSI.DVAL and not RX0_MOSI.DVAL) or TX_MISO.BUSY;
   RX0_MISO.AFULL <= TX_MISO.AFULL;
   RX1_MISO.AFULL <= TX_MISO.AFULL;
   
   -- mosi mappings
   TX_MOSI.DVAL <= RX0_MOSI.DVAL and RX1_MOSI.DVAL;  -- both data must be valid
   TX_MOSI.SOF  <= RX0_MOSI.SOF;                     -- sync SOF/EOF to either path
   TX_MOSI.EOF  <= RX0_MOSI.EOF;
   
   map_data : process(RX0_MOSI.DATA, RX0_MOSI.DREM, RX1_MOSI.DATA, RX1_MOSI.DREM)
   begin
      if RX0_MOSI.DREM = "01" then
         TX_MOSI.DATA <= RX0_MOSI.DATA(31 downto 16) & RX1_MOSI.DATA(31 downto 16) & x"00000000";
         TX_MOSI.DREM <= "011";
      else
         TX_MOSI.DATA <= RX0_MOSI.DATA(31 downto 16) & RX1_MOSI.DATA(31 downto 16) & RX0_MOSI.DATA(15 downto 0) & RX1_MOSI.DATA(15 downto 0);
         TX_MOSI.DREM <= "111";
      end if;
   end process map_data;
   
   -- broadcast/verify busy support
   TX_MOSI.SUPPORT_BUSY <= '1';   
   -- translate_off   
   assert (RX0_MOSI.SUPPORT_BUSY /= '0') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;
   assert (RX1_MOSI.SUPPORT_BUSY /= '0') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;
   -- translate_on
   
end rtl;
