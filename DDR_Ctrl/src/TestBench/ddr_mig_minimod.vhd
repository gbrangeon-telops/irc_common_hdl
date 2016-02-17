---------------------------------------------------------------------------------------------------
--
-- Title       : ddr_mig
-- Design      : ddr_mig
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : Test for MIG memory controller
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.all;

entity ddr_mig is
   generic(
      SIMULATION     : boolean := FALSE
   );
   port (
      -- System
      SYS_RST_N      : in    std_logic;
      SYS_CLK100     : in    std_logic;

      -- DDR memory
      MEM_CK_P       : out   std_logic;
      MEM_CK_N       : out   std_logic;
      MEM_CKE        : out   std_logic;
      MEM_CS_N       : out   std_logic;
      MEM_RAS_N      : out   std_logic;
      MEM_CAS_N      : out   std_logic;
      MEM_WE_N       : out   std_logic;
      MEM_BA         : out   std_logic_vector( 1 downto 0);
      MEM_ADD        : out   std_logic_vector(12 downto 0);
      MEM_DQS        : inout std_logic_vector( 1 downto 0);
      MEM_DQ         : inout std_logic_vector(15 downto 0);
      MEM_DM         : out   std_logic_vector( 1 downto 0)
   );
end ddr_mig;

architecture RTL of ddr_mig is

   constant USE_CHIPSCOPE  : boolean := TRUE;--not SIMULATION;

   component BUFG
   port (
      I  : in  std_logic;
      O  : out std_logic
   );
   end component;
   
   component OBUF
   port (
      I  : in  std_logic;
      O  : out std_logic
   );
   end component;
   
   component IBUFGDS
   generic (
      IOSTANDARD : string
   );
   port (
      I  : in  std_logic;
      IB : in  std_logic;
      O  : out std_logic
   );
   end component;

   component IBUFG
   generic (
      IOSTANDARD : string
   );
   port (
      I  : in  std_logic;
      O  : out std_logic
   );
   end component;

   component SRL16
   generic (
      INIT : BIT_VECTOR := X"0000"
   );
   port (
      Q   : out std_logic;
      A0  : in  std_logic;
      A1  : in  std_logic;
      A2  : in  std_logic;
      A3  : in  std_logic;
      CLK : in  std_logic;
      D   : in  std_logic
   );
   end component;

   component DCM_BASE
   generic (
      CLKDV_DIVIDE            : real := 2.0;
      CLKFX_DIVIDE            : integer := 1;
      CLKFX_MULTIPLY          : integer := 1;
      CLKIN_DIVIDE_BY_2       : boolean := FALSE;
      CLKIN_PERIOD            : real := 10.0;
      CLKOUT_PHASE_SHIFT      : string := "NONE";
      CLK_FEEDBACK            : string := "1X";
      DCM_AUTOCALIBRATION     : boolean := TRUE;
      DCM_PERFORMANCE_MODE    : string := "MAX_SPEED";
      DESKEW_ADJUST           : string := "SYSTEM_SYNCHRONOUS";
      DFS_FREQUENCY_MODE      : string := "LOW";
      DLL_FREQUENCY_MODE      : string := "LOW";
      DUTY_CYCLE_CORRECTION   : boolean := TRUE;
      FACTORY_JF              : bit_vector := X"F0F0";
      PHASE_SHIFT             : integer := 0;
      STARTUP_WAIT            : boolean := FALSE
   );
   port (
      RST      : in  std_ulogic;
      CLKIN    : in  std_ulogic;
      CLKFB    : in  std_ulogic;
      CLK0     : out std_ulogic;
      CLK90    : out std_ulogic;
      CLK180   : out std_ulogic;
      CLK270   : out std_ulogic;
      CLK2X    : out std_ulogic;
      CLK2X180 : out std_ulogic;
      CLKDV    : out std_ulogic;
      CLKFX    : out std_ulogic;
      CLKFX180 : out std_ulogic;
      LOCKED   : out std_ulogic
   );
   end component;

   component intf_acces_gen
   port (
      rst         : in  std_logic;
      clk         : in  std_logic;
      -- Write 1
      wr1_afull   : in  std_logic;
      wr1_en      : out std_logic;
      wr1_addr    : out std_logic_vector( 25 downto 0);
      wr1_data    : out std_logic_vector(127 downto 0);
      -- Write 2
      wr2_afull   : in  std_logic;
      wr2_en      : out std_logic;
      wr2_addr    : out std_logic_vector( 25 downto 0);
      wr2_data    : out std_logic_vector(127 downto 0);
      -- Read 1
      rd1_afull   : in  std_logic;
      rd1_dval    : in  std_logic;
      rd1_data    : in  std_logic_vector(127 downto 0);
      rd1_data_en : out std_logic;
      rd1_addr_en : out std_logic;
      rd1_addr    : out std_logic_vector( 25 downto 0);
      -- Read 2
      rd2_afull   : in  std_logic;
      rd2_dval    : in  std_logic;
      rd2_data    : in  std_logic_vector(127 downto 0);
      rd2_data_en : out std_logic;
      rd2_addr_en : out std_logic;
      rd2_addr    : out std_logic_vector( 25 downto 0);
      -- Read 3
      rd3_afull   : in  std_logic;
      rd3_dval    : in  std_logic;
      rd3_data    : in  std_logic_vector(127 downto 0);
      rd3_data_en : out std_logic;
      rd3_addr_en : out std_logic;
      rd3_addr    : out std_logic_vector( 25 downto 0);
      -- Debug
      mem_init_cnt: out std_logic_vector( 25 downto 0);
      mem_tst     : out std_logic;
      FIFOclr_cnt : out std_logic;
      rst_memtest : out std_logic;
      mem_tst_cnt : out std_logic_vector( 19 downto 0);
      mem_tst_over: out std_logic;
      cnt         : out std_logic_vector(  3 downto 0);
      rd1cnt      : out std_logic_vector(  3 downto 0);
      rd2cnt      : out std_logic_vector(  3 downto 0);
      wr1cnt      : out std_logic_vector(  3 downto 0);
      rd1ok       : out std_logic;
      rd2ok       : out std_logic;
      count_hold  : out std_logic
   );
   end component;

   component ddr_wrapper_128d_26a_r0
   port(
      --------------------------------
      -- Global clocks and resets
      --------------------------------
      USER_CLK       : in    std_logic;
      MEM_CLK_0      : in    std_logic;
      MEM_CLK_90     : in    std_logic;
      MEM_CLK_LOCKED : in    std_logic;
      CLK200         : in    std_logic;
      ARESET         : in    std_logic;
      CLEAR_FIFOS    : in    std_logic;
      --------------------------------
      -- Write Interface Signals #1
      --------------------------------
      WR1_EN         : in    std_logic;
      WR1_ADD        : in    std_logic_vector( 25 downto 0);
      WR1_DATA       : in    std_logic_vector(127 downto 0);
      WR1_AFULL      : out   std_logic;           
      --------------------------------
      -- Write Interface Signals #2
      --------------------------------
      WR2_EN         : in    std_logic;
      WR2_ADD        : in    std_logic_vector( 25 downto 0);
      WR2_DATA       : in    std_logic_vector(127 downto 0);
      WR2_AFULL      : out   std_logic;      
      --------------------------------
      -- Read Interface Signals #1
      --------------------------------
      RD1_ADD        : in    std_logic_vector( 25 downto 0);
      RD1_ADD_EN     : in    std_logic;
      RD1_DATA       : out   std_logic_vector(127 downto 0);
      RD1_DVAL       : out   std_logic;
      RD1_AFULL      : out   std_logic;
      RD1_DATA_EN    : in    std_logic;
      --------------------------------
      -- Read Interface Signals #2
      --------------------------------
      RD2_ADD        : in    std_logic_vector( 25 downto 0);
      RD2_ADD_EN     : in    std_logic;
      RD2_DATA       : out   std_logic_vector(127 downto 0);
      RD2_DVAL       : out   std_logic;
      RD2_AFULL      : out   std_logic;
      RD2_DATA_EN    : in    std_logic;
      --------------------------------
      -- Read Interface Signals #3
      --------------------------------
      RD3_ADD        : in    std_logic_vector( 25 downto 0);
      RD3_ADD_EN     : in    std_logic;
      RD3_DATA       : out   std_logic_vector(127 downto 0);
      RD3_DVAL       : out   std_logic;
      RD3_AFULL      : out   std_logic;
      RD3_DATA_EN    : in    std_logic;
      --------------------------------
      -- DDR DIMM Signals
      --------------------------------
      DDR_CK_P       : out   std_logic;
      DDR_CK_N       : out   std_logic;
      DDR_CKE        : out   std_logic;
      DDR_CS_N       : out   std_logic;
      DDR_RAS_N      : out   std_logic;
      DDR_CAS_N      : out   std_logic;
      DDR_WE_N       : out   std_logic;
      DDR_BA         : out   std_logic_vector(  1 downto 0);
      DDR_A          : out   std_logic_vector( 12 downto 0);
      DDR_DQS        : inout std_logic_vector(  1 downto 0);
      DDR_DQ         : inout std_logic_vector( 15 downto 0);
      DDR_DM         : out   std_logic_vector(  1 downto 0);
      --------------------------------
      -- MISC
      --------------------------------
      FIFO_ERR       : out   std_logic;
      DDRT_STAT      : out   std_logic_vector( 1 downto 0);
      MEM_INITDONE   : out   std_logic;
    rd_ok                                : in std_logic_vector(1 downto 0)
   );
   end component;

   component icon
      port (
         control0    : out std_logic_vector(35 downto 0)
--         control1    : out std_logic_vector(35 downto 0)
      );
   end component;

   component ila
      port (
         control     : in    std_logic_vector(35 downto 0);
         clk         : in    std_logic;
         trig0       : in    std_logic_vector(126 downto 0)
      );
   end component;

   component vio
      port (
         control     : in    std_logic_vector(35 downto 0);
         clk         : in    std_logic;
         sync_out    : out   std_logic_vector(7 downto 0)
      );
   end component;

   -- Misc
   signal sys_rst             : std_logic := '1';
   signal sys_rstn            : std_logic := '0';
   signal sys_rstn1           : std_logic := '0';
   signal intf_test_rst       : std_logic := '1';
   signal core_rst            : std_logic := '1';
   signal fifo_err_out        : std_logic;
   
   -- Clock Generation
   signal s_clk100            : std_logic;
   signal clk100              : std_logic;
   signal clk100_b            : std_logic;
