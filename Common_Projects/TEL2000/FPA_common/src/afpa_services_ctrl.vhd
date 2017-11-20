------------------------------------------------------------------
--!   @file : afpa_services_ctrl
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
use IEEE. numeric_std.all;
use work.fpa_common_pkg.all;
use work.FPA_define.all;


entity afpa_services_ctrl is
   
   port(
      
      -- signaux generaux
      CLK                    : in std_logic;
      ARESET                 : in std_logic;
      
      -- interface avec la switch      
      SWITCH_PROG            : out std_logic;
      SWITCH_DONE            : in std_logic;
      
      -- interface avec monitoring adc
      FPA_TEMP               : in t_ll_ext_mosi16;
      FPA_DIGIOV             : in t_ll_ext_mosi16;      -- en milliVolt
      FLEX_PSP               : in t_ll_ext_mosi16;      -- en milliVolt
      MEAS_TP                : in t_ll_ext_mosi16;
      
      -- interface avec adc_brd_id_reader
      ADC_BRD_INFO           : in adc_brd_info_type;
      
      -- interface avec flex_brd_id_reader
      FLEX_BRD_INFO          : in flex_brd_info_type;
      
      -- erreurs entrantes
      ERR                    : in std_logic_vector(3 downto 0);
      
      -- statuts
      FPA_HARDW_STAT           : out fpa_hardw_stat_type;
      FPA_TEMP_STAT            : out fpa_temp_stat_type;
      CHN_DIVERSITY_POSSIBLE   : out std_logic;
      DISABLE_QUAD_DEFAULT_CLK : out std_logic
      );
end afpa_services_ctrl;


architecture rtl of afpa_services_ctrl is
   
   constant C_ADC_DATA_RDY_DLY_FACTOR   : natural := 50_000_000;   -- ce qui donne un temps de 500ms pour une hrologe de 100MHz
   constant C_TEMP_ADC_TIMEOUT_FACTOR   : natural := 200_000_000; -- ce qui donne un temps de 2sec au ADC pour rafraichir ses données de température détecteur.
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   type services_ctrl_sm_type  is (wait_adc_brd_id_st, check_adc_brd_data_st1, check_adc_brd_data_st2, wait_flex_brd_id_st, check_flex_brd_data_st1, check_flex_brd_data_st2, launch_decision_maker_st);
   type decision_sm_type is(idle, chn_diversity_st1, chn_diversity_st2, quad_adc_st, prog_sw_st, wait_sw_st1, wait_sw_st2, send_status_st, wait_timeout_st, wait_feedback_st1, wait_feedback_st2, 
   check_feedback_st1, check_feedback_st2, success_status_st, failure_status_st, check_sw_reprogr_st, reset_param_st);
   type fpa_temp_sm_type is (idle, check_temp_max_st, check_temp_min_st, temp_rdy_st);
   type adc_alive_sm_type is (idle, check_rate_st, timeout_st);
   
   signal timeout_cnt                : natural range 0 to C_TEMP_ADC_TIMEOUT_FACTOR;
   signal sreset                     : std_logic;
   signal services_ctrl_sm           : services_ctrl_sm_type;
   signal fpa_hardw_stat_i           : fpa_hardw_stat_type;
   signal decision_sm                : decision_sm_type;
   signal adc_brd_err                : std_logic;
   signal flex_brd_err               : std_logic;
   signal decision_maker             : std_logic;
   signal chn_diversity_possible_i   : std_logic;
   signal total_analog_chn           : natural range 0 to 63;
   signal disable_quad_default_clk_i : std_logic;
   signal rdy_dly_cnt                : natural range 0 to C_ADC_DATA_RDY_DLY_FACTOR;
   signal fpa_input_type_meas        : std_logic_vector(7 downto 0);
   signal flex_psp_meas              : natural range 0 to 8000;
   signal brd_feedback_err           : std_logic;
   signal prog_cnt                   : unsigned(2 downto 0);
   signal fpa_temp_stat_i            : fpa_temp_stat_type;
   signal fpa_temp_sm                : fpa_temp_sm_type;
   signal adc_alive                  : std_logic;
   signal adc_alive_sm               : adc_alive_sm_type;
   signal temp_reached               : std_logic;
   
   --attribute dont_touch              : string;
   --attribute dont_touch of adc_brd_err                   : signal is "true";
   --attribute dont_touch of flex_brd_err                  : signal is "true";
   --attribute dont_touch of decision_maker                : signal is "true";
   --attribute dont_touch of chn_diversity_possible_i      : signal is "true";
   --attribute dont_touch of disable_quad_default_clk_i    : signal is "true";
   --attribute dont_touch of fpa_input_type_meas           : signal is "true"; 
   --attribute dont_touch of flex_psp_meas                 : signal is "true";
   
