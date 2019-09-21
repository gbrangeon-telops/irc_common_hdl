------------------------------------------------------------------
--!   @file : fastrd2_mem_fanout
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fastrd2_define.all; 

entity fastrd2_mem_fanout is
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      AREA_INFO         : in area_info_type;     
      
      AREA_INFOA_AFULL  : in std_logic;
      AREA_INFOA        : out area_info_type;
      
      AREA_INFOB_AFULL  : in std_logic;
      AREA_INFOB        : out area_info_type;   
      
      AFULL             : out std_logic
      );   
end fastrd2_mem_fanout;

architecture rtl of fastrd2_mem_fanout is  
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component; 
   
   signal sreset       : std_logic;
   signal afull_i      : std_logic;
  
   
begin                                                     
   
   --------------------------------------------------
   -- output maps
   --------------------------------------------------   
   AREA_INFOA <= AREA_INFO;
   AREA_INFOB <= AREA_INFO;
   AFULL <= afull_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );    
   
   -------------------------------------------------- 
   -- Ecriture dans les fifos                                 
   -------------------------------------------------- 
   U2: process(CLK)
   begin      
      
      if rising_edge(CLK) then                     
         if sreset = '1' then
            afull_i <= '0';
            
         else
            
            ----------------------------------------------------------
            -- generation afull
            ----------------------------------------------------------
            afull_i <= AREA_INFOA_AFULL or AREA_INFOB_AFULL;

         end if;
      end if; 
   end process;   
   
end rtl;
