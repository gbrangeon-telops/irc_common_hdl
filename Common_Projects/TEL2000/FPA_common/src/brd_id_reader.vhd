------------------------------------------------------------------
--!   @file brd_id_reader
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

entity brd_id_reader is
   port(
      ARESET         : in std_logic;
      CLK_100M       : in std_logic;
      
      RUN            : in std_logic;   -- à '1' pour lancer le module des IDs
      DONE           : out std_logic;  -- '1' pour signaler la fin de la mesure;
      
      FREQ_ID        : in std_logic;
      
      ADC_BRD_INFO   : out adc_brd_info_type;
      FLEX_BRD_INFO  : out flex_brd_info_type;
      DDC_BRD_INFO   : out ddc_brd_info_type;
      ERR            : out std_logic
      );
end brd_id_reader;

architecture RTL of brd_id_reader is 
   
   constant CLK_100M_RATE   : natural := 100_000_000;
   constant MEAS_NUMBER_MAX : natural := 5;  -- nombre de measures à faire
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK    : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component; 
   
   component Clk_Divider is
      Generic(	
         Factor : integer := 2);		
      Port ( 
         Clock     : in std_logic;
         Reset     : in std_logic;		
         Clk_div   : out std_logic);
   end component;
   
   type freq_id_sm_type is (init_st, idle, wait_signal_st, meas_period_st, fetch_intf_st, check_result_adc_st, check_result_ddc_st, check_result_flex_st, check_meas_number_st, meas_result_st1, meas_result_st2);
   type detected_adc_type is array  (0 to MEAS_NUMBER_MAX) of adc_brd_info_type;
   type detected_ddc_type is array  (0 to MEAS_NUMBER_MAX) of ddc_brd_info_type;
   type detected_flex_type is array (0 to MEAS_NUMBER_MAX) of flex_brd_info_type;
   
   signal freq_id_sm             : freq_id_sm_type;
   signal adc_brd_info_i         : adc_brd_info_type;
   signal ddc_brd_info_i         : ddc_brd_info_type;
   signal flex_brd_info_i        : flex_brd_info_type;
   signal sreset                 : std_logic;
   signal freq_id_reg            : std_logic;
   signal freq_id_reg_last       : std_logic;
   signal count                  : natural;
   signal meas_number            : natural range 0 to MEAS_NUMBER_MAX + 1; 
   signal previous_meas_number   : natural range 0 to MEAS_NUMBER_MAX + 1; 
   signal pause_cnter            : unsigned(7 downto 0);   
   signal pause_clk_en           : std_logic;
   signal detected_adc           : detected_adc_type;
   signal detected_ddc           : detected_ddc_type;
   signal detected_flex          : detected_flex_type;
   signal done_i                 : std_logic;
   signal adc_detection_err      : std_logic;
   signal ddc_detection_err      : std_logic;
   signal flex_detection_err     : std_logic;
   signal one_sec_clk            : std_logic;
   signal clk_div                : std_logic;
   signal clk_div_last           : std_logic;
   
   
