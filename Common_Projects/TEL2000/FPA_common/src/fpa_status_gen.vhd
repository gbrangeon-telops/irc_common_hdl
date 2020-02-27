------------------------------------------------------------------
--!   @file fpa_status_gen
--!   @brief collecteur des statuts des sous-modules
--!   @details ce module collecte les statuts de tous les sous modules et en génère des statuts standards
--! 
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_misc.all;
use work.fpa_common_pkg.all;
use work.fpa_define.all;
use work.proxy_define.all;
use work.fpa_serdes_define.all;
use work.tel2000.all;   


entity fpa_status_gen is
   port(
      
      ARESET           : in std_logic;
      MB_CLK           : in std_logic;
      FPA_INTF_CLK     : in std_logic;
      
      FPA_INTF_CFG     : in fpa_intf_cfg_type;
      
      FPA_SERDES_STAT  : in fpa_serdes_stat_type;
      TRIG_CTLER_STAT  : in std_logic_vector(7 downto 0);
      FPA_DRIVER_STAT  : in std_logic_vector(31 downto 0);
      INTF_SEQ_STAT    : in std_logic_vector(7 downto 0);
      DATA_PATH_STAT   : in std_logic_vector(15 downto 0);
      
      FPA_TEMP_STAT    : in fpa_temp_stat_type;
      FPA_COOLER_STAT  : in fpa_cooler_stat_type; 
      
      FPA_HARDW_STAT   : in fpa_hardw_stat_type;
      
      MISC_STAT        : in misc_stat_type;
      
      MISC_STAT_MOSI   : in t_axi4_lite_mosi;               -- statut divers envoyés en dual port ram 
      MISC_STAT_MISO   : out t_axi4_lite_miso;              -- statut divers envoyés en dual port ram 	  
      
      RESET_ERR        : in std_logic;
      FPA_INTF_ERR     : out std_logic_vector(31 downto 0); -- decodage de toutes les erreurs
      ERR_FOUND        : out std_logic;                     -- monte à '1' si erreur trouvée et y reste. C'est le PPC qui peut effacer cette erreur      
      
      STATUS_MOSI      : in t_axi4_lite_mosi;
      STATUS_MISO      : out t_axi4_lite_miso
      );
end fpa_status_gen;


