-- $Id: ddr_wrapper.vhd,v 1.3 2006/03/27 16:09:47 pdubois Exp $



--
-- DDR Core wrapper for "Virtex2p"
-- 
-- This file instantiates the controller core and provides a way to correctly
-- synthesize IO block primitives. The proposed approach using the controller
-- core is to synthesize the core separately and provide the customer with
-- a EDIF netlist "ddr_sdr.edn". The customer then links to the EDIF netlist
-- by means of this wrapper file.
-- 
-- For synthesis, the core component 'ddr_core' is treated as a black box which
-- will be replaced by the actual netlist during place-and-route.
-- 
-- For Xilinx architectures synthesizers will generate IOB primitives
-- for the external pins connected to the controller instance. Due to this, any
-- tristate output buffer must be provided in this wrapper file.
-- 



library ieee;
use ieee.std_logic_1164.all;  
library Common_HDL;

entity ddr_wrapper is
   port (
      clk                   : in std_logic;   
      clk270                : in std_logic;   
      ddr_rdata_clk         : in std_logic;  -- clock for read data capture

      areset                : in std_logic;  -- synchronous reset for 'sys_clk', released after 'clk' is stable

      -- user interface
      u_cmd                 : in std_logic_vector(1 downto 0);
      u_cmd_valid           : in std_logic;
      u_addr                : in std_logic_vector(27 downto 0);
      u_busy_q              : out std_logic;
      
      -- write data
      data_in               : in std_logic_vector(127 downto 0);
      data_req_q            : out std_logic;
      -- read data
      data_out_q            : out std_logic_vector(127 downto 0);
      data_vld_q            : out std_logic;

      -- DDR SDRAM signals
      ddr_clk               : out std_logic;
      ddr_clk_n             : out std_logic;
      ddr_cke               : out std_logic_vector(1 downto 0);
      ddr_cs_n              : out std_logic_vector(1 downto 0);
      ddr_ras_n             : out std_logic;
      ddr_cas_n             : out std_logic;
      ddr_we_n              : out std_logic;
      ddr_reset_n           : out std_logic;
      ddr_dqs               : out std_logic_vector(15 downto 0);
      ddr_ba                : out std_logic_vector(1 downto 0);
      ddr_a                 : out std_logic_vector(12 downto 0);
      ddr_d                 : inout std_logic_vector(63 downto 0)
   );
end;


