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
      
      -- post prog détecteur
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
   
   type hw_seq_fsm_type is (idle, diag_mode_only_st, update_fpa_cfg_st1, update_fpa_cfg_st2, check_fpa_prog_done_st, update_dac_cfg_st, forward_rqst_st, check_rqst_st, dac_prog_st, dac_another_rqst_st, fpa_prog_st, wait_prog_end_st, wait_dac_end_st, dac_pause_st, prog_img_start_st, prog_img_end_st, check_prog_mode_end_st);
   
   signal hw_seq_fsm                : hw_seq_fsm_type;
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
   --  Allumage du détecteur 
   --------------------------------------------------
   -- doit être dans un process indépendant et sans fsm 
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then 
         FPA_PWR <= FPA_POWER and not sreset; 
         fpa_powered_i <= FPA_POWERED and not sreset;                 
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
            dac_powered_i <= '0';
            dac_en_i <= '0';
            prog_en_i <= '0';
            hw_done_i <= '0';
            valid_prog_rqst <= '0';
            valid_dac_rqst <= '0';
            valid_rqst_pending <= '0';
            prog_trig_i <= '0';
            fpa_intf_cfg_i <= FPA_INTF_CFG_DEFAULT;
         else                   
            
            -- misc
            readout_i <= READOUT;
            dac_powered_i <= DAC_POWERED; -- pour signifier que le fleg est allumé et les dacs sont à programmer pour la premiere fois.
            
            valid_prog_rqst <= PROG_RQST and fpa_powered_i and dac_powered_i;  -- il faut absoluement dac_powered_i.
            valid_dac_rqst <= DAC_RQST and dac_powered_i;
            valid_rqst_pending <= valid_dac_rqst or valid_prog_rqst; 
            
            --fsm de contrôle            
            case  hw_seq_fsm is
               
               -- attente d'une demande
               when idle =>      
                  hw_done_i <= '1';                    
                  dac_en_i <= '0';
                  prog_en_i <= '0';
                  hw_rqst_i <= '0';
                  prog_trig_i <= '0';
                  img_cnt <= (others => '0');
                  post_update_img <= '0';
                  if DIAG_MODE_ONLY = '1' then
                     hw_seq_fsm <= diag_mode_only_st;
                  elsif valid_rqst_pending = '1' then 
                     hw_seq_fsm <= forward_rqst_st;
                  end if;
               
               when diag_mode_only_st =>
                  fpa_intf_cfg_i <= USER_CFG;
                  if DIAG_MODE_ONLY = '0' then
                     hw_seq_fsm <= idle;
                  end if;                  
                  
               -- demande envoyée au contrôleur principal
               when forward_rqst_st =>
                  hw_rqst_i <= '1';                                 -- fpa_rqst est le signal de demande d'autorisation au contrôleur principal. Certes il porte le prefixe fpa_ mais il est valable pour le dac aussi.
                  if HW_DRIVER_EN = '1' then                        -- suppose que le trig_controller est arrêté par le contrôleur principal du hw
                     hw_seq_fsm <= check_rqst_st;
                  end if;
                  
               -- quel client fait la demande
               when check_rqst_st => 
                  hw_done_i <= '0';
                  hw_rqst_i <= '0';
                  if valid_dac_rqst = '1' then
                     hw_seq_fsm <= dac_prog_st;
                  elsif valid_prog_rqst = '1' then                  
                     hw_seq_fsm <= prog_img_start_st;               -- ENO : 26 janv 2016: pour le Hawk, on doit au moins prendre une image avec int_time = 0.2usec avant de le programer. C'est tres utile surtout pour eviter de la saturation en windowing. Cette modif ne derangera pas les autres détecteurs 
                  end if;                   
                  
                  ----------------------------------------------------
                  -- accès accordé au dac                
                  ----------------------------------------------------
               
               when dac_prog_st =>     
                  dac_en_i <= '1';
                  if DAC_DONE = '0' then
                     hw_seq_fsm <= wait_dac_end_st;
                  end if;
                  
               -- attente de la fin de transaction pour le dac
               when  wait_dac_end_st =>     
                  dac_en_i <= '0';
                  pause_cnt <= (others => '0');                  
                  if DAC_DONE = '1' then
                     hw_seq_fsm <= dac_pause_st;
                  end if;             
                  
               -- on donne le temps pour voir si une autre demande du dac suit
               when  dac_pause_st =>
                  pause_cnt <= pause_cnt + 1;
                  if pause_cnt > 63 then   -- largement le temps qu'une autre demande du DAC soit placée. Ainsi, on s'assure que toutes les  tensions sont programmées avant de donner la main au programmateur du détecteur
                     hw_seq_fsm <= dac_another_rqst_st;
                  end if;
                  
               -- on regarde si une autre demande du dac est placée
               when dac_another_rqst_st =>                  
                  if valid_dac_rqst = '1' then  
                     hw_seq_fsm <= dac_prog_st;
                  else               
                     hw_seq_fsm <= update_dac_cfg_st;
                  end if;   
                  
               -- mise à jour de la partie Dac de la cfg
               when  update_dac_cfg_st =>
                  fpa_intf_cfg_i.vdac_value <= USER_CFG.VDAC_VALUE; 
                  hw_seq_fsm <= idle;
                  
                  -------------------------------------------------
                  -- accès accordé au programmateur du détecteur      
                  -------------------------------------------------
               
               when  fpa_prog_st =>
                  prog_en_i <= '1';  
                  if PROG_DONE = '0' then
                     hw_seq_fsm <= wait_prog_end_st;
                  end if; 
                  
               -- attente de la fin de transaction pour le programmateur du détecteur
               when  wait_prog_end_st =>     
                  prog_en_i <= '0';                  
                  if PROG_DONE = '1' then
                     hw_seq_fsm <= prog_img_start_st;
                  end if; 
                  
               -- prise des images en mode prog_trig (le temps d'integration utilisé est defini dans le fpa_define). Pour un Hawk, il est de 0.2 usec pour eviter des problemes de saturation en windowing
               when prog_img_start_st =>              
                  prog_trig_i <= '1';
                  if readout_i = '1' then
                     hw_seq_fsm <= prog_img_end_st;
                  end if;                  
                  
               -- fin d'une image prog_trig
               when prog_img_end_st =>
                  prog_trig_i <= '0';
                  if readout_i = '0' then
                     img_cnt <= img_cnt + 1;
                     hw_seq_fsm <= check_prog_mode_end_st;
                  end if;
                  
               -- fin de la serie d'images prog_trig
               when check_prog_mode_end_st =>                  
                  if img_cnt = DEFINE_FPA_XTRA_IMAGE_NUM_TO_SKIP then 
                     hw_seq_fsm <= check_fpa_prog_done_st;
                  else
                     hw_seq_fsm <= prog_img_start_st;
                  end if;               
                  
               -- voir si la demande de programmation est traitée   
               when check_fpa_prog_done_st =>               
                  img_cnt <= (others => '0');
                  if valid_prog_rqst = '1' then               -- si au terme de la prise d'images prog_trig, il y a une requete de programmation, alors c'est qu'elle n'avait pas été traitée. Donc on la traite
                     hw_seq_fsm <= fpa_prog_st;
                  else
                     hw_seq_fsm <= update_fpa_cfg_st1;             
                  end if;                
                  
               -- update_fpa_cfg_st : phase preparatoire où on latche les valeurs de la partie dac de la config actuelle
               when update_fpa_cfg_st1 =>
                  img_cnt <= (others => '0');
                  vdac_value <= fpa_intf_cfg_i.vdac_value;    -- il faut enregistrer la cfg des dacs pour ne pas les ecraser
                  hw_seq_fsm <= update_fpa_cfg_st2;
                  
               -- update_fpa_cfg_st : phase finale où on met à jour la partie FPA (non DAC)  de la config 
               when update_fpa_cfg_st2 =>
                  fpa_intf_cfg_i <= USER_CFG;
                  fpa_intf_cfg_i.vdac_value <= vdac_value;
                  if post_update_img = '1' then
                     hw_seq_fsm <= idle;
                  else                           -- ENO 24 janv 2015: même après la sortie de la config, on prend pareille des images post prog pour que le module readout_ctrler puisse generer le bon nombre de coups de clocks requis pour la config dans le detecteur et assurer convenablement les resets des detecteurs comme le Hawk
                     post_update_img <= '1';
                     hw_seq_fsm <= prog_img_start_st;
                  end if;
               
               when others =>
               
            end case;
            
            -- ENO : 24 janv 2015: mis ici pour une simulation correcte
            -- mise à jour de la partie int_time de la cfg : le module du temps d'integration a un latch qui est synchrone avec le frame, donc pas de pb.
            fpa_intf_cfg_i.int_time  <= USER_CFG.INT_TIME;
            fpa_intf_cfg_i.int_indx  <= USER_CFG.INT_INDX;
            fpa_intf_cfg_i.int_signal_high_time <= USER_CFG.INT_SIGNAL_HIGH_TIME;
            
            -- ENO : 25 janv 2015: mis ici pour un fonctionnement correct. Sinon, sans reprogrammation du dtecteur, la partie common est figée
            fpa_intf_cfg_i.comn <= USER_CFG.COMN;
            
         end if;
      end if;   
   end process;
   
   
   
   
   
end rtl;
