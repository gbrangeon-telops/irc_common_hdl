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
-- You must compile the wrapper file fft_16k_16bit.vhd when simulating
-- the core, fft_16k_16bit. When compiling the wrapper file, be sure to
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
ENTITY fft_16k_16bit IS
	port (
	xn_re: IN std_logic_VECTOR(15 downto 0);
	xn_im: IN std_logic_VECTOR(15 downto 0);
	start: IN std_logic;
	unload: IN std_logic;
	nfft: IN std_logic_VECTOR(4 downto 0);
	nfft_we: IN std_logic;
	fwd_inv: IN std_logic;
	fwd_inv_we: IN std_logic;
	sclr: IN std_logic;
	ce: IN std_logic;
	clk: IN std_logic;
	xk_re: OUT std_logic_VECTOR(15 downto 0);
	xk_im: OUT std_logic_VECTOR(15 downto 0);
	xn_index: OUT std_logic_VECTOR(13 downto 0);
	xk_index: OUT std_logic_VECTOR(13 downto 0);
	rfd: OUT std_logic;
	busy: OUT std_logic;
	dv: OUT std_logic;
	edone: OUT std_logic;
	done: OUT std_logic;
	blk_exp: OUT std_logic_VECTOR(4 downto 0));
END fft_16k_16bit;

ARCHITECTURE fft_16k_16bit_a OF fft_16k_16bit IS
-- synopsys translate_off
component wrapped_fft_16k_16bit
	port (
	xn_re: IN std_logic_VECTOR(15 downto 0);
	xn_im: IN std_logic_VECTOR(15 downto 0);
	start: IN std_logic;
	unload: IN std_logic;
	nfft: IN std_logic_VECTOR(4 downto 0);
	nfft_we: IN std_logic;
	fwd_inv: IN std_logic;
	fwd_inv_we: IN std_logic;
	sclr: IN std_logic;
	ce: IN std_logic;
	clk: IN std_logic;
	xk_re: OUT std_logic_VECTOR(15 downto 0);
	xk_im: OUT std_logic_VECTOR(15 downto 0);
	xn_index: OUT std_logic_VECTOR(13 downto 0);
	xk_index: OUT std_logic_VECTOR(13 downto 0);
	rfd: OUT std_logic;
	busy: OUT std_logic;
	dv: OUT std_logic;
	edone: OUT std_logic;
	done: OUT std_logic;
	blk_exp: OUT std_logic_VECTOR(4 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_fft_16k_16bit use entity XilinxCoreLib.xfft_v3_1(behavioral)
		generic map(
			c_nfft_max => 14,
			c_has_rounding => 1,
			c_has_nfft => 1,
			c_input_width => 16,
			c_twiddle_mem_type => 1,
			c_has_sclr => 1,
			c_has_bfp => 1,
			c_enable_rlocs => 0,
			c_has_natural_output => 0,
			c_has_bypass => 1,
			c_data_mem_type => 1,
			c_has_ce => 1,
			c_family => "virtex2p",
			c_optimize => 0,
			c_arch => 1,
			c_twiddle_width => 24,
			c_has_scaling => 1,
			c_has_ovflo => 0,
			c_bram_stages => 1,
			c_output_width => 16);
-- synopsys translate_on
BEGIN
-- synopsys translate_off
U0 : wrapped_fft_16k_16bit
		port map (
			xn_re => xn_re,
			xn_im => xn_im,
			start => start,
			unload => unload,
			nfft => nfft,
			nfft_we => nfft_we,
			fwd_inv => fwd_inv,
			fwd_inv_we => fwd_inv_we,
			sclr => sclr,
			ce => ce,
			clk => clk,
			xk_re => xk_re,
			xk_im => xk_im,
			xn_index => xn_index,
			xk_index => xk_index,
			rfd => rfd,
			busy => busy,
			dv => dv,
			edone => edone,
			done => done,
			blk_exp => blk_exp);
-- synopsys translate_on

END fft_16k_16bit_a;