--   signal clk133_i            : std_logic;
--   signal clk133_b1           : std_logic;
--   signal clk133              : std_logic;
--   signal clk133_b            : std_logic;
--   signal clk133_90           : std_logic;
--   signal clk133_90_b         : std_logic;
   signal clk200              : std_logic;
   signal clk200_b            : std_logic;
--   signal clk66               : std_logic;
--   signal clk66_b             : std_logic;
   signal clk166_i            : std_logic;
   signal clk166_b1           : std_logic;
   signal clk166              : std_logic;
   signal clk166_b            : std_logic;
   signal clk166_90           : std_logic;
   signal clk166_90_b         : std_logic;
   signal clk83               : std_logic;
   signal clk83_b             : std_logic;
   signal clk_locked_1        : std_logic;
   signal clk_locked_2        : std_logic;
   signal clk_locked_3        : std_logic;
   signal clk_locked_4        : std_logic;
   signal clk_locked_5        : std_logic;
   signal clk_locked_6        : std_logic;
   signal clk_locked_7        : std_logic;
   signal clk_locked_8        : std_logic;
   signal clk_locked_9        : std_logic;
   signal clk_locked_10       : std_logic;
   signal clk_locked_11       : std_logic;
   signal clk_locked_12       : std_logic;
   signal dcm_rst             : std_logic;
   signal clk_locked          : std_logic;

   -- Memory interface
   signal mem_rd1_afull       : std_logic;
   signal mem_rd1_add_en      : std_logic;
   signal mem_rd1_data_en     : std_logic;
   signal mem_rd1_add         : std_logic_vector( 25 downto 0);
   signal mem_rd1_data        : std_logic_vector(127 downto 0);
   signal mem_rd1_dval        : std_logic;
   signal mem_rd2_afull       : std_logic;
   signal mem_rd2_add_en      : std_logic;
   signal mem_rd2_data_en     : std_logic;
   signal mem_rd2_add         : std_logic_vector( 25 downto 0);
   signal mem_rd2_data        : std_logic_vector(127 downto 0);
   signal mem_rd2_dval        : std_logic;
   signal mem_rd3_afull       : std_logic;
   signal mem_rd3_add_en      : std_logic;
   signal mem_rd3_data_en     : std_logic;
   signal mem_rd3_add         : std_logic_vector( 25 downto 0);
   signal mem_rd3_data        : std_logic_vector(127 downto 0);
   signal mem_rd3_dval        : std_logic;
   signal mem_wr1_en          : std_logic;
   signal mem_wr1_addr        : std_logic_vector( 25 downto 0);
   signal mem_wr1_data        : std_logic_vector(127 downto 0);
   signal mem_wr1_afull       : std_logic;
   signal mem_wr2_en          : std_logic;
   signal mem_wr2_addr        : std_logic_vector( 25 downto 0);
   signal mem_wr2_data        : std_logic_vector(127 downto 0);
   signal mem_wr2_afull       : std_logic;
   
   -- Debug
   signal ddr_stat_out        : std_logic_vector(  1 downto 0);
   signal mem_init_done       : std_logic;
   signal debug_mem_init_cnt  : std_logic_vector( 25 downto 0);
   signal debug_mem_tst       : std_logic;
   signal debug_FIFOclr_cnt   : std_logic;
   signal debug_rst_memtest   : std_logic;
   signal debug_mem_tst_cnt   : std_logic_vector( 19 downto 0);
   signal debug_mem_tst_over  : std_logic;
   signal debug_cnt           : std_logic_vector(  3 downto 0);
   signal debug_rd1cnt        : std_logic_vector(  3 downto 0);
   signal debug_rd2cnt        : std_logic_vector(  3 downto 0);
   signal debug_wr1cnt        : std_logic_vector(  3 downto 0);
   signal debug_rd1ok         : std_logic;
   signal debug_rd2ok         : std_logic;
   signal debug_count_hold    : std_logic;
   signal rd_ok               : std_logic_vector(1 downto 0);
   
   -- Chipscope
   signal control_ila         : std_logic_vector( 35 downto 0);
   signal data_ila            : std_logic_vector(126 downto 0);

