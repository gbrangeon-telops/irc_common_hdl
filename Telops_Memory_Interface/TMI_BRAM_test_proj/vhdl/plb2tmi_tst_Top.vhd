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
use IEEE.numeric_std.all;
---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity plb2tmi_tst_Top is
    Port ( CLK_I : in  STD_LOGIC;
           RST_I : in  STD_LOGIC;
           LED_1 : out  STD_LOGIC;
           LED_2 : out  STD_LOGIC);
end plb2tmi_tst_Top;

architecture Behavioral of plb2tmi_tst_Top is

-------------------------------------------------------------------
-- Generic constants definition:
-------------------------------------------------------------------
constant MEM_DLEN : integer:=32;
constant MEM_ALEN : integer:=8;
constant C_READ_LATENCY    : integer := 2;
constant C_BUSY_GENERATE   : boolean := TRUE;
constant C_BUSY_DURATION   : integer := 20;
-------------------------------------------------------------------

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
signal tmi_arst_dly   	: std_logic;
signal tmi_arst_Fedge  	: std_logic;
signal start_test_s   	: std_logic;
signal Dcm_locked_s     : std_logic;
signal test_done_s      : std_logic;
signal test_pass_s      : std_logic;

signal MemTester_add_s     : std_logic_vector(MEM_ALEN-1 downto 0);
signal MemTester_rnw_s     : std_logic;
signal MemTester_dval_s    : std_logic;
signal MemTester_busy_s    : std_logic;
signal MemTester_rd_data_s : std_logic_vector(MEM_DLEN-1 downto 0);
signal MemTester_rd_dval_s : std_logic;
signal MemTester_wr_data_s : std_logic_vector(MEM_DLEN-1 downto 0);
signal MemTester_idle_s    : std_logic;
signal MemTester_error_s   : std_logic;
signal MemTester_clk_s      : std_logic;
signal mem160Mhz_clk_s        : std_logic;

signal err_flag_s          : std_logic_vector(1 downto 0);
attribute keep : string;
attribute keep of err_flag_s : signal is "true";


begin

-- TMI memory runs at 160 MHz clock
tmi_clk_s         <= mem160Mhz_clk_s;
-- Memory tester runs at 100 MHz clock
MemTester_clk_s   <= sys_clk100MHz_s;

-- ARESET
tmi_arst_s        <= not(RST_I) or not(Dcm_locked_s);

 --------------------------------------
 -- Generate START_TEST puls signal 16 clock
 -- after the reset is cleared.
 --------------------------------------
 SRL16_inst : SRL16
-- The following generic declaration is only necessary if you wish to
-- change the initial contents of the SRL to anything other than all
-- zero's.
   generic map (
      INIT => X"0001")
   port map (
      Q => start_test_s,       -- SRL data output
      A0 => '1',     -- Select[0] input
      A1 => '1',     -- Select[1] input
      A2 => '1',     -- Select[2] input
      A3 => '1',     -- Select[3] input
      CLK => MemTester_clk_s,   -- Clock input
      D => tmi_arst_Fedge        -- SRL data input
   );


-- Negative Logic for LEDs
 LED_1 <= not(test_done_s);
 LED_2 <= not(test_pass_s);


-- Main DCM for system clocks
Inst_MainDCM: entity work.MainDCM
   PORT MAP(
	  	CLKIN_IN          => CLK_I,
	  	RST_IN            => '0',
	  	CLKFX_OUT         => mem160Mhz_clk_s,
		CLKIN_IBUFG_OUT   => open,
		CLK0_OUT          => sys_clk100MHz_s,
		LOCKED_OUT        => Dcm_locked_s
	);


--Detect reset Falling Edge to be used
-- for test start
process(MemTester_clk_s)
begin
   if rising_edge(MemTester_clk_s)then
      tmi_arst_dly <= tmi_arst_s;
   end if;
end process;
   tmi_arst_Fedge <= not(tmi_arst_s) and tmi_arst_dly;


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
      TMI_IN_ADD       => MemTester_add_s,
      TMI_IN_RNW       => MemTester_rnw_s,
      TMI_IN_DVAL      => MemTester_dval_s,
      TMI_IN_BUSY      => MemTester_busy_s,
      TMI_IN_RD_DATA   => MemTester_rd_data_s,
      TMI_IN_RD_DVAL   => MemTester_rd_dval_s,
      TMI_IN_WR_DATA   => MemTester_wr_data_s,
      TMI_IN_IDLE      => MemTester_idle_s,
      TMI_IN_ERROR     => MemTester_error_s,
      TMI_IN_CLK       => MemTester_clk_s,
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


u0_TMI_memtest: entity work.TMI_memtest
generic map(
      Random_Pattern    => FALSE,   -- Pseudo-random data pattern for self-test. Linear data is false.
      Random_dval       => FALSE, -- pseudo-random dval pattern
      random_dval_seed  => x"1", -- --Pseudo-random generator seed
      DLEN              => MEM_DLEN,
      ALEN              => MEM_ALEN)
   port map(
      --------------------------------
      -- Control port
      --------------------------------
      START_TEST  => start_test_s,        -- Needs a 0 to 1 transition to trigger another test. Can be tied to '1' to execute test once after reset.
      TEST_DONE   => test_done_s,
      TEST_PASS   => test_pass_s,
      ERR_FLAG    => err_flag_s,
      --------------------------------
      -- TMI Interface
      --------------------------------
      TMI_IDLE          => MemTester_idle_s,
      TMI_ERROR         => MemTester_error_s,
      TMI_RNW           => MemTester_rnw_s,
      TMI_ADD           => MemTester_add_s,
      TMI_DVAL          => MemTester_dval_s,
      TMI_BUSY          => MemTester_busy_s,
      TMI_RD_DATA       => MemTester_rd_data_s,
      TMI_RD_DVAL       => MemTester_rd_dval_s,
      TMI_WR_DATA       => MemTester_wr_data_s,

      --------------------------------
      -- Others IOs
      --------------------------------
      ARESET            => tmi_arst_s,
      CLK               => MemTester_clk_s
      );



end Behavioral;

