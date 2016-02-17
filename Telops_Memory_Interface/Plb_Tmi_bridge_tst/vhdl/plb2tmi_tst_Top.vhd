----------------------------------------------------------------------------------
-- Company: 		Telops
-- Engineer: 		Khalid Bensadek
--
-- Create Date:    16:49:16 04/29/2010
-- Design Name:
-- Module Name:    plb2tmi_tst_Top - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:    Top entity to test the PLB to TMI bridge.
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity plb2tmi_tst_Top is
    Port ( CLK_I : in  STD_LOGIC;
           RST_I : in  STD_LOGIC;
           RS232_RX_I : in  STD_LOGIC;
           RS232_TX_O : out  STD_LOGIC);
end plb2tmi_tst_Top;

architecture Behavioral of plb2tmi_tst_Top is

-------------------------------------------------------------------
-- Generic constants definition:
-------------------------------------------------------------------
constant MEM_DLEN          : integer := 32;
constant MEM_ALEN          : integer := 8;
constant C_READ_LATENCY    : integer := 2;
constant C_BUSY_GENERATE   : boolean := True;
constant C_BUSY_DURATION   : integer := 20;

-------------------------------------------------------------------


component system
  port (
    fpga_0_RS232_RX_pin : in std_logic;
    fpga_0_RS232_TX_pin : out std_logic;
    fpga_0_LEDs_3Bit_pin : out std_logic_vector(0 to 2);
    fpga_0_UserLED_1Bit_pin : out std_logic_vector(0 to 0);
    fpga_0_PushButtons_2Bit_pin : in std_logic_vector(0 to 1);
    fpga_0_DIPSw_4Bit_pin : in std_logic_vector(0 to 3);
    sys_clk_pin : in std_logic;
    sys_rst_pin : in std_logic;
    TMI1_CLK : out std_logic;
    TMI1_WR_DATA : out std_logic_vector(31 downto 0);
    TMI1_RD_DVAL : in std_logic;
    TMI1_RD_DATA : in std_logic_vector(31 downto 0);
    TMI1_BUSY : in std_logic;
    TMI1_DVAL : out std_logic;
    TMI1_ADD : out std_logic_vector(7 downto 0);
    TMI1_RNW : out std_logic;
    TMI1_ERROR : in std_logic;
    TMI1_IDLE : in std_logic;
    sys_periph_reset_pin : out std_logic_vector(0 to 0);
    sys_clk_100MHz_pin : out std_logic;
    mem160Mhz_clk_s_pin : out std_logic
  );
end component;


signal tmi_idle_s   	: std_logic;
signal tmi_error_s  	: std_logic;
signal tmi_rnw_s    	: std_logic;
signal tmi_add_s    	: std_logic_vector(MEM_ALEN-1 downto 0);
signal tmi_dval_s   	: std_logic;
signal tmi_busy_s   	: std_logic;
signal tmi_rd_data_s	: std_logic_vector(MEM_DLEN-1 downto 0);
signal tmi_rd_dval_s	: std_logic;
signal tmi_wr_data_s	: std_logic_vector(MEM_DLEN-1 downto 0);
signal tmi_clk_s    	: std_logic;
signal sys_clk100MHz_s	: std_logic;
signal tmi_arst_s     	: std_logic;

signal PlbTmiBridge_add_s     : std_logic_vector(MEM_ALEN-1 downto 0);
signal PlbTmiBridge_rnw_s     : std_logic;
signal PlbTmiBridge_dval_s    : std_logic;
signal PlbTmiBridge_busy_s    : std_logic;
signal PlbTmiBridge_rd_data_s : std_logic_vector(MEM_DLEN-1 downto 0);
signal PlbTmiBridge_rd_dval_s : std_logic;
signal PlbTmiBridge_wr_data_s : std_logic_vector(MEM_DLEN-1 downto 0);
signal PlbTmiBridge_idle_s    : std_logic;
signal PlbTmiBridge_error_s   : std_logic;
signal PlbTmiBridge_clk_s     : std_logic;
signal PlbTmiBridge_tmi_clk_s : std_logic;
signal mem160Mhz_clk_s        : std_logic;

begin

-- mem clck = 160 MHz, client clk = 100 MHz.
tmi_clk_s            <= mem160Mhz_clk_s;

