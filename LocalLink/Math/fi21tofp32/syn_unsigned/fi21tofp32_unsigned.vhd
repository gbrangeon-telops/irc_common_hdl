-------------------------------------------------------------------------------
--
-- Title       : fi21tofp32_unsigned
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This is a wrapper file for the edif fi21tofp32_syn_unsigned.edf
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;       
library Common_HDL;
use Common_HDL.Telops.all; 

entity fi21tofp32_unsigned is
   port(           
      RX_LL_MOSI  : in  t_ll_mosi21;
      RX_LL_MISO  : out t_ll_miso;   
      
      TX_LL_MOSI  : out t_ll_mosi32;
      TX_LL_MISO  : in  t_ll_miso;   
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC      
      );
end fi21tofp32_unsigned;  


architecture SYNPLIFY of fi21tofp32_unsigned is

   signal RX_LL_MOSI_slv : std_logic_vector(24 downto 0);
   signal RX_LL_MISO_slv : std_logic_vector(1 downto 0);
   signal TX_LL_MOSI_slv : std_logic_vector(35 downto 0);
   signal TX_LL_MISO_slv : std_logic_vector(1 downto 0);   
   
	component fi21tofp32_syn_unsigned
	port(
      RX_LL_MOSI_slv : in std_logic_vector (24 downto 0);
      RX_LL_MISO_slv : out std_logic_vector (1 downto 0);
      TX_LL_MOSI_slv : out std_logic_vector (35 downto 0);
      TX_LL_MISO_slv : in std_logic_vector (1 downto 0);
		ARESET : in std_logic;
		CLK : in std_logic);
	end component;   

begin

   RX_LL_MISO.AFULL <= RX_LL_MISO_slv(1);
   RX_LL_MISO.BUSY <= RX_LL_MISO_slv(0);
   
   RX_LL_MOSI_slv <= RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA & RX_LL_MOSI.DVAL & RX_LL_MOSI.SUPPORT_BUSY;
   
   
   TX_LL_MISO_slv <= TX_LL_MISO.AFULL & TX_LL_MISO.BUSY;
   
   TX_LL_MOSI.SOF <= TX_LL_MOSI_slv(35);
   TX_LL_MOSI.EOF <= TX_LL_MOSI_slv(34);
   TX_LL_MOSI.DATA <= TX_LL_MOSI_slv(33 downto 2);
   TX_LL_MOSI.DVAL <= TX_LL_MOSI_slv(1);
   TX_LL_MOSI.SUPPORT_BUSY <= TX_LL_MOSI_slv(0);   

   U1 : fi21tofp32_syn_unsigned
   port map(
      RX_LL_MOSI_slv => RX_LL_MOSI_slv,
      RX_LL_MISO_slv => RX_LL_MISO_slv,
      TX_LL_MOSI_slv => TX_LL_MOSI_slv,
      TX_LL_MISO_slv => TX_LL_MISO_slv,
      ARESET => ARESET,
      CLK => CLK
   );
   
end SYNPLIFY;