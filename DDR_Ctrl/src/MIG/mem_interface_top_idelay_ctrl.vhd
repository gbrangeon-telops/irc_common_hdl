-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_idelay_ctrl.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantaites the IDELAYCTRL primitive of the Virtex4 device
--              which continously calibrates the IDELAY elements in the region
--              in case of varying operating conditions. It takes a 200MHz
--              clock as an input.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_idelay_ctrl is
  port(
    CLK200     : in  std_logic;
    RESET      : in  std_logic;
    RDY_STATUS : out std_logic
    );
end mem_interface_top_idelay_ctrl;

architecture arch of mem_interface_top_idelay_ctrl is

begin

--  idelayctrl0 : IDELAYCTRL
--    port map (
--      RDY    => RDY_STATUS,
--      REFCLK => CLK200,
--      RST    => RESET
--      );
      
   RDY_STATUS <= '1';

end arch;
