--//////////////////////////////////////////////////////////////////////////////
-- Module: UltraController2 - cache only
--//////////////////////////////////////////////////////////////////////////////
--
--     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION \"AS IS\"
--     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
--     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
--     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
--     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS
--     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
--     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
--     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
--     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
--     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
--     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
--     FOR A PARTICULAR PURPOSE.
--     
--     (c) Copyright 2005 Xilinx, Inc.
--     All rights reserved.
-- 
--//////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////
-- Filename:      prom2jtag
-- 
-- Description:    
-- Module instantiates a prom2jtag module for Demonstration 
-- of PROM loading of SW elf file into the UltraController2 caches
-- 
-- Design Notes:
--   
-- The design can be set to:
--      - Masterserial    (M2 M1 M0 = 000)
--      - Slaveserial     (M2 M1 M0 = 111)
--      - Masterselectmap (M2 M1 M0 = 011)
--      - Slaveselectmap  (M2 M1 M0 = 110)
--
-- Default mode is Masterserial
-- 
-- For Master mode, uncomment the Master mode section and comment out the Slave mode section
-- For Slave mode, uncomment the Slave mode section and comment out the Master mode section
--
-- For serial mode, comment out the Selectmap State Machine and uncomment the Serial State Machine
-- For Selectmap mode, comment out the Serial State Machine and uncomment the Selectmap State Machine
--
-- The Memec LC and LCV4 boards only support the Serial modes
--
-- For all modes: 
--      - The CCLK pin must be connected to FPGA's CCLK
--
-- For Selectmap: 
--      - The .ucf file will need the din<1> - din<7> pins and 
--        pull-ups added (uncommented)
--      - The FPGA pins CS_B and RDWR_B must be grounded
--
-- For Slave modes:
--     - An external 4 MHz signal must be connected to CCLK
-- 
--
--//////////////////////////////////////////////////////////////////////////////
--//////////////////////////////////////////////////////////////////////////////
-- Author:      APD/SEG         
-- History:     2005.06.06 - Initial release
-- 
--
--//////////////////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

entity prom2uar is
  port (
    clk  : in    std_logic;
    rst  : in    std_logic;
    tck  : out   std_logic;
    tms  : out   std_logic;
    tdi  : out   std_logic
    );
end prom2uar;

architecture rtl of prom2uar is

  signal cclk_gen : std_logic;
  signal cnt      : std_logic_vector(5 downto 0);

  signal rst_pwrup_delay   : std_logic;
  signal cclk_tri   : std_logic;
  signal uar_done   : std_logic;

  component uar_load
    port (
      clk  : in    std_logic;
      rst  : in    std_logic;
      tck  : out   std_logic;
      tms  : out   std_logic;
      tdi  : out   std_logic;
      uar_data_out  : out   std_logic_vector(31 downto 0);
      uar_datavalid  : out   std_logic;
      uar_done  : out   std_logic
      );
  end component;


begin

--
-- Power up delay to match that of the PPC405 reset pwrup delay circuit   
--

  shiftreg : SRL16
    generic map (
      INIT => X"FFFF")
    port map (
      CLK  => clk,
      D    => rst,
      A0   => '1',
      A1   => '1',
      A2   => '1',
      A3   => '1',
      Q    => rst_pwrup_delay
      );

--
-- Instantiate UAR State machine logic
--   

  UAR_LOAD_I : uar_load
    port map (
      clk => clk, 
      rst => rst_pwrup_delay, 
      tck => tck, 
      tms => tms, 
      tdi => tdi, 
--      uar_data_out,
--      uar_datavalid, 
      uar_done => uar_done
      );

--
-- Generate CCLK from input system clk by dividing it by 32
-- Alternatively, a DCM could be used here to generate 
-- higher freqency cclk_gen signal if desired.
-- Please refer to XAP719 for restrictions of cclk_gen vs. the system clk.
--
  process (clk, rst_pwrup_delay)
  begin
    if (rst_pwrup_delay = '1') then
      cnt        <= "000000";
    elsif (clk'event and clk = '1') then
      cnt        <= cnt + 1;
    end if;
  end process;

  process (clk, rst_pwrup_delay)
  begin
    if (rst_pwrup_delay = '1') then
      cclk_gen   <= '0';
    elsif (clk'event and clk = '1') then
      if (cnt = 31) then
        cclk_gen <= not cclk_gen;
      end if;
    end if;
  end process;

--
-- Tri State the external CCLK pin immediately after device configuration.
-- Delay driving the external CCLK pin with cclk_gen by 16 internal 
-- cclk_gen cycles 
-- Then continuosly drive the CCLK pin with cclk_gen.
--
  shiftreg_cclk_tri : SRL16
    generic map (
      INIT => X"FFFF")
    port map (
      CLK  => cclk_gen,
      D    => '0',
      A0   => '1',
      A1   => '1',
      A2   => '1',
      A3   => '1',
      Q    => cclk_tri
      );


--
-- Instantiate Vitex-4 startup block to take control of DONE and CCLK pins  
--
  STARTUP_VIRTEX4_inst : STARTUP_VIRTEX4
    port map (
--      CLK => CLK,
--      GSR => GSR,
--      GTS => GTS,
      --USRCCLKO => cclk_gen,
      --USRCCLKTS => cclk_tri,
      USRDONEO => uar_done,
      USRDONETS => '0'
--      EOS => EOS
      );


end rtl;
