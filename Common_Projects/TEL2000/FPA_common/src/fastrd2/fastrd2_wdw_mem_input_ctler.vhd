------------------------------------------------------------------
--!   @file : fastrd2_wdw_mem_input_ctler
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

entity fastrd2_wdw_mem_input_ctler is
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      WINDOW_INFO       : in window_info_type;
      
      WDOW_FIFO_WR_EN   : out std_logic;
      WDOW_FIFO_DATA    : out std_logic_vector(63 downto 0)
      
      );   
end fastrd2_wdw_mem_input_ctler;

architecture rtl of fastrd2_wdw_mem_input_ctler is
   
   type wdow_data_pipe_type is array (0 to 1) of std_logic_vector(WDOW_FIFO_DATA'LENGTH-1 downto 0);   
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal wdow_data_pipe_wr : std_logic_vector(1 downto 0);
   signal wdow_data_pipe    : wdow_data_pipe_type;
   signal sreset            : std_logic;
   signal wdow_data_wr_last : std_logic;
   
   
begin
   
   WDOW_FIFO_WR_EN <= wdow_data_pipe_wr(1);
   WDOW_FIFO_DATA <= wdow_data_pipe(1);     -- ENO 24 mai 2017: on écrit dans le fifo à chaque PCLK. Cela efface la notion de temps au profit de celle du clock count
   
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
   -- chaque donnée a été générée sur PCLK_SAMPLE et ici, elle est ecrite à une cadence de PCLK_SAMPLE.
   -- Ainsi, seule la notion de coups d'horloge est conservée.
   U2: process(CLK)
   begin      
      
      if rising_edge(CLK) then                     
         if sreset = '1' then
            wdow_data_pipe_wr <= (others => '0');
            -- wdow_data_wr_last <= '0';
            
         else
            
            ----------------------------------------------------------
            -- pipe(0)
            ----------------------------------------------------------
            wdow_data_pipe_wr(0) <= WINDOW_INFO.RAW.RECORD_VALID;
            
            wdow_data_pipe(0) <=  
            '0'
            -- user (length = 15 bits) 
            & WINDOW_INFO.USER.spare                           
            & WINDOW_INFO.USER.sof                  
            & WINDOW_INFO.USER.eof                  
            & WINDOW_INFO.USER.sol                  
            & WINDOW_INFO.USER.eol                  
            & WINDOW_INFO.USER.fval                 
            & WINDOW_INFO.USER.lval                 
            & WINDOW_INFO.USER.dval                 
            
            -- raw (length = 44 bits)                         -- (47:4)
            & WINDOW_INFO.RAW.spare                 
            & WINDOW_INFO.RAW.imminent_clk_change  
            & WINDOW_INFO.RAW.imminent_aoi            
            & WINDOW_INFO.RAW.sof                  
            & WINDOW_INFO.RAW.eof                  
            & WINDOW_INFO.RAW.sol                  
            & WINDOW_INFO.RAW.eol                  
            & WINDOW_INFO.RAW.fval                 
            & WINDOW_INFO.RAW.lval                 
            & WINDOW_INFO.RAW.dval                 
            & WINDOW_INFO.RAW.lsync                
            & std_logic_vector(WINDOW_INFO.RAW.line_cnt)             
            & std_logic_vector(WINDOW_INFO.RAW.line_pclk_cnt)         
            
            --clk_id (length = 4 bits)                         -- (3:0)
            & std_logic_vector(WINDOW_INFO.CLK_ID);       
            
            ----------------------------------------------------------
            -- pipe(1) : détermination des changements imminents
            ----------------------------------------------------------
            wdow_data_pipe_wr(1) <= wdow_data_pipe_wr(0);
            wdow_data_pipe(1)     <= wdow_data_pipe(0);
            wdow_data_pipe(1)(38) <= WINDOW_INFO.USER.SOL;      -- signale à l'avance, l'imminence de l'entrée en zone USER
            if unsigned(wdow_data_pipe(0)(3 downto 0)) /= WINDOW_INFO.CLK_ID then
               wdow_data_pipe(1)(39) <= '1';      -- signale à l'avance, l'imminence du changement d'horloge
            else
               wdow_data_pipe(1)(39) <= '0';  
            end if;
            
         end if;
      end if; 
   end process;   
   
end rtl;
