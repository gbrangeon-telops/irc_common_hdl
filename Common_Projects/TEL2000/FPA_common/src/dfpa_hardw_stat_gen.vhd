------------------------------------------------------------------
--!   @file dfpa_hardw_stat_gen
--!   @brief generateur de statut Hardware (mise à jour carte et type d'interface branché sur Iddca)
--!   @details ce module lit le DET_FREQ_ID et le convertit en type d'interface détecteur
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
use work.fpa_common_pkg.all;

entity dfpa_hardw_stat_gen is
   port(
      ARESET         : in std_logic;
      CLK_100M       : in std_logic;
      DET_FREQ_ID    : in std_logic;
      FPA_HARDW_STAT : out fpa_hardw_stat_type
      );
end dfpa_hardw_stat_gen;

architecture RTL of dfpa_hardw_stat_gen is 
   --constant HARDW_STAT_UNKNOWN : fpa_hardw_stat_type  :=
   --   (
   --   '0',                -- dval
   --   BRD_INFO_UNKNOWN,   -- adc_info
   --   BRD_INFO_UNKNOWN,   -- ddc_info
   --   BRD_INFO_UNKNOWN,   -- flex_info
   --   IDDCA_INFO_UNKNOWN, -- iddca info
   --   '0'                 -- hardw_up2date
   --   );
   --   
   constant CLK_100M_RATE   : natural := 100_000_000;
   constant MEAS_NUMBER_MAX : natural := 3;  -- nombre de measures à faire
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK    : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component; 
   
   component clk_divider_pulse
      generic(FACTOR : integer);
      port(
         CLOCK : in std_logic;
         RESET : in std_logic;
         PULSE : out std_logic);
   end component;
   
   type freq_id_sm_type is (init_st, wait_signal_st, meas_period_st, fetch_intf_st, check_result_st1, check_result_st2, 
   check_result_st3, check_result_st4, check_meas_number_st, meas_success_st, meas_failure_st);
   type detected_iddca_type is array (1 to MEAS_NUMBER_MAX) of ddc_brd_info_type;
   signal detected_iddca        : detected_iddca_type;
   signal freq_id_sm             : freq_id_sm_type;
   signal fpa_hardw_stat_i       : fpa_hardw_stat_type;
   signal sreset                 : std_logic;
   signal det_freq_id_reg        : std_logic;
   signal det_freq_id_reg_last   : std_logic;
   signal count                  : natural;
   signal meas_number            : natural range 0 to MEAS_NUMBER_MAX + 1; 
   signal previous_meas_number   : natural range 0 to MEAS_NUMBER_MAX + 1; 
   signal pause_cnter            : unsigned(2 downto 0);   
   --signal timeout_clk_en         : std_logic;
   signal pause_clk_en           : std_logic;
   
   
begin
   --------------------------------------------------
   -- mapping des sorties
   --------------------------------------------------    
   FPA_HARDW_STAT <= fpa_hardw_stat_i;
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1 : sync_reset
   port map(ARESET => ARESET, CLK => CLK_100M, SRESET => sreset); 
   
   --------------------------------------------------
   -- DET_FREQ_ID dans IOB
   -------------------------------------------------- 
   U2 : process(CLK_100M)
   begin
      if rising_edge(CLK_100M) then
         det_freq_id_reg <= DET_FREQ_ID; 
      end if;
   end process;
   
   
   --------------------------------------------------
   -- holroge pour timeout
   -------------------------------------------------- 
   U3 : Clk_Divider_Pulse
   Generic map( FACTOR => 
      CLK_100M_RATE            -- cela donne 1 seconde de periode 
      -- 
      -- /10000             -- cela donne 100 usec de periode pour la simulation 
      --       
      )	
   
   Port map(		
      CLOCK   => CLK_100M,		
      RESET   => sreset,
      PULSE   => pause_clk_en
      );
   
   --------------------------------------------------
   -- process
   -------------------------------------------------- 
   U4 : process(CLK_100M)
      variable iddca_info             : iddca_info_type;
      
   begin          
      if rising_edge(CLK_100M) then 
         if sreset = '1' then 
            freq_id_sm <= init_st; 
            det_freq_id_reg_last <= det_freq_id_reg;
            fpa_hardw_stat_i <= HARDW_STAT_UNKNOWN;         -- par defaut on spéifie qu'on ne connait pas le harwdare présent
            meas_number <= 0; 
            pause_cnter <= (others => '0');  
         else 
            
            det_freq_id_reg_last <= det_freq_id_reg;
            
            case freq_id_sm is 
               
               when init_st =>                              -- on attend au moins 1 seconde avant de commencer les mesures (le temps que les signaux soient stables)     
                  if pause_cnter = 1 then
                     freq_id_sm <= wait_signal_st;
                     pause_cnter <= (others => '0');
                  else
                     if pause_clk_en = '1' then             -- pulse de 1 sec
                        pause_cnter <= pause_cnter + 1;
                     end if;
                  end if;               
               
               when wait_signal_st =>                       -- on attend le front montant pour commencer les mesures. S'il ne venait jamais alors fpa_hardw_stat_i est invalide (le sequenceur gère cela)  
                  count <= 0;           
                  if det_freq_id_reg_last = '0'  and det_freq_id_reg = '1' then
                     freq_id_sm <= meas_period_st;
                     previous_meas_number <= meas_number;   
                     meas_number <= meas_number + 1;                     
                  end if;
                  if pause_cnter = 2 then          -- erreur si aucun front après 2 sec
                     freq_id_sm <= meas_failure_st;
                  else
                     if pause_clk_en = '1' then             -- pulse de 1 sec
                        pause_cnter <= pause_cnter + 1;
                     end if;
                  end if;
               
               when meas_period_st =>                       -- on mesure la période (prochain front montant)
                  count <= count + 1; 
                  if det_freq_id_reg_last = '0'  and det_freq_id_reg = '1' then
                     freq_id_sm <= fetch_intf_st;   
                  end if;
               
               when fetch_intf_st =>                        -- on cherche le type de iddca auquel cela correspond
                  detected_iddca(meas_number) <= freq_to_ddc_brd_info(count, CLK_100M_RATE); 
                  if meas_number = 1 then 
                     freq_id_sm <= wait_signal_st; 
                  else                                     -- ie meas_number > 1 dans ce cas car meas_number /= 0 dans cet etat
                     freq_id_sm <= check_result_st1;
                  end if;                 
               
               when check_result_st1 =>                     -- les fpa_roic des mesures doivent être identiques
                  if  detected_iddca(meas_number).fpa_roic = detected_iddca(previous_meas_number).fpa_roic then    
                     freq_id_sm <= check_result_st2;
                  else
                     freq_id_sm <= meas_failure_st;                        
                  end if;  
               
               when check_result_st2 =>                     -- les output_type des mesures doivent être identiques
                  if  detected_iddca(meas_number).fpa_output = detected_iddca(previous_meas_number).fpa_output then    
                     freq_id_sm <= check_result_st3;
                  else
                     freq_id_sm <= meas_failure_st;                        
                  end if;
               
               when check_result_st3 =>                     -- les cooler_volt_min_mV des mesures doivent être identiques
                  if  detected_iddca(meas_number).cooler_volt_min_mV = detected_iddca(previous_meas_number).cooler_volt_min_mV then    
                     freq_id_sm <= check_result_st4;
                  else
                     freq_id_sm <= meas_failure_st;                        
                  end if; 
               
               when check_result_st4 =>                     -- les cooler_volt_max_mV des mesures doivent être identiques
                  if  detected_iddca(meas_number).cooler_volt_max_mV = detected_iddca(previous_meas_number).cooler_volt_max_mV then    
                     freq_id_sm <= check_meas_number_st;
                  else                     
                     freq_id_sm <= meas_failure_st;                        
                  end if;                    
               
               when check_meas_number_st =>                 -- on vérifie qu'on a fait le nombre de mesures specifiées
                  if meas_number = MEAS_NUMBER_MAX then                     
                     freq_id_sm <= meas_success_st;
                  else
                     freq_id_sm <= wait_signal_st; 
                  end if;
               
               when meas_success_st =>                      -- on ne sort plus de cet etat
                  iddca_info.fpa_roic   := detected_iddca(meas_number).fpa_roic;
                  iddca_info.fpa_output := detected_iddca(meas_number).fpa_output;
                  iddca_info.fpa_input  := detected_iddca(meas_number).fpa_input;
                  iddca_info.cooler_volt_min_mV := detected_iddca(meas_number).cooler_volt_min_mV;
                  iddca_info.cooler_volt_max_mV := detected_iddca(meas_number).cooler_volt_max_mV;
                  iddca_info.dval       := '1';                  
                  fpa_hardw_stat_i.dval <= '1';
                  fpa_hardw_stat_i.ddc_brd_info <= detected_iddca(meas_number);
                  fpa_hardw_stat_i.iddca_info <= iddca_info;
               
               when meas_failure_st =>                      -- on ne sort plus de cet etat
                  iddca_info.fpa_roic   := FPA_ROIC_UNKNOWN;
                  iddca_info.fpa_output := OUTPUT_UNKNOWN;
                  iddca_info.fpa_input  := INPUT_UNKNOWN;
                  iddca_info.cooler_volt_min_mV := 1;
                  iddca_info.cooler_volt_max_mV := 0;
                  iddca_info.dval       := '1';  
                  fpa_hardw_stat_i.dval <= '1';
                  fpa_hardw_stat_i <= HARDW_STAT_UNKNOWN;
                  fpa_hardw_stat_i.iddca_info <= iddca_info;
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
end RTL;
