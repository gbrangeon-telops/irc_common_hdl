------------------------------------------------------------------
--!   @file : monitoring_adc_ctrl
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
use work.adc_brd_define.all;
--use work.FPA_define.all;

entity monitoring_adc_ctrl is
   port(		
      CLK        : in std_logic;
      ARESET     : in std_logic;
      
      EN         : in std_logic;
      RQST       : out std_logic;
      DONE       : out std_logic;
      
      CSN        : out std_logic;
      SCLK       : out std_logic;
      MOSI       : out std_logic;
      MISO       : in std_logic;
      
      FPA_TEMP   : out t_ll_ext_mosi16;
      PCB_TEMP   : out t_ll_ext_mosi16;
      FPA_DIGIOV : out t_ll_ext_mosi16;
      FLEX_PSP   : out t_ll_ext_mosi16;
      MEAS_TP    : out t_ll_ext_mosi16;
      
      ERR        : out std_logic
      );                        
end monitoring_adc_ctrl;

architecture rtl of monitoring_adc_ctrl is
   
   
   component ads1118_driver      
      port (
         CLK 		 : in std_logic;
         ARESET 	 : in std_logic;     
         ADC_CH    : in std_logic_vector(7 downto 0);             
         ADC_RUN   : in std_logic;                       
         ADC_BUSY	 : out std_logic;                      
         ADC_SCLK  : in std_logic;                     
         SPI_MOSI  : out std_logic; 
         SPI_MISO	 : in std_logic;
         SPI_SCLK	 : out std_logic; 
         SPI_CSN	 : out std_logic;  
         ADC_DATA  : out std_logic_vector(15 downto 0); 
         ADC_DVAL  : out std_logic; 
         ADC_ERR   : out std_logic 
         );      
   end component;
   
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   component Clk_Divider is
      Generic(	Factor:		integer := 2);		
      Port ( 
         Clock  : in std_logic;
         Reset  : in std_logic;		
         Clk_div: out std_logic);
   end component;
   
   component signal_filter
      port (
         CLK : in STD_LOGIC;
         SIG_IN : in STD_LOGIC;
         SIG_OUT : out STD_LOGIC
         );
   end component;
   
   type monit_adc_sm_type is (idle, rqst_st, check_ch_st0, check_ch_st1, check_ch_st2, check_ch_st3, check_ch_stf, start_meas_st, run_sample_st, wait_sample_st, inc_meas_cnt_st);
   type sample_fsm_type is (idle, sample_sum_st, check_enough_st, comput_data_st, output_data_st, output_dval_st1, output_dval_st2, output_dval_st3, output_dval_st4, output_dval_st5, data_mean_st);  
   
   signal sreset                : std_logic;
   signal dout                  : std_logic_vector(15 downto 0);
   signal fpa_temp_dval         : std_logic;
   signal fpa_digiov_dval       : std_logic;
   signal flex_psp_dval         : std_logic;
   signal meas_tp_dval          : std_logic;
   signal pcb_temp_dval         : std_logic;
   signal adc_ch_to_read        : std_logic_vector(7 downto 0);
   signal adc_ch_read           : std_logic_vector(7 downto 0);
   signal monit_adc_sm          : monit_adc_sm_type;
   signal adc_run               : std_logic;
   signal adc_busy              : std_logic;
   signal adc_sclk              : std_logic;
   signal meas_trig             : std_logic;
   signal meas_trig_last        : std_logic;
   signal adc_data              : std_logic_vector(15 downto 0);
   signal adc_dval              : std_logic;
   signal meas_cnt              : integer range 0 to 63;
   signal sample_sm_en          : std_logic;
   signal init_meas             : std_logic;
   signal done_i                : std_logic;
   signal sample_fsm            : sample_fsm_type;
   signal sample_sum            : integer;
   signal sample_mean           : integer;
   signal sample_cnt            : integer range 0 to DEFINE_ADC_SAMPLE_SUM_NUM;
   signal adc_ch_gain_factor_to_use    : integer range 0 to 4095;
   signal adc_ch_gain_factor    : integer range 0 to 4095;
   signal computed_data         : integer;
   signal sample_done           : std_logic;
   signal clean_miso            : std_logic;
   
   attribute dont_touch              : string;
   attribute dont_touch of dout                       : signal is "true";
   attribute dont_touch of fpa_temp_dval              : signal is "true";
   attribute dont_touch of fpa_digiov_dval            : signal is "true";
   attribute dont_touch of flex_psp_dval              : signal is "true";
   attribute dont_touch of meas_tp_dval               : signal is "true";
   attribute dont_touch of pcb_temp_dval              : signal is "true";
   
