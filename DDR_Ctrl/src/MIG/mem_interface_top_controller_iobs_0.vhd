-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_controller_iobs_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Puts the memory control signals like address, bank address, row
--              address strobe, column address strobe, write enable and clock
--              enable in the IOBs.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_controller_iobs_0 is
  port (
    ctrl_ddr_address : in  std_logic_vector((row_address - 1) downto 0);
    ctrl_ddr_ba      : in  std_logic_vector((bank_address - 1) downto 0);
    ctrl_ddr_ras_L   : in  std_logic;
    ctrl_ddr_cas_L   : in  std_logic;
    ctrl_ddr_we_L    : in  std_logic;
    ctrl_ddr_cs_L    : in  std_logic_vector(cs_width-1 downto 0);
    ctrl_ddr_cke     : in  std_logic_vector(cke_width-1 downto 0);
    DDR_ADDRESS      : out std_logic_vector((row_address - 1) downto 0);
    DDR_BA           : out std_logic_vector((bank_address - 1) downto 0);
    DDR_RAS_L        : out std_logic;
    DDR_CAS_L        : out std_logic;
    DDR_WE_L         : out std_logic;
    DDR_CKE          : out std_logic_vector(cke_width-1 downto 0);
    ddr_cs_L         : out std_logic_vector(cs_width-1 downto 0)
    );
end mem_interface_top_controller_iobs_0;

architecture arch of mem_interface_top_controller_iobs_0 is

begin

  r0 : OBUF
    port map(
      I => ctrl_ddr_ras_L,
      O => DDR_RAS_L
      );

  r1 : OBUF
    port map(
      I => ctrl_ddr_cas_L,
      O => DDR_CAS_L
      );

  r2 : OBUF
    port map(
      I => ctrl_ddr_we_L,
      O => DDR_WE_L
      );


  OBUF_cs0 : OBUF
    port map(
      I => ctrl_ddr_cs_L(0),
      O => ddr_cs_L(0)
      );


  OBUF_cs1 : OBUF
    port map(
      I => ctrl_ddr_cs_L(1),
      O => ddr_cs_L(1)
      );


  OBUF_cke0 : OBUF
    port map(
      I => ctrl_ddr_cke(0),
      O => DDR_CKE(0)
      );


  OBUF_cke1 : OBUF
    port map(
      I => ctrl_ddr_cke(1),
      O => DDR_CKE(1)
      );


  OBUF_r0: OBUF
    port map(
          I => ctrl_ddr_address(0),
          O => DDR_ADDRESS(0)
          );


  OBUF_r1: OBUF
    port map(
          I => ctrl_ddr_address(1),
          O => DDR_ADDRESS(1)
          );


  OBUF_r2: OBUF
    port map(
          I => ctrl_ddr_address(2),
          O => DDR_ADDRESS(2)
          );


  OBUF_r3: OBUF
    port map(
          I => ctrl_ddr_address(3),
          O => DDR_ADDRESS(3)
          );


  OBUF_r4: OBUF
    port map(
          I => ctrl_ddr_address(4),
          O => DDR_ADDRESS(4)
          );


  OBUF_r5: OBUF
    port map(
          I => ctrl_ddr_address(5),
          O => DDR_ADDRESS(5)
          );


  OBUF_r6: OBUF
    port map(
          I => ctrl_ddr_address(6),
          O => DDR_ADDRESS(6)
          );


  OBUF_r7: OBUF
    port map(
          I => ctrl_ddr_address(7),
          O => DDR_ADDRESS(7)
          );


  OBUF_r8: OBUF
    port map(
          I => ctrl_ddr_address(8),
          O => DDR_ADDRESS(8)
          );


  OBUF_r9: OBUF
    port map(
          I => ctrl_ddr_address(9),
          O => DDR_ADDRESS(9)
          );


  OBUF_r10: OBUF
    port map(
          I => ctrl_ddr_address(10),
          O => DDR_ADDRESS(10)
          );


  OBUF_r11: OBUF
    port map(
          I => ctrl_ddr_address(11),
          O => DDR_ADDRESS(11)
          );


  OBUF_r12: OBUF
    port map(
          I => ctrl_ddr_address(12),
          O => DDR_ADDRESS(12)
          );



  
  OBUF_b0: OBUF
    port map(
           I => ctrl_ddr_ba(0),
           O => DDR_BA(0)
          );


  OBUF_b1: OBUF
    port map(
           I => ctrl_ddr_ba(1),
           O => DDR_BA(1)
          );



end arch;
