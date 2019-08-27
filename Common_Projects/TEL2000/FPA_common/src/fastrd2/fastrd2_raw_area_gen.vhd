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
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fastrd2_define.all; 

entity fastrd2_raw_area_gen is
   generic(
      G_DEFAULT_CLK_ID : integer range 0 to FPA_MCLK_NUM_MAX-1 := 0 
      ); 
   
   port (
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      AFULL             : in std_logic;      
      
      RAW_AREA_CFG      : in area_cfg_type;      
      START             : in std_logic;
      
      AREA_INFO       : out area_info_type
      );  
end fastrd2_raw_area_gen;


architecture rtl of fastrd2_raw_area_gen is   
   
   --type sync_flag_fsm_type is (idle, sync_flag_dly_st, sync_flag_on_st1, sync_flag_on_st2, sync_flag_on_st3);
   type readout_fsm_type is (idle, pause_st, readout_st, wait_readout_end_st);
   type area_pipe_type is array (0 to 4) of area_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   
   --signal sync_flag_fsm        : sync_flag_fsm_type;
   signal readout_fsm          : readout_fsm_type;
   signal start_i              : std_logic := '0';
   signal start_last           : std_logic;
   signal frame_pclk_cnt       : unsigned(RAW_AREA_CFG.READOUT_PCLK_CNT_MAX'LENGTH-1 downto 0); 
   signal line_pclk_cnt        : unsigned(RAW_AREA_CFG.LINE_PERIOD_PCLK'LENGTH-1 downto 0);
   signal quad_clk_copy_i      : std_logic;
   signal quad_clk_copy_last   : std_logic;
   signal adc_sync_flag_i      : std_logic;
   signal raw_pipe             : area_pipe_type;
   signal readout_in_progress  : std_logic;
   signal raw_line_en          : std_logic;
   signal global_reset         : std_logic;
   signal line_cnt             : unsigned(RAW_AREA_CFG.LINE_END_NUM'LENGTH-1 downto 0);
   signal sol_pipe_pclk        : std_logic_vector(1 downto 0):= (others => '0'); 
   signal lsync_i              : std_logic;
   signal lsync_cnt            : unsigned(RAW_AREA_CFG.WINDOW_LSYNC_NUM'LENGTH-1 downto 0);
   signal pclk_cnt_edge        : std_logic;
   --  signal record_valid         : std_logic := '0';
   signal pclk_sample_last     : std_logic := '0';
   signal active_window_en     : std_logic;
   
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------  
   AREA_INFO.RAW <= raw_pipe(3);   
   AREA_INFO.CLK_ID <= to_unsigned(G_DEFAULT_CLK_ID, AREA_INFO.CLK_ID'LENGTH);
   
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
   -- generation de readout_in_progress
   --------------------------------------------------
   U3: process(CLK)
      variable pclk_cnt_incr : std_logic_vector(1 downto 0);  
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then            
            readout_fsm <= idle;
            readout_in_progress <= '0';
            start_last <= '1';
         else           
            
            start_i <= START;
            start_last <= start_i;
            
            -- contrôleur
            case readout_fsm is           
               
               when idle =>   
                  readout_in_progress <= '0';
                  if start_last = '0' and start_i = '1' then 
                     readout_fsm <= readout_st;
                  end if;        
               
               when readout_st => 
                  if AFULL = '0' then 
                     readout_in_progress <= '1';               
                     readout_fsm <= wait_readout_end_st;
                  end if;
               
               when wait_readout_end_st =>                  
                  if raw_pipe(0).rd_end = '1' then 
                     readout_fsm <= idle;
                  end if;         
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;  
   
   --------------------------------------------------
   -- referentiel image et referentiel ligne
   --------------------------------------------------
   U4: process(CLK)
   begin
      if rising_edge(CLK) then 
         if AFULL = '0' then 
            if readout_in_progress = '1' then            
               frame_pclk_cnt <= frame_pclk_cnt + 1;  -- referentiel trame  : compteur temporel sur toute l'image
               line_pclk_cnt <= line_pclk_cnt + 1;   -- referentiel ligne  : compteur temporel sur ligne synchronisé sur celui de trame. 
            else
               frame_pclk_cnt <= to_unsigned(0, frame_pclk_cnt'length);
               line_pclk_cnt <= (others => '0'); 
            end if;         
            
            if line_pclk_cnt = RAW_AREA_CFG.LINE_PERIOD_PCLK then       -- periode du referentiel ligne
               line_pclk_cnt <= to_unsigned(1, line_pclk_cnt'length);   
            end if;
         end if;       
         
      end if;
   end process;   
   
   --------------------------------------------------
   --  generation des identificateurs de trames 
   --------------------------------------------------
   U5: process(CLK)
   begin
      if rising_edge(CLK) then  
         
         if AFULL = '0' then 
            
            ----------------------------------------------
            -- pipe 0 pour generation identificateurs 
            ----------------------------------------------
            if frame_pclk_cnt = 1 then                                           -- fval
               raw_pipe(0).fval <= '1';
            elsif frame_pclk_cnt = RAW_AREA_CFG.READOUT_PCLK_CNT_MAX then
               raw_pipe(0).fval <= '0';
            end if;
            
            if line_pclk_cnt = RAW_AREA_CFG.SOL_POSL_PCLK then          -- lval
               raw_pipe(0).lval <= '1';
            elsif line_pclk_cnt = RAW_AREA_CFG.EOL_POSL_PCLK_P1 then
               raw_pipe(0).lval <= '0';
            end if;    
            
            if line_pclk_cnt = RAW_AREA_CFG.SOL_POSL_PCLK then          -- sol
               raw_pipe(0).sol <= '1';                                  
            else
               raw_pipe(0).sol <= '0';
            end if;
            
            if line_pclk_cnt = RAW_AREA_CFG.EOL_POSL_PCLK then         -- eol
               raw_pipe(0).eol <= '1';
            else
               raw_pipe(0).eol <= '0';
            end if;
            
            if frame_pclk_cnt = RAW_AREA_CFG.SOF_POSF_PCLK then         -- sof
               raw_pipe(0).sof <= '1';
            else
               raw_pipe(0).sof <= '0';
            end if;
            
            if frame_pclk_cnt = RAW_AREA_CFG.EOF_POSF_PCLK then         -- eof
               raw_pipe(0).eof <= '1';
            else
               raw_pipe(0).eof <= '0';        
            end if;            
            raw_pipe(0).rd_end <= raw_pipe(1).fval and not raw_pipe(0).fval; -- read_end se trouve en dehors de fval. C'est voulu. le suivre pour comprendre ce qu'il fait.
            raw_pipe(0).line_pclk_cnt <= line_pclk_cnt;
                
            -----------------------------------------------
            -- pipe 1 : génération de line_cnt
            ---------------------------------------------           
            raw_pipe(1) <= raw_pipe(0);
            if raw_pipe(1).sol = '0' and raw_pipe(0).sol = '1' then 
               line_cnt <= line_cnt + 1;
            end if;                    
            raw_pipe(1).sol <= raw_pipe(0).sol and raw_pipe(0).fval; 
            raw_pipe(1).lval <= raw_pipe(0).lval and raw_pipe(0).fval;        
            
            ----------------------------------------------
            -- pipe 2 
            ----------------------------------------------
            raw_pipe(2) <= raw_pipe(1);
            raw_pipe(2).line_cnt <= line_cnt;
            if  line_cnt >= RAW_AREA_CFG.LINE_START_NUM then 
               raw_line_en <= '1';
            else
               raw_line_en <= '0';
            end if; 
            
            ----------------------------------
            -- pipe 3 pour generation dval         
            ----------------------------------
            raw_pipe(3) <= raw_pipe(2);
            if raw_pipe(2).line_cnt <= RAW_AREA_CFG.LINE_END_NUM then  
               raw_pipe(3).dval   <= raw_line_en and raw_pipe(2).lval; 
            else
               raw_pipe(3).dval   <= '0';
            end if;
            raw_pipe(3).lsync <= (raw_pipe(0).sol or raw_pipe(1).sol) and raw_pipe(0).fval;
            raw_pipe(3).record_valid <= raw_pipe(2).fval;
            
         else
            raw_pipe(3).record_valid <= '0';
         end if;
         
         global_reset <= sreset or raw_pipe(2).rd_end;
         
         -------------------------
         -- reset des identificateurs
         -------------------------
         if global_reset = '1' then
            raw_line_en <= '0';
            raw_pipe(1).sol <= '0';
            line_cnt <= (others => '0');
            for ii in 0 to 3 loop
               raw_pipe(ii) <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0');     
            end loop;
         end if;
         
      end if;
      
   end process; 
   
end rtl;