begin 
   
   FPA_TEMP_STAT  <= fpa_temp_stat_i;
   
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U0: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );
   
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   --ETAPE1 : lire ID flex et ID ADC
   --ETAPE2 : programmer les switches selon ID et FPA_Define
   --ETAPE3 : lancer monitoring_adc pour relire valeurs  programmées   
   --ETAPE4 : relancer la programmation max 3 fois si non concordance
   --ETAPE5 : si OK, verifier que Horloge ADC du define conforme à ID ADC (freq et nbre de bits resolution)
   --ETAPE6 : si OK, clocker les ADC
   --ETAPE7 : compiller tout et sortir les statuts
   --ETAPE8 : lancer monitoring ADC pour la température du detecteur et la sortir en mode continuel
   --ETAPE9 : allumer Led erreur si Erreur                                    
   
   ----------------------------------------------------------------------------
   -- Recueil d'informations sur ADC Board et Flex
   ----------------------------------------------------------------------------
   U1: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            services_ctrl_sm <= wait_adc_brd_id_st;
            fpa_hardw_stat_i <= HARDW_STAT_UNKNOWN;
            adc_brd_err <= '0';
            flex_brd_err <= '0';
            decision_maker <= '0';  			
         else 
            
            case services_ctrl_sm is
               
               when wait_adc_brd_id_st =>            -- il faut detecter la carte ADC d'abord sinon comment peut-on operer avec un adc inconnu et un flex connu?
                  if ADC_BRD_INFO.DVAL = '1' then
                     services_ctrl_sm <= check_adc_brd_data_st1;
                  end if;          
               
               when check_adc_brd_data_st1 =>        -- vérification si la carte ADC pourra supporter les canaux du détecteur
                  if DEFINE_FPA_TAP_NUMBER > ADC_BRD_INFO.ANALOG_CHANNEL_NUM then  -- condition verifiée même si aucune carte ADC n'est pas détectée car ADC_BRD_INFO.ANALOG_CHANNEL_NUM vaut 0 dans ce cas
                     adc_brd_err <= '1';                     
                  end if;
                  services_ctrl_sm <= check_adc_brd_data_st2;
               
               when check_adc_brd_data_st2 =>        -- verification si la carte ADC pourra supporter le sampling rate imposé par le détecteur
                  if integer(DEFINE_ADC_QUAD_CLK_RATE_KHZ) > ADC_BRD_INFO.ADC_OPER_FREQ_MAX_KHZ then
                     adc_brd_err <= '1';                     
                  end if;
                  services_ctrl_sm <= wait_flex_brd_id_st;
               
               when wait_flex_brd_id_st =>           -- detection du flex
                  if FLEX_BRD_INFO.DVAL = '1' then
                     services_ctrl_sm <= check_flex_brd_data_st1;
                  end if;
               
               when check_flex_brd_data_st1 =>      -- vérification si flex conforme au FPA attendu pour bien programmer le generateur de courant de la diode de lecture de temperature
                  if FLEX_BRD_INFO.FPA_ROIC /= DEFINE_FPA_ROIC then     -- condition verifiée même si aucune carte flex n'est pas détectée 
                     flex_brd_err <= '1';                     
                  end if;
                  services_ctrl_sm <= check_flex_brd_data_st2;
               
               when check_flex_brd_data_st2 =>     -- vérification si flex conforme au FPA attendu pour bien programmer le translateur FPA_DIGIO
                  if FLEX_BRD_INFO.FPA_INPUT /= DEFINE_FPA_INPUT then 
                     flex_brd_err <= '1';                     
                  end if;
                  services_ctrl_sm <= launch_decision_maker_st;
               
               when launch_decision_maker_st =>         -- on lance une prise de décision avec les infos recueillies et on ne sort plus de cet état
                  decision_maker <= '1';   
               
               when others =>
               
            end case;
         end if;
      end if;
   end process;   
   
   
   ----------------------------------------------------------------------------
   -- Prise de décisions au sujet de ADC et FLEX
   ----------------------------------------------------------------------------
   U2: process(CLK) 
      variable iddca_info: iddca_info_type; 
      
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            decision_sm <= idle;
            chn_diversity_possible_i <= '0';
            DISABLE_QUAD_DEFAULT_CLK <= '0';
            CHN_DIVERSITY_POSSIBLE <= '0';
            SWITCH_PROG <= '0';
            disable_quad_default_clk_i <= '0';
            brd_feedback_err <= '0';
            FPA_HARDW_STAT.DVAL <= '0';
         else
            
            case decision_sm is
               
               when idle =>
                  prog_cnt <= (others => '0');
                  if decision_maker = '1' then
                     decision_sm <= chn_diversity_st1; 
                  end if;
                  
               -- etape 1: verification des infos recueillies auprès des cartes 
               when chn_diversity_st1 =>       -- on regarde si la diversité des canaux est possible sur le flex detecté
                  chn_diversity_possible_i <= '0';   -- par defaut, non possible. Cette decision sera renversée au besoin dans l'état suivant.
                  if FLEX_BRD_INFO.CHN_DIVERSITY_NUM > 1 then 
                     decision_sm <= chn_diversity_st2;
                  else                     
                     decision_sm <= quad_adc_st;					 
                  end if;
                  total_analog_chn <= DEFINE_FPA_TAP_NUMBER*FLEX_BRD_INFO.CHN_DIVERSITY_NUM; -- nombre de canaux requis sur la carte ADC (avec diversité de canal ou non)
               
               when chn_diversity_st2 =>   -- on regarde si la diversité des canaux est possible sur le flex detecté. on passe par ici ssi FLEX_BRD_INFO.CHN_DIVERSITY_NUM > 1 donc on peut affirmer qu'il est possible d'en faire. Mais le dernier mot revient au pilote
                  if total_analog_chn <= ADC_BRD_INFO.ANALOG_CHANNEL_NUM then
                     chn_diversity_possible_i <= '1';   -- finalement, diversité Possible si le flex et la carte adc le permettent
                  end if;
                  decision_sm <= quad_adc_st;
               
               when quad_adc_st =>		    -- on envoie au quad la fréquence d'horloge specifiée dans FPA_define. On desactive donc la frequence par defaut si aucune erreur n'est détectée.   
                  disable_quad_default_clk_i <= not adc_brd_err;     				
                  decision_sm <= prog_sw_st;   
                  
               -- etape 2: programmation de la switch   
               when prog_sw_st =>          -- on programme la switch avec la configuration source-courant, FPA_DIGIO requise pour le flex détecté. Bien evidemment si aucune erreur détectée sur cartes ADC et flex 
                  if adc_brd_err = '0' and flex_brd_err = '0' then
                     if SWITCH_DONE = '1' then
                        SWITCH_PROG <= '1';   
                        decision_sm <= wait_sw_st1;
                     end if;
                  else
                     decision_sm <= failure_status_st;
                  end if;
               
               when wait_sw_st1 =>         -- on attend que le contrôleur lance la programmation de la switch
                  if SWITCH_DONE = '0' then
                     decision_sm <= wait_sw_st2;
                     SWITCH_PROG <= '0';
                  end if;
               
               when wait_sw_st2 =>          -- on attend la fin de la programmation de la switch
                  rdy_dly_cnt <= 0;
                  if SWITCH_DONE = '1' then
                     decision_sm <= wait_timeout_st;
                     SWITCH_PROG <= '0';
                  end if;
               
               when wait_timeout_st =>   -- attendre que les mesures soient à jour sur les composants reprogrammés
                  rdy_dly_cnt <= rdy_dly_cnt + 1;
                  if rdy_dly_cnt = C_ADC_DATA_RDY_DLY_FACTOR then   -- 500 ms de delai suggéré
                     decision_sm <= wait_feedback_st1;
                  end if;
                  -- pragma translate_off  
                  decision_sm <= wait_feedback_st1;
                  -- pragma translate_on  
                  
               -- etape 3: feedback  
               when wait_feedback_st1 =>  -- attendre feedback  FPA_DIGIOV
                  fpa_input_type_meas <= digio_voltage_to_fpa_input_type(unsigned(FPA_DIGIOV.DATA)); -- FPA_DIGIOV.DATA doit être en mV
                  if FPA_DIGIOV.DVAL = '1' then
                     decision_sm <= wait_feedback_st2;
                  end if;
               
               when wait_feedback_st2 =>  -- attendre feedback FLEX_PSP
                  flex_psp_meas <= voltage_to_flex_psp_mV(unsigned(FLEX_PSP.DATA));                  -- FLEX_PSP.DATA doit être en mV
                  if FLEX_PSP.DVAL = '1' then
                     decision_sm <= check_feedback_st1;                     
                  end if;
               
               when check_feedback_st1 => -- verifier le 1er element de feedback
                  if fpa_input_type_meas /= DEFINE_FPA_INPUT then
                     brd_feedback_err <= '1';
                  end if;
                  decision_sm <= check_feedback_st2;
               
               when check_feedback_st2 => -- verifier le 2e element de feedback
                  if flex_psp_meas /= DEFINE_FLEX_VOLTAGEP_mV then
                     brd_feedback_err <= '1';
                  end if;   
                  decision_sm <= check_sw_reprogr_st;                  
               
               when check_sw_reprogr_st => 
                  if brd_feedback_err = '1' then
                     if prog_cnt = 3 then 
                        decision_sm <= failure_status_st;
                     else
                        decision_sm <= reset_param_st; 
                     end if;
                  else
                     decision_sm <= success_status_st;
                  end if;                 
               
               when reset_param_st =>
                  brd_feedback_err <= '0';
                  prog_cnt <= prog_cnt + 1;                  
                  decision_sm <= prog_sw_st; 
                  
                  -- etape 4: sortie des statuts
               -- en cas d'échec
               when failure_status_st =>
                  FPA_HARDW_STAT.ADC_BRD_INFO  <= ADC_BRD_INFO_UNKNOWN;                  
                  FPA_HARDW_STAT.FLEX_BRD_INFO <= FLEX_BRD_INFO_UNKNOWN;
                  FPA_HARDW_STAT.IDDCA_INFO <= IDDCA_INFO_UNKNOWN;
                  FPA_HARDW_STAT.DVAL <= '1';
                  CHN_DIVERSITY_POSSIBLE <= '0';
                  DISABLE_QUAD_DEFAULT_CLK <= '0';
                  
               --en cas de succès
               when success_status_st =>
                  FPA_HARDW_STAT.ADC_BRD_INFO  <= ADC_BRD_INFO;                  
                  FPA_HARDW_STAT.FLEX_BRD_INFO <= FLEX_BRD_INFO;
                  FPA_HARDW_STAT.IDDCA_INFO <= flex_brd_info_to_iddca_info(FLEX_BRD_INFO);
                  FPA_HARDW_STAT.DVAL <= '1';
                  CHN_DIVERSITY_POSSIBLE <= chn_diversity_possible_i;
                  DISABLE_QUAD_DEFAULT_CLK <= disable_quad_default_clk_i;
               
               when others =>
               
            end case;        
            
         end if;
      end if;
   end process; 
   
   ----------------------------------------------------------------------------
   -- Envoi de la Température du détecteur
   ----------------------------------------------------------------------------
   -- fsm dans le but de reduire les contraintes de timings
   U3: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            fpa_temp_stat_i.fpa_pwr_on_temp_reached <= '0';
            temp_reached <= '0';
            fpa_temp_stat_i.temp_dval <= '0';
            fpa_temp_sm <= idle;
         else
            
            fpa_temp_stat_i.fpa_pwr_on_temp_reached <= temp_reached and adc_alive;
            
            case fpa_temp_sm is       -- pour generer le fpa_temp_stat_i.fpa_pwr_on_temp_reached
               
               when idle =>                  
                  if FPA_TEMP.DVAL = '1' then
                     fpa_temp_sm <= check_temp_max_st;
                     fpa_temp_stat_i.temp_data <= std_logic_vector(resize(unsigned(FPA_TEMP.DATA), fpa_temp_stat_i.temp_data'length)); -- ENO: faut pas deplacer cette ligne
                  end if;
               
               when check_temp_max_st =>  
                  fpa_temp_stat_i.temp_dval <= '1';
                  if unsigned(fpa_temp_stat_i.temp_data(15 downto 0)) < DEFINE_FPA_TEMP_RAW_MAX then
                     fpa_temp_sm <= check_temp_min_st;
                  else
                     fpa_temp_sm <= idle;
                     temp_reached <= '0';    -- ainsi lorsque FPA_TEMP> DEFINE_FPA_TEMP_RAW_MAX, fpa_pwr_on_temp_reached tombe à '0' ce qui permet au sequenceur d'eteindre le détecteur 
                  end if;
               
               when check_temp_min_st =>
                  if unsigned(fpa_temp_stat_i.temp_data(15 downto 0)) > DEFINE_FPA_TEMP_RAW_MIN then
                     fpa_temp_sm <= temp_rdy_st;
                  else
                     fpa_temp_sm <= idle;
                     temp_reached <= '0';    -- ainsi lorsque FPA_TEMP < DEFINE_FPA_TEMP_RAW_MIN, fpa_pwr_on_temp_reached tombe à '0' ce qui permet au sequenceur d'eteindre le détecteur
                  end if;
               
               when temp_rdy_st =>
                  temp_reached <= '1';
                  fpa_temp_sm <= idle;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   
   ---------------------------------------------------------------------------------------
   -- Vérification de l'état de l'ADC lisant la température du FPA 
   ---------------------------------------------------------------------------------------
   --en l'absence de données provenant de l'ADC durant 2sec, on eteint le détecteur.Sinon la temperature peut sortir des limites tolerables, sans qu,on ne le sache
   U4: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            adc_alive <= '0';
            adc_alive_sm <= check_rate_st;
            timeout_cnt <= C_TEMP_ADC_TIMEOUT_FACTOR;
         else          
            
            case adc_alive_sm is       
               
               when check_rate_st =>
                  adc_alive <= '1'; 
                  timeout_cnt <= timeout_cnt - 1;
                  if FPA_TEMP.DVAL = '1' then
                     timeout_cnt <= C_TEMP_ADC_TIMEOUT_FACTOR;
                  end if;                  
                  if timeout_cnt = 0 then 
                     adc_alive_sm <= timeout_st;
                  end if;
               
               when timeout_st =>     -- on en sort plus. En effet cette erreur ne doit jamais se produire. Si cela arrivait, on eteint le détecteur pour de bon!!!! Un diagostic doit être effectué.
                  adc_alive <= '0';
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process; 
   
   
end rtl;
