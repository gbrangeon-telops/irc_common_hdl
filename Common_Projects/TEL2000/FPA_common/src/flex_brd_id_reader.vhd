------------------------------------------------------------------
--!   @file : flex_brd_id_reader
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

entity flex_brd_id_reader is
   port(           
      ARESET        : in std_logic;
      CLK_100M      : in std_logic;
      
      EN            : in std_logic;
      FREQ_ID       : in std_logic;
      RQST          : out std_logic;
      DONE          : out std_logic;    
      
      ERR           : out std_logic;
      
      FLEX_BRD_INFO : out flex_brd_info_type
      );
end flex_brd_id_reader;


architecture rtl of flex_brd_id_reader is
   
   
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
      port (
         CLK : in STD_LOGIC;
         SIG_IN : in STD_LOGIC;
         SIG_OUT : out STD_LOGIC
         );
   end component;
   
   type flex_id_sm_type is (idle, wait_reader_st, end_rqst_st);
   
   signal sreset         : std_logic;
   signal reader_run     : std_logic;
   signal reader_done    : std_logic;
   signal flex_id_sm     : flex_id_sm_type;
   signal clean_miso     : std_logic;
   signal rqst_i         : std_logic;
   
   
begin
   
   U0 : process(CLK_100M)
   begin
      if rising_edge(CLK_100M) then
         DONE <= reader_done; 
         RQST <= rqst_i;
      end if;
   end process;
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1 : sync_reset
   port map(ARESET => ARESET, CLK => CLK_100M, SRESET => sreset); 
   
   
   --------------------------------------------------
   -- freqID est filtré avant d'être utilisé
   -------------------------------------------------- 
   U10 : signal_filter
   port map(
      CLK => CLK_100M,
      SIG_IN => FREQ_ID,
      SIG_OUT => clean_miso
      );
   
   
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
      ADC_BRD_INFO  => open,
      FLEX_BRD_INFO => FLEX_BRD_INFO,
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
            flex_id_sm <= wait_reader_st; 
            rqst_i <= '0';
            reader_run <= '0';
         else 
            
            case flex_id_sm is 
               
               when wait_reader_st =>   -- on attend que le brd_id_reader soit prêt
                  if reader_done = '1' then 
                     flex_id_sm <= idle;
                  end if;
               
               when idle =>             -- on demande à lire i'ID et on lance l'id)_reader dès que la demande est accordée
                  rqst_i <= '1';
                  if EN = '1' then 
                     flex_id_sm <= end_rqst_st;
                     reader_run <= '1';
                  end if;
               
               when end_rqst_st =>         -- on s'assure que l'ID reader est lancé pour effacer la demande.
                  rqst_i <= '0';
                  if reader_done = '0' then  
                     reader_run <= '0';
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
end rtl;
