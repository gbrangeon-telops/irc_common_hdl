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
-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component fft_16k_16bit
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

-- FPGA Express Black Box declaration
attribute fpga_dont_touch: string;
attribute fpga_dont_touch of fft_16k_16bit: component is "true";

-- Synplicity black box declaration
attribute syn_black_box : boolean;
attribute syn_black_box of fft_16k_16bit: component is true;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : fft_16k_16bit
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
-- INST_TAG_END ------ End INSTANTIATION Template ------------

-- You must compile the wrapper file fft_16k_16bit.vhd when simulating
-- the core, fft_16k_16bit. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

