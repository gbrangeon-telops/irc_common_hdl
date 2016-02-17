-------------------------------------------------------------------------------
--
-- Title       : TMI_SysGen_Wrap
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
library Common_HDL;
use Common_HDL.Telops.all;

entity TMI_SysGen_Wrap is 
   port(
      TMI_MOSI     : in  t_tmi_mosi_a10_d21; 
      TMI_MISO     : out t_tmi_miso_d21; 
      
      SG_TMI_ADD     : out std_logic_vector(9 downto 0);
      SG_TMI_RNW     : out std_logic;
      SG_TMI_DVAL    : out std_logic;
      SG_TMI_BUSY    : in std_logic;
      SG_TMI_IDLE    : in std_logic;
      SG_TMI_ERROR   : in std_logic;
      SG_TMI_WR_DATA : out std_logic_vector(20 downto 0);
      SG_TMI_RD_DATA   : in std_logic_vector(20 downto 0);
      SG_TMI_RD_DVAL   : in std_logic
      );
end TMI_SysGen_Wrap;

architecture RTL of TMI_SysGen_Wrap is  

signal rx_busy : std_logic;
   
begin      
   
      SG_TMI_ADD <= TMI_MOSI.ADD;
      SG_TMI_RNW <= TMI_MOSI.RNW;
      SG_TMI_DVAL <= TMI_MOSI.DVAL;
      SG_TMI_WR_DATA <= TMI_MOSI.WR_DATA;
      TMI_MISO.BUSY <= SG_TMI_BUSY;
      TMI_MISO.IDLE <= SG_TMI_IDLE;
      TMI_MISO.ERROR <= SG_TMI_ERROR;
      TMI_MISO.RD_DATA <= SG_TMI_RD_DATA;
      TMI_MISO.RD_DVAL <= SG_TMI_RD_DVAL;

end RTL;