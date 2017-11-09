------------------------------------------------------------------
--!   @file : wdow_mem_input_ctler
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
use work.fpa_define.all;
use work.fpa_common_pkg.all; 

entity wdow_mem_input_ctler is
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      WINDOW_INFO       : in window_info_type;
      
      WDOW_FIFO_WR_EN   : out std_logic;
      WDOW_FIFO_DATA    : out std_logic_vector(42 downto 0)
      
      );   
end wdow_mem_input_ctler;

architecture rtl of wdow_mem_input_ctler is
   
   type wdow_data_pipe_type is array (0 to 1) of std_logic_vector(42 downto 0);   
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal wdow_data_wr_pipe : std_logic_vector(1 downto 0);
   signal wdow_data_pipe    : wdow_data_pipe_type;
   signal sreset            : std_logic;
   signal wdow_data_wr_last : std_logic;
   
   
begin
   
   WDOW_FIFO_WR_EN <= wdow_data_wr_pipe(1);
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
            wdow_data_wr_pipe <= (others => '0');
            wdow_data_wr_last <= '0';
            
         else
            
            if WINDOW_INFO.RAW.PCLK_SAMPLE  = '1' then 
               ----------------------------------------------------------
               -- pipe(0)
               ----------------------------------------------------------
               wdow_data_pipe(0)(42)            <= WINDOW_INFO.DATA_ID(0);
               wdow_data_pipe(0)(41)            <= WINDOW_INFO.RAW.ACTIVE_WINDOW;
               wdow_data_pipe(0)(40)            <= WINDOW_INFO.IMMINENT_CLK_CHANGE;
               wdow_data_pipe(0)(39)            <= WINDOW_INFO.FAST_CLK_EN;
               wdow_data_pipe(0)(38)            <= WINDOW_INFO.SLOW_CLK_EN;   
               -- raw area                     
               wdow_data_pipe(0)(37)            <= WINDOW_INFO.RAW.IMMINENT_LSYNC;
               wdow_data_pipe(0)(36)            <= WINDOW_INFO.RAW.LSYNC;
               wdow_data_pipe(0)(35)            <= WINDOW_INFO.RAW.FVAL;
               wdow_data_pipe(0)(34)            <= WINDOW_INFO.RAW.SOF;   
               wdow_data_pipe(0)(33)            <= WINDOW_INFO.RAW.EOF;   
               wdow_data_pipe(0)(32)            <= WINDOW_INFO.RAW.SOL;   
               wdow_data_pipe(0)(31)            <= WINDOW_INFO.RAW.EOL;   
               wdow_data_pipe(0)(30)            <= WINDOW_INFO.RAW.LVAL;  
               wdow_data_pipe(0)(29)            <= WINDOW_INFO.RAW.DVAL;
               wdow_data_pipe(0)(28 downto 19)  <= std_logic_vector(WINDOW_INFO.RAW.LINE_CNT);
               wdow_data_pipe(0)(18 downto 9)   <= std_logic_vector(WINDOW_INFO.RAW.LINE_PCLK_CNT); 
               -- user area
               wdow_data_pipe(0)(8)             <= WINDOW_INFO.USER.IMMINENT_SOL;
               wdow_data_pipe(0)(7)             <= WINDOW_INFO.USER.SYNC_FLAG;
               wdow_data_pipe(0)(6)             <= WINDOW_INFO.USER.FVAL;
               wdow_data_pipe(0)(5)             <= WINDOW_INFO.USER.SOF;
               wdow_data_pipe(0)(4)             <= WINDOW_INFO.USER.EOF;
               wdow_data_pipe(0)(3)             <= WINDOW_INFO.USER.SOL;
               wdow_data_pipe(0)(2)             <= WINDOW_INFO.USER.EOL;
               wdow_data_pipe(0)(1)             <= WINDOW_INFO.USER.LVAL;
               wdow_data_pipe(0)(0)             <= WINDOW_INFO.USER.DVAL;
               wdow_data_wr_pipe(0)             <= not wdow_data_wr_pipe(0);   -- toggle qui suit WINDOW_INFO.RAW.PCLK_SAMPLE
               
               ----------------------------------------------------------
               -- pipe(1) : détermination des changements imminents
               ---------------------------------------------------------- 
               wdow_data_pipe(1)     <= wdow_data_pipe(0);
               wdow_data_pipe(1)(8)  <= WINDOW_INFO.USER.SOL;      -- signale à l'avance, l'imminence de l'entrée en zone USER
               wdow_data_pipe(1)(37)  <= WINDOW_INFO.RAW.LSYNC and not wdow_data_pipe(0)(36);      -- signale à l'avance, l'imminence de l'arrivée de LSYNC. wdow_data_pipe(0) intervient car le signal doit durer 1PCLK.
               wdow_data_pipe(1)(40) <= (not WINDOW_INFO.SLOW_CLK_EN and wdow_data_pipe(0)(38)) or (not WINDOW_INFO.FAST_CLK_EN and wdow_data_pipe(0)(39));      -- signale à l'avance, l'imminence du changement d'horloge
               
            end if;
            
            wdow_data_wr_last <= wdow_data_wr_pipe(0);
            wdow_data_wr_pipe(1) <=  wdow_data_wr_last xor wdow_data_wr_pipe(0);
            
         end if;
      end if; 
   end process;
   
   
end rtl;
