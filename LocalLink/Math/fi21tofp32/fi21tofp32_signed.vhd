-------------------------------------------------------------------------------
--
-- Title       : fi21tofp32_signed
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This is a SIMULATION wrapper only.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;       
library Common_HDL;
use Common_HDL.Telops.all; 

entity fi21tofp32_signed is
   port(           
      RX_LL_MOSI  : in  t_ll_mosi21;
      RX_LL_MISO  : out t_ll_miso;   
      
      TX_LL_MOSI  : out t_ll_mosi32;
      TX_LL_MISO  : in  t_ll_miso;   
      
      TDM_FLOW    : in  std_logic;
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC      
      );
end fi21tofp32_signed;  

-- pragma translate_off

-- Declare these librairies only for the architecture
library IEEE;
use ieee.numeric_std.all;
library IEEE_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

architecture SIM of fi21tofp32_signed is
   

begin                

U1 : entity fi21tofp32
   generic map(    
      Support_TDM => TRUE,
      signed_fi => TRUE
      )
   port map(
      RX_LL_MOSI => RX_LL_MOSI,
      RX_LL_MISO => RX_LL_MISO,
      TX_LL_MOSI => TX_LL_MOSI,
      TX_LL_MISO => TX_LL_MISO,
      TDM_FLOW => TDM_FLOW,
      ARESET => ARESET,
      CLK => CLK
   );
   
end SIM;

-- pragma translate_on