begin
   --------------------------------------------------
   -- mapping des sorties
   --------------------------------------------------    
   U0 : process(CLK_100M)
   begin
      if rising_edge(CLK_100M) then 
         ADC_BRD_INFO <= adc_brd_info_i;
         DDC_BRD_INFO <= ddc_brd_info_i;
         FLEX_BRD_INFO <= flex_brd_info_i;
         ERR <= '0';
         DONE <= done_i;
      end if;
   end process;
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1 : sync_reset
   port map(ARESET => ARESET, CLK => CLK_100M, SRESET => sreset); 
   
   --------------------------------------------------
   -- DET_FREQ_ID dans IOB si FREQ_ID est un pad
   -------------------------------------------------- 
   U2 : process(CLK_100M)
   begin
      if rising_edge(CLK_100M) then
         freq_id_reg <= FREQ_ID; 
      end if;
   end process;
   
   
   --------------------------------------------------
   -- horloge pour timeout
   -------------------------------------------------- 
   U3: Clk_Divider
   Generic map(
      Factor => CLK_100M_RATE
      -- pragma translate_off 
      /2_000
      -- pragma translate_on
      )
   Port map( 
      Clock   => CLK_100M,
      Reset   => sreset, 
      Clk_div => one_sec_clk   
      );
   
   --------------------------------------------------
   --  FSM  
   -------------------------------------------------- 
   U4 : process(CLK_100M)
   begin          
      if rising_edge(CLK_100M) then 
         if sreset = '1' then 
            freq_id_sm <= init_st; 
            freq_id_reg_last <= freq_id_reg;
            --meas_number <= 0; 
            pause_cnter <= (others => '0'); 
            done_i <= '0';
            adc_brd_info_i.dval <= '0';
            ddc_brd_info_i.dval <= '0';
            flex_brd_info_i.dval <= '0';
            clk_div_last <= '1';
            pause_clk_en <= '0'; 
            
         else 
            
            clk_div <= one_sec_clk;
            clk_div_last <= clk_div;
            pause_clk_en <= not clk_div_last and clk_div;
            
            freq_id_reg_last <= freq_id_reg;
            
            case freq_id_sm is 
               
               when init_st =>                              -- on attend au moins 1 seconde avant de commencer les mesures (le temps que les signaux soient stables)     
                  if pause_cnter = 2 then
                     freq_id_sm <= idle;
                  end if;
                  if pause_clk_en = '1' then             
                     pause_cnter <= pause_cnter + 1;
                  end if;
               
               when idle => 
                  done_i <= '1';
                  pause_cnter <= (others => '0');
                  meas_number <= 0;
                  adc_detection_err <= '0';
                  ddc_detection_err <= '0';
                  flex_detection_err <= '0'; 
                  if RUN = '1' then
                     adc_brd_info_i.dval <= '0';
                     ddc_brd_info_i.dval <= '0';
                     flex_brd_info_i.dval <= '0';
                     done_i <= '0';
                     freq_id_sm <= wait_signal_st;
                  end if;  
               
               when wait_signal_st =>                       -- on attend le front montant pour commencer les mesures. 
                  count <= 0;           
                  if freq_id_reg_last = '0'  and freq_id_reg = '1' then
                     freq_id_sm <= meas_period_st;
                     previous_meas_number <= meas_number;   
                     meas_number <= meas_number + 1;                     
                  end if;
                  if pause_cnter = 2 then                   -- S'il ne venait pas après 2 secondes environ, on statue que la nmesure a echoué
                     adc_detection_err  <= '1';
                     ddc_detection_err  <= '1';
                     flex_detection_err <= '1';
                     freq_id_sm <= meas_result_st1;
                  end if;
                  if pause_clk_en = '1' then             
                     pause_cnter <= pause_cnter + 1;
                  end if;
               
               when meas_period_st =>                       -- on mesure la période 
                  pause_cnter <= (others => '0');
                  count <= count + 1; 
                  if freq_id_reg_last = '0'  and freq_id_reg = '1' then
                     freq_id_sm <= fetch_intf_st;   
                  end if;
                  if pause_cnter = 2 then                   -- S'il ne venait pas après 2 secondes environ, on statut que la nmesure a echoué
                     adc_detection_err  <= '1';
                     ddc_detection_err  <= '1';
                     flex_detection_err <= '1';
                     freq_id_sm <= meas_result_st1;
                  end if;
                  if pause_clk_en = '1' then             
                     pause_cnter <= pause_cnter + 1;
                  end if;
               
               when fetch_intf_st =>                        -- on cherche le type de board auquel cela correspond
                  detected_adc(meas_number)  <= freq_to_adc_brd_info(count, CLK_100M_RATE);   -- carte ADC
                  detected_ddc(meas_number)  <= freq_to_ddc_brd_info(count, CLK_100M_RATE);   -- carte DDC
                  detected_flex(meas_number) <= freq_to_flex_brd_info(count, CLK_100M_RATE);  -- carte FLEX
                  if meas_number = 1 then 
                     freq_id_sm <= wait_signal_st; 
                  else                                     -- ie meas_number > 1 dans ce cas car meas_number /= 0 dans cet etat
                     freq_id_sm <= check_result_adc_st;
                  end if;                 
               
               when check_result_adc_st =>                   -- fonction de reconnaissance assy pour carte ADC
                  if  detected_adc(meas_number) /= detected_adc(previous_meas_number) then    
                     adc_detection_err <= '1';                     
                  end if; 
                  freq_id_sm <= check_result_ddc_st;
               
               when check_result_ddc_st =>                   -- fonction de reconnaissance assy pour carte DDC
                  if  detected_ddc(meas_number) /= detected_ddc(previous_meas_number) then    
                     ddc_detection_err <= '1';                        
                  end if;
                  freq_id_sm <= check_result_flex_st;
               
               when check_result_flex_st =>                  -- fonction de reconnaissance assy pour carte FLEX
                  if  detected_flex(meas_number) /= detected_flex(previous_meas_number) then    
                     flex_detection_err <= '1'; 
                  end if;
                  freq_id_sm <= check_meas_number_st;                        
               
               when check_meas_number_st =>                  -- on fait la mesure MEAS_NUMBER_MAX fois de suite
                  if meas_number = MEAS_NUMBER_MAX then                     
                     freq_id_sm <= meas_result_st1;
                  else
                     freq_id_sm <= wait_signal_st; 
                  end if;
               
               when meas_result_st1 =>                       -- si mesures faites avec succès alors on considère les données de la fonction de conversion. On ne sort plus de cet état                
                  adc_brd_info_i  <= detected_adc(meas_number);
                  ddc_brd_info_i  <= detected_ddc(meas_number);
                  flex_brd_info_i <= detected_flex(meas_number);
                  adc_brd_info_i.dval  <= '0';
                  ddc_brd_info_i.dval  <= '0';
                  flex_brd_info_i.dval <= '0';
                  freq_id_sm <= meas_result_st2;
               
               when meas_result_st2 =>                       -- Sinon, on vient ecraser avec BRD_INFO_UNKNOWN                   
                  if adc_detection_err = '1' then 
                     adc_brd_info_i <= ADC_BRD_INFO_UNKNOWN;
                  end if;
                  if ddc_detection_err = '1' then
                     ddc_brd_info_i  <= DDC_BRD_INFO_UNKNOWN;
                  end if;
                  if flex_detection_err = '1' then
                     flex_brd_info_i <= FLEX_BRD_INFO_UNKNOWN;
                  end if;
                  adc_brd_info_i.dval  <= '1';
                  ddc_brd_info_i.dval  <= '1';
                  flex_brd_info_i.dval <= '1';               
                  freq_id_sm <= idle;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   
end RTL;
