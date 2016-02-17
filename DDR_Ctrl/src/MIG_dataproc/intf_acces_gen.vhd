---------------------------------------------------------------------------------------------------
--
-- Title       : intf_acces_gen
-- Design      : intf_acces_gen
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : Test for memory interface
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;   

entity intf_acces_gen is
   port (
      rst         : in  std_logic;
      clk         : in  std_logic;
      -- Write 1
      wr1_afull   : in  std_logic;
      wr1_en      : out std_logic;
      wr1_addr    : out std_logic_vector( 26 downto 0);
      wr1_data    : out std_logic_vector(127 downto 0);
      -- Write 2
      wr2_afull   : in  std_logic;
      wr2_en      : out std_logic;
      wr2_addr    : out std_logic_vector( 26 downto 0);
      wr2_data    : out std_logic_vector(127 downto 0);
      -- Read 1
      rd1_afull   : in  std_logic;
      rd1_dval    : in  std_logic;
      rd1_data    : in  std_logic_vector(127 downto 0);
      rd1_data_en : out std_logic;
      rd1_addr_en : out std_logic;
      rd1_addr    : out std_logic_vector( 26 downto 0);
      -- Read 2
      rd2_afull   : in  std_logic;
      rd2_dval    : in  std_logic;
      rd2_data    : in  std_logic_vector(127 downto 0);
      rd2_data_en : out std_logic;
      rd2_addr_en : out std_logic;
      rd2_addr    : out std_logic_vector( 26 downto 0);
      -- Read 3
      rd3_afull   : in  std_logic;
      rd3_dval    : in  std_logic;
      rd3_data    : in  std_logic_vector(127 downto 0);
      rd3_data_en : out std_logic;
      rd3_addr_en : out std_logic;
      rd3_addr    : out std_logic_vector( 26 downto 0);
      -- Debug
      mem_init_cnt: out std_logic_vector( 26 downto 0);
      mem_tst     : out std_logic;
      FIFOclr_cnt : out std_logic;
      rst_memtest : out std_logic;
      mem_tst_cnt : out std_logic_vector( 19 downto 0);
      mem_tst_over: out std_logic;
      cnt         : out std_logic_vector(  3 downto 0);
      rd1cnt      : out std_logic_vector(  3 downto 0);
      rd2cnt      : out std_logic_vector(  3 downto 0);
      wr1cnt      : out std_logic_vector(  3 downto 0);
      rd1ok       : out std_logic;
      rd2ok       : out std_logic;
      count_hold  : out std_logic
   );
end intf_acces_gen;

