------------------------------------------------------------------
--!   @file : afpa_sample_sum
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

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.FPA_Define.all;
use work.fpa_common_pkg.all;

entity afpa_sample_sum is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      SAMP_SUM_NUM   : in std_logic_vector(3 downto 0);
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      
      ERR            : out std_logic
      );
end afpa_sample_sum;


architecture rtl of afpa_sample_sum is 
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   type samp_sum_fsm_type is (passthru_st, sum_st);
   type pixel_samp_sum_type is array (1 to 4) of unsigned(17 downto 0);
   signal samp_sum_fsm        : samp_sum_fsm_type;
   signal samp_pixel          : pixel_samp_sum_type;
   signal sreset			      : std_logic;
   signal err_i               : std_logic;
   signal samp_count          : integer range 0 to DEFINE_FPA_PIX_SAMPLE_NUM_PER_CH + 1;
   signal pixel_samp_sum_sof  : std_logic;
   signal pixel_samp_sum_eof  : std_logic;
   signal pixel_samp_sum_sol  : std_logic;
   signal pixel_samp_sum_eol  : std_logic;
   signal pixel_samp_sum_dval : std_logic;
   signal pixel_samp_sum_data : pixel_samp_sum_type;
   signal samp_sum_en         : std_logic;
   
   
begin
   
   
   ------------------------------------------------------
   -- output map
   ------------------------------------------------------
   TX_MOSI.SOF  <= pixel_samp_sum_sof;
   TX_MOSI.EOF  <= pixel_samp_sum_eof;
   TX_MOSI.SOL  <= pixel_samp_sum_sol;
   TX_MOSI.EOL  <= pixel_samp_sum_eol;
   TX_MOSI.DVAL <= pixel_samp_sum_dval;
   TX_MOSI.DATA <= std_logic_vector(pixel_samp_sum_data(4)) &  std_logic_vector(pixel_samp_sum_data(3)) &  std_logic_vector(pixel_samp_sum_data(2)) &  std_logic_vector(pixel_samp_sum_data(1));
   
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
   samp_pixel(4) <= unsigned(RX_MOSI.DATA(71 downto 54));
   samp_pixel(3) <= unsigned(RX_MOSI.DATA(53 downto 36));
   samp_pixel(2) <= unsigned(RX_MOSI.DATA(35 downto 18));
   samp_pixel(1) <= unsigned(RX_MOSI.DATA(17 downto 0));	
   
   ------------------------------------------------------
   --process de calcul des sommes
   ------------------------------------------------------
   process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            pixel_samp_sum_dval <= '0';	
            samp_sum_fsm <= passthru_st;
            -- pragma translate_off
            pixel_samp_sum_sof <= '0';
            pixel_samp_sum_eof <= '0';
            -- pragma translate_on 
            
         else
            
            err_i <= TX_MISO.BUSY and RX_MOSI.DVAL;
            if unsigned(SAMP_SUM_NUM) > 1 then
               samp_sum_en <= '1';
            else
               samp_sum_en <= '0';
            end if;
            
            
            case samp_sum_fsm is 
               
               when passthru_st =>                     
                  samp_count <= 1;	
                  pixel_samp_sum_dval <= RX_MOSI.DVAL and not samp_sum_en;
                  pixel_samp_sum_sof <= RX_MOSI.SOF;
                  pixel_samp_sum_sol <= RX_MOSI.SOL;
                  pixel_samp_sum_eof <= RX_MOSI.EOF;
                  pixel_samp_sum_eol <= RX_MOSI.EOL;
                  for ii in 1 to 4 loop
                     pixel_samp_sum_data(ii) <= samp_pixel(ii);  
                  end loop;
                  if samp_sum_en = '1' and RX_MOSI.DVAL = '1' then
                     samp_sum_fsm <= sum_st;
                  end if;
               
               when sum_st =>
                  if RX_MOSI.DVAL = '1' then 
                     samp_count <= samp_count + 1; 
                     pixel_samp_sum_sol <= RX_MOSI.SOL;
                     pixel_samp_sum_eof <= RX_MOSI.EOF;
                     pixel_samp_sum_eol <= RX_MOSI.EOL;
                     for ii in 1 to 4 loop
                        pixel_samp_sum_data(ii) <= pixel_samp_sum_data(ii) + samp_pixel(ii);
                     end loop;
                  end if;
                  if samp_count = to_integer(unsigned(SAMP_SUM_NUM)) then
                     samp_sum_fsm <= passthru_st; 
                     pixel_samp_sum_dval <= '1';   
                  end if;
               
               when others =>
               
            end case; 	
            
         end if;
      end if;
           
   end process;
   
end rtl;