library ieee;
use IEEE.std_logic_arith.all;
-- pragma translate_off
library unisim;
--library ddr_lib;
--use ieee.math_real.all;
-- pragma translate_on
architecture virtexii of ddr_wrapper is

   component ddr_core
      port (
         clk                   : in std_logic;
         clk90                 : in std_logic := '0';  -- unused
         clk270                : in std_logic;
         ddr_rdata_clk         : in std_logic;

         sinit                 : in std_logic;  -- synchronous reset
         
         -- user interface
         u_cmd                 : in std_logic_vector(1 downto 0);
         u_cmd_valid           : in std_logic;
         u_addr                : in std_logic_vector(27 downto 0);
         u_autopre             : in std_logic;
         u_port                : in std_logic_vector(0 downto 0);
         u_busy_q              : out std_logic;
         
         -- user data interface
         data_in               : in std_logic_vector(127 downto 0);
         data_mask             : in std_logic_vector(15 downto 0) := (others => '0');
         data_req_q            : out std_logic_vector(0 downto 0);
         data_out_q            : out std_logic_vector(127 downto 0);
         data_vld_q            : out std_logic_vector(0 downto 0);

         -- DDR SDRAM signals
         ddr_cke               : out std_logic_vector(1 downto 0);
         ddr_cs_n              : out std_logic_vector(1 downto 0);
         ddr_ras_n             : out std_logic;
         ddr_cas_n             : out std_logic;
         ddr_we_n              : out std_logic;
         ddr_ba                : out std_logic_vector(1 downto 0);
         ddr_a                 : out std_logic_vector(12 downto 0);
         ddr_din               : in  std_logic_vector(127 downto 0);  -- data bus input
         ddr_dout              : out std_logic_vector(127 downto 0);  -- data bus output
         ddr_data_tri          : out std_logic_vector(63 downto 0);  -- data bus tristate control
         ddr_data_mask         : out std_logic_vector(15 downto 0);
         ddr_dqs_out           : out std_logic_vector(31 downto 0);
         ddr_dqs_tri           : out std_logic_vector(15 downto 0);    -- dqs tristate control
         ddr_dqs_in            : in  std_logic_vector(15 downto 0) := (others => '0')
         );
   end component;
   -- pragma translate_off
   --for all: ddr_core use entity ddr_lib.ddr_core;
   -- pragma translate_on

   constant tCO : time := 2050 ps; -- clock-to-output delay of Virtex2 IOB 
   
   signal sdram_cke,   ddr_cke_q    : std_logic_vector(1 downto 0);
   signal sdram_cs_n,  ddr_cs_qn    : std_logic_vector(1 downto 0);
   signal sdram_ras_n, ddr_ras_qn   : std_logic;
   signal sdram_cas_n, ddr_cas_qn   : std_logic;
   signal sdram_we_n,  ddr_we_qn    : std_logic;
   signal sdram_ba,    ddr_ba_q     : std_logic_vector(1 downto 0);
   signal sdram_a,     ddr_a_q      : std_logic_vector(12 downto 0);
   
   signal ddr_din       : std_logic_vector(127 downto 0);
   signal ddr_dout      : std_logic_vector(127 downto 0);
   signal ddr_data_tri  : std_logic_vector(63 downto 0);
   signal ddr_data_mask : std_logic_vector(15 downto 0);
   signal ddr_dqs_out   : std_logic_vector(31 downto 0);
   signal ddr_dqs_tri   : std_logic_vector(15 downto 0);
   
   signal data_req_int    : std_logic_vector(0 downto 0);
   signal data_vld_int    : std_logic_vector(0 downto 0);
   
   component fd
      -- pragma translate_off
      generic ( INIT : bit := '0' );
      -- pragma translate_on
      port (
         Q : out std_ulogic;
         C : in std_ulogic;
         D : in std_ulogic
         );
   end component;
   
   component fd_1
      -- pragma translate_off
      generic ( INIT : bit := '0' );
      -- pragma translate_on
      port (
         Q : out std_ulogic;
         C : in std_ulogic;
         D : in std_ulogic
         );
   end component;
   
   -- pragma translate_off
   for all: fd use entity unisim.fd;
   for all: fd_1 use entity unisim.fd_1;
   -- pragma translate_on

--   -- XST synthesis constraint: ensure placement of flipflop in IOB
--   attribute iob : string;
--   attribute iob of fd : component is "true";
--   attribute iob of fd_1 : component is "true";
   
   -- XST synthesis constraint
   attribute box_type : string;
   attribute box_type of fd : component is "black_box";
   attribute box_type of fd_1 : component is "black_box";

   
--   attribute keep_hierarchy : boolean;
--   attribute keep_hierarchy of ddr1: label is true;

   signal sinit : std_logic;
   
