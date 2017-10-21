------------------------------------------------------------------
--!   @file : afpa_elec_offset_calc
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
use work.FPA_Define.all;
use work.fpa_common_pkg.all;

entity afpa_elec_offset_calc is
   port(      
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      FPA_INTF_CFG   : in fpa_intf_cfg_type;
      SEND_RESULT    : in std_logic;
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MISO        : in t_ll_ext_miso;    
      TX_MOSI        : out t_ll_ext_mosi72;
      ERR            : out std_logic
      );
end afpa_elec_offset_calc;

architecture rtl of afpa_elec_offset_calc is
   
   constant C_SYNC_POS           : natural := 1; -- le dval sort parfaitement synchro avec la donnée à la position 1 dans le pipe
   constant C_SYNC_POS_M1        : natural := C_SYNC_POS - 1; -- calcul
   constant C_DENOM_CONV_BIT_POS : natural := 21;
   constant C_RESULT_MSB_POS     : natural := TX_MOSI.DATA'LENGTH/4 + C_DENOM_CONV_BIT_POS - 1;
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK    : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   type samp_sum_fsm_type is (passthru_st, sum_st);
   type samp_sum_type is array (1 to 4) of unsigned(20 downto 0);
   type result_type is array (1 to 4) of unsigned(17 downto 0); 
   type temp_result_type is array (1 to 4) of unsigned(C_RESULT_MSB_POS downto 0);
   
   signal samp_sum_fsm        : samp_sum_fsm_type;
   signal samp_data           : samp_sum_type;
   signal sreset			      : std_logic;
   signal err_i               : std_logic;
   signal samp_count          : integer range 0 to 127;
   signal samp_sum_dval       : std_logic;
   signal samp_sum_data       : samp_sum_type;
   signal samp_sum_data_latch : samp_sum_type;
   signal samp_sum_en         : std_logic;
   signal numerator           : unsigned(FPA_INTF_CFG.ELEC_OFS_SAMP_MEAN_NUMERATOR'LENGTH-1 downto 0);
   signal result_dval         : std_logic;
   signal result              : result_type;
   signal send_result_i       : std_logic := '0';
   signal send_result_last    : std_logic := '0';
   signal temp_result         : temp_result_type;
   
   
begin
   
   ------------------------------------------------------
   -- output map
   ------------------------------------------------------
   TX_MOSI.DVAL <= result_dval;
   TX_MOSI.DATA <= std_logic_vector(result(4)) & std_logic_vector(result(3)) & std_logic_vector(result(2)) & std_logic_vector(result(1));
   
   ERR <= err_i;	
   RX_MISO <= TX_MISO;
   
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
   -- input map
   ------------------------------------------------------	
   samp_data(4) <= resize(unsigned(RX_MOSI.DATA(71 downto 54)), samp_data(4)'length);
   samp_data(3) <= resize(unsigned(RX_MOSI.DATA(53 downto 36)), samp_data(3)'length);
   samp_data(2) <= resize(unsigned(RX_MOSI.DATA(35 downto 18)), samp_data(2)'length);
   samp_data(1) <= resize(unsigned(RX_MOSI.DATA(17 downto 0)) , samp_data(1)'length);	   
   
   ------------------------------------------------------
   --process de calcul des sommes
   ------------------------------------------------------
   process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            samp_sum_dval <= '0';	
            samp_sum_fsm <= passthru_st;           
         else
            
            err_i <= TX_MISO.BUSY and RX_MOSI.DVAL;
            if to_integer(FPA_INTF_CFG.ELEC_OFS_SAMP_NUM_PER_CH) > 1 then
               samp_sum_en <= '1';
            else
               samp_sum_en <= '0';
            end if;            
            
            case samp_sum_fsm is 
               
               when passthru_st =>                     
                  samp_count <= 1;	
                  samp_sum_dval <= RX_MOSI.DVAL and not samp_sum_en;
                  for ii in 1 to 4 loop
                     samp_sum_data(ii) <= samp_data(ii);  
                  end loop;
                  if samp_sum_en = '1' and RX_MOSI.DVAL = '1' then
                     samp_sum_fsm <= sum_st;
                  end if;
               
               when sum_st =>
                  if RX_MOSI.DVAL = '1' then 
                     samp_count <= samp_count + 1; 
                     for ii in 1 to 4 loop
                        samp_sum_data(ii) <= samp_sum_data(ii) + samp_data(ii);
                     end loop;
                  end if;
                  if samp_count = to_integer(unsigned(FPA_INTF_CFG.ELEC_OFS_SAMP_NUM_PER_CH)) then
                     samp_sum_fsm <= passthru_st; 
                     samp_sum_dval <= '1';   
                  end if;
               
               when others =>
               
            end case; 	
            
         end if;
      end if;
      
   end process;
   
   ------------------------------------------------------
   --process de calcul de la moyenne
   ------------------------------------------------------
   process(CLK) 
   begin
      if rising_edge(CLK) then
         
         -- passage dans des registres 
         numerator <= unsigned(FPA_INTF_CFG.ELEC_OFS_SAMP_MEAN_NUMERATOR);
         send_result_i <= SEND_RESULT;
         send_result_last <= send_result_i;
         
         -- latch des sommes
         if samp_sum_dval = '1' then 
            for ii in 1 to 4 loop               
               samp_sum_data_latch(ii) <= samp_sum_data(ii);
            end loop;
         end if; 
         
         -- division
         for ii in 1 to 4 loop
            temp_result(ii) <= resize(samp_sum_data_latch(ii) * numerator, temp_result(1)'length);
            result(ii) <= temp_result(ii)(C_RESULT_MSB_POS downto C_DENOM_CONV_BIT_POS);       -- soit une division par 2^denom_conv_bit_pos
         end loop;
         
         -- validation de la sortie
         result_dval <= not send_result_last and send_result_i; -- donnée sort uniquement sur front montant de send_result_i
         
      end if;      
      
   end process;
   
   
end rtl;