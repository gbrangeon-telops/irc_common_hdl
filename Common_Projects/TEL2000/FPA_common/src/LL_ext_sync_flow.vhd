-------------------------------------------------------------------------------
--
-- Title       : LL_ext_sync_flow
-- Design      : Common_HDL
-- Author      : ENO
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------
--
-- Description :  This module is to synchronize two input data flows. It is
--                used when a downstream module needs both flows to be valid
--                simultaneously, such as a divider or multiplier module.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity LL_ext_sync_flow is
   port(           
      
      RX0_DVAL    : in std_logic;
      RX0_BUSY    : out std_logic;
      
      RX1_DVAL    : in std_logic;
      RX1_BUSY    : out std_logic;
      
      SYNC_BUSY   : in std_logic;      
      SYNC_DVAL   : out std_logic               
      
      );
end LL_ext_sync_flow;


architecture RTL of LL_ext_sync_flow is
begin
 
   RX0_BUSY <= (RX0_DVAL and not  RX1_DVAL) or  SYNC_BUSY;

   RX1_BUSY <= (RX1_DVAL and not  RX0_DVAL) or SYNC_BUSY;   
   
   SYNC_DVAL <= RX0_DVAL and RX1_DVAL;
   
end RTL;
