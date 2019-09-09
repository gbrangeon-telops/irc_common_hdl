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
   
   generic(
      FIFO_FULL_THRESHOLD  : integer range 0 to 511 := 384
      );    
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      AREA_INFO         : in area_info_type;     
      
      AREA_FIFO_DCNT    : in std_logic_vector(9 downto 0);
      AREA_FIFO_WR      : out std_logic;
      AREA_FIFO_DATA    : out std_logic_vector(71 downto 0);
      
      AFULL             : out std_logic
      );   
end fastrd2_area_mem_ctler;

architecture rtl of fastrd2_area_mem_ctler is  
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component; 
   
   signal sreset              : std_logic;
   signal area_fifo_wr_i      : std_logic;
   signal area_fifo_data_i    : std_logic_vector(AREA_FIFO_DATA'LENGTH-1 downto 0);
   signal afull_i             : std_logic;
   
begin
   
--   AREA_FIFO_WR   <= area_fifo_wr_i;
--   AREA_FIFO_DATA <= area_fifo_data_i;
   
   AREA_FIFO_WR <= AREA_INFO.INFO_DVAL;            
   AREA_FIFO_DATA <= std_logic_vector(resize(unsigned(area_info_to_vector_func(AREA_INFO)), area_fifo_data_i'length));
   
   
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
   -- Ecriture dans le fifo                                 
   -------------------------------------------------- 
   U2: process(CLK)
   begin      
      
      if rising_edge(CLK) then                     
         if sreset = '1' then
            -- area_fifo_wr_i <= '0';
            afull_i <= '0';
         else
            
            if unsigned(AREA_FIFO_DCNT) > FIFO_FULL_THRESHOLD then 
               afull_i <= '1';
            else
               afull_i <= '0';
            end if;            
            
            ----------------------------------------------------------
            -- conversion en std_logic_vector
            ----------------------------------------------------------
            --            area_fifo_wr_i <= AREA_INFO.INFO_DVAL;            
            --            area_fifo_data_i <= std_logic_vector(resize(unsigned(area_info_to_vector_func(AREA_INFO)), area_fifo_data_i'length));
            --            
         end if;
      end if; 
   end process;   
   
end rtl;
