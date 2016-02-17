-------------------------------------------------------------------------------
--
-- Title       : LL_value
-- Author      : SSA
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--  $Revision$
--  $Author$
--  $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library common_hdl;
use common_hdl.telops.all;

entity LL_value is  
   generic(
      DLEN : natural := 32);
   port(
      VALUE : in std_logic_vector(31 downto 0);
      TX_MOSI : out t_ll_mosi32;
      TX_MISO : in  t_ll_miso      
      );
   
   attribute keep_hierarchy : string;
   attribute keep_hierarchy of LL_value: entity is "no";
end LL_value;


architecture RTL of LL_value is
begin
   
   TX_MOSI.SOF <= '0';
   TX_MOSI.EOF <= '0';
   TX_MOSI.DATA(DLEN-1 downto 0) <= VALUE(DLEN-1 downto 0);
   TX_MOSI.DATA(31 downto DLEN) <= (others=>'0');
   TX_MOSI.DVAL <= '1';
   TX_MOSI.SUPPORT_BUSY <= '1';
   TX_MOSI.DREM <= (others => '0');
   
end RTL;
