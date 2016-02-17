-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : ZBT_Ctrl
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\Common_HDL\ZBT_Ctrl\Active-HDL\compile\zbt_ctrl_20a_16d.vhd
-- Generated   : Wed May 23 17:53:36 2007
-- From        : d:\Telops\Common_HDL\ZBT_Ctrl\Active-HDL\src\zbt_ctrl_20a_16d.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : This is a wrapper for either the NGC or RTL model.
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;


entity zbt_ctrl_20a_16d_wrap is
  port(
       ARESET : in STD_LOGIC;
       CLK : in STD_LOGIC;
       CLK_CORE : in STD_LOGIC;
       RD_ADD_EN : in STD_LOGIC;
       RD_DATA_BUSY : in STD_LOGIC;
       RD_DATA_EN : in STD_LOGIC;
       WR_EN : in STD_LOGIC;
       RD_ADD : in STD_LOGIC_VECTOR(19 downto 0);
       RD_ADD_AFULL : out STD_LOGIC;
       WR_ADD : in STD_LOGIC_VECTOR(19 downto 0);
       WR_DATA : in STD_LOGIC_VECTOR(15 downto 0);
       ZBT_ADV_LD_N : out STD_LOGIC;
       ZBT_BWA_N : out STD_LOGIC;
       ZBT_BWB_N : out STD_LOGIC;
       ZBT_BWC_N : out STD_LOGIC;
       ZBT_BWD_N : out STD_LOGIC;
       ZBT_CE2_N : out STD_LOGIC;
       ZBT_CE2 : out STD_LOGIC;
       ZBT_CE_N : out STD_LOGIC;
       ZBT_CKE_N : out STD_LOGIC;
       FIFO_ERR : out STD_LOGIC;
       ZBT_LDO : out STD_LOGIC;
       ZBT_OE_N : out STD_LOGIC;
       RD_IDLE : out STD_LOGIC;
       SELF_TEST_PASS : out STD_LOGIC;
       ZBT_WE_N : out STD_LOGIC;
       WR_AFULL : out STD_LOGIC;
       WR_IDLE : out STD_LOGIC;
       CTRL_BUSY : out STD_LOGIC;
       ZBT_ZZ : out STD_LOGIC;
       ZBT_ADD : out STD_LOGIC_VECTOR(19 downto 0);
       RD_DATA : out STD_LOGIC_VECTOR(15 downto 0);
       RD_DVAL : out STD_LOGIC;
       ZBT_DATA : inout STD_LOGIC_VECTOR(15 downto 0)
  );
end zbt_ctrl_20a_16d_wrap;

-- This architecture is for post-synthesis simulation
architecture NGC of zbt_ctrl_20a_16d_wrap is

constant DLEN : integer := 16;
constant ALEN : integer := 20;

component zbt_ctrl_20a_16d
  port (
       ARESET : in STD_LOGIC;
       CLK : in STD_LOGIC;
       CLK_CORE : in STD_LOGIC;
       RD_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
       RD_ADD_EN : in STD_LOGIC;
       RD_DATA_BUSY : in STD_LOGIC;
       RD_DATA_EN : in STD_LOGIC;
       WR_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
       WR_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
       WR_EN : in STD_LOGIC;
       ZBT_ADD : out STD_LOGIC_VECTOR(alen-1 downto 0);
       ZBT_ADV_LD_N : out STD_LOGIC;
       ZBT_BWA_N : out STD_LOGIC;
       ZBT_BWB_N : out STD_LOGIC;
       ZBT_BWC_N : out STD_LOGIC;
       ZBT_BWD_N : out STD_LOGIC;
       ZBT_CE2_N : out STD_LOGIC;
       ZBT_CE2 : out STD_LOGIC;
       ZBT_CE_N : out STD_LOGIC;
       ZBT_CKE_N : out STD_LOGIC;
       FIFO_ERR : out STD_LOGIC;
       ZBT_LDO : out STD_LOGIC;
       ZBT_OE_N : out STD_LOGIC;
       RD_ADD_AFULL : out STD_LOGIC;
       RD_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
       RD_DVAL : out STD_LOGIC;
       RD_IDLE : out STD_LOGIC;
       SELF_TEST_PASS : out STD_LOGIC;
       ZBT_WE_N : out STD_LOGIC;
       WR_AFULL : out STD_LOGIC;
       WR_IDLE : out STD_LOGIC;
       CTRL_BUSY : out STD_LOGIC;
       ZBT_ZZ : out STD_LOGIC;
       ZBT_DATA : inout STD_LOGIC_VECTOR(DLEN-1 downto 0)
  );
end component;

---- Signal declarations used on the diagram ----

begin

----  Component instantiations  ----