begin
	sync_RESET : entity double_sync
	port map(d => ARESET, q => sinit, reset => '0', clk => CLK);   

   
   ddr1 : ddr_core
      port map (
         clk                   => clk,
         clk270                => clk270,
         ddr_rdata_clk         => ddr_rdata_clk,
         
         sinit                 => sinit,
         
         u_cmd                 => u_cmd,
         u_cmd_valid           => u_cmd_valid,
         u_addr                => u_addr,
         u_autopre             => '0',
         u_port(0)             => '0',
         u_busy_q              => u_busy_q,
         
         data_in               => data_in,
         data_req_q            => data_req_int,
         data_out_q            => data_out_q,
         data_vld_q            => data_vld_int,

         ddr_cke               => sdram_cke,
         ddr_cs_n              => sdram_cs_n,
         ddr_ras_n             => sdram_ras_n,
         ddr_cas_n             => sdram_cas_n,
         ddr_we_n              => sdram_we_n,
         ddr_ba                => sdram_ba,
         ddr_a                 => sdram_a,
         ddr_din               => ddr_din,
         ddr_dout              => ddr_dout,
         ddr_data_tri          => ddr_data_tri,
         ddr_data_mask         => ddr_data_mask,
         ddr_dqs_out           => ddr_dqs_out,
         ddr_dqs_tri           => ddr_dqs_tri,
         ddr_dqs_in            => open
      );
   

   data_req_q <= data_req_int(0);
   data_vld_q <= data_vld_int(0);


   --------------------------------------------------------------------------------
   -- generate differential DDR SDRAM clock signals
   --------------------------------------------------------------------------------
   fddr_clk_inst0 : entity work.my_fddr
      port map( d0 => '1',
                d1 => '0',
                ce => '1',
                c0 => clk270,
                r  => '0',
                s  => '0',
                q  => ddr_clk );
   
   fddr_clkn_inst0 : entity work.my_fddr
      port map( d0 => '0',
                d1 => '1',
                ce => '1',
                c0 => clk270,
                r  => '0',
                s  => '0',
                q  => ddr_clk_n );
   

   --------------------------------------------------------------------------------
   -- output flip flops for addresses and control signals
   --------------------------------------------------------------------------------
   fd_cke_inst0: fd port map ( Q => ddr_cke_q(0), D => sdram_cke(0), C => clk );
   fd_cs_inst0: fd port map ( Q => ddr_cs_qn(0), D => sdram_cs_n(0), C => clk );
   fd_cke_inst1: fd port map ( Q => ddr_cke_q(1), D => sdram_cke(1), C => clk );
   fd_cs_inst1: fd port map ( Q => ddr_cs_qn(1), D => sdram_cs_n(1), C => clk );
   fd_ras_inst: fd port map ( Q => ddr_ras_qn, D => sdram_ras_n, C => clk );
   fd_cas_inst: fd port map ( Q => ddr_cas_qn, D => sdram_cas_n, C => clk );
   fd_we_inst: fd port map ( Q => ddr_we_qn, D => sdram_we_n, C => clk );
   fd_ba_inst0: fd port map ( Q => ddr_ba_q(0), D => sdram_ba(0), C => clk );
   fd_ba_inst1: fd port map ( Q => ddr_ba_q(1), D => sdram_ba(1), C => clk );
   fd_addr_inst0: fd port map ( Q => ddr_a_q(0), D => sdram_a(0), C => clk );
   fd_addr_inst1: fd port map ( Q => ddr_a_q(1), D => sdram_a(1), C => clk );
   fd_addr_inst2: fd port map ( Q => ddr_a_q(2), D => sdram_a(2), C => clk );
   fd_addr_inst3: fd port map ( Q => ddr_a_q(3), D => sdram_a(3), C => clk );
   fd_addr_inst4: fd port map ( Q => ddr_a_q(4), D => sdram_a(4), C => clk );
   fd_addr_inst5: fd port map ( Q => ddr_a_q(5), D => sdram_a(5), C => clk );
   fd_addr_inst6: fd port map ( Q => ddr_a_q(6), D => sdram_a(6), C => clk );
   fd_addr_inst7: fd port map ( Q => ddr_a_q(7), D => sdram_a(7), C => clk );
   fd_addr_inst8: fd port map ( Q => ddr_a_q(8), D => sdram_a(8), C => clk );
   fd_addr_inst9: fd port map ( Q => ddr_a_q(9), D => sdram_a(9), C => clk );
   fd_addr_inst10: fd port map ( Q => ddr_a_q(10), D => sdram_a(10), C => clk );
   fd_addr_inst11: fd port map ( Q => ddr_a_q(11), D => sdram_a(11), C => clk );
   fd_addr_inst12: fd port map ( Q => ddr_a_q(12), D => sdram_a(12), C => clk );
   
   -- clk-to-out delay model
   ddr_cke <= ddr_cke_q after tCO;
   ddr_cs_n <= ddr_cs_qn after tCO;
   ddr_ras_n <= ddr_ras_qn after tCO;
   ddr_cas_n <= ddr_cas_qn after tCO;
   ddr_we_n <= ddr_we_qn after tCO;
   ddr_ba <= ddr_ba_q after tCO;
   ddr_a <= ddr_a_q after tCO;





   -- asynchronous reset for Registered DIMM, released after FPGA is configured
   -- Note: ddr_reset_n should be pulled down on the PCB with an external resistor
   ddr_reset_n <= '1';


   
   --------------------------------------------------------------------------------
   -- Capture read data with 'ddr_rdata_clk'
   --------------------------------------------------------------------------------
   
   -- CL=2 and CL=3 : register even words (0,2,4,6)
   -- CL=2.5        : register odd words (1,3,5,7)
   fd_din_inst0: fd port map ( Q => ddr_din(0), D => ddr_d(0), C => ddr_rdata_clk );
   fd_din_inst1: fd port map ( Q => ddr_din(1), D => ddr_d(1), C => ddr_rdata_clk );
   fd_din_inst2: fd port map ( Q => ddr_din(2), D => ddr_d(2), C => ddr_rdata_clk );
   fd_din_inst3: fd port map ( Q => ddr_din(3), D => ddr_d(3), C => ddr_rdata_clk );
   fd_din_inst4: fd port map ( Q => ddr_din(4), D => ddr_d(4), C => ddr_rdata_clk );
   fd_din_inst5: fd port map ( Q => ddr_din(5), D => ddr_d(5), C => ddr_rdata_clk );
   fd_din_inst6: fd port map ( Q => ddr_din(6), D => ddr_d(6), C => ddr_rdata_clk );
   fd_din_inst7: fd port map ( Q => ddr_din(7), D => ddr_d(7), C => ddr_rdata_clk );
   fd_din_inst8: fd port map ( Q => ddr_din(8), D => ddr_d(8), C => ddr_rdata_clk );
   fd_din_inst9: fd port map ( Q => ddr_din(9), D => ddr_d(9), C => ddr_rdata_clk );
   fd_din_inst10: fd port map ( Q => ddr_din(10), D => ddr_d(10), C => ddr_rdata_clk );
   fd_din_inst11: fd port map ( Q => ddr_din(11), D => ddr_d(11), C => ddr_rdata_clk );
   fd_din_inst12: fd port map ( Q => ddr_din(12), D => ddr_d(12), C => ddr_rdata_clk );
   fd_din_inst13: fd port map ( Q => ddr_din(13), D => ddr_d(13), C => ddr_rdata_clk );
   fd_din_inst14: fd port map ( Q => ddr_din(14), D => ddr_d(14), C => ddr_rdata_clk );
   fd_din_inst15: fd port map ( Q => ddr_din(15), D => ddr_d(15), C => ddr_rdata_clk );
   fd_din_inst16: fd port map ( Q => ddr_din(16), D => ddr_d(16), C => ddr_rdata_clk );
   fd_din_inst17: fd port map ( Q => ddr_din(17), D => ddr_d(17), C => ddr_rdata_clk );
   fd_din_inst18: fd port map ( Q => ddr_din(18), D => ddr_d(18), C => ddr_rdata_clk );
   fd_din_inst19: fd port map ( Q => ddr_din(19), D => ddr_d(19), C => ddr_rdata_clk );
   fd_din_inst20: fd port map ( Q => ddr_din(20), D => ddr_d(20), C => ddr_rdata_clk );
   fd_din_inst21: fd port map ( Q => ddr_din(21), D => ddr_d(21), C => ddr_rdata_clk );
   fd_din_inst22: fd port map ( Q => ddr_din(22), D => ddr_d(22), C => ddr_rdata_clk );
   fd_din_inst23: fd port map ( Q => ddr_din(23), D => ddr_d(23), C => ddr_rdata_clk );
   fd_din_inst24: fd port map ( Q => ddr_din(24), D => ddr_d(24), C => ddr_rdata_clk );
   fd_din_inst25: fd port map ( Q => ddr_din(25), D => ddr_d(25), C => ddr_rdata_clk );
   fd_din_inst26: fd port map ( Q => ddr_din(26), D => ddr_d(26), C => ddr_rdata_clk );
   fd_din_inst27: fd port map ( Q => ddr_din(27), D => ddr_d(27), C => ddr_rdata_clk );
   fd_din_inst28: fd port map ( Q => ddr_din(28), D => ddr_d(28), C => ddr_rdata_clk );
   fd_din_inst29: fd port map ( Q => ddr_din(29), D => ddr_d(29), C => ddr_rdata_clk );
   fd_din_inst30: fd port map ( Q => ddr_din(30), D => ddr_d(30), C => ddr_rdata_clk );
   fd_din_inst31: fd port map ( Q => ddr_din(31), D => ddr_d(31), C => ddr_rdata_clk );
   fd_din_inst32: fd port map ( Q => ddr_din(32), D => ddr_d(32), C => ddr_rdata_clk );
   fd_din_inst33: fd port map ( Q => ddr_din(33), D => ddr_d(33), C => ddr_rdata_clk );
   fd_din_inst34: fd port map ( Q => ddr_din(34), D => ddr_d(34), C => ddr_rdata_clk );
   fd_din_inst35: fd port map ( Q => ddr_din(35), D => ddr_d(35), C => ddr_rdata_clk );
   fd_din_inst36: fd port map ( Q => ddr_din(36), D => ddr_d(36), C => ddr_rdata_clk );
   fd_din_inst37: fd port map ( Q => ddr_din(37), D => ddr_d(37), C => ddr_rdata_clk );
   fd_din_inst38: fd port map ( Q => ddr_din(38), D => ddr_d(38), C => ddr_rdata_clk );
   fd_din_inst39: fd port map ( Q => ddr_din(39), D => ddr_d(39), C => ddr_rdata_clk );
   fd_din_inst40: fd port map ( Q => ddr_din(40), D => ddr_d(40), C => ddr_rdata_clk );
   fd_din_inst41: fd port map ( Q => ddr_din(41), D => ddr_d(41), C => ddr_rdata_clk );
   fd_din_inst42: fd port map ( Q => ddr_din(42), D => ddr_d(42), C => ddr_rdata_clk );
   fd_din_inst43: fd port map ( Q => ddr_din(43), D => ddr_d(43), C => ddr_rdata_clk );
   fd_din_inst44: fd port map ( Q => ddr_din(44), D => ddr_d(44), C => ddr_rdata_clk );
   fd_din_inst45: fd port map ( Q => ddr_din(45), D => ddr_d(45), C => ddr_rdata_clk );
   fd_din_inst46: fd port map ( Q => ddr_din(46), D => ddr_d(46), C => ddr_rdata_clk );
   fd_din_inst47: fd port map ( Q => ddr_din(47), D => ddr_d(47), C => ddr_rdata_clk );
   fd_din_inst48: fd port map ( Q => ddr_din(48), D => ddr_d(48), C => ddr_rdata_clk );
   fd_din_inst49: fd port map ( Q => ddr_din(49), D => ddr_d(49), C => ddr_rdata_clk );
   fd_din_inst50: fd port map ( Q => ddr_din(50), D => ddr_d(50), C => ddr_rdata_clk );
   fd_din_inst51: fd port map ( Q => ddr_din(51), D => ddr_d(51), C => ddr_rdata_clk );
   fd_din_inst52: fd port map ( Q => ddr_din(52), D => ddr_d(52), C => ddr_rdata_clk );
   fd_din_inst53: fd port map ( Q => ddr_din(53), D => ddr_d(53), C => ddr_rdata_clk );
   fd_din_inst54: fd port map ( Q => ddr_din(54), D => ddr_d(54), C => ddr_rdata_clk );
   fd_din_inst55: fd port map ( Q => ddr_din(55), D => ddr_d(55), C => ddr_rdata_clk );
   fd_din_inst56: fd port map ( Q => ddr_din(56), D => ddr_d(56), C => ddr_rdata_clk );
   fd_din_inst57: fd port map ( Q => ddr_din(57), D => ddr_d(57), C => ddr_rdata_clk );
   fd_din_inst58: fd port map ( Q => ddr_din(58), D => ddr_d(58), C => ddr_rdata_clk );
   fd_din_inst59: fd port map ( Q => ddr_din(59), D => ddr_d(59), C => ddr_rdata_clk );
   fd_din_inst60: fd port map ( Q => ddr_din(60), D => ddr_d(60), C => ddr_rdata_clk );
   fd_din_inst61: fd port map ( Q => ddr_din(61), D => ddr_d(61), C => ddr_rdata_clk );
   fd_din_inst62: fd port map ( Q => ddr_din(62), D => ddr_d(62), C => ddr_rdata_clk );
   fd_din_inst63: fd port map ( Q => ddr_din(63), D => ddr_d(63), C => ddr_rdata_clk );

      
   -- CL=2 and CL=3 : register odd words (1,3,5,7)
   -- CL=2.5        : register even words (0,2,4,6)
   fd_ddr_din_inst0: fd_1 port map ( Q => ddr_din(64), D => ddr_d(0), C => ddr_rdata_clk );
   fd_ddr_din_inst1: fd_1 port map ( Q => ddr_din(65), D => ddr_d(1), C => ddr_rdata_clk );
   fd_ddr_din_inst2: fd_1 port map ( Q => ddr_din(66), D => ddr_d(2), C => ddr_rdata_clk );
   fd_ddr_din_inst3: fd_1 port map ( Q => ddr_din(67), D => ddr_d(3), C => ddr_rdata_clk );
   fd_ddr_din_inst4: fd_1 port map ( Q => ddr_din(68), D => ddr_d(4), C => ddr_rdata_clk );
   fd_ddr_din_inst5: fd_1 port map ( Q => ddr_din(69), D => ddr_d(5), C => ddr_rdata_clk );
   fd_ddr_din_inst6: fd_1 port map ( Q => ddr_din(70), D => ddr_d(6), C => ddr_rdata_clk );
   fd_ddr_din_inst7: fd_1 port map ( Q => ddr_din(71), D => ddr_d(7), C => ddr_rdata_clk );
   fd_ddr_din_inst8: fd_1 port map ( Q => ddr_din(72), D => ddr_d(8), C => ddr_rdata_clk );
   fd_ddr_din_inst9: fd_1 port map ( Q => ddr_din(73), D => ddr_d(9), C => ddr_rdata_clk );
   fd_ddr_din_inst10: fd_1 port map ( Q => ddr_din(74), D => ddr_d(10), C => ddr_rdata_clk );
   fd_ddr_din_inst11: fd_1 port map ( Q => ddr_din(75), D => ddr_d(11), C => ddr_rdata_clk );
   fd_ddr_din_inst12: fd_1 port map ( Q => ddr_din(76), D => ddr_d(12), C => ddr_rdata_clk );
   fd_ddr_din_inst13: fd_1 port map ( Q => ddr_din(77), D => ddr_d(13), C => ddr_rdata_clk );
   fd_ddr_din_inst14: fd_1 port map ( Q => ddr_din(78), D => ddr_d(14), C => ddr_rdata_clk );
   fd_ddr_din_inst15: fd_1 port map ( Q => ddr_din(79), D => ddr_d(15), C => ddr_rdata_clk );
   fd_ddr_din_inst16: fd_1 port map ( Q => ddr_din(80), D => ddr_d(16), C => ddr_rdata_clk );
   fd_ddr_din_inst17: fd_1 port map ( Q => ddr_din(81), D => ddr_d(17), C => ddr_rdata_clk );
   fd_ddr_din_inst18: fd_1 port map ( Q => ddr_din(82), D => ddr_d(18), C => ddr_rdata_clk );
   fd_ddr_din_inst19: fd_1 port map ( Q => ddr_din(83), D => ddr_d(19), C => ddr_rdata_clk );
   fd_ddr_din_inst20: fd_1 port map ( Q => ddr_din(84), D => ddr_d(20), C => ddr_rdata_clk );
   fd_ddr_din_inst21: fd_1 port map ( Q => ddr_din(85), D => ddr_d(21), C => ddr_rdata_clk );
   fd_ddr_din_inst22: fd_1 port map ( Q => ddr_din(86), D => ddr_d(22), C => ddr_rdata_clk );
   fd_ddr_din_inst23: fd_1 port map ( Q => ddr_din(87), D => ddr_d(23), C => ddr_rdata_clk );
   fd_ddr_din_inst24: fd_1 port map ( Q => ddr_din(88), D => ddr_d(24), C => ddr_rdata_clk );
   fd_ddr_din_inst25: fd_1 port map ( Q => ddr_din(89), D => ddr_d(25), C => ddr_rdata_clk );
   fd_ddr_din_inst26: fd_1 port map ( Q => ddr_din(90), D => ddr_d(26), C => ddr_rdata_clk );
   fd_ddr_din_inst27: fd_1 port map ( Q => ddr_din(91), D => ddr_d(27), C => ddr_rdata_clk );
   fd_ddr_din_inst28: fd_1 port map ( Q => ddr_din(92), D => ddr_d(28), C => ddr_rdata_clk );
   fd_ddr_din_inst29: fd_1 port map ( Q => ddr_din(93), D => ddr_d(29), C => ddr_rdata_clk );
   fd_ddr_din_inst30: fd_1 port map ( Q => ddr_din(94), D => ddr_d(30), C => ddr_rdata_clk );
   fd_ddr_din_inst31: fd_1 port map ( Q => ddr_din(95), D => ddr_d(31), C => ddr_rdata_clk );
   fd_ddr_din_inst32: fd_1 port map ( Q => ddr_din(96), D => ddr_d(32), C => ddr_rdata_clk );
   fd_ddr_din_inst33: fd_1 port map ( Q => ddr_din(97), D => ddr_d(33), C => ddr_rdata_clk );
   fd_ddr_din_inst34: fd_1 port map ( Q => ddr_din(98), D => ddr_d(34), C => ddr_rdata_clk );
   fd_ddr_din_inst35: fd_1 port map ( Q => ddr_din(99), D => ddr_d(35), C => ddr_rdata_clk );
   fd_ddr_din_inst36: fd_1 port map ( Q => ddr_din(100), D => ddr_d(36), C => ddr_rdata_clk );
   fd_ddr_din_inst37: fd_1 port map ( Q => ddr_din(101), D => ddr_d(37), C => ddr_rdata_clk );
   fd_ddr_din_inst38: fd_1 port map ( Q => ddr_din(102), D => ddr_d(38), C => ddr_rdata_clk );
   fd_ddr_din_inst39: fd_1 port map ( Q => ddr_din(103), D => ddr_d(39), C => ddr_rdata_clk );
   fd_ddr_din_inst40: fd_1 port map ( Q => ddr_din(104), D => ddr_d(40), C => ddr_rdata_clk );
   fd_ddr_din_inst41: fd_1 port map ( Q => ddr_din(105), D => ddr_d(41), C => ddr_rdata_clk );
   fd_ddr_din_inst42: fd_1 port map ( Q => ddr_din(106), D => ddr_d(42), C => ddr_rdata_clk );
   fd_ddr_din_inst43: fd_1 port map ( Q => ddr_din(107), D => ddr_d(43), C => ddr_rdata_clk );
   fd_ddr_din_inst44: fd_1 port map ( Q => ddr_din(108), D => ddr_d(44), C => ddr_rdata_clk );
   fd_ddr_din_inst45: fd_1 port map ( Q => ddr_din(109), D => ddr_d(45), C => ddr_rdata_clk );
   fd_ddr_din_inst46: fd_1 port map ( Q => ddr_din(110), D => ddr_d(46), C => ddr_rdata_clk );
   fd_ddr_din_inst47: fd_1 port map ( Q => ddr_din(111), D => ddr_d(47), C => ddr_rdata_clk );
   fd_ddr_din_inst48: fd_1 port map ( Q => ddr_din(112), D => ddr_d(48), C => ddr_rdata_clk );
   fd_ddr_din_inst49: fd_1 port map ( Q => ddr_din(113), D => ddr_d(49), C => ddr_rdata_clk );
   fd_ddr_din_inst50: fd_1 port map ( Q => ddr_din(114), D => ddr_d(50), C => ddr_rdata_clk );
   fd_ddr_din_inst51: fd_1 port map ( Q => ddr_din(115), D => ddr_d(51), C => ddr_rdata_clk );
   fd_ddr_din_inst52: fd_1 port map ( Q => ddr_din(116), D => ddr_d(52), C => ddr_rdata_clk );
   fd_ddr_din_inst53: fd_1 port map ( Q => ddr_din(117), D => ddr_d(53), C => ddr_rdata_clk );
   fd_ddr_din_inst54: fd_1 port map ( Q => ddr_din(118), D => ddr_d(54), C => ddr_rdata_clk );
   fd_ddr_din_inst55: fd_1 port map ( Q => ddr_din(119), D => ddr_d(55), C => ddr_rdata_clk );
   fd_ddr_din_inst56: fd_1 port map ( Q => ddr_din(120), D => ddr_d(56), C => ddr_rdata_clk );
   fd_ddr_din_inst57: fd_1 port map ( Q => ddr_din(121), D => ddr_d(57), C => ddr_rdata_clk );
   fd_ddr_din_inst58: fd_1 port map ( Q => ddr_din(122), D => ddr_d(58), C => ddr_rdata_clk );
   fd_ddr_din_inst59: fd_1 port map ( Q => ddr_din(123), D => ddr_d(59), C => ddr_rdata_clk );
   fd_ddr_din_inst60: fd_1 port map ( Q => ddr_din(124), D => ddr_d(60), C => ddr_rdata_clk );
   fd_ddr_din_inst61: fd_1 port map ( Q => ddr_din(125), D => ddr_d(61), C => ddr_rdata_clk );
   fd_ddr_din_inst62: fd_1 port map ( Q => ddr_din(126), D => ddr_d(62), C => ddr_rdata_clk );
   fd_ddr_din_inst63: fd_1 port map ( Q => ddr_din(127), D => ddr_d(63), C => ddr_rdata_clk );

      



   -- instantiate data output buffers
   gen_data : for n in 0 to 63 generate
      fddr : entity work.my_fddr_tri
         port map( d0 => ddr_dout(64 + n),
                   d1 => ddr_dout(n),
                   ce => '1',
                   c0 => clk,
                   r  => '0',
                   s  => '0',
                   t  => ddr_data_tri(n),
                   o  => ddr_d(n) );
   end generate;



   -- instantiate dqs output buffers
   gen_dqs : for n in 0 to 15 generate
      fddr : entity work.my_fddr_tri
         port map( d0 => ddr_dqs_out(n),
                   d1 => ddr_dqs_out(16 + n),
                   ce => '1',
                   c0 => clk270,
                   r  => '0',
                   s  => '0',
                   t  => ddr_dqs_tri(n),
                   o  => ddr_dqs(n) );
   end generate;
   
