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
-- You must compile the wrapper file s_fifo_w27_d16.vhd when simulating
-- the core, s_fifo_w27_d16. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synopsys directives "translate_off/translate_on" specified
-- below are supported by XST, FPGA Compiler II, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

-- synopsys translate_off
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

Library XilinxCoreLib;
ENTITY s_fifo_w27_d16 IS
	port (
	clk: IN std_logic;
	sinit: IN std_logic;
	din: IN std_logic_VECTOR(26 downto 0);
	wr_en: IN std_logic;
	rd_en: IN std_logic;
	dout: OUT std_logic_VECTOR(26 downto 0);
	full: OUT std_logic;
	empty: OUT std_logic;
	rd_ack: OUT std_logic;
	rd_err: OUT std_logic;
	wr_err: OUT std_logic;
	data_count: OUT std_logic_VECTOR(4 downto 0));
END s_fifo_w27_d16;

ARCHITECTURE s_fifo_w27_d16_a OF s_fifo_w27_d16 IS

component wrapped_s_fifo_w27_d16
	port (
	clk: IN std_logic;
	sinit: IN std_logic;
	din: IN std_logic_VECTOR(26 downto 0);
	wr_en: IN std_logic;
	rd_en: IN std_logic;
	dout: OUT std_logic_VECTOR(26 downto 0);
	full: OUT std_logic;
	empty: OUT std_logic;
	rd_ack: OUT std_logic;
	rd_err: OUT std_logic;
	wr_err: OUT std_logic;
	data_count: OUT std_logic_VECTOR(4 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_s_fifo_w27_d16 use entity XilinxCoreLib.sync_fifo_v4_0(behavioral)
		generic map(
			c_read_data_width => 27,
			c_has_wr_ack => 0,
			c_dcount_width => 5,
			c_has_wr_err => 1,
			c_wr_err_low => 0,
			c_wr_ack_low => 1,
			c_enable_rlocs => 0,
			c_has_dcount => 1,
			c_rd_err_low => 0,
			c_rd_ack_low => 0,
			c_read_depth => 16,
			c_has_rd_ack => 1,
			c_write_depth => 16,
			c_ports_differ => 0,
			c_memory_type => 0,
			c_write_data_width => 27,
			c_has_rd_err => 1);
BEGIN

U0 : wrapped_s_fifo_w27_d16
		port map (
			clk => clk,
			sinit => sinit,
			din => din,
			wr_en => wr_en,
			rd_en => rd_en,
			dout => dout,
			full => full,
			empty => empty,
			rd_ack => rd_ack,
			rd_err => rd_err,
			wr_err => wr_err,
			data_count => data_count);
END s_fifo_w27_d16_a;

-- synopsys translate_on

