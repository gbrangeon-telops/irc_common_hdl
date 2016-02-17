-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description     : It is the top most module which interfaces with the system
--                         and the memory.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top is
  generic(
    REGISTERED_DIMM      : std_logic := '1'
  );
  port (
  	 dly_ctrl_rdy								  : out std_logic;
    cntrl0_DDR_DQ                        : inout  std_logic_vector(71 downto 0);
    cntrl0_DDR_A                         : out  std_logic_vector(12 downto 0);
    cntrl0_DDR_BA                        : out  std_logic_vector(1 downto 0);
    cntrl0_DDR_CKE                       : out std_logic_vector(1 downto 0);
    cntrl0_DDR_CS_N                      : out std_logic_vector(1 downto 0);
    cntrl0_DDR_RAS_N                     : out std_logic;
    cntrl0_DDR_CAS_N                     : out std_logic;
    cntrl0_DDR_WE_N                      : out std_logic;
    cntrl0_DDR_RESET_N                   : out std_logic;
    init_done                            : out std_logic;
    SYS_RESET_IN_N                       : in std_logic;
    cntrl0_CLK_TB                        : out std_logic;
    cntrl0_RESET_TB                      : out std_logic;
    cntrl0_WDF_ALMOST_FULL               : out std_logic;
    cntrl0_AF_ALMOST_FULL                : out std_logic;
    cntrl0_READ_DATA_VALID               : out std_logic;
    cntrl0_APP_WDF_WREN                  : in std_logic;
    cntrl0_APP_AF_WREN                   : in std_logic;
    cntrl0_BURST_LENGTH                  : out  std_logic_vector(2 downto 0);
    cntrl0_APP_AF_ADDR                   : in  std_logic_vector(35 downto 0);
    cntrl0_APP_WDF_DATA                  : in  std_logic_vector(143 downto 0);
    cntrl0_READ_DATA_FIFO_OUT            : out  std_logic_vector(143 downto 0);
    clk_0                                : in std_logic;
    clk_90                               : in std_logic;
    clk_200                              : in std_logic;
    dcm_lock                             : in std_logic;
    cntrl0_DDR_DQS                       : inout  std_logic_vector(17 downto 0);
    cntrl0_DDR_CK                        : out  std_logic_vector(0 downto 0);
    cntrl0_DDR_CK_N                      : out  std_logic_vector(0 downto 0)
      );

end mem_interface_top;

architecture arc_mem_interface_top of mem_interface_top is

  component mem_interface_top_top_0
  generic(
    REGISTERED_DIMM      : std_logic := '1'
  );
  port (
   DDR_DQ                         : inout  std_logic_vector(71 downto 0);
   DDR_A                          : out  std_logic_vector(12 downto 0);
   DDR_BA                         : out  std_logic_vector(1 downto 0);
   DDR_CKE                        : out std_logic_vector(1 downto 0);
   DDR_CS_N                       : out std_logic_vector(1 downto 0);
   DDR_RAS_N                      : out std_logic;
   DDR_CAS_N                      : out std_logic;
   DDR_WE_N                       : out std_logic;
   DDR_RESET_N                    : out std_logic;
   init_done                      : out std_logic;
   CLK_TB                         : out std_logic;
   RESET_TB                       : out std_logic;
   WDF_ALMOST_FULL                : out std_logic;
   AF_ALMOST_FULL                 : out std_logic;
   READ_DATA_VALID                : out std_logic;
   APP_WDF_WREN                   : in std_logic;
   APP_AF_WREN                    : in std_logic;
   BURST_LENGTH                   : out  std_logic_vector(2 downto 0);
   APP_AF_ADDR                    : in  std_logic_vector(35 downto 0);
   APP_WDF_DATA                   : in  std_logic_vector(143 downto 0);
   READ_DATA_FIFO_OUT             : out  std_logic_vector(143 downto 0);
   DDR_DQS                        : inout  std_logic_vector(17 downto 0);
   DDR_CK                         : out  std_logic_vector(0 downto 0);
   DDR_CK_N                       : out  std_logic_vector(0 downto 0);
   clk_0                          : in std_logic;
   clk_90                         : in std_logic;
   
   sys_rst                        : in std_logic;   
   sys_rst90                      : in std_logic;   
   idelay_ctrl_rdy                : in std_logic

   );
