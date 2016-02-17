---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: spi_tx.vhd
--  Use: general purpose spi master interface (DACs etc...)
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Notes: core divides incoming clock by CLKDIV to generate SPI clock must be at least a factor
--         of 2
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_tx is
   generic(
      CLKDIV : natural := 4;
      BITWIDTH : natural := 12);
   port(
      CLK : in std_logic;
      DIN : in std_logic_vector(BITWIDTH-1 downto 0);
      STB : in std_logic;
      ACK : out std_logic;
      CSn : out std_logic;
      SDA : out std_logic;
      SCL : out std_logic);
end spi_tx;

architecture rtl of spi_tx is
   
   type spi_state_t is (IDLE, ENABLE, SHIFT, TOGGLE_CLOCK, WAITSTATE);
   signal spi_state : spi_state_t := IDLE;
   signal dreg : std_logic_vector(BITWIDTH-1 downto 0) := (others => '0');
   signal clk_en : std_logic;
   
begin
   
   -- clock division (at least by 2)
   clock_en_div : process(CLK)
      variable clkdiv_shr : unsigned((CLKDIV/2)-1 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         if (spi_state = IDLE) then
            clkdiv_shr := (0 => '1', others => '0');
         else
            clkdiv_shr := clkdiv_shr(0) & clkdiv_shr((CLKDIV/2)-1 downto 1);
         end if;
         clk_en <= clkdiv_shr(0);
      end if;
   end process clock_en_div;
   
   -- Map left bit of shift register to serial data out
   SDA <= dreg(BITWIDTH-1);
   
   -- describe the high speed SPI state machine (SCL at 1/2 system clock frequency)
   SPI_machine : process(CLK)
      variable bit_shr : std_logic_vector(BITWIDTH-1 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         case spi_state is
            
            when IDLE => -- pull CS low and load shift register when strobed
               ACK <= '0';
               if (STB = '1') then
                  dreg <= DIN;
                  CSn <= '0';
                  bit_shr := (0 => '1', others => '0');
                  spi_state <= ENABLE;
               else
                  CSn <= '1';
                  SCL <= '0';
               end if;
               
            when ENABLE => -- wait for tLEAD
               if (clk_en = '1') then
                  spi_state <= TOGGLE_CLOCK;
               end if;
               
            when SHIFT =>  -- pulse clock low and shift the register
               if (clk_en = '1') then
                  SCL <= '0';
                  if bit_shr(BITWIDTH-1) = '1' then
                     spi_state <= WAITSTATE;
                  else
                     dreg <= dreg(BITWIDTH-2 downto 0 ) & '0';
                     bit_shr := bit_shr(BITWIDTH-2 downto 0) & '1';
                     spi_state <= TOGGLE_CLOCK;
                  end if;
               end if;
               
            when TOGGLE_CLOCK =>  -- pulse clock high
               if (clk_en = '1') then
                  SCL <= '1';
                  spi_state <= SHIFT;
               end if;
               
            when WAITSTATE => -- wait for tWait
            if (clk_en = '1') then
               ACK <= '1';   
               SCL <= '0';
               CSn <= '1';
               spi_state <= IDLE;
            end if;
            
         end case;
      end if;
   end process SPI_machine;
   
end rtl;