u0_tmi_bram: entity work.tmi_bram
	generic map(
		C_TMI_DLEN => MEM_DLEN,
		C_TMI_ALEN => MEM_ALEN,
		C_READ_LATENCY => C_READ_LATENCY,
		C_BUSY_GENERATE => C_BUSY_GENERATE,
		C_RANDOM_SEED  => x"1",
		C_BUSY_DURATION => C_BUSY_DURATION
		)
	port map(
		TMI_IDLE					=> tmi_idle_s,
		TMI_ERROR            => tmi_error_s,
		TMI_RNW              => tmi_rnw_s,
		TMI_ADD              => tmi_add_s,
		TMI_DVAL             => tmi_dval_s,
		TMI_BUSY             => tmi_busy_s,
		TMI_RD_DATA          => tmi_rd_data_s,
		TMI_RD_DVAL          => tmi_rd_dval_s,
		TMI_WR_DATA          => tmi_wr_data_s,
		TMI_CLK              => tmi_clk_s,
		ARESET		         => tmi_arst_s
	);

u0_tmi_afifo: entity work.TMI_aFifo
   generic map(
      DLEN  => MEM_DLEN,
      ALEN  => MEM_ALEN
      )
   port map(
      --------------------------------
      -- Client Interface (aka IN)
      --------------------------------
      TMI_IN_ADD       => PlbTmiBridge_add_s,
      TMI_IN_RNW       => PlbTmiBridge_rnw_s,
      TMI_IN_DVAL      => PlbTmiBridge_dval_s,
      TMI_IN_BUSY      => PlbTmiBridge_busy_s,
      TMI_IN_RD_DATA   => PlbTmiBridge_rd_data_s,
      TMI_IN_RD_DVAL   => PlbTmiBridge_rd_dval_s,
      TMI_IN_WR_DATA   => PlbTmiBridge_wr_data_s,
      TMI_IN_IDLE      => PlbTmiBridge_idle_s,
      TMI_IN_ERROR     => PlbTmiBridge_error_s,
      TMI_IN_CLK       => PlbTmiBridge_tmi_clk_s,
      --------------------------------
      -- Controller Interface (aka OUT)
      --------------------------------
      TMI_OUT_ADD       => tmi_add_s,
      TMI_OUT_RNW       => tmi_rnw_s,
      TMI_OUT_DVAL      => tmi_dval_s,
      TMI_OUT_BUSY      => tmi_busy_s,
      TMI_OUT_RD_DATA   => tmi_rd_data_s,
      TMI_OUT_RD_DVAL   => tmi_rd_dval_s,
      TMI_OUT_WR_DATA   => tmi_wr_data_s,
      TMI_OUT_IDLE      => tmi_idle_s,
      TMI_OUT_ERROR     => tmi_error_s,
      TMI_OUT_CLK       => tmi_clk_s,
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET      => tmi_arst_s
      );


u0_system: system
	port map(
		fpga_0_RS232_RX_pin			=> RS232_RX_I,
		fpga_0_RS232_TX_pin        => RS232_TX_O,
		fpga_0_LEDs_3Bit_pin		   => open,
		fpga_0_UserLED_1Bit_pin		=> open,
		fpga_0_PushButtons_2Bit_pin => (others =>'0'),
		fpga_0_DIPSw_4Bit_pin		=> (others =>'0'),
		sys_clk_pin					   => CLK_I,			-- CLK 100 MHZ board oscilator
		sys_rst_pin 		         => RST_I,			-- Push Button SW3
		TMI1_CLK 			         => PlbTmiBridge_tmi_clk_s,
		TMI1_WR_DATA 		         => PlbTmiBridge_wr_data_s,
		TMI1_RD_DVAL 		         => PlbTmiBridge_rd_dval_s,
		TMI1_RD_DATA 		         => PlbTmiBridge_rd_data_s,
		TMI1_BUSY 			         => PlbTmiBridge_busy_s,
		TMI1_DVAL 			         => PlbTmiBridge_dval_s,
		TMI1_ADD			            => PlbTmiBridge_add_s,
		TMI1_RNW 			         => PlbTmiBridge_rnw_s,
		TMI1_ERROR 			         => PlbTmiBridge_error_s,
		TMI1_IDLE 			         => PlbTmiBridge_idle_s,
		sys_periph_reset_pin(0)		=> tmi_arst_s, 	  -- Synchro active high system peripherals reset
		sys_clk_100MHz_pin			=> open, -- 100 MHz PLB system clk out
		mem160Mhz_clk_s_pin        => mem160Mhz_clk_s  -- 160 MHZ from system main DCM.
	);






end Behavioral;

