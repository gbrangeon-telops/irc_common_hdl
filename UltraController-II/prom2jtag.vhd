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

entity prom2jtag is
  port (
    clk  : in    std_logic;
    rst  : in    std_logic;
    cclk : inout std_logic;
    din  : in    std_logic_vector(7 downto 0);
    tck  : out   std_logic;
    tms  : out   std_logic;
    tdi  : out   std_logic
    );
end prom2jtag;

architecture rtl of prom2jtag is

  signal rst16  : std_logic;
  signal rising : std_logic;

  signal tck0     : std_logic;
  signal tms0     : std_logic;
  signal tdi0     : std_logic;
  signal cclk0    : std_logic;
  signal cclk1    : std_logic;
  signal cclk2    : std_logic;
  signal cclk_gen : std_logic;
  signal cclk_tri : std_logic;
  signal cclk_s   : std_logic;
  signal q        : std_logic_vector(15 downto 0);
  signal din0     : std_logic_vector(7 downto 0);
  signal CS       : std_logic_vector(2 downto 0);
  signal cnt      : std_logic_vector(5 downto 0);


  constant waitDIN  : std_logic_vector(2 downto 0) := "000";
  constant getTDI   : std_logic_vector(2 downto 0) := "010";
  constant getTMS   : std_logic_vector(2 downto 0) := "011";
  constant clockTCK : std_logic_vector(2 downto 0) := "001";


begin
  tck    <= tck0;
  tms    <= tms0;
  tdi    <= tdi0;
  rising <= cclk1 and not cclk2;

-----------------------------------------------------------------------------------------------
-- Master Mode
-- Use this section for Master mode of operation:
-- CCLK tri-stated until bitstream loaded, then wait 16 cclk_gen cycles before driving CCLK
-----------------------------------------------------------------------------------------------
  cclk_s <= cclk_gen;

  shiftreg_tri : SRL16
    generic map (
      INIT => X"FFFF")
    port map (
      CLK  => cclk_gen,
      D    => '0',
      A0   => '1',
      A1   => '1',
      A2   => '1',
      A3   => '1',
      Q    => cclk_tri);

  process (cclk_gen, cclk_tri)
  begin
    if (cclk_tri = '0') then
      cclk <= cclk_gen;
    else
      cclk <= 'Z';
    end if;
  end process;
-----------------------------------------------------------------------------------------------
-- End of Master Mode
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
-- Slave Mode
-- Use this section for Slave mode operation:
-----------------------------------------------------------------------------------------------
--        cclk_s <= cclk;
-----------------------------------------------------------------------------------------------
-- End of section for Slave mode operation:
-----------------------------------------------------------------------------------------------


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
      Q    => rst16);

  process (clk, rst16)
  begin
    if (rst16 = '1') then
      cclk0      <= '0';
      cclk1      <= '1';
      cclk2      <= '1';
      tck0       <= '0';
      tms0       <= '0';
      tdi0       <= '0';
      cnt        <= "000000";
      cclk_gen   <= '0';
      CS         <= waitDIN;
    elsif (clk'event and clk = '1') then
      cclk0      <= cclk_s;
      cclk1      <= cclk0;
      cclk2      <= cclk1;
      cnt        <= cnt + 1;
      if (cnt = 31) then
        cclk_gen <= not cclk_gen;
      end if;

      
-----------------------------------------------------------------------------------------------
-- Serial State Machine
-- Use this state machine for Serial mode of operation
-----------------------------------------------------------------------------------------------
      if (CS = clockTCK) then
        tck0 <= '1';
      else
        tck0 <= '0';
      end if;

      if (CS = waitDIN and rising = '1' and din0(0) = '0') then
        CS <= getTDI;
      elsif (CS = getTMS and rising = '1') then
        tms0 <= din0(0);
        CS <= getTDI;
      elsif (CS = getTDI and rising = '1') then
        tdi0 <= din0(0); CS <= clockTCK;
      elsif (CS = clockTCK) then CS <= getTMS;
      end if;
-----------------------------------------------------------------------------------------------
-- End of Serial State Machine
-----------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
-- SelectMAP State Machine
-- Use this state machine for SelectMAP mode of operation
-----------------------------------------------------------------------------------------------
--              tck0 <= CS(0);
--              if      (CS = 0) then
--                tms0 <= din0(0);
--                tdi0 <= din0(1);
--              if (rising = '1') then
--                CS <= CS+1; end if;
--              elsif   (CS = 2) then
--                tms0 <= din0(2);
--                tdi0 <= din0(3);
--                CS <= CS+1;
--              elsif   (CS = 4) then
--                tms0 <= din0(4);
--                tdi0 <= din0(5);
--                CS <= CS+1;
--              elsif   (CS = 6) then
--                tms0 <= din0(6);
--                tdi0 <= din0(7);
--                CS <= CS+1; 
--              else
--                CS <= CS+1;
--              end if;
-----------------------------------------------------------------------------------------------
-- End of SelectMAP State Machine
-----------------------------------------------------------------------------------------------
    end if;
  end process;


  process (din, cclk_s)
  begin
    if (cclk_s = '0') then
      din0 <= din;
    end if;
  end process;

end rtl;
