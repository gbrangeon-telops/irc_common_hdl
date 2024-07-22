------------------------------------------------------------------
--!   @file : afpa_line_pos
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

entity afpa_line_pos is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      RX_MOSI        : in t_ll_ext_mosi72;
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MOSI        : out t_ll_ext_mosi72;
      TX_MISO        : in t_ll_ext_miso;
      LINE_POS       : out std_logic_vector(13 downto 0);
      
      ERR            : out  std_logic
      );
end afpa_line_pos;



architecture rtl of afpa_line_pos is

   component sync_reset
      port (
         ARESET : in STD_LOGIC;
         CLK    : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1'
         );
   end component;
   
   signal sreset          : std_logic; 
   signal line_pos_i      : unsigned(LINE_POS'LENGTH-1 downto 0); 
   signal err_i           : std_logic;
   signal tx_mosi_i       : t_ll_ext_mosi72;
   
begin  
	
	
   TX_MOSI <= tx_mosi_i;
   RX_MISO <= TX_MISO;
   LINE_POS <= std_logic_vector(line_pos_i);
   ERR <= err_i;
   
   ------------------------------------------------------
   -- Sync reset
   ------------------------------------------------------
   U1 : sync_reset
   port map (
      ARESET => ARESET,
      CLK => CLK,
      SRESET => sreset
   );
   
   -----------------------------------------------------
   -- numérotation des lignes
   -----------------------------------------------------    
   U2: process(CLK)
   begin  
      if rising_edge(CLK) then 
         if sreset = '1' then 
            tx_mosi_i.dval <= '0'; 
            err_i <= '0';  
         else 
            -- sortie des données 
            tx_mosi_i  <= RX_MOSI;
            
            -- sortie des numéros des lignes
            if RX_MOSI.DVAL = '1' then 
               if RX_MOSI.SOF = '1' then 
                  line_pos_i <= to_unsigned(1, line_pos_i'length);
               elsif RX_MOSI.EOL = '1' then
                  line_pos_i <= line_pos_i + 1;        -- 
               end if;				  
            end if;
            
            -- erreur
            err_i <= TX_MISO.BUSY and tx_mosi_i.dval;
            
         end if;           
      end if;			
   end process;
      
   
 
end rtl;
