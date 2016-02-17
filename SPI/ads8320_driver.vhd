-------------------------------------------------------------------------------
--
-- Title       : ads8320_driver.vhd
-- Design      : Common_HDL
-- Author      : Patrick Daraiche.
-- Company     : Telops Inc.
--
--  $Revision: 
--  $Author: 
--  $LastChangedDate:
-------------------------------------------------------------------------------
--
-- Description : driver for ADC ADS8320EB from Texas Instrument
--             : Need to toggle start_adc 
--             : Output 16 bit data with adc_data_rdy
--             : Output SCLK 
--             : Generic NB_BIT_CLK_CNT is used to size the counter to divide the
--             : input clk for the SCLK
   
--  ENO :29 septembre 2010: NE PAS DEPASSER 48.8KHz POUR LA CLOCK SPI  MALGRÉ LES INDICATIONS DU DATASHEET.
--                          Cela fait suite au problème rencontré dans le ROIC. 
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity ads8320_driver is
   generic(
      NB_BIT_CLK_CNT : integer := 4);
   port (CLK 					: in std_logic;
      ARESET 				: in std_logic;
      START_ADC 			: in std_logic;
      ADC_DATA_RDY		: out std_logic;
      ADC_BUSY				: out std_logic;
      ADC_DIN				: in std_logic;
      ADC_SCLK		      : out std_logic;
      ADC_CS_N				: out std_logic;                      
      ADC_ERR           : out std_logic;
      ADC_DATA 			: out std_logic_vector(15 downto 0));
end ads8320_driver;

architecture ads8320_driver_arch of ads8320_driver is
   
   signal start_adc_q1,start_adc_q2 		: std_logic;
   signal start_adc_pulse						: std_logic;
   signal adc_busy_s								: std_logic;
   signal end_conversion						: std_logic;
   signal adc_clk_q1								: std_logic;
   signal adc_cs_s								: std_logic;
   signal adc_clk_counter						: unsigned(NB_BIT_CLK_CNT-1 downto 0);
   signal adc_clk_counter2 					: unsigned(7 downto 0);
   signal adc_clk_falling 						: std_logic;
   signal adc_clk_rising 						: std_logic;
   signal acquisition_window_s   			: std_logic;
   signal acquisition_window		   		: std_logic;
   signal acquisition_trig                : std_logic;
   signal data_register							: std_logic_vector(15 downto 0);
   signal sreset                          : std_logic;
   signal adc_din_reg                     : std_logic;
   
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK); 
   
   
   -- start adc synchronisation
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            start_adc_q1 <= '0';
            start_adc_q2 <= '0';
            start_adc_pulse <= '0';
         else
            start_adc_q1 <= START_ADC;
            start_adc_q2 <= start_adc_q1;
         end if;           
         -- start adc rising edge detection
         start_adc_pulse <= start_adc_q1 and not start_adc_q2;         
      end if;
   end process;    
   
   
   -- adc busy generation
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            adc_busy_s <= '0';
         else
            if (start_adc_pulse = '1') then
               adc_busy_s <= '1';
            elsif (end_conversion = '1') then
               adc_busy_s <= '0';
            end if;
         end if;
      end if;
   end process;  
   
   
   -- adc clk period counter
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            adc_clk_counter <= (others => '0');
         else
            if (adc_busy_s = '1') then
               if (end_conversion = '1') then
                  adc_clk_counter <= (others => '0');
               else
                  adc_clk_counter <= adc_clk_counter + 1;	
               end if;
            end if;
         end if;
      end if;
   end process;      
   
   
   -- adc clk generation
   process (CLK,sreset)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            adc_clk_q1 <= '0';
         else
            adc_clk_q1 <= adc_clk_counter(NB_BIT_CLK_CNT-1);
         end if;
      end if;
   end process;
   
   ADC_SCLK <=  adc_clk_counter(NB_BIT_CLK_CNT-1);	
   
   
   -- adc clk edge detection
   adc_clk_falling <= not adc_clk_counter(NB_BIT_CLK_CNT-1) and adc_clk_q1;
   adc_clk_rising  <= adc_clk_counter(NB_BIT_CLK_CNT-1) and not adc_clk_q1; 
   
   
   -- adc clk cycles counter		 
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            adc_clk_counter2 <= (others => '0');
         else
            if (adc_busy_s = '1') then
               if (end_conversion = '1') then 
                  adc_clk_counter2 <= (others => '0');
               elsif (adc_clk_rising = '1') then
                  adc_clk_counter2 <= adc_clk_counter2 + 1;
               end if;
            end if;
         end if;
      end if;
   end process;  
   
   
   -- acquisition window generation 
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            acquisition_window_s <= '0';
            end_conversion <= '0';
         else             
            -- acquisition trig generation (data valid)
            if (adc_clk_counter2 >= x"06") and (adc_clk_counter2 <= x"15") then  --x"06" afin de ne pas râter le 7e rising_edge
               acquisition_window_s <= '1';
            else
               acquisition_window_s <= '0';
            end if;             
            --	end conversion generation
            if (adc_clk_falling = '1' and adc_clk_counter2 = x"16") then 
               end_conversion <= '1';
            else
               end_conversion <= '0';
            end if;
            
         end if;
      end if;
   end process;  
   
   
   
   -- acquisition window pipelining (pour eviter le 6e rising_edge
   process (CLK)
   begin
      if rising_edge(clk) then
         if (sreset = '1') then
            acquisition_window <= '0';
         else
            acquisition_window <= acquisition_window_s;
         end if;
      end if;
   end process;  
   
   
   -- adc input data register
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            data_register <= (others => '0');			
         else
            adc_din_reg <=  ADC_DIN; -- pour visualisation dans chipscope.
            acquisition_trig <= acquisition_window and adc_clk_rising;  -- definition explicite de acquisition_trig afin de savoir exactement quand la donnée a été latchée
            if  acquisition_trig = '1' then 
               data_register(0) <= adc_din_reg;
               data_register(15 downto 1) <= data_register(14 downto 0);
            end if;
         end if;  
      end if;
   end process; 
   
   
   -- adc cs generation
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            adc_cs_s <= '0';
         else
            if (start_adc_pulse = '1') then
               adc_cs_s <= '1';	 
            elsif (adc_clk_counter2 = x"16" and adc_clk_falling = '1') then
               adc_cs_s <= '0';
            end if;
         end if;
      end if;
   end process;
   
   
   -- adc data rdy generation
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            ADC_DATA_RDY <= '0';
            -- translate_off
            ADC_DATA <= x"BBBB";
            -- translate_on
         else
            if end_conversion = '1' then      -- sortie des données uniquement lorsque la conversion est terminée          
               ADC_DATA_RDY <= '1';         
               ADC_DATA <= data_register;
            else
               ADC_DATA_RDY <= '0';  
            end if;
         end if;
      end if;
   end process;
   
    -- detection d'anomalie
   process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            ADC_ERR <= '0';
           else
            if adc_clk_counter2 = x"05" and  adc_clk_rising = '1' then  -- arrivée du 6e rising_edge           
               ADC_ERR <= adc_din_reg;   -- selon la DOC, il ya erreur si  ADC_DIN ne vaut pas '0' au 6e rising edge     
            else
               ADC_ERR <= '0';  
            end if;
         end if;
      end if;
   end process; 
   
   
   ADC_CS_N <= not adc_cs_s;
   
   ADC_BUSY <= adc_busy_s;								
   
end ads8320_driver_arch;
