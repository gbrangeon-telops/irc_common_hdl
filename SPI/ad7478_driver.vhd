-------------------------------------------------------------------------------
--
-- Title       : ad7478_driver.vhd
-- Design      : Common_HDL
-- Author      : Edem Nofodjie.
-- Company     : Telops Inc.
--
--  $Revision: 
--  $Author: 
--  $LastChangedDate:
-------------------------------------------------------------------------------
--
-- Description : driver for ADC ad7478 from AD
--             : 
--             : 
--             :    
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity ad7478_driver is
   generic(
      ADC_SCLK_FACTOR   : integer := 32;
      FIRST_CLK_EDGE_IS_FE : boolean := true
      );
   port (
      CLK 			      : in std_logic;
      ARESET 				: in std_logic;
      START_ADC 			: in std_logic;
      ADC_DATA_RDY		: out std_logic;
      ADC_BUSY				: out std_logic;
      ADC_DIN				: in std_logic;
      ADC_SCLK		      : out std_logic;
      ADC_CS_N				: out std_logic;                      
      ADC_ERR           : out std_logic;
      ADC_DATA 			: out std_logic_vector(7 downto 0)
      );
end ad7478_driver;

architecture RTL of ad7478_driver is
   
   constant NB_BIT_CLK_CNT  : integer := log2(ADC_SCLK_FACTOR)-1;   
   constant NBIT_TO_ACQ     : integer := 16; -- nombre de bits total à acquerir lors d'une acquisition
   constant NBIT_TO_ACQ_P_2 : integer := NBIT_TO_ACQ + 2;
   
   type acq_fsm_type is (idle, start_st, acq_st, end_st);
   
   signal acq_fsm                         : acq_fsm_type;   
   signal start_adc_i                  	: std_logic;
   signal data_rdy_i    						: std_logic;
   signal busy_i							   	: std_logic;
   signal master_clk_i							: std_logic;
   signal sclk_i   								: std_logic;
   signal div_clk_cnt						   : unsigned(NB_BIT_CLK_CNT downto 0);
   signal adc_clk_counter 				   	: unsigned(7 downto 0);
   signal cs_n_i 					         	: std_logic;
   signal acq_window   			            : std_logic;
   signal adc_err_i		            		: std_logic;
   signal data_register							: std_logic_vector(NBIT_TO_ACQ-1 downto 0); 
   signal adc_data_i                      : std_logic_vector(7 downto 0); 
   signal sreset                          : std_logic;
   signal adc_din_reg                     : std_logic;
   signal master_clk_i_last               : std_logic;
   signal master_clk_acq_edge             : std_logic; 
   signal master_clk_cnt                  : unsigned(log2(NBIT_TO_ACQ)+1 downto 0); 
   signal sclk_iob                        : std_logic; 
   signal cs_n_iob                        : std_logic; 
   
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   attribute IOB : string;
   attribute IOB of sclk_iob                         : signal is "FORCE"; 
   attribute IOB of cs_n_iob                         : signal is "FORCE";
   attribute IOB of adc_din_reg                    : signal is "FORCE";
   
   