U1 : zbt_ctrl_20a_16d
  port map(
       ZBT_ADD => ZBT_ADD( alen-1 downto 0 ),
       ZBT_ADV_LD_N => ZBT_ADV_LD_N,
       ARESET => ARESET,
       ZBT_BWA_N => ZBT_BWA_N,
       ZBT_BWB_N => ZBT_BWB_N,
       ZBT_BWC_N => ZBT_BWC_N,
       ZBT_BWD_N => ZBT_BWD_N,
       ZBT_CE2_N => ZBT_CE2_N,
       ZBT_CE2 => ZBT_CE2,
       ZBT_CE_N => ZBT_CE_N,
       ZBT_CKE_N => ZBT_CKE_N,
       CLK => CLK,
       CLK_CORE => CLK_CORE,
       ZBT_DATA => ZBT_DATA( DLEN-1 downto 0 ),
       FIFO_ERR => FIFO_ERR,
       ZBT_LDO => ZBT_LDO,
       ZBT_OE_N => ZBT_OE_N,
       RD_ADD => RD_ADD( ALEN-1 downto 0 ),
       RD_ADD_EN => RD_ADD_EN,
       RD_ADD_AFULL => RD_ADD_AFULL,
       RD_DATA => RD_DATA( DLEN-1 downto 0 ),
       RD_DATA_BUSY => RD_DATA_BUSY,
       RD_DATA_EN => RD_DATA_EN,
       RD_DVAL => RD_DVAL,
       RD_IDLE => RD_IDLE,
       SELF_TEST_PASS => SELF_TEST_PASS,
       ZBT_WE_N => ZBT_WE_N,
       WR_ADD => WR_ADD( ALEN-1 downto 0 ),
       WR_AFULL => WR_AFULL,
       WR_DATA => WR_DATA( DLEN-1 downto 0 ),
       WR_EN => WR_EN,
       WR_IDLE => WR_IDLE,
       CTRL_BUSY => CTRL_BUSY,
       ZBT_ZZ => ZBT_ZZ
  );


end NGC;

 --This architecture is for pre-synthesis simulation
 --pragma translate_off
architecture RTL of zbt_ctrl_20a_16d_wrap is

constant DLEN : integer := 16;
constant ALEN : integer := 20;

component ZBT_CONTROL
  generic(
       ALEN : integer := 20;
       DLEN : integer := 36
  );
  port (
       ARESET : in STD_LOGIC;
       CLK : in STD_LOGIC;
       CLK_CORE : in STD_LOGIC;
       RD_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
       RD_ADD_EN : in STD_LOGIC;
       RD_DATA_BUSY : in STD_LOGIC;
       RD_DATA_EN : in STD_LOGIC;
       WR_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
       WR_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
       WR_EN : in STD_LOGIC;
       ZBT_ADD : out STD_LOGIC_VECTOR(alen-1 downto 0);
       ZBT_ADV_LD_N : out STD_LOGIC;
       ZBT_BWA_N : out STD_LOGIC;
       ZBT_BWB_N : out STD_LOGIC;
       ZBT_BWC_N : out STD_LOGIC;
       ZBT_BWD_N : out STD_LOGIC;
       ZBT_CE2_N : out STD_LOGIC;
       ZBT_CE2 : out STD_LOGIC;
       ZBT_CE_N : out STD_LOGIC;
       ZBT_CKE_N : out STD_LOGIC;
       FIFO_ERR : out STD_LOGIC;
       ZBT_LDO : out STD_LOGIC;
       ZBT_OE_N : out STD_LOGIC;
       RD_ADD_AFULL : out STD_LOGIC;
       RD_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
       RD_DVAL : out STD_LOGIC;
       RD_IDLE : out STD_LOGIC;
       SELF_TEST_PASS : out STD_LOGIC;
       ZBT_WE_N : out STD_LOGIC;
       WR_AFULL : out STD_LOGIC;
       WR_IDLE : out STD_LOGIC;
       CTRL_BUSY : out STD_LOGIC;
       ZBT_ZZ : out STD_LOGIC;
       ZBT_DATA : inout STD_LOGIC_VECTOR(DLEN-1 downto 0)
  );
end component;     

begin

DP_ZBT_CONTROL : ZBT_CONTROL
  generic map (
       ALEN => ALEN,
       DLEN => DLEN
  )
  port map(
       ZBT_ADD => ZBT_ADD( alen-1 downto 0 ),
       ZBT_ADV_LD_N => ZBT_ADV_LD_N,
       ARESET => ARESET,
       ZBT_BWA_N => ZBT_BWA_N,
       ZBT_BWB_N => ZBT_BWB_N,
       ZBT_BWC_N => ZBT_BWC_N,
       ZBT_BWD_N => ZBT_BWD_N,
       ZBT_CE2_N => ZBT_CE2_N,
       ZBT_CE2 => ZBT_CE2,
       ZBT_CE_N => ZBT_CE_N,
       ZBT_CKE_N => ZBT_CKE_N,
       CLK => CLK,
       CLK_CORE => CLK_CORE,
       ZBT_DATA => ZBT_DATA( dlen-1 downto 0 ),
       FIFO_ERR => FIFO_ERR,
       ZBT_LDO => ZBT_LDO,
       ZBT_OE_N => ZBT_OE_N,
       RD_ADD => RD_ADD( ALEN-1 downto 0 ),
       RD_ADD_EN => RD_ADD_EN,
       RD_ADD_AFULL => RD_ADD_AFULL,
       RD_DATA => RD_DATA( DLEN-1 downto 0 ),
       RD_DATA_BUSY => RD_DATA_BUSY,
       RD_DATA_EN => RD_DATA_EN,
       RD_DVAL => RD_DVAL,
       RD_IDLE => RD_IDLE,
       SELF_TEST_PASS => SELF_TEST_PASS,
       ZBT_WE_N => ZBT_WE_N,
       WR_ADD => WR_ADD( ALEN-1 downto 0 ),
       WR_AFULL => WR_AFULL,
       WR_DATA => WR_DATA( DLEN-1 downto 0 ),
       WR_EN => WR_EN,
       WR_IDLE => WR_IDLE,
       CTRL_BUSY => CTRL_BUSY,
       ZBT_ZZ => ZBT_ZZ
  );


end RTL;
-- pragma translate_on
