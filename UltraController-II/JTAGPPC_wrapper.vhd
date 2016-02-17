-------------------------------------------------------------------------------
--
-- Title       : JTAGPPC_wrapper
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- SNV modified fields:
-- $Revision$
-- $Author$
-- $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity JTAGPPC_wrapper is
   port(
      TDOPPC     : in std_ulogic;
      TDOTSPPC   : in std_ulogic;
      TCK        : out std_ulogic;
      TDIPPC     : out std_ulogic;
      TMS        : out std_ulogic
      );
end JTAGPPC_wrapper;

architecture WRAPPER of JTAGPPC_wrapper is
   
   component JTAGPPC
      port (
         TDOPPC : in std_ulogic;
         TDOTSPPC : in std_ulogic;
         TCK : out std_ulogic;
         TDIPPC : out std_ulogic;
         TMS : out std_ulogic
         );
   end component;
   
begin
   
   U1 : JTAGPPC
   port map(
      TCK => TCK,
      TDIPPC => TDIPPC,
      TDOPPC => TDOPPC,
      TDOTSPPC => TDOTSPPC,
      TMS => TMS
      );
   
end WRAPPER;
