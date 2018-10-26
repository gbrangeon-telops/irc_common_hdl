------------------------------------------------------------------
--!   @file fpa_intf_sequencer
--!   @brief sequenceur du modeule FPA interface
--!   @details ce module assure la coordination des activités dans le module FPA Interface
--! 
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
use work.fpa_common_pkg.all;        -- pour connaitre le type d'interface du projet
use work.FPA_Define.all;
use work.Proxy_Define.all;

entity fpa_intf_sequencer is
   
   generic (       
      BYPASS_FPA_PROTECTION : boolean := false  -- en simulation, permet de contourner  toutes les protections. Doit toujours démeurer à false en mode réel 
      );
   
   port(       
      --------------------------------------------------
      -- INPUTS
      --------------------------------------------------
      CLK                : in std_logic;
      ARESET             : in std_logic;       
      FPA_INTF_CFG       : in fpa_intf_cfg_type; --! configuration           
      TRIG_CTLER_STAT    : in std_logic_vector(7 downto 0); --! statuts du gestionnaire des trigs du FPA          
      FPA_DRIVER_STAT    : in std_logic_vector(31 downto 0); --! statuts du pilote Hardware du FPA     
      DATA_PATH_STAT     : in std_logic_vector(15 downto 0); --! statuts du lien des donnees
      FPA_COOLER_STAT    : in fpa_cooler_stat_type; --! statut du refroidisseur     
      FPA_HARDW_STAT     : in fpa_hardw_stat_type; --! statut (type + mise-à-jour) de toutes les cartes de proximité (proxy, flex, DDC, ADC, harnais etc...)   
      FPA_SOFTW_STAT     : in fpa_firmw_stat_type;--
      FPA_VHD_STAT       : in fpa_firmw_stat_type;--
      FPA_TEMP_STAT      : in fpa_temp_stat_type; --! statut du lecteur de température
      --------------------------------------------------
      -- OUTPUTS
      --------------------------------------------------     
      TRIG_CTLER_EN      : out std_logic; --! controle du gestionnaire des trigs      
      FPA_DRIVER_EN      : out std_logic; --! controle du pilote Hardware du FPA      
      FPA_POWER          : out std_logic; --! controle de l'allumage du FPA    
      INTF_SEQ_STAT      : out std_logic_vector(7 downto 0); --! statut du séquenceur     
      DIAG_MODE_ONLY     : out std_logic  --! diag mode only. à '1' <=> seul le mode diag est autorisé      
      );
end fpa_intf_sequencer;



architecture RTL of fpa_intf_sequencer is  
   
   component sync_reset
      port(
         ARESET : in STD_LOGIC;
         SRESET : out STD_LOGIC;
         CLK    : in STD_LOGIC);
   end component;
   
   component Clk_Divider is
      Generic(	Factor:		integer := 2);		
      Port ( Clock  : in std_logic;
         Reset  : in std_logic;		
         Clk_div: out std_logic);
   end component;
   
   type status_type is (not_available, success, failure);
   type fpa_sequencer_sm_type is (init_st1, init_st2, idle, trig_ctrl_st, active_prog_st, wait_trig_done_st, wait_dpath_done_st, wait_prog_end_st, trig_en_st);
   signal fpa_hardw_up2date   : status_type;
   signal fpa_hardw_type      : status_type;
   signal fpa_vhd_stat_i      : status_type;
   signal fpa_softw_stat_i    : status_type;
   signal fpa_temp_stat_i     : status_type;
   signal hardw_global_status : status_type;
   signal firmw_global_status : status_type;
   signal fpa_sequencer_sm    : fpa_sequencer_sm_type;
   signal sreset              : std_logic;
   --signal fpa_intf_type_err_i : std_logic;
   signal fpa_power_i           : std_logic;
   signal trig_ctler_en_i     : std_logic; 
   signal fpa_driver_en_i     : std_logic;
   signal trig_ctler_done     : std_logic;
   signal fpa_driver_done     : std_logic;
   signal fpa_driver_rqst     : std_logic; -- permet de saboir si le pilote hw requiert de reprogrammer le FPA
   signal fpa_cooler_on       : std_logic;
   signal done                : std_logic; 
   signal fpa_hardw_err       : std_logic;
   signal diag_mode_only_i    : std_logic;
   signal fpa_softw_err       : std_logic;
   signal fpa_vhd_err         : std_logic;
   signal fpa_init_cfg_rdy    : std_logic;
   signal frm_in_progress     : std_logic := '0';
   
   
   
   --   attribute keep : string;
   --   attribute keep of CLK_1sec : signal is "true";
   
