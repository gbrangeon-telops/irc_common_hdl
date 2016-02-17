-------------------------------------------------------------------------------
--
-- Title       : TMI_a21_d32_to_d24
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
use IEEE.std_logic_1164.all;    
library Common_HDL;
use Common_HDL.Telops.all;


entity TMI_a21_d32_to_d24 is
   port(     
      TMI32_MOSI : in  t_tmi_mosi_a21_d32;
      TMI32_MISO : out t_tmi_miso_d32;  
      
      TMI24_MOSI : out t_tmi_mosi_a21_d24;
      TMI24_MISO : in  t_tmi_miso_d24            
      );
end TMI_a21_d32_to_d24;

architecture RTL of TMI_a21_d32_to_d24 is

   attribute KEEP_HIERARCHY : string;                         
   attribute KEEP_HIERARCHY of RTL: architecture is "false";   
begin 
   
   TMI24_MOSI.ADD     <= TMI32_MOSI.ADD    ;
   TMI24_MOSI.RNW     <= TMI32_MOSI.RNW    ;
   TMI24_MOSI.DVAL    <= TMI32_MOSI.DVAL   ;
   TMI24_MOSI.WR_DATA <= TMI32_MOSI.WR_DATA(23 downto 0);
   
   TMI32_MISO.BUSY    <= TMI24_MISO.BUSY   ;  
   TMI32_MISO.RD_DATA <= (31 downto 24 => '0') & TMI24_MISO.RD_DATA;  
   TMI32_MISO.RD_DVAL <= TMI24_MISO.RD_DVAL;  
   TMI32_MISO.IDLE    <= TMI24_MISO.IDLE   ;  
   TMI32_MISO.ERROR   <= TMI24_MISO.ERROR  ;    
   
   
end RTL;
