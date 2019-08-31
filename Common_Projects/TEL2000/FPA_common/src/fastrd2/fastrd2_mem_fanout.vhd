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
      
      FIFOA_AFULL       : in std_logic;
      FIFOA_WR          : out std_logic;
      FIFOA_DATA        : out std_logic_vector(71 downto 0);
      
      FIFOB_AFULL       : in std_logic;
      FIFOB_WR          : out std_logic;
      FIFOB_DATA        : out std_logic_vector(71 downto 0);    
      
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
   
   signal sreset              : std_logic;
   signal fifo_wr_i           : std_logic;
   signal fifo_data_i         : std_logic_vector(FIFOA_DATA'LENGTH-1 downto 0);
   signal afull_i             : std_logic;
   
   
begin                                                     
   
   --------------------------------------------------
   -- output maps
   --------------------------------------------------  
   FIFOA_WR   <= fifo_wr_i;
   FIFOA_DATA <= fifo_data_i;
   
   FIFOB_WR   <= fifo_wr_i;
   FIFOB_DATA <= fifo_data_i;
   
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
            fifo_wr_i <= '0';
            afull_i <= '0';
         else
            
            ----------------------------------------------------------
            -- generation afull
            ----------------------------------------------------------
            afull_i <= FIFOA_AFULL or FIFOB_AFULL;
            
            ----------------------------------------------------------
            -- conversion en std_logic_vector
            ----------------------------------------------------------
            fifo_wr_i <= AREA_INFO.INFO_DVAL or AREA_INFO.RAW.RD_END;            
            fifo_data_i <= std_logic_vector(resize(unsigned(area_info_to_vector_func(AREA_INFO)), fifo_data_i'length));
            
         end if;
      end if; 
   end process;   
   
end rtl;
