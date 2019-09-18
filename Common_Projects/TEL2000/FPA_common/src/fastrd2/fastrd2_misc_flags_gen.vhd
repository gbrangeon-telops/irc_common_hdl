------------------------------------------------------------------
--!   @file : mglk_DOUT_DVALiter
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
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fastrd2_define.all; 

entity fastrd2_misc_flags_gen is
  
   port (
      ARESET               : in std_logic;
      CLK                  : in std_logic; 
      
      DOUBLE_AREA_INFO     : in double_area_info_type;      
      AREA_INFO            : out area_info_type
      
      );  
end fastrd2_misc_flags_gen;


architecture rtl of fastrd2_misc_flags_gen is   
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
      
   type writer_fsm_type is (idle, wait_end_st, last_wr_st); 
   
   signal sreset               : std_logic;
   signal area_info_i          : area_info_type;

   
begin
   
   --------------------------------------------------
   -- outputs map
   --------------------------------------------------                       
   AREA_INFO <= area_info_i;
   
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
   --  generation des misc flags 
   --------------------------------------------------
   U4: process(CLK)
   begin
      if rising_edge(CLK) then
         
         area_info_i <= DOUBLE_AREA_INFO.PRESENT;
         area_info_i.info_dval <= DOUBLE_AREA_INFO.INFO_DVAL;
         
         -- les miscellaneous flags 
         area_info_i.raw.imminent_aoi <= DOUBLE_AREA_INFO.FUTURE.USER.SOL and not DOUBLE_AREA_INFO.PRESENT.USER.SOL; 
         if DOUBLE_AREA_INFO.PRESENT.CLK_ID /= DOUBLE_AREA_INFO.FUTURE.CLK_ID  then 
            area_info_i.raw.imminent_clk_change <= '1';
         else
            area_info_i.raw.imminent_clk_change <= '0';
         end if;
         
      end if;
   end process; 
   
end rtl;
