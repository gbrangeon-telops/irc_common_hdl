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
   
   type area_info_pipe_type is array (0 to 1) of area_info_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal fifo_wr_i            : std_logic;
   signal fifo_data_i          : std_logic_vector(FIFOA_DATA'LENGTH-1 downto 0);
   signal afull_i              : std_logic;
   signal area_info_pipe       : area_info_pipe_type;  
   
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
            -- pragma translate_off
            for ii in 0 to 1 loop
               area_info_pipe(ii).raw <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'));
               area_info_pipe(ii).user <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'));
            end loop;
            -- pragma translate_on
            
            for ii in 0 to 1 loop
               area_info_pipe(ii).imminent_clk_id <= (others => '1');
               area_info_pipe(ii).clk_id <= (others => '0');
               area_info_pipe(ii).info_dval <= '0';
            end loop;
            
         else
            
            ----------------------------------------------------------
            -- generation afull
            ----------------------------------------------------------
            afull_i <= FIFOA_AFULL or FIFOB_AFULL;
            
            ----------------------------------------------------------
            -- pipe 0
            ----------------------------------------------------------
            area_info_pipe(0) <= AREA_INFO;
            
            ----------------------------------------------------------
            -- pipe 1 : generation de imminent_clk_id
            ----------------------------------------------------------
            area_info_pipe(1) <= area_info_pipe(0);
            area_info_pipe(1).imminent_clk_id <= AREA_INFO.CLK_ID;
            
            ----------------------------------------------------------
            -- conversion en std_logic_vector
            ----------------------------------------------------------
            fifo_wr_i <= area_info_pipe(1).info_dval or area_info_pipe(1).raw.rd_end;            
            fifo_data_i <= std_logic_vector(resize(unsigned(area_info_to_vector_func(area_info_pipe(1))), fifo_data_i'length));
            
         end if;
      end if; 
   end process;   
   
end rtl;
