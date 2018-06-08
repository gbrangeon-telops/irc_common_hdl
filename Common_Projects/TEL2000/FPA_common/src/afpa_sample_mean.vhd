------------------------------------------------------------------
--!   @file : afpa_sample_mean
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

entity afpa_sample_mean is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      SAMP_MEAN_NUMERATOR   : in std_logic_vector(22 downto 0);
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      
      ERR            : out std_logic
      );
end afpa_sample_mean;


architecture rtl of afpa_sample_mean is 
   
   constant C_SYNC_POS           : natural := 1; -- le dval sort parfaitement synchro avec la donnée à la position 1 dans le pipe
   constant C_SYNC_POS_M1        : natural := C_SYNC_POS - 1; -- calcul
   constant C_DENOM_CONV_BIT_POS : natural := 21;
   constant C_RESULT_MSB_POS     : natural := TX_MOSI.DATA'LENGTH/4 + C_DENOM_CONV_BIT_POS - 1;

   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   type result_type is array (1 to 4) of signed(17 downto 0); 
   type temp_result_type is array (1 to 4) of signed(C_RESULT_MSB_POS + 1 downto 0); 
   
   signal result, samp_sum_pix      : result_type;
   signal sreset			            : std_logic;
   signal err_i                     : std_logic;
   signal result_sof_pipe           : std_logic_vector(C_SYNC_POS downto 0);
   signal result_eof_pipe           : std_logic_vector(C_SYNC_POS downto 0);
   signal result_sol_pipe           : std_logic_vector(C_SYNC_POS downto 0);
   signal result_eol_pipe           : std_logic_vector(C_SYNC_POS downto 0);
   signal result_dval_pipe          : std_logic_vector(C_SYNC_POS downto 0);
   signal numerator                 : signed(SAMP_MEAN_NUMERATOR'LENGTH downto 0);
   --signal denom_conv_bit_pos        : unsigned(FPA_INTF_CFG.GOOD_SAMP_MEAN_DIV_BIT_POS'LENGTH-1 downto 0);  
   signal temp_result               : temp_result_type;
   
   
begin
   
   
   ------------------------------------------------------
   -- output map
   ------------------------------------------------------
   TX_MOSI.SOF  <= result_sof_pipe(C_SYNC_POS);
   TX_MOSI.EOF  <= result_eof_pipe(C_SYNC_POS);
   TX_MOSI.SOL  <= result_sol_pipe(C_SYNC_POS);
   TX_MOSI.EOL  <= result_eol_pipe(C_SYNC_POS);
   TX_MOSI.DVAL <= result_dval_pipe(C_SYNC_POS);
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
   samp_sum_pix(4) <= signed(RX_MOSI.DATA(71 downto 54));
   samp_sum_pix(3) <= signed(RX_MOSI.DATA(53 downto 36));
   samp_sum_pix(2) <= signed(RX_MOSI.DATA(35 downto 18));
   samp_sum_pix(1) <= signed(RX_MOSI.DATA(17 downto 0));	
   
   ------------------------------------------------------
   --process de calcul des moyennes
   ------------------------------------------------------
   process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            result_dval_pipe <= (others => '0');
            
         else
            
            -- passage dans des registres 
            numerator <= signed('0'& SAMP_MEAN_NUMERATOR);
            
            -- division
            for ii in 1 to 4 loop
               temp_result(ii) <= resize(samp_sum_pix(ii) * numerator, temp_result(1)'length);
               result(ii) <= temp_result(ii)(C_RESULT_MSB_POS downto C_DENOM_CONV_BIT_POS);  -- soit une division par 2^denom_conv_bit_pos
            end loop;
            
            -- pipe de sortie
            result_dval_pipe(C_SYNC_POS downto 0) <= result_dval_pipe(C_SYNC_POS_M1 downto 0) & RX_MOSI.DVAL;
            result_sof_pipe(C_SYNC_POS downto 0)  <= result_sof_pipe(C_SYNC_POS_M1 downto 0)  & RX_MOSI.SOF;
            result_sol_pipe(C_SYNC_POS downto 0)  <= result_sol_pipe(C_SYNC_POS_M1 downto 0)  & RX_MOSI.SOL;
            result_eof_pipe(C_SYNC_POS downto 0)  <= result_eof_pipe(C_SYNC_POS_M1 downto 0)  & RX_MOSI.EOF;
            result_eol_pipe(C_SYNC_POS downto 0)  <= result_eol_pipe(C_SYNC_POS_M1 downto 0)  & RX_MOSI.EOL;
            
            -- erreurs
            err_i <= RX_MOSI.DVAL and result_dval_pipe(C_SYNC_POS);  
            
            
         end if;
      end if;       
      
   end process;
   
   
end rtl;
