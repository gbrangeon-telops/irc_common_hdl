------------------------------------------------------------------
--!   @file : afpa_hw_driver_ctrler
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.fpa_define.all;
use work.proxy_define.all;
use work.fleg_brd_define.all;

entity afpa_hw_driver_ctrler is
   port(                                         
      -- 
      ARESET           : in std_logic;
      CLK              : in std_logic;
      
      -- interfaçage avec le contrôleur principal
      DIAG_MODE_ONLY   : in std_logic;
      HW_DRIVER_EN     : in std_logic; 
      HW_RQST          : out std_logic;
      HW_DONE          : out std_logic;
      
      -- allumage détecteur
      FPA_POWER        : in std_logic;
      FPA_PWR          : out std_logic;
      FPA_POWERED      : in std_logic;
      
      -- allumage DAC
      DAC_POWERED      : in std_logic;
      
      -- programmateur du détecteur
      PROG_RQST        : in std_logic;
      PROG_EN          : out std_logic;
      PROG_DONE        : in std_logic;
      PROG_INIT_DONE   : out std_logic;
      
      -- post prog détecteur
      READOUT          : in std_logic;
      PROG_TRIG        : out std_logic; 
      
      -- programmateur du dac
      DAC_RQST         : in std_logic;
      DAC_EN           : out std_logic;
      DAC_DONE         : in std_logic;
      
      -- statut
      ACQ_IN_PROGRESS    : in std_logic; 
      HW_CFG_IN_PROGRESS : out std_logic;
      FPA_PROG_MODE      : out std_logic; -- à '1' si le FPA va être en programmation et revient à '0' lorsque terminé
      DAC_PROG_MODE      : out std_logic; -- à '1' si le DAC va être en programmation et revient à '0' lorsque terminé
      
      -- configs
      USER_CFG         : in fpa_intf_cfg_type;
      FPA_INTF_CFG     : out fpa_intf_cfg_type
      
      );
end afpa_hw_driver_ctrler;


architecture rtl of afpa_hw_driver_ctrler is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
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
   
   type hw_seq_fsm_type is (idle, diag_mode_only_st, wait_client_run_st, forward_rqst_st, check_rqst_st, wait_client_done_st, pause_st);
   type dac_ctrl_fsm_type is (idle, dac_prog_st, wait_dac_end_st, dac_pause_st, dac_another_rqst_st, pause_st);
   type prog_ctrl_fsm_type is (idle, check_first_prog_st, fpa_prog_st, wait_prog_end_st, prog_img_start_st, prog_img_end_st, check_prog_mode_end_st, check_fpa_prog_done_st);
   
   signal hw_seq_fsm                : hw_seq_fsm_type;
   signal dac_ctrl_fsm              : dac_ctrl_fsm_type;
   signal prog_ctrl_fsm              : prog_ctrl_fsm_type;
   signal fpa_powered_i             : std_logic;
   signal sreset                    : std_logic;
   signal prog_trig_i               : std_logic;
   signal dac_powered_i             : std_logic;
   signal dac_en_i                  : std_logic;
   signal prog_en_i                 : std_logic;
   signal pause_cnt                 : unsigned(7 downto 0);
   signal hw_rqst_i                 : std_logic;
   signal hw_done_i                 : std_logic;
   signal valid_prog_rqst           : std_logic;
   signal valid_dac_rqst            : std_logic;
   signal valid_rqst_pending        : std_logic;
   signal readout_i                 : std_logic;
   signal diag_mode_only_i          : std_logic;
   signal img_cnt                   : unsigned(3 downto 0);
   signal vdac_value                : fleg_vdac_value_type;
   signal post_update_img           : std_logic;
   signal fpa_intf_cfg_i            : fpa_intf_cfg_type;
   signal fpa_first_cfg_done        : std_logic;
   signal update_whole_cfg          : std_logic;
   signal run_dac_prog_client       : std_logic;
   signal run_fpa_prog_client       : std_logic;
   signal dac_client_done           : std_logic;
   signal fpa_client_done           : std_logic;
   signal client_done               : std_logic;
   signal update_dac_part_temp      : std_logic;
   signal update_dac_part_only      : std_logic;
   signal update_fpa_part_temp      : std_logic;
   signal update_fpa_part_only      : std_logic;
   signal update_dac_cfg            : std_logic;
   signal update_fpa_cfg            : std_logic;
   signal prog_init_done_i          : std_logic;
   signal first_prog_done           : std_logic;
   signal hw_cfg_in_progress_i      : std_logic;
   signal wait_cnt                  : unsigned(7 downto 0);
   signal fpa_intf_cfg_up2date      : std_logic;
   signal acq_in_progress_i         : std_logic;
   signal hw_driver_en_i            : std_logic;
   signal fpa_prog_mode_i           : std_logic;
   signal dac_prog_mode_i           : std_logic;
   
   --   attribute KEEP : string;
   --   attribute KEEP of readout_i : signal is "TRUE";
   --   attribute KEEP of update_fpa_part_only : signal is "TRUE";
   --   attribute KEEP of update_fpa_cfg : signal is "TRUE";
   --   attribute KEEP of prog_ctrl_fsm : signal is "TRUE";
   --   attribute KEEP of hw_seq_fsm : signal is "TRUE";
   --   attribute KEEP of valid_prog_rqst : signal is "TRUE";
   --   attribute KEEP of fpa_client_done : signal is "TRUE";
   --   attribute KEEP of fpa_intf_cfg_up2date : signal is "TRUE";
   --   attribute KEEP of run_fpa_prog_client : signal is "TRUE";
   --   attribute KEEP of fpa_first_cfg_done : signal is "TRUE";
   