begin

------------------------------------------------------------
----                        Misc                        ----
------------------------------------------------------------
   rst_srl1: SRL16
   generic map (
      INIT => X"0000"
   )
   port map (
      Q   => sys_rstn1,
      A0  => '1',
      A1  => '1',
      A2  => '1',
      A3  => '1',
      CLK => s_clk100,
      D   => SYS_RST_N
   );

   process(s_clk100)
   begin
      if s_clk100'event and s_clk100 = '1' then
         sys_rstn <= sys_rstn1;
         sys_rst  <= not sys_rstn1;
      end if;
   end process;

   process(sys_rstn, s_clk100)
   begin
      if sys_rstn = '0' then
         intf_test_rst  <= '1';
         core_rst  <= '1';
      elsif s_clk100'event and s_clk100 = '1' then
         intf_test_rst  <= not clk_locked;
         core_rst       <= '0';
      end if;
   end process;

------------------------------------------------------------
----                   Clock Resources                  ----
------------------------------------------------------------

   diff_clock: IBUFG
   generic map (
      IOSTANDARD => "DEFAULT"
   )
   port map (
      I  => SYS_CLK100,
      O  => s_clk100
   );

--   clk_gen : DCM_BASE
--   generic map (
--      CLKDV_DIVIDE            => 2.0,
--      CLKFX_DIVIDE            => 3,
--      CLKFX_MULTIPLY          => 4,
--      CLKIN_DIVIDE_BY_2       => FALSE,
--      CLKIN_PERIOD            => 10.0,
--      CLKOUT_PHASE_SHIFT      => "NONE",
--      CLK_FEEDBACK            => "1X",
--      DCM_AUTOCALIBRATION     => TRUE,
--      DCM_PERFORMANCE_MODE    => "MAX_SPEED",
--      DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS",
--      DFS_FREQUENCY_MODE      => "LOW",
--      DLL_FREQUENCY_MODE      => "LOW",
--      DUTY_CYCLE_CORRECTION   => TRUE,
--      FACTORY_JF              => X"F0F0",
--      PHASE_SHIFT             => 0,
--      STARTUP_WAIT            => FALSE
--   )
--   port map (
--      RST      => sys_rst,
--      CLKIN    => s_clk100,
--      CLKFB    => clk100,
--      CLK0     => clk100_b,
--      CLK90    => open,
--      CLK180   => open,
--      CLK270   => open,
--      CLK2X    => clk200_b,
--      CLK2X180 => open,
--      CLKDV    => open,
--      CLKFX    => clk133_b1,
--      CLKFX180 => open,
--      LOCKED   => clk_locked_1
--   );
--   
--   clk100_b_bufg: BUFG
--   port map (
--      I  => clk100_b,
--      O  => clk100
--   );
--
--   clk200_b_bufg: BUFG
--   port map (
--      I  => clk200_b,
--      O  => clk200
--   );
--
--   clk133_b1_bufg: BUFG
--   port map (
--      I  => clk133_b1,
--      O  => clk133_i
--   );
--
--   process(clk_locked_1, clk100)
--   begin
--      if clk_locked_1 = '0' then
--         clk_locked_2  <= '0';
--         clk_locked_3  <= '0';
--         clk_locked_4  <= '0';
--         clk_locked_5  <= '0';
--         clk_locked_6  <= '0';
--         clk_locked_7  <= '0';
--         clk_locked_8  <= '0';
--         clk_locked_9  <= '0';
--         clk_locked_10 <= '0';
--         clk_locked_11 <= '0';
--         clk_locked_12 <= '0';
--         dcm_rst <= '1';
--      elsif clk100'event and clk100 = '1' then
--         clk_locked_2  <= clk_locked_1;
--         clk_locked_3  <= clk_locked_2;
--         clk_locked_4  <= clk_locked_3;
--         clk_locked_5  <= clk_locked_4;
--         clk_locked_6  <= clk_locked_5;
--         clk_locked_7  <= clk_locked_6;
--         clk_locked_8  <= clk_locked_7;
--         clk_locked_9  <= clk_locked_8;
--         clk_locked_10 <= clk_locked_9;
--         clk_locked_11 <= clk_locked_10;
--         clk_locked_12 <= clk_locked_11;
--         dcm_rst       <= not clk_locked_12;
--      end if;
--   end process;
--
--   clk_gen2 : DCM_BASE
--   generic map (
--      CLKDV_DIVIDE            => 2.0,
--      CLKFX_DIVIDE            => 1,
--      CLKFX_MULTIPLY          => 2,
--      CLKIN_DIVIDE_BY_2       => FALSE,
--      CLKIN_PERIOD            => 7.5,
--      CLKOUT_PHASE_SHIFT      => "NONE",
--      CLK_FEEDBACK            => "1X",
--      DCM_AUTOCALIBRATION     => TRUE,
--      DCM_PERFORMANCE_MODE    => "MAX_SPEED",
--      DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS",
--      DFS_FREQUENCY_MODE      => "LOW",
--      DLL_FREQUENCY_MODE      => "LOW",
--      DUTY_CYCLE_CORRECTION   => TRUE,
--      FACTORY_JF              => X"F0F0",
--      PHASE_SHIFT             => 0,
--      STARTUP_WAIT            => FALSE
--   )
--   port map (
--      RST      => dcm_rst,
--      CLKIN    => clk133_i,
--      CLKFB    => clk133,
--      CLK0     => clk133_b,
--      CLK90    => clk133_90_b,
--      CLK180   => open,
--      CLK270   => open,
--      CLK2X    => open,
--      CLK2X180 => open,
--      CLKDV    => clk66_b,
--      CLKFX    => open,
--      CLKFX180 => open,
--      LOCKED   => clk_locked
--   );
--
--   clk133_0_bufg: BUFG
--   port map (
--      I  => clk133_b,
--      O  => clk133
--   );
--
--   clk133_90_bufg: BUFG
--   port map (
--      I  => clk133_90_b,
--      O  => clk133_90
--   );
--
--   clk66_bufg: BUFG
--   port map (
--      I  => clk66_b,
--      O  => clk66
--   );

   clk_gen : DCM_BASE
   generic map (
      CLKDV_DIVIDE            => 2.0,
      CLKFX_DIVIDE            => 3,
      CLKFX_MULTIPLY          => 5,
      CLKIN_DIVIDE_BY_2       => FALSE,
      CLKIN_PERIOD            => 10.0,
      CLKOUT_PHASE_SHIFT      => "NONE",
      CLK_FEEDBACK            => "1X",
      DCM_AUTOCALIBRATION     => TRUE,
      DCM_PERFORMANCE_MODE    => "MAX_SPEED",
      DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS",
      DFS_FREQUENCY_MODE      => "LOW",
      DLL_FREQUENCY_MODE      => "LOW",
      DUTY_CYCLE_CORRECTION   => TRUE,
      FACTORY_JF              => X"F0F0",
      PHASE_SHIFT             => 0,
      STARTUP_WAIT            => FALSE
   )
   port map (
      RST      => sys_rst,
      CLKIN    => s_clk100,
      CLKFB    => clk100,
      CLK0     => clk100_b,
      CLK90    => open,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => clk200_b,
      CLK2X180 => open,
      CLKDV    => open,
      CLKFX    => clk166_b1,
      CLKFX180 => open,
      LOCKED   => clk_locked_1
   );
   
   clk100_b_bufg: BUFG
   port map (
      I  => clk100_b,
      O  => clk100
   );

   clk200_b_bufg: BUFG
   port map (
      I  => clk200_b,
      O  => clk200
   );

   clk133_b1_bufg: BUFG
   port map (
      I  => clk166_b1,
      O  => clk166_i
   );

   process(clk_locked_1, clk100)
   begin
      if clk_locked_1 = '0' then
         clk_locked_2  <= '0';
         clk_locked_3  <= '0';
         clk_locked_4  <= '0';
         clk_locked_5  <= '0';
         clk_locked_6  <= '0';
         clk_locked_7  <= '0';
         clk_locked_8  <= '0';
         clk_locked_9  <= '0';
         clk_locked_10 <= '0';
         clk_locked_11 <= '0';
         clk_locked_12 <= '0';
         dcm_rst <= '1';
      elsif clk100'event and clk100 = '1' then
         clk_locked_2  <= clk_locked_1;
         clk_locked_3  <= clk_locked_2;
         clk_locked_4  <= clk_locked_3;
         clk_locked_5  <= clk_locked_4;
         clk_locked_6  <= clk_locked_5;
         clk_locked_7  <= clk_locked_6;
         clk_locked_8  <= clk_locked_7;
         clk_locked_9  <= clk_locked_8;
         clk_locked_10 <= clk_locked_9;
         clk_locked_11 <= clk_locked_10;
         clk_locked_12 <= clk_locked_11;
         dcm_rst       <= not clk_locked_12;
      end if;
   end process;

   clk_gen2 : DCM_BASE
   generic map (
      CLKDV_DIVIDE            => 2.0,
      CLKFX_DIVIDE            => 1,
      CLKFX_MULTIPLY          => 2,
      CLKIN_DIVIDE_BY_2       => FALSE,
      CLKIN_PERIOD            => 6.0,
      CLKOUT_PHASE_SHIFT      => "NONE",
      CLK_FEEDBACK            => "1X",
      DCM_AUTOCALIBRATION     => TRUE,
      DCM_PERFORMANCE_MODE    => "MAX_SPEED",
      DESKEW_ADJUST           => "SYSTEM_SYNCHRONOUS",
      DFS_FREQUENCY_MODE      => "HIGH",
      DLL_FREQUENCY_MODE      => "HIGH",
      DUTY_CYCLE_CORRECTION   => TRUE,
      FACTORY_JF              => X"F0F0",
      PHASE_SHIFT             => 0,
      STARTUP_WAIT            => FALSE
   )
   port map (
      RST      => dcm_rst,
      CLKIN    => clk166_i,
      CLKFB    => clk166,
      CLK0     => clk166_b,
      CLK90    => clk166_90_b,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => open,
      CLK2X180 => open,
      CLKDV    => clk83_b,
      CLKFX    => open,
      CLKFX180 => open,
      LOCKED   => clk_locked
   );

   clk133_0_bufg: BUFG
   port map (
      I  => clk166_b,
      O  => clk166
   );

   clk133_90_bufg: BUFG
   port map (
      I  => clk166_90_b,
      O  => clk166_90
   );

   clk66_bufg: BUFG
   port map (
      I  => clk83_b,
      O  => clk83
   );

