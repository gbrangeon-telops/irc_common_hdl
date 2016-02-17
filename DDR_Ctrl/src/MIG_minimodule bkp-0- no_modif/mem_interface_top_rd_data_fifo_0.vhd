-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_rd_data_fifo_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Instantiates the distributed RAM which stores the read data
--              from the memory.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_rd_data_fifo_0 is
  port(
    CLK                  : in  std_logic;
    RESET                : in  std_logic;
    READ_EN_DELAYED_RISE : in  std_logic;
    READ_EN_DELAYED_FALL : in  std_logic;
    FIRST_RISING         : in  std_logic;
    READ_DATA_RISE       : in  std_logic_vector(memory_width-1 downto 0);
    READ_DATA_FALL       : in  std_logic_vector(memory_width-1 downto 0);
    fifo_rd_enable       : in  std_logic;
    READ_DATA_FIFO_RISE  : out std_logic_vector(memory_width-1 downto 0);
    READ_DATA_FIFO_FALL  : out std_logic_vector(memory_width-1 downto 0);
    READ_DATA_VALID      : out std_logic
    );
end mem_interface_top_rd_data_fifo_0;

architecture arch of mem_interface_top_rd_data_fifo_0 is

  component mem_interface_top_RAM_D_0
    port(
      DPO       : out std_logic_vector(memory_width-1 downto 0);
      A0        : in std_logic;
      A1        : in std_logic;
      A2        : in std_logic;
      A3        : in std_logic;
      D         : in std_logic_vector(memory_width-1 downto 0);
      DPRA0     : in std_logic;
      DPRA1     : in std_logic;
      DPRA2     : in std_logic;
      DPRA3     : in std_logic;
      WCLK      : in std_logic;
      WE        : in std_logic
      );
  end component;

  signal fifos_data_out1 : std_logic_vector((memory_width*2 -1) downto 0);
  signal fifo_rd_addr    : std_logic_vector(3 downto 0);
  signal rise0_wr_addr   : std_logic_vector(3 downto 0);
  signal fall0_wr_addr   : std_logic_vector(3 downto 0);
  signal fifo_rd_en      : std_logic;
  signal fifo_rd_en_r1   : std_logic;
  signal fifo_rd_en_r2   : std_logic;
  signal rise_fifo_data  : std_logic_vector((memory_width -1) downto 0);
  signal fall_fifo_data  : std_logic_vector((memory_width -1) downto 0);
  signal rise_fifo_out   : std_logic_vector((memory_width -1) downto 0);
  signal fall_fifo_out   : std_logic_vector((memory_width -1) downto 0);
  signal rst_r           : std_logic;

begin

  READ_DATA_VALID     <= fifo_rd_en_r2;
  READ_DATA_FIFO_FALL <= fifos_data_out1(memory_width-1 downto 0);
  READ_DATA_FIFO_RISE <= fifos_data_out1((memory_width*2-1) downto memory_width);

-- Read Pointer and fifo data output sequencing

-- Read Enable generation for fifos based on write enable


  process( CLK)
  begin
    if(CLK'event and CLK = '1') then
      rst_r <= RESET;
    end if;
  end process;

  process ( CLK)
  begin
    if(CLK'event and CLK = '1') then
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

  process ( CLK)
  begin
    if(CLK'event and CLK = '1') then
      if (rst_r = '1') then
        rise0_wr_addr <= "0000";
      elsif (READ_EN_DELAYED_RISE = '1') then
        rise0_wr_addr <= rise0_wr_addr + '1';
      end if;
    end if;
  end process;

  process ( CLK)
  begin
    if(CLK'event and CLK = '1') then
      if (rst_r = '1') then
        fall0_wr_addr <= "0000";
      elsif (READ_EN_DELAYED_FALL = '1') then
        fall0_wr_addr <= fall0_wr_addr + '1';
      end if;
    end if;
  end process;

--********** FIFO Data Output Sequencing ***********

  process ( CLK)
  begin
    if(CLK'event and CLK = '1') then
      if (rst_r = '1') then
        rise_fifo_data <= (others => '0');
        fall_fifo_data <= (others => '0');
        fifo_rd_addr   <= "0000";
      elsif (fifo_rd_en = '1') then
        rise_fifo_data(memory_width-1 downto 0) <= rise_fifo_out(memory_width-1 downto 0);
        fall_fifo_data(memory_width-1 downto 0) <= fall_fifo_out(memory_width-1 downto 0);
        fifo_rd_addr(3 downto 0)    <= fifo_rd_addr(3 downto 0) + '1';
      end if;
    end if;
  end process;

  process ( CLK)
  begin
if(CLK'event and CLK = '1') then
     if (rst_r = '1') then
       fifos_data_out1((memory_width*2 -1) downto 0) <= (others => '0');
     elsif (fifo_rd_en_r1 = '1') then
         if (FIRST_RISING = '1') then
           fifos_data_out1((memory_width*2 -1) downto 0) <= fall_fifo_data((memory_width -1) downto 0)
                                                            & rise_fifo_data((memory_width -1) downto 0);
         else
           fifos_data_out1((memory_width*2 -1) downto 0) <= rise_fifo_data((memory_width -1) downto 0)
                                                            & fall_fifo_data((memory_width -1) downto 0);
         end if;
      end if;
 end if;
end process;

--******************************************************************************
-- Distributed RAM 4 bit wide FIFO instantiations (2 FIFOs per strobe, rising
-- edge data fifo and falling edge data fifo)
--******************************************************************************
-- FIFOs associated with DQS(0)

ram_rise0: mem_interface_top_RAM_D_0 port map
            (
              DPO   => rise_fifo_out(memory_width -1 downto 0),
              A0    => rise0_wr_addr(0),
              A1    => rise0_wr_addr(1),
              A2    => rise0_wr_addr(2),
              A3    => rise0_wr_addr(3),
              D     => READ_DATA_RISE(memory_width -1 downto 0),
              DPRA0 => fifo_rd_addr(0),
              DPRA1 => fifo_rd_addr(1),
              DPRA2 => fifo_rd_addr(2),
              DPRA3 => fifo_rd_addr(3),
              WCLK  => CLK,
              WE    => READ_EN_DELAYED_RISE
            );

ram_fall0: mem_interface_top_RAM_D_0 port map
            (
              DPO   => fall_fifo_out(memory_width -1 downto 0),
              A0    => fall0_wr_addr(0),
              A1    => fall0_wr_addr(1),
              A2    => fall0_wr_addr(2),
              A3    => fall0_wr_addr(3),
              D     => READ_DATA_FALL(memory_width -1 downto 0),
              DPRA0 => fifo_rd_addr(0),
              DPRA1 => fifo_rd_addr(1),
              DPRA2 => fifo_rd_addr(2),
              DPRA3 => fifo_rd_addr(3),
              WCLK  => CLK,
              WE    => READ_EN_DELAYED_FALL
            );

end arch;
