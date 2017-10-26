------------------------------------------------------------------
--!   @file : afpa_fsync_mode_dval_gen
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------

-- ENO 27 sept 2017 :  
--    revision en profondeur pour tenir compte de le necessité de sortir les données hors AOI.
--    le flushing des fifos est abandonné. le frame sync ne sert qu'à l'initialisation. Ainsi, le mode IWR sera facilité puisque aoi_fsync aurait été une entrave.  

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fpa_define.all;

entity afpa_fsync_mode_dval_gen is
   port(
      
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : in fpa_intf_cfg_type;
      
      READOUT       : in std_logic;
      FPA_DIN       : in std_logic_vector(71 downto 0);
      FPA_DIN_DVAL  : in std_logic;
      READOUT_INFO  : in readout_info_type;
      
      DIAG_MODE_EN  : in std_logic;
      
      FPA_DOUT      : out std_logic_vector(95 downto 0);
      FPA_DOUT_DVAL : out std_logic;
      
      ERR           : out std_logic_vector(1 downto 0)
      );
end afpa_fsync_mode_dval_gen;


architecture rtl of afpa_fsync_mode_dval_gen is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component fwft_sfifo_w32_d256
      port (
         clk : in std_logic;
         srst: in std_logic;
         din : in std_logic_vector(31 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(31 downto 0);
         full : out std_logic;
         almost_full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   component double_sync is
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D     : in std_logic;
         Q     : out std_logic := '0';
         RESET : in std_logic;
         CLK   : in std_logic
         );
   end component;
   
   type init_fsm_type is (init_st1, init_st2, init_st3, init_st4, init_done_st, non_init_done_st);
   type sync_fsm_type is (wait_init_done_st, idle, active_data_dly_st, launch_sync_st);   
   
   signal init_fsm                  : init_fsm_type;
   
   signal aoi_sync_fsm              : sync_fsm_type;
   signal naoi_sync_fsm             : sync_fsm_type;  
   signal aoi_dly_cnt               : unsigned(7 downto 0);
   signal naoi_dly_cnt              : unsigned(7 downto 0); 
   signal sync_err_i                : std_logic;
   
   signal global_areset             : std_logic;
   signal sreset                    : std_logic;
   signal aoi_init_done             : std_logic;
   signal naoi_init_done            : std_logic;
   signal pix_count                 : unsigned(7 downto 0);
   
   signal aoi_fsync                 : std_logic;
   signal aoi_fsync_last            : std_logic;   
   signal aoi_fsync_edge_detected   : std_logic;
   signal din_dval_i                : std_logic;
   
   signal aoi_in_progress           : std_logic;  
   signal aoi_flag_fifo_dval        : std_logic;
   signal aoi_flag_fifo_dout        : std_logic_vector(31 downto 0);
   signal aoi_flag_fifo_din         : std_logic_vector(31 downto 0);
   signal aoi_flag_fifo_wr          : std_logic;
   signal aoi_flag_fifo_rd          : std_logic;
   signal aoi_flag_fifo_ovfl        : std_logic;                                    
   signal aoi_flag_fifo_rst         : std_logic;
   
   signal naoi_in_progress          : std_logic;  
   signal naoi_flag_fifo_dval       : std_logic;
   signal naoi_flag_fifo_dout       : std_logic_vector(31 downto 0);
   signal naoi_flag_fifo_din        : std_logic_vector(31 downto 0);
   signal naoi_flag_fifo_wr         : std_logic;
   signal naoi_flag_fifo_rd         : std_logic;
   signal naoi_flag_fifo_ovfl       : std_logic;                                    
   signal naoi_flag_fifo_rst        : std_logic;
   
   signal dout_o                    : std_logic_vector(FPA_DOUT'LENGTH-1 downto 0);
   signal dout_wr_en_o              : std_logic;
   

   signal err_i                     : std_logic_vector(ERR'LENGTH-1 downto 0);
   signal readout_info_o            : readout_info_type;
   signal naoi_start_sync                : std_logic; 
   signal naoi_start_sync_last           : std_logic;
   signal naoi_start_sync_edge_detected  : std_logic;
   
   
   --attribute dont_touch     : string;
   --attribute dont_touch of dout_dval_o         : signal is "true"; 
   --attribute dont_touch of dout_o              : signal is "true";
   --attribute dont_touch of samp_fifo_ovfl      : signal is "true";
   --attribute dont_touch of aoi_flag_fifo_ovfl      : signal is "true";
   
begin
   
   --------------------------------------------------
   -- Outputs map
   -------------------------------------------------- 
   FPA_DOUT_DVAL <= dout_wr_en_o; 
   FPA_DOUT <= dout_o; --
   ERR <= err_i;
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------
   U1: sync_reset
   port map(
      ARESET => global_areset,
      CLK    => CLK,
      SRESET => sreset
      ); 
   global_areset <= ARESET or DIAG_MODE_EN;   -- tout le module sera en reset tant qu'on est en mode diag    
   
   --------------------------------------------------
   -- quelques definitions
   -------------------------------------------------- 
   U2: process(CLK)
   begin
      if rising_edge(CLK) then          
         
         -- erreurs
         err_i(0) <= sync_err_i or sync_err_i; 
         err_i(1) <= aoi_flag_fifo_ovfl;         
         
         -- sync_flag 
         aoi_fsync <= FPA_DIN(57);
         aoi_fsync_last <= aoi_fsync;
         
         din_dval_i <= FPA_DIN_DVAL;     
         
         -- naoi_start
         naoi_start_sync <= FPA_DIN(58);
         naoi_start_sync_last <= naoi_start_sync;      
         
         -- front montant ou descendant
         if DEFINE_FPA_SYNC_FLAG_VALID_ON_FE then 
            aoi_fsync_edge_detected <= aoi_fsync_last and not aoi_fsync; 
            naoi_start_sync_edge_detected <= naoi_start_sync_last and not naoi_start_sync; 
         else
            aoi_fsync_edge_detected <= not aoi_fsync_last and aoi_fsync;
            naoi_start_sync_edge_detected <= not naoi_start_sync_last and naoi_start_sync; 
         end if;    
         
         -- 
      end if;
   end process;
   
   --------------------------------------------------
   -- Process d'initialisation
   --------------------------------------------------
   U3: process(CLK)
      variable incr :std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            init_fsm <= init_st1;
            aoi_init_done <= '0';
            naoi_init_done <= '0';
            aoi_flag_fifo_rst <= '1';
            naoi_flag_fifo_rst <= '1';
            -- pragma translate_off
            init_fsm <= init_done_st;
            -- pragma translate_on
            
         else              
            
            case init_fsm is         -- ENO: 23 juillet 2014. les etats init_st sont requis pour éviter des problèmes de synchro          
               
               when init_st1 =>      
                  pix_count <= (others => '0');
                  if aoi_fsync = '1' then  -- je vois un signal de synchro
                     init_fsm <= init_st2;
                  end if;                                                                       
               
               when init_st2 =>     
                  if aoi_fsync = '0' then  -- je ne vois plus le signal de synchro
                     init_fsm <= init_st3;
                  end if;  
               
               when init_st3 =>
                  if din_dval_i = '1' then      
                     pix_count <= pix_count + DEFINE_FPA_TAP_NUMBER;
                  end if;                                           
                  if pix_count >= 64 then   -- je vois au moins un nombre de pixels équivalent à la plus petite ligne d'image de TEL-2000. cela implique que le système en amont est actif. je m'en vais en idle et attend la prochaine synchro 
                     init_fsm <= init_done_st;     
                  end if;
               
               when init_done_st => 
                  if READOUT_INFO.AOI.READ_END = '1' then  -- je vois la tombée du fval d'une readout_info.aoi =>
                     aoi_init_done <= '1';
                     aoi_flag_fifo_rst <= '0';
                  end if;
                  if READOUT_INFO.NAOI.STOP = '1' and READOUT_INFO.AOI.DVAL = '1' then  -- je vois la fin d'une readout_info.naoi =>
                     naoi_init_done <= '1';
                     naoi_flag_fifo_rst <= '0';
                  end if;
                  
                  -- pragma translate_off                
                  aoi_init_done <= '1';
                  aoi_flag_fifo_rst <= '0';
                  naoi_init_done <= '1';
                  naoi_flag_fifo_rst <= '0';                  
                  -- pragma translate_on
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process; 
   
   ----------------------------------------------------------------
   -- AOI: contrôle du synchronisateur des données avec les flags 
   ----------------------------------------------------------------
   Uaoi1: process(CLK)
      variable incr :std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then          
            aoi_sync_fsm <= wait_init_done_st;
            sync_err_i <= '0';
            aoi_in_progress <= '0';
            
         else        
            
            if readout_info_o.aoi.eof = '1' and FPA_DIN_DVAL = '1' then -- FPA_DIN_DVAL assure qu'effectivement eol est lu
               aoi_in_progress <= '0';
            end if;
            
            case aoi_sync_fsm is        
               
               when wait_init_done_st =>  -- si l'on quitte cet état, c'est que la fsm précédente assure que les deux flows seront synchronisables
                  if aoi_init_done = '1' then
                     aoi_sync_fsm <= idle;                     
                  end if;                   
               
               when idle =>               -- en idle, on sort les données non AOI
                  aoi_dly_cnt <= (others => '0');                  
                  if aoi_fsync_edge_detected = '1' then
                     aoi_sync_fsm <= active_data_dly_st;
                  end if; 
               
               when active_data_dly_st =>  -- delai en nombre de samples avant d'aller chercher les pixels d'une trame
                  incr := '0'& FPA_DIN_DVAL;
                  aoi_dly_cnt <= aoi_dly_cnt + to_integer(unsigned(incr));                 
                  if aoi_dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then -- REAL_MODE_ACTIVE_PIXEL_DLY est configurable via microblaze
                     aoi_sync_fsm <= launch_sync_st;                     
                  end if;                    
               
               when launch_sync_st =>     -- 
                  aoi_in_progress <= '1';
                  sync_err_i <= not aoi_flag_fifo_dval; -- erreur grave! pendant la sortie d'une trame AOI, il manquait des données Flag. Problème de débit 
                  if FPA_DIN_DVAL = '1' then        -- on est certain ainsi que aoi_flag_fifo_rd a été activé
                     aoi_sync_fsm <= idle;          
                  end if;                   
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   ------------------------------------------------
   -- AOI: Gestionnaire des Flags
   ------------------------------------------------
   aoi_flag_fifo_rd <= aoi_in_progress and FPA_DIN_DVAL;
   
   -- aoi fag fifo mapping      
   Uaoi2 : fwft_sfifo_w32_d256
   port map (
      clk         => CLK,
      srst        => aoi_flag_fifo_rst,
      din         => aoi_flag_fifo_din,
      wr_en       => aoi_flag_fifo_wr,
      rd_en       => aoi_flag_fifo_rd,
      dout        => aoi_flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => aoi_flag_fifo_ovfl,
      empty       => open,
      valid       => aoi_flag_fifo_dval
      );
   
   -- AOi flag fifo write
   Uaoi3 : process(CLK)
   begin
      if rising_edge(CLK) then         
         aoi_flag_fifo_din(21 downto 0) <= READOUT_INFO.AOI.SPARE & READOUT_INFO.AOI.SOF & READOUT_INFO.AOI.EOF & READOUT_INFO.AOI.SOL & READOUT_INFO.AOI.EOL & READOUT_INFO.AOI.FVAL & READOUT_INFO.AOI.LVAL & READOUT_INFO.AOI.DVAL;  -- read_end n'est plus ecrit dans les fifos
         aoi_flag_fifo_wr <= READOUT_INFO.AOI.SAMP_PULSE and aoi_init_done; -- remarquer qu'on ecrit meme les samples d'interligne! S'il y en a. Cela marchera si l'on ne fait pas de l'overclocking sur les interlignes. Si tel doit être le cas, alors mieux vaut utiliser le lsync_mode.       
      end if;
   end process;        
   
   
   
   ----------------------------------------------------------------
   -- NON AOI: contrôle du synchronisateur des données avec les flags 
   ----------------------------------------------------------------
   Unaoi1: process(CLK)
      variable incr :std_logic_vector(1 downto 0);
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then          
            naoi_sync_fsm <= wait_init_done_st;
            naoi_in_progress <= '0';
            
         else        
            
            if readout_info_o.naoi.stop = '1' and FPA_DIN_DVAL = '1' then -- FPA_DIN_DVAL assure qu'effectivement eol est lu
               naoi_in_progress <= '0';
            end if;
            
            case naoi_sync_fsm is        
               
               when wait_init_done_st =>  -- si l'on quitte cet état, c'est que la fsm précédente assure que les deux flows seront synchronisables
                  if naoi_init_done = '1' then
                     naoi_sync_fsm <= idle;                     
                  end if;                   
               
               when idle =>               -- en idle, on sort les données non AOI
                  naoi_dly_cnt <= (others => '0');                  
                  if naoi_start_sync_edge_detected = '1' then
                     naoi_sync_fsm <= active_data_dly_st;
                  end if; 
               
               when active_data_dly_st =>  -- delai en nombre de samples avant d'aller chercher les pixels d'une ligne
                  incr := '0'& FPA_DIN_DVAL;
                  naoi_dly_cnt <= naoi_dly_cnt + to_integer(unsigned(incr));                 
                  if naoi_dly_cnt >= to_integer(FPA_INTF_CFG.REAL_MODE_ACTIVE_PIXEL_DLY) then -- REAL_MODE_ACTIVE_PIXEL_DLY est configurable via microblaze -- rigoureusement le même delai qu,en AOI pour conserver le mpeme chronogramme
                     naoi_sync_fsm <= launch_sync_st;                     
                  end if;                    
               
               when launch_sync_st =>     -- 
                  naoi_in_progress <= '1';
                  if FPA_DIN_DVAL = '1' then        -- on est certain ainsi que aoi_flag_fifo_rd a été activé
                     naoi_sync_fsm <= idle;          
                  end if;                   
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   ------------------------------------------------
   -- NON_ AOI: Gestionnaire des Flags
   ------------------------------------------------
   naoi_flag_fifo_rd <= FPA_DIN_DVAL and naoi_in_progress;
   
   -- naoi fag fifo mapping      
   Unaoi2 : fwft_sfifo_w32_d256
   port map (
      clk         => CLK,
      srst        => naoi_flag_fifo_rst,
      din         => naoi_flag_fifo_din,
      wr_en       => naoi_flag_fifo_wr,
      rd_en       => naoi_flag_fifo_rd,
      dout        => naoi_flag_fifo_dout,
      full        => open,
      almost_full => open,
      overflow    => naoi_flag_fifo_ovfl,
      empty       => open,
      valid       => naoi_flag_fifo_dval
      );
   
   -- naoi flag fifo write
   Unaoi3 : process(CLK)
   begin
      if rising_edge(CLK) then         
         naoi_flag_fifo_din(17 downto 0) <= READOUT_INFO.NAOI.SPARE & READOUT_INFO.NAOI.DVAL & READOUT_INFO.NAOI.STOP & READOUT_INFO.NAOI.START;
         naoi_flag_fifo_wr <= READOUT_INFO.NAOI.SAMP_PULSE and READOUT_INFO.NAOI.DVAL and naoi_init_done;    
      end if;
   end process; 
   
   ---------------------------------------------------------------------
   -- FLAG FIFO OUT                                                
   ---------------------------------------------------------------------
   readout_info_o.aoi.spare      <= aoi_flag_fifo_dout(21 downto 7);
   readout_info_o.aoi.sof        <= aoi_flag_fifo_dout(6);
   readout_info_o.aoi.eof        <= aoi_flag_fifo_dout(5);
   readout_info_o.aoi.sol        <= aoi_flag_fifo_dout(4);
   readout_info_o.aoi.eol        <= aoi_flag_fifo_dout(3);
   readout_info_o.aoi.fval       <= aoi_flag_fifo_dout(2);
   readout_info_o.aoi.lval       <= aoi_flag_fifo_dout(1);
   readout_info_o.aoi.dval       <= aoi_flag_fifo_dout(0);
   
   -- non_aoi flag fifo out 
   readout_info_o.naoi.spare     <= naoi_flag_fifo_dout(17 downto 3); 
   readout_info_o.naoi.dval      <= naoi_flag_fifo_dout(2);
   readout_info_o.naoi.stop      <= naoi_flag_fifo_dout(1);
   readout_info_o.naoi.start     <= naoi_flag_fifo_dout(0);
   
   --------------------------------------------------
   -- synchronisateur des données sortantes
   --------------------------------------------------
   U4: process(CLK)
   begin
      if rising_edge(CLK) then         
         if sreset = '1' then      -- tant qu'on est en mode diag, la fsm est en reset.      
            dout_wr_en_o <= '0';
            
         else      
            
            -- ecriture des données en aval
            dout_wr_en_o <= aoi_init_done and naoi_init_done and FPA_DIN_DVAL; -- les données sortent tout le temps. les flags permettront de distinguer le AOI du NAOI 
            
            -- données écrite en aval
            if DEFINE_FPA_VIDEO_DATA_INVERTED = '1' then 
               dout_o(55 downto 0) <= not FPA_DIN(55 downto 0);
            else
               dout_o(55 downto 0) <= FPA_DIN(55 downto 0);   
            end if;            
            
            -- zone AOI
            dout_o(56)           <= readout_info_o.aoi.sol and aoi_in_progress;                       -- aoi_sol
            dout_o(57)           <= readout_info_o.aoi.eol and aoi_in_progress;                       -- aoi_eol
            dout_o(58)           <= readout_info_o.aoi.fval and aoi_flag_fifo_dval;                   -- aoi_fval 
            dout_o(59)           <= readout_info_o.aoi.sof and aoi_in_progress;                       -- aoi_sof
            dout_o(60)           <= readout_info_o.aoi.eof and aoi_in_progress;                       -- aoi_eof            
            dout_o(61)           <= readout_info_o.aoi.dval and aoi_in_progress and FPA_DIN_DVAL;     -- aoi_dval    (nouvel ajout)
            dout_o(76 downto 62) <= readout_info_o.aoi.spare;                                         -- aoi_spares  (nouvel ajout)
            
            -- Zone NON AOI
            dout_o(77)           <= readout_info_o.aoi.dval and naoi_in_progress and FPA_DIN_DVAL;    -- naoi_dval    
            dout_o(78)           <= readout_info_o.naoi.start and naoi_in_progress;                   -- naoi_start 
            dout_o(79)           <= readout_info_o.naoi.stop and naoi_in_progress;                    -- naoi_stop            
            dout_o(94 downto 80) <= readout_info_o.naoi.spare;                                        -- naoi_spares
            
            -- non utilisé                                                                            -- non utilisé
            dout_o(95)          <= '0'; 
            
         end if;
      end if;
   end process;
   
end rtl;

