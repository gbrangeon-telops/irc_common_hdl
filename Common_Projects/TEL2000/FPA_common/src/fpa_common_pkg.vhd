---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-- $Id$
-- $URL$
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;

package fpa_common_pkg is
   
   
   -------------------------------------------------------------------------- 
   -- les types de FPA
   --------------------------------------------------------------------------
   -- Pour toutes  les cartes EFA-00251-ZZZ, EFA-00253-ZZZ 
   constant FPA_ROIC_MARS          : std_logic_vector(7 downto 0) := x"10";       -- 
   constant FPA_ROIC_ISC0209       : std_logic_vector(7 downto 0) := x"11";       -- 
   constant FPA_ROIC_ISC0207       : std_logic_vector(7 downto 0) := x"12";       -- 
   constant FPA_ROIC_HAWK          : std_logic_vector(7 downto 0) := x"13";       -- 
   constant FPA_ROIC_HERCULES      : std_logic_vector(7 downto 0) := x"14";       -- 
   constant FPA_ROIC_JUPITER       : std_logic_vector(7 downto 0) := x"15";
   constant FPA_ROIC_PELICAND      : std_logic_vector(7 downto 0) := x"16";       -- pelicanD originel sur carte 254
   constant FPA_ROIC_BLACKBIRD1280 : std_logic_vector(7 downto 0) := x"16";       
   constant FPA_ROIC_BLACKBIRD1920 : std_logic_vector(7 downto 0) := x"16"; 
   constant FPA_ROIC_SCD_PROXY1    : std_logic_vector(7 downto 0) := x"16";       -- regroupe Pelican et BlackBird1280 sur carte 273
   constant FPA_ROIC_SCD_PROXY2    : std_logic_vector(7 downto 0) := x"16";       -- Scd proxy2 regroupe BB1920_90Hz, BB1920_115Hz, BB1920_120Hz
   
   constant FPA_ROIC_SCORPIO_LW    : std_logic_vector(7 downto 0) := x"17";
   constant FPA_ROIC_SCORPIO_MW    : std_logic_vector(7 downto 0) := x"18";
   constant FPA_ROIC_ISC0804       : std_logic_vector(7 downto 0) := x"19"; 
   constant FPA_ROIC_SUPHAWK       : std_logic_vector(7 downto 0) := x"20";
   constant FPA_ROIC_XRO3503       : std_logic_vector(7 downto 0) := x"21";
   constant FPA_ROIC_UNKNOWN       : std_logic_vector(7 downto 0) := x"FF";       --  interface inconnue 
   
   -------------------------------------------------------------------------- 
   -- les types de PROXY (détecteurs numériques)
   --------------------------------------------------------------------------
   constant PROXY_MGLK          : std_logic_vector(2 downto 0) := "000";
   constant PROXY_SCD           : std_logic_vector(2 downto 0) := "001";
   constant PROXY2_SCD          : std_logic_vector(2 downto 0) := "010";
   
   -------------------------------------------------------------------------- 
   -- les Gains de FPA dans le module FPA_INTF (FPAs analogiques)
   --------------------------------------------------------------------------
   --constant FPA_GAIN_0          : std_logic_vector(7 downto 0) := x"00";       -- plus gros puits
   --constant FPA_GAIN_1          : std_logic_vector(7 downto 0) := x"01";       -- 
   --constant FPA_GAIN_2          : std_logic_vector(7 downto 0) := x"02"; 
   --constant FPA_GAIN_3          : std_logic_vector(7 downto 0) := x"03"; 
   --constant FPA_GAIN_4          : std_logic_vector(7 downto 0) := x"04"; 
   --constant FPA_GAIN_5          : std_logic_vector(7 downto 0) := x"05"; 
   --constant FPA_GAIN_6          : std_logic_vector(7 downto 0) := x"06"; 
   --constant FPA_GAIN_7          : std_logic_vector(7 downto 0) := x"07";      -- 
   
   -------------------------------------------------------------------------- 
   -- les modes du contrôleur de trig
   --------------------------------------------------------------------------
   -- dépendamment des détecteurs, nous avons plusieurs façons de contrôler les delais interTrigs 
   -- et donc la periode minimale des trigs
   constant MODE_READOUT_END_TO_TRIG_START      : std_logic_vector(7 downto 0) := x"00";       -- delai pris en compte = fin du readout jusqu'au prochain trig d'integration 
   constant MODE_TRIG_START_TO_TRIG_START       : std_logic_vector(7 downto 0) := x"01";       -- delai pris en compte = periode entre le trig actuel et le prochain
   constant MODE_INT_END_TO_TRIG_START          : std_logic_vector(7 downto 0) := x"02";       -- delai pris en compte = fin de l'integration jusqu'au prochain trig d'integration 
   constant MODE_ITR_TRIG_START_TO_TRIG_START   : std_logic_vector(7 downto 0) := x"03";       -- delai pris en compte = periode entre le trig actuel et le prochain. Une fois ce delai observé, on s'assure que le readout est terminé avant de considerer le prochain trig.
   constant MODE_ITR_INT_END_TO_TRIG_START      : std_logic_vector(7 downto 0) := x"04";       -- delai pris en compte = fin de l'integration jusqu'au prochain trig d'integration. Une fois ce delai observé, on s'assure que le readout est terminé avant de considerer le prochain trig.
   constant MODE_ALL_END_TO_TRIG_START          : std_logic_vector(7 downto 0) := x"05";       -- delai pris en compte = fin de l'integration / readout (selon le plus long des deux) jusqu'au prochain trig d'integration. 
   -------------------------------------------------------------------------- 
   -- les types de sortie de l,iDDCA FPA
   --------------------------------------------------------------------------
   -- Pour toutes  les cartes EFA-00251-ZZZ, EFA-00253-ZZZ
   constant OUTPUT_UNKNOWN   : std_logic_vector(1 downto 0) := "00"; 
   constant OUTPUT_ANALOG    : std_logic_vector(1 downto 0) := "01";
   constant OUTPUT_DIGITAL   : std_logic_vector(1 downto 0) := "10";
   
   -------------------------------------------------------------------------- 
   -- les types de signaux de contrôle
   --------------------------------------------------------------------------
   -- Pour toutes  les cartes EFA-00251-ZZZ, EFA-00253-ZZZ
   constant INPUT_UNKNOWN    : std_logic_vector(7 downto 0) := x"00";    --
   constant LVDS25           : std_logic_vector(7 downto 0) := x"01";    -- Differentielle LVDS 2.5V 
   constant LVDS33           : std_logic_vector(7 downto 0) := x"02";    -- Differentielle LVDS 3.3V
   constant LVTTL50          : std_logic_vector(7 downto 0) := x"03";    -- single ended LVTTL 5.0V  
   constant LVCMOS33         : std_logic_vector(7 downto 0) := x"04";    -- single ended LVCMOS 3.3V
   constant LVCMOS25         : std_logic_vector(7 downto 0) := x"06";    -- single ended LVCMOS 2.5V
   
   --------------------------------------------------------------------------
   -- les sources de données  
   --------------------------------------------------------------------------
   constant DATA_SOURCE_INSIDE_FPGA  : std_logic := '0';                 -- dit que la source de données est interne au FPGA (mode patron de tests Telops)
   constant DATA_SOURCE_OUTSIDE_FPGA : std_logic := '1';                 -- dit que la source de données est externe au FPGA (ADc par exemple))
   
   --------------------------------------------------------------------------
   -- Les frequences de reconnaissance des IDDCAs (en coups de clocks 100 MHz)   
   --------------------------------------------------------------------------
   -- se referer au fichier F:\Bibliotheque\Détecteurs\Informations controlees\MISC\Detector_Freq_ID\Frequence_de_reconnaissance_des_IDDCA.xlsx
   type freq_id_type is 
   record
      freq_id_min  : natural;    -- nombre de coups d'horloges de 100 MHz de la valeur minimale de la frequence id 
      freq_id_max  : natural;    -- nombre de coups d'horloges de 100 MHz de la valeur maximale de la frequence id   
   end record freq_id_type;
   
   constant  ID_DIGITAL_SCD_PROXY1_INPUT_LVDS25_COOL_20V_TO_28V            : freq_id_type := (31746, 35088);   --  3.0 KHz, Digital SCD_PROXY1
   constant  ID_DIGITAL_SCD_PROXY2_INPUT_LVDS25_COOL_20V_TO_28V            : freq_id_type := (31746, 35088);   --  3.0 KHz, Digital SCD_PROXY2
   constant  ID_DIGITAL_HERCULES_INPUT_LVDS25_COOL_20V_TO_28V              : freq_id_type := (27211, 30075);   --  3.5 KHz, Digital HERCULES RICOR K548
   constant  ID_DIGITAL_SCORPIO_LW_INPUT_LVDS25_COOL_23V_TO_25V            : freq_id_type := (23810, 26316);   --  4.0 KHz, Digital SCORPIO LW RM3 (w MGLK)
   constant  ID_ANALOG_SCORPIO_LW_INPUT_LVTTL50_COOL_23V_TO_25V            : freq_id_type := (21164, 23392);   --  4.5 KHz, Analog SCORPIO LW RM3  (wo MGLK)
   constant  ID_ANALOG_MARS_INPUT_LVTTL50_COOL_9V_TO_15V                   : freq_id_type := (19048, 21053);   --  5.0 KHz, Analog MARS RM4
   constant  ID_ANALOG_MARS_INPUT_LVTTL50_COOL_18V_TO_32V                  : freq_id_type := (15873, 17544);   --  6.0 KHz, Analog MARS LSF (linear)
   constant  ID_DIGITAL_MARS_INPUT_LVTTL50_COOL_9V_TO_15V                  : freq_id_type := (13605, 15038);   --  7.0 KHz, Digital Mars RM4 (w MGLK)
   constant  ID_DIGITAL_SCORPIO_MW_INPUT_LVDS25_COOL_23V_TO_25V            : freq_id_type := (11905, 13158);   --  8.0 KHz, Digital SCORPIO MW RM3 (w MGLK)
   constant  ID_ANALOG_ISC0207_INPUT_LVTTL50_COOL_20V_TO_28V               : freq_id_type := (10582, 11696);   --  9.0 KHz, Analog ISC0207 RICOR K548/LSF with Flex
   constant  ID_ANALOG_HAWK_INPUT_LVCMOS33_COOL_18V_TO_32V                 : freq_id_type := ( 9524, 10526);   -- 10.0 KHz, Analog HAWK RM4
   constant  ID_ANALOG_ISC0209_INPUT_LVTTL50_COOL_20V_TO_28V               : freq_id_type := ( 8282,  9153);   -- 11.5 KHz, Analog ISC0209 RICOR Kxxx/LSF
   constant  ID_ANALOG_SCORPIO_MW_INPUT_LVCMOS33_COOL_23V_TO_25V           : freq_id_type := ( 7326,  8097);   -- 13.0 KHz, Analog Scorpio MW RM3 (wo MGLK)
   constant  ID_ANALOG_ISC0804_INPUT_LVCMOS33_COOL_20V_TO_28V              : freq_id_type := ( 6568,  7260);   -- 14.5 KHz, Analog ISC0804 RICOR K548/LSF with FleG-X
   constant  ID_ANALOG_ISC0207_INPUT_LVTTL50_COOL_20V_TO_28V_WITH_FLEGX    : freq_id_type := ( 5772,  6380);   -- 16.5 KHz, Analog ISC0207 RICOR K548/LSF with FleG-X
   constant  ID_ANALOG_SUPHAWK_INPUT_LVCMOS33_COOL_11V_TO_27V              : freq_id_type := ( 5299,  5516);   -- 18.5 KHz, Analog SUPHAWK RM2
   constant  ID_ANALOG_ISC0804_LN2_INPUT_LVCMOS33_COOL_0V_TO_28V           : freq_id_type := ( 5028,  5233);   -- 19.5 KHz, Analog ISC0804 LN2 with FleX 291
   constant  ID_ANALOG_XRO3503_INPUT_LVCMOS33_COOL_12V_TO_28V              : freq_id_type := ( 4782,  4978);   -- 20.5 KHz, Analog XRO3503 with TEC            
   
   ----------------------------------------------------------------------------------
   -- Les frequences de reconnaissance des cartes ADC (en coups de clocks 100 MHz)   
   ----------------------------------------------------------------------------------
   -- se referer au fichier F:\Bibliotheque\Détecteurs\Informations controlees\MISC\Detector_Freq_ID\Frequence_de_reconnaissance_des_cartes_ADC.xlsx
   -- ADC EFA-00253
   constant  ID_ADC_BRD_04CHN_FREQMAX_25MHZ                     : freq_id_type := (31746, 35088);   -- 1 quad  LTC2170 soudé  sur le board
   constant  ID_ADC_BRD_08CHN_FREQMAX_25MHZ                     : freq_id_type := (27211, 30075);   -- 2 quads LTC2170 soudés sur le board
   constant  ID_ADC_BRD_12CHN_FREQMAX_25MHZ                     : freq_id_type := (23810, 26316);   -- 3 quads LTC2170 soudés sur le board
   constant  ID_ADC_BRD_16CHN_FREQMAX_25MHZ                     : freq_id_type := (21164, 23392);   -- 4 quads LTC2170 soudés sur le board
   constant  ID_ADC_BRD_04CHN_FREQMAX_40MHZ                     : freq_id_type := (15873, 17544);   -- 1 quad  LTC2171 soudé  sur le board
   constant  ID_ADC_BRD_08CHN_FREQMAX_40MHZ                     : freq_id_type := (13605, 15038);   -- 2 quads LTC2171 soudés sur le board
   constant  ID_ADC_BRD_12CHN_FREQMAX_40MHZ                     : freq_id_type := (11905, 13158);   -- 3 quads LTC2171 soudés sur le board
   constant  ID_ADC_BRD_16CHN_FREQMAX_40MHZ                     : freq_id_type := (10582, 11696);   -- 4 quads LTC2171 soudés sur le board
   constant  ID_ADC_BRD_04CHN_FREQMAX_65MHZ                     : freq_id_type := ( 8282,  9153);   -- 1 quad  LTC2172 soudé  sur le board
   constant  ID_ADC_BRD_08CHN_FREQMAX_65MHZ                     : freq_id_type := ( 7326,  8097);   -- 2 quads LTC2172 soudés sur le board
   constant  ID_ADC_BRD_12CHN_FREQMAX_65MHZ                     : freq_id_type := ( 6568,  7260);   -- 3 quads LTC2172 soudés sur le board
   constant  ID_ADC_BRD_16CHN_FREQMAX_65MHZ                     : freq_id_type := ( 5772,  6380);   -- 4 quads LTC2172 soudés sur le board
   
   -- SADC EFA-00276
   constant  ID_SADC_BRD_8CHN_FREQMAX_25MHZ                     : freq_id_type := ( 4782,  4978);   -- 1 octal LTM9006 soudé sur le board          
   
   
   --------------------------------------------------------------------------------
   -- Configuration partie commune du Bloc FPA_interface
   --------------------------------------------------------------------------------
   
   type fpa_comn_cfg_type is
   record     
      fpa_diag_mode                       : std_logic;  --! à '1' si on est en mode diag telops
      fpa_diag_type                       : std_logic_vector(7 downto 0);  --! diag telops constant ou non (valeurs dans fpa_common_pkg 
      fpa_pwr_on                          : std_logic;  --! à '1' si on veut allumer le détecteur ou le proxy                                                              
      fpa_init_cfg                        : std_logic;  --! à '1' si la config en cours de progression est une config d'initialisation 
      fpa_init_cfg_received               : std_logic; -- ne provient pas du µBlaze. À '1' si on a reçu une config d'initialisation de la part du pilote. Cela devrait être le cas au reset et à tout pwrUp de la carte ADC/DDC
      
      -- config pour le contrôleur des trigs
      fpa_trig_ctrl_mode                  : std_logic_vector(7 downto 0);  -- mode d'operation du contrôleur des trigs (voir fichier fpa_common_pkg) ENO:17 fev 2021. Va tomber en desuetude
      fpa_acq_trig_mode                   : std_logic_vector(7 downto 0);  -- mode d'operation du contrôleur pour les acq_trig
      fpa_acq_trig_ctrl_dly               : unsigned(31 downto 0);         -- delai pour le contrôleur des trigs (depend des modes. Voir le trig_controller.vhd) 
      fpa_spare                           : unsigned(31 downto 0);         -- spare 
      fpa_xtra_trig_mode                  : std_logic_vector(7 downto 0);  -- mode d'operation du contrôleur pour les xtra_trig
      fpa_xtra_trig_ctrl_dly              : unsigned(31 downto 0);         -- delai pour le contrôleur des trigs (depend des modes. Voir le trig_controller.vhd) 
      fpa_trig_ctrl_timeout_dly           : unsigned(31 downto 0);         -- delay pour le timeout de fpa_trig_controller
      fpa_stretch_acq_trig                : std_logic;                     -- permet d'utiliser une version étirée du trig pour supporter les instabilités de la roue à filtre
      
      -- fpas analogiques principalement
      fpa_intf_data_source                : std_logic;                     -- permet de dire si la source de données est dans le FPGA (patron de tests telops) ou à l'extérieur du FPGA (ADC) 
      -- fpa_intf_data_source n'est utilisé/regardé par le vhd que lorsque fpa_diag_mode = 1
      
      -- temps d'exposition en mclk en mode xtra_trig et prog_trig
      fpa_xtra_trig_int_time              : unsigned(31 downto 0);
      fpa_prog_trig_int_time              : unsigned(31 downto 0);
      
      -- parametre de conversion du temps d'integration
      intclk_to_clk100_conv_numerator     : unsigned(31 downto 0);         -- conversion INTCLK vers 100 MHz
      clk100_to_intclk_conv_numerator     : unsigned(31 downto 0);         -- conversion 100 MHz vers 
      
   end record;    
   
   --------------------------------------------------------------------------------
   -- flex_brd_info_type                                                              
   --------------------------------------------------------------------------------
   type flex_brd_info_type is 
   record
      fpa_roic                : std_logic_vector(FPA_ROIC_UNKNOWN'range);
      fpa_output              : std_logic_vector(OUTPUT_UNKNOWN'range);
      fpa_input               : std_logic_vector(INPUT_UNKNOWN'range);  -- type de signal de contrôle du détecteur (LVDS25, LVCMOS_25, LVCMOS33 etc...). Cette info priovient des cartes d'interface (via Freq_ID ou Code_ID) 
      chn_diversity_num       : natural range 0 to 15;                  -- nombre de canaux de flex par tap de détecteur pour la diversité de canaux
      cooler_volt_min_mV      : natural range 0 to 65_000;              -- valeur en mV au-dessus duquel allumer le cooler
      cooler_volt_max_mV      : natural range 0 to 65_000;              -- valeur en mV en dessous duquel allumer le cooler
      cooler_on_curr_min_mA   : natural range 0 to 8191;                -- valeur en mA au dessus duquel considérer que le cooler est allumé
      cooler_off_curr_max_mA  : natural range 0 to 8191;                -- valeur en mA en dessous duquel considérer que le cooler est éteint
      flegx_brd_present       : std_logic;                              -- à '1' ssi l'électronique de proximité en est une bâtie avec un FleG
      dval                    : std_logic; 
   end record flex_brd_info_type;
   
   --------------------------------------------------------------------------------
   -- ddc_brd_info_type                                                                
   --------------------------------------------------------------------------------
   type ddc_brd_info_type is 
   record
      fpa_roic                : std_logic_vector(FPA_ROIC_UNKNOWN'range);
      fpa_output              : std_logic_vector(OUTPUT_UNKNOWN'range);
      fpa_input               : std_logic_vector(INPUT_UNKNOWN'range);  -- type de signal de contrôle du détecteur (LVDS25, LVCMOS_25, LVCMOS33 etc...). Cette info priovient des cartes d'interface (via Freq_ID ou Code_ID) 
      cooler_volt_min_mV      : natural range 0 to 65_000;    -- valeur en mV au-dessus duquel allumer le cooler
      cooler_volt_max_mV      : natural range 0 to 65_000;    -- valeur en mV en dessous duquel allumer le cooler
      cooler_on_curr_min_mA   : natural range 0 to 8191;      -- valeur en mA au dessus duquel considérer que le cooler est allumé
      cooler_off_curr_max_mA  : natural range 0 to 8191;      -- valeur en mA en dessous duquel considérer que le cooler est éteint     
      dval                    : std_logic; 
   end record ddc_brd_info_type;
   
   --------------------------------------------------------------------------------
   -- iddca_info_type                                                                
   --------------------------------------------------------------------------------
   type iddca_info_type is      -- extraite adc_brd_info_type, ddc_brd_info_type, flex_brd_info_type pour le sequenceur principal. 
   record
      fpa_roic                : std_logic_vector(FPA_ROIC_UNKNOWN'range);
      fpa_output              : std_logic_vector(OUTPUT_UNKNOWN'range);
      fpa_input               : std_logic_vector(INPUT_UNKNOWN'range);  -- type de signal de contrôle du détecteur (LVDS25, LVCMOS_25, LVCMOS33 etc...). Cette info priovient des cartes d'interface (via Freq_ID ou Code_ID) 
      cooler_volt_min_mV      : natural range 0 to 65_000;    -- valeur en mV au-dessus duquel allumer le cooler
      cooler_volt_max_mV      : natural range 0 to 65_000;    -- valeur en mV en dessous duquel allumer le cooler
      cooler_on_curr_min_mA   : natural range 0 to 8191;      -- valeur en mA au dessus duquel considérer que le cooler est allumé
      cooler_off_curr_max_mA  : natural range 0 to 8191;      -- valeur en mA en dessous duquel considérer que le cooler est éteint
      dval                    : std_logic; 
   end record iddca_info_type;
   
   --------------------------------------------------------------------------------
   -- adc_brd_info_type                                                            
   --------------------------------------------------------------------------------
   type adc_brd_info_type is 
   record                                                                                    
      brd_assy_number      : natural range 0 to 511; 
      adc_oper_freq_max_khz: natural range 0 to 125_000 ; -- frequence maximale d'operation des adcs soudées sur la carte EFA-00253-XXX  (lié à l'ID)
      analog_channel_num   : natural range 0 to 16;  -- nombre de canaux total disponible sur la carte (lié à l'ID)
      adc_resolution       : natural range 0 to 16;  -- résoltuion des ADC soudés sur la carte (provient du mode diagnostic des adcs)
      dval                 : std_logic; 
   end record adc_brd_info_type;
   
   --------------------------------------------------------------------------------
   -- record pour l'état du cooler                                                 
   --------------------------------------------------------------------------------
   type fpa_cooler_stat_type is 
   record
      cooler_on            : std_logic;
   end record fpa_cooler_stat_type;
   
   --------------------------------------------------------------------------------
   -- record pour l'état du hardware d'interface                                   
   --------------------------------------------------------------------------------
   type fpa_hardw_stat_type is 
   record
      adc_brd_info         : adc_brd_info_type;             -- 
      ddc_brd_info         : ddc_brd_info_type;
      flex_brd_info        : flex_brd_info_type;            -- 
      iddca_info           : iddca_info_type;
      dval                 : std_logic;                     -- 
   end record fpa_hardw_stat_type; 
   
   --------------------------------------------------------------------------------
   -- record pour l'état du vhd dans le FPGA et du soft du PPC/µBlaze              
   --------------------------------------------------------------------------------
   type fpa_firmw_stat_type is 
   record
      dval                 : std_logic;                      -- dval est requis bcp plus pour le FPA_SOFTW_STAT dans fpa_intf_sequencer.vhd en vue d'éviter de sortr des fausses erreurs 
      fpa_roic             : std_logic_vector(FPA_ROIC_UNKNOWN'range);  -- type de fpa pour lequel le design vhd est fait
      fpa_output           : std_logic_vector(OUTPUT_UNKNOWN'range);    -- type de sortie de l'iddca pour laquelle le design vhd est fait
      fpa_input            : std_logic_vector(INPUT_UNKNOWN'range);     -- type de signal de contrôle du fpa. Cette info provient d'un module mesureur de la tension de la banque de contrôle du FPA
   end record fpa_firmw_stat_type;   
   
   --------------------------------------------------------------------------------
   -- record pour l'état de la température du détecteur                            
   --------------------------------------------------------------------------------
   type fpa_temp_stat_type is 
   record      
      temp_data                : std_logic_vector(31 downto 0);
      temp_dval                : std_logic;  -- assure que la température est fpa_temp_raw est valide
      fpa_pwr_on_temp_reached  : std_logic;
   end record fpa_temp_stat_type; 
   
   --------------------------------------------------------------------------------
   -- record pour acheminer les statuts divers vers microBlaze                           
   --------------------------------------------------------------------------------
   type misc_stat_type is
   record      
      acq_trig_cnt            : std_logic_vector(15 downto 0);  -- compteur de acq_trig
      acq_int_cnt             : std_logic_vector(15 downto 0);
      fast_hder_cnt           : std_logic_vector(15 downto 0);      
      acq_readout_cnt         : std_logic_vector(15 downto 0);
      fpa_readout_cnt         : std_logic_vector(15 downto 0);
      out_pix_cnt_min         : std_logic_vector(23 downto 0);
      out_pix_cnt_max         : std_logic_vector(23 downto 0);
      trig_to_int_delay_min   : std_logic_vector(31 downto 0);
      trig_to_int_delay_max   : std_logic_vector(31 downto 0);
      int_to_int_delay_min    : std_logic_vector(31 downto 0);
      int_to_int_delay_max    : std_logic_vector(31 downto 0);
   end record misc_stat_type; 
   
   --------------------------------------------------------------------------------
   -- types  pour transferer des données                                 
   --------------------------------------------------------------------------------
   type t_ll_ext_mosi1 is record
      sof         : std_logic;
      eof         : std_logic;
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic;
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi8 is record
      sof         : std_logic;
      eof         : std_logic;
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(7 downto 0);
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi10 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(9 downto 0);
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi16 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(15 downto 0);
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi18 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(17 downto 0);
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi32 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(31 downto 0); 
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi36 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(35 downto 0); 
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi56 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(55 downto 0); 
      dval        : std_logic;
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi72 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(71 downto 0); 
      dval        : std_logic;
      misc        : std_logic_vector(15 downto 0);
      support_busy : std_logic;
   end record;
   
   type t_ll_ext_mosi144 is record
      sof         : std_logic;
      eof         : std_logic; 
      sol         : std_logic;   -- start of line
      eol         : std_logic;   -- eol of line
      data        : std_logic_vector(143 downto 0); 
      dval        : std_logic;
      misc        : std_logic_vector(15 downto 0);
      support_busy : std_logic;
   end record;
   
   type t_ll_area_mosi72 is record -- dedié exclusivement aux données AOi ou non      
      -- données
      data             : std_logic_vector(71 downto 0);
      
      -- AOI_area
      aoi_sof          : std_logic;
      aoi_eof          : std_logic; 
      aoi_sol          : std_logic;  -- start of line
      aoi_eol          : std_logic;  -- eol of line      
      aoi_dval         : std_logic;  -- à '1' dit que les données sur le bus data sont des pixels de l'image 
      aoi_spare        : std_logic_vector(14 downto 0);   
      
      -- non AOI_area
      naoi_dval        : std_logic;  -- à '1' dit que les données sur le bus data sont couplés aux flags naoi_misc. 
      naoi_start       : std_logic;  -- start global d'une zone naoi ( en general zone de voltage refrence)
      naoi_stop        : std_logic;  -- stop global d'une zone naoi ( en general zone de voltage refrence)
      naoi_ref_valid   : std_logic_vector(1 downto 0);  -- est à '1' pour indiquer quelle reference de tension est en progression dans la chaine. Utilisée pour la correction dynamique de l'électronique 
      naoi_spare       : std_logic_vector(12 downto 0);
      support_busy     : std_logic;
   end record;
   
   type t_ll_area_miso is record
      afull	: std_logic;
      busy  : std_logic;
   end record; 
   
   type t_ll_ext_miso is record
      afull	: std_logic;
      busy  : std_logic;
   end record;  
   
   --------------------------------------------------------------------------------
   -- constantes decoulant des types précédants                                    
   --------------------------------------------------------------------------------
   constant DDC_BRD_INFO_UNKNOWN  : ddc_brd_info_type      := (FPA_ROIC_UNKNOWN, OUTPUT_UNKNOWN, INPUT_UNKNOWN, 0, 1, 8000, 8000, '0');
   constant FLEX_BRD_INFO_UNKNOWN : flex_brd_info_type     := (FPA_ROIC_UNKNOWN, OUTPUT_UNKNOWN, INPUT_UNKNOWN, 0, 1, 0, 8000, 8000, '0', '0'); -- remarquer que le voltage min est superieur au voltga max. Une absurdité qui fera que le cooler ne sera pas allumé par le PPC
   constant ADC_BRD_INFO_UNKNOWN  : adc_brd_info_type      := (0, 0, 0, 0, '0');
   constant IDDCA_INFO_UNKNOWN    : iddca_info_type        := (FPA_ROIC_UNKNOWN, OUTPUT_UNKNOWN, INPUT_UNKNOWN, 0, 1, 8000, 8000, '0');
   constant HARDW_STAT_UNKNOWN    : fpa_hardw_stat_type    := (ADC_BRD_INFO_UNKNOWN, DDC_BRD_INFO_UNKNOWN, FLEX_BRD_INFO_UNKNOWN, IDDCA_INFO_UNKNOWN, '0');
   
   ------------------------------------------
   -- functions --
   --------------------------------------------  
   function MAX(LEFT, RIGHT: INTEGER) return INTEGER;
   function MIN(LEFT, RIGHT: INTEGER) return INTEGER;
   
   function freq_to_flex_brd_info (Tosc: natural; MEAS_CLK_RATE: natural) return flex_brd_info_type;
   function freq_to_adc_brd_info (Tosc: natural; MEAS_CLK_RATE: natural) return adc_brd_info_type;
   function freq_to_ddc_brd_info (Tosc: natural; MEAS_CLK_RATE: natural) return ddc_brd_info_type;
   
   function flex_brd_info_to_iddca_info (flex_brd_info: flex_brd_info_type) return iddca_info_type;
   function ddc_brd_info_to_iddca_info (ddc_brd_info: ddc_brd_info_type) return iddca_info_type;
   
   function digio_voltage_to_fpa_input_type(voltage_mV: unsigned(15 downto 0)) return std_logic_vector;
   function voltage_to_flex_psp_mV(voltage_mV: unsigned(15 downto 0)) return natural;
   
   
end fpa_common_pkg;

package body fpa_common_pkg is
   
   function MAX(LEFT, RIGHT: INTEGER) return INTEGER is
   begin
      if LEFT > RIGHT then return LEFT;
      else return RIGHT;
      end if;
   end;
   
   function MIN(LEFT, RIGHT: INTEGER) return INTEGER is
   begin
      if LEFT < RIGHT then return LEFT;
      else return RIGHT;
      end if;
   end;
   
   ---------------------------------------------------------------------------------------------
   -- function de conversion de la frequence de reconnaissance en type d'interface FLEX
   --------------------------------------------------------------------------------------------- 
   -- pour les iddcas analogiques
   function freq_to_flex_brd_info(Tosc: natural; MEAS_CLK_RATE: natural) return flex_brd_info_type is
      variable flex_brd_info : flex_brd_info_type;
   begin
      if MEAS_CLK_RATE /= 100_000_000 then       -- CLK_RATE est la clock de mesure de la periode. Il doit valoir 100_000_000 Hz
         flex_brd_info.fpa_roic                 := FPA_ROIC_UNKNOWN;
         flex_brd_info.fpa_output               := OUTPUT_UNKNOWN;
         flex_brd_info.fpa_input                := INPUT_UNKNOWN;
         flex_brd_info.cooler_volt_min_mV       := 1;  -- remarquer que le min
         flex_brd_info.cooler_volt_max_mV       := 0;  -- est superieur au max. Une absurdité provioquée mais qui fera en sorte qu'on ne puisse allumer le cooler
         flex_brd_info.cooler_on_curr_min_mA    := 8000;
         flex_brd_info.cooler_off_curr_max_mA   := 8000;
         flex_brd_info.chn_diversity_num        := 0;
         
      else                                     
         
         -- -- marsA linear cooler (flegX non encore conçu)
         if (Tosc > ID_ANALOG_MARS_INPUT_LVTTL50_COOL_18V_TO_32V.freq_id_min) and (Tosc < ID_ANALOG_MARS_INPUT_LVTTL50_COOL_18V_TO_32V.freq_id_max) then 
            flex_brd_info.fpa_roic                 := FPA_ROIC_MARS;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVTTL50;
            flex_brd_info.cooler_volt_min_mV       := 18_000;
            flex_brd_info.cooler_volt_max_mV       := 32_000;
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '1';
            flex_brd_info.chn_diversity_num        := 2;
            
            -- hawkA RM4                  (EFA-00267-XXX)
         elsif (Tosc >= ID_ANALOG_HAWK_INPUT_LVCMOS33_COOL_18V_TO_32V.freq_id_min) and (Tosc <= ID_ANALOG_HAWK_INPUT_LVCMOS33_COOL_18V_TO_32V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_HAWK;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVCMOS33;
            flex_brd_info.cooler_volt_min_mV       := 18_000;
            flex_brd_info.cooler_volt_max_mV       := 32_000;
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '1';
            flex_brd_info.chn_diversity_num        := 2;
            
            -- isc0207A with cooler 24V  (EFA-00264-XXX)
         elsif (Tosc >= ID_ANALOG_ISC0207_INPUT_LVTTL50_COOL_20V_TO_28V.freq_id_min) and (Tosc <= ID_ANALOG_ISC0207_INPUT_LVTTL50_COOL_20V_TO_28V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_ISC0207;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVTTL50;
            flex_brd_info.cooler_volt_min_mV       := 20_000;
            flex_brd_info.cooler_volt_max_mV       := 28_000;
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '0';
            flex_brd_info.chn_diversity_num        := 1;  
            
            -- isc0209A with cooler 24V  (EFA-00268-XXX)
         elsif (Tosc >= ID_ANALOG_ISC0209_INPUT_LVTTL50_COOL_20V_TO_28V.freq_id_min) and (Tosc <= ID_ANALOG_ISC0209_INPUT_LVTTL50_COOL_20V_TO_28V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_ISC0209;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVTTL50;
            flex_brd_info.cooler_volt_min_mV       := 10_500;--20_000;   -- 12V pour accommoder non conformité du Ricor AIRS SLS320 de IRC1505
            flex_brd_info.cooler_volt_max_mV       := 28_000;--28_000;   -- ENO: 19 janv 2016: on accommode le 12V (IRC1505 et son problème de stator qui ne peut être remplacé à cause de la cassure du tournevis) et le 24V mais attention le 12V n'est plus protegé.
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '1';
            flex_brd_info.chn_diversity_num        := 2;
            
            -- scorpioMW with cooler 24V  (EFA-00270-XXX) 
         elsif (Tosc >= ID_ANALOG_SCORPIO_MW_INPUT_LVCMOS33_COOL_23V_TO_25V.freq_id_min) and (Tosc <= ID_ANALOG_SCORPIO_MW_INPUT_LVCMOS33_COOL_23V_TO_25V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_SCORPIO_MW;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVCMOS33;
            flex_brd_info.cooler_volt_min_mV       := 23_000;  
            flex_brd_info.cooler_volt_max_mV       := 25_000;
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '1';
            flex_brd_info.chn_diversity_num        := 2;
            
            -- isc0207A with cooler 24V  (EFA-00272-XXX & EFA-00271-001)
         elsif (Tosc >= ID_ANALOG_ISC0207_INPUT_LVTTL50_COOL_20V_TO_28V_WITH_FLEGX.freq_id_min) and (Tosc <= ID_ANALOG_ISC0207_INPUT_LVTTL50_COOL_20V_TO_28V_WITH_FLEGX.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_ISC0207;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVTTL50;
            flex_brd_info.cooler_volt_min_mV       := 20_000;
            flex_brd_info.cooler_volt_max_mV       := 28_000;
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '1';
            flex_brd_info.chn_diversity_num        := 1;
            
            -- isc0804A with cooler 24V  (EFA-00272-XXX & EFA-00271-002)
         elsif (Tosc >= ID_ANALOG_ISC0804_INPUT_LVCMOS33_COOL_20V_TO_28V.freq_id_min) and (Tosc <= ID_ANALOG_ISC0804_INPUT_LVCMOS33_COOL_20V_TO_28V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_ISC0804;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVCMOS33;
            flex_brd_info.cooler_volt_min_mV       := 20_000;
            flex_brd_info.cooler_volt_max_mV       := 28_000;
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '1';
            flex_brd_info.chn_diversity_num        := 1; 
            
            -- superhawkA RM2                  (EFA-00295-XXX)
         elsif (Tosc >= ID_ANALOG_SUPHAWK_INPUT_LVCMOS33_COOL_11V_TO_27V.freq_id_min) and (Tosc <= ID_ANALOG_SUPHAWK_INPUT_LVCMOS33_COOL_11V_TO_27V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_SUPHAWK;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVCMOS33;
            flex_brd_info.cooler_volt_min_mV       := 11_000;
            flex_brd_info.cooler_volt_max_mV       := 27_000;
            flex_brd_info.cooler_on_curr_min_mA    := 100;
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '1';
            flex_brd_info.chn_diversity_num        := 2;
            
            -- isc0804A LN2 (Flex EFA-00291-001)
         elsif (Tosc >= ID_ANALOG_ISC0804_LN2_INPUT_LVCMOS33_COOL_0V_TO_28V.freq_id_min) and (Tosc <= ID_ANALOG_ISC0804_LN2_INPUT_LVCMOS33_COOL_0V_TO_28V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_ISC0804;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVCMOS33;
            flex_brd_info.cooler_volt_min_mV       := 0;
            flex_brd_info.cooler_volt_max_mV       := 28_000;
            flex_brd_info.cooler_on_curr_min_mA    := 0;       -- pour accommoder l'absence de refroidisseur à moteur
            flex_brd_info.cooler_off_curr_max_mA   := 100;     -- pour accommoder l'absence de refroidisseur à moteur
            flex_brd_info.flegx_brd_present        := '0';     -- flex 291 utilisé
            flex_brd_info.chn_diversity_num        := 1;
            
            -- Xenics XRO3503 (EFA-00305-001)
         elsif (Tosc >= ID_ANALOG_XRO3503_INPUT_LVCMOS33_COOL_12V_TO_28V.freq_id_min) and (Tosc <= ID_ANALOG_XRO3503_INPUT_LVCMOS33_COOL_12V_TO_28V.freq_id_max) then
            flex_brd_info.fpa_roic                 := FPA_ROIC_XRO3503;
            flex_brd_info.fpa_output               := OUTPUT_ANALOG;
            flex_brd_info.fpa_input                := LVCMOS33;
            flex_brd_info.cooler_volt_min_mV       := 11_000;
            flex_brd_info.cooler_volt_max_mV       := 27_000;
            flex_brd_info.cooler_on_curr_min_mA    := 35;      -- courant minimal de la carte 306 (TEC Controller)
            flex_brd_info.cooler_off_curr_max_mA   := 100;
            flex_brd_info.flegx_brd_present        := '0';
            flex_brd_info.chn_diversity_num        := 1;
            
            -- flex_brd inconnu  
         else
            flex_brd_info.fpa_roic                 := FPA_ROIC_UNKNOWN;
            flex_brd_info.fpa_output               := OUTPUT_UNKNOWN;
            flex_brd_info.fpa_input                := INPUT_UNKNOWN;
            flex_brd_info.cooler_volt_min_mV       := 1;       -- remarquer que le min est superieur au max. Une absurdité voulue et qui fera en sorte qu'on ne puisse allumer le cooler
            flex_brd_info.cooler_volt_max_mV       := 0;       --
            flex_brd_info.cooler_on_curr_min_mA    := 8000;
            flex_brd_info.cooler_off_curr_max_mA   := 8000;
            flex_brd_info.flegx_brd_present        := '0';
            flex_brd_info.chn_diversity_num        := 0;
            
         end if;		 
      end if; 
      return flex_brd_info;
   end freq_to_flex_brd_info;
   
   
   ---------------------------------------------------------------------------------------------
   -- function de conversion de la frequence de reconnaissance en type de carte ADC
   ---------------------------------------------------------------------------------------------
   -- pour les iddcas analogiques
   function freq_to_adc_brd_info(Tosc: natural; MEAS_CLK_RATE: natural) return adc_brd_info_type is
      variable adc_brd_info : adc_brd_info_type;
   begin
      if MEAS_CLK_RATE /= 100_000_000 then       -- CLK_RATE est la clock de mesure de la periode. Il doit valoir 100_000_000 Hz
         adc_brd_info.brd_assy_number               :=  0;
         adc_brd_info.adc_oper_freq_max_khz  :=  25_000; -- quel que soit l'ADC,  il peut s'opérer à 25MHz au moins
         adc_brd_info.analog_channel_num     :=  0;  
         adc_brd_info.adc_resolution         :=  0;
         
      else                                                       
         
         --------------------------------------------------------
         --  EFA-00253-XYZ
         --------------------------------------------------------         
         -- 4 canaux 25MHz max (1 quad LTC2170) détecté 
         if (Tosc > ID_ADC_BRD_04CHN_FREQMAX_25MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_04CHN_FREQMAX_25MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 25_000; 
            adc_brd_info.analog_channel_num     := 4;            
            adc_brd_info.adc_resolution         := 14;        
            
            -- 8 canaux 25MHz max (2 quads LTC2170) détectés 
         elsif (Tosc > ID_ADC_BRD_08CHN_FREQMAX_25MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_08CHN_FREQMAX_25MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 25_000; 
            adc_brd_info.analog_channel_num     := 8;            
            adc_brd_info.adc_resolution         := 14;  
            
            -- 12 canaux 25MHz max (3 quads LTC2170) détectés 
         elsif (Tosc > ID_ADC_BRD_12CHN_FREQMAX_25MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_12CHN_FREQMAX_25MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 25_000; 
            adc_brd_info.analog_channel_num     := 12;            
            adc_brd_info.adc_resolution         := 14; 
            
            -- 16 canaux 25MHz max (4 quads LTC2170) détectés 
         elsif (Tosc > ID_ADC_BRD_16CHN_FREQMAX_25MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_16CHN_FREQMAX_25MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 25_000; 
            adc_brd_info.analog_channel_num     := 16;            
            adc_brd_info.adc_resolution         := 14; 
            
            -- 4 canaux 40MHz max (1 quad LTC2171) détecté 
         elsif (Tosc > ID_ADC_BRD_04CHN_FREQMAX_40MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_04CHN_FREQMAX_40MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 40_000; 
            adc_brd_info.analog_channel_num     := 4;            
            adc_brd_info.adc_resolution         := 14;        
            
            -- 8 canaux 40MHz max (2 quads LTC2171) détectés 
         elsif (Tosc > ID_ADC_BRD_08CHN_FREQMAX_40MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_08CHN_FREQMAX_40MHZ.freq_id_max) then 
            adc_brd_info.adc_oper_freq_max_khz  := 40_000; 
            adc_brd_info.analog_channel_num     := 8;            
            adc_brd_info.adc_resolution         := 14;  
            
            -- 12 canaux 40MHz max (3 quads LTC2171) détectés 
         elsif (Tosc > ID_ADC_BRD_12CHN_FREQMAX_40MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_12CHN_FREQMAX_40MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 40_000; 
            adc_brd_info.analog_channel_num     := 12;            
            adc_brd_info.adc_resolution         := 14; 
            
            -- 16 canaux 40MHz max (4 quads LTC2171) détectés 
         elsif (Tosc > ID_ADC_BRD_16CHN_FREQMAX_40MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_16CHN_FREQMAX_40MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 40_000; 
            adc_brd_info.analog_channel_num     := 16;            
            adc_brd_info.adc_resolution         := 14; 
            
            -- 4 canaux 65MHz max (1 quad LTC2172) détecté 
         elsif (Tosc > ID_ADC_BRD_04CHN_FREQMAX_65MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_04CHN_FREQMAX_65MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 65_000; 
            adc_brd_info.analog_channel_num     := 4;            
            adc_brd_info.adc_resolution         := 14;        
            
            -- 8 canaux 65MHz max (2 quads LTC2172) détectés 
         elsif (Tosc > ID_ADC_BRD_08CHN_FREQMAX_65MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_08CHN_FREQMAX_65MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 65_000; 
            adc_brd_info.analog_channel_num     := 8;            
            adc_brd_info.adc_resolution         := 14;  
            
            -- 12 canaux 65MHz max (3 quads LTC2172) détectés 
         elsif (Tosc > ID_ADC_BRD_12CHN_FREQMAX_65MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_12CHN_FREQMAX_65MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 65_000; 
            adc_brd_info.analog_channel_num     := 12;            
            adc_brd_info.adc_resolution         := 14; 
            
            -- 16 canaux 65MHz max (4 quads LTC2172) détectés 
         elsif (Tosc > ID_ADC_BRD_16CHN_FREQMAX_65MHZ.freq_id_min) and (Tosc < ID_ADC_BRD_16CHN_FREQMAX_65MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        :=  253;
            adc_brd_info.adc_oper_freq_max_khz  := 65_000; 
            adc_brd_info.analog_channel_num     := 16;            
            adc_brd_info.adc_resolution         := 14; 
            
            
            --------------------------------------------------------
            --  EFA-00276-XYZ
            --------------------------------------------------------     
            -- 8 canaux 25MHz max (1 octal LTM9006 ) détectés 
         elsif (Tosc > ID_SADC_BRD_8CHN_FREQMAX_25MHZ.freq_id_min) and (Tosc < ID_SADC_BRD_8CHN_FREQMAX_25MHZ.freq_id_max) then
            adc_brd_info.brd_assy_number        := 276;
            adc_brd_info.adc_oper_freq_max_khz  := 25_000; 
            adc_brd_info.analog_channel_num     := 8;            
            adc_brd_info.adc_resolution         := 14;           
            
         else
            adc_brd_info.brd_assy_number        :=  0;
            adc_brd_info.adc_oper_freq_max_khz  := 25_000; -- quel que soit l'ADC,  il peut s'opérer à 25MHz au moins
            adc_brd_info.analog_channel_num     := 0;  
            adc_brd_info.adc_resolution         := 0;           
         end if;		 
      end if; 
      return adc_brd_info;
   end freq_to_adc_brd_info;
   
   
   ---------------------------------------------------------------------------------------------
   -- function de conversion de la frequence de reconnaissance en type d'interface DDC
   ---------------------------------------------------------------------------------------------
   -- pour les iddcas numeriques
   function freq_to_ddc_brd_info(Tosc: natural; MEAS_CLK_RATE: natural) return ddc_brd_info_type is
      variable ddc_brd_info  : ddc_brd_info_type;
   begin
      if MEAS_CLK_RATE /= 100_000_000 then       -- CLK_RATE est la clock de mesure de la periode. Il doit valoir 100_000_000 Hz
         ddc_brd_info.fpa_roic                  := FPA_ROIC_UNKNOWN;
         ddc_brd_info.fpa_output                := OUTPUT_UNKNOWN;
         ddc_brd_info.fpa_input                 := INPUT_UNKNOWN;
         ddc_brd_info.cooler_volt_min_mV        := 1;  -- remarquer que le min
         ddc_brd_info.cooler_volt_max_mV        := 0;  -- est superieur au max. Une absurdité provioquée mais qui fera en sorte qu'on ne puisse allumer le cooler
         ddc_brd_info.cooler_on_curr_min_mA     := 8000;
         ddc_brd_info.cooler_off_curr_max_mA    := 8000; 
         
      else                                     
         -- pelicanD or scd_proxy1
         if (Tosc > ID_DIGITAL_SCD_PROXY1_INPUT_LVDS25_COOL_20V_TO_28V.freq_id_min) and (Tosc < ID_DIGITAL_SCD_PROXY1_INPUT_LVDS25_COOL_20V_TO_28V.freq_id_max) then 
            ddc_brd_info.fpa_roic                  := FPA_ROIC_SCD_PROXY1;
            ddc_brd_info.fpa_output                := OUTPUT_DIGITAL;
            ddc_brd_info.fpa_input                 := LVDS25;
            ddc_brd_info.cooler_volt_min_mV        := 20_000;
            ddc_brd_info.cooler_volt_max_mV        := 28_000; 
            ddc_brd_info.cooler_on_curr_min_mA     := 100;
            ddc_brd_info.cooler_off_curr_max_mA    := 100;
            
            -- herculesD
         elsif (Tosc > ID_DIGITAL_HERCULES_INPUT_LVDS25_COOL_20V_TO_28V.freq_id_min) and (Tosc < ID_DIGITAL_HERCULES_INPUT_LVDS25_COOL_20V_TO_28V.freq_id_max) then 
            ddc_brd_info.fpa_roic                  := FPA_ROIC_HERCULES;
            ddc_brd_info.fpa_output                := OUTPUT_DIGITAL;
            ddc_brd_info.fpa_input                 := LVDS25;
            ddc_brd_info.cooler_volt_min_mV        := 20_000;
            ddc_brd_info.cooler_volt_max_mV        := 28_000;
            ddc_brd_info.cooler_on_curr_min_mA     := 100;
            ddc_brd_info.cooler_off_curr_max_mA    := 100;
            
            -- scd_proxy2
         elsif (Tosc > ID_DIGITAL_SCD_PROXY2_INPUT_LVDS25_COOL_20V_TO_28V.freq_id_min) and (Tosc < ID_DIGITAL_SCD_PROXY2_INPUT_LVDS25_COOL_20V_TO_28V.freq_id_max) then 
            ddc_brd_info.fpa_roic                  := FPA_ROIC_SCD_PROXY2;
            ddc_brd_info.fpa_output                := OUTPUT_DIGITAL;
            ddc_brd_info.fpa_input                 := LVDS25;
            ddc_brd_info.cooler_volt_min_mV        := 20_000;
            ddc_brd_info.cooler_volt_max_mV        := 28_000;
            ddc_brd_info.cooler_on_curr_min_mA     := 100;
            ddc_brd_info.cooler_off_curr_max_mA    := 100;
            
            -- scorpiolwD RM3 (avec MGLK)
         elsif (Tosc > ID_DIGITAL_SCORPIO_LW_INPUT_LVDS25_COOL_23V_TO_25V.freq_id_min) and (Tosc < ID_DIGITAL_SCORPIO_LW_INPUT_LVDS25_COOL_23V_TO_25V.freq_id_max) then 
            ddc_brd_info.fpa_roic                  := FPA_ROIC_SCORPIO_LW;
            ddc_brd_info.fpa_output                := OUTPUT_DIGITAL;
            ddc_brd_info.fpa_input                 := LVDS25;
            ddc_brd_info.cooler_volt_min_mV        := 23_000;
            ddc_brd_info.cooler_volt_max_mV        := 25_000;
            ddc_brd_info.cooler_on_curr_min_mA     := 100;
            ddc_brd_info.cooler_off_curr_max_mA    := 100;
            
            -- marsD RM4
         elsif (Tosc >= ID_DIGITAL_MARS_INPUT_LVTTL50_COOL_9V_TO_15V.freq_id_min) and (Tosc <= ID_DIGITAL_MARS_INPUT_LVTTL50_COOL_9V_TO_15V.freq_id_max) then
            ddc_brd_info.fpa_roic                  := FPA_ROIC_MARS;
            ddc_brd_info.fpa_output                := OUTPUT_DIGITAL;
            ddc_brd_info.fpa_input                 := LVDS25;
            ddc_brd_info.cooler_volt_min_mV        := 10_000;
            ddc_brd_info.cooler_volt_max_mV        := 15_000;
            ddc_brd_info.cooler_on_curr_min_mA     := 100;
            ddc_brd_info.cooler_off_curr_max_mA    := 100;
            
            -- scorpiomwD RM3
         elsif (Tosc >= ID_DIGITAL_SCORPIO_MW_INPUT_LVDS25_COOL_23V_TO_25V.freq_id_min) and (Tosc <= ID_DIGITAL_SCORPIO_MW_INPUT_LVDS25_COOL_23V_TO_25V.freq_id_max) then
            ddc_brd_info.fpa_roic                  := FPA_ROIC_SCORPIO_MW;
            ddc_brd_info.fpa_output                := OUTPUT_DIGITAL;
            ddc_brd_info.fpa_input                 := LVDS25;
            ddc_brd_info.cooler_volt_min_mV        := 23_000;
            ddc_brd_info.cooler_volt_max_mV        := 25_000;
            ddc_brd_info.cooler_on_curr_min_mA     := 100;
            ddc_brd_info.cooler_off_curr_max_mA    := 100;
            
            -- ddc_brd inconnu 
         else
            ddc_brd_info.fpa_roic                  := FPA_ROIC_UNKNOWN;
            ddc_brd_info.fpa_output                := OUTPUT_UNKNOWN;
            ddc_brd_info.fpa_input                 := INPUT_UNKNOWN;
            ddc_brd_info.cooler_volt_min_mV        := 1;  -- remarquer que le min est superieur au max. Une absurdité voulue et qui fera en sorte qu'on ne puisse allumer le cooler
            ddc_brd_info.cooler_volt_max_mV        := 0;  -- 
            ddc_brd_info.cooler_on_curr_min_mA     := 8000;
            ddc_brd_info.cooler_off_curr_max_mA    := 8000;
            
         end if;		 
      end if; 
      return ddc_brd_info; 
   end freq_to_ddc_brd_info;
   
   
   ---------------------------------------------------------------------------------------------
   -- function de conversion des infos du flex/DDC en info iDDCA
   ---------------------------------------------------------------------------------------------
   function flex_brd_info_to_iddca_info (flex_brd_info: flex_brd_info_type) return iddca_info_type is
      variable iddca_info  : iddca_info_type;   
   begin
      iddca_info.fpa_roic                 := flex_brd_info.fpa_roic;
      iddca_info.fpa_output               := flex_brd_info.fpa_output;
      iddca_info.fpa_input                := flex_brd_info.fpa_input;
      iddca_info.cooler_volt_min_mV       := flex_brd_info.cooler_volt_min_mV;
      iddca_info.cooler_volt_max_mV       := flex_brd_info.cooler_volt_max_mV;
      iddca_info.cooler_on_curr_min_mA    := flex_brd_info.cooler_on_curr_min_mA;
      iddca_info.cooler_off_curr_max_mA   := flex_brd_info.cooler_off_curr_max_mA;
      iddca_info.dval                     := flex_brd_info.dval;
      return iddca_info;
   end flex_brd_info_to_iddca_info; 
   
   
   function ddc_brd_info_to_iddca_info (ddc_brd_info: ddc_brd_info_type) return iddca_info_type is
      variable iddca_info  : iddca_info_type;   
   begin
      iddca_info.fpa_roic                 := ddc_brd_info.fpa_roic;
      iddca_info.fpa_output               := ddc_brd_info.fpa_output;
      iddca_info.fpa_input                := ddc_brd_info.fpa_input;
      iddca_info.cooler_volt_min_mV       := ddc_brd_info.cooler_volt_min_mV;
      iddca_info.cooler_volt_max_mV       := ddc_brd_info.cooler_volt_max_mV;
      iddca_info.cooler_on_curr_min_mA    := ddc_brd_info.cooler_on_curr_min_mA; 
      iddca_info.cooler_off_curr_max_mA   := ddc_brd_info.cooler_off_curr_max_mA;
      iddca_info.dval                     := ddc_brd_info.dval;
      return iddca_info;
   end ddc_brd_info_to_iddca_info;
   
   ---------------------------------------------------------------------------------------------
   -- function de conversion de voltage DIGIO en type standardisé
   ---------------------------------------------------------------------------------------------  
   function digio_voltage_to_fpa_input_type(voltage_mV: unsigned(15 downto 0)) return std_logic_vector is
      variable fpa_digio_input_type : std_logic_vector(7 downto 0);       
   begin
      
      -- LVTTL 5V 
      if (voltage_mV > 4500) and (voltage_mV < 5500) then 
         fpa_digio_input_type := LVTTL50;
         
         -- LVCMOS 3.3V              
      elsif (voltage_mV > 3000) and (voltage_mV < 3600) then
         fpa_digio_input_type := LVCMOS33;
         
         -- LVCMOS 2.5V                       
      elsif (voltage_mV > 2300) and (voltage_mV < 2700) then
         fpa_digio_input_type := LVCMOS25;         
         
         -- toute autre combinaison n'est pas possible avec la carte EFA-00253 d'origine.
      else
         fpa_digio_input_type := INPUT_UNKNOWN;         
      end if;
      
      return fpa_digio_input_type;
   end digio_voltage_to_fpa_input_type;
   
   
   ---------------------------------------------------------------------------------------------
   -- function de conversion de voltage en tension standardisée pour le flex
   ---------------------------------------------------------------------------------------------  
   function voltage_to_flex_psp_mV(voltage_mV: unsigned(15 downto 0)) return natural is
      variable flex_psp_mV : natural range 0 to 8000;       
   begin
      
      -- tension 5V
      if (voltage_mV > 4500) and (voltage_mV < 5500) then 
         flex_psp_mV := 5_000;
         
         -- tension 6.5V            
      elsif (voltage_mV > 6000) and (voltage_mV < 7000) then 
         flex_psp_mV := 6_500;
         
         -- tension 8V                      
      elsif (voltage_mV > 7500) and (voltage_mV < 8500) then 
         flex_psp_mV := 8_000;         
         
         -- toute autre combinaison n'est pas possible avec la carte EFA-00253 d'origine.
      else
         flex_psp_mV := 0;         
      end if;
      
      return flex_psp_mV;
   end voltage_to_flex_psp_mV;
   
   
end package body fpa_common_pkg;