begin    
   
   
   --------------------------------------------------
   -- mapping des sorties
   -------------------------------------------------- 
   FPA_POWER <= fpa_power_i;
   TRIG_CTLER_EN <= trig_ctler_en_i;
   FPA_DRIVER_EN <= fpa_driver_en_i;
   DIAG_MODE_ONLY <= diag_mode_only_i;
   
   --stat                     
   INTF_SEQ_STAT(7 downto 4) <= (others => '0');   
   INTF_SEQ_STAT(3) <= fpa_softw_err; 
   INTF_SEQ_STAT(2) <= fpa_vhd_err; 
   INTF_SEQ_STAT(1) <= fpa_hardw_err;           
   INTF_SEQ_STAT(0) <= done; 
   
   --------------------------------------------------
   -- mapping des entrees
   -------------------------------------------------- 
   fpa_driver_rqst <= FPA_DRIVER_STAT(1);
   trig_ctler_done <= TRIG_CTLER_STAT(0);
   fpa_driver_done <= FPA_DRIVER_STAT(0);
   
   frm_in_progress <= DATA_PATH_STAT(9);
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1 : sync_reset
   port map(ARESET => ARESET, CLK => CLK, SRESET => sreset); 
   
   -----------------------------------------------------------
   -- Vérification des statuts des cartes électroniques 
   -----------------------------------------------------------
   U2: process(CLK)
   begin          
      if rising_edge(CLK) then         
         
         if FPA_HARDW_STAT.DVAL = '1' and FPA_VHD_STAT.DVAL = '1' then     -- dval est requis pour eviter de sortir des fausses erreurs
            
            -- on vérifie que le montage électronique est conforme au design vhd et on vérifie aussi que les IO de contrôle du FPGA sont conformes aux specs de l'iDDCA
            if FPA_HARDW_STAT.IDDCA_INFO.FPA_ROIC = FPA_VHD_STAT.FPA_ROIC and  FPA_HARDW_STAT.IDDCA_INFO.FPA_OUTPUT = FPA_VHD_STAT.FPA_OUTPUT and  FPA_HARDW_STAT.IDDCA_INFO.FPA_INPUT = FPA_VHD_STAT.FPA_INPUT then  -- FPA_VHD_STAT.FPA_ROIC est une reference sûre car codé en hardware.              
               fpa_hardw_type <= success;                                                                                                                                                                       ---- FPA_HARDW_STAT.IDDCA_INFO.FPA_INPUT provient des cartes d'interface des détecteurs et FPA_VHD_STAT.FPA_INPUT provient d'un module qui mesure la tension du FPGA          
               fpa_hardw_err <= '0';
            else
               fpa_hardw_type <= failure;
               fpa_hardw_err <= '1';
            end if; 
            
            -- on vérifie que l'électronique est à jour
            -- if FPA_HARDW_STAT.HARDW_UP2DATE = '1' then
            fpa_hardw_up2date <= success;
            --   fpa_hardw_err <= '0';
            --else
            --   fpa_hardw_up2date <= failure;
            --   fpa_hardw_err <= '1';
            --end if;
            
         else                
            fpa_hardw_up2date <= not_available;
            fpa_hardw_type <= not_available;
            fpa_hardw_err <= '0';            
         end if;
         
      end if;
   end process; 
   
   -----------------------------------------------------------
   -- Vérification des statuts du firmware 
   -----------------------------------------------------------
   U3: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            fpa_vhd_stat_i <= not_available; 
            fpa_softw_stat_i <= not_available;
            fpa_vhd_err <= '0';
            fpa_softw_err <= '0';
         else
            
            -- on vérifie que le design Vhd est conforme à FPA_define(Ceci est requis car tous les defines ont le même nom)
            if FPA_VHD_STAT.DVAL = '1' then               
               if FPA_VHD_STAT.FPA_ROIC = DEFINE_FPA_ROIC and FPA_VHD_STAT.FPA_OUTPUT = DEFINE_FPA_OUTPUT then  
                  fpa_vhd_stat_i <= success;
                  fpa_vhd_err <= '0';
               else
                  fpa_vhd_stat_i <= failure;
                  fpa_vhd_err <= '1';
               end if;
            else
               fpa_vhd_stat_i <= not_available;
               fpa_vhd_err <= '0';
            end if;
            --
            -- on vérifie que les pilotes software (PPC/µBlaze) sont conformes à la definition dans FPA_define
            if FPA_SOFTW_STAT.DVAL = '1' then           -- dval est requis car cela prend du temps au PPC pour envoyer l'info au Hardw
               if FPA_SOFTW_STAT.FPA_ROIC = DEFINE_FPA_ROIC and FPA_SOFTW_STAT.FPA_OUTPUT = DEFINE_FPA_OUTPUT then 
                  fpa_softw_stat_i <= success;
                  fpa_softw_err <= '0';
               else
                  fpa_softw_stat_i <= failure;
                  fpa_softw_err <= '1';
               end if;
            else
               fpa_softw_stat_i <= not_available;  --! requis car il y a un delai avant que l'init de PPC envoie cette information
               fpa_softw_err <= '0';
            end if;
            -- 
         end if;
      end if;
   end process; 
   
   -----------------------------------------------------------
   -- Vérification du statut du refroidisseur de la cfg d'initisalisation
   -----------------------------------------------------------
   -- on vérifie que le refroidisseur est allumé 
   -- on vérifie que la config d'initialisation est prête
   U5: process(CLK)
   begin          
      if rising_edge(CLK) then 
         fpa_cooler_on <= FPA_COOLER_STAT.COOLER_ON;
         fpa_init_cfg_rdy <= (DEFINE_FPA_INIT_CFG_NEEDED and FPA_INTF_CFG.COMN.FPA_INIT_CFG_RECEIVED) or not DEFINE_FPA_INIT_CFG_NEEDED; 
      end if;
   end process;  
   
   -----------------------------------------------------------
   -- Vérification de la temperature du détecteur  
   -----------------------------------------------------------
   -- on vérifie que la température lue est conforme pour 
   -- l'allumage du détecteur
   U6: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if FPA_TEMP_STAT.FPA_PWR_ON_TEMP_REACHED = '1' then
            fpa_temp_stat_i <= success;
         else
            fpa_temp_stat_i <= failure;
         end if;
         
         -- pragma translate_off
         if BYPASS_FPA_PROTECTION = true then
            fpa_temp_stat_i <= success;
         end if;         
         -- pragma translate_on
         
      end if;
   end process;
   
   -----------------------------------------------------------
   -- Compilation des différents statuts pré-allumage  
   -----------------------------------------------------------
   -- on compile les différents statuts pé-allumage 
   U7: process(CLK)
   begin          
      if rising_edge(CLK) then
         
         -- compilation des statuts du hw (type de cartes et mises-à-jour)
         if fpa_hardw_up2date = not_available or fpa_hardw_type = not_available then
            hardw_global_status <= not_available;
         elsif fpa_hardw_up2date = success and fpa_hardw_type = success then
            hardw_global_status <= success;
         else
            hardw_global_status <= failure;
         end if;
         
         -- pragma translate_off
         if BYPASS_FPA_PROTECTION = true then
            hardw_global_status <= success;
         end if;         
         -- pragma translate_on
         
         -- compilation des statuts firmware (vhd et du software (PPC/µBlaze))
         if fpa_softw_stat_i = not_available or fpa_vhd_stat_i = not_available then 
            firmw_global_status <= not_available;
         elsif fpa_softw_stat_i = success and fpa_vhd_stat_i = success then 
            firmw_global_status <= success;                                
         else
            firmw_global_status <= failure;
         end if;
         
         -- pragma translate_off
         if BYPASS_FPA_PROTECTION = true then
            firmw_global_status <= success;
         end if;         
         -- pragma translate_on
         
      end if;      
   end process;     
   
   --------------------------------------------------
   -- Allumage du Flex ou du Proxy  
   -------------------------------------------------- 
   -- il faut que ce soit un process totalement indépendant qui 
   -- s'occupe de l'allumage des cartes sensibles
   U8: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            fpa_power_i <= '0'; 
         else                      
            -- le proxy ou le FPA ne peut s'allumer que ssi : 
            -- 1) le hawdware et le firmare sont conformes
            -- 2) le refroidisseur est en fonction
            -- 3) la température du détecteur est conforme
            -- 4) on reçoit l'ordre d'allumage en provenance du PPC/µBlaze
            -- 5) le statut relatif à la config d'initialisation est conforme
            if hardw_global_status = success and firmw_global_status = success and fpa_temp_stat_i = success then 
               fpa_power_i <= FPA_INTF_CFG.COMN.FPA_PWR_ON and fpa_cooler_on and fpa_init_cfg_rdy; 
            else
               fpa_power_i <= '0';
            end if;            
         end if;
      end if;
   end process;    
   
   --------------------------------------------------
   -- sequenceur
   --------------------------------------------------   
   --
   U9: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            fpa_sequencer_sm <= init_st1;
            trig_ctler_en_i <= '0';
            fpa_driver_en_i <= '0';
            done <= '0';
            diag_mode_only_i <= '0'; 
            
         else             
            
            case fpa_sequencer_sm is 
               
               when init_st1 => 
                  done <= '0';
                  trig_ctler_en_i <= '0';
                  fpa_driver_en_i <= '0';
                  diag_mode_only_i <= '0'; 
                  if firmw_global_status = success then 
                     fpa_sequencer_sm <= init_st2; 
                  else     -- statut non encore disponible ou failure, rien à faire sauf attendre
                  end if;
               
               when init_st2 =>
                  diag_mode_only_i <= '1'; -- si le firmware est correct, au moins le mode diag est possible. 
                  if hardw_global_status = success then                        
                     fpa_sequencer_sm <= idle;
                  elsif hardw_global_status = failure then     
                     fpa_sequencer_sm <= idle;
                  else  -- statut non encore disponible, on attend
                     trig_ctler_en_i <= FPA_INTF_CFG.COMN.FPA_DIAG_MODE; -- le contrôleur de trig est activé si le mode diag est demandé. Sinon , rien ne se passe
                  end if;                  
               
               when idle =>      -- on ne vient ici que lorsqu'au moins le firmware est correct                    
                  done <= '1';
                  if diag_mode_only_i = '1' then   
                     trig_ctler_en_i <= FPA_INTF_CFG.COMN.FPA_DIAG_MODE; -- en mode diag_only le contrôleur de trigs est en fonction ssi le mode diag est demandé.
                  end if;                  
                  if fpa_power_i = '1' then      -- certes fpa_power_i est l'ordre d'allumage mais ne dit pas si le fpa est allumé réellement ou pas. Mais ce n'est pas grave car fpa éteint => fpa_driver_rqst = '0'
                     diag_mode_only_i <= '0';    -- le mode diag n'est plus le seul mode une fois que le détecteur est allumé
                     if fpa_driver_rqst = '1' then 
                        fpa_sequencer_sm <= trig_ctrl_st;
                     end if;
                  else                         
                     diag_mode_only_i <= '1';   -- le mode diag uniquement si le détecteur n'est pas encore allumé (cooldown ou pas d'ordre d'allumage)
                  end if;                    
               
               when trig_ctrl_st =>  -- si on vient ici, c'est que le détecteur est allumé et qu'on veuille le programmer
                  if PROG_FREE_RUNNING_TRIG = '1' then   -- en mode free_running_trig, il n'est pas necessaire d'arrêter le contrôleur de trig avant programmation
                     fpa_sequencer_sm <= active_prog_st;
                     trig_ctler_en_i <= '1';  -- on s'assure que les trigs sont envoyés au détecteur avant de le programmer (cas des scd par exemple)
                  else                     
                     fpa_sequencer_sm <= wait_trig_done_st;
                     trig_ctler_en_i <= '0'; -- on arrete tout trig avant de programmer le détecteur (cas de plusieurs détecteurs analogiques)
                  end if;
               
               when wait_trig_done_st =>    
                  if trig_ctler_done = '1' then 
                     fpa_sequencer_sm <= wait_dpath_done_st;
                  end if;
               
               when wait_dpath_done_st =>
                  if frm_in_progress = '0' then 
                     fpa_sequencer_sm <= active_prog_st;
                  end if;
               
               when active_prog_st =>                -- on programme le FPA
                  fpa_driver_en_i <= '1';
                  if fpa_driver_done = '0' then 
                     fpa_sequencer_sm <= wait_prog_end_st;
                  end if;    
               
               when wait_prog_end_st =>        -- on attend la fin de la programmation                
                  fpa_driver_en_i <= '0';    
                  if fpa_driver_done = '1' then 
                     fpa_sequencer_sm <= trig_en_st;
                  end if; 
               
               when trig_en_st =>            -- on permet les integrations 
                  trig_ctler_en_i <= '1';
                  fpa_sequencer_sm <= idle; 
               
               when others =>                                    
               
            end case;      
            
         end if;
      end if;
   end process;
   
end RTL;
