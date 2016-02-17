--
--      Project:  Aurora Module Generator version 2.2
--
--         Date:  $Date: 2005/06/29 16:19:07 $
--          Tag:  $Name:  $
--         File:  $RCSfile: ck_aurora_401.vhd,v $
--          Rev:  $Revision: 1.5 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  CLOCK_MODULE
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: A module provided as a convenience for desingners using 4-byte
--               lane Aurora Modules. This module takes the MGT reference clock as
--               input, and produces a divided clock on a global clock net suitable
--               for driving application logic connected to the Aurora User Interface.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.all;
-- synthesis translate_on

entity ck_aurora_401 is
	
	port (
		
		RST 					  : in std_logic;
		MGT_REFERENCE_CLOCK : in std_logic;
		USER_CLK            : out std_logic;
		USER_CLK_2X_N       : out std_logic;
		DCM_NOT_LOCKED      : out std_logic
		
		);
	
end ck_aurora_401;

-- pragma translate_off
architecture SIM of ck_aurora_401 is
	signal init_cnt : integer range 0 to 15;
	signal clk_on : std_logic := '0';
	signal USER_CLK_buf : std_logic;
begin
	
	USER_CLK_2X_N <= not MGT_REFERENCE_CLOCK and clk_on;
	USER_CLK <= USER_CLK_buf;
	
	sim_process : process(RST, MGT_REFERENCE_CLOCK)
	begin
		if RST = '1' then
			DCM_NOT_LOCKED <= '1';
			USER_CLK_buf <= '0';
			init_cnt <= 0;
			clk_on <= '0';
		elsif rising_edge(MGT_REFERENCE_CLOCK) then
			if init_cnt < 15 then
				init_cnt <= init_cnt + 1;
			end if;
			if init_cnt > 8 then
				clk_on <= '1';
			end if;
			if init_cnt > 12 then
				DCM_NOT_LOCKED <= '0';
				USER_CLK_buf <= not USER_CLK_buf;
			end if;
		end if;
	end process;
	
end SIM;			
-- pragma translate_on

architecture MAPPED of ck_aurora_401 is
	
	-- External Register Declarations --
	
	signal USER_CLK_Buffer       : std_logic;
	signal USER_CLK_2X_N_Buffer  : std_logic;
	signal DCM_NOT_LOCKED_Buffer : std_logic;
	
	-- Wire Declarations --
	
	signal not_connected_i : std_logic_vector(15 downto 0);
	signal clkfb_i         : std_logic;
	signal clkdv_i         : std_logic;
	signal clk0_i          : std_logic;
	signal locked_i        : std_logic;
	
	signal tied_to_ground_i : std_logic;
	
	-- Component Declarations --
	
	component DCM
		
		-- synthesis translate_off
		
		generic (CLKDV_DIVIDE            : real       := 2.0;
			CLKFX_DIVIDE            : integer    := 1;
			CLKFX_MULTIPLY          : integer    := 4;
			CLKIN_DIVIDE_BY_2       : boolean    := false;
			CLKIN_PERIOD            : real       := 0.0;                  --non-simulatable
			CLKOUT_PHASE_SHIFT      : string     := "NONE";
			CLK_FEEDBACK            : string     := "1X";
			DESKEW_ADJUST           : string     := "SYSTEM_SYNCHRONOUS"; --non-simulatable
			DFS_FREQUENCY_MODE      : string     := "LOW";
			DLL_FREQUENCY_MODE      : string     := "LOW";
			DSS_MODE                : string     := "NONE";               --non-simulatable
			DUTY_CYCLE_CORRECTION   : boolean    := true;
			FACTORY_JF              : bit_vector := X"C080";              --non-simulatable
--			MAXPERCLKIN             : time       := 1000000 ps;           --simulation parameter
--			MAXPERPSCLK             : time       := 100000000 ps;         --simulation parameter
			PHASE_SHIFT             : integer    := 0;
--			SIM_CLKIN_CYCLE_JITTER  : time       := 300 ps;               --simulation parameter
--			SIM_CLKIN_PERIOD_JITTER : time       := 1000 ps;              --simulation parameter
			STARTUP_WAIT            : boolean    := false);               --non-simulatable
		
		-- synthesis translate_on
		
		port (
			CLK0     : out std_ulogic                   := '0';
			CLK180   : out std_ulogic                   := '0';
			CLK270   : out std_ulogic                   := '0';
			CLK2X    : out std_ulogic                   := '0';
			CLK2X180 : out std_ulogic                   := '0';
			CLK90    : out std_ulogic                   := '0';
			CLKDV    : out std_ulogic                   := '0';
			CLKFX    : out std_ulogic                   := '0';
			CLKFX180 : out std_ulogic                   := '0';
			LOCKED   : out std_ulogic                   := '0';
			PSDONE   : out std_ulogic                   := '0';
			STATUS   : out std_logic_vector(7 downto 0) := "00000000";
			CLKFB    : in std_ulogic                    := '0';
			CLKIN    : in std_ulogic                    := '0';
			DSSEN    : in std_ulogic                    := '0';
			PSCLK    : in std_ulogic                    := '0';
			PSEN     : in std_ulogic                    := '0';
			PSINCDEC : in std_ulogic                    := '0';
			RST      : in std_ulogic                    := '0'
			);
		
	end component;
	
	
	component BUFG
		
		port (
			
			O : out std_ulogic;
			I : in  std_ulogic
			
			);
		
	end component;
	
	
	component INV
		
		port (
			
			O : out std_ulogic;
			I : in  std_ulogic
			
			);
		
	end component;
	
begin
	
	USER_CLK       <= USER_CLK_Buffer;
	USER_CLK_2X_N  <= USER_CLK_2X_N_Buffer;
	DCM_NOT_LOCKED <= DCM_NOT_LOCKED_Buffer;
	
	tied_to_ground_i <= '0';
	
	-- Main Body of Code --
	
	-- Instantiate a DCM module to divide the reference clock.
	
	DCM_INST : DCM
	
	port map (
		
		CLK0     => clk0_i,
		CLK180   => open,
		CLK270   => open,
		CLK2X    => open,
		CLK2X180 => open,
		CLK90    => open,
		CLKDV    => clkdv_i,
		CLKFX    => open,
		CLKFX180 => open,
		LOCKED   => locked_i,
		PSDONE   => open,
		STATUS   => open,
		CLKFB    => clkfb_i,
		CLKIN    => MGT_REFERENCE_CLOCK,
		DSSEN    => tied_to_ground_i,
		PSCLK    => tied_to_ground_i,
		PSEN     => tied_to_ground_i,
		PSINCDEC => tied_to_ground_i,
		RST      => RST
		
		);
	
	
	-- BUFG for the feedback clock.  The feedback signal is phase aligned to the input
	-- and must come from the CLK0 or CLK2X output of the DCM.  In this case, we use
	-- the CLK0 output.
	
	feedback_clock_net_i : BUFG
	
	port map (
		
		I => clk0_i,
		O => clkfb_i
		
		);
	
	
	-- We invert the feedback clock to get USER_CLK_2X_N.
	
	user_clk_2x_inverter_i : INV
	
	port map (
		
		I => clkfb_i,
		O => USER_CLK_2X_N_Buffer
		
		);
	
	
	-- The User Clock is distributed on a global clock net.
	
	user_clk_net_i : BUFG
	
	port map (
		
		I => clkdv_i,
		O => USER_CLK_Buffer
		
		);
	
	
	-- The DCM_NOT_LOCKED signal is created by inverting the DCM's locked signal.
	
	DCM_NOT_LOCKED_Buffer <= not locked_i;
	
	
end MAPPED;
