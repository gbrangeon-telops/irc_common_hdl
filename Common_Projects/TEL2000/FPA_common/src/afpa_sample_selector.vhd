------------------------------------------------------------------
--!   @file : afpa_sample_selector
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
use work.proxy_define.all;
use work.fpa_common_pkg.all;

entity afpa_sample_selector is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      FPA_INTF_CFG   : fpa_intf_cfg_type;
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      SAMP_CNT       : in std_logic_vector(7 downto 0);
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      
      ERR            : out std_logic
      );
end afpa_sample_selector;



architecture rtl of afpa_sample_selector is
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   type tx_mosi_pipe_type is array (0 to 1) of t_ll_ext_mosi72;
   
   signal sreset              : std_logic; 
   signal err_i               : std_logic;
   signal tx_mosi_pipe        : tx_mosi_pipe_type;
   signal sample_valid_set1   : std_logic;
   signal sample_valid_set2   : std_logic;
   
begin
   
   TX_MOSI <= tx_mosi_pipe(1);   
   ERR <= err_i;
   RX_MISO <= TX_MISO;
   
   
   ------------------------------------------------------
   -- Sync reset
   ------------------------------------------------------
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK => CLK,
      SRESET => sreset
      );
   
   ------------------------------------------------------
   -- choix des echantilllons
   ------------------------------------------------------
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then 
         
         tx_mosi_pipe(0) <= RX_MOSI;
         
         if  unsigned(SAMP_CNT) >= FPA_INTF_CFG.GOOD_SAMP_FIRST_POS_PER_CH then
            sample_valid_set1 <= RX_MOSI.DVAL;
         else
            sample_valid_set1 <= '0';
         end if;
         
         if  unsigned(SAMP_CNT) <= FPA_INTF_CFG.GOOD_SAMP_LAST_POS_PER_CH then
            sample_valid_set2 <= RX_MOSI.DVAL;
         else
            sample_valid_set2 <= '0';  
         end if;
         
         tx_mosi_pipe(1) <= tx_mosi_pipe(0);
         tx_mosi_pipe(1).dval <=sample_valid_set1 and sample_valid_set2;
         
      end if;   
   end process;
   
end rtl;