------------------------------------------------------------
----                  Memory Controller                 ----
------------------------------------------------------------

   -- Memory interface feed for test purposes
   intf_data_gen: intf_acces_gen
   port map (
      rst         => intf_test_rst,
      clk         => clk83,--clk66,
      -- Write 1
      wr1_afull   => mem_wr1_afull,
      wr1_en      => mem_wr1_en,
      wr1_addr    => mem_wr1_addr,
      wr1_data    => mem_wr1_data,
      -- Write 2
      wr2_afull   => mem_wr2_afull,
      wr2_en      => mem_wr2_en,
      wr2_addr    => mem_wr2_addr,
      wr2_data    => mem_wr2_data,
      -- Read 1
      rd1_afull   => mem_rd1_afull,
      rd1_dval    => mem_rd1_dval,
      rd1_data    => mem_rd1_data,
      rd1_data_en => mem_rd1_data_en,
      rd1_addr_en => mem_rd1_add_en,
      rd1_addr    => mem_rd1_add,
      -- Read 2
      rd2_afull   => mem_rd2_afull,
      rd2_dval    => mem_rd2_dval,
      rd2_data    => mem_rd2_data,
      rd2_data_en => mem_rd2_data_en,
      rd2_addr_en => mem_rd2_add_en,
      rd2_addr    => mem_rd2_add,
      -- Read 3
      rd3_afull   => mem_rd3_afull,
      rd3_dval    => mem_rd3_dval,
      rd3_data    => mem_rd3_data,
      rd3_data_en => mem_rd3_data_en,
      rd3_addr_en => mem_rd3_add_en,
      rd3_addr    => mem_rd3_add,
      -- Debug
      mem_init_cnt=> debug_mem_init_cnt,
      mem_tst     => debug_mem_tst,
      FIFOclr_cnt => debug_FIFOclr_cnt,
      rst_memtest => debug_rst_memtest,
      mem_tst_cnt => debug_mem_tst_cnt,
      mem_tst_over=> debug_mem_tst_over,
      cnt         => debug_cnt,
      rd1cnt      => debug_rd1cnt,
      rd2cnt      => debug_rd2cnt,
      wr1cnt      => debug_wr1cnt,
      rd1ok       => debug_rd1ok,
      rd2ok       => debug_rd2ok,
      count_hold  => debug_count_hold
   );

   ddr_wrap: ddr_wrapper_128d_26a_r0
   port map(
      --------------------------------
      -- Global clocks and resets
      --------------------------------
      USER_CLK       => clk83,--clk66,
      MEM_CLK_0      => clk166,--clk133,
      MEM_CLK_90     => clk166_90,--clk133_90,
      MEM_CLK_LOCKED => clk_locked,
      CLK200         => clk200,
      ARESET         => core_rst,
      CLEAR_FIFOS    => '0',
      --------------------------------
      -- Write Interface Signals #1
      --------------------------------
      WR1_EN         => mem_wr1_en,
      WR1_ADD        => mem_wr1_addr,
      WR1_DATA       => mem_wr1_data,
      WR1_AFULL      => mem_wr1_afull,
      --------------------------------
      -- Write Interface Signals #2
      --------------------------------
      WR2_EN         => mem_wr2_en,
      WR2_ADD        => mem_wr2_addr,
      WR2_DATA       => mem_wr2_data,
      WR2_AFULL      => mem_wr2_afull,
      --------------------------------
      -- Read Interface Signals #1
      --------------------------------
      RD1_ADD        => mem_rd1_add,
      RD1_ADD_EN     => mem_rd1_add_en,
      RD1_DATA       => mem_rd1_data,
      RD1_DVAL       => mem_rd1_dval,
      RD1_AFULL      => mem_rd1_afull,
      RD1_DATA_EN    => mem_rd1_data_en,
      --------------------------------
      -- Read Interface Signals #2
      --------------------------------
      RD2_ADD        => mem_rd2_add,
      RD2_ADD_EN     => mem_rd2_add_en,
      RD2_DATA       => mem_rd2_data,
      RD2_DVAL       => mem_rd2_dval,
      RD2_AFULL      => mem_rd2_afull,
      RD2_DATA_EN    => mem_rd2_data_en,
      --------------------------------
      -- Read Interface Signals #3
      --------------------------------
      RD3_ADD        => mem_rd3_add,
      RD3_ADD_EN     => mem_rd3_add_en,
      RD3_DATA       => mem_rd3_data,
      RD3_DVAL       => mem_rd3_dval,
      RD3_AFULL      => mem_rd3_afull,
      RD3_DATA_EN    => mem_rd3_data_en,
      --------------------------------
      -- DDR DIMM Signals
      --------------------------------
      DDR_CK_P       => MEM_CK_P,
      DDR_CK_N       => MEM_CK_N,
      DDR_CKE        => MEM_CKE,
      DDR_CS_N       => MEM_CS_N,
      DDR_RAS_N      => MEM_RAS_N,
      DDR_CAS_N      => MEM_CAS_N,
      DDR_WE_N       => MEM_WE_N,
      DDR_BA         => MEM_BA,
      DDR_A          => MEM_ADD,
      DDR_DQS        => MEM_DQS,
      DDR_DQ         => MEM_DQ,
      DDR_DM         => MEM_DM,
      --------------------------------
      -- MISC
      --------------------------------
      FIFO_ERR       => fifo_err_out,
      DDRT_STAT      => ddr_stat_out,
      MEM_INITDONE   => mem_init_done,
      rd_ok          => rd_ok
   );                        
   rd_ok <= debug_rd1ok & debug_rd2ok;

