-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : ddr_NGCwrap_128d_26a_r1
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : ddr_wrapper_144d.vhd
-- Generated   : Wed May 23 17:53:36 2007
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity ddr_NGCwrap_128d_26a_r1 is
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
      FIFO_ERR       : out   std_logic;
      DDRT_STAT      : out   std_logic_vector( 1 downto 0);
      MEM_INITDONE   : out   std_logic
   );
end ddr_NGCwrap_128d_26a_r1;

architecture STRUCTURE of ddr_NGCwrap_128d_26a_r1 is

   component ddr_wrapper_128d_26a_r1
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
         FIFO_ERR       : out   std_logic;
         DDRT_STAT      : out   std_logic_vector( 1 downto 0);
         MEM_INITDONE   : out   std_logic
      );
   end component;

begin

   ddr: ddr_wrapper_128d_26a_r1
   port map(
      --------------------------------
      -- Global clocks and resets
      --------------------------------
      USER_CLK       => USER_CLK,
      MEM_CLK_0      => MEM_CLK_0,
      MEM_CLK_90     => MEM_CLK_90,
      MEM_CLK_LOCKED => MEM_CLK_LOCKED,
      CLK200         => CLK200,
      ARESET         => ARESET,
      CLEAR_FIFOS    => CLEAR_FIFOS,
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
      DDR_CS_N       => DDR_CS_N,
      DDR_RAS_N      => DDR_RAS_N,
      DDR_CAS_N      => DDR_CAS_N,
      DDR_WE_N       => DDR_WE_N,
      DDR_BA         => DDR_BA,
      DDR_A          => DDR_A,
      DDR_DQS        => DDR_DQS,
      DDR_DQ         => DDR_DQ,
      DDR_SA         => DDR_SA,
      DDR_SCL        => DDR_SCL,
      DDR_SDA        => DDR_SDA,
      --------------------------------
      -- MISC
      --------------------------------
      FIFO_ERR       => FIFO_ERR,
      DDRT_STAT      => DDRT_STAT,
      MEM_INITDONE   => MEM_INITDONE
   );
    
end STRUCTURE;