architecture RTL of intf_acces_gen is

   -- Constants
   constant cnt_max     : integer := 14;
   constant wr1_act1    : integer := 1;
   constant wr1_act2    : integer := 8;
   constant rd1_act1    : integer := 3;
   constant rd1_act2    : integer := 10;
   constant rd2_act1    : integer := 6;
   constant rd2_act2    : integer := 14;

   -- Signals
   signal rst_mem_test  : std_logic;
   signal mem_init_count: unsigned(26 downto 0);
   signal count         : integer range 0 to cnt_max := 0;
   signal rd1_cnt       : integer range 0 to 15 := 0;
   signal wr1_cnt       : integer range 0 to 15 := 0;
   signal rd2_cnt       : integer range 0 to 15 := 0;
   signal wr2_data_r    : std_logic_vector(wr2_data'range);
   signal rd1_addr_r    : std_logic_vector(rd1_addr'range);
   signal wr1_addr_r    : std_logic_vector(wr1_addr'range);
   signal wr1_data_r    : std_logic_vector(wr1_data'range);
   signal rd2_addr_r    : std_logic_vector(rd2_addr'range);
   signal FIFO_clr_cnt  : std_logic;
   signal mem_test      : std_logic;
   signal rd1_datat     : std_logic_vector(15 downto 0);
   signal rd1_datat0    : std_logic_vector(15 downto 0);
   signal rd1_ok        : std_logic;
   signal rd2_datat     : std_logic_vector(15 downto 0);
   signal rd2_datacnt   : integer range 0 to 3;
   signal rd2_ok        : std_logic;
   signal mem_test_over : std_logic;
   signal mem_test_cnt  : unsigned(19 downto 0);

begin
   
   rd3_addr_en    <= '0';
   rd3_data_en    <= '0';
   rd1_data_en    <= '1';
   rd2_data_en    <= '1';
   rd3_addr       <= (others => '0');
   mem_init_cnt   <= std_logic_vector(mem_init_count);
   mem_tst        <= mem_test;
   FIFOclr_cnt    <= FIFO_clr_cnt;
   rst_memtest    <= rst_mem_test;
   mem_tst_cnt    <= std_logic_vector(mem_test_cnt);
   mem_tst_over   <= mem_test_over;
   cnt            <= std_logic_vector(to_unsigned(count,4));
   rd1cnt         <= std_logic_vector(to_unsigned(rd1_cnt,4));
   rd2cnt         <= std_logic_vector(to_unsigned(rd2_cnt,4));
   wr1cnt         <= std_logic_vector(to_unsigned(rd1_cnt,4));
   rd1ok          <= rd1_ok;
   rd2ok          <= rd2_ok;
   
   process(rst, clk)
   begin
      if rst = '1' then
         mem_init_count <= (others => '0');
         wr2_en         <= '0';
         wr2_addr       <= (others => '0');
         wr2_data_r     <= x"5AC35AC35AC35AC35AC35AC35AC35AC3";
         rst_mem_test   <= '1';
         FIFO_clr_cnt   <= '0';
         mem_test       <= '0';
         mem_test_over  <= '0';
      elsif clk'event and clk = '1' then
         wr2_en         <= '0';
         rst_mem_test   <= '1';
         if mem_test = '0' and wr2_afull = '0'then
            if mem_init_count = 2048 then
               mem_init_count <= "000000000001010000000000000";
            elsif mem_init_count = (40960+2048) then
               mem_init_count <= "000000000010100000000000000";
            elsif mem_init_count = (40960*2+2048) then
               mem_init_count <= "000000000011110000000000000";
            elsif mem_init_count = (40960*3+2048) then
               mem_init_count <= "100000000000000000000000000";
            elsif mem_test = '0' and mem_init_count = (2**26+8192) then
               mem_init_count <= (others => '0');
               mem_test       <= '1';
            else
               mem_init_count <= mem_init_count + 1;
            end if;
            wr2_en         <= '1';
            wr2_addr       <= std_logic_vector(unsigned(mem_init_count));
            wr2_data_r     <= wr2_data_r(3 downto 0) & wr2_data_r(127 downto 4);
         elsif mem_test = '1' then
            if FIFO_clr_cnt = '0' and mem_init_count = 50 then
               mem_init_count <= (others => '0');
               FIFO_clr_cnt <= '1';
            elsif FIFO_clr_cnt = '1' then
               if mem_init_count = 61440 then
                  rst_mem_test   <= '1';
                  mem_test_over  <= '1';
               elsif rd1_cnt = 15 or rd2_cnt = 15 or wr1_cnt = 15 then
                  rst_mem_test <= '0';
               else
                  rst_mem_test <= '0';
                  mem_init_count <= mem_init_count + 1;
               end if;
            else
               mem_init_count <= mem_init_count + 1;
            end if;
         end if;
      end if;
   end process;
   wr2_data <= wr2_data_r;

   process(rst, rst_mem_test, clk)
   begin
      if rst = '1' or rst_mem_test = '1' then
         mem_test_cnt   <= (others => '0');
         count          <= 0;
         count_hold     <= '0';
      elsif clk'event and clk = '1' then
         mem_test_cnt <= mem_test_cnt + 1;
         count_hold <= '0';
         if count = cnt_max then
            count <= 0;
         elsif rd1_cnt = 15 or rd2_cnt = 15 or wr1_cnt = 15 then
            count_hold <= '1';
            count <= count;
         else
            count <= count + 1;
         end if;
      end if;
   end process;

   process(rst, rst_mem_test, clk)
   begin
      if rst = '1' or rst_mem_test = '1' then
         rd1_cnt     <= 0;
         rd1_addr_en <= '0';
         rd1_addr_r  <= (26 => '1', others => '0');
         rd1_addr    <= (26 => '1', others => '0');
      elsif clk'event and clk = '1' then
         rd1_addr_en <= '0';
         rd1_addr <= rd1_addr_r;
         if (count=rd1_act1 or count=rd1_act2) and rd1_afull='1' then
            rd1_cnt     <= rd1_cnt + 1;
         elsif (count=rd1_act1 or count=rd1_act2 or rd1_cnt/=0) and rd1_afull='0' then
            rd1_addr_en <= '1';
            rd1_addr_r  <= std_logic_vector(unsigned(rd1_addr_r) + 1);
            if count /= rd1_act1 and count /= rd1_act2 then
               rd1_cnt     <= rd1_cnt - 1;
            end if;
         end if;
      end if;
   end process;

   process(rst, rst_mem_test, clk)
   begin
      if rst = '1' or rst_mem_test = '1' then
         rd1_ok      <= '1';
         rd1_datat   <= x"46BD";
         rd1_datat0  <= x"35AC";
      elsif clk'event and clk = '1' then
         if rd1_dval = '1' then
            if rd1_datat /= rd1_data(15 downto 0) and rd1_datat0 /= rd1_data(15 downto 0) then
               rd1_ok <= '0';
            end if;
            rd1_datat   <= rd1_datat(3 downto 0) & rd1_datat(15 downto 4);
            rd1_datat0  <= rd1_datat0(3 downto 0) & rd1_datat0(15 downto 4);
         end if;
      end if;
   end process;

   process(rst, rst_mem_test, clk)
   begin
      if rst = '1' or rst_mem_test = '1' then
         wr1_cnt     <= 0;
         wr1_en      <= '0';
         wr1_addr_r  <= (26 => '1', others => '0');
         wr1_addr    <= (26 => '1', others => '0');
         wr1_data_r  <= x"6BD46BD46BD46BD46BD46BD46BD46BD4";
      elsif clk'event and clk = '1' then
         wr1_en      <= '0';
         wr1_addr <= wr1_addr_r;
         if (count=wr1_act1 or count=wr1_act2) and wr1_afull='1' then
            wr1_cnt     <= wr1_cnt + 1;
         elsif (count=wr1_act1 or count=wr1_act2 or wr1_cnt/=0) and wr1_afull='0' then
            wr1_en      <= '1';
            wr1_addr_r  <= std_logic_vector(unsigned(wr1_addr_r) + 1);
            wr1_data_r  <= wr1_data_r(3 downto 0) & wr1_data_r(127 downto 4);
            if count /= wr1_act1 and count /= wr1_act2 then
               wr1_cnt     <= wr1_cnt - 1;
            end if;
         end if;
      end if;
   end process;
   wr1_data <= wr1_data_r;

   process(rst, rst_mem_test, clk)
   begin
      if rst = '1' or rst_mem_test = '1' then
         rd2_cnt     <= 0;
         rd2_addr_en <= '0';
         rd2_addr_r  <= (others => '0');
         rd2_addr    <= (others => '0');
      elsif clk'event and clk = '1' then
         rd2_addr_en <= '0';
         rd2_addr <= rd2_addr_r;
         if (count=rd2_act1 or count=rd2_act2) and rd2_afull='1' then
            rd2_cnt     <= rd2_cnt + 1;
         elsif (count=rd2_act1 or count=rd2_act2 or rd2_cnt/=0) and rd2_afull='0' then
            rd2_addr_en <= '1';
            if unsigned(rd2_addr_r) < 122880 then
               rd2_addr_r  <= std_logic_vector(unsigned(rd2_addr_r) + 40960);
            else
               rd2_addr_r  <= std_logic_vector(unsigned(rd2_addr_r) - 122879);
            end if;
            if count /= rd2_act1 and count /= rd2_act2 then
               rd2_cnt     <= rd2_cnt - 1;
            end if;
         end if;
      end if;
   end process;

   process(rst, rst_mem_test, clk)
   begin
      if rst = '1' or rst_mem_test = '1' then
         rd2_ok      <= '1';
         rd2_datat   <= x"35AC";
         rd2_datacnt <= 0;
      elsif clk'event and clk = '1' then
         if rd2_dval = '1' then
            if rd2_datacnt = 3 then rd2_datacnt <= 0;
            else rd2_datacnt <= rd2_datacnt + 1; end if;

            if rd2_datacnt = 3 then
               rd2_datat   <= rd2_datat(7 downto 0) & rd2_datat(15 downto 8);
            else
               rd2_datat   <= rd2_datat(3 downto 0) & rd2_datat(15 downto 4);
            end if;

            if rd2_datat /= rd2_data(15 downto 0) then
               rd2_ok <= '0';
            end if;
         end if;
      end if;
   end process;

end RTL;
