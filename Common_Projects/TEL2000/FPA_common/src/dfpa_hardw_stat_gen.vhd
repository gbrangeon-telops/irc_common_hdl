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
   
   type ddc_id_sm_type is (idle, wait_start_st, hw_status_st);
   
   signal sreset          : std_logic;
   signal reader_run      : std_logic;
   signal reader_done     : std_logic;
   signal ddc_id_sm       : ddc_id_sm_type;
   signal clean_miso      : std_logic;
   signal ddc_brd_info_i : ddc_brd_info_type;
   
   
begin
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1 : sync_reset
   port map(ARESET => ARESET, CLK => CLK_100M, SRESET => sreset); 
   
   
   --------------------------------------------------
   -- freqID est filtré avant d'être utilisé
   -------------------------------------------------- 
   U10 : signal_filter
   generic map(
      SCAN_WINDOW_LEN => 64
      )
   port map(
      ARESET => ARESET,
      CLK => CLK_100M,
      SIG_IN => DET_FREQ_ID,
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
      FLEX_BRD_INFO => open,
      DDC_BRD_INFO  => ddc_brd_info_i,
      ERR           => open 
      );   
   
   --------------------------------------------------
   -- Fsm de contrôle
   -------------------------------------------------- 
   U4 : process(CLK_100M)
   begin          
      if rising_edge(CLK_100M) then 
         if sreset = '1' then 
            ddc_id_sm <= idle; 
            reader_run <= '0';
            FPA_HARDW_STAT.DVAL <= '0';
         else 
            
            case ddc_id_sm is 
               
               when idle =>
                  if reader_done = '1' then 
                     ddc_id_sm <= wait_start_st;
                     reader_run <= '1';     
                  end if;
               
               when wait_start_st =>          
                  if reader_done = '0' then  
                     reader_run <= '0';
                     ddc_id_sm <= hw_status_st;
                  end if;
               
               when hw_status_st =>
                  if reader_done = '1' then  
                     FPA_HARDW_STAT.IDDCA_INFO <= ddc_brd_info_to_iddca_info(ddc_brd_info_i);
                     FPA_HARDW_STAT.DVAL <= '1';
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
end RTL;
