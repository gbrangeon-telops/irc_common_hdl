---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: mctrl_iface.vhd
--  Hierarchy: Sub-module file
--  Use: Interfacing module to transparently add a memory test block between Array DDR controller
--  and the rest of the system
--	 Project: GATORADE2 - In system memory tester
--	 By: Olivier Bourgois
--  Date: October 25, 2005
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mctrl_iface is
	port(
      -- mux control
      CLK            : in std_logic;
		EN_TEST        : in std_logic;
      ADDR_TEST_DONE : in std_logic;
		-- ddr controller interface side
		U_CMD          : out std_logic_vector(2 downto 0);
		U_CMD_VALID    : out std_logic;
		U_ADDR         : out std_logic_vector(27 downto 0);
		U_BUSY_Q       : in std_logic;
		DATA_IN        : out std_logic_vector(143 downto 0);
		DATA_OUT_Q     : in std_logic_vector(143 downto 0);
		DATA_VLD_Q     : in std_logic;
		-- system interface side
		S_U_CMD        : in std_logic_vector(2 downto 0);
		S_U_CMD_VALID  : in std_logic;
		S_U_ADDR       : in std_logic_vector(27 downto 0);
		S_U_BUSY_Q     : out std_logic;
		S_DATA_IN      : in std_logic_vector(143 downto 0);
		S_DATA_OUT_Q   : out std_logic_vector(143 downto 0);
		S_DATA_VLD_Q   : out std_logic;
		-- memory tester side
		T_U_CMD        : in std_logic_vector(2 downto 0);
		T_U_CMD_VALID  : in std_logic;
		T_U_ADDR       : in std_logic_vector(27 downto 0);
		T_U_BUSY_Q     : out std_logic;
		T_DATA_IN      : in std_logic_vector(143 downto 0);
		T_DATA_OUT_Q   : out std_logic_vector(143 downto 0);
		T_DATA_VLD_Q   : out std_logic;
		-- address bits tester
		A_U_CMD        : in std_logic_vector(2 downto 0);
		A_U_CMD_VALID  : in std_logic;
		A_U_ADDR       : in std_logic_vector(27 downto 0);
		A_U_BUSY_Q     : out std_logic;
		A_DATA_IN      : in std_logic_vector(143 downto 0);
		A_DATA_OUT_Q   : out std_logic_vector(143 downto 0);
		A_DATA_VLD_Q   : out std_logic
      );
end entity mctrl_iface;

architecture rtl of mctrl_iface is
	
	type ddrc2sys is record
		u_busy_q   : std_logic;
		data_out_q : std_logic_vector(143 downto 0);
		data_vld_q : std_logic;
	end record ddrc2sys;
	
	type sys2ddrc is record
		u_cmd       : std_logic_vector(2 downto 0);
		u_cmd_valid : std_logic;
		u_addr      : std_logic_vector(27 downto 0);
		data_in     : std_logic_vector(143 downto 0);
	end record sys2ddrc;
	
	signal from_sys   : sys2ddrc;
	signal from_iface : sys2ddrc;
   signal from_addr  : sys2ddrc;
	signal to_mctrl   : sys2ddrc;
	signal to_sys     : ddrc2sys;
	signal to_iface   : ddrc2sys;
   signal to_addr    : ddrc2sys;
	signal from_mctrl : ddrc2sys;
	
	constant IDLE_ddrc2sys : ddrc2sys := (
	'1',                                 -- u_busy_q
	x"000000000000000000000000000000000000", -- data_out_q
	'0'                                  -- data_vld_q
	);
   
begin		 
	-- system side port mapping
	from_sys.u_cmd       <= S_U_CMD;
	from_sys.u_cmd_valid <= S_U_CMD_VALID;
	from_sys.u_addr      <= S_U_ADDR;
	from_sys.data_in     <= S_DATA_IN;
	S_U_BUSY_Q           <= to_sys.u_busy_q;
	S_DATA_OUT_Q         <= to_sys.data_out_q;
	S_DATA_VLD_Q         <= to_sys.data_vld_q;
	
	-- test side port mapping
	from_iface.u_cmd       <= T_U_CMD;
	from_iface.u_cmd_valid <= T_U_CMD_VALID;
	from_iface.u_addr      <= T_U_ADDR;
	from_iface.data_in     <= T_DATA_IN;
	T_U_BUSY_Q             <= to_iface.u_busy_q;
	T_DATA_OUT_Q           <= to_iface.data_out_q;
	T_DATA_VLD_Q           <= to_iface.data_vld_q;
	
   -- address tester side port mapping
	from_addr.u_cmd       <= A_U_CMD;
	from_addr.u_cmd_valid <= A_U_CMD_VALID;
	from_addr.u_addr      <= A_U_ADDR;
	from_addr.data_in     <= A_DATA_IN;
	A_U_BUSY_Q             <= to_addr.u_busy_q;
	A_DATA_OUT_Q           <= to_addr.data_out_q;
	A_DATA_VLD_Q           <= to_addr.data_vld_q;

   -- ddr controller side port mapping
	U_CMD               <= to_mctrl.u_cmd;
	U_CMD_VALID         <= to_mctrl.u_cmd_valid;
	U_ADDR              <= to_mctrl.u_addr;
	DATA_IN             <= to_mctrl.data_in;
	from_mctrl.u_busy_q   <= U_BUSY_Q;
	from_mctrl.data_out_q <= DATA_OUT_Q;
	from_mctrl.data_vld_q <= DATA_VLD_Q;

	-- datapath mux
	dpath_mux : process(EN_TEST, from_sys, from_mctrl, from_iface, from_addr, ADDR_TEST_DONE)
	begin
--		if (EN_TEST = '1') then
--			to_mctrl <= from_iface;
--			to_sys   <= IDLE_ddrc2sys;
--			to_iface <= from_mctrl;
--			to_addr  <= IDLE_ddrc2sys;
--      elsif (ADDR_TEST_DONE = '0') then
      if (ADDR_TEST_DONE = '0') then
			to_mctrl <= from_addr;
			to_sys   <= IDLE_ddrc2sys;
			to_iface <= IDLE_ddrc2sys;
			to_addr  <= from_mctrl;
		else
			to_mctrl <= from_sys;
			to_sys   <= from_mctrl;
			to_iface <= IDLE_ddrc2sys;
			to_addr  <= IDLE_ddrc2sys;
		end if;
	end process dpath_mux;

end rtl;					