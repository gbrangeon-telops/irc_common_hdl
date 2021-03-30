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
use work.fpa_define.all;

entity fastrd2_raw_area_gen is
   
   port (
      ARESET               : in std_logic;
      CLK                  : in std_logic; 
      AFULL                : in std_logic;
            
      RAW_AREA_CFG         : in area_cfg_type;      
      START                : in std_logic;
                           
      AREA_INFO            : out area_info_type
      );  
end fastrd2_raw_area_gen;


architecture rtl of fastrd2_raw_area_gen is   
   
   --type sync_flag_fsm_type is (idle, sync_flag_dly_st, sync_flag_on_st1, sync_flag_on_st2, sync_flag_on_st3);
   type readout_fsm_type is (idle, pause_st, readout_st, wait_readout_end_st);
   type area_info_pipe_type is array (0 to 4) of area_info_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   
   signal readout_fsm          : readout_fsm_type;
   signal start_i              : std_logic := '0';
   signal start_last           : std_logic;
   signal frame_pclk_cnt       : unsigned(RAW_AREA_CFG.READOUT_PCLK_CNT_MAX'LENGTH-1 downto 0); 
   signal line_pclk_cnt        : unsigned(RAW_AREA_CFG.LINE_PERIOD_PCLK'LENGTH-1 downto 0);
   signal adc_sync_flag_i      : std_logic;
   signal area_info_pipe       : area_info_pipe_type;
   signal readout_in_progress  : std_logic;
   signal raw_line_en          : std_logic;
   signal global_reset         : std_logic;
   signal line_cnt             : unsigned(RAW_AREA_CFG.LINE_END_NUM'LENGTH-1 downto 0);
   signal sol_pipe_pclk        : std_logic_vector(1 downto 0):= (others => '0'); 
   signal lsync_i              : std_logic;
   signal lsync_cnt            : unsigned(RAW_AREA_CFG.LSYNC_NUM'LENGTH-1 downto 0);
   signal pclk_cnt_edge        : std_logic;
   --  signal record_valid         : std_logic := '0';
   signal pclk_sample_last     : std_logic := '0';
   signal lsync_enabled        : std_logic;
   signal lval_temp            : std_logic;
   
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------  
   AREA_INFO <= area_info_pipe(4);   
   
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
            start_last <= '0';
            start_i <= '0';
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
                  if area_info_pipe(0).raw.rd_end = '1' then     
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
               line_pclk_cnt <= line_pclk_cnt + 1;    -- referentiel ligne  : compteur temporel sur ligne synchronisé sur celui de trame. 
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
         
         area_info_pipe(0).clk_info.clk_id <= resize(unsigned(RAW_AREA_CFG.CLK_ID), area_info_pipe(0).clk_info.clk_id'length); -- horloge de la zone raw
         
         if AFULL = '0' then 
            
            ----------------------------------------------
            -- pipe 0 pour generation identificateurs 
            ----------------------------------------------
            if frame_pclk_cnt = 1 then                                  -- fval
               area_info_pipe(0).raw.fval <= '1';
            elsif frame_pclk_cnt = RAW_AREA_CFG.READOUT_PCLK_CNT_MAX then
               area_info_pipe(0).raw.fval <= '0';
            end if;
            
            if line_pclk_cnt = RAW_AREA_CFG.SOL_POSL_PCLK then          -- sol
               area_info_pipe(0).raw.sol <= '1';
               area_info_pipe(0).raw.lval <= '1';
            else
               area_info_pipe(0).raw.sol <= '0';
            end if;          
            
            if line_pclk_cnt = RAW_AREA_CFG.EOL_POSL_PCLK then          -- eol
               area_info_pipe(0).raw.eol <= '1';
               area_info_pipe(0).raw.lval <= '0';
            else
               area_info_pipe(0).raw.eol <= '0';
            end if;
            
            if frame_pclk_cnt = RAW_AREA_CFG.SOF_POSF_PCLK then         -- sof
               area_info_pipe(0).raw.sof <= '1';
            else
               area_info_pipe(0).raw.sof <= '0';
            end if;
            
            if frame_pclk_cnt = RAW_AREA_CFG.EOF_POSF_PCLK then         -- eof
               area_info_pipe(0).raw.eof <= '1';
            else
               area_info_pipe(0).raw.eof <= '0';        
            end if;            
            area_info_pipe(0).raw.rd_end <= area_info_pipe(1).raw.fval and not area_info_pipe(0).raw.fval; -- read_end se trouve en dehors de fval. C'est voulu. le suivre pour comprendre ce qu'il fait.
            area_info_pipe(0).raw.line_pclk_cnt <= line_pclk_cnt;
            
            -----------------------------------------------
            -- pipe 1 : génération de line_cnt, lval
            ---------------------------------------------           
            area_info_pipe(1) <= area_info_pipe(0);
            if area_info_pipe(0).raw.line_pclk_cnt = 1 then -- if raw_pipe(1).sol = '0' and raw_pipe(0).sol = '1' then 
               line_cnt <= line_cnt + 1;
            end if;                    
            area_info_pipe(1).raw.sol <= area_info_pipe(0).raw.sol and area_info_pipe(0).raw.fval;
            area_info_pipe(1).raw.lval <= (area_info_pipe(0).raw.lval or area_info_pipe(0).raw.eol) and area_info_pipe(0).raw.fval;
            
            ----------------------------------------------
            -- pipe 2 
            ----------------------------------------------
            area_info_pipe(2) <= area_info_pipe(1);
            area_info_pipe(2).raw.line_cnt <= line_cnt;
            if  line_cnt >= RAW_AREA_CFG.LINE_START_NUM then     -- raw_line_en
               raw_line_en <= '1';
            else
               raw_line_en <= '0';
            end if;
            if line_cnt <= RAW_AREA_CFG.LSYNC_NUM then           -- lsync enabled
               lsync_enabled <= '1';
            else
               lsync_enabled <= '0';
            end if;
            
            ----------------------------------------------
            -- pipe 3 pour generation dval et lsync         
            ----------------------------------------------
            area_info_pipe(3) <= area_info_pipe(2);
            if area_info_pipe(2).raw.line_cnt <= RAW_AREA_CFG.LINE_END_NUM then  
               area_info_pipe(3).raw.dval   <= raw_line_en and area_info_pipe(2).raw.lval; 
            else
               area_info_pipe(3).raw.dval   <= '0';
            end if;     
            if area_info_pipe(2).raw.line_pclk_cnt = RAW_AREA_CFG.LSYNC_START_POSL_PCLK then
               area_info_pipe(3).raw.lsync <= lsync_enabled;
            elsif area_info_pipe(2).raw.line_pclk_cnt > RAW_AREA_CFG.LSYNC_END_POSL_PCLK then
               area_info_pipe(3).raw.lsync <= '0';
            end if;
            
            ----------------------------------------------
            -- pipe 4 pour generation info_dval         
            ----------------------------------------------
            area_info_pipe(4) <= area_info_pipe(3);
            area_info_pipe(4).info_dval <= area_info_pipe(3).raw.fval or area_info_pipe(3).raw.rd_end;
            
         else
            area_info_pipe(4).info_dval <= '0';
         end if;
         
         global_reset <= sreset or area_info_pipe(3).raw.rd_end;
         
         -------------------------
         -- reset des identificateurs
         -------------------------
         if global_reset = '1' then
            raw_line_en <= '0';
            area_info_pipe(1).raw.sol <= '0';
            lval_temp <= '0';
            line_cnt <= (others => '0');
            lsync_enabled <= '0';
            for ii in 0 to 4 loop
               area_info_pipe(ii).raw <= ((others => '0'), (others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'));     
               area_info_pipe(ii).info_dval <= '0';
               area_info_pipe(ii).raw.rd_end <= '0';
            end loop;
         end if;
         
      end if;
      
   end process; 
   
end rtl;
