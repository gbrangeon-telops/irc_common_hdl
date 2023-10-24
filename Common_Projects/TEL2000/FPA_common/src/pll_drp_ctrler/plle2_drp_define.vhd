------------------------------------------------------------------
--!   @file : pll_drp_define.vhd
--!   @brief :  Package for PLL DRP Inteface Controller
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
--
-- Reference: Application Note XAPP888 de Xilinx, "MMCM and PLL DynamicReconfiguration", 2019.
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package plle2_drp_define is

constant DRP_POWER_REG_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#28#, 7));    -- Power Reg
constant DRP_CLKOUT0_REG1_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#08#, 7)); -- CLKOUT0 Register 1
constant DRP_CLKOUT0_REG2_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#09#, 7)); -- CLKOUT0 Register 2
constant DRP_CLKOUT1_REG1_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#0A#, 7)); -- CLKOUT1 Register 1
constant DRP_CLKOUT1_REG2_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#0B#, 7)); -- CLKOUT1 Register 2
constant DRP_CLKOUT2_REG1_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#0C#, 7)); -- CLKOUT2 Register 1
constant DRP_CLKOUT2_REG2_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#0D#, 7)); -- CLKOUT2 Register 2
constant DRP_CLKOUT3_REG1_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#0E#, 7)); -- CLKOUT3 Register 1
constant DRP_CLKOUT3_REG2_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#0F#, 7)); -- CLKOUT3 Register 2
constant DRP_CLKOUT4_REG1_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#10#, 7)); -- CLKOUT4 Register 1
constant DRP_CLKOUT4_REG2_ADDR : std_logic_vector(6 downto 0) := std_logic_vector(to_unsigned(16#11#, 7)); -- CLKOUT4 Register 2
constant DRP_CLKOUTN_PHASE_MUX_MASK : std_logic_vector(15 downto 0) := X"E000";  -- mask for Phase Mux Field
constant DRP_CLKOUTN_DELAY_TIME_MASK : std_logic_vector(15 downto 0) := X"003F"; -- mask for Delay Time Field
constant DRP_CLKOUTN_MX_MASK : std_logic_vector(15 downto 0) := X"0300";         -- mask for MX Field

type phase_array_t is array (natural range <>) of std_logic_vector(8 downto 0);  -- phase config type

end package plle2_drp_define;
