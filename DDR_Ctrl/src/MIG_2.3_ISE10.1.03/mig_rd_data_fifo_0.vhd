--*****************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a
-- license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as-is" solely for use in developing programs and
-- solutions for Xilinx devices, with no obligation on the
-- part of Xilinx to provide support. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are
-- done at the user's sole risk and will be unsupported.
--
-- Copyright (c) 2005-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part
-- of this text at all times.
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : 2.3
--  \   \        Application        : MIG
--  /   /        Filename           : mig_rd_data_fifo_0.vhd
-- /___/   /\    Date Last Modified : $Date$
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the distributed RAM which stores the read data
--              from the memory.
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mig_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mig_rd_data_fifo_0 is
  port(
    clk                  : in  std_logic;
    reset                : in  std_logic;
    read_en_delayed_rise : in  std_logic;
    read_en_delayed_fall : in  std_logic;
    first_rising         : in  std_logic;
    read_data_rise       : in  std_logic_vector(MEMORY_WIDTH - 1 downto 0);
    read_data_fall       : in  std_logic_vector(MEMORY_WIDTH - 1 downto 0);
    fifo_rd_enable       : in  std_logic;
    read_data_fifo_rise  : out std_logic_vector(MEMORY_WIDTH - 1 downto 0);
    read_data_fifo_fall  : out std_logic_vector(MEMORY_WIDTH - 1 downto 0);
    read_data_valid      : out std_logic
    );
end mig_rd_data_fifo_0;

architecture arch of mig_rd_data_fifo_0 is

  component mig_RAM_D_0
    port(
      dpo       : out std_logic_vector(MEMORY_WIDTH - 1 downto 0);
      a0        : in std_logic;
      a1        : in std_logic;
      a2        : in std_logic;
      a3        : in std_logic;
      d         : in std_logic_vector(MEMORY_WIDTH - 1 downto 0);
      dpra0     : in std_logic;
      dpra1     : in std_logic;
      dpra2     : in std_logic;
      dpra3     : in std_logic;
      wclk      : in std_logic;
      we        : in std_logic
      );
  end component;

  signal fifos_data_out1 : std_logic_vector((MEMORY_WIDTH*2 - 1) downto 0);
  signal fifo_rd_addr    : std_logic_vector(3 downto 0);
  signal rise0_wr_addr   : std_logic_vector(3 downto 0);
  signal fall0_wr_addr   : std_logic_vector(3 downto 0);
  signal fifo_rd_en      : std_logic;
  signal fifo_rd_en_r1   : std_logic;
  signal fifo_rd_en_r2   : std_logic;
  signal rise_fifo_data  : std_logic_vector((MEMORY_WIDTH - 1) downto 0);
  signal fall_fifo_data  : std_logic_vector((MEMORY_WIDTH - 1) downto 0);
  signal rise_fifo_out   : std_logic_vector((MEMORY_WIDTH - 1) downto 0);
  signal fall_fifo_out   : std_logic_vector((MEMORY_WIDTH - 1) downto 0);
  signal rst_r           : std_logic;

begin

  --***************************************************************************

  read_data_valid     <= fifo_rd_en_r2;
  read_data_fifo_fall <= fifos_data_out1(MEMORY_WIDTH - 1 downto 0);
  read_data_fifo_rise <= fifos_data_out1((MEMORY_WIDTH*2 - 1) downto MEMORY_WIDTH);

-- Read Pointer and fifo data output sequencing

