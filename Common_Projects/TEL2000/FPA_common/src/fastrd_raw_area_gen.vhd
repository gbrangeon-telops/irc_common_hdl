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
use work.fpa_define.all;
use work.fpa_common_pkg.all; 

entity fastrd_raw_area_gen is
   port (
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      
      FPA_PCLK          : in std_logic;  -- FPA_PCLK permet juste de generer rapidement les données pour rencontrer le requis de vitesse.    
      FPA_MCLK          : in std_logic;  -- permet une synchro sur re de MCLK. ce qui n'est pas forcément possible avec PCLK uniquement
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;      
      START             : in std_logic;
      
      WINDOW_INFO       : out window_info_type
      --AFULL             : in std_logic
      );  
end fastrd_raw_area_gen;


architecture rtl of fastrd_raw_area_gen is   
   
   --type sync_flag_fsm_type is (idle, sync_flag_dly_st, sync_flag_on_st1, sync_flag_on_st2, sync_flag_on_st3);
   type readout_fsm_type is (idle, pause_st, readout_st, wait_readout_end_st);
   type raw_pipe_type is array (0 to 4) of raw_area_type;
   
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
   signal pclk_last            : std_logic;
   signal pclk_rise            : std_logic;
   signal frame_pclk_cnt       : unsigned(FPA_INTF_CFG.RAW_AREA.READOUT_PCLK_CNT_MAX'LENGTH-1 downto 0); 
   signal line_pclk_cnt        : unsigned(FPA_INTF_CFG.RAW_AREA.LINE_PERIOD_PCLK'LENGTH-1 downto 0);
   signal quad_clk_copy_i      : std_logic;
   signal quad_clk_copy_last   : std_logic;
   signal adc_sync_flag_i      : std_logic;
   signal raw_pipe             : raw_pipe_type;
   signal rd_end_pipe          : std_logic_vector(3 downto 0) := (others => '0');
   signal readout_in_progress  : std_logic;
   signal raw_line_en          : std_logic;
   signal global_reset         : std_logic;
   signal line_cnt             : unsigned(FPA_INTF_CFG.RAW_AREA.LINE_END_NUM'LENGTH-1 downto 0);
   signal sol_pipe_pclk        : std_logic_vector(1 downto 0):= (others => '0'); 
   signal lsync_i              : std_logic;
   signal lsync_cnt            : unsigned(FPA_INTF_CFG.RAW_AREA.WINDOW_LSYNC_NUM'LENGTH-1 downto 0);
   signal pclk_cnt_edge        : std_logic;
   signal pclk_watchdog        : std_logic := '0';
   signal pclk_sample_last     : std_logic := '0';
   -- signal active_window_en     : std_logic;
   
   
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------  
   WINDOW_INFO.RAW <= raw_pipe(3);
   
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
            
            pclk_last <= FPA_PCLK;                  
            pclk_rise <= not pclk_last and FPA_PCLK;
            
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
                  if pclk_rise = '1' then 
                     readout_in_progress <= '1';               
                     readout_fsm <= wait_readout_end_st;
                  end if;
               
               when wait_readout_end_st =>                  
                  if rd_end_pipe(0) = '1' then 
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
         if pclk_rise = '1' then 
            if readout_in_progress = '1' then            
               frame_pclk_cnt <= frame_pclk_cnt + 1;  -- referentiel trame  : compteur temporel sur toute l'image
               line_pclk_cnt <= line_pclk_cnt + 1;   -- referentiel ligne  : compteur temporel sur ligne synchronisé sur celui de trame. 
            else
               frame_pclk_cnt <= to_unsigned(0, frame_pclk_cnt'length);
               line_pclk_cnt <= (others => '0'); 
            end if;         
            
            if line_pclk_cnt = FPA_INTF_CFG.RAW_AREA.LINE_PERIOD_PCLK then       -- periode du referentiel ligne
               line_pclk_cnt <= to_unsigned(1, line_pclk_cnt'length);   
            end if;
            pclk_watchdog <= not pclk_watchdog; 
         end if;   
         
      end if;
   end process;   
   
   --------------------------------------------------
   --  generation des identificateurs de trames 
   --------------------------------------------------
   U5: process(CLK)
   begin
      if rising_edge(CLK) then  
         
         if pclk_rise = '1' then 
            
            ----------------------------------------------
            -- pipe 0 pour generation identificateurs 
            ----------------------------------------------
            if frame_pclk_cnt = 1 then                                           -- fval
               raw_pipe(0).fval <= '1';
            elsif frame_pclk_cnt = FPA_INTF_CFG.RAW_AREA.READOUT_PCLK_CNT_MAX then
               raw_pipe(0).fval <= '0';
            end if;
            
            if line_pclk_cnt = FPA_INTF_CFG.RAW_AREA.SOL_POSL_PCLK then          -- lval
               raw_pipe(0).lval <= '1';
            elsif line_pclk_cnt = FPA_INTF_CFG.RAW_AREA.EOL_POSL_PCLK_P1 then
               raw_pipe(0).lval <= '0';
            end if;    
            
            if line_pclk_cnt = FPA_INTF_CFG.RAW_AREA.SOL_POSL_PCLK then          -- sol
               raw_pipe(0).sol <= '1';                                  
            else
               raw_pipe(0).sol <= '0';
            end if;
            
            if line_pclk_cnt = FPA_INTF_CFG.RAW_AREA.EOL_POSL_PCLK then         -- eol
               raw_pipe(0).eol <= '1';
            else
               raw_pipe(0).eol <= '0';
            end if;
            
            if frame_pclk_cnt = FPA_INTF_CFG.RAW_AREA.SOF_POSF_PCLK then         -- sof
               raw_pipe(0).sof <= '1';
            else
               raw_pipe(0).sof <= '0';
            end if;
            
            if frame_pclk_cnt = FPA_INTF_CFG.RAW_AREA.EOF_POSF_PCLK then         -- eof
               raw_pipe(0).eof <= '1';
            else
               raw_pipe(0).eof <= '0';        
            end if;            
            rd_end_pipe(0) <= raw_pipe(1).fval and not raw_pipe(0).fval; -- read_end se trouve en dehors de fval. C'est voulu. le suivre pour comprendre ce qu'il fait.
            raw_pipe(0).line_pclk_cnt <= line_pclk_cnt;                  
            raw_pipe(0).pclk_sample <= pclk_watchdog;
            
            -----------------------------------------------
            -- pipe 1 : génération de line_cnt
            ---------------------------------------------           
            raw_pipe(1) <= raw_pipe(0);
            rd_end_pipe(1) <= rd_end_pipe(0);
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
            rd_end_pipe(2) <= rd_end_pipe(1);
            if  line_cnt >= FPA_INTF_CFG.RAW_AREA.LINE_START_NUM and line_cnt <= FPA_INTF_CFG.RAW_AREA.LINE_END_NUM then 
               raw_line_en <= '1';
            else
               raw_line_en <= '0';
            end if; 
          
            ----------------------------------
            -- pipe 3 pour generation dval         
            ----------------------------------
            raw_pipe(3) <= raw_pipe(2);
            rd_end_pipe(3) <= rd_end_pipe(2);
            if raw_pipe(2).line_cnt <= FPA_INTF_CFG.RAW_AREA.LINE_END_NUM then  
               raw_pipe(3).dval <= raw_line_en and raw_pipe(2).lval; 
            else
               raw_pipe(3).dval <= '0';
            end if;
            if  raw_pipe(2).line_cnt >= FPA_INTF_CFG.USER_AREA.LINE_START_NUM and raw_pipe(2).line_cnt <= FPA_INTF_CFG.USER_AREA.LINE_END_NUM then 
               raw_pipe(3).active_window <= '1';
            else
               raw_pipe(3).active_window <= '0';
            end if;
            raw_pipe(3).lsync <= (raw_pipe(0).sol or raw_pipe(1).sol) and raw_pipe(0).fval;
            
         end if;
         pclk_sample_last <= raw_pipe(2).pclk_sample;
         raw_pipe(3).pclk_sample <=  pclk_sample_last xor raw_pipe(2).pclk_sample;
         
         global_reset <= sreset or rd_end_pipe(2);
         
         -------------------------
         -- reset des identificateurs
         -------------------------
         if global_reset = '1' then
            raw_line_en <= '0';
            rd_end_pipe <= (others => '0');
            raw_pipe(1).sol <= '0';
            line_cnt <= (others => '0');
            for ii in 0 to 3 loop
               raw_pipe(ii) <= ('0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0', '0');     
            end loop;
         end if;
         
      end if;
      
   end process; 
   
end rtl;
