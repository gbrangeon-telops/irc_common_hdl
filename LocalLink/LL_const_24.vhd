-------------------------------------------------------------------------------
--
-- Title       : LL_const_24
-- Author      : Patrick Dubois
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

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library COMMON_HDL;
use COMMON_HDL.TELOPS.all;

entity LL_const_24 is  
   generic(
      value : std_logic_vector(23 downto 0) := x"000000");
   port(
      TX_MOSI : out t_ll_mosi24;
      TX_MISO : in  t_ll_miso      
      );
   attribute keep_hierarchy : string;
   attribute keep_hierarchy of LL_const_24: entity is "no";
end LL_const_24;


architecture RTL of LL_const_24 is
begin
   
   TX_MOSI.SOF <= '0';
   TX_MOSI.EOF <= '0';
   TX_MOSI.DATA <= value;  
   TX_MOSI.DVAL <= '1';
   TX_MOSI.SUPPORT_BUSY <= '1';
   
end RTL;
