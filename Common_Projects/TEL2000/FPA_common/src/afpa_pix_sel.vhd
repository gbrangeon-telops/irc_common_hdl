------------------------------------------------------------------
--!   @file : afpa_pix_sel
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
use work.proxy_define.all;

entity afpa_pix_sel is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      CFG            : in line_area_cfg_type;
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      RX_POS         : in std_logic_vector(9 downto 0);
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      
      ERR            : out std_logic
      );
end afpa_pix_sel;



architecture rtl of afpa_pix_sel is
   
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
   signal tx_pos_i            : unsigned(RX_POS'LENGTH-1 downto 0); 
   
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
   -- choix des données
   ------------------------------------------------------
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            sample_valid_set1 <= '0';
            tx_mosi_pipe(0).dval <= '0';
            tx_mosi_pipe(1).dval <= '0';
            sample_valid_set2 <= '0';
            
         else
            
            
            -- données
            tx_mosi_pipe(0) <= RX_MOSI;
            
            if  unsigned(RX_POS) >= to_integer(CFG.SOL_POS) then
               sample_valid_set1 <= RX_MOSI.DVAL;
            else
               sample_valid_set1 <= '0';
            end if;
            
            if  unsigned(RX_POS) <= to_integer(CFG.EOL_POS) then
               sample_valid_set2 <= RX_MOSI.DVAL;
            else
               sample_valid_set2 <= '0';  
            end if;
            
            tx_mosi_pipe(1) <= tx_mosi_pipe(0);
            tx_mosi_pipe(1).dval <=sample_valid_set1 and sample_valid_set2;
                       
         end if;
         
      end if;   
   end process;
   
end rtl;
