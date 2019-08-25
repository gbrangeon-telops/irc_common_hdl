------------------------------------------------------------------
--!   @file : fastrd2_area_mem_ctler
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

entity fastrd2_area_mem_ctler is
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      AREA_INFO         : in area_info_type;
      
      AREA_FIFO_WR      : out std_logic;
      AREA_FIFO_DATA    : out std_logic_vector(71 downto 0)
      
      );   
end fastrd2_area_mem_ctler;

architecture rtl of fastrd2_area_mem_ctler is  
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component; 
   
   signal sreset           : std_logic;
   signal area_fifo_wr_i   : std_logic;
   signal area_fifo_data_i : std_logic_vector(AREA_FIFO_DATA'LENGTH-1 downto 0);
   
begin
   
   AREA_FIFO_WR   <= area_fifo_wr_i;
   AREA_FIFO_DATA <= area_fifo_data_i;
   
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
   -- Ecriture dans le fifo                                 
   -------------------------------------------------- 
   U2: process(CLK)
   begin      
      
      if rising_edge(CLK) then                     
         if sreset = '1' then
            area_fifo_wr_i <= '0';
            
         else
            
            ----------------------------------------------------------
            -- conversion en std_logic_vector
            ----------------------------------------------------------
            area_fifo_wr_i <= AREA_INFO.RAW.RECORD_VALID or AREA_INFO.RAW.RD_END;            
            area_fifo_data_i <= std_logic_vector(resize(unsigned(area_info_to_vector_func(AREA_INFO)), area_fifo_data_i'length));
            
         end if;
      end if; 
   end process;   
   
end rtl;