end architecture;      

-- pragma translate_off 
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

architecture asim of ddr_wrapper is                                  
   constant WR : std_logic_vector(1 downto 0) := "10";
   constant RD : std_logic_vector(1 downto 0) := "01";      
   constant MEMSIZE : integer := 12;
   
   type ram_type is array ((2**MEMSIZE)-1 downto 0) of std_logic_vector (127 downto 0);   
   
   signal addr : std_logic_vector(MEMSIZE-1 downto 0);
   signal cmd_valid : std_logic;
   signal busy_q : std_logic;   
   
   type t_data_out_pipe is array (1 downto 0) of std_logic_vector (127 downto 0);   
   signal data_out_pipe : t_data_out_pipe;
   signal data_vld_pipe : std_logic_vector(1 downto 0);
   
begin
   --addr <= u_addr(27 downto 20) & u_addr(MEMSIZE-8 downto 1);
   addr <= u_addr(27 downto 25) & u_addr(MEMSIZE-3 downto 1);
   cmd_valid <= u_cmd_valid and not busy_q;
   u_busy_q <= busy_q;
   
   main_process: process (clk)
      variable RAM : ram_type;   
   begin  
      if rising_edge(clk) then
         if areset = '1' then            
            busy_q <= '1';
            data_vld_q <= '0';
            data_req_q <= '0';
            data_vld_pipe <= (others => '0');
         else
            -- Read Pipeline
            data_out_q   <= data_out_pipe(0);
            data_out_pipe(0) <= data_out_pipe(1);
            data_vld_q <= data_vld_pipe(0);
            data_vld_pipe(0) <= data_vld_pipe(1);
            
            
            -- Default values
            busy_q <= '0';
            data_vld_pipe(1) <= '0';
            data_req_q <= '0';            
            
            if cmd_valid = '1' then
               assert (u_addr(24 downto MEMSIZE-2) = 0) report "This memory address range is not supported by the simulation model." severity FAILURE;
               
               if u_cmd = RD then
                  data_out_pipe(1) <= RAM(conv_integer(addr)); 
                  data_vld_pipe(1) <= '1';
                  busy_q <= '1';
               elsif u_cmd = WR then
                  RAM(conv_integer(addr)) := data_in;   
                  data_req_q <= '1';            
                  busy_q <= '1';
               else
                  assert FALSE;
               end if;
            end if;            
            
         end if; -- if areset = '1'
      end if; -- if rising_edge(clk)
      
   end process;   
   
end asim;         
-- pragma translate_on

