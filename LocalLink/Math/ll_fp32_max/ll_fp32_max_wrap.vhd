---------------------------------------------------------------------------------------------------
--
-- Title       : ll_fp32_max_wrap
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
---------------------------------------------------------------------------------------------------
--
-- Description : This is the wrapper to be used by the end user. Its ports are records.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.Telops.all; 

entity ll_fp32_max_wrap is
   port(        
      RX_MOSI  : in  t_ll_mosi32;
      -- No MISO because never busy;
      
      MAX      : out std_logic_vector(31 downto 0);
      NEW_MAX  : out std_logic;
      
      ARESET   : in std_logic;
      CLK      : in std_logic	 		 		 
      );
end ll_fp32_max_wrap;     


architecture SIM of ll_fp32_max_wrap is    

   component ll_fp32_max
      port(                 
         RX_MOSI : in t_ll_mosi32;
         MAX      : out std_logic_vector(31 downto 0);
         NEW_MAX  : out std_logic;
         
         ARESET   : in std_logic;
         CLK      : in std_logic		 		 		 
         );
   end component; 
   
begin                                       
 
   U1 : entity ll_fp32_max
   port map(
      RX_MOSI => RX_MOSI,
      MAX      => MAX,
      NEW_MAX  => NEW_MAX,
               
      ARESET   => ARESET,
      CLK      => CLK
   );    
   
end SIM;
