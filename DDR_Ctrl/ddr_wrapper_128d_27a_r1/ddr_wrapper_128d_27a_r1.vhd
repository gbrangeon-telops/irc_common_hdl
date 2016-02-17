-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : ddr_wrapper_128d_27a_r1
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : ddr_wrapper_128d_27a_r1.vhd
-- Generated   : Wed May 23 17:53:36 2007
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
library Common_HDL;
use Common_HDL.all;
use Common_HDL.Telops.all;

entity ddr_wrapper_128d_27a_r1 is
   port(
      --------------------------------
      -- Global clocks and resets
      --------------------------------
      USER_CLK       : in    std_logic;
      MEM_CLK_0      : in    std_logic;
      MEM_CLK_90     : in    std_logic;
      CLK200         : in    std_logic;
      ARESET         : in    std_logic;
      CLEAR_FIFOS    : in    std_logic;
      --------------------------------
      -- Wishbone
      --------------------------------
      WB_MOSI        : in t_wb_mosi;
      WB_MISO        : out t_wb_miso;		 
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
      IDLE           : out   std_logic;
      DDRT_TRIG      : in    std_logic;
      DDRT_STAT      : out   std_logic_vector(1 downto 0);
      FIFO_ERR       : out   std_logic;
      MEM_INITDONE   : out   std_logic
      );
end ddr_wrapper_128d_27a_r1;

architecture STRUCTURE of ddr_wrapper_128d_27a_r1 is
   
   constant USER_DATA_WIDTH   : integer := 128;
   constant USER_ADDR_WIDTH   : integer := 27;
   constant REGISTERED_DIMM   : std_logic := '1';
   
   signal DDR_CS_N_i       : std_logic_vector(3 downto 0);          
   signal DDR_BA_i         : std_logic_vector(2 downto 0);          
   signal DDR_A_i          : std_logic_vector(15 downto 0);          
   
   component ddr_top is
      generic(
         USER_DATA_WIDTH: integer range 128 to 144 := 144; -- 128 or 144
         USER_ADDR_WIDTH: integer range 25 to 27 := 27;
         CMD_TO_CMD_DLY : std_logic_vector(5 downto 0) := "100000";
         CONSECUTIVE_CMD: std_logic_vector(4 downto 0) := "01111"; -- < WF_AFULL_CNT et < RF_AFULL_CNT
         WF_AFULL_CNT   : std_logic_vector(4 downto 0) := "11000";
         RF_AFULL_CNT   : std_logic_vector(4 downto 0) := "11010";
         REGISTERED_DIMM: std_logic := '1'
         );
      port(
         --------------------------------
         -- Global clocks and resets
         --------------------------------
         USER_CLK       : in    std_logic;
         MEM_CLK_0      : in    std_logic;
         MEM_CLK_90     : in    std_logic;
         CLK200         : in    std_logic;
         ARESET         : in    std_logic;
         CLEAR_FIFOS    : in    std_logic;
         --------------------------------
         -- Wishbone
         --------------------------------
         WB_MOSI        : in t_wb_mosi;
         WB_MISO        : out t_wb_miso;		 
         --------------------------------
         -- Write Interface Signals #1
         --------------------------------
         WR1_EN         : in    std_logic;
         WR1_ADD        : in    std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
         WR1_DATA       : in    std_logic_vector(USER_DATA_WIDTH-1 downto 0);
         WR1_AFULL      : out   std_logic;           
         --------------------------------
         -- Write Interface Signals #2
         --------------------------------
         WR2_EN         : in    std_logic;
         WR2_ADD        : in    std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
         WR2_DATA       : in    std_logic_vector(USER_DATA_WIDTH-1 downto 0);
         WR2_AFULL      : out   std_logic;      
         --------------------------------
         -- Read Interface Signals #1
         --------------------------------
         RD1_ADD        : in    std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
         RD1_ADD_EN     : in    std_logic;
         RD1_DATA       : out   std_logic_vector(USER_DATA_WIDTH-1 downto 0);
         RD1_DVAL       : out   std_logic;
         RD1_AFULL      : out   std_logic;
         RD1_DATA_EN    : in    std_logic;
         --------------------------------
         -- Read Interface Signals #2
         --------------------------------
         RD2_ADD        : in    std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
         RD2_ADD_EN     : in    std_logic;
         RD2_DATA       : out   std_logic_vector(USER_DATA_WIDTH-1 downto 0);
         RD2_DVAL       : out   std_logic;
         RD2_AFULL      : out   std_logic;
         RD2_DATA_EN    : in    std_logic;
         --------------------------------
         -- Read Interface Signals #3
         --------------------------------
         RD3_ADD        : in    std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
         RD3_ADD_EN     : in    std_logic;
         RD3_DATA       : out   std_logic_vector(USER_DATA_WIDTH-1 downto 0);
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
         DDR_CS_N       : out   std_logic_vector(  3 downto 0);
         DDR_RAS_N      : out   std_logic;
         DDR_CAS_N      : out   std_logic;
         DDR_WE_N       : out   std_logic;
         DDR_BA         : out   std_logic_vector(  2 downto 0);
         DDR_A          : out   std_logic_vector( 15 downto 0);
         DDR_DQS        : inout std_logic_vector( 17 downto 0);
         DDR_DQ         : inout std_logic_vector( 71 downto 0);
         DDR_SA         : out   std_logic_vector(  2 downto 0);
         DDR_SCL        : out   std_logic;
         DDR_SDA        : inout std_logic;
         --------------------------------
         -- MISC
         --------------------------------    
         DDRT_TRIG      : in    std_logic;  
         IDLE           : out   std_logic;
         DDRT_STAT      : out   std_logic_vector(1 downto 0);
         FIFO_ERR       : out   std_logic;
         MEM_INITDONE   : out   std_logic);
   end component;
   
