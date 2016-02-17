---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  Author: OBO, adapaté par ENO en 2010
--
--  File: ll_16_merge_32.vhd
--  Use:  Block for merging two 16 bit Localink Buses into a 32 bit LocalLink Bus
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity ll_16_merge_32 is
	port(
		CLK       : in  std_logic;
		RX0_MOSI  : in  t_ll_mosi;
		RX0_MISO  : out t_ll_miso;
		RX1_MOSI  : in  t_ll_mosi;
		RX1_MISO  : out t_ll_miso;
		TX_MOSI   : out t_ll_mosi32;
		TX_MISO   : in  t_ll_miso);
end ll_16_merge_32;

architecture rtl of ll_16_merge_32 is
	
begin
	
	-- miso mappings
	RX0_MISO.BUSY <= (RX0_MOSI.DVAL and not RX1_MOSI.DVAL) or TX_MISO.BUSY;
	RX1_MISO.BUSY <= (RX1_MOSI.DVAL and not RX0_MOSI.DVAL) or TX_MISO.BUSY;
	RX0_MISO.AFULL <= TX_MISO.AFULL;
	RX1_MISO.AFULL <= TX_MISO.AFULL;
	
	-- mosi mappings
	TX_MOSI.DVAL <= RX0_MOSI.DVAL and RX1_MOSI.DVAL;  -- both data must be valid
	TX_MOSI.SOF  <= RX0_MOSI.SOF;                     -- sync SOF/EOF to either path
	TX_MOSI.EOF  <= RX0_MOSI.EOF;
	
	-- data mapping
	TX_MOSI.DATA <= RX0_MOSI.DATA(15 downto 0) & RX1_MOSI.DATA(15 downto 0);
	TX_MOSI.DREM <= "11";
	
	-- broadcast/verify busy support
	TX_MOSI.SUPPORT_BUSY <= '1';   
	-- translate_off   
	assert (RX0_MOSI.SUPPORT_BUSY /= '0') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;
	assert (RX1_MOSI.SUPPORT_BUSY /= '0') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;
	-- translate_on
	
end rtl;
