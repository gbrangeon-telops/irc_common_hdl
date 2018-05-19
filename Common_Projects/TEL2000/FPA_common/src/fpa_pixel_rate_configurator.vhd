------------------------------------------------------------------
--!   @file : fpa_pixel_rate_configurator
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
use work.fpa_common_pkg.all;
use work.tel2000.all;


entity fpa_pixel_rate_configurator is
   port(
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;
      
      FPA_INT_TIME      : in std_logic_vector(31 downto 0);
      FPA_INT           : in std_logic;  
      
      TRIG_PERIOD       : in std_logic_vector(31 downto 0);
      TRIG_PERIOD_DVAL  : in std_logic;
      
      DYN_PAUSE_CFG     : out dyn_pause_cfg_type
      );
end fpa_pixel_rate_configurator; 

architecture rtl of fpa_pixel_rate_configurator is
   
   signal line_pause_i           : unsigned(7 downto 0); 
   
   constant C_DENOM_CONV_BIT_POS : natural := 21;
   constant C_RESULT_MSB_POS     : natural := line_pause_i'length + C_DENOM_CONV_BIT_POS - 1;
   constant C_TRIG_CTLER_VHD_DLY : natural := 80; -- en coups d'horloges, c'est la somme de tous les delais imputables à la fsm du fpa_trig_controller
   
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS       : natural := 26;  -- log2 de FPA_EXP_TIME_CONV_DENOMINATOR  
   constant C_EXP_TIME_CONV_DENOMINATOR               : integer := 2**C_EXP_TIME_CONV_DENOMINATOR_BIT_POS;
   constant C_EXP_TIME_CONV_NUMERATOR                 : unsigned(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 4 downto 0):= to_unsigned(integer(real(DEFINE_FPA_100M_CLK_RATE_KHZ)*real(2**C_EXP_TIME_CONV_DENOMINATOR_BIT_POS)/real(DEFINE_FPA_MCLK_RATE_KHZ)), C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 5);     --
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27  : natural := C_EXP_TIME_CONV_DENOMINATOR_BIT_POS + 27; --pour un total de 27 bits pour le temps d'integration
   constant C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_M_1   : natural := C_EXP_TIME_CONV_DENOMINATOR_BIT_POS - 1;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component;
   
   type exp_time_pipe_type is array (0 to 3) of unsigned(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27 downto 0);
   
   signal exp_time_pipe          : exp_time_pipe_type;
   signal exp_dval_pipe          : std_logic_vector(7 downto 0) := (others => '0');   
   signal sreset                 : std_logic;
   signal cfg_valid_pipe         : std_logic_vector(7 downto 0);
   signal dyn_pause_cfg_i        : dyn_pause_cfg_type;
   signal dyn_pause_possible_i   : std_logic;
   signal trig_period_i          : unsigned(TRIG_PERIOD'LENGTH-1 downto 0);
   signal fpa_int_i              : std_logic;
   signal integration_time_i     : unsigned(TRIG_PERIOD'LENGTH-1 downto 0);
   signal total_pause_i          : unsigned(31 downto 0);
   signal total_pause_temp_i     : unsigned(total_pause_i'length-1 downto 0);
   signal temp_result            : unsigned(C_RESULT_MSB_POS downto 0);
   signal fpa_trig_ctrl_dly_i    : unsigned(31 downto 0);
   signal trig_period_min_wo_int : unsigned(31 downto 0);
   signal trig_period_min_i      : unsigned(31 downto 0);
   signal line_pause_temp_i      : unsigned(line_pause_i'length-1 downto 0);
   signal trig_start_to_trig_start_dly : unsigned(31 downto 0);
   signal int_time_100MHz        : unsigned(31 downto 0);
   signal int_time_100MHz_dval_i : std_logic;
   
   
   
begin
   
   DYN_PAUSE_CFG <= dyn_pause_cfg_i;   
   
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
   -- temps disponible pour les pauses
   --------------------------------------------------   
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then   
         if sreset = '1' then 
            cfg_valid_pipe <= (others => '0');
            dyn_pause_possible_i <= '0';
            dyn_pause_cfg_i.enabled <= '0';
            -- pragma translate_off
            fpa_trig_ctrl_dly_i <= (others => '0');
            trig_period_i <= (others => '0');
            integration_time_i <= (others => '0');
            -- pragma translate_on
            
         else   
            
            fpa_int_i <= FPA_INT; 
            
            -- pipe pour le calcul du temps d'integration en clk de 100 MHz
            exp_time_pipe(0) <= resize(unsigned(FPA_INT_TIME), exp_time_pipe(0)'length) ;
            exp_time_pipe(1) <= resize(exp_time_pipe(0) * C_EXP_TIME_CONV_NUMERATOR, exp_time_pipe(0)'length);          
            exp_time_pipe(2) <= resize(exp_time_pipe(1)(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_P_27 downto C_EXP_TIME_CONV_DENOMINATOR_BIT_POS), exp_time_pipe(0)'length);  -- soit une division par 2^EXP_TIME_CONV_DENOMINATOR
            exp_time_pipe(3) <= exp_time_pipe(2) + resize("00"& exp_time_pipe(1)(C_EXP_TIME_CONV_DENOMINATOR_BIT_POS_M_1), exp_time_pipe(0)'length);  -- pour l'operation d'arrondi
            int_time_100MHz  <= exp_time_pipe(3)(int_time_100MHz'length-1 downto 0);
            
            -- pipe pour rendre valide la donnée qques CLKs apres sa sortie
            exp_dval_pipe(0)           <= FPA_INT;
            exp_dval_pipe(1)           <= exp_dval_pipe(0); 
            exp_dval_pipe(2)           <= exp_dval_pipe(1); 
            exp_dval_pipe(3)           <= exp_dval_pipe(2);
            exp_dval_pipe(4)           <= exp_dval_pipe(3);
            exp_dval_pipe(5)           <= exp_dval_pipe(4);
            int_time_100MHz_dval_i     <= exp_dval_pipe(5);        
            
            
            ---------------------------------------------------------------------------
            -- ETAPE 1 : validité des prémisses pour le calcul des pauses               
            ---------------------------------------------------------------------------         
            
            -- validité du temps d'integration
            if int_time_100MHz_dval_i = '1' then 
               integration_time_i <= int_time_100MHz;
            end if;
            
            -- periode minimale lorsque temps d'integration nul
            trig_period_min_wo_int <= FPA_INTF_CFG.COMN.FPA_ACQ_TRIG_PERIOD_MIN;
            
            -- trig_period minimale requis pour le temps d'integration actuel
            trig_period_min_i <= trig_period_min_wo_int +  integration_time_i;       
            
            -- validité du trig_period mesuré
            if unsigned(TRIG_PERIOD) > trig_period_min_i then
               trig_period_i <= unsigned(TRIG_PERIOD);
            end if; 
            
            -- delai pour MODE_TRIG_START_TO_TRIG_START
            trig_start_to_trig_start_dly <= trig_period_i - FPA_INTF_CFG.DYN_PAUSE_VHD_DLY;
            
            -- fpa_trig_ctrl_dly pour proteger le module fpa contre les changements live de periode de trig alors que le throughput est encore au ralenti
            if  FPA_INTF_CFG.COMN.FPA_TRIG_CTRL_MODE = MODE_INT_END_TO_TRIG_START then
               fpa_trig_ctrl_dly_i <= trig_start_to_trig_start_dly - integration_time_i;  -- vaut donc trig_period_min_wo_int
            else
               fpa_trig_ctrl_dly_i <= trig_start_to_trig_start_dly;  --pour le mode MODE_TRIG_START_TO_TRIG_START
            end if;
            
            
            ---------------------------------------------------------------------------
            -- ETAPE 2 : calcul des pauses               
            ---------------------------------------------------------------------------
            
            -- total théorique des pauses disséminées dans la preriode mesurée                                 
            if trig_period_i > FPA_INTF_CFG.READOUT_TIME_WO_PAUSE then 
               total_pause_temp_i <= resize(trig_period_i, total_pause_temp_i'length) - resize(FPA_INTF_CFG.READOUT_TIME_WO_PAUSE, total_pause_i'length);
            else        -- ce cas ne devrait en principe jamais arriver
               total_pause_temp_i <= (others => '0');  
            end if;           
            
            -- limitation volontaire pour que la division qui suit, fonctionne tout en ménageant la baisse de throughput
            if total_pause_temp_i > FPA_INTF_CFG.TOTAL_ADDITIONAL_PAUSE_LIMIT then
               total_pause_i <= resize(FPA_INTF_CFG.TOTAL_ADDITIONAL_PAUSE_LIMIT, total_pause_i'length);
            else
               total_pause_i <= total_pause_temp_i;
            end if;
            
            -- delai par ligne, en divisant total_pause par le nombre de lignes - 1
            temp_result <= resize(total_pause_i * FPA_INTF_CFG.DYN_PAUSE_CALC_NUMERATOR, temp_result'length);
            line_pause_temp_i <= temp_result(C_RESULT_MSB_POS downto C_DENOM_CONV_BIT_POS);  -- soit une division par 2^denom_conv_bit_pos
            
            -- tenir compte du delai des fsm
            if line_pause_temp_i >= 1  then 
               line_pause_i <=  line_pause_temp_i - 1; -- il faut enlever 1 puisque le fpa_pixel_rate_ctrler en rajoute déjà 1 à cause des delais de ses fsm
               dyn_pause_possible_i <= '1';
            else
               line_pause_i <= (others => '0');
               dyn_pause_possible_i <= '0';
            end if;
            
            
            ---------------------------------------------------------------------------
            -- ETAPE 3 : sortie des parametres de configuration              
            ---------------------------------------------------------------------------
            -- la configuration finale 
            cfg_valid_pipe(0) <= fpa_int_i or TRIG_PERIOD_DVAL;
            cfg_valid_pipe(7 downto 1) <= cfg_valid_pipe(6 downto 0);
            
            dyn_pause_cfg_i.data_cnt_max <= to_unsigned(to_integer(FPA_INTF_CFG.XSIZE_DIV4), dyn_pause_cfg_i.data_cnt_max'length);                   -- le temps de passage d'une ligne donne implicitement le throughput du détecteur. En clair si on arrive à compter XSIZE_DIV_4 en un temps T alors on a le thoughput actuel du détecteur
            dyn_pause_cfg_i.time_cnt_max <= to_unsigned(to_integer(FPA_INTF_CFG.XSIZE_DIV4) + to_integer(line_pause_i), dyn_pause_cfg_i.time_cnt_max'length);    -- le throuhput devient XSIZE_DIV_4/ (T + line_pause_i)
            dyn_pause_cfg_i.fpa_trig_ctrl_dly <=  fpa_trig_ctrl_dly_i;           
            dyn_pause_cfg_i.enabled <=  FPA_INTF_CFG.DYN_PAUSE_EN and dyn_pause_possible_i;
            
         end if;         
      end if;
   end process;       
   
   
   
   
end rtl;