------------------------------------------------------------
----                     Chipscope                      ----
------------------------------------------------------------
   chipscope: if USE_CHIPSCOPE generate
      i_icon : icon
      port map (
         control0    => control_ila
      );
      
      i_ila : ila
      port map (
         control   => control_ila,
         clk       => clk83,
         trig0     => data_ila
      );
      
--      process(sys_rst, clk66)
      process(sys_rst, clk83)
      begin
         if sys_rst = '1' then
            data_ila <= (others => '0');
--         elsif clk66'event and clk66 = '1' then
         elsif clk83'event and clk83 = '1' then
            data_ila(126 downto 111)   <= debug_mem_init_cnt(15 downto 0);
            data_ila(110 downto  94)   <= debug_mem_tst_cnt(16 downto 0);
            data_ila( 93)              <= debug_mem_tst_over;
            data_ila( 92)              <= debug_rd1ok;
            data_ila( 91)              <= debug_rd2ok;
            data_ila( 90)              <= debug_count_hold;
            data_ila( 89)              <= debug_mem_tst;
            data_ila( 88)              <= mem_wr1_en;
            data_ila( 87)              <= mem_wr1_afull;
            data_ila( 86)              <= mem_wr2_en;
            data_ila( 85)              <= mem_wr2_afull;
            data_ila( 84)              <= mem_rd1_add_en;
            data_ila( 83)              <= mem_rd1_afull;
            data_ila( 82)              <= mem_rd1_dval;
            data_ila( 81)              <= mem_rd2_add_en;
            data_ila( 80)              <= mem_rd2_afull;
            data_ila( 79)              <= mem_rd2_dval;
            data_ila( 78 downto 53)    <= mem_wr1_addr;
            data_ila( 52 downto 34)    <= mem_rd1_add(18 downto 0);
            data_ila( 33 downto 18)    <= mem_rd1_data(15 downto 0);
--            data_ila( 17 downto   2)   <= mem_rd2_data(15 downto 0);
--            data_ila( 33 downto  2)    <= mem_rd1_data(31 downto 0);
            data_ila( 17 downto  2)    <= mem_wr1_data(15 downto 0);
            data_ila(  1)              <= mem_init_done;
            data_ila(  0)              <= clk_locked;
         end if;
      end process;
      
   end generate;

end RTL;
