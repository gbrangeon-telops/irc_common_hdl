---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: spi_rx.vhd
--  Use: general purpose spi slave interface
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_rx is
   generic(
      BITWIDTH : natural := 12);
   port(
      CLK  : in std_logic;
      DOUT : out std_logic_vector(BITWIDTH-1 downto 0);
      DVAL : out std_logic;
      CSn  : in std_logic;
      SDA  : in std_logic;
      SCL  : in std_logic);
end spi_rx;

architecture rtl of spi_rx is
   
   signal dreg : std_logic_vector(BITWIDTH-1 downto 0) := (others => '0');
   signal data_vld : std_logic_vector(BITWIDTH-1 downto 0) := (others => '0');
   
begin
   
   -- deserializing state machine
   deserializer_sm : process(CSn,SCL)
   begin
      if (CSn = '1') then                                     -- use CSn high as async reset
         data_vld <= (others => '0');
      elsif (SCL'event and SCL = '1') then
         if (CSn = '0') then
            data_vld <= data_vld(BITWIDTH-2 downto 0) & '1';  -- data_vld(BITWIDTH-1) will go high after last bit shifted in
            dreg <= dreg(BITWIDTH-2 downto 0) & SDA;          -- shift dreg left by the correct amount               
         end if;
      end if;
   end process deserializer_sm;
   
   -- resync to system clock
   resync : process(CLK)
      variable dval_dsync : std_logic_vector(2 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         if (dval_dsync(2) ='0' and dval_dsync(1) = '1') then
            DVAL <= '1';    -- DVAL is rising edge of resynced data_vld
            DOUT <= dreg;   -- dreg will be stable for sampling by the time DVAL goes hi
         else
            DVAL <= '0';
         end if;
         dval_dsync := dval_dsync(1 downto 0) & data_vld(BITWIDTH-1);
      end if;
   end process resync;
   
end rtl;
