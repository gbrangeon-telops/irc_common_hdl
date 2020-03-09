------------------------------------------------------------------
--!   @file fpa_trig_controller.vhd
--!   @brief contrôleur de trigs d'intégration
--!   @details ce module s'assure du traitement du trig d'intégration et du respect des delais de sequence du détecteur.
--! 
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------

--!   Use IEEE standard library.
library IEEE;
--!   Use logic elements package from IEEE library.
use IEEE.STD_LOGIC_1164.all;					   
--!   Use numeric package package from IEEE library.
use IEEE.numeric_std.all; 
use work.FPA_Common_pkg.all;
--!   Use work FPA package.
use work.FPA_define.all;
use work.Proxy_define.all;

entity fpa_trig_controller is
   port(
      ARESET          : in std_logic;
      CLK             : in std_logic;
      
      -- configuration
      FPA_INTF_CFG    : in fpa_intf_cfg_type;
      
      TRIG_CTLER_EN   : in std_logic;
      
      -- trigs d'acquisition ou xtra trig du generateur de trig ou prog_trig du hw_driver des fpas analogiques
      ACQ_TRIG_IN     : in std_logic;
      XTRA_TRIG_IN    : in std_logic;
      PROG_TRIG_IN    : in std_logic;
      
      -- trigs d'acquisition ou xtra trig envoyés au fpa
      ACQ_TRIG_OUT    : out std_logic;
      XTRA_TRIG_OUT   : out std_logic;
      PROG_TRIG_OUT   : out std_logic;   -- trig de prise d'image prost programmation du fPA. image à ne pas envoyer dans la chaine
      
      -- feedback de l'integration du détecteur 
      FPA_INT_FEEDBK  : in std_logic;   -- ce signal doit monter à '1' que si le détecteur a vraiment intégré suite au trig envoyé. Pour les detecteurs numériques, il est généré seuelemnt avec ACQ_INT     
      
      -- signal readout du détecteur
      FPA_READOUT     : in std_logic;       
      
      -- statut
      TRIG_CTLER_STAT : out std_logic_vector(7 downto 0)
      );
end fpa_trig_controller;