end component;

  component mem_interface_top_infrastructure
    port(
      idelay_ctrl_rdy                : in std_logic;
      sys_rst                        : out std_logic;
      sys_rst90                      : out std_logic;
      sys_rst_r1                     : out std_logic;
      SYS_RESET_IN_N                 : in std_logic;
      clk_0                          : in std_logic;
      clk_90                         : in std_logic;
      clk_200                        : in std_logic;
      dcm_lock                       : in std_logic
      );
  end component;

  component mem_interface_top_idelay_ctrl
    port (
      CLK200     : in  std_logic;
      RESET      : in  std_logic;
      RDY_STATUS : out std_logic
      );
  end component;

  signal sys_rst         : std_logic;
  signal sys_rst90       : std_logic;
  signal idelay_ctrl_rdy : std_logic;
  signal sys_rst_r1      : std_logic;

begin

  top_00 :    mem_interface_top_top_0
  generic map (
    REGISTERED_DIMM               => REGISTERED_DIMM
  )
  port map (
   DDR_DQ                         => cntrl0_DDR_DQ,
   DDR_A                          => cntrl0_DDR_A,
   DDR_BA                         => cntrl0_DDR_BA,
   DDR_CKE                        => cntrl0_DDR_CKE,
   DDR_CS_N                       => cntrl0_DDR_CS_N,
   DDR_RAS_N                      => cntrl0_DDR_RAS_N,
   DDR_CAS_N                      => cntrl0_DDR_CAS_N,
   DDR_WE_N                       => cntrl0_DDR_WE_N,
   DDR_RESET_N                    => cntrl0_DDR_RESET_N,
   init_done                      => init_done,
   CLK_TB                         => cntrl0_CLK_TB,
   RESET_TB                       => cntrl0_RESET_TB,
   WDF_ALMOST_FULL                => cntrl0_WDF_ALMOST_FULL,
   AF_ALMOST_FULL                 => cntrl0_AF_ALMOST_FULL,
   READ_DATA_VALID                => cntrl0_READ_DATA_VALID,
   APP_WDF_WREN                   => cntrl0_APP_WDF_WREN,
   APP_AF_WREN                    => cntrl0_APP_AF_WREN,
   BURST_LENGTH                   => cntrl0_BURST_LENGTH,
   APP_AF_ADDR                    => cntrl0_APP_AF_ADDR,
   APP_WDF_DATA                   => cntrl0_APP_WDF_DATA,
   READ_DATA_FIFO_OUT             => cntrl0_READ_DATA_FIFO_OUT,
   DDR_DQS                        => cntrl0_DDR_DQS,
   DDR_CK                         => cntrl0_DDR_CK,
   DDR_CK_N                       => cntrl0_DDR_CK_N,
   clk_0                          => clk_0,
   clk_90                         => clk_90,
   
   sys_rst                        => sys_rst,
   sys_rst90                      => sys_rst90,
   idelay_ctrl_rdy                => idelay_ctrl_rdy
   );


  infrastructure0 : mem_interface_top_infrastructure
    port map (
      idelay_ctrl_rdy                => idelay_ctrl_rdy,
      sys_rst                        => sys_rst,
      sys_rst90                      => sys_rst90,
      sys_rst_r1                     => sys_rst_r1,
      SYS_RESET_IN_N                 => SYS_RESET_IN_N,
      clk_0                          => clk_0,
      clk_90                         => clk_90,
      clk_200                        => clk_200,
      dcm_lock                       => dcm_lock
      );


  --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- IDELAYCTRL instantiation
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  mem_interface_top_idelay_ctrl0 : mem_interface_top_idelay_ctrl
    port map (
      CLK200 => clk_200,
      RESET      => sys_rst_r1,
      RDY_STATUS => idelay_ctrl_rdy
      );
  
  dly_ctrl_rdy <= idelay_ctrl_rdy;

end arc_mem_interface_top;
