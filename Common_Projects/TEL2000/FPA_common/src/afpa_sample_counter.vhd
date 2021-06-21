------------------------------------------------------------------
--!   @file : afpa_sample_counter
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

entity afpa_sample_counter is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      FPA_INTF_CFG   : in fpa_intf_cfg_type;
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      SAMP_CNT       : out std_logic_vector(7 downto 0);
      
      ERR            : out  std_logic_vector(1 downto 0)
      );
end afpa_sample_counter;



architecture rtl of afpa_sample_counter is
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   signal sreset          : std_logic; 
   signal samp_cnt_i      : unsigned(SAMP_CNT'LENGTH-1 downto 0); 
   signal err_i           : std_logic_vector(1 downto 0);
   signal tx_mosi_i       : t_ll_ext_mosi72;
   
begin
   
   TX_MOSI <= tx_mosi_i;
   RX_MISO <= TX_MISO;
   
   SAMP_CNT <= std_logic_vector(samp_cnt_i);
   
   ERR <= err_i;
   
   
   ------------------------------------------------------
   -- Sync reset
   ------------------------------------------------------
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK => CLK,
      SRESET => sreset
      );
   
   -----------------------------------------------------
   -- numerotation des echantillons
   -----------------------------------------------------    
   U2: process(CLK)
      variable dval_i : std_logic_vector(7 downto 0);
   begin  
      if rising_edge(CLK) then 
         if sreset = '1' then 
            tx_mosi_i.dval <= '0';
            samp_cnt_i <= (others => '0'); 
            err_i <= (others => '0');  
            
         else 
            
            -- sortie des données 
            tx_mosi_i  <=  RX_MOSI;
            
            -- sortie des numeros des echantillons
            dval_i := "0000000"&RX_MOSI.DVAL;    -- fait ainsi pour eviter problème de synthese avec vivado
            if samp_cnt_i = FPA_INTF_CFG.PIX_SAMP_NUM_PER_CH then 
               samp_cnt_i <= unsigned(dval_i);              -- initialisation de samp_cnt_i à 1 di dval à '1', sinon à 0
            else
               samp_cnt_i <= samp_cnt_i + unsigned(dval_i); --  samp_cnt_i s'incrémente de 1 ssi dval à '1', sinon increment = 0
            end if;           
            
            -- erreur
            err_i(0)<= TX_MISO.BUSY and tx_mosi_i.dval;
            
         end if;           
      end if;			
   end process;
   
   
   
end rtl;
