------------------------------------------------------------------
--!   @file : afpa_pix_pos
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

entity afpa_pix_pos is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      TX_POS         : out std_logic_vector(9 downto 0);
      
      ERR            : out  std_logic
      );
end afpa_pix_pos;



architecture rtl of afpa_pix_pos is
   
   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK    : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   signal sreset          : std_logic; 
   signal tx_pos_i        : unsigned(TX_POS'LENGTH-1 downto 0); 
   signal err_i           : std_logic;
   signal tx_mosi_i       : t_ll_ext_mosi72;
   
begin
   
   TX_MOSI <= tx_mosi_i;
   RX_MISO <= TX_MISO;
   
   TX_POS <= std_logic_vector(tx_pos_i);
   
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
   -- numerotation des quads
   -----------------------------------------------------    
   U2: process(CLK)
      
   begin  
      if rising_edge(CLK) then 
         if sreset = '1' then 
            tx_mosi_i.dval <= '0'; 
            err_i <= '0';  
            
         else 
            
            -- sortie des données 
            tx_mosi_i  <=  RX_MOSI;
            
            -- sortie des numeros des quads
            if RX_MOSI.DVAL = '1' then 
               if RX_MOSI.SOL = '1' then 
                  tx_pos_i <= to_unsigned(1, tx_pos_i'length);
               else
                  tx_pos_i <= tx_pos_i + 1;        -- 
               end if;				  
            end if;
            
            -- erreur
            err_i <= TX_MISO.BUSY and tx_mosi_i.dval;
            
         end if;           
      end if;			
   end process;
   
   
   
end rtl;
