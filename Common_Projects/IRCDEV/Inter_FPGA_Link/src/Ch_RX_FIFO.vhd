library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
library common_HDL;       
use common_HDL.Telops.all;

entity Ch_RX_FIFO is
	port(		
		CLK 		: in std_logic;
		SRESET 		: in std_logic;
		-- Write/RX side
		CH_RX_MOSI : in t_ll_mosi8;
		CH_RX_MISO : out t_ll_miso;
		WR_ERR		: out std_logic;
		PROG_FULL_THRESH : in std_logic_vector(3 downto 0);
		-- Read side
		AEMPTY : out std_logic; 
		RD_EN		: in std_logic;
		DOUT	: out std_logic_vector(9 downto 0);
		DVALID		: out std_logic		
		);
end Ch_RX_FIFO; 		

architecture Ch_RX_FIFO_arch of Ch_RX_FIFO is		

component ch_fifo_w10d16
	port (
	clk: IN std_logic;
	din: IN std_logic_VECTOR(9 downto 0);
	prog_full_thresh: IN std_logic_VECTOR(3 downto 0);
	rd_en: IN std_logic;
	rst: IN std_logic;
	wr_en: IN std_logic;
	almost_empty: OUT std_logic;
	dout: OUT std_logic_VECTOR(9 downto 0);
	empty: OUT std_logic;
	full: OUT std_logic;
	overflow: OUT std_logic;
	prog_full: OUT std_logic;
	valid: OUT std_logic);
end component;

signal  v10_din : std_logic_VECTOR(9 downto 0);
signal wr_en,
		full,
		prog_full,
		empty : std_logic;

begin

 v10_din <= CH_RX_MOSI.SOF & CH_RX_MOSI.EOF & CH_RX_MOSI.DATA;
 wr_en <= CH_RX_MOSI.DVAL and not full;

U0_chFifo: ch_fifo_w10d16
		port map (
			clk => CLK,
			din => v10_din,
			prog_full_thresh => PROG_FULL_THRESH,
			rd_en => RD_EN,
			rst => SRESET,
			wr_en => wr_en,
			almost_empty => AEMPTY,
			dout => DOUT,
			empty => open,
			full => full,
			overflow => WR_ERR,
			prog_full => prog_full,
			valid => DVALID);


 --DATA_PRESENT <= not empty;
 
 CH_RX_MISO.AFULL <= prog_full;
 CH_RX_MISO.BUSY  <= full or SRESET;
			
end Ch_RX_FIFO_arch;