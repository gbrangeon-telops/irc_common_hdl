---------------------------------------------------------------------------------------------------
--
-- Title       : ll_fp32_max_syn
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
---------------------------------------------------------------------------------------------------
--
-- Description : This is a wrapper for Synplicity Synplify. All ports are slv (no records).
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  

entity ll_fp32_max_syn is
   port(        
      RX_MOSI_slv : in std_logic_vector (35 downto 0);
      MAX      : out std_logic_vector(31 downto 0);
      NEW_MAX  : out std_logic;
      
      ARESET   : in std_logic;
      CLK      : in std_logic			 		 		 
      );
end ll_fp32_max_syn;     

library Common_HDL;
use Common_HDL.Telops.all; 

architecture SYN of ll_fp32_max_syn is    

	component ll_fp32_max
	port(
      RX_MOSI  : in  t_ll_mosi32;
      -- No MISO because never busy;
      
      MAX      : out std_logic_vector(31 downto 0);
      NEW_MAX  : out std_logic;
      
      ARESET   : in std_logic;
      CLK      : in std_logic);
	end component;
	
	signal RX_MOSI : t_ll_mosi32;	


begin
   
   RX_MOSI.SOF <= RX_MOSI_slv(35);
   RX_MOSI.EOF <= RX_MOSI_slv(34);
   RX_MOSI.DATA <= RX_MOSI_slv(33 downto 2);
   RX_MOSI.DVAL <= RX_MOSI_slv(1);
   RX_MOSI.SUPPORT_BUSY <= RX_MOSI_slv(0); 
   
   U1 : ll_fp32_max
   port map(
      RX_MOSI => RX_MOSI,
      MAX      => MAX,
      NEW_MAX  => NEW_MAX,
               
      ARESET   => ARESET,
      CLK      => CLK
   ); 
   
end SYN;