begin
   
   DDR_CS_N   <= DDR_CS_N_i(1 downto 0);
   DDR_BA     <= DDR_BA_i(1 downto 0)  ;
   DDR_A      <= DDR_A_i(12 downto 0)  ;
   
   ddr: ddr_top
   generic map(
      USER_DATA_WIDTH=> USER_DATA_WIDTH,
      USER_ADDR_WIDTH=> USER_ADDR_WIDTH,
      REGISTERED_DIMM=> REGISTERED_DIMM
      )
   port map(
      --------------------------------
      -- Global clocks and resets
      --------------------------------
      USER_CLK       => USER_CLK,
      MEM_CLK_0      => MEM_CLK_0,
      MEM_CLK_90     => MEM_CLK_90,
      CLK200         => CLK200,
      ARESET         => ARESET,
      CLEAR_FIFOS    => CLEAR_FIFOS,
      --------------------------------
      -- Wishbone
      --------------------------------
      WB_MOSI        => WB_MOSI,
      WB_MISO        => WB_MISO,
      --------------------------------
      -- Write Interface Signals #1
      --------------------------------
      WR1_EN         => WR1_EN,
      WR1_ADD        => WR1_ADD,
      WR1_DATA       => WR1_DATA,
      WR1_AFULL      => WR1_AFULL,
      --------------------------------
      -- Write Interface Signals #2
      --------------------------------
      WR2_EN         => WR2_EN,
      WR2_ADD        => WR2_ADD,
      WR2_DATA       => WR2_DATA,
      WR2_AFULL      => WR2_AFULL,
      --------------------------------
      -- Read Interface Signals #1
      --------------------------------
      RD1_ADD        => RD1_ADD,
      RD1_ADD_EN     => RD1_ADD_EN,
      RD1_DATA       => RD1_DATA,
      RD1_DVAL       => RD1_DVAL,
      RD1_AFULL      => RD1_AFULL,
      RD1_DATA_EN    => RD1_DATA_EN,
      --------------------------------
      -- Read Interface Signals #2
      --------------------------------
      RD2_ADD        => RD2_ADD,
      RD2_ADD_EN     => RD2_ADD_EN,
      RD2_DATA       => RD2_DATA,
      RD2_DVAL       => RD2_DVAL,
      RD2_AFULL      => RD2_AFULL,
      RD2_DATA_EN    => RD2_DATA_EN,
      --------------------------------
      -- Read Interface Signals #3
      --------------------------------
      RD3_ADD        => RD3_ADD,
      RD3_ADD_EN     => RD3_ADD_EN,
      RD3_DATA       => RD3_DATA,
      RD3_DVAL       => RD3_DVAL,
      RD3_AFULL      => RD3_AFULL,
      RD3_DATA_EN    => RD3_DATA_EN,
      --------------------------------
      -- DDR DIMM Signals
      --------------------------------
      DDR_RESET_N    => DDR_RESET_N,
      DDR_CK_P       => DDR_CK_P,
      DDR_CK_N       => DDR_CK_N,
      DDR_CKE        => DDR_CKE,
      DDR_CS_N       => DDR_CS_N_i,
      DDR_RAS_N      => DDR_RAS_N,
      DDR_CAS_N      => DDR_CAS_N,
      DDR_WE_N       => DDR_WE_N,
      DDR_BA         => DDR_BA_i,
      DDR_A          => DDR_A_i,
      DDR_DQS        => DDR_DQS,
      DDR_DQ         => DDR_DQ,
      DDR_SA         => DDR_SA,
      DDR_SCL        => DDR_SCL,
      DDR_SDA        => DDR_SDA,
      --------------------------------
      -- MISC
      --------------------------------  
      IDLE           => IDLE,
      DDRT_TRIG      => DDRT_TRIG,
      DDRT_STAT      => DDRT_STAT,
      FIFO_ERR       => FIFO_ERR,
      MEM_INITDONE   => MEM_INITDONE
      );
   
end STRUCTURE;

