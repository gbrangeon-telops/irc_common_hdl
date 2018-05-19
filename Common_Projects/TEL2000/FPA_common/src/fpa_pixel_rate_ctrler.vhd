------------------------------------------------------------------
--!   @file : fpa_pixel_rate_ctrler
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
use IEEE.numeric_std.all;
use work.fpa_common_pkg.all;
use work.tel2000.all;
use work.FPA_define.all;

entity fpa_pixel_rate_ctrler is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;   -- Attention, il faut que 4*CLK_RATE*15/16 > FPA_LINE_MEAN_THOUGHPUT  => CLK_RATE > FPA_LINE_MEAN_THOUGHPUT*4/15. Ainsi Pour ISC0804 àavec un FPA_LINE_MEAN_THOUGHPUT = 338, il faut CLK_RATE > 90 MHz.
      DYN_PAUSE_CFG  : in dyn_pause_cfg_type;
      RX_MOSI        : in t_axi4_stream_mosi64;
      RX_MISO        : out t_axi4_stream_miso;      
      TX_MOSI        : out t_axi4_stream_mosi64;
      TX_MISO        : in t_axi4_stream_miso
      );
end fpa_pixel_rate_ctrler;

architecture rtl of fpa_pixel_rate_ctrler is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component;
   
   type fsm_type is (idle, pause_st);
   type cfg_fsm_type is (pause_cfg_st, wait_frame_end_st);
   
   signal data_fsm               : fsm_type;
   signal time_fsm               : fsm_type;
   signal cfg_fsm                : cfg_fsm_type;
   signal data_cnt               : unsigned(15 downto 0);
   signal time_cnt               : unsigned(15 downto 0);
   signal sreset                 : std_logic;
   signal time_cycle_end_i       : std_logic;
   signal time_cnt_enabled       : std_logic;
   signal flow_enabled_i         : std_logic := '0'; 
   signal dyn_pause_cfg_i        : dyn_pause_cfg_type;
   signal dyn_pause_cfg_valid_i  : std_logic;
   
   
begin
   
   TX_MOSI.TDATA  <= RX_MOSI.TDATA; 
   TX_MOSI.TVALID <= RX_MOSI.TVALID and flow_enabled_i;
   TX_MOSI.TSTRB  <= RX_MOSI.TSTRB; 
   TX_MOSI.TKEEP  <= RX_MOSI.TKEEP; 
   TX_MOSI.TLAST  <= RX_MOSI.TLAST; 
   TX_MOSI.TUSER  <= RX_MOSI.TUSER; 
   TX_MOSI.TID    <= RX_MOSI.TID;   
   TX_MOSI.TDEST  <= RX_MOSI.TDEST;   
   
   RX_MISO.TREADY <= TX_MISO.TREADY and flow_enabled_i; 
   
   ----------------------------------------------------
   -- Synchronisation reset
   ----------------------------------------------------
   U0: sync_reset
   Port map(
      ARESET => ARESET, SRESET => sreset, CLK => CLK);   
   
   ----------------------------------------------------
   --  management de la config
   ----------------------------------------------------  
   U1: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then     
            cfg_fsm <= pause_cfg_st;
            dyn_pause_cfg_valid_i <= '0';
         else                
            
            case cfg_fsm is
               
               when pause_cfg_st =>
                  dyn_pause_cfg_valid_i <= '0';
                  if RX_MOSI.TVALID = '1' and TX_MISO.TREADY = '1' then     -- premiere donnée apres un TLAST ou apres un reset = sof
                     cfg_fsm <= wait_frame_end_st;
                     dyn_pause_cfg_i <= DYN_PAUSE_CFG;
                     dyn_pause_cfg_valid_i <= '1';
                  end if;                  
               
               when wait_frame_end_st =>
                  if RX_MOSI.TVALID = '1' and TX_MISO.TREADY = '1' and RX_MOSI.TLAST = '1' then 
                     cfg_fsm <= pause_cfg_st;                     
                  end if;                  
               
               when others =>
               
            end case;
            
            
         end if;
      end if;
   end process;   
   
   ----------------------------------------------------
   --  contrôle du flow de données
   ----------------------------------------------------  
   U2: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then            
            data_fsm <= idle;
            data_cnt <= (others => '0'); 
            flow_enabled_i <= '1';
            
         else                       
            
            case  data_fsm is         
               
               when idle =>             
                  if RX_MOSI.TVALID = '1' and TX_MISO.TREADY = '1' and flow_enabled_i = '1' then
                     data_cnt <= data_cnt + 1;
                  end if;    
                  if data_cnt >= dyn_pause_cfg_i.data_cnt_max  and dyn_pause_cfg_valid_i = '1' then
                     flow_enabled_i <= not dyn_pause_cfg_i.enabled; -- on ralentit le flow ssi les pauses dynamiques sont activees 
                     data_fsm <= pause_st; 
                  end if; 
               
               when pause_st =>                 
                  if time_cycle_end_i = '1' then 
                     data_fsm <= idle;
                     flow_enabled_i <= '1';  
                  end if;
               
               when others =>
               
            end case; 
            
            if time_cycle_end_i = '1' then                   -- a preseance sinon bug
               data_cnt <= to_unsigned(1, data_cnt'length);
            end if;
            
            
         end if;
      end if;
   end process;
   
   ----------------------------------------------------
   --  contrôle du temps de cycle
   ----------------------------------------------------  
   U3: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then            
            time_fsm <= idle;
            time_cnt <= (others => '0'); 
            time_cnt_enabled <= '0';
            time_cycle_end_i <= '0';
            
         else                       
            
            if time_cnt_enabled = '1' then          
               time_cnt <= time_cnt + 1;
            else
               time_cnt <= to_unsigned(2, time_cnt'length); -- 2 pour tenir compte des delais afin que time_cnt reflete le temps qui s'ecoule 
            end if;
            
            case  time_fsm is         
               
               when idle =>
                  time_cnt_enabled <= '0';
                  time_cycle_end_i <= '0';
                  if data_cnt = 1 then 
                     time_cnt_enabled <= '1';
                     time_fsm <= pause_st;
                  end if;                  
               
               when pause_st =>                 
                  if time_cnt >= dyn_pause_cfg_i.time_cnt_max then 
                     time_fsm <= idle;
                     time_cnt_enabled <= '0';
                     time_cycle_end_i <= '1';
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
end rtl;