architecture rtl of fpa_status_gen is
   signal sreset_fpa_intf_clk          : std_logic;
   signal sreset_mb_clk                : std_logic;
   signal reset_err_i                  : std_logic;
   signal done_i                       : std_logic;
   signal error                        : std_logic_vector(31 downto 0);
   signal error_latch                  : std_logic_vector(31 downto 0);  
   signal fpa_seq_softw_err            : std_logic;
   signal fpa_seq_vhd_err              : std_logic;
   signal fpa_seq_hardw_err            : std_logic;
   signal fpa_seq_init_done            : std_logic;
   signal dpath_proxy_err              : std_logic;
   signal dpath_dout_fifo_err          : std_logic;
   signal dpath_dval_gen_err           : std_logic;
   signal dpath_fpa_cfg_mismatch       : std_logic;
   signal dpath_speed_err              : std_logic;
   signal dpath_samp_sum_or_mean_err   : std_logic;
   signal dpath_samp_sel_err           : std_logic;
   signal dpath_samp_cnt_err           : std_logic;
   signal dpath_done                   : std_logic;
   signal fpa_serdes_done              : std_logic_vector(fpa_serdes_stat_type.done'range);
   signal fpa_serdes_success           : std_logic_vector(fpa_serdes_stat_type.success'range);
   signal fpa_serdes_delay             : delay_array;
   signal fpa_serdes_edges             : edges_array;
   signal trig_ctler_done              : std_logic;
   signal fpa_powered                  : std_logic;
   signal fpa_driver_rqst              : std_logic;
   signal fpa_driver_seq_err           : std_logic;
   signal fpa_driver_done              : std_logic;
   signal fpa_cfg_err                  : std_logic;
   signal fpa_driver_trig_err          : std_logic;
   signal fpa_driver_ram_err           : std_logic;
   signal fpa_temperature_raw          : std_logic_vector(31 downto 0);
   signal cooler_volt_min_mV_in        : std_logic_vector(15 downto 0);
   signal cooler_volt_max_mV_in        : std_logic_vector(15 downto 0);
   signal cooler_on_curr_min_mA_in     : std_logic_vector(15 downto 0);
   signal cooler_off_curr_max_mA_in    : std_logic_vector(15 downto 0);
   
   signal cooler_volt_min_mV_out       : std_logic_vector(15 downto 0);
   signal cooler_volt_max_mV_out       : std_logic_vector(15 downto 0);
   signal cooler_on_curr_min_mA_out    : std_logic_vector(15 downto 0);
   signal cooler_off_curr_max_mA_out   : std_logic_vector(15 downto 0);
   
   signal cooler_powered               : std_logic;
   signal global_done                  : std_logic;
   signal fpa_hw_init_done             : std_logic;
   signal fpa_hw_init_success          : std_logic;
   signal error_found                  : std_logic;
   signal stat_read_add                : std_logic_vector(15 downto 0);
   signal stat_read_reg                : std_logic_vector(31 downto 0);
   signal stat_read_dval               : std_logic;
   signal stat_read_err                : std_logic;
   signal fpa_driver_dvalid_err        : std_logic;
   -- pour le power management de DAL
   signal adc_ddc_detect_process_done    : std_logic := '0';
   signal adc_ddc_present                : std_logic := '0';
   signal flex_flegx_detect_process_done : std_logic := '0';
   signal flex_flegx_present             : std_logic;
   signal acq_trig_done                  : std_logic;
   signal fpa_permit_int_change          : std_logic;
   signal fpa_prog_init_done             : std_logic;
   signal fpa_driver_cmd_in_err          : std_logic_vector(7 downto 0);
   signal flegx_present                  : std_logic;
   signal fpa_readout_err                : std_logic_vector(1 downto 0); 
   signal cooler_param_valid             : std_logic := '0';
   signal fpa_seq_success                : std_logic;
   
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   --   component ram_dp is
   --      generic(
   --         D_WIDTH : integer := 16;
   --         A_WIDTH : integer := 8);
   --      port (
   --         clk   : in std_logic;
   --         we    : in std_logic;                              -- Synchronous Write Enable (Active High)
   --         add   : in std_logic_vector(A_WIDTH-1 downto 0);   -- Write Address/Primary Read Address
   --         dpra  : in std_logic_vector(A_WIDTH-1 downto 0);   -- Dual Read Address
   --         din   : in std_logic_vector(D_WIDTH-1 downto 0);   -- Data Input
   --         dout  : out std_logic_vector(D_WIDTH-1 downto 0);  -- Primary Output Port
   --         dpo   : out std_logic_vector(D_WIDTH-1 downto 0)); -- Dual Output Port 
   --   end component;
   --   
   
begin                 
   
   
   --output map
   FPA_INTF_ERR <= error_latch;
   ERR_FOUND <= error_found;
   
   -- MISO
   STATUS_MISO.ARREADY <= '1';
   STATUS_MISO.RRESP   <= AXI_OKAY;         
   STATUS_MISO.RVALID  <= stat_read_dval;
   STATUS_MISO.RDATA   <= stat_read_reg;
   
   --------------------------------------------
   -- SYNC_RESET
   --------------------------------------------
   U1A : sync_reset
   port map(ARESET => ARESET, SRESET => sreset_fpa_intf_clk, CLK => FPA_INTF_CLK); 	
   U1B : sync_reset
   port map(ARESET => ARESET, SRESET => sreset_mb_clk, CLK => MB_CLK); 	
   
   -----------------------------------------------
   -- Inputs maps: INTF_SEQ_STAT 
   -----------------------------------------------
   fpa_seq_success     <= INTF_SEQ_STAT(4);
   fpa_seq_softw_err   <= INTF_SEQ_STAT(3);
   fpa_seq_vhd_err     <= INTF_SEQ_STAT(2);
   fpa_seq_hardw_err   <= INTF_SEQ_STAT(1);
   fpa_seq_init_done   <= INTF_SEQ_STAT(0);
   
   -----------------------------------------------
   -- Inputs maps:  DATA_PATH_STAT
   -----------------------------------------------
   dpath_proxy_err            <= DATA_PATH_STAT(8);   -- dfpa
   dpath_dout_fifo_err        <= DATA_PATH_STAT(7);   -- dfpa and afpa
   dpath_dval_gen_err         <= DATA_PATH_STAT(6);   -- dfpa and afpa
   dpath_fpa_cfg_mismatch     <= DATA_PATH_STAT(5);   -- dfpa.  (fpa_cfg_mismatch n'est pas une erreur. Il signale au FPA_DRIVER une differenece de config suite à une reprogrammation). 
   dpath_speed_err            <= DATA_PATH_STAT(4);   -- dfpa and afpa
   dpath_samp_sum_or_mean_err <= DATA_PATH_STAT(3);   -- afpa    
   dpath_samp_sel_err         <= DATA_PATH_STAT(2);   -- afpa     
   dpath_samp_cnt_err         <= DATA_PATH_STAT(1);   -- afpa     
   dpath_done                 <= DATA_PATH_STAT(0);   -- dfpa and afpa
   
   -----------------------------------------------
   -- Inputs maps: FPA_SERDES_STAT 
   -----------------------------------------------
   fpa_serdes_done <= FPA_SERDES_STAT.done;
   fpa_serdes_success <= FPA_SERDES_STAT.success;
   fpa_serdes_delay <= FPA_SERDES_STAT.delay;
   fpa_serdes_edges <= FPA_SERDES_STAT.edges;
   
   -----------------------------------------------
   -- Inputs maps:  TRIG_CTLER_STAT
   -----------------------------------------------
   acq_trig_done   <= TRIG_CTLER_STAT(3);             -- à '1' ssi aucun acq_trig n'est en cours de traitement dans le module FPA. 
   trig_ctler_done <= TRIG_CTLER_STAT(0);             -- 
   
   -----------------------------------------------
   -- FPA_DRIVER_STAT                             
   -----------------------------------------------
   fpa_readout_err(1)    <= FPA_DRIVER_STAT(19);
   fpa_readout_err(0)    <= FPA_DRIVER_STAT(18);
   fpa_prog_init_done    <= FPA_DRIVER_STAT(17);            -- monte à '1' lorsque la config d'initialisation est programmée dans le ROIC. Ce qui est intéressant pour les ROIC necessitant une config d'initialisation 
   fpa_driver_dvalid_err <= FPA_DRIVER_STAT(16);            -- upour les sofradir: un fpa_data_valid est manquant après integration
   fpa_driver_cmd_in_err <= FPA_DRIVER_STAT(15 downto 8);   -- pour les détecteurs numériques principalement, c'est l'ID de la cmd en erreur
   fpa_permit_int_change <= FPA_DRIVER_STAT(7);
   fpa_driver_trig_err   <= FPA_DRIVER_STAT(6);
   fpa_driver_ram_err    <= FPA_DRIVER_STAT(5);
   fpa_powered           <= FPA_DRIVER_STAT(4);        -- dit si le Fpa est effectivement allumé ou pas
   fpa_driver_seq_err    <= FPA_DRIVER_STAT(3);
   fpa_cfg_err           <= FPA_DRIVER_STAT(2);
   fpa_driver_rqst       <= FPA_DRIVER_STAT(1);
   fpa_driver_done       <= FPA_DRIVER_STAT(0);    
   
   -----------------------------------------------
   -- Inputs maps:  FPA_TEMP_STAT                               
   -----------------------------------------------
   fpa_temperature_raw <= FPA_TEMP_STAT.TEMP_DATA when FPA_TEMP_STAT.TEMP_DVAL = '1' else (others => '1');  -- others ('1' assure que la temperature sera aberrante si non mis-à-jour par le détecteur)
   
   -----------------------------------------------   
   -- FPA_COOLER_STAT                             
   -----------------------------------------------
   -- aussitôt qu'il y a une erreur de type hardware ou firmware, le voltage de reference du cooler renvoyé au µblaze est nulle.
   -- Avec une un voltage de reference nulle, impossible d'allumer le cooler
   cooler_volt_min_mV_in      <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.IDDCA_INFO.COOLER_VOLT_MIN_mV,cooler_volt_min_mV_in'length));
   cooler_volt_max_mV_in      <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.IDDCA_INFO.COOLER_VOLT_MAX_mV,cooler_volt_max_mV_in'length));
   cooler_on_curr_min_mA_in   <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.IDDCA_INFO.COOLER_ON_CURR_MIN_mA,cooler_on_curr_min_mA_in'length));
   cooler_off_curr_max_mA_in  <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.IDDCA_INFO.COOLER_OFF_CURR_MAX_mA,cooler_off_curr_max_mA_in'length));
   
   U2 : process(FPA_INTF_CLK) 
   begin
      if rising_edge(FPA_INTF_CLK) then
         
         if fpa_seq_hardw_err = '0' and fpa_seq_vhd_err = '0' and fpa_seq_softw_err = '0' and FPA_HARDW_STAT.DVAL = '1' then 
            cooler_param_valid <= '1';
         end if;
         
         if cooler_param_valid = '1' then   
            cooler_volt_min_mV_out     <= cooler_volt_min_mV_in; 
            cooler_volt_max_mV_out     <= cooler_volt_max_mV_in;
            cooler_on_curr_min_mA_out  <= cooler_on_curr_min_mA_in;
            cooler_off_curr_max_mA_out <= cooler_off_curr_max_mA_in;
            
         else
            cooler_volt_min_mV_out <= std_logic_vector(to_unsigned(1, cooler_volt_min_mV_out'length)); -- le min est superieur au max, cas absurde, on ne peut donc allumer le cooler 
            cooler_volt_max_mV_out <= std_logic_vector(to_unsigned(0, cooler_volt_min_mV_out'length)); --
            cooler_on_curr_min_mA_out <= std_logic_vector(to_unsigned(8000, cooler_on_curr_min_mA_out'length));
            cooler_off_curr_max_mA_out <= std_logic_vector(to_unsigned(8000, cooler_off_curr_max_mA_out'length));
         end if;
         
         cooler_powered <= FPA_COOLER_STAT.COOLER_ON;
      end if;
   end process;
   
   -----------------------------------------------   
   -- Statut flex et ADC                         
   -----------------------------------------------
   -- ces assignations sont faites pour le power management 
   -- et doivent Être revues avec les detecteurs analogiques
   UP : process(FPA_INTF_CLK) 
   begin
      if rising_edge(FPA_INTF_CLK) then
         
         -- adc_ddc
         if FPA_HARDW_STAT.DVAL = '1' then
            adc_ddc_detect_process_done <= FPA_HARDW_STAT.DVAL;
            if FPA_HARDW_STAT.IDDCA_INFO /= IDDCA_INFO_UNKNOWN then 
               adc_ddc_present <= '1';
            else                   
               adc_ddc_present <= '0';
            end if;
         end if;
         
         -- flex ou flegx
         if FPA_HARDW_STAT.DVAL = '1' then 
            flex_flegx_detect_process_done <= '1';
            if FPA_HARDW_STAT.FLEX_BRD_INFO /= FLEX_BRD_INFO_UNKNOWN then 
               flex_flegx_present <= '1';
               flegx_present <= FPA_HARDW_STAT.FLEX_BRD_INFO.FLEGX_BRD_PRESENT;
            else                   
               flex_flegx_present <= '0';
               flegx_present <= '0';
            end if; 
         end if;     
         
      end if;
   end process;
   
   ----------------------------------------------
   -- PROCESS  de gestion des erreurs
   ---------------------------------------------
   U3 : process(FPA_INTF_CLK) 
   begin
      if rising_edge(FPA_INTF_CLK) then
         if sreset_fpa_intf_clk = '1' then
            global_done <= '0';
            fpa_hw_init_done <= '0';
            fpa_hw_init_success <= '0';
            error_latch <= (others => '0');
            error <= (others => '0');
            error_found <= '0';
            reset_err_i <= '0';
         else 
            
            reset_err_i <= RESET_ERR;
            
            -- statut : signal done  
            global_done <= acq_trig_done;-- fpa_seq_done, fpa_driver_done, trig_ctler_done ne comptent pas parmi le global_done
            
            -- hw init status: 
            fpa_hw_init_done <= and_reduce(fpa_serdes_done) and fpa_seq_init_done;
            fpa_hw_init_success <= and_reduce(fpa_serdes_success) and fpa_seq_success;
            
            -- les erreurs à latcher (connecter les signaux des erreurs ici)
            error(31 downto 18) <= (others => '0');  -- non utilisés 
            error(17) <= fpa_readout_err(1);
            error(16) <= fpa_readout_err(0);
            error(15) <= fpa_driver_dvalid_err;
            error(14) <= fpa_driver_trig_err;
            error(13) <= fpa_driver_ram_err;
            error(12) <= fpa_driver_seq_err;
            error(11) <= fpa_cfg_err;
            error(10) <= stat_read_err;
            error(9)  <= fpa_seq_softw_err;
            error(8)  <= fpa_seq_vhd_err;
            error(7)  <= fpa_seq_hardw_err;
            error(6)  <= dpath_proxy_err;
            error(5)  <= dpath_dout_fifo_err;
            error(4)  <= dpath_dval_gen_err;
            error(3)  <= dpath_speed_err;
            error(2)  <= dpath_samp_sum_or_mean_err; 
            error(1)  <= dpath_samp_sel_err; 
            error(0)  <= dpath_samp_cnt_err;  
            
            -- latch des erreurs
            for i in 0 to error'length-1 loop
               if error(i) = '1'  then  
                  error_latch(i)  <=  '1';
               end if;                                 
            end  loop;
            
            -- gestion du latch
            if reset_err_i = '1' then 
               error_found <= '0';
               error_latch <= (others => '0');
            else
               if error /= (error'length-1 downto 0 => '0') then
                  error_found <= '1';         
               end if;
            end if;
            
         end if;
      end if;
   end process;  
   
   ---------------------------------------------
   -- MAPPING Adresses des statuts
   ---------------------------------------------
   -- 0x0000 à 0x00FF reservées aux statuts communs à tous les détecteurs
   -- 0x0100 à RAM_END reservées aux statuts spécifiques aux détecteurs (numériques principalement) Non implémenté pour le moment
   
   -- Mapping partie commune (0x0000 à 0x00FC)
   
   --    0x0000 -> adc board rev                   -- voir fpa_hardw_stat_type dans fichier fpa_common_pkg pour details sur la donnée
   --    0x0004 -> adc board firw revision         --
   --    0x0008 -> adc board bootup tests status   --
   --    0x000C -> adc status spare                --
   
   --    0x0010 -> ddc board rev                   -- voir fpa_hardw_stat_type dans fichier fpa_common_pkg pour details sur la donnée
   --    0x0014 -> ddc board firw revision         --
   --    0x0018 -> ddc bootup tests status         --
   --    0x001C -> ddc status spare                --
   
   
   --    0x0020 -> flex board rev                  -- voir fpa_hardw_stat_type dans fichier fpa_common_pkg pour details sur la donnée
   --
   --    0x0024 -> cooler_volt_min_out             -- Tension Minimale au-dessus duquel allumer Cooler. Provient du fichier FPA_define puis redefini dans le présent fichier
   --    0x0028 -> cooler_volt_max_out             -- Tension Maximale en-dessous duquel allumer Cooler. Provient du fichier FPA_define puis redefini dans le présent fichier 
   --    0x002C -> fpa temperature raw             -- temperature raw du FPA
   
   --    0x0030 -> Global done                     -- defini dans le présent fichier
   --    0x0034 -> FPA Powered                     -- defini dans le présent fichier
   --    0x0038 -> Cooler Powered                  -- 
   --    0x003C -> erreurs latchées                -- definies dans le présent fichier
   
   --    0x0040 -> INTF_SEQ_STAT                   -- definies dans le présent fichier
   --    0x0044 -> DATA_PATH_STAT                  -- definies dans le présent fichier
   --    0x0048 -> TRIG_CTLER_STAT                 -- definies dans le présent fichier
   --    0x004C -> FPA_DRIVER_STAT                 -- definies dans le présent fichier
   
   --    0x0050 -> non utilisé (et donc disponible)
   --    ...    -> non utilisé (et donc disponible)
   --    0x00FC -> non utilisé (et donc disponible)
   
   -----------------------------------------------
   -- Adresses des statuts
   -----------------------------------------------
   -- MOSI
   stat_read_add <= STATUS_MOSI.ARADDR(15 downto 0);
   
   U4 : process(MB_CLK) 
   begin
      if rising_edge(MB_CLK) then
         if sreset_mb_clk = '1' then 
            stat_read_err <= '0';
            stat_read_dval <= '0';
         else
            
            stat_read_dval <= STATUS_MOSI.ARVALID;
            
            -- erreur grave
            stat_read_err <= stat_read_dval and not STATUS_MOSI.RREADY; -- le microblaze n'a pas écouté la réponse.
            
            case  stat_read_add is
               -- ADC BRD
               when  x"0000" =>   -- frequence maximale d'operation des adcs soudées sur la carte EFA-00253-XXX  (lié à l'ID)
                  stat_read_reg <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.ADC_BRD_INFO.ADC_OPER_FREQ_MAX_KHZ,32));
                  -- pragma translate_off
                  stat_read_reg <= std_logic_vector(to_unsigned(60,32));
                  -- pragma translate_on
               
               when  x"0004" =>    -- nombre de canaux au total disponible sur la carte (lié à l'ID)
                  stat_read_reg <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.ADC_BRD_INFO.ANALOG_CHANNEL_NUM,32));
               
               when  x"0008" =>   -- résoltuion des ADC soudés sur la carte (provient du mode diagnostic des adcs)
                  stat_read_reg <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.ADC_BRD_INFO.ADC_RESOLUTION,32));
               
               when  x"000C" =>   --  status spare for promimity electronics
                  stat_read_reg(31 downto 1) <= (others => '0');
                  stat_read_reg(0) <= flegx_present;
                  
               -- DDC_BRD 
               when  x"0010" =>   -- fpa roic
                  stat_read_reg <= resize(FPA_HARDW_STAT.DDC_BRD_INFO.FPA_ROIC, 32);
               
               when  x"0014" =>   -- ddc spare
                  stat_read_reg <=  (others => '0');
                  
               -- FLEX_BRD 
               when  x"0018" =>   -- fpa_roic
                  stat_read_reg <= resize(FPA_HARDW_STAT.FLEX_BRD_INFO.FPA_ROIC, 32);
               
               when  x"001C" =>   -- fpa_input
                  stat_read_reg <= resize(FPA_HARDW_STAT.FLEX_BRD_INFO.FPA_INPUT, 32);
               
               when  x"0020" =>   -- chn_diversity_num
                  stat_read_reg <= std_logic_vector(to_unsigned(FPA_HARDW_STAT.FLEX_BRD_INFO.CHN_DIVERSITY_NUM, 32));
                  
               -- COOLER
               when  x"0024" =>   -- cooler voltage min
                  stat_read_reg <= resize(cooler_volt_min_mV_out, 32);
               
               when  x"0028" =>   -- cooler voltage max
                  stat_read_reg <= resize(cooler_volt_max_mV_out, 32);
               
               when  x"002C" =>   -- fpa_temperature_raw
                  stat_read_reg <=  fpa_temperature_raw;
               
               when  x"0030" =>   -- global done
                  stat_read_reg <= resize('0' & global_done, 32);
               
               when  x"0034" =>   -- FPA powered
                  stat_read_reg <= resize('0' & fpa_powered, 32);
               
               when  x"0038" =>   -- cooler powered
                  stat_read_reg <= resize('0' & cooler_powered, 32);
               
               when  x"003C" =>   -- erreurs latchées
                  stat_read_reg <= error_latch;
                  
                  --               when  x"0040" =>   -- INTF_SEQ_STAT
                  --                  stat_read_reg <= resize(INTF_SEQ_STAT, 32);
                  --               
                  --               when  x"0044" =>   -- DATA_PATH_STAT
                  --                  stat_read_reg <= resize(DATA_PATH_STAT, 32);
                  --               
                  --               when  x"0048" =>   -- TRIG_CTLER_STAT
                  --                  stat_read_reg <= resize(TRIG_CTLER_STAT, 32);
                  --               
                  --               when  x"004C" =>   -- FPA_DRIVER_STAT
                  --                  stat_read_reg <= resize(FPA_DRIVER_STAT, 32);
                  
               -- pour le power management de DAL   
               when  x"0050" =>   -- adc_ddc_detect_process_done
                  stat_read_reg <= resize('0'& adc_ddc_detect_process_done, 32); 
               
               when  x"0054" =>   -- adc_ddc_present
                  stat_read_reg <= resize('0'& adc_ddc_present, 32);
               
               when  x"0058" =>   -- flex_flegx_detect_process_done
                  stat_read_reg <= resize('0'& flex_flegx_detect_process_done, 32); 
               
               when  x"005C" =>   -- flex_flegx_present
                  stat_read_reg <= resize('0'& flex_flegx_present, 32);
                  -----------------------------------
               
               when  x"0060" =>   -- cmd en erreur
                  stat_read_reg <= resize(fpa_driver_cmd_in_err, 32);
                  
               -- FPA_SERDES_STAT
               when  x"0064" =>   -- fpa serdes done
                  stat_read_reg <=  resize(fpa_serdes_done, 32);
               
               when  x"0068" =>   -- fpa serdes success
                  stat_read_reg <=  resize(fpa_serdes_success, 32);
               
               when  x"006C" =>   -- fpa serdes delay
                  stat_read_reg <=  resize(fpa_serdes_delay(3), 8) & 
                  resize(fpa_serdes_delay(2), 8) & 
                  resize(fpa_serdes_delay(1), 8) & 
                  resize(fpa_serdes_delay(0), 8);
               
               when  x"0070" =>   -- fpa serdes edges ch0
                  stat_read_reg <=  resize(fpa_serdes_edges(0), 32);
               
               when  x"0074" =>   -- fpa serdes edges ch1
                  stat_read_reg <=  resize(fpa_serdes_edges(1), 32);
               
               when  x"0078" =>   -- fpa serdes edges ch2
                  stat_read_reg <=  resize(fpa_serdes_edges(2), 32);
               
               when  x"007C" =>   -- fpa serdes edges ch3
                  stat_read_reg <=  resize(fpa_serdes_edges(3), 32);
                  
               -- FPA init status
               when  x"0080" =>   -- fpa init done
                  stat_read_reg <=  (0 => fpa_hw_init_done, others => '0');
               
               when  x"0084" =>   -- fpa init success
                  stat_read_reg <=  (0 => fpa_hw_init_success, others => '0');
               
               when  x"0088" =>   -- prog_init_done
                  stat_read_reg <=  (0 => fpa_prog_init_done, others => '0');
               
               when  x"008C" =>   -- cooler_on_curr_min_mA_out
                  stat_read_reg <= resize(cooler_on_curr_min_mA_out, 32);
               
               when  x"0090" =>   -- cooler_off_curr_max_mA_out
                  stat_read_reg <= resize(cooler_off_curr_max_mA_out, 32);                  
                  
               ---- watchdog data
               when  x"0094" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.acq_trig_cnt, 32);  
               
               when  x"0098" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.acq_int_cnt, 32);                        
               
               when  x"009C" =>   --                                                           
                  stat_read_reg <= resize(MISC_STAT.fpa_readout_cnt, 32);                     
               
               when  x"00A0" =>   --                                                           
                  stat_read_reg <= resize(MISC_STAT.acq_readout_cnt, 32);
               
               when  x"00A4" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.out_pix_cnt_min, 32);
               
               when  x"00A8" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.out_pix_cnt_max, 32);
               
               when  x"00AC" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.trig_to_int_delay_min, 32);
               
               when  x"00B0" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.trig_to_int_delay_max, 32);
               
               when  x"00B4" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.int_to_int_delay_min, 32);
               
               when  x"00B8" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.int_to_int_delay_max, 32);
               
               when  x"00BC" =>   -- 
                  stat_read_reg <= resize(MISC_STAT.fast_hder_cnt, 32);
               
               when others  => stat_read_reg <= (others => '0');
               
            end case;
            
         end if;
      end if;
   end process;
   
   
   -- Mapping partie specifique (0x0100 à 0x03FC)
   --    Pour l'instant, pas mplémenté. Mais si cela doit l'être, y mettre les headers complets des images des detecteurs numériques 
   
   
   
end rtl;














