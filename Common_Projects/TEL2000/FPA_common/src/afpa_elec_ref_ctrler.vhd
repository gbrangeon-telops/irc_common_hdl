------------------------------------------------------------------
--!   @file : afpa_elec_ref_ctrler
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

entity afpa_elec_ref_ctrler is
   
   generic(
      REF_ID : natural := 0 
      );
   
   port(
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;
      
      RX_MOSI           : in t_ll_ext_mosi72;
      RX_MISO           : out t_ll_ext_miso;
      
      TX_MOSI           : out t_ll_ext_mosi72;
      TX_MISO           : in t_ll_ext_miso;
      
      ABORT_CALC        : out std_logic;
      
      ERR               : out std_logic
      );
end afpa_elec_ref_ctrler;

architecture rtl of afpa_elec_ref_ctrler is     
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   type ref_ctrl_fsm_type is (idle, global_dly_st, wait_ref_start_st, wait_ref_end_st, pause_st, abort_calc_st);
   
   signal ref_ctrl_fsm        : ref_ctrl_fsm_type;
   signal sreset			      : std_logic;
   signal tx_dval             : std_logic;
   signal tx_data             : std_logic_vector(RX_MOSI.DATA'LENGTH-1 downto 0);
   signal lane_enabled        : std_logic;
   signal dly_cnt             : unsigned(7 downto 0);
   signal pause_cnt           : unsigned(7 downto 0);
   signal err_i               : std_logic;
   signal abort_calc_i        : std_logic;
   signal ref_valid_i         : std_logic;
   signal global_active_area_i: std_logic;
   
begin
   
   RX_MISO.AFULL <= TX_MISO.AFULL;
   RX_MISO.BUSY  <= TX_MISO.BUSY;
   ABORT_CALC    <= abort_calc_i;
   TX_MOSI.DATA  <= tx_data;
   TX_MOSI.DVAL  <= tx_dval;
   
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
            tx_dval <= '0';
            err_i <= '0';
            
         else
            
            -- definition des donn�es
            tx_data <= RX_MOSI.DATA;
            tx_dval <= RX_MOSI.DVAL and lane_enabled;     
            
         end if;
      end if;
      
   end process;   
   
   ------------------------------------------------------
   -- process de contr�le
   ------------------------------------------------------
   process(CLK)
      variable incr   : unsigned(1 downto 0);
      
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            lane_enabled  <= '0';
            ref_ctrl_fsm <= idle;
            abort_calc_i <= '1';
            ref_valid_i <= '0';
            global_active_area_i <= '0';
            
         else            
            
            ref_valid_i <= RX_MOSI.MISC(0);  -- selon la definition du module en amont
            
            if RX_MOSI.EOF = '1' then 
               global_active_area_i <= '0';
            elsif RX_MOSI.SOF = '1' then
               global_active_area_i <= '1';
            end if;
            
            
            case ref_ctrl_fsm is 
               
               when idle =>
                  abort_calc_i <= '0'; 
                  dly_cnt <= (others => '0');
                  pause_cnt <= (others => '0');
                  if RX_MOSI.SOF = '1' then          -- debut de la zone globale de d�finition des r�f�rences
                     ref_ctrl_fsm <= global_dly_st;
                  end if;                                    
               
               when global_dly_st =>                 -- delai en nombre de samples avant d'aller chercher les pixels d'une ligne
                  incr := '0'& RX_MOSI.DVAL;
                  dly_cnt <= dly_cnt + to_integer(unsigned(incr));                 
                  if dly_cnt >= to_integer(FPA_INTF_CFG.ELCORR_REF_CFG(REF_ID).START_DLY_SAMPCLK) then
                     ref_ctrl_fsm <= wait_ref_start_st;
                  end if;
               
               when wait_ref_start_st =>
                  if ref_valid_i = '1' then
                     ref_ctrl_fsm <= wait_ref_end_st;
                  end if;                  
               
               when wait_ref_end_st =>
                  lane_enabled <= ref_valid_i;                  
                  if ref_valid_i = '0' then         -- fin de la zone retreinte de definition de la reference
                     ref_ctrl_fsm <= pause_st;
                  end if;                
               
               when pause_st =>                      -- on attend que le dernier echantillon se circule dans le pipe du moyenneur
                  pause_cnt <= pause_cnt + 1;
                  lane_enabled <= '0';
                  if pause_cnt(3) = '1' then        
                     ref_ctrl_fsm <= abort_calc_st; 
                  end if;                  
               
               when abort_calc_st =>                 -- on fait un reset sur le moyenneur afin qu'il reinitialise son pipe
                  abort_calc_i <= '1';
                  pause_cnt <= pause_cnt + 1;
                  if pause_cnt(4) = '1' then
                     if global_active_area_i = '0' then   -- on va en idle car la zone des references est termin�e
                        ref_ctrl_fsm <= idle;
                     else                                 -- la zone de prise des references n'est pas finie.  
                        ref_ctrl_fsm <= wait_ref_start_st;
                     end if;
                  end if;
               
               when others =>
               
            end case;
            
            -- priorit� absolue: � la fin de la zone globale des references, abandonner tout
            if RX_MOSI.EOF = '1' and ref_ctrl_fsm /= idle  then                      -- fin de la zone globale de definition de la reference
               ref_ctrl_fsm <= pause_st;
            end if;
            
         end if;
      end if;
      
   end process;  
   
   
end rtl;
