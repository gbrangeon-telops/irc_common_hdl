---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: ad7671_iface.vhd
--  Use: Serial interfacing to AD7671 ADC
--
--  Revision history:  (use SVN for exact code history)
--    SSA : Jan 19, 2007 - original implementation in file ir_adc_acq.vhd
--    OBO : Sept 17, 2007 - adaptation for cooler noise aquisition, new generalized interface
--
--  References:
--    AD7671 data sheet
--
--  Note :
--
--  $Revision$ 
--  $Author$
--  $LastChangedDate$
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library common_hdl;
use common_hdl.all;

entity ad7671_iface is
   port(
      -- FPGA Domain
      CLK           : in  std_logic; -- system clock
      RST           : in  std_logic; -- to reset the ADC and interfacing core
      TRIG          : in  std_logic; -- initiate a conversion on rising edge
      DOUT_VLD      : out std_logic; -- pulsed for one clock tick when DOUT is valid
      DOUT          : out std_logic_vector(15 downto 0); -- data from ADC
      -- ADC Domain
      ADC_SCLK   : in  std_logic; -- internal 40 MHz serial clock from ADC
      ADC_SDOUT  : in  std_logic; -- serial data coming from adc
      ADC_BUSY   : in  std_logic; -- high when ADC is busy
      ADC_CNVT_N : out std_logic; -- ADC conversion initiation
      ADC_RESET  : out std_logic); -- ADC reset pin drive
end entity ad7671_iface;

architecture rtl of ad7671_iface is
   
   signal spi_sr        : std_logic_vector(15 downto 0);
   signal spi_dout      : std_logic_vector(15 downto 0);
   signal adc_busy_dly  : std_logic;
   signal trig_dly          : std_logic_vector(1 downto 0);
   
begin	
   
   -- map ADC reset pin
   ADC_RESET <= RST;
   
   -- SPI data reception (ADC clock domain)
   spi_shift: process(ADC_SCLK)
   begin
      if rising_edge(ADC_SCLK) then
         spi_sr <= spi_sr(14 downto 0) & ADC_SDOUT;
      end if;
   end process;
   
   -- Synchronize across clock domains and pulse data valid for one system clock tick
   data_sync : process(CLK)
      variable dval_buf : std_logic_vector(2 downto 0);
   begin
      if rising_edge(CLK) then
         -- verify flop setup and hold times are respected and register
         if dval_buf(2 downto 1) = "01" then
            DOUT_VLD <= '1';
            DOUT <= spi_sr;
         else
            DOUT_VLD <= '0';
         end if;
         
         -- clock domain re-sync register for dval
         dval_buf(2 downto 1) := dval_buf(1 downto 0);
         dval_buf(0):= not ADC_BUSY;  -- data is valid when ADC is not busy;
         
         -- on trig rising edge pulse cnvt_n pin for 2 clocks
         trig_dly(1 downto 0) <= TRIG & trig_dly(1);
         if (TRIG = '1' and trig_dly(1) = '0') or (trig_dly = "10") then
            ADC_CNVT_N <= '0';
         else
            ADC_CNVT_N <= '1';
         end if;
      end if;
   end process data_sync;
   
end rtl;