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
-- You must compile the wrapper file mult_20x22_42o.vhd when simulating
-- the core, mult_20x22_42o. When compiling the wrapper file, be sure to
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
ENTITY mult_20x22_42o IS
	port (
	clk: IN std_logic;
	a: IN std_logic_VECTOR(19 downto 0);
	b: IN std_logic_VECTOR(21 downto 0);
	q: OUT std_logic_VECTOR(41 downto 0));
END mult_20x22_42o;

ARCHITECTURE mult_20x22_42o_a OF mult_20x22_42o IS
-- synopsys translate_off
component wrapped_mult_20x22_42o
	port (
	clk: IN std_logic;
	a: IN std_logic_VECTOR(19 downto 0);
	b: IN std_logic_VECTOR(21 downto 0);
	q: OUT std_logic_VECTOR(41 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_mult_20x22_42o use entity XilinxCoreLib.mult_gen_v7_0(behavioral)
		generic map(
			c_a_type => 1,
			c_mem_type => 0,
			c_has_sclr => 0,
			c_reg_a_b_inputs => 0,
			c_has_q => 1,
			c_has_o => 0,
			bram_addr_width => 9,
			c_v2_speed => 0,
			c_baat => 20,
			c_output_hold => 0,
			c_b_constant => 0,
			c_has_loadb => 0,
			c_has_b => 1,
			c_use_luts => 0,
			c_has_rdy => 0,
			c_has_nd => 0,
			c_pipeline => 1,
			c_has_a_signed => 0,
			c_b_type => 1,
			c_sqm_type => 0,
			c_standalone => 1,
			c_enable_rlocs => 1,
			c_b_value => "0000000000000001",
			c_mult_type => 1,
			c_has_aclr => 0,
			c_has_swapb => 0,
			c_has_load_done => 0,
			c_out_width => 42,
			c_mem_init_prefix => "mem",
			c_b_width => 22,
			c_a_width => 20,
			c_has_rfd => 0,
			c_sync_enable => 1,
			c_has_ce => 0,
			c_stack_adders => 1);
-- synopsys translate_on
BEGIN
-- synopsys translate_off
U0 : wrapped_mult_20x22_42o
		port map (
			clk => clk,
			a => a,
			b => b,
			q => q);
-- synopsys translate_on

END mult_20x22_42o_a;

