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
use work.fleg_brd_define.all;

entity afpa_hw_driver_ctrler is
   port(                                         
      -- 
      ARESET           : in std_logic;
      CLK              : in std_logic;
      
      -- interfa�age avec le contr�leur principal
      DIAG_MODE_ONLY   : in std_logic;
      HW_DRIVER_EN     : in std_logic; 
      HW_RQST          : out std_logic;
      HW_DONE          : out std_logic;
      
      -- allumage d�tecteur
      FPA_POWER        : in std_logic;
      FPA_PWR          : out std_logic;
      FPA_POWERED      : in std_logic;
      
      -- allumage DAC
      DAC_POWERED      : in std_logic;
      
      -- programmateur du d�tecteur
      PROG_RQST        : in std_logic;
      PROG_EN          : out std_logic;
      PROG_DONE        : in std_logic;
      
      -- post prog d�tecteur
      READOUT          : in std_logic;
      PROG_TRIG        : out std_logic; 
      
      -- programmateur du dac
      DAC_RQST         : in std_logic;
      DAC_EN           : out std_logic;
      DAC_DONE         : in std_logic;
      
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
   
begin
   
   FPA_INTF_CFG <= fpa_intf_cfg_i;
   PROG_TRIG <= prog_trig_i;
   PROG_EN <= prog_en_i;
   DAC_EN <= dac_en_i;
   HW_RQST <= hw_rqst_i;
   HW_DONE <= hw_done_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   --------------------------------------------------
   --  Allumage du d�tecteur et dacs
   --------------------------------------------------
   -- doit �tre dans un process ind�pendant et sans fsm 
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then 
         FPA_PWR <= FPA_POWER and not sreset; 
         fpa_powered_i <= FPA_POWERED and not sreset;
         dac_powered_i <= DAC_POWERED and not sreset; -- pour signifier que le fleg est allum� et les dacs sont � programmer pour la premiere fois.
      end if;
   end process; 
   
   --------------------------------------------------
   --  attribution des priorit�s
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
            
         else                   
            
            -- misc
            readout_i <= READOUT;           
            
            valid_prog_rqst <= PROG_RQST and fpa_powered_i and dac_powered_i;  -- il faut absoluement dac_powered_i.
            valid_dac_rqst <= DAC_RQST and dac_powered_i;
            valid_rqst_pending <= valid_dac_rqst or valid_prog_rqst; 
            
            client_done <= dac_client_done and fpa_client_done;
            
            --fsm de contr�le            
            case  hw_seq_fsm is
               
               -- attente d'une demande
               when idle =>      
                  hw_done_i <= '1';                    
                  hw_rqst_i <= '0';
                  post_update_img <= '0';
                  update_whole_cfg <= '0';
                  if DIAG_MODE_ONLY = '1' then
                     hw_seq_fsm <= diag_mode_only_st;
                  elsif valid_rqst_pending = '1' then 
                     hw_seq_fsm <= forward_rqst_st;
                  end if;
                  
               -- diag mode only
               when diag_mode_only_st =>
                  update_whole_cfg <= '1';
                  if DIAG_MODE_ONLY = '0' then
                     hw_seq_fsm <= idle;
                  end if;                  
                  
               -- demande envoy�e au contr�leur principal
               when forward_rqst_st =>
                  hw_rqst_i <= '1';                                 -- fpa_rqst est le signal de demande d'autorisation au contr�leur principal. 
                  if HW_DRIVER_EN = '1' then                        -- suppose que le trig_controller est arr�t� par le contr�leur principal
                     hw_seq_fsm <= check_rqst_st;
                  end if;
                  
               -- quel client fait la demande et le lancer
               when check_rqst_st => 
                  hw_done_i <= '0';
                  hw_rqst_i <= '0';
                  hw_seq_fsm <= wait_client_run_st;
                  if valid_dac_rqst = '1' then
                     run_dac_prog_client <= '1';
                  else                                   -- si on arrive ici c'est que valid_rqst_pending = '1' et que  valid_dac_rqst = '0' => valid_prog_rqst = '1';
                     run_fpa_prog_client <= '1';
                  end if;
                  
               -- valider que le client soit lanc�
               when  wait_client_run_st =>  
                  if client_done = '0' then                  
                     run_dac_prog_client  <= '0';
                     run_fpa_prog_client <= '0';
                  end if;
                  hw_seq_fsm <= wait_client_done_st;
                  
               -- attendre que le client ait termin� 
               when wait_client_done_st =>    
                  if client_done = '1' then          
                     hw_seq_fsm <= pause_st; 
                  end if;
                  
               -- pause 
               when pause_st =>
                  hw_seq_fsm <= idle; -- pour donner le temps que le signal valid_rqst_pending tombe apr�s mise � jour de la config
               
               when others =>
               
            end case;
            
         end if;
      end if;   
   end process; 
   
   
   --------------------------------------------------
   --  mise � jour de la config
   --------------------------------------------------
   Uc: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            fpa_intf_cfg_i <= FPA_INTF_CFG_DEFAULT;
            update_dac_part_temp <= '0';
            update_dac_part_only <= '0';
            update_fpa_part_temp <= '0';
            update_fpa_part_only <= '0';
            
         else 
            
            update_dac_part_temp <= update_dac_cfg or update_whole_cfg;
            update_dac_part_only <= update_dac_part_temp;
            
            update_fpa_part_temp <= update_fpa_cfg or update_whole_cfg; 
            update_fpa_part_only <= update_fpa_part_temp;
            
            -- sauvegarde de la partie dac 
            if update_fpa_part_temp = '1' then  
               vdac_value <= fpa_intf_cfg_i.vdac_value;
            end if;
            
            -- mise � jour de la partie fpa
            if update_fpa_part_only = '1' then 
               fpa_intf_cfg_i <= USER_CFG;
               fpa_intf_cfg_i.vdac_value <= vdac_value; -- restitution de la partie Dac
            end if;
            
            -- mise � jour de la partie dac
            if update_dac_part_only = '1' then 
               fpa_intf_cfg_i.vdac_value <= USER_CFG.VDAC_VALUE;
            end if;
            
            -- ENO : 24 janv 2015: mis ici pour une simulation correcte
            -- mise � jour de la partie int_time de la cfg : le module du temps d'integration a un latch qui est synchrone avec le frame, donc pas de pb.
            fpa_intf_cfg_i.int_time  <= USER_CFG.INT_TIME;
            fpa_intf_cfg_i.int_indx  <= USER_CFG.INT_INDX;
            fpa_intf_cfg_i.int_signal_high_time <= USER_CFG.INT_SIGNAL_HIGH_TIME;
            
            -- ENO : 25 janv 2015: mis ici pour un fonctionnement correct. Sinon, sans reprogrammation du dtecteur, la partie common est fig�e
            fpa_intf_cfg_i.comn <= USER_CFG.COMN;
            
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
                  if pause_cnt > 63 then   -- largement le temps qu'une autre demande du DAC soit plac�e. Ainsi, on s'assure que toutes les  tensions sont programm�es avant de donner la main au programmateur du d�tecteur
                     dac_ctrl_fsm <= dac_another_rqst_st;
                  end if;
                  
               -- on regarde si une autre demande du dac est plac�e
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
   -- acc�s accord� au programmateur du d�tecteur      
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
                     prog_ctrl_fsm <= prog_img_start_st;               -- ENO : 26 janv 2016: pour le Hawk, on doit au moins prendre une image avec int_time = 0.2usec avant de le programer. C'est tres utile surtout pour eviter de la saturation en windowing. Cette modif ne derangera pas les autres d�tecteurs 
                  end if;
                  
               -- programmer le d�tecteur
               when  fpa_prog_st =>                  
                  prog_en_i <= '1';  
                  if PROG_DONE = '0' then
                     prog_ctrl_fsm <= wait_prog_end_st;
                  end if; 
                  
               -- attente de la fin de programmation
               when  wait_prog_end_st =>     
                  prog_en_i <= '0';                  
                  if PROG_DONE = '1' then
                     prog_ctrl_fsm <= prog_img_start_st;
                     update_fpa_cfg <= '1';       -- ainsi les images prost trig seront trait�es avec la nouvelle config et donc le bon nombre de coups d'horloge pour le HAwk
                  end if;                         -- de plus, -- ENO 24 janv 2016: m�me apr�s la sortie de la config, on prend pareille des images post prog pour que le module readout_ctrler puisse generer le bon nombre de coups de clocks requis pour la config dans le detecteur et assurer convenablement les resets des detecteurs comme le Hawk
                  
               -- prise des images en mode prog_trig (le temps d'integration utilis� est defini dans le fpa_define). Pour un Hawk, il est de 0.2 usec pour eviter des problemes de saturation en windowing
               when prog_img_start_st =>        
                  prog_trig_i <= '1';
                  if readout_i = '1' then
                     prog_ctrl_fsm <= prog_img_end_st;
                     prog_trig_i <= '0';                -- ENO 18 mars 2016: absolument necessaire ici pour �viter des bugs.
                  end if;                  
                  
               -- fin d'une image prog_trig
               when prog_img_end_st =>     
                  update_fpa_cfg <= '0';
                  fpa_first_cfg_done <= '1';
                  if readout_i = '0' then
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
                  
               -- voir si la demande de programmation est trait�e   
               when check_fpa_prog_done_st =>               
                  img_cnt <= (others => '0');
                  if valid_prog_rqst = '1' then               -- si au terme de la prise d'images prog_trig, il y a une requete de programmation, alors c'est qu'elle n'avait pas �t� trait�e. Donc on la traite
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
