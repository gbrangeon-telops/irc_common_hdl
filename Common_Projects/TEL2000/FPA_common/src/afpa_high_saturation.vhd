------------------------------------------------------------------
--!   @file : afpa_high_saturation
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
use work.fpa_common_pkg.all;
use work.tel2000.all;

entity afpa_high_saturation is
   port(
      ARESET     : in std_logic;
      CLK        : in std_logic;   
      
      ENABLE     : in std_logic;     
      
      RX_MOSI    : in t_axi4_stream_mosi64;
      RX_MISO    : out t_axi4_stream_miso;
      TX_MISO    : in t_axi4_stream_miso;      
      TX_MOSI    : out t_axi4_stream_mosi64;
      
      ERR        : out std_logic
      );
end afpa_high_saturation;



architecture rtl of afpa_high_saturation is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   --signal reorder_sm       : reorder_sm_type;
   signal sreset           : std_logic;
   signal err_i            : std_logic;
   signal tx_mosi_i        : t_axi4_stream_mosi64;
   
begin    
   
   --------------------------------------------------
   -- outputs maps
   -------------------------------------------------- 
   TX_MOSI <= tx_mosi_i;
   RX_MISO <= TX_MISO;
   
   ERR <= err_i;                                          
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );
   
   --------------------------------------------------
   -- saturation
   -------------------------------------------------- 
   U3 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            err_i <= '0';
            tx_mosi_i.tvalid <= '0';
         else
            
            tx_mosi_i <= RX_MOSI;
            if ENABLE = '1' then
               for kk in 1 to 4 loop
                  if signed(RX_MOSI.TDATA((16*kk-1) downto 16*(kk-1))) > 16383 then   -- soit 2^14 - 1
                     tx_mosi_i.tdata((16*kk-1) downto 16*(kk-1)) <= std_logic_vector(to_unsigned(16383, 16)); 
                  end if;
               end loop;
            end if;
            
            err_i <= tx_mosi_i.tvalid and not TX_MISO.TREADY;   -- le module fpa a horreur du busy. Erreur grave de vitesse                   
            
         end if;                             
      end if;
   end process;
   
end rtl;
