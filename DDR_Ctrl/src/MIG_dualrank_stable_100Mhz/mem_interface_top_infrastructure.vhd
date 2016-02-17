-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_infrastructure.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the DCM of the FPGA device. The system clock is
--              given as the input and two clocks that are phase shifted by
--              90 degrees are taken out. It also give the reset signals in
--              phase with the clocks.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_infrastructure is
  port (
      idelay_ctrl_rdy  : in std_logic;

      clk_0           : in std_logic;
      clk_90          : in std_logic;
      dcm_lock        : in std_logic;
      clk_200          : in std_logic;
	  SYS_RESET_IN_N    : in std_logic;

      sys_rst    : out std_logic;
      sys_rst90  : out std_logic;
      sys_rst_r1 : out std_logic
      );
end mem_interface_top_infrastructure;

architecture arch of mem_interface_top_infrastructure is




  constant RST_SYNC_NUM        : integer := 12;

  signal rst0_sync_r           : std_logic_vector((RST_SYNC_NUM -1) downto 0);
  signal rst200_sync_r         : std_logic_vector((RST_SYNC_NUM -1) downto 0);
  signal rst90_sync_r          : std_logic_vector((RST_SYNC_NUM -1) downto 0);
  signal rst_tmp               : std_logic;
  signal SYS_RESET             : std_logic;

  constant add_const           : std_logic_vector(15 downto 0) := X"FFFF" ;


begin

  
  SYS_RESET   <= (not SYS_RESET_IN_N) when (reset_active_low = '1') else
                  SYS_RESET_IN_N;

  
  

  rst_tmp  <= (not dcm_lock) or (not idelay_ctrl_rdy) or (SYS_RESET);

  process(clk_0, rst_tmp)
  begin
    if (rst_tmp = '1') then
      rst0_sync_r <= add_const(RST_SYNC_NUM-1 downto 0);
    elsif (clk_0'event and clk_0 = '1') then
      rst0_sync_r(RST_SYNC_NUM-1 downto 1) <= rst0_sync_r(RST_SYNC_NUM-2 downto 0);
      rst0_sync_r(0) <= '0';
    end if;
  end process;

  process(clk_90, rst_tmp)
  begin
    if (rst_tmp = '1') then
      rst90_sync_r <= add_const(RST_SYNC_NUM-1 downto 0);
    elsif (clk_90'event and clk_90 = '1') then
      rst90_sync_r(RST_SYNC_NUM-1 downto 1) <= rst90_sync_r(RST_SYNC_NUM-2 downto 0);
      rst90_sync_r(0) <= '0';
    end if;
  end process;

  process(clk_200, dcm_lock)
  begin
    if (dcm_lock = '0') then
      rst200_sync_r <= add_const(RST_SYNC_NUM-1 downto 0);
    elsif (clk_200'event and clk_200 = '1') then
      rst200_sync_r(RST_SYNC_NUM-1 downto 1) <= rst200_sync_r(RST_SYNC_NUM-2 downto 0);
      rst200_sync_r(0) <= '0';
    end if;
  end process;


  sys_rst    <= rst0_sync_r(RST_SYNC_NUM-1);
  sys_rst90  <= rst90_sync_r(RST_SYNC_NUM-1);
  sys_rst_r1 <= rst200_sync_r(RST_SYNC_NUM-1);

end arch;
