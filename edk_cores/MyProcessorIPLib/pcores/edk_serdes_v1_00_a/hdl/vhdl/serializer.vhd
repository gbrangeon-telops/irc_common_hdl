---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006-2008
--
--  File: serializer.vhd
--  Use: Data Serializing with embeded framing control and seperate clock line
--  Author: Olivier Bourgois
--  Notes: Improved version of sync_ser with a LocalLink style interface and
--  a clock division module
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
      DVAL   : in std_logic;
      BSY    : out std_logic;
      SDAT   : out std_logic_vector(lines-1 downto 0);
      SCLK   : out std_logic);
end serializer;

architecture rtl of serializer is
   
   constant sync_word : std_logic_vector(lines-1 downto 0) := (others => '0'); -- frame start word
   constant total_width : integer := width+sync_word'length;
   constant max_tx_cnts : integer := (total_width+lines-1)/lines; -- integer division rounding trick to calculate number of transmissions required
   constant dreg_width : integer := max_tx_cnts*lines;
   
   type tx_st is (IDLE, TRANSMIT, TX_DONE);
   signal state : tx_st;
   signal din_q : std_logic_vector(width-1 downto 0);
   signal dreg : std_logic_vector(dreg_width-1 downto 0);
   signal clk_gen_p2 : std_logic;
   signal clk_gen_p1 : std_logic;
   signal clk_gen : std_logic;
   signal clk_en : std_logic := '0';
   signal bsy_i : std_logic := '0';
   signal xfer_ack : std_logic;
   signal tx_cnt : integer range 1 to max_tx_cnts;
   
begin
   
   -- clock division, simply select appropriate bit of a free running counter. Fastest SCLK is CLK/2
   clock_en_div : process(CLK)
      variable clkdiv_cnt : unsigned(7 downto 0) := (others => '0');
   begin
      if (CLK'event and CLK = '1') then
         clk_gen_p2 <= clkdiv_cnt(to_integer(unsigned(DIV)));   -- early early generated clock
         clk_gen_p1 <= clk_gen_p2;                              -- early generated clock
         clk_gen    <= clk_gen_p1;                              -- generated clock
         if (clk_gen_p2 = '1' and clk_gen_p1 = '0') then        -- clock enable in sync with  early generated clock edge
            clk_en <= '1';
         else
            clk_en <= '0';
         end if;
         clkdiv_cnt := clkdiv_cnt + 1;
      end if;
   end process clock_en_div;
   
   -- serial data output maping
   SDAT <= dreg(SDAT'range);
   
   -- output the generated clock
   SCLK <= clk_gen;
   
   -- data interface
   data_interface : process(CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (xfer_ack = '1') then
            bsy_i <= '0';
         elsif (DVAL = '1' and bsy_i = '0') then
            bsy_i <= '1';
            din_q <= DIN;
         end if;
      end if;
   end process data_interface;
   
   -- serializing state machine
   serializer_sm : process(CLK)
      constant ones : std_logic_vector(SDAT'range) := (others => '1');
   begin
      if (CLK'event and CLK = '1') then
         case state is
            when TRANSMIT =>  -- transmit state
               if (clk_en = '1') then
                  if (tx_cnt = max_tx_cnts - 1) then
                     state <= TX_DONE;
                  end if;
                  dreg <= ones & dreg(dreg'length-1 downto ones'length); -- shift dreg right by the correct amount
                  tx_cnt <= tx_cnt + 1;
               end if;
            when TX_DONE =>
               if (clk_en = '1') then
                  xfer_ack <= '1';
                  dreg <= (others => '1');
                  STATE <= IDLE;
               end if;
            when others =>   -- idle state
            if (bsy_i = '1' and clk_en = '1') then
               dreg(din_q'length + sync_word'length -1 downto 0) <= din_q & sync_word; -- load the data into shift register
               state <= TRANSMIT;
            else
               dreg <= (others => '1');
            end if;
            xfer_ack <= '0';
            tx_cnt <= 1;
         end case;
      end if;
   end process serializer_sm;
   
   -- drive external busy
   BSY <= bsy_i;
   
   
end rtl;