-- Read Enable generation for fifos based on write enable


  process( clk)
  begin
    if(clk'event and clk = '1') then
      rst_r <= reset;
    end if;
  end process;

  process ( clk)
  begin
    if(clk'event and clk = '1') then
      if (rst_r = '1') then
        fifo_rd_en             <= '0';
        fifo_rd_en_r1          <= '0';
        fifo_rd_en_r2          <= '0';
      else
        fifo_rd_en             <= fifo_rd_enable;
        fifo_rd_en_r1          <= fifo_rd_en;
        fifo_rd_en_r2          <= fifo_rd_en_r1;
      end if;
    end if;
  end process;

-- Write Pointer increment for FIFOs

  process ( clk)
  begin
    if(clk'event and clk = '1') then
      if (rst_r = '1') then
        rise0_wr_addr <= "0000";
      elsif (read_en_delayed_rise = '1') then
        rise0_wr_addr <= rise0_wr_addr + '1';
      end if;
    end if;
  end process;

  process ( clk)
  begin
    if(clk'event and clk = '1') then
      if (rst_r = '1') then
        fall0_wr_addr <= "0000";
      elsif (read_en_delayed_fall = '1') then
        fall0_wr_addr <= fall0_wr_addr + '1';
      end if;
    end if;
  end process;

--********** FIFO Data Output Sequencing ***********

  process ( clk)
  begin
    if(clk'event and clk = '1') then
      if (rst_r = '1') then
        rise_fifo_data <= (others => '0');
        fall_fifo_data <= (others => '0');
        fifo_rd_addr   <= "0000";
      elsif (fifo_rd_en = '1') then
        rise_fifo_data(MEMORY_WIDTH - 1 downto 0) <= rise_fifo_out(MEMORY_WIDTH - 1 downto 0);
        fall_fifo_data(MEMORY_WIDTH - 1 downto 0) <= fall_fifo_out(MEMORY_WIDTH - 1 downto 0);
        fifo_rd_addr(3 downto 0)    <= fifo_rd_addr(3 downto 0) + '1';
      end if;
    end if;
  end process;

  process ( clk)
  begin
if(clk'event and clk = '1') then
     if (rst_r = '1') then
       fifos_data_out1((MEMORY_WIDTH*2 - 1) downto 0) <= (others => '0');
     elsif (fifo_rd_en_r1 = '1') then
         if (first_rising = '1') then
           fifos_data_out1((MEMORY_WIDTH*2 - 1) downto 0) <= fall_fifo_data((MEMORY_WIDTH - 1) downto 0)
                                                            & rise_fifo_data((MEMORY_WIDTH - 1) downto 0);
         else
           fifos_data_out1((MEMORY_WIDTH*2 - 1) downto 0) <= rise_fifo_data((MEMORY_WIDTH - 1) downto 0)
                                                            & fall_fifo_data((MEMORY_WIDTH - 1) downto 0);
         end if;
      end if;
 end if;
end process;

--******************************************************************************
-- Distributed RAM 4 bit wide FIFO instantiations (2 FIFOs per strobe, rising
-- edge data fifo and falling edge data fifo)
--******************************************************************************
-- FIFOs associated with DQS(0)

ram_rise0: mig_RAM_D_0 port map
            (
              dpo   => rise_fifo_out(MEMORY_WIDTH - 1 downto 0),
              a0    => rise0_wr_addr(0),
              a1    => rise0_wr_addr(1),
              a2    => rise0_wr_addr(2),
              a3    => rise0_wr_addr(3),
              d     => read_data_rise(MEMORY_WIDTH - 1 downto 0),
              dpra0 => fifo_rd_addr(0),
              dpra1 => fifo_rd_addr(1),
              dpra2 => fifo_rd_addr(2),
              dpra3 => fifo_rd_addr(3),
              wclk  => clk,
              we    => read_en_delayed_rise
            );

ram_fall0: mig_RAM_D_0 port map
            (
              dpo   => fall_fifo_out(MEMORY_WIDTH - 1 downto 0),
              a0    => fall0_wr_addr(0),
              a1    => fall0_wr_addr(1),
              a2    => fall0_wr_addr(2),
              a3    => fall0_wr_addr(3),
              d     => read_data_fall(MEMORY_WIDTH - 1 downto 0),
              dpra0 => fifo_rd_addr(0),
              dpra1 => fifo_rd_addr(1),
              dpra2 => fifo_rd_addr(2),
              dpra3 => fifo_rd_addr(3),
              wclk  => clk,
              we    => read_en_delayed_fall
            );

end arch;
