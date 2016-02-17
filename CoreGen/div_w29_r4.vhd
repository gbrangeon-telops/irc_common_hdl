--------------------------------------------------------------------------------
--     This file is owned and controlled by Xilinx and must be used           --
--     solely for design, simulation, implementation and creation of          --
--     design files limited to Xilinx devices or technologies. Use            --
--     with non-Xilinx devices or technologies is expressly prohibited        --
--     and immediately terminates your license.                               --
--                                                                            --
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"          --
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                --
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION        --
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION            --
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS              --
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                --
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE       --
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY               --
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                --
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR         --
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF        --
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS        --
--     FOR A PARTICULAR PURPOSE.                                              --
--                                                                            --
--     Xilinx products are not intended for use in life support               --
--     appliances, devices, or systems. Use in such applications are          --
--     expressly prohibited.                                                  --
--                                                                            --
--     (c) Copyright 1995-2004 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file div_w29_r4.vhd when simulating
-- the core, div_w29_r4. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Guide".

-- The synopsys directives "translate_off/translate_on" specified
-- below are supported by XST, FPGA Compiler II, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

-- synopsys translate_off
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

Library XilinxCoreLib;
ENTITY div_w29_r4 IS
	port (
	dividend: IN std_logic_VECTOR(28 downto 0);
	divisor: IN std_logic_VECTOR(3 downto 0);
	quot: OUT std_logic_VECTOR(28 downto 0);
	remd: OUT std_logic_VECTOR(3 downto 0);
	clk: IN std_logic;
	rfd: OUT std_logic;
	aclr: IN std_logic;
	sclr: IN std_logic;
	ce: IN std_logic);
END div_w29_r4;

ARCHITECTURE div_w29_r4_a OF div_w29_r4 IS

component wrapped_div_w29_r4
	port (
	dividend: IN std_logic_VECTOR(28 downto 0);
	divisor: IN std_logic_VECTOR(3 downto 0);
	quot: OUT std_logic_VECTOR(28 downto 0);
	remd: OUT std_logic_VECTOR(3 downto 0);
	clk: IN std_logic;
	rfd: OUT std_logic;
	aclr: IN std_logic;
	sclr: IN std_logic;
	ce: IN std_logic);
end component;

-- Configuration specification 
	for all : wrapped_div_w29_r4 use entity XilinxCoreLib.sdivider_v3_0(behavioral)
		generic map(
			c_has_ce => 1,
			divclk_sel => 1,
			dividend_width => 29,
			fractional_width => 4,
			c_sync_enable => 1,
			divisor_width => 4,
			signed_b => 0,
			c_has_aclr => 1,
			fractional_b => 0,
			c_has_sclr => 0);
BEGIN

U0 : wrapped_div_w29_r4
		port map (
			dividend => dividend,
			divisor => divisor,
			quot => quot,
			remd => remd,
			clk => clk,
			rfd => rfd,
			aclr => aclr,
			sclr => sclr,
			ce => ce);
END div_w29_r4_a;

-- synopsys translate_on