begin
   
   FPA_INTF_CFG <= fpa_intf_cfg_i;
   PROG_TRIG <= prog_trig_i;
   PROG_EN <= prog_en_i;
   DAC_EN <= dac_en_i;
   HW_RQST <= hw_rqst_i;
   HW_DONE <= hw_done_i;
   PROG_INIT_DONE <= prog_init_done_i;
   HW_CFG_IN_PROGRESS <= hw_cfg_in_progress_i;
   FPA_PROG_MODE <= fpa_prog_mode_i;
   DAC_PROG_MODE <= dac_prog_mode_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1A : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   --------------------------------------------------
   -- double sync 
   --------------------------------------------------   
   U1B: double_sync generic map(INIT_VALUE => '0') port map (RESET => sreset, D => READOUT, CLK => CLK, Q => readout_i);
   U1C: double_sync generic map(INIT_VALUE => '0') port map (RESET => sreset, D => ACQ_IN_PROGRESS, CLK => CLK, Q => acq_in_progress_i);
   U1D: double_sync generic map(INIT_VALUE => '0') port map (RESET => sreset, D => DIAG_MODE_ONLY, CLK => CLK, Q => diag_mode_only_i);
   U1E: double_sync generic map(INIT_VALUE => '0') port map (RESET => sreset, D => HW_DRIVER_EN, CLK => CLK, Q => hw_driver_en_i);
   
   --------------------------------------------------
   --  Allumage du détecteur et dacs
   --------------------------------------------------
   -- doit être dans un process indépendant et sans fsm 
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then 
         FPA_PWR <= FPA_POWER and not sreset; 
         fpa_powered_i <= FPA_POWERED and not sreset;
         dac_powered_i <= DAC_POWERED and not sreset; -- pour signifier que le fleg est allumé et les dacs sont à programmer pour la premiere fois.
      end if;
   end process; 
   
   --------------------------------------------------
   --  attribution des priorités
   --------------------------------------------------
   U3: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            hw_seq_fsm <=  idle;
            hw_done_i <= '0';
            valid_prog_rqst <= '0';
            valid_dac_rqst <= '0';
            valid_rqst_pending <= '0';
            update_whole_cfg <= '0';
            run_dac_prog_client <= '0';
            run_fpa_prog_client <= '0';
            first_prog_done <= '0';
            prog_init_done_i <= '0';
            hw_cfg_in_progress_i <= '0';
            hw_rqst_i <= '0';
            fpa_prog_mode_i <= '1';
            dac_prog_mode_i <= '1';
            
         else                            
            
            valid_prog_rqst <= PROG_RQST and fpa_powered_i and dac_powered_i;  -- il faut absoluement dac_powered_i.
            valid_dac_rqst <= DAC_RQST and dac_powered_i;
            valid_rqst_pending <= valid_dac_rqst or valid_prog_rqst; 
            
            client_done <= dac_client_done and fpa_client_done;
            
            --fsm de contrôle            
            case  hw_seq_fsm is
               
               -- attente d'une demande
               when idle =>      
                  hw_done_i <= '1';                    
                  hw_rqst_i <= '0';
                  hw_cfg_in_progress_i <= '0';
                  post_update_img <= '0';
                  update_whole_cfg <= '0';
                  prog_init_done_i <= first_prog_done;    -- Par principe pour le scorpiomwA, la premiere config est celle d'initialisation.
                  wait_cnt <= (others => '0');
                  fpa_prog_mode_i <= not fpa_first_cfg_done;
                  dac_prog_mode_i <= '0';                  
                  if diag_mode_only_i = '1' then
                     hw_seq_fsm <= diag_mode_only_st;
                  elsif valid_prog_rqst = '1' then
                     fpa_prog_mode_i <= '1';
                     hw_seq_fsm <= forward_rqst_st;
                  elsif valid_dac_rqst = '1' then
                     dac_prog_mode_i <= '1';
                     if prog_init_done_i = '0' then       -- on fait ceci juste pour être compatible avec l'existant. Sinon, le dac n'a pas besoin de cela. Il peut être tout le temps programmé à la volée, sans blocage des trigs d'integration
                        hw_seq_fsm <= forward_rqst_st; 
                     else                                 -- programmation sans interruption des trigs d'integration
                        hw_seq_fsm <= check_rqst_st; 
                     end if;
                  end if;
                  
               -- diag mode only
               when diag_mode_only_st =>
                  update_whole_cfg <= '1';
                  if diag_mode_only_i = '0' then
                     hw_seq_fsm <= idle;
                  end if;                  
                  
               -- demande envoyée au contrôleur principal
               when forward_rqst_st =>
                  hw_rqst_i <= '1';                                 -- fpa_rqst est le signal de demande d'autorisation au contrôleur principal.
                  hw_cfg_in_progress_i <= '1';
                  if hw_driver_en_i = '1' then                      -- suppose que le trig_controller est arrêté par le contrôleur principal
                     hw_seq_fsm <= check_rqst_st;
                  end if;
                  
               -- quel client fait la demande et le lancer
               when check_rqst_st => 
                  hw_done_i <= '0';
                  hw_rqst_i <= '0';
                  if valid_dac_rqst = '1' then
                     run_dac_prog_client <= '1';
                     hw_seq_fsm <= wait_client_run_st;
                  elsif valid_prog_rqst = '1' then              
                     run_fpa_prog_client <= '1';
                     first_prog_done <= '1';    -- la premiere config
                     hw_seq_fsm <= wait_client_run_st;
                  else 
                     hw_seq_fsm <= pause_st;                     -- aller en pause et non en idle permet de faire durer hw_done_i d'au moins 2 clk en l'état '0'
                  end if;
                  
               -- valider que le client soit lancé
               when  wait_client_run_st =>  
                  if client_done = '0' then                  
                     run_dac_prog_client  <= '0';
                     run_fpa_prog_client <= '0';
                     hw_seq_fsm <= wait_client_done_st;
                  end if;                  
                  
               -- attendre que le client ait terminé 
               when wait_client_done_st =>    
                  if client_done = '1' and fpa_intf_cfg_up2date = '1' then          
                     hw_seq_fsm <= pause_st; 
                  end if;
                  
               -- pause 
               when pause_st =>
                  wait_cnt <= wait_cnt + 1;
                  if wait_cnt(4) = '1' then
                     hw_seq_fsm <= idle; -- pour donner le temps que le signal valid_rqst_pending tombe après mise à jour de la config
                  end if;
               
               when others =>
               
            end case;
            
            -- pragma translate_off
            --prog_init_done_i <= '1';
            -- pragma translate_on
            
         end if;
      end if;   
   end process;
   
   --------------------------------------------------
   --  mise à jour de la config
   --------------------------------------------------
   Uc: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            fpa_intf_cfg_i <= USER_CFG;   -- ENO 25 juillet 2017: fpa_intf_cfg_i <= USER_CFG implique que dans mb_intf.vhd, tant qu'aucune config n'est reçue, MB_RESET ou CTRLED_RESET soit à '1'. S'inspirer de fastrd_mb_intf.vhd
            update_dac_part_temp <= '0';
            update_dac_part_only <= '0';
            update_fpa_part_temp <= '0';
            update_fpa_part_only <= '0';
            fpa_intf_cfg_up2date <= '0';
            
         else 
            
            update_dac_part_temp <= update_dac_cfg or update_whole_cfg;
            update_dac_part_only <= update_dac_part_temp;
            
            update_fpa_part_temp <= update_fpa_cfg or update_whole_cfg; 
            update_fpa_part_only <= update_fpa_part_temp;
            
            -- sauvegarde de la partie dac 
            if update_fpa_part_temp = '1' then  
               vdac_value <= fpa_intf_cfg_i.vdac_value;
            end if;            
            
            if run_dac_prog_client = '1' or run_fpa_prog_client = '1' then 
               fpa_intf_cfg_up2date <= '0';
            end if;
            
            ----------------------------------------------------------------
            -- mise à jour de la partie fpa suite à une reprog
            ----------------------------------------------------------------
            if update_fpa_part_only = '1' and readout_i = '0' then    -- ENO 14 mai 2019: necessaire pour eviter qu'une cfg sortante ne fourre tout le readout en cours
               fpa_intf_cfg_i <= USER_CFG;
               fpa_intf_cfg_i.vdac_value <= vdac_value; -- restitution de la partie Dac
               fpa_intf_cfg_up2date <= '1';
            end if;
            
            ---------------------------------------------------------------
            -- mise à jour de la partie dac suite à une reprog             
            ---------------------------------------------------------------
            if update_dac_part_only = '1' then 
               fpa_intf_cfg_i.vdac_value <= USER_CFG.VDAC_VALUE;
               fpa_intf_cfg_up2date <= '1';
            end if;
            -----------------------------------------------------------------
            --
            -----------------------------------------------------------------
            
            -- ENO : 24 janv 2016: mis ici pour une simulation correcte
            -- mise à jour de la partie int_time de la cfg : le module du temps d'integration a un latch qui est synchrone avec le frame, donc pas de pb.
            fpa_intf_cfg_i.int_time  <= USER_CFG.INT_TIME;
            fpa_intf_cfg_i.int_indx  <= USER_CFG.INT_INDX;
            fpa_intf_cfg_i.int_signal_high_time <= USER_CFG.INT_SIGNAL_HIGH_TIME;
            
            -- ENO : 25 janv 2016: mis ici pour un fonctionnement correct. Sinon, sans reprogrammation du dtecteur, la partie common est figée
            if acq_in_progress_i = '0' then  -- ENO 14 juin 2022: il ne reste que acq_in_progress_i comme condition car cfg.comn ne touche que principalemnt le trig control 
               fpa_intf_cfg_i.comn <= USER_CFG.COMN;
            end if;
            
            -------------------------------------
            -- ENO: 8 juillet 2018
            ------------------------------------
            -- la mise à jour temps reel de certains champs de fpa_intf_cfg_i n'est plus recommandee 
            -- car cela peut conduire à des bugs comme ce qui est vu sur ISC0804 qui ne semble pas se programmer correctement au demarrage.
            -- On peut introduire cfg_num pour que cette mise à jour se fasse via un stop/start comme ce fut le cas de ISC0804 
            -- certes le detecteur se programmera à chaque nouvelle config reçue du MB mais il a été conçu pour cela.
            
         end if;
      end if;   
   end process; 
   
   --------------------------------------------------
   --  FSM pour programmation DAC
   --------------------------------------------------
   U4A: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            dac_ctrl_fsm <=  idle;
            dac_en_i <= '0';
            dac_client_done <= '0';
            update_dac_cfg <= '0';
            
         else      
            
            -- fsm dac           
            case  dac_ctrl_fsm is     
               
               -- idle
               when idle =>
                  dac_en_i <= '0';
                  dac_client_done <= '1';
                  update_dac_cfg <= '0';
                  if run_dac_prog_client = '1' then
                     dac_ctrl_fsm <= dac_prog_st;
                  end if;
                  
               -- on lance la programmation des dacs
               when dac_prog_st =>
                  dac_client_done <= '0';
                  dac_en_i <= '1';
                  if DAC_DONE = '0' then
                     dac_ctrl_fsm <= wait_dac_end_st;
                  end if;
                  
               -- attente de la fin de transaction pour le dac
               when  wait_dac_end_st =>     
                  dac_en_i <= '0';
                  pause_cnt <= (others => '0');                  
                  if DAC_DONE = '1' then
                     dac_ctrl_fsm <= dac_pause_st;
                  end if;             
                  
               -- on donne le temps pour voir si une autre demande du dac suit
               when  dac_pause_st =>
                  pause_cnt <= pause_cnt + 1;
                  if pause_cnt > 63 then   -- largement le temps qu'une autre demande du DAC soit placée. Ainsi, on s'assure que toutes les  tensions sont programmées avant de donner la main au programmateur du détecteur
                     dac_ctrl_fsm <= dac_another_rqst_st;
                  end if;
                  
               -- on regarde si une autre demande du dac est placée
               when dac_another_rqst_st =>                  
                  if valid_dac_rqst = '1' then  
                     dac_ctrl_fsm <= dac_prog_st;
                  else               
                     dac_ctrl_fsm <= pause_st;
                     update_dac_cfg <= '1';
                  end if;   
                  
               -- pause pour lancer dac cfg update
               when  pause_st => 
                  dac_ctrl_fsm <= idle;                 
               
               when others =>
               
            end case;
            
         end if;
      end if;   
   end process;
   
   -------------------------------------------------
   -- accès accordé au programmateur du détecteur      
   -------------------------------------------------
   U4B: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            prog_ctrl_fsm <=  idle;
            prog_en_i <= '0';
            fpa_client_done <= '0';
            fpa_first_cfg_done <= '0';
            prog_trig_i <= '0';
            update_fpa_cfg <= '0';
            
         else      
            
            -- fsm prog fpa roic           
            case  prog_ctrl_fsm is 
               
               -- idle
               when idle =>   
                  img_cnt <= (others => '0');
                  prog_en_i <= '0';
                  fpa_client_done <= '1';
                  update_fpa_cfg <= '0';
                  if run_fpa_prog_client = '1' then
                     prog_ctrl_fsm <= check_first_prog_st;
                  end if;               
                  
               -- voir si c'est la 1ere programmation post-allumage
               when check_first_prog_st =>
                  fpa_client_done <= '0';
                  if fpa_first_cfg_done = '0' then                  
                     prog_ctrl_fsm <= fpa_prog_st;
                  else   
                     prog_ctrl_fsm <= prog_img_start_st;               -- ENO : 26 janv 2016: pour le Hawk, on doit au moins prendre une image avec int_time = 0.2usec avant de le programer. C'est tres utile surtout pour eviter de la saturation en windowing. Cette modif ne derangera pas les autres détecteurs 
                  end if;
                  
               -- programmer le détecteur
               when  fpa_prog_st =>                  
                  prog_en_i <= not readout_i;                   
                  if PROG_DONE = '0' then
                     prog_ctrl_fsm <= wait_prog_end_st;
                  end if; 
                  
               -- attente de la fin de programmation
               when  wait_prog_end_st =>     
                  prog_en_i <= '0';                  
                  if PROG_DONE = '1' then
                     prog_ctrl_fsm <= prog_img_start_st;
                     update_fpa_cfg <= '1';       -- ainsi les images prost trig seront traitées avec la nouvelle config et donc le bon nombre de coups d'horloge pour le HAwk
                  end if;                         -- de plus, -- ENO 24 janv 2016: même après la sortie de la config, on prend pareille des images post prog pour que le module readout_ctrler puisse generer le bon nombre de coups de clocks requis pour la config dans le detecteur et assurer convenablement les resets des detecteurs comme le Hawk
                  
               -- prise des images en mode prog_trig (le temps d'integration utilisé est defini dans le fpa_define). Pour un Hawk, il est de 0.2 usec pour eviter des problemes de saturation en windowing
               when prog_img_start_st =>        
                  prog_trig_i <= not readout_i;         -- ENO 29 janv 2020:  not readout_i permet d'accommoder IWR aussi.
                  if readout_i = '1' then
                     prog_ctrl_fsm <= prog_img_end_st;
                     prog_trig_i <= '0';                -- ENO 18 mars 2016: absolument necessaire ici pour éviter des bugs.
                  end if;                  
                  
               -- fin d'une image prog_trig
               when prog_img_end_st =>                 
                  fpa_first_cfg_done <= '1';
                  if readout_i = '0' then
                     update_fpa_cfg <= '0';              -- ENO 14 mai 2019: absolument necessaire ici pour être certain que la cfg est mise à jour.
                     img_cnt <= img_cnt + 1;
                     prog_ctrl_fsm <= check_prog_mode_end_st;
                  end if;
                  
               -- fin de la serie d'images prog_trig
               when check_prog_mode_end_st =>                  
                  if img_cnt = DEFINE_FPA_XTRA_IMAGE_NUM_TO_SKIP then 
                     prog_ctrl_fsm <= check_fpa_prog_done_st;
                  else
                     prog_ctrl_fsm <= prog_img_start_st;
                  end if;               
                  
               -- voir si la demande de programmation est traitée   
               when check_fpa_prog_done_st =>               
                  img_cnt <= (others => '0');
                  if valid_prog_rqst = '1' then               -- si au terme de la prise d'images prog_trig, il y a une requete de programmation, alors c'est qu'elle n'avait pas été traitée. Donc on la traite
                     prog_ctrl_fsm <= fpa_prog_st;
                  else
                     prog_ctrl_fsm <= idle;             
                  end if; 
               
               when others =>
               
            end case;
            
         end if;
      end if;   
   end process;
   
end rtl;
