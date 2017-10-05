------------------------------------------------------------------
--!   @file : afpa_elec_offset_ctrler
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
use work.FPA_Define.all;
use work.fpa_common_pkg.all;

entity afpa_elec_offset_ctrler is
   port(
      ARESET            : in std_logic;
      CLK               : in std_logic;
                        
      FPA_INTF_CFG      : in fpa_intf_cfg_type;
                        
      RX_MOSI           : in t_ll_ext_mosi72;
      RX_MISO           : out t_ll_ext_miso;
                        
      ABORT_CALC        : out std_logic;
      FLUSH_FIFO        : out std_logic;
      FLUSH_FIFO_DONE   : in std_logic;
      
      TX0_MOSI          : out t_ll_ext_mosi72;
      TX0_MISO          : in t_ll_ext_miso;
      SEND_RESULT0      : out std_logic;
                       
      TX1_MOSI          : out t_ll_ext_mosi72;
      TX1_MISO          : in t_ll_ext_miso;
      SEND_RESULT1      : out std_logic;
      
      ERR               : out std_logic
      );
end afpa_elec_offset_ctrler;

architecture rtl of afpa_elec_offset_ctrler is     
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   type ofs_ctrl_fsm_type is (idle, active_dly_st, dispatch_samp_st, send_result_st0, send_result_st1, check_end_st, abort_calc_st);
   
   signal ofs_ctrl_fsm        : ofs_ctrl_fsm_type;
   signal sreset			      : std_logic;
   signal tx_dval             : std_logic_vector(1 downto 0);
   signal tx_data             : std_logic_vector(RX_MOSI.DATA'LENGTH-1 downto 0);
   signal lane_enabled        : std_logic_vector(1 downto 0);
   signal elec_ofs_start_i    : std_logic;
   signal elec_ofs_end_i      : std_logic;
   signal flush_fifo_i        : std_logic;
   signal abort_calc_i        : std_logic;
   signal send_result         : std_logic_vector(1 downto 0);
   signal dly_cnt             : unsigned(7 downto 0);
   signal dcount              : unsigned(7 downto 0);
   signal err_i               : std_logic;
   
begin
   
   RX_MISO.AFULL <= TX0_MISO.AFULL or TX1_MISO.AFULL;
   RX_MISO.BUSY  <= TX0_MISO.BUSY or TX1_MISO.BUSY;
   ABORT_CALC    <= abort_calc_i;
   FLUSH_FIFO    <= flush_fifo_i;
   
   TX0_MOSI.DATA <= tx_data;
   TX0_MOSI.DVAL <= tx_dval(0);
   SEND_RESULT0  <= send_result(0); 
   
   TX1_MOSI.DATA <= tx_data;
   TX1_MOSI.DVAL <= tx_dval(1);
   SEND_RESULT1  <= send_result(1);
   
   ERR <= err_i;
   
   
   ------------------------------------------------------
   -- Sync reset
   ------------------------------------------------------
   sync_reset_map : sync_reset
   port map(
      ARESET => ARESET,
      CLK => CLK,
      SRESET => sreset
      ); 
   
   ------------------------------------------------------
   -- data_ctrl
   ------------------------------------------------------
   process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            tx_dval(1 downto 0) <= (others => '0');
            
         else
            
            -- definition des données 
            tx_data  <= RX_MOSI.DATA;
            tx_dval(0) <= RX_MOSI.DVAL and lane_enabled(0);  
            tx_dval(1) <= RX_MOSI.DVAL and lane_enabled(1);         
            
            -- autres definitions
            elec_ofs_start_i <= RX_MOSI.MISC(0) and RX_MOSI.DVAL;
            elec_ofs_end_i   <= RX_MOSI.MISC(1) and RX_MOSI.DVAL;
            
            err_i <= not FLUSH_FIFO_DONE and (tx_dval(0) or  tx_dval(1));
            
         end if;
      end if;
      
   end process;   
   
   ------------------------------------------------------
   -- process de contrôle
   ------------------------------------------------------
   process(CLK)
      variable incr   : unsigned(1 downto 0);
      
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            flush_fifo_i <= '1';
            abort_calc_i <= '1';
            lane_enabled  <= (others => '0');
            send_result <= (others => '0');
            ofs_ctrl_fsm <= idle;           
         else            
            
            -- valeur par defaut
            send_result <= (others => '0');            
            
            case ofs_ctrl_fsm is 
               
               when idle =>
                  flush_fifo_i <= '0';
                  abort_calc_i <= '0'; 
                  dly_cnt <= (others => '0');
                  dcount <= (others => '0');
                  if elec_ofs_start_i = '1' then 
                     ofs_ctrl_fsm <= active_dly_st;
                     flush_fifo_i <= '1';            -- on flush la memoire des offsets
                  end if;                                    
               
               when active_dly_st =>                 -- delai en nombre de samples avant d'aller chercher les pixels d'une ligne
                  flush_fifo_i <= '0';
                  incr := '0'& RX_MOSI.DVAL;
                  dly_cnt <= dly_cnt + to_integer(unsigned(incr));                 
                  if dly_cnt >= to_integer(FPA_INTF_CFG.ELEC_OFS_START_DLY) then
                     ofs_ctrl_fsm <= dispatch_samp_st;
                     lane_enabled <= "01";     -- pour activation du lane0
                  end if;                
               
               when dispatch_samp_st =>            -- on envoie les echantillons aux deux lanes de moyenneurs
                  if RX_MOSI.DVAL = '1' then 
                     lane_enabled <= not lane_enabled;
                  end if;
                  if elec_ofs_end_i = '1' then       -- fin de la zone de calcul d'offset
                     lane_enabled <= "00";
                     ofs_ctrl_fsm <= send_result_st0;
                  end if;
               
               when send_result_st0 =>
                  send_result(0) <= '1';         -- dure 1 clk à cause de la valeur par defaut en haut
                  ofs_ctrl_fsm <= send_result_st1;
               
               when send_result_st1 =>                  
                  send_result(1) <= '1';         -- dure 1 clk à cause de la valeur par defaut en haut
                  ofs_ctrl_fsm <= check_end_st;
               
               when check_end_st =>               
                  dcount <= dcount + 1;
                  if dcount(2) = '1' then         -- ENO: 04 oct 2017: ecrire au moins 4 elements identiques de chaque dans le fifo de sorte que le recyckage se fasse sans bug 
                     ofs_ctrl_fsm <= abort_calc_st;
                  else
                     ofs_ctrl_fsm <= send_result_st0;  
                  end if;                  
               
               when abort_calc_st =>
                  abort_calc_i <= '1';
                  dcount <= dcount + 1;
                  if dcount(3) = '1' then
                     ofs_ctrl_fsm <= idle;
                  end if;
               
               when others =>
               
            end case; 	
            
         end if;
      end if;
      
   end process;  
   
   
end rtl;
