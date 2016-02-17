--******************************************************************************
-- Destination: 
--
--	File: adc_brd_define.vhd
-- Hierarchy: Package file
-- Use: 
--	Project: IRCDEV
--	By: Edem Nofodjie
-- Date: 22 october 2009	  
--
--******************************************************************************
--Description
--******************************************************************************
-- 1- Defines the global variables 
-- 2- Defines the project function
--******************************************************************************


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
use work.FPA_define.all; 


package adc_brd_define is    
   
   ----------------------------------------------
   -- ADC 
   ---------------------------------------------- 
   constant DEFINE_ADC_FULL_SCALE_mV                  : integer  := 2048;     -- normalement +- 2.048V mais seule la partie positive est utilisée, Voir le parametre PGA dans le pilote ads1118_driver.vhd
   constant DEFINE_ADC_DATA_NATIVE_RESOLUTION         : integer  := 15;       -- on utilise seulement 15 bits sur 16 puisque la partie negative de la plage dynamique n'est pas utilisée
   constant DEFINE_ADC_SPI_CLK_RATE_KHZ               : integer  := 100;      -- spi clk = 100KHz
   constant DEFINE_ADC_TRIG_CLK_RATE_HZ               : integer  := 200;      -- 200 sampes/sec
   constant DEFINE_ADC_SAMPLE_SUM_NUM                 : integer  := 8;        -- doit être une puissance de 2. Doit tenir compte de la repartition de meas_cnt dans monitoring_adc_ctrl.vhd. 
   constant DEFINE_ADC_DATA_FINAL_RESOLUTION          : integer  := 16;       -- j'aimerais sortir toutes mes données sur 16 bits bien que l'adc soit en 15 bits. C'est possible puisque je prends 8 echantillons de 15 bits
   constant DEFINE_ADC_PTRN_DATA                      : std_logic_vector(15 downto 0) := x"130F";
   
   -- gain des canaux de mesures
   constant DEFINE_FPA_DIGIOV_CH_GAIN                 : real     := 590.0/(1000.0 + 590.0); -- gain mis sur le canal analogique de FPA_DIGIOV
   constant DEFINE_FLEX_PSP_CH_GAIN                   : real     := 332.0/(1000.0 + 332.0); -- gain mis sur le canal analogique de FLEX_PSP
   constant DEFINE_TP_MEAS_CH_GAIN                    : real     := 332.0/(1000.0 + 332.0); -- gain mis sur le canal analogique de TP_MEAS
   constant DEFINE_PCB_TEMP_CH_GAIN                   : real     := 1.0;                    -- gain unitaire pour PCB temp
   constant DEFINE_1024                               : integer  := 1024;                   -- toujours puissance de 2. Permet de calculer facilement les voltages lues par l'ADC de monitoring
   
   -- ne rien changer sur les constantes suivantes   
   constant DEFINE_ADC_SPI_CLK_FACTOR                 : integer  := DEFINE_FPA_100M_CLK_RATE_KHZ/DEFINE_ADC_SPI_CLK_RATE_KHZ;         -- le module monitoring_adc_ctrl est branché sur une horloge de 100MHz
   constant DEFINE_ADC_TRIG_CLK_FACTOR                : integer  := (DEFINE_FPA_100M_CLK_RATE_KHZ*1000)/DEFINE_ADC_TRIG_CLK_RATE_HZ;  -- ce qui donne des trigs de 200Hz pour les mesures
   constant DEFINE_ADC_SAMPLE_DIV_NUM                 : integer  := DEFINE_ADC_SAMPLE_SUM_NUM/2**(DEFINE_ADC_DATA_FINAL_RESOLUTION - DEFINE_ADC_DATA_NATIVE_RESOLUTION);  -- soit 8 echantillons 15 bits à diviser par DEFINE_ADC_SAMPLE_DIV_NUM = 4 pour avoir un echantillon de 16 btis
   
   -- ne rien changer:
   -- ces constantes permettent de convertir le sample_word de 16 bits en la grandeur mesurée mais multipliée par 1024.
   -- le 1024 permet une division facile par 1024.
   -- noter que le fait que DEFINE_ADC_FULL_SCALE_mV soit en milliVolt impose que le resultat est également en millivolt.
   -- en somme, le resultat de la conversion est en millivolt*1024
   constant DEFINE_FPA_DIGIOV_CONV_FACTOR_X_1024      : integer  := integer((real(DEFINE_1024)*real(DEFINE_ADC_FULL_SCALE_mV))/(DEFINE_FPA_DIGIOV_CH_GAIN*real(2**DEFINE_ADC_DATA_FINAL_RESOLUTION)));
   constant DEFINE_FLEX_PSP_CONV_FACTOR_X_1024        : integer  := integer((real(DEFINE_1024)*real(DEFINE_ADC_FULL_SCALE_mV))/(DEFINE_FLEX_PSP_CH_GAIN*real(2**DEFINE_ADC_DATA_FINAL_RESOLUTION)));
   constant DEFINE_TP_MEAS_CONV_FACTOR_X_1024         : integer  := integer((real(DEFINE_1024)*real(DEFINE_ADC_FULL_SCALE_mV))/(DEFINE_TP_MEAS_CH_GAIN*real(2**DEFINE_ADC_DATA_FINAL_RESOLUTION)));
   constant DEFINE_PCB_TEMP_CONV_FACTOR_X_1024        : integer  := integer(real(DEFINE_1024)*real(DEFINE_PCB_TEMP_CH_GAIN));       -- calcul special pour le PCB_temp car il sort du driver ads1118_driver.vhd en celsius 
   constant DEFINE_FPA_TEMP_CONV_FACTOR_X_1024        : integer  := DEFINE_1024; -- ENO 21 aout 2015: on prend la donnée brute de l'ADC et la conversion se fait dans le microBlaze                                             integer((real(DEFINE_1024)*real(DEFINE_ADC_FULL_SCALE_mV))/(DEFINE_FPA_TEMP_CH_GAIN*real(2**DEFINE_ADC_DATA_FINAL_RESOLUTION))); -- DEFINE_FPA_TEMP_CH_GAIN provient de FPA_define 

end adc_brd_define;

package body adc_brd_define is
   
   
   
end package body adc_brd_define; 
