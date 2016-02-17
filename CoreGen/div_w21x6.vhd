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
--     (c) Copyright 1995-2005 Xilinx, Inc.                                   --
--     All rights reserved.                                                   --
--------------------------------------------------------------------------------
-- You must compile the wrapper file div_w21x6.vhd when simulating
-- the core, div_w21x6. When compiling the wrapper file, be sure to
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
ENTITY div_w21x6 IS
	port (
	dividend: IN std_logic_VECTOR(20 downto 0);
	divisor: IN std_logic_VECTOR(5 downto 0);
	quot: OUT std_logic_VECTOR(20 downto 0);
	remd: OUT std_logic_VECTOR(5 downto 0);
	clk: IN std_logic;
	rfd: OUT std_logic;
	ce: IN std_logic);
END div_w21x6;

ARCHITECTURE div_w21x6_a OF div_w21x6 IS
-- synopsys translate_off
component wrapped_div_w21x6
	port (
	dividend: IN std_logic_VECTOR(20 downto 0);
	divisor: IN std_logic_VECTOR(5 downto 0);
	quot: OUT std_logic_VECTOR(20 downto 0);
	remd: OUT std_logic_VECTOR(5 downto 0);
	clk: IN std_logic;
	rfd: OUT std_logic;
	ce: IN std_logic);
end component;

-- Configuration specification 
	for all : wrapped_div_w21x6 use entity XilinxCoreLib.sdivider_v3_0(behavioral)
		generic map(
			c_has_ce => 1,
			divclk_sel => 4,
			dividend_width => 21,
			fractional_width => 6,
			c_sync_enable => 1,
			signed_b => 0,
			divisor_width => 6,
			c_has_aclr => 0,
			fractional_b => 0,
			c_has_sclr => 0);
-- synopsys translate_on
BEGIN
-- synopsys translate_off
U0 : wrapped_div_w21x6
		port map (
			dividend => dividend,
			divisor => divisor,
			quot => quot,
			remd => remd,
			clk => clk,
			rfd => rfd,
			ce => ce);
-- synopsys translate_on

END div_w21x6_a;