begin
   
   --------------------------------------
   --  outputs
   --------------------------------------
   
   FPA_TEMP.DATA <= dout;  
   FPA_TEMP.DVAL <= fpa_temp_dval;
   
   FPA_DIGIOV.DATA <= dout;  
   FPA_DIGIOV.DVAL <= fpa_digiov_dval;
   
   FLEX_PSP.DATA <= dout;  
   FLEX_PSP.DVAL <= flex_psp_dval;
   
   MEAS_TP.DATA <= dout;  
   MEAS_TP.DVAL <= meas_tp_dval;
   
   PCB_TEMP.DATA <= dout;  
   PCB_TEMP.DVAL <= pcb_temp_dval;
   
   DONE <= done_i;
   
   ------------------------------------
   -- sync reset
   ------------------------------------
   U1: sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK); 
   
   
   --------------------------------------------------
   -- Genereteur de l'horloge SPI de l'ADC
   -------------------------------------------------- 
   UcA: Clk_Divider
   Generic map(Factor=> DEFINE_ADC_SPI_CLK_FACTOR)
   Port map( Clock => CLK, Reset => sreset, Clk_div => adc_sclk);
   
   
   --------------------------------------------------
   -- Genereteur de l'horloge des mesures
   -------------------------------------------------- 
   UcB: Clk_Divider
   Generic map(Factor=> DEFINE_ADC_TRIG_CLK_FACTOR
      
      -- pragma translate_off
      /(DEFINE_ADC_TRIG_CLK_FACTOR/10)
      -- pragma translate_on
      
      )
   Port map( Clock => CLK, Reset => sreset, Clk_div => meas_trig);
   
   
   --------------------------------------------------
   -- MISO est filtré avant d'être utilisé
   -------------------------------------------------- 
   U10 : signal_filter
   port map(
      CLK => CLK,
      SIG_IN => MISO,
      SIG_OUT => clean_miso
      );
   
   
   ------------------------------------
   -- adc driver map
   ------------------------------------
   U2: ads1118_driver      
   port map(
      CLK 		=>  CLK,
      ARESET 	=>  ARESET,
      ADC_CH   =>  adc_ch_to_read, -- x"FF" -> PCB temperature, x"00" --> fpa_temp , x"01" --> fpa_digiov, x"02" --> flex_psp , x"03" --> test_point          
      ADC_RUN  =>  adc_run, 
      ADC_BUSY	=>  adc_busy, 
      ADC_SCLK =>  adc_sclk,
      SPI_MOSI =>  MOSI,
      SPI_MISO	=>  clean_miso,
      SPI_SCLK	=>  SCLK,
      SPI_CSN	=>  CSN,
      ADC_DATA =>  adc_data,
      ADC_DVAL =>  adc_dval,
      ADC_ERR  =>  ERR
      );    
   
   
   --------------------------------------------------
   -- Fsm de contrôle
   -------------------------------------------------- 
   U3 : process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            monit_adc_sm <= idle; 
            RQST <= '0';
            adc_run <= '0';
            meas_cnt <= 0;
            sample_sm_en <= '0';
            meas_trig_last <= '1';
            init_meas <= '0';
         else 
            
            
            meas_trig_last <= meas_trig; 
            init_meas <= not meas_trig_last and meas_trig;
            
            case monit_adc_sm is 
               
               when idle =>
                  done_i <= '1';
                  adc_run <= '0';
                  sample_sm_en <= '0';
                  if init_meas = '1' then 
                     monit_adc_sm <= rqst_st;
                  end if;
               
               when rqst_st =>
                  RQST <= not adc_busy;
                  if EN = '1' then 
                     monit_adc_sm <= check_ch_st1;
                  end if;
               
               when check_ch_st1 =>
                  RQST <= '0';
                  done_i <= '0';
                  if meas_cnt <= 7 then     -- FPA_DIGIO : 8 mesures consecutives sur 64 (soit 8 echantillons)
                     adc_ch_to_read <= x"01";
                     adc_ch_gain_factor_to_use <= DEFINE_FPA_DIGIOV_CONV_FACTOR_X_1024;
                     monit_adc_sm <= start_meas_st;
                  else
                     monit_adc_sm <= check_ch_st2; 
                  end if;
               
               when check_ch_st2 =>                             -- FLEX_PSP : 8 mesures consecutives sur 64 (soit 8 echantillons)
                  if meas_cnt <= 15 then                        -- subitilé: compte-tenu de l'état précédent, cela revient à (meas_cnt > 7 and meas_cnt <= 15)
                     adc_ch_to_read <= x"02";
                     adc_ch_gain_factor_to_use <= DEFINE_FLEX_PSP_CONV_FACTOR_X_1024;
                     monit_adc_sm <= start_meas_st;
                  else
                     monit_adc_sm <= check_ch_st3; 
                  end if;  
               
               when check_ch_st3 =>                             -- TEST_POINT : 8 mesures consecutives sur 64 (soit 8 echantillons)
                  if meas_cnt <= 23 then
                     adc_ch_to_read <= x"03";
                     adc_ch_gain_factor_to_use <= DEFINE_TP_MEAS_CONV_FACTOR_X_1024;
                     monit_adc_sm <= start_meas_st;
                  else
                     monit_adc_sm <= check_ch_stf; 
                  end if;   
               
               when check_ch_stf =>                             -- PCB_TEMP : 8 mesures consecutives sur 64 (soit 8 echantillons)
                  if meas_cnt <= 31 then
                     adc_ch_to_read <= x"FF";
                     adc_ch_gain_factor_to_use <= DEFINE_PCB_TEMP_CONV_FACTOR_X_1024;
                     monit_adc_sm <= start_meas_st;
                  else
                     monit_adc_sm <= check_ch_st0; 
                  end if; 
               
               when check_ch_st0 =>                             -- FPA_TEMP : 32 mesures sur 64
                  adc_ch_to_read <= x"00";
                  adc_ch_gain_factor_to_use <= DEFINE_FPA_TEMP_CONV_FACTOR_X_1024;
                  monit_adc_sm <= start_meas_st;
               
               when start_meas_st => 
                  adc_run <= '1';
                  if adc_busy = '1' then
                     monit_adc_sm <= run_sample_st;                     
                  end if;
               
               when run_sample_st =>
                  adc_run <= '0';
                  sample_sm_en <= '1';                  
                  if sample_done = '0' then
                     sample_sm_en <= '0';    -- fait expres pour le process suivant
                     monit_adc_sm <= wait_sample_st;
                  end if;          
               
               when wait_sample_st => 
                  if sample_done = '1' then 
                     monit_adc_sm <= inc_meas_cnt_st;                     
                  end if;
               
               when inc_meas_cnt_st =>    
                  meas_cnt <= (meas_cnt + 1) mod 64;                  
                  monit_adc_sm <= idle;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   
   --------------------------------------------------
   -- reduction de bruit de mesures
   -------------------------------------------------- 
   U4 : process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            sample_fsm <= idle;
            fpa_temp_dval <= '0';
            fpa_digiov_dval <= '0';
            flex_psp_dval <= '0';
            meas_tp_dval <= '0';
            pcb_temp_dval <= '0';
            sample_done <= '0';
         else 
            
            
            case sample_fsm is 
               
               when idle => 
                  fpa_temp_dval <= '0';
                  fpa_digiov_dval <= '0';
                  flex_psp_dval <= '0';
                  meas_tp_dval <= '0';
                  pcb_temp_dval <= '0';                     
                  sample_sum <= 0;
                  sample_cnt <= 0;
                  sample_done <= '1';
                  if  sample_sm_en = '1' then
                     sample_fsm <= sample_sum_st;
                     adc_ch_read <= adc_ch_to_read;
                     adc_ch_gain_factor <= adc_ch_gain_factor_to_use;
                  end if;           
               
               when sample_sum_st => 
                  sample_done <= '1';        -- fait expres pour le process précédent
                  if adc_dval = '1' then
                     sample_done <= '0';     -- fait expres pour le process précédent
                     sample_sum <=  sample_sum + to_integer(signed(adc_data)); 
                     sample_cnt <= sample_cnt + 1; 
                     sample_fsm <= check_enough_st;
                  end if;          
               
               when check_enough_st =>
                  if sample_cnt = DEFINE_ADC_SAMPLE_SUM_NUM then 
                     sample_fsm <= data_mean_st;
                  else
                     sample_fsm <= sample_sum_st;
                  end if;                
               
               when data_mean_st => 
                  if  adc_ch_read = x"FF" then
                     sample_mean <= sample_sum/DEFINE_ADC_SAMPLE_SUM_NUM;    -- température PCB est déjà sur 16 bits. il faut que  DEFINE_ADC_SAMPLE_DIV_NUM soit une puissance de 2
                  else
                     sample_mean <= sample_sum/DEFINE_ADC_SAMPLE_DIV_NUM;   -- resultat final sur 16 bits il faut que  DEFINE_ADC_SAMPLE_DIV_NUM soit une puissance de 2.
                  end if;
                  sample_fsm <= comput_data_st; 
               
               when comput_data_st =>
                  computed_data <= sample_mean*adc_ch_gain_factor; 
                  sample_fsm <= output_data_st;
               
               when output_data_st =>
                  dout <= std_logic_vector(to_signed(computed_data/DEFINE_1024, dout'length));  -- permet de retrouver la valeur réellement mesurée 
                  sample_fsm <= output_dval_st1;
               
               when output_dval_st1 =>                  
                  if  adc_ch_read = x"00" then 
                     fpa_temp_dval <= '1';
                     sample_fsm <= idle;
                  else
                     sample_fsm <= output_dval_st2;  
                  end if;
               
               when output_dval_st2 =>
                  if  adc_ch_read = x"01" then 
                     fpa_digiov_dval <= '1';
                     sample_fsm <= idle;
                  else
                     sample_fsm <= output_dval_st3;  
                  end if;        
               
               when output_dval_st3 =>
                  if  adc_ch_read = x"02" then
                     flex_psp_dval <= '1';
                     sample_fsm <= idle;
                  else
                     sample_fsm <= output_dval_st4;   
                  end if;                  
               
               when output_dval_st4 =>
                  if  adc_ch_read = x"03" then
                     meas_tp_dval <= '1';
                     sample_fsm <= idle;
                  else
                     sample_fsm <= output_dval_st5;  
                  end if;     
               
               when output_dval_st5 =>
                  if  adc_ch_read = x"FF" then
                     pcb_temp_dval <= '1';                     
                  end if;                  
                  sample_fsm <= idle;                  
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;  
   
   
end rtl;
