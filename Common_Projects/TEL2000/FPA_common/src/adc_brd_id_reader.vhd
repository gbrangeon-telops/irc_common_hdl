------------------------------------------------------------------
--!   @file : adc_brd_id_reader
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.fpa_common_pkg.all;

entity adc_brd_id_reader is
   port(           
      ARESET       : in std_logic;
      CLK_100M     : in std_logic;
      
      EN           : in std_logic;
      MISO         : in std_logic;
      RQST         : out std_logic;
      DONE         : out std_logic;    
      
      CSN          : out std_logic;
      SCLK         : out std_logic;
      MOSI         : out std_logic;
      ERR          : out std_logic;
      
      ADC_BRD_INFO : out adc_brd_info_type
      );
end adc_brd_id_reader;


architecture rtl of adc_brd_id_reader is
   
   
   component brd_id_reader
      port(
         ARESET         : in std_logic;
         CLK_100M       : in std_logic;
         RUN            : in std_logic;
         DONE           : out std_logic;
         FREQ_ID        : in std_logic;
         ADC_BRD_INFO   : out adc_brd_info_type;
         FLEX_BRD_INFO  : out flex_brd_info_type;
         DDC_BRD_INFO   : out ddc_brd_info_type;
         ERR            : out std_logic
         );
   end component;
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   component signal_filter
      generic(
         SCAN_WINDOW_LEN : natural range 3 to 127 := 64
         );       
      port (
         ARESET   : in STD_LOGIC;
         CLK : in STD_LOGIC;
         SIG_IN : in STD_LOGIC;
         SIG_OUT : out STD_LOGIC
         );
   end component;
   
   type adc_id_sm_type is (idle, wait_reader_st, end_rqst_st);
   
   signal sreset         : std_logic;
   signal reader_run     : std_logic;
   signal reader_done    : std_logic;
   signal adc_id_sm      : adc_id_sm_type;
   signal clean_miso     : std_logic;
   signal rqst_i         : std_logic;
   
   ---- attribute dont_touch : string;
   ---- attribute dont_touch of ADC_BRD_INFO     : signal is "TRUE";
   ---- attribute dont_touch of rqst_i            : signal is "TRUE";
   
   
begin
   
   --------------------------------------------------
   -- outputs
   --------------------------------------------------  
   CSN <='1';
   SCLK <= '0';
   MOSI <= '0';
   
   U0 : process(CLK_100M)
   begin
      if rising_edge(CLK_100M) then     
         RQST <= rqst_i;
         DONE <=  reader_done;
      end if;
   end process;
   
   --------------------------------------------------
   -- MISO est filtré avant d'être utilisé
   -------------------------------------------------- 
   U10 : signal_filter
   generic map(
      SCAN_WINDOW_LEN => 64
      )
   port map(
      ARESET => ARESET,
      CLK => CLK_100M,
      SIG_IN => MISO,
      SIG_OUT => clean_miso
      );
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1 : sync_reset
   port map(ARESET => ARESET, CLK => CLK_100M, SRESET => sreset); 
   
   --------------------------------------------------
   -- brd_id_reader
   -------------------------------------------------- 
   U2 : brd_id_reader
   port map(
      ARESET        => ARESET, 
      CLK_100M      => CLK_100M,      
      RUN           => reader_run,
      DONE          => reader_done, 
      FREQ_ID       => clean_miso,         
      ADC_BRD_INFO  => ADC_BRD_INFO,
      FLEX_BRD_INFO => open,
      DDC_BRD_INFO  => open,
      ERR           => ERR 
      );   
   
   --------------------------------------------------
   -- Fsm de contrôle
   -------------------------------------------------- 
   U4 : process(CLK_100M)
   begin          
      if rising_edge(CLK_100M) then 
         if sreset = '1' then 
            adc_id_sm <= wait_reader_st; 
            -- RQST <= '0';
            rqst_i <='0';
            reader_run <= '0';
         else 
            
            case adc_id_sm is 
               
               when wait_reader_st =>   -- on attend que le brd_id_reader soit prêt
                  if reader_done = '1' then 
                     adc_id_sm <= idle;
                  end if;
               
               when idle =>             -- on demande à lire i'ID et on lance l'id)_reader dès que la demande est accordée
                  -- RQST <= '1';
                  rqst_i <='1';
                  if EN = '1' then 
                     adc_id_sm <= end_rqst_st;
                     reader_run <= '1';
                  end if;
               
               when end_rqst_st =>         -- on s'assure que l'ID reader est lancé pour effacer la demande et on ne sort plus de cet etat
                  -- RQST <= '0';
                  rqst_i <='0';
                  if reader_done = '0' then  
                     reader_run <= '0';
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
end rtl;