begin
   
   --------------------------------------------------
   -- qque sorties 
   -------------------------------------------------- 
   ADC_BUSY <= busy_i;
   ADC_SCLK <= sclk_iob;
   ADC_CS_N <= cs_n_iob;
   process(CLK)
   begin
      if rising_edge(CLK) then
         sclk_iob <= sclk_i;
         cs_n_iob <= cs_n_i;
      end if;
   end process;  
   
   --------------------------------------------------
   -- sync reset 
   --------------------------------------------------
   U0 : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK); 
   
   
   -------------------------------------------------
   -- compteur pour division d'horloge 
   --------------------------------------------------
   -- Clk_divider (par puissance de 2)
   U1 : process(CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            div_clk_cnt <= (others => '0');
         else
            div_clk_cnt <= div_clk_cnt + 1;	
         end if;         
      end if;
   end process;      
   
   
   --------------------------------------------------
   -- master_clk generation 
   --------------------------------------------------
   --  horloge principale divisée par un facteur puissance de 2
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            master_clk_i <= '0'; 
            master_clk_i_last <= '0';
            master_clk_acq_edge <= '0';
         else 
            -- division de l'horloge par une puissance de 2 
            master_clk_i <= div_clk_cnt(NB_BIT_CLK_CNT);
            master_clk_i_last <= master_clk_i;   
            
            -- adc clk edge detection
            if FIRST_CLK_EDGE_IS_FE then                    -- si premiere transition d'horloge lorsque cs_n abaissée doit etre Falling edge
               master_clk_acq_edge <= not master_clk_i_last and master_clk_i;   -- alors les données sont à acquerir sur le rising_edge
            else
               master_clk_acq_edge <= master_clk_i_last and not master_clk_i;   -- alors les données sont à acquerir sur le falling_edge
            end if;  
            
         end if;
      end if;      
   end process;  
   
   
   --------------------------------------------------
   -- generation de signaux generaux spi part1
   --------------------------------------------------
   U3 : process(CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            acq_window <= '0';
            acq_fsm <= idle;
            master_clk_cnt <= (others => '0');
            start_adc_i <= '0';
            busy_i <= '1';
            data_rdy_i <= '0'; 
            cs_n_i <= '1';
            acq_window <= '0';
         else               
            start_adc_i <= START_ADC;   
            
            case acq_fsm is
               when idle => 
                  master_clk_cnt <= (others => '0');
                  data_rdy_i <= '0'; 
                  busy_i <= '0';
                  cs_n_i <= '1';
                  acq_window <= '0'; 
                  if start_adc_i = '1' then 
                     acq_fsm <= start_st;
                  end if;  
               
               when start_st =>  -- pour savoir quand abaisser cs_n (dans ce cas 
                  busy_i <= '1';
                  if master_clk_acq_edge = '1' then 
                     cs_n_i <= '0';                -- cs_n est abaissée master_clk_acq_edge, de sorte que la premiere transition percue après son abaissement  soit le contraire de master_clk_acq_edge
                     acq_window <= '1';                    
                     acq_fsm <= acq_st;
                  end if;          
               
               when acq_st =>  -- durée de CS_N  
                  if master_clk_acq_edge = '1' then 
                     master_clk_cnt <= master_clk_cnt + 1;
                  end if;           
                  if master_clk_cnt = NBIT_TO_ACQ then 
                     acq_fsm <= end_st;
                  end if;      
               
               when end_st =>   
                  cs_n_i <= '1';
                  acq_window <= '0';                    
                  if master_clk_acq_edge = '1' then  
                     master_clk_cnt <= master_clk_cnt + 1;
                  end if;                  
                  if  master_clk_cnt = NBIT_TO_ACQ_P_2 then   --    pour donner largement du temps avant la prochaine acquisition
                     acq_fsm <= idle;
                     data_rdy_i <= '1'; 
                  end if;
               
               when others =>                  
               
            end case;              
            
         end if;
      end if;
   end process;  
   
   
   --------------------------------------------------
   -- generation de signaux generaux spi part2
   --------------------------------------------------   
   U4 : process(CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            sclk_i <= '0'; 
         else 
            
            if cs_n_i = '1' then             -- etat de SCLK avant abaissement de CS_N
               if FIRST_CLK_EDGE_IS_FE then 
                  sclk_i <= '1';
               else
                  sclk_i <= '0';
               end if;
            else                              -- etat de SCLK après abaissement de CS_N
               sclk_i <= master_clk_i; 
            end if;             
            
         end if;
      end if;      
   end process;  
   
   
   --------------------------------------------------
   -- capture des données
   --------------------------------------------------  
   U5 : process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            data_register <= (others => '0');			
         else
            adc_din_reg <=  ADC_DIN; -- pour visualisation dans chipscope.
            if  acq_window = '1' and master_clk_acq_edge = '1' then 
               data_register(NBIT_TO_ACQ-1 downto 1) <= data_register(NBIT_TO_ACQ-2 downto 0);  
               data_register(0) <= adc_din_reg;
            end if;
         end if;  
      end if;
   end process; 
   
   
   --------------------------------------------------
   -- cas particulier de ADC7478
   --------------------------------------------------  
   U6 : process (CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            ADC_ERR <= '0';
            ADC_DATA_RDY <= '0';
            -- translate_off
            ADC_DATA <= x"AA"; 
            -- translate_on
         else
            if data_rdy_i = '1' then 
               ADC_DATA <=  data_register(12 downto 5);  
               ADC_DATA_RDY <= '1';
               if data_register(15 downto 13) /= "000" or data_register(4 downto 0) /= "00000" then
                  ADC_ERR <= '1';
               end if;
            else
               ADC_DATA_RDY <= '0';
            end if;         
         end if;
      end if;  
   end process; 
   
   
end RTL;
