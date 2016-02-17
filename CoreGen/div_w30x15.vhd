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
--     (c) Copyright 1995-2006 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file div_w30x15.vhd when simulating
-- the core, div_w30x15. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synopsys directives "translate_off/translate_on" specified
-- below are supported by XST, FPGA Compiler II, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synopsys translate_off
Library XilinxCoreLib;
-- synopsys translate_on
ENTITY div_w30x15 IS
	port (
	dividend: IN std_logic_VECTOR(29 downto 0);
	divisor: IN std_logic_VECTOR(14 downto 0);
	quot: OUT std_logic_VECTOR(29 downto 0);
	remd: OUT std_logic_VECTOR(3 downto 0);
	clk: IN std_logic;
	rfd: OUT std_logic);
END div_w30x15;

ARCHITECTURE div_w30x15_a OF div_w30x15 IS
-- synopsys translate_off
component wrapped_div_w30x15
	port (
	dividend: IN std_logic_VECTOR(29 downto 0);
	divisor: IN std_logic_VECTOR(14 downto 0);
	quot: OUT std_logic_VECTOR(29 downto 0);
	remd: OUT std_logic_VECTOR(3 downto 0);
	clk: IN std_logic;
	rfd: OUT std_logic);
end component;

-- Configuration specification 
	for all : wrapped_div_w30x15 use entity XilinxCoreLib.sdivider_v3_0(behavioral)
		generic map(
			c_has_ce => 0,
			divclk_sel => 8,
			dividend_width => 30,
			fractional_width => 4,
			c_sync_enable => 1,
			signed_b => 0,
			divisor_width => 15,
			c_has_aclr => 0,
			fractional_b => 1,
			c_has_sclr => 0);
-- synopsys translate_on
BEGIN
-- synopsys translate_off
U0 : wrapped_div_w30x15
		port map (
			dividend => dividend,
			divisor => divisor,
			quot => quot,
			remd => remd,
			clk => clk,
			rfd => rfd);
-- synopsys translate_on

END div_w30x15_a;

