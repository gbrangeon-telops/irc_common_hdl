---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006-2007
--
--  File: serializer.vhd
--  Use: Data Serializing with embeded framing control and seperate clock line
--  Author: Olivier Bourgois
--  Notes: Improved version of sync_ser which can be used without a DDR reg in CPLDs
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Status: New version needs hardware validation
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;

entity serializer is
   generic(
      width  : integer;
      lines  : integer);
   port(
      CLK    : in std_logic;
      DIV    : in std_logic_vector(2 downto 0);
      DIN    : in std_logic_vector(width-1 downto 0);
      WR     : in std_logic;
      BSY    : out std_logic;
      SDAT   : out std_logic_vector(lines-1 downto 0);
      SCLK   : out std_logic);
end serializer;

architecture rtl of serializer is
   
   constant cpld : boolean := false;  -- we can not use a generic here because if generate will use default value and ignore generic map
   constant sync_word : std_logic_vector(lines-1 downto 0) := (others => '0'); -- frame start word
   constant total_width : integer := width+sync_word'length;
   constant max_tx_cnts : integer := (total_width+lines-1)/lines; -- integer division rounding trick to calculate number of transmissions required
   constant dreg_width : integer := max_tx_cnts*lines;
   
   type tx_st is (IDLE, TRANSMIT);
   signal state : tx_st;
   signal dreg : std_logic_vector(dreg_width-1 downto 0);
   signal clkn : std_logic;
   signal clk_en : std_logic;
   
   component FDDRCPE is
      port (
         C0   : in std_logic;
         C1    : in std_logic;
         CLR   : in std_logic;
         PRE   : in std_logic;
         CE    : in std_logic;
         D0    : in std_logic;
         D1    : in std_logic;
         Q     : out std_logic);
   end component;
   
begin
   
   -- clock division
   clock_en_div : process(CLK)
      variable clkdiv_cnt : unsigned(7 downto 0) := (0 => '1', others => '0');
   begin
      if (CLK'event and CLK = '1') then
         clk_en <= clkdiv_cnt(to_integer(unsigned(DIV)));
         clkdiv_cnt(7 downto 1) := clkdiv_cnt(7 downto 1) + 1;
      end if;
   end process clock_en_div;
   
   -- serial data output maping
   SDAT <= dreg(SDAT'range);
   
   -- serializing state machine
   serializer_sm : process(CLK)
      constant ones : std_logic_vector(SDAT'range) := (others => '1');
      variable tx_cnt : integer range 1 to max_tx_cnts;
   begin
      if (CLK'event and CLK = '1') then
         if clk_en = '1' then
            case state is
               when TRANSMIT =>  -- transmit state
                  if (tx_cnt = max_tx_cnts - 1) then
                     BSY <= '0';
                     state <= IDLE;
                  end if;
                  dreg <= ones & dreg(dreg'length-1 downto ones'length); -- shift dreg right by the correct amount
                  tx_cnt := tx_cnt + 1;
               when others =>   -- idle state
               tx_cnt := 1;
               if (WR = '1') then
                  dreg(DIN'length + sync_word'length -1 downto 0) <= DIN & sync_word; -- load the data into shift register
                  BSY <= '1';
                  state <= TRANSMIT;
               else
                  dreg <= (others => '1');
                  BSY <= '0';
               end if;
            end case;
         end if;
      end if;
   end process serializer_sm;
   
   -- generate a source synchronous output clock using appropriate method
   gen_fpga : if not cpld generate
      clkn <= not CLK;
      
      -- DDR flop is used in such a way as to have clock with 180 degree
      -- phase shift to data so as to clock in middle of "eye"
      ddr_flop : FDDRCPE
      port map (
         C0    => CLK,
         C1    => clkn,
         CLR   => '0',
         PRE   => '0',
         CE    => '1',
         D0    => clk_en,
         D1    => '0',
         Q     => SCLK);
   end generate;
   
   -- cpld have no DDR registers but have predictable pin-to-pin delays
   gen_cpld : if cpld generate
      
      SCLK <= not (CLK and clk_en); -- clock in the middle of data so invert clock
      
   end generate;
   
end rtl;