architecture RTL of fpa_trig_controller is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
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
   
   type fpa_trig_sm_type is (idle, int_trig_st, check_trig_ctrl_mode_st, check_int_feedback_st, wait_readout_start_st, wait_readout_end_st, wait_int_end_st, apply_dly_st, check_readout_st, int_sanity_check_st);
   type trig_timeout_sm_type is (idle, cnt_st);
   signal fpa_trig_sm                  : fpa_trig_sm_type;
   signal trig_timeout_sm              : trig_timeout_sm_type;
   signal sreset                       : std_logic;
   signal acq_trig_o                   : std_logic;
   signal xtra_trig_o                  : std_logic;
   signal prog_trig_o                  : std_logic;
   signal done                         : std_logic;
   -- signal fpa_readout_last             : std_logic;
   signal count                        : unsigned(3 downto 0);
   signal dly_cnt                      : unsigned(FPA_INTF_CFG.COMN.FPA_ACQ_TRIG_CTRL_DLY'LENGTH-1  downto 0);
   signal timeout_i                    : std_logic := '0';
   signal timeout_count                : unsigned(FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_TIMEOUT_DLY'LENGTH-1 downto 0);
   signal acq_trig_done                : std_logic;
   signal fpa_readout_i                : std_logic;
   signal fpa_int_feedbk_i             : std_logic;
   signal trig_ctler_en_i              : std_logic;
   signal prog_trig_in_i               : std_logic;
   signal apply_dly_then_check_readout : std_logic;
   signal acq_mode                     : std_logic;  -- ENO. 19 fev.  2020 : ce signal reste à '1' tant qu'on est avec les ACQ_TRIG. Il descend à '0' dès qu'un prog_trig ou xtra_trig est pris en compte. 
   signal acq_mode_first_int           : std_logic;  -- ENO. 07 mars. 2020 : ce signal reste à '1' pendant le premier trig et son image associée lors d'une entrée en acq_mode.Tres utile pour les detecteurs en RWI.
   signal nacq_mode_first_int          : std_logic;  -- ENO. 07 mars. 2020 : ce signal reste à '1' pendant le premier trig et son image associée lors d'une entree en non_acq_mode.Tres utile pour les detecteurs en RWI.
   signal acq_in_progress              : std_logic;
   
   --   -- attribute dont_touch                : string;
   --   -- attribute dont_touch of acq_trig_o  : signal is "true";
   --   -- attribute dont_touch of xtra_trig_o : signal is "true";
   --   -- attribute dont_touch of timeout_i       : signal is "true";
   --   -- attribute dont_touch of fpa_readout_last  : signal is "true";
   --   -- attribute dont_touch of timeout_count : signal is "true"; 
   --   -- attribute dont_touch of dly_cnt     : signal is "true"; 
   
   
begin
   --------------------------------------------------
   -- mapping des sorties
   --------------------------------------------------  
   ACQ_TRIG_OUT  <=  acq_trig_o;  --! '1' ssi l'image suivant l'integration en court doit être envoyée dans la chaine. Sinon, à '0'.
   XTRA_TRIG_OUT <=  xtra_trig_o; --! 
   PROG_TRIG_OUT <=  prog_trig_o; --! 
   
   TRIG_CTLER_STAT(7) <= '0';
   TRIG_CTLER_STAT(6) <= acq_in_progress;
   TRIG_CTLER_STAT(5) <= acq_mode_first_int;
   TRIG_CTLER_STAT(4) <= acq_mode;
   TRIG_CTLER_STAT(3) <= acq_trig_done;
   TRIG_CTLER_STAT(2) <= '0';
   TRIG_CTLER_STAT(1) <= nacq_mode_first_int;
   TRIG_CTLER_STAT(0) <= done;
   
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
   -- synchro feedback 
   --------------------------------------------------    
   U1B : double_sync
   port map(
      CLK => CLK,
      D   => FPA_READOUT,
      Q   => fpa_readout_i,
      RESET => sreset
      );
   
   U1C : double_sync
   port map(
      CLK => CLK,
      D   => FPA_INT_FEEDBK,
      Q   => fpa_int_feedbk_i,
      RESET => sreset
      );
   
   U1D : double_sync
   port map(
      CLK => CLK,
      D   => TRIG_CTLER_EN,
      Q   => trig_ctler_en_i,
      RESET => sreset
      );
   
   U1F : double_sync
   port map(
      CLK => CLK,
      D   => PROG_TRIG_IN,
      Q   => prog_trig_in_i,
      RESET => sreset
      );
   
   --------------------------------------------------
   -- fsm de contrôle/filtrage des trigs 
   -------------------------------------------------- 
   -- et de suivi du mode d'integration
   U2: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            acq_trig_o <= '0';
            xtra_trig_o <= '0';
            prog_trig_o <= '0';
            done <= '0';
            fpa_trig_sm <= idle;
            -- fpa_readout_last <= '0';
            acq_trig_done <= '0';
            apply_dly_then_check_readout <= '0';
            acq_mode <= '0';
            acq_mode_first_int <= '0';
            acq_in_progress <= '0';
            nacq_mode_first_int <= '0';
            
         else
            
            -- pour detection front de FPA_readout
            -- fpa_readout_last <= fpa_readout_i;
            
            
            -- definition des delais en dehors de la fsm. De plus ça dure 10 clks : ce qui est convenable pour les timings)
            if acq_trig_o = '1' then                 
               dly_cnt <= FPA_INTF_CFG.COMN.FPA_ACQ_TRIG_CTRL_DLY; 
            end if;
            if xtra_trig_o = '1' then
               dly_cnt <= FPA_INTF_CFG.COMN.FPA_XTRA_TRIG_CTRL_DLY;   
            end if;
            if prog_trig_o = '1' then
               dly_cnt <= FPA_INTF_CFG.COMN.FPA_XTRA_TRIG_CTRL_DLY;
            end if;             
            
            -- séquenceur
            case fpa_trig_sm is 
               
               -- etat idle
               when idle => 
                  acq_trig_o <= '0';
                  xtra_trig_o <= '0';
                  prog_trig_o <= '0';
                  done <= '1'; --! le done est utilisé uniquement par le séquenceur. Ce done est un pulse, etant donné que les extra-trig sont toujours là.Donc à bannir dans le done general envoyé au PPC
                  count <= (others => '0');
                  acq_trig_done <= '1';
                  acq_mode_first_int <= '0';
                  acq_in_progress <= '0';
                  nacq_mode_first_int <= '0';
                  if trig_ctler_en_i = '1' then  --! TRIG_CTLER_EN = '1' ssi le détecteur/proxy est allumé ou si on est en mode diag
                     if ACQ_TRIG_IN = '1' then
                        acq_mode <= '1';
                        acq_trig_o <= not prog_trig_in_i;
                        fpa_trig_sm <= int_trig_st;
                        acq_trig_done <= '0';
                        done <= '0';
                        if acq_mode = '0' then 
                           acq_mode_first_int <= '1';
                        end if;
                     elsif XTRA_TRIG_IN = '1' then
                        acq_mode <= '0';
                        xtra_trig_o <= not prog_trig_in_i;
                        fpa_trig_sm <= int_trig_st;
                        acq_trig_done <= '1';
                        done <= '0';
                        if acq_mode = '1' then 
                           nacq_mode_first_int <= '1';
                        end if;
                     end if;                     
                  end if;
                  
                  if prog_trig_in_i = '1' then
                     acq_mode <= '0';
                     prog_trig_o <= '1';
                     fpa_trig_sm <= int_trig_st;
                     acq_trig_done <= '1';
                     done <= '0';
                     if acq_mode = '1' then 
                        nacq_mode_first_int <= '1';
                     end if;
                  end if; 
                  
               -- pulse ordonnant l'integration  
               when int_trig_st =>		   
                  count <= count + 1;
                  if count >= 10 then --! le pulse pour le debut de l'integration dure au moins 100ns 
                     xtra_trig_o <= '0';                                   
                     acq_trig_o <= '0'; 
                     prog_trig_o <= '0';
                     fpa_trig_sm <= check_int_feedback_st;
                  end if;
                  
               -- on attend le feedback d'intégration
               when check_int_feedback_st =>		   
                  if fpa_int_feedbk_i = '1' then --! on attend le feedback de l'integration qui peut ne pas venir dans le cas des détecteurs numeriques (le détecteur n'est pas allumé bien que le proxy le soit).
                     fpa_trig_sm <= check_trig_ctrl_mode_st;
                     acq_in_progress <= acq_mode;
                  else
                     if timeout_i = '1' and DEFINE_FPA_OUTPUT = OUTPUT_DIGITAL then --! en l'absence du feedback d'intégration, le timeout_i permet de retour en idle en ayant au moins respectée la frequence minimale des trigs 
                        fpa_trig_sm <= idle; 
                     end if;
                  end if;
                  
               -- verif du mode du contrôleur de trig
               when check_trig_ctrl_mode_st =>
                  apply_dly_then_check_readout <= '0';
                  if FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_MODE     = MODE_READOUT_END_TO_TRIG_START then  -- ENO: 10 avril 2019: ne plus utiliser le mode MODE_READOUT_END_TO_TRIG_START pour les détecteurs analogiques puisqu'il n'y a pas de timeout_i 
                     fpa_trig_sm <= wait_readout_start_st;
                  elsif  FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_MODE = MODE_TRIG_START_TO_TRIG_START then
                     fpa_trig_sm <= apply_dly_st;
                  elsif FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_MODE  = MODE_INT_END_TO_TRIG_START then 
                     fpa_trig_sm <= wait_int_end_st;
                  elsif FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_MODE  = MODE_ITR_TRIG_START_TO_TRIG_START then 
                     fpa_trig_sm <= apply_dly_st;
                     apply_dly_then_check_readout <= '1';
                  elsif FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_MODE  = MODE_ITR_INT_END_TO_TRIG_START then
                     fpa_trig_sm <= wait_int_end_st;
                     apply_dly_then_check_readout <= '1';                    
                  end if;
                  
               -- mode_readout_end_to_trig_start : on attend le debut du readout 
               when wait_readout_start_st =>			   
                  if fpa_readout_i = '1' or timeout_i = '1' then   --! début du readout sinon timeout_i permet de retourner à idle.
                     fpa_trig_sm <= wait_readout_end_st; 
                  end if;
                  
               -- mode_readout_end_to_trig_start : on attend la fin du readout 
               when wait_readout_end_st =>			   
                  if fpa_readout_i = '0' then                        --! fin du readout
                     fpa_trig_sm <= apply_dly_st; 
                  end if;
                  
               -- mode_int_end_to_trig_start : on attend la fin de l'intégration 
               when wait_int_end_st =>
                  if fpa_int_feedbk_i = '0' then
                     fpa_trig_sm <= apply_dly_st;                     
                  end if;
                  
                  -- Dans le mode_int_end_to_trig_start : on observe le delai entre la fin de l'integration et le debut du prochain trig
                  -- Dans le mode_readout_end_to_trig_start : on observe le delai readout_end_to_trig_start
                  -- le pilote est donc supposé calculer le delai FPA_TRIG_CTRL_DLY en tenant compte du mode du contrôleur
                  
               -- mode_trig_start_to_trig_start/ mode_itr_trig_start_to_trig_start: on observe les delais prescrits
               when apply_dly_st =>
                  dly_cnt <= dly_cnt - 1;   -- !un compte-down est plus fiable
                  if dly_cnt = 0  then
                     if apply_dly_then_check_readout = '0' then 
                        fpa_trig_sm <= int_sanity_check_st;                   
                     else
                        fpa_trig_sm <= check_readout_st; 
                     end if;
                  end if;
                  
               -- check supplémentaire de la fin du readout
               when check_readout_st =>		   
                  if fpa_readout_i = '0' then --! fin du readout.
                     fpa_trig_sm <= int_sanity_check_st; 
                  end if;
                  
               -- il faut s'assurer de la fin de l'integration (très important pour les detecteurs RWI)
               when int_sanity_check_st =>
                  if fpa_int_feedbk_i = '0' then --! pour les non RWI, c'est un coup d'horloge supplementaire de delai. A priori, rien de majeur.
                     fpa_trig_sm <= idle; 
                  end if;                   
               
               when others =>
               
            end case;
            
         end if;         
      end if;
      
   end process;
   
   --------------------------------------------------
   -- fsm de contrôle de la periode minimale du trig
   --------------------------------------------------
   U3: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then  
            timeout_i <= '0';
            trig_timeout_sm <= idle;
            
         else            
            
            -- séquenceur
            case trig_timeout_sm is 
               
               -- etat idle
               when idle =>                   
                  timeout_count <= (others => '0');
                  if acq_trig_o = '1' or xtra_trig_o = '1' or prog_trig_o = '1' then
                     timeout_count <= FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_TIMEOUT_DLY; -- determine la periode minimale des acq trigs 
                     trig_timeout_sm <= cnt_st;  
                     timeout_i <= '0';          
                  end if;
                  
               -- decompte pour le timeout
               when cnt_st =>           
                  timeout_count <= timeout_count - 1;                
                  if timeout_count = 0 then
                     trig_timeout_sm <= idle;
                     timeout_i <= '1';
                  end if;
               
               when others =>
               
            end case;
            
            -- reset du timeout
            if fpa_trig_sm = idle then 
               trig_timeout_sm <= idle;
            end if;            
            
         end if;         
      end if;
      
   end process;
   
end RTL;
