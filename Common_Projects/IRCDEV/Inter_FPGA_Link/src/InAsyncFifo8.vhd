-------------------------------------------------------------------------------
--
-- Title       : InAsyncFifo8
-- Design      : Inter_FPGA_Link
-- Author      : Telops
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00229\Active-HDL\Inter_FPGA_Link\Inter_FPGA_Link\src\InAsyncFifo8.vhd
-- Generated   : Wed Dec 23 14:39:47 2009
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {InAsyncFifo8} architecture {InAsyncFifo8}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library common_hdl;
use common_hdl.telops.all;



entity InAsyncFifo8 is
	 port(
		 TX_MOSI : in t_ll_mosi8;
		 CLK : in STD_LOGIC;
		 ARESET : in STD_LOGIC;
		 CLK_20MHz : in STD_LOGIC;
		 FIFO_RD : in STD_LOGIC;
		 TX_MISO : out t_ll_miso;
		 DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0);
		 DATA_PRESENT : out STD_LOGIC
	     );
end InAsyncFifo8;

--}} End of automatically maintained section

architecture InAsyncFifo8 of InAsyncFifo8 is

component fifo_async_w8_d16 
	port (
	din: IN std_logic_VECTOR(7 downto 0);
	rd_clk: IN std_logic;
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_clk: IN std_logic;
	wr_en: IN std_logic;	
	almost_full: OUT std_logic;
	dout: OUT std_logic_VECTOR(7 downto 0);
	empty: OUT std_logic;
	full: OUT std_logic;
	overflow: OUT std_logic);
end component;	

 signal wr_err_sig,
 		empty_sig,
		 sreset_sig
		 			: std_logic;

begin
	
	-- tmp assign.
	sreset_sig <= ARESET;
	
	-- enter your statements here --
			
	DATA_PRESENT	<= not empty_sig; 
	
--	-- Sync Reset
--	sync_RESET_TX :  sync_reset
--    port map(
--	ARESET 	=> ARESET,
--	SRESET 	=> sreset_sig,
--	CLK 	=> CLK
--	); 
   
	U0_Fifo8: fifo_async_w8_d16 
	port map(
		din				=> TX_MOSI.DATA,
		rd_clk			=> CLK_20MHz,
		rd_en			=> FIFO_RD,
		rst				=> ARESET,
		wr_clk			=> CLK,
		wr_en			=> TX_MOSI.DVAL,		
		almost_full		=> TX_MISO.AFULL,
		dout			=> DATA_OUT,
		empty			=> empty_sig,
		full			=> TX_MISO.BUSY,
		overflow		=> wr_err_sig
	);
	

end InAsyncFifo8;
