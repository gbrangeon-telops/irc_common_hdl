------------------------------------------------------------------
--!   @file : afpa_faked_data_gen
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
use work.Fpa_Common_Pkg.all;
use work.fpa_define.all;
--use work.tel2000.all;

entity afpa_faked_data_gen is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      FPA_INTF_CFG   : in fpa_intf_cfg_type;
      
      RX_MOSI        : in t_ll_ext_mosi72; 
      RX_MISO        : out t_ll_ext_miso;
      
      TX_MISO        : in t_ll_ext_miso;
      TX_MOSI        : out t_ll_ext_mosi72
      
      );
end afpa_faked_data_gen;

architecture rtl of afpa_faked_data_gen is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;   
   
   signal tx_mosi_i        : t_ll_ext_mosi72;
   signal sreset           : std_logic;
   
begin
   
   TX_MOSI <= tx_mosi_i;
   RX_MISO <= TX_MISO;
   
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
   -- operateur de soustraction (A-B)                          
   --------------------------------------------------
   U3 :  process(CLK) 
   begin
      if rising_edge(CLK) then
         -- if sreset = '1' then 
            -- tx_mosi_i.dval <= '0'; 
            -- tx_mosi_i.support_busy <= '1';
            
         -- else
            
            -- tx_mosi_i <= RX_MOSI;
            -- if FPA_INTF_CFG.ELCORR_PIX_FAKED_VALUE_FORCED = '1' then
               -- tx_mosi_i.data(71 downto 54) <= std_logic_vector(resize(FPA_INTF_CFG.ELCORR_PIX_FAKED_VALUE, 18));
               -- tx_mosi_i.data(53 downto 36) <= std_logic_vector(resize(FPA_INTF_CFG.ELCORR_PIX_FAKED_VALUE, 18));
               -- tx_mosi_i.data(35 downto 18) <= std_logic_vector(resize(FPA_INTF_CFG.ELCORR_PIX_FAKED_VALUE, 18));
               -- tx_mosi_i.data(17 downto 0)  <= std_logic_vector(resize(FPA_INTF_CFG.ELCORR_PIX_FAKED_VALUE, 18));
            -- else
               -- tx_mosi_i.data <= RX_MOSI.DATA;
            -- end if;
            
         -- end if;
      end if;
   end process;    
end rtl;
