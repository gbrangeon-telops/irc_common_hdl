-------------------------------------------------------------------------------
--
-- Title       : ads1118_driver.vhd
-- Design      : Common_HDL
-- Author      : Edem Nofodjie
-- Company     : Telops Inc.
--
--  $Revision: 
--  $Author: 
--  $LastChangedDate:
-------------------------------------------------------------------------------
--

-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity ads1118_driver is
   
   port (
      CLK 					: in std_logic;
      ARESET 				: in std_logic;
      
      -- control interface 
      ADC_CH         	: in std_logic_vector(7 downto 0);     -- channel to read. x"FF" => PCB temperature; x"00" => ADC input 0, x"01" => ADC input 1, "02" => ADC input 2, "03" => ADC input 3
      ADC_RUN           : in std_logic;                        -- init the read process with the parameter set in ADC_CH
      ADC_BUSY				: out std_logic;                       -- '1' when a read process is in progress
      ADC_SCLK          : in std_logic;                        -- clk spi transféré à l'ADC
      
      -- ADS118 side
      SPI_MOSI 			: out std_logic;  -- data sent to ADC
      SPI_MISO		      : in std_logic;   -- data from ADC
      SPI_SCLK				: out std_logic;  -- spi clock
      SPI_CSN				: out std_logic;  -- spi chip select (active low)
      
      -- data read from ADC
      ADC_DATA 			: out std_logic_vector(15 downto 0);   -- data read from adc and sent to user interface
      ADC_DVAL          : out std_logic;                       -- data valid
      ADC_ERR           : out std_logic                        -- error
      );
   
end ads1118_driver;

