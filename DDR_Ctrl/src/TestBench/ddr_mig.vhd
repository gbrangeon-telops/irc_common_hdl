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
      SYS_CLK200_P   : in    std_logic;
      SYS_CLK200_N   : in    std_logic;

      -- DDR memory
      MEM_CK_P       : out   std_logic;
      MEM_CK_N       : out   std_logic;
      MEM_CKE        : out   std_logic_vector(1 downto 0);
      MEM_RST_N      : out   std_logic;
      MEM_CS_N       : out   std_logic_vector(1 downto 0);
      MEM_RAS_N      : out   std_logic;
      MEM_CAS_N      : out   std_logic;
      MEM_WE_N       : out   std_logic;
      MEM_BA         : out   std_logic_vector( 1 downto 0);
      MEM_ADD        : out   std_logic_vector(12 downto 0);
      MEM_DQS        : inout std_logic_vector(17 downto 0);
      MEM_DQ         : inout std_logic_vector(71 downto 0);
      MEM_SA         : out   std_logic_vector( 2 downto 0);
      MEM_SCL        : out   std_logic;
      MEM_SDA        : inout std_logic
   );
end ddr_mig;

architecture RTL of ddr_mig is

   constant USE_CHIPSCOPE  : boolean := not SIMULATION;

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
      wr1_addr    : out std_logic_vector( 26 downto 0);
      wr1_data    : out std_logic_vector(127 downto 0);
      -- Write 2
      wr2_afull   : in  std_logic;
      wr2_en      : out std_logic;
      wr2_addr    : out std_logic_vector( 26 downto 0);
      wr2_data    : out std_logic_vector(127 downto 0);
      -- Read 1
      rd1_afull   : in  std_logic;
      rd1_dval    : in  std_logic;
      rd1_data    : in  std_logic_vector(127 downto 0);
      rd1_data_en : out std_logic;
      rd1_addr_en : out std_logic;
      rd1_addr    : out std_logic_vector( 26 downto 0);
      -- Read 2
      rd2_afull   : in  std_logic;
      rd2_dval    : in  std_logic;
      rd2_data    : in  std_logic_vector(127 downto 0);
      rd2_data_en : out std_logic;
      rd2_addr_en : out std_logic;
      rd2_addr    : out std_logic_vector( 26 downto 0);
      -- Read 3
      rd3_afull   : in  std_logic;
      rd3_dval    : in  std_logic;
      rd3_data    : in  std_logic_vector(127 downto 0);
      rd3_data_en : out std_logic;
      rd3_addr_en : out std_logic;
      rd3_addr    : out std_logic_vector( 26 downto 0);
      -- Debug
      mem_init_cnt: out std_logic_vector( 26 downto 0);
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

   component ddr_wrapper_128d_27a_r1
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
      WR1_ADD        : in    std_logic_vector( 26 downto 0);
      WR1_DATA       : in    std_logic_vector(127 downto 0);
      WR1_AFULL      : out   std_logic;           
      --------------------------------
      -- Write Interface Signals #2
      --------------------------------
      WR2_EN         : in    std_logic;
      WR2_ADD        : in    std_logic_vector( 26 downto 0);
      WR2_DATA       : in    std_logic_vector(127 downto 0);
      WR2_AFULL      : out   std_logic;      
      --------------------------------
      -- Read Interface Signals #1
      --------------------------------
      RD1_ADD        : in    std_logic_vector( 26 downto 0);
      RD1_ADD_EN     : in    std_logic;
      RD1_DATA       : out   std_logic_vector(127 downto 0);
      RD1_DVAL       : out   std_logic;
      RD1_AFULL      : out   std_logic;
      RD1_DATA_EN    : in    std_logic;
      --------------------------------
      -- Read Interface Signals #2
      --------------------------------
      RD2_ADD        : in    std_logic_vector( 26 downto 0);
      RD2_ADD_EN     : in    std_logic;
      RD2_DATA       : out   std_logic_vector(127 downto 0);
      RD2_DVAL       : out   std_logic;
      RD2_AFULL      : out   std_logic;
      RD2_DATA_EN    : in    std_logic;
      --------------------------------
      -- Read Interface Signals #3
      --------------------------------
      RD3_ADD        : in    std_logic_vector( 26 downto 0);
      RD3_ADD_EN     : in    std_logic;
      RD3_DATA       : out   std_logic_vector(127 downto 0);
      RD3_DVAL       : out   std_logic;
      RD3_AFULL      : out   std_logic;
      RD3_DATA_EN    : in    std_logic;
      --------------------------------
      -- DDR DIMM Signals
      --------------------------------
      DDR_RESET_N    : out   std_logic;
      DDR_CK_P       : out   std_logic;
      DDR_CK_N       : out   std_logic;
      DDR_CKE        : out   std_logic_vector(  1 downto 0);
      DDR_CS_N       : out   std_logic_vector(  1 downto 0);
      DDR_RAS_N      : out   std_logic;
      DDR_CAS_N      : out   std_logic;
      DDR_WE_N       : out   std_logic;
      DDR_BA         : out   std_logic_vector(  1 downto 0);
      DDR_A          : out   std_logic_vector( 12 downto 0);
      DDR_DQS        : inout std_logic_vector( 17 downto 0);
      DDR_DQ         : inout std_logic_vector( 71 downto 0);
      DDR_SA         : out   std_logic_vector(  2 downto 0);
      DDR_SCL        : out   std_logic;
      DDR_SDA        : inout std_logic;
      --------------------------------
      -- MISC
      --------------------------------
      FIFO_ERR       : out   std_logic;
      DDRT_STAT      : out   std_logic_vector( 1 downto 0);
      MEM_INITDONE   : out   std_logic
   );
   end component;

   component icon
      port (
         control0    : out std_logic_vector(35 downto 0);
         control1    : out std_logic_vector(35 downto 0)
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
   signal sys_rst             : std_logic;
   signal sys_rstn            : std_logic;
   signal intf_test_rst       : std_logic;
   signal core_rst           : std_logic;
   signal fifo_err_out        : std_logic;
   
   -- Clock Generation
   signal sys_clk200          : std_logic;
   signal clk100              : std_logic;
   signal clk100_b            : std_logic;
   signal clk200              : std_logic;
   signal clk200_b            : std_logic;
   signal clk200_90           : std_logic;
   signal clk200_90_b         : std_logic;
   signal clk_locked          : std_logic;

   -- Memory interface
   signal mem_rd1_afull       : std_logic;
   signal mem_rd1_add_en      : std_logic;
   signal mem_rd1_data_en     : std_logic;
   signal mem_rd1_add         : std_logic_vector( 26 downto 0);
   signal mem_rd1_data        : std_logic_vector(127 downto 0);
   signal mem_rd1_dval        : std_logic;
   signal mem_rd2_afull       : std_logic;
   signal mem_rd2_add_en      : std_logic;
   signal mem_rd2_data_en     : std_logic;
   signal mem_rd2_add         : std_logic_vector( 26 downto 0);
   signal mem_rd2_data        : std_logic_vector(127 downto 0);
   signal mem_rd2_dval        : std_logic;
   signal mem_rd3_afull       : std_logic;
   signal mem_rd3_add_en      : std_logic;
   signal mem_rd3_data_en     : std_logic;
   signal mem_rd3_add         : std_logic_vector( 26 downto 0);
   signal mem_rd3_data        : std_logic_vector(127 downto 0);
   signal mem_rd3_dval        : std_logic;
   signal mem_wr1_en          : std_logic;
   signal mem_wr1_addr        : std_logic_vector( 26 downto 0);
   signal mem_wr1_data        : std_logic_vector(127 downto 0);
   signal mem_wr1_afull       : std_logic;
   signal mem_wr2_en          : std_logic;
   signal mem_wr2_addr        : std_logic_vector( 26 downto 0);
   signal mem_wr2_data        : std_logic_vector(127 downto 0);
   signal mem_wr2_afull       : std_logic;
   
   -- Debug
   signal ddr_stat_out        : std_logic_vector(  1 downto 0);
   signal mem_init_done       : std_logic;
   signal debug_mem_init_cnt  : std_logic_vector( 26 downto 0);
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
   
   -- Chipscope
   signal control_ila         : std_logic_vector( 35 downto 0);
   signal control_vio         : std_logic_vector( 35 downto 0);
   signal data_ila            : std_logic_vector(126 downto 0);
   signal trig_vio            : std_logic_vector(  7 downto 0);
   signal mem_cke_out         : std_logic_vector(  1 downto 0);
   signal mem_cs_out          : std_logic_vector(  3 downto 0);
   signal mem_ras_out         : std_logic;
   signal mem_cas_out         : std_logic;
   signal mem_we_out          : std_logic;
   signal mem_ba_out          : std_logic_vector(  2 downto 0);
   signal mem_add_out         : std_logic_vector( 15 downto 0);
   signal mem_dqs_out         : std_logic_vector( 17 downto 0);
   signal mem_dq_out          : std_logic_vector( 71 downto 0);

begin

------------------------------------------------------------
----                        Misc                        ----
------------------------------------------------------------
   sys_rstn       <= SYS_RST_N;
   sys_rst        <= not sys_rstn;

   process(sys_rst, clk100)
   begin
      if sys_rst = '1' then
         intf_test_rst  <= '1';
         core_rst       <= '1';
      elsif clk100'event and clk100 = '1' then
         intf_test_rst  <= ((not clk_locked) or trig_vio(0));
         core_rst      <= trig_vio(1);
      end if;
   end process;

------------------------------------------------------------
----                   Clock Resources                  ----
------------------------------------------------------------

   diff_clock: IBUFGDS
   generic map (
      IOSTANDARD => "DEFAULT"
   )
   port map (
      I  => SYS_CLK200_P,
      IB => SYS_CLK200_N,
      O  => sys_clk200
   );

   clk_gen : DCM_BASE
   generic map (
      CLKDV_DIVIDE            => 2.0,
      CLKFX_DIVIDE            => 1,
      CLKFX_MULTIPLY          => 2,
      CLKIN_DIVIDE_BY_2       => FALSE,
      CLKIN_PERIOD            => 5.0,
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
      RST      => sys_rst,
      CLKIN    => sys_clk200,
      CLKFB    => clk200,
      CLK0     => clk200_b,
      CLK90    => clk200_90_b,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => open,
      CLK2X180 => open,
      CLKDV    => clk100_b,
      CLKFX    => open,
      CLKFX180 => open,
      LOCKED   => clk_locked
   );

   clk100_bufg: BUFG
   port map (
      I  => clk100_b,
      O  => clk100
   );

   clk200_0_bufg: BUFG
   port map (
      I  => clk200_b,
      O  => clk200
   );

   clk200_90_bufg: BUFG
   port map (
      I  => clk200_90_b,
      O  => clk200_90
   );

------------------------------------------------------------
----                  Memory Controller                 ----
------------------------------------------------------------

   -- Memory interface feed for test purposes
   intf_data_gen: intf_acces_gen
   port map (
      rst         => intf_test_rst, -- sys_rst,
      clk         => clk100,
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

   ddr_wrap: ddr_wrapper_128d_27a_r1
   port map(
      --------------------------------
      -- Global clocks and resets
      --------------------------------
      USER_CLK       => clk100,
      MEM_CLK_0      => clk200,
      MEM_CLK_90     => clk200_90,
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
      DDR_RESET_N    => MEM_RST_N,
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
      DDR_SA         => MEM_SA,
      DDR_SCL        => MEM_SCL,
      DDR_SDA        => MEM_SDA,
      --------------------------------
      -- MISC
      --------------------------------
      FIFO_ERR       => fifo_err_out,
      DDRT_STAT      => ddr_stat_out,
      MEM_INITDONE   => mem_init_done
   );

------------------------------------------------------------
----                     Chipscope                      ----
------------------------------------------------------------
   chipscope: if USE_CHIPSCOPE generate
      i_icon : icon
      port map (
         control0    => control_ila,
         control1    => control_vio
      );
      
      i_ila : ila
      port map (
         control   => control_ila,
         clk       => clk100,
         trig0     => data_ila
      );
      
      i_vio : vio
      port map (
         control   => control_vio,
         clk       => clk100,
         sync_out  => trig_vio
      );

      process(sys_rst, clk100)
      begin
         if sys_rst = '1' then
            data_ila <= (others => '0');
         elsif clk100'event and clk100 = '1' then
            data_ila(126 downto 100)   <= debug_mem_init_cnt;
            data_ila( 99)              <= debug_FIFOclr_cnt;
            data_ila( 98)              <= debug_rst_memtest;
            data_ila( 97 downto  78)   <= debug_mem_tst_cnt;
            data_ila( 77)              <= debug_mem_tst_over;
            data_ila( 76 downto  73)   <= debug_cnt;
            data_ila( 72 downto  69)   <= debug_rd1cnt;
            data_ila( 68 downto  65)   <= debug_rd2cnt;
            data_ila( 64 downto  61)   <= debug_wr1cnt;
            data_ila( 60)              <= debug_rd1ok;
            data_ila( 59)              <= debug_rd2ok;
            data_ila( 58)              <= debug_count_hold;
            data_ila( 57)              <= debug_mem_tst;
            data_ila( 56)              <= fifo_err_out;
            data_ila( 55 downto  54)   <= ddr_stat_out;
            data_ila( 53)              <= mem_wr1_en;
            data_ila( 52)              <= mem_wr1_afull;
            data_ila( 51)              <= mem_wr2_en;
            data_ila( 50)              <= mem_wr2_afull;
            data_ila( 49)              <= mem_rd1_add_en;
            data_ila( 48)              <= mem_rd1_afull;
            data_ila( 47)              <= mem_rd1_data_en;
            data_ila( 46)              <= mem_rd1_dval;
            data_ila( 45)              <= mem_rd2_add_en;
            data_ila( 44)              <= mem_rd2_afull;
            data_ila( 43)              <= mem_rd2_data_en;
            data_ila( 42)              <= mem_rd2_dval;
            data_ila( 41)              <= mem_rd3_add_en;
            data_ila( 40)              <= mem_rd3_afull;
            data_ila( 39)              <= mem_rd3_data_en;
            data_ila( 38)              <= mem_rd3_dval;
            data_ila( 37 downto  22)   <= mem_rd1_data(15 downto 0);
            data_ila( 21 downto   6)   <= mem_rd2_data(15 downto 0);
            data_ila(  5)              <= SYS_RST_N;
            data_ila(  4)              <= intf_test_rst;  
            data_ila(  3)              <= core_rst;
            data_ila(  2)              <= mem_init_done;
            data_ila(  0)              <= clk_locked;
         end if;
      end process;
      
   end generate;

   no_chipscope: if not USE_CHIPSCOPE generate
      trig_vio <= (others => '0');
   end generate;

end RTL;
