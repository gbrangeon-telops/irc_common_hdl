-----------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: dat_path.vhd
--  Hierarchy: Sub-module file
--  Use: data path for performing ddr memory test
--	 Project: GATORADE2 - In system memory tester
--	 By: Olivier Bourgois
--  Date: October 28, 2005
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dat_path is
   generic(
      DATAWIDTH : integer := 128);
   port(
      CLK       : in  std_logic;
      RST_DPTH  : in  std_logic;
      DAT_INV   : in  std_logic;
      NXT_ADR   : in  std_logic;
      NXT_DAT   : in  std_logic;
      DAT_PEND  : out std_logic;
      DAT       : in  std_logic_vector(7 downto 0);
      DOUT      : out std_logic_vector(DATAWIDTH-1 downto 0);
      DIN       : in  std_logic_vector(DATAWIDTH-1 downto 0);
      DAT_EQ    : out std_logic;
      DEAD_BIT  : out std_logic_vector(6 downto 0);
      DEAD_FND  : out std_logic);
end entity dat_path;

architecture rtl of dat_path is
   
   signal dat_local : std_logic_vector(DATAWIDTH-1 downto 0);
   signal din_local : std_logic_vector(DATAWIDTH-1 downto 0);
   signal test_vect    : std_logic_vector(DATAWIDTH-1 downto 0);
   signal datn         : std_logic_vector(DATAWIDTH/2-1 downto 0);
   signal datp         : std_logic_vector(DATAWIDTH/2-1 downto 0);
   signal pend_cnt     : std_logic_vector(9 downto 0);  -- we can have up to 1024 words in the fifo
   signal dead_bit_cnt : std_logic_vector(7 downto 0);
   
   constant pend_zero  : std_logic_vector(pend_cnt'range) := (others => '0');
   constant test_ones  : std_logic_vector(test_vect'range) := (others => '1');
   constant dat_chunks : integer := DATAWIDTH/16;
   
begin

   din_local <= DIN;
   
   -- synopsys translate_off
   -- we want to prevent 'X' in arithmetic operand warning printout which slows simulation when DIN is hi-Z
   din_local <= (others => 'H');
   -- synopsys translate_on
   
   -- data replication to drive full 128 bit bus, use inverted value on second data time to maximize SSO
   dat_replicate : for i in 0 to dat_chunks-1 generate
      datn(i*8+7 downto i*8) <=  not DAT when (DAT_INV = '1') else DAT;
      datp(i*8+7 downto i*8) <=  DAT when (DAT_INV = '1') else not DAT;
   end generate;
   
   dat_local <= datn & datp;
   DOUT <= dat_local;
   
   -- xor inverted predicted value with readback value, any zeroes in pattern indicate dead bits
   xor_pred_rd : process(CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST_DPTH = '1') then
            test_vect <= (others => '1');
         elsif (NXT_DAT = '1') then
            test_vect <= (not dat_local) xor din_local;
         elsif (test_vect(0) /= '0') then
            test_vect(DATAWIDTH-2 downto 0) <= test_vect(DATAWIDTH-1 downto 1);
            test_vect(DATAWIDTH-1) <= '1';
         end if;
      end if;
   end process xor_pred_rd;
   
   -- if we are recomputing a test vector (xor operation) reset the DEAD_BIT to zero
   -- otherwise keep counting the shifts in the test_vect until we find the problem bit
   find_rightmost_dead_bit : process(CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST_DPTH = '1' or NXT_DAT = '1') then
            dead_bit_cnt <= (others => '0');
         elsif (test_vect(0) /= '0' and dead_bit_cnt(7) /= '1') then
            dead_bit_cnt <= dead_bit_cnt + 1;
         end if;
      end if;
   end process find_rightmost_dead_bit;
   
   -- report our findings about the error
   DEAD_BIT <= dead_bit_cnt(6 downto 0);
   DEAD_FND <= not test_vect(0);
   
   -- comparator to check that read_back data is equivalent to generated value
   DAT_EQ <= '1' when test_vect = test_ones else '0';
   
   -- counter to keep a running difference of sent commands and sent data
   dat_cnt : process(CLK)
      variable op : std_logic_vector(1 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         op := NXT_ADR & NXT_DAT;
         if (RST_DPTH = '1') then
            pend_cnt <= (others => '0');
         else
            case op is
               when "10" =>
                  pend_cnt <= pend_cnt + 1;
               when "01" =>
                  pend_cnt <= pend_cnt - 1;
               when others =>
               null;
            end case;
         end if;
      end if;
   end process dat_cnt;
   
   -- if all pending data has been sent / received set the flag
   DAT_PEND <= '0' when pend_cnt = pend_zero else '1';
   
end rtl;