architecture rtl of ads1118_driver is
   constant SS      : std_logic           := '0';   -- '1' -> let start single conversion, '0' No effect
   constant MUX     : std_logic_vector    := "100"; -- default value
   constant PGA     : std_logic_vector    := "010"; -- FS = ±2.048V 
   constant MODE    : std_logic           := '0';   -- '1' -> power-down and signle-shot mode, '0' -> continuous conversion nmode
   constant DR      : std_logic_vector    := "101"; -- Irrelevant in signle conversion mode. In continuous conversion mode, "101" = 250 conversions per second soit une periode de 4 ms
   constant TS_MODE : std_logic           := '0';   -- default value. '0' => adc mode. '1' => temperature sensor mode
   constant PULL_UP : std_logic           := '1';   -- '1' => enable pull-up on SDO
   constant NOP     : std_logic_vector    := "01";  --  Valid data, update the Config register (default)
   constant NUSED   : std_logic           := '1';   -- not used
   
   constant ADC_CFG_DEFAULT     : std_logic_vector(15 downto 0):= SS & MUX & PGA & MODE & DR & TS_MODE & PULL_UP & NOP & NUSED;
   constant C_TEMP_CH_ID        : std_logic_vector(7 downto 0) := x"FF";
   constant C_CSN_PAUSE_FACTOR  : natural := 1_000_000; -- soit 10 ms (doit valoir au moins 1 fois ou mieux, 2 fois la periode inscrite dans le registre DR afin de s'assurer qu'une nouvelle conversion sera dispo. 
   
   type spi_rx_sm_type is (idle, grab_data_st, check_data_st, temp_conv_st, output_data_st);
   type adc_driver_sm_type is (idle, build_default_cfg_st, build_ch_cfg_st, build_temp_cfg_st, csn_low_st, wait_clk_fe_st,
   send_tx_data_st, check_tx_end_st, tx_end_st, pause_st, csn_high_st, check_read_flag_st);
   
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   signal sreset             : std_logic;
   signal adc_data_i         : std_logic_vector(ADC_DATA'LENGTH-1 downto 0);
   signal adc_dval_i         : std_logic;
   signal adc_busy_i         : std_logic;
   signal spi_mosi_i         : std_logic;
   signal spi_sclk_i         : std_logic;
   signal spi_csn_i          : std_logic;
   signal adc_clk_sync       : std_logic;
   signal adc_clk_sync_last  : std_logic;
   signal spi_sclk_fall      : std_logic;
   signal spi_sclk_rise      : std_logic;
   signal spi_sclk_pipe      : std_logic_vector(7 downto 0);
   signal spi_sclk_window    : std_logic;
   signal spi_miso_i         : std_logic;
   signal spi_rx_sm          : spi_rx_sm_type;
   signal read_in_progress   : std_logic;
   signal dcnt, bit_cnt      : integer range -1 to 15;
   signal rx_data            : std_logic_vector(15 downto 0);
   signal adc_temp_read      : std_logic;
   signal adc_driver_sm      : adc_driver_sm_type;
   signal pause_cnt          : unsigned(23 downto 0);
   signal adc_ch_i           : std_logic_vector(ADC_CH'LENGTH-1 downto 0);
   signal adc_cfg_word       : std_logic_vector(ADC_CFG_DEFAULT'LENGTH-1 downto 0);
   signal spi_rx_sclk_fall   : std_logic;
   signal spi_rx_sclk_last   : std_logic;
   signal waiting_for_miso_low_st : std_logic;
   
   attribute dont_touch : string;
   attribute dont_touch of read_in_progress : signal is "true"; 
   attribute dont_touch of spi_csn_i        : signal is "true";
   attribute dont_touch of spi_sclk_i : signal is "true";
   attribute dont_touch of waiting_for_miso_low_st : signal is "true";
   
   
   
begin
   
   ADC_DATA <= adc_data_i;
   ADC_DVAL <= adc_dval_i;
   
   ADC_BUSY <= adc_busy_i;
   SPI_MOSI <= spi_mosi_i;
   SPI_SCLK <= spi_sclk_i;
   SPI_CSN  <= spi_csn_i;
   
   ADC_ERR <= '0';
   ------------------------------------
   -- sync reset
   ------------------------------------
   U1: sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK); 
   
   
   ------------------------------------
   -- spi sclk and miso                   
   ------------------------------------
   U2: process(CLK)
   begin
      if rising_edge(CLK) then 
         
         -- sync
         adc_clk_sync <= ADC_SCLK;
         
         -- edges detection
         adc_clk_sync_last <= adc_clk_sync;
         spi_sclk_fall <=  adc_clk_sync_last and not adc_clk_sync;
         spi_sclk_rise <=  not adc_clk_sync_last and adc_clk_sync;
         
         -- spi_clk_gen 
         spi_sclk_pipe(0) <= adc_clk_sync;
         spi_sclk_pipe(7 downto 1) <= spi_sclk_pipe(6 downto 0);
         spi_sclk_i <= spi_sclk_pipe(3) and spi_sclk_window;    -- synchro parfaite avec spi_sclk_window
         
         -- miso
         spi_miso_i <= SPI_MISO;
         
      end if;
   end process;
   
   
   ------------------------------------
   -- spi rx                   
   ------------------------------------
   U3: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            spi_rx_sm <= idle;
            adc_dval_i <= '0';
            spi_rx_sclk_fall <= '0';
            spi_rx_sclk_last <= '0';
         else
            
            spi_rx_sclk_last <= spi_sclk_i;
            spi_rx_sclk_fall <= spi_rx_sclk_last and not spi_sclk_i;
            
            
            case spi_rx_sm is
               
               when idle =>
                  adc_dval_i <= '0';
                  dcnt <= 15;
                  if  read_in_progress = '1' and spi_csn_i = '0' then 
                     spi_rx_sm <= grab_data_st;                     
                  end if;                   
               
               when grab_data_st =>
                  if  spi_rx_sclk_fall = '1' then  
                     rx_data(dcnt) <= spi_miso_i;
                     dcnt <= dcnt - 1;
                  end if;
                  if spi_csn_i = '1' then 
                     spi_rx_sm <= check_data_st;  
                  end if;                  
               
               when check_data_st =>
                  if adc_temp_read  = '1' then
                     spi_rx_sm <= temp_conv_st; 
                  else
                     spi_rx_sm <= output_data_st;
                  end if;
               
               when temp_conv_st =>
                  rx_data <= std_logic_vector(signed(rx_data)/128); -- en degC . Consulter la doc de ads1118. 1/32 = 0.03125. La division par 32 ne pose pas de probleme en 1CLK. le 1/128 = 1/(4*32). 4 vient de la justification à gauche des 14 bits de température.
                  spi_rx_sm <= output_data_st;
               
               when output_data_st =>
                  adc_data_i <= std_logic_vector(rx_data);
                  adc_dval_i <= '1';
                  spi_rx_sm <= idle;
               
               when others =>
               
            end case;
            
            
         end if;
      end if;
   end process;
   
   ------------------------------------
   -- spi tx                   
   ------------------------------------
   -- fait deux envois. le premier pour configuer, le second pour lire la donnée liée à la configuration du 1er envoi. Entre les deux envois, on a un delai permettant à une nouvelle conversion de se efaire selon la config envoyée.
   -- adc_busy_i retombe à '0' seulement au terme des deux envois.
   
   U4: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            adc_driver_sm <= idle;
            adc_busy_i <= '1';
            read_in_progress <= '0';
            spi_csn_i  <= '1';
            
         else
            
            case adc_driver_sm is
               
               when idle =>
                  waiting_for_miso_low_st <= '0';
                  spi_sclk_window <= '0';
                  read_in_progress <= '0';
                  adc_busy_i <= '0';
                  bit_cnt <= 15;
                  pause_cnt <= (others => '0');
                  adc_temp_read <= '0';
                  spi_csn_i  <= '1';
                  if  ADC_RUN = '1' then 
                     adc_driver_sm <= build_default_cfg_st;
                     adc_ch_i <= ADC_CH;                     
                  end if;                   
               
               when build_default_cfg_st => 
                  adc_busy_i <= '1';
                  adc_cfg_word <= ADC_CFG_DEFAULT;
                  adc_driver_sm <= build_ch_cfg_st;
               
               when build_ch_cfg_st =>   
                  adc_cfg_word(13 downto 12) <= adc_ch_i(1 downto 0); 
                  if adc_ch_i = C_TEMP_CH_ID then
                     adc_driver_sm <= build_temp_cfg_st;
                     adc_temp_read <= '1';
                  else
                     adc_driver_sm <= csn_low_st;
                  end if;
               
               when build_temp_cfg_st =>
                  adc_cfg_word(4) <= '1';
                  adc_driver_sm <= csn_low_st;
               
               when csn_low_st =>
                  spi_csn_i  <= '0';
                  spi_mosi_i  <= '0';
                  waiting_for_miso_low_st <= '1';
                  if spi_miso_i = '0' then
                     adc_driver_sm <= wait_clk_fe_st;
                  end if;
               
               when wait_clk_fe_st =>
                  waiting_for_miso_low_st <= '0';
                  if spi_sclk_fall = '1' then 
                     adc_driver_sm <= send_tx_data_st;
                  end if;
               
               when send_tx_data_st =>   
                  if spi_sclk_rise = '1' then
                     spi_sclk_window <= '1';
                     spi_mosi_i <= adc_cfg_word(bit_cnt);
                     adc_driver_sm <= check_tx_end_st;
                  end if;
               
               when check_tx_end_st =>
                  if bit_cnt = 0 then
                     adc_driver_sm <= tx_end_st;
                  else
                     adc_driver_sm <= send_tx_data_st; 
                     bit_cnt <= bit_cnt - 1;
                  end if;                  
               
               when tx_end_st =>
                  if spi_sclk_fall = '1' then
                     spi_sclk_window <= '0';
                     adc_driver_sm <= csn_high_st;
                  end if;
               
               when csn_high_st =>                  
                  if spi_sclk_fall = '1' then
                     spi_csn_i <= '1';
                     adc_driver_sm <= pause_st;                    
                  end if;                   
               
               when pause_st =>       
                  spi_mosi_i <= '0';
                  pause_cnt <=  pause_cnt + 1;                  
                  if pause_cnt = C_CSN_PAUSE_FACTOR then 
                     adc_driver_sm <= check_read_flag_st;                       
                  end if;
                  -- pragma translate_off
                  if pause_cnt = 10 then
                     adc_driver_sm <= check_read_flag_st; 
                  end if;
                  -- pragma translate_on
               
               when check_read_flag_st =>
                  bit_cnt <= 15;
                  pause_cnt <= (others => '0');
                  if read_in_progress = '1' then 
                     adc_driver_sm <= idle; 
                  else
                     read_in_progress <= '1';
                     adc_driver_sm <= csn_low_st;  -- un second envoi de la config permet de lire les données du 1er envoi. le 1er envoi sert à configurer l,ADC                 
                  end if;
               
               when others =>
               
            end case;
         end if;
      end if;
   end process;
   
end rtl;
