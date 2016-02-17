-------------------------------------------------------------------------------
--
-- Title       : fi21tofp32
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This is a wrapper to generate an edif file named
--               fi21tofp32_syn_signed. This file will be called by a wrapper.
--               THIS FILE SHOULD BE COMPILED BY SYNPLIFY.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;       

entity fi21tofp32_syn_unsigned is
   port(           
      RX_LL_MOSI_slv : in std_logic_vector (24 downto 0);
      RX_LL_MISO_slv : out std_logic_vector (1 downto 0);
      
      TX_LL_MOSI_slv : out std_logic_vector (35 downto 0);
      TX_LL_MISO_slv : in std_logic_vector (1 downto 0);        
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC      
      );
end fi21tofp32_syn_unsigned;  

library Common_HDL;
use Common_HDL.Telops.all; 

architecture SYN of fi21tofp32_syn_unsigned is

	component fi21tofp32
	generic(    
      Support_TDM : boolean := FALSE;
      signed_fi   : boolean := FALSE
      );
	port(
		RX_LL_MOSI : in t_ll_mosi21;
		RX_LL_MISO : out t_ll_miso;
		TX_LL_MOSI : out t_ll_mosi32;
		TX_LL_MISO : in t_ll_miso;
		TDM_FLOW : in std_logic;
		ARESET : in std_logic;
		CLK : in std_logic);
	end component;
	
	signal RX_LL_MOSI : t_ll_mosi21;
	signal RX_LL_MISO : t_ll_miso;
	signal TX_LL_MOSI : t_ll_mosi32;
	signal TX_LL_MISO : t_ll_miso;	


begin

   TX_LL_MISO.AFULL <= TX_LL_MISO_slv(1);
   TX_LL_MISO.BUSY <= TX_LL_MISO_slv(0);
   
   TX_LL_MOSI_slv <= TX_LL_MOSI.SOF & TX_LL_MOSI.EOF & TX_LL_MOSI.DATA & TX_LL_MOSI.DVAL & TX_LL_MOSI.SUPPORT_BUSY;
   
   
   RX_LL_MISO_slv <= RX_LL_MISO.AFULL & RX_LL_MISO.BUSY;
   
   RX_LL_MOSI.SOF <= RX_LL_MOSI_slv(24);
   RX_LL_MOSI.EOF <= RX_LL_MOSI_slv(23);
   RX_LL_MOSI.DATA <= RX_LL_MOSI_slv(22 downto 2);
   RX_LL_MOSI.DVAL <= RX_LL_MOSI_slv(1);
   RX_LL_MOSI.SUPPORT_BUSY <= RX_LL_MOSI_slv(0); 
   
   U1 : fi21tofp32
   generic map(
      Support_TDM => FALSE,
      signed_fi => FALSE)
   port map(
      RX_LL_MOSI => RX_LL_MOSI,
      RX_LL_MISO => RX_LL_MISO,
      TX_LL_MOSI => TX_LL_MOSI,
      TX_LL_MISO => TX_LL_MISO,
      TDM_FLOW => '0',
      ARESET => ARESET,
      CLK => CLK
   );   
   
end SYN;
