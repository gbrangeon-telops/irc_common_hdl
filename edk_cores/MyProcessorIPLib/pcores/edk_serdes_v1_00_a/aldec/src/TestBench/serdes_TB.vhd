-------------------------------------------------------------------------------
--
-- Title       : Test Bench for embedded framing serdes
-- Design      : FIR-00173
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\serdes_TB.vhd
-- Generated   : 2006-10-06, 15:00
-- From        : $DSN\src\serializer.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Test Bench for lvds (external) serializer and deserializer
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity serdes_tb is
end serdes_tb;

architecture TB_ARCHITECTURE of serdes_tb is
   
   constant width : integer := 32;
   constant lines : integer := 1;
   
   -- Component declaration of the tested unit
   component serializer
      generic(
         width : integer;
         lines : integer);
      port(
         CLK    : in std_logic;
         DIV    : in std_logic_vector(2 downto 0);
         DIN    : in std_logic_vector(width-1 downto 0);
         DVAL   : in std_logic;
         BSY    : out std_logic;
         SDAT   : out std_logic_vector(lines-1 downto 0);
         SCLK   : out std_logic);
   end component;
   
   component deserializer
      generic(
         width : integer;
         lines : integer);
      port(
         SCLK : in std_logic;                             -- serial input clock
         SDAT : in std_logic_vector(lines-1 downto 0);    -- serial input data
         CLK  : in std_logic;                             -- system clock
         DVAL : out std_logic;                            -- parallel data valid
         DOUT : out std_logic_vector(width-1 downto 0));  -- parallel data out
   end component;
   
   -- signals
   signal TCLK : std_logic;
   signal RCLK : std_logic;
   signal RST : std_logic;
   signal DIN : std_logic_vector(width-1 downto 0);
   signal TDVAL  : std_logic;
   signal DIV : std_logic_vector(2 downto 0);
   signal BSY : std_logic;
   signal SCLK : std_logic;
   signal SDAT  : std_logic_vector(lines-1 downto 0);
   signal DVAL : std_logic;
   signal DOUT : std_logic_vector(width-1 downto 0);
   
begin
   
   -- Add your stimulus here ...
   -- Unit Under Test1 port map
   UUT1 : serializer
   generic map(
      width => width,
      lines => lines)
   port map (
      CLK => TCLK,
      DIV => DIV,
      DIN => DIN,
      DVAL => TDVAL,
      BSY => BSY,
      SCLK => SCLK,
      SDAT => SDAT);
   
   UUT2 : deserializer
   generic map(
      width => width,
      lines => lines)
   port map (
      SCLK => SCLK,
      SDAT => SDAT,
      CLK => RCLK,
      DVAL => DVAL,
      DOUT => DOUT);
   
   -- generate a tx clock
   gen_tclk : process
   begin
      TCLK <= '0';
      loop
         wait for 10ns;
         TCLK <= not TCLK;
      end loop;
   end process gen_tclk;
   
   -- generate an rx clock
   gen_rclk : process
   begin
      RCLK <= '0';
      loop
         wait for 11ns;
         RCLK <= not RCLK;
      end loop;
   end process gen_rclk;
   
   -- generate a reset
   gen_rst : process
   begin
      RST <= '1';
      wait for 50ns;
      RST <= '0';
      wait;
   end process gen_rst;
   
   -- generate some counter data to transmit
   gen_data : process(TCLK)
      variable data : std_logic_vector(DIN'range) := (others => '0');
      constant lfsr8_seed : std_logic_vector(7 downto 0) := x"ba"; 
      variable lfsr8 : std_logic_vector(7 downto 0);
   begin
      if (TCLK'event and TCLK = '1') then
         if (RST = '1') then
            lfsr8 := lfsr8_seed;
            TDVAL <= '0';
         else
            if (BSY = '0') then
               lfsr8(7 downto 1) := lfsr8(6 downto 0);
               lfsr8(0) := lfsr8(7) xor lfsr8(5) xor lfsr8(4) xor lfsr8(3);
               if (lfsr8(0) = '1' or lfsr8(1) = '1') then
                  TDVAL <= '1';
                  DIN <= data;
                  data := data + 1;
               else
                  TDVAL <= '0';
               end if;
            end if;
         end if;
      end if;
   end process gen_data;
   
   DIV <= "000";
   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_serdes of serdes_tb is
   for TB_ARCHITECTURE
      for UUT1 : serializer
         use entity work.serializer(rtl);
      end for;
      for UUT2 : deserializer
         use entity work.deserializer(rtl);
      end for;
   end for;
end TESTBENCH_FOR_serdes;

