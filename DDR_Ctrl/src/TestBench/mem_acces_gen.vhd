---------------------------------------------------------------------------------------------------
--
-- Title       : mem_acces_gen
-- Design      : mem_acces_gen
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : Test for MIG memory controller
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;   

entity mem_acces_gen is
   port (
      rst               : in  std_logic;
      clk               : in  std_logic;
      read_fifo_vld     : in  std_logic;
      read_fifo_data    : in  std_logic_vector(143 downto 0);
      addr_fifo_afull   : in  std_logic;
      data_fifo_afull   : in  std_logic;
      mem_addr          : out std_logic_vector( 35 downto 0);
      mem_addr_we       : out std_logic;
      mem_data          : out std_logic_vector(143 downto 0);
      mem_data_we       : out std_logic
   );
end mem_acces_gen;

architecture RTL of mem_acces_gen is

   -- Types
   type datagen_state is (IDLE, WRITE1, WRITE2, WRITE3, WRITE4, WRITE5, WRITE6, WRITE7,
                          READ1,  READ2,  READ3,  READ4,  READ5,  READ6,
                          RANK_TEST);

   -- Constants
   constant max_cnt     : integer := 13;

   -- Signals
   signal state         : datagen_state := IDLE;
   signal count         : integer range 0 to 20 := max_cnt;
   signal mem_addr_r    : std_logic_vector(27 downto 0);
   signal mem_addr_cmd  : std_logic_vector(2 downto 0);
   signal mem_addr_inc  : std_logic := '0';
   signal mem_addr_row  : std_logic := '0';
   signal mem_addr_bnk  : std_logic := '0';
   signal mem_data_r    : std_logic_vector(mem_data'range);
   signal mem_data_inc  : std_logic := '0';
   signal mem_addr_rst  : std_logic := '0';
   signal mem_addr_rnk  : std_logic := '0';

begin
   
   process(rst, clk)
   begin
      if rst = '1' then
         state          <= IDLE;
         mem_addr_we    <= '0';
         mem_data_we    <= '0';
         mem_addr_inc   <= '0';
         mem_addr_row   <= '0';
         mem_addr_bnk   <= '0';
         mem_data_inc   <= '0';
         mem_addr_cmd   <= (others => '0');
         mem_addr_rst   <= '0';
         mem_addr_rnk   <= '0';
      elsif clk'event and clk = '1' then
         mem_addr_we    <= '0';
         mem_data_we    <= '0';
         mem_addr_inc   <= '0';
         mem_addr_row   <= '0';
         mem_addr_bnk   <= '0';
         mem_data_inc   <= '0';
         mem_addr_cmd   <= (others => '0');
         mem_addr_rst   <= '0';
         mem_addr_rnk   <= '0';
         case state is
            when IDLE =>
               state          <= WRITE1;
               mem_addr_rst   <= '1';
            when WRITE1 =>
               state          <= WRITE1;
               if count = 0 then
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
                  state          <= WRITE2;
               end if;
            when WRITE2 =>
               state          <= WRITE2;
               if count = 0 then
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
                  state          <= WRITE3;
               end if;
            when WRITE3 =>
               state          <= WRITE3;
               if count <= 5 then
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
               if count = 0 then
                  state          <= WRITE4;
               end if;
            when WRITE4 =>
               state          <= WRITE4;
               mem_data_we    <= '1';
               mem_data_inc   <= '1';
               mem_addr_cmd   <= "100";
               mem_addr_we    <= '1';
               mem_addr_inc   <= '1';
               if count = 0 then
                  state          <= READ1;
                  mem_addr_rst   <= '1';
               end if;
            when READ1 =>
               state          <= READ1;
               if count = 0 then
                  state          <= READ2;
               elsif count >= 5 then
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
            when READ2 =>
               state          <= READ2;
               if count = 8 then
                  state          <= WRITE5;
                  mem_addr_rst   <= '1';
               end if;
               if count >= 8 then
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
            when WRITE5 =>
               state          <= WRITE5;
               if count <= 13 then
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
               if count = 0 then
                  state          <= WRITE6;
                  mem_addr_rst   <= '1';
               end if;
            when WRITE6 =>
               state          <= WRITE6;
               mem_data_we    <= '1';
               mem_data_inc   <= '1';
               mem_addr_cmd   <= "100";
               mem_addr_we    <= '1';
               mem_addr_row   <= '1';
               if count = 0 then
                  state          <= READ3;
                  mem_addr_rst   <= '1';
               end if;
            when READ3 =>
               state          <= READ3;
               if count = 10 then
                  state          <= WRITE7;
                  mem_addr_rst   <= '1';
               end if;
               if count >= 10 then
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_row   <= '1';
               end if;
            when WRITE7 =>
               state          <= WRITE7;
               mem_data_we    <= '1';
               mem_data_inc   <= '1';
               mem_addr_cmd   <= "100";
               mem_addr_we    <= '1';
               mem_addr_row   <= '1';
               if count = 0 then
                  state          <= RANK_TEST;
                  mem_addr_rst   <= '1';
               end if;
            when RANK_TEST =>
               state          <= RANK_TEST;
               if count = 13 then -- Write rank0
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
               if count = 12 then -- Write rank0
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_rst   <= '1';
               end if;
               if count = 11 then -- Read rank0
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
               if count = 10 then -- Read rank0
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_rnk   <= '1';
               end if;
               if count = 9 then -- Write rank1
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
               if count = 8 then -- Write rank1
                  mem_data_we    <= '1';
                  mem_data_inc   <= '1';
                  mem_addr_cmd   <= "100";
                  mem_addr_we    <= '1';
                  mem_addr_rnk   <= '1';
               end if;
               if count = 7 then -- Read rank1
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
               if count = 6 then -- Read rank1
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_rst   <= '1';
               end if;
               if count = 5 then -- Read rank0
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_inc   <= '1';
               end if;
               if count = 4 then -- Read rank0
                  mem_addr_cmd   <= "101";
                  mem_addr_we    <= '1';
                  mem_addr_rst   <= '1';
               end if;
               if count = 0 then
                  state          <= IDLE;
               end if;
            when others =>
               state          <= IDLE;
         end case;
      end if;
   end process;
   
   process(rst, clk)
   begin
      if rst = '1' then
         count <= max_cnt;
      elsif clk'event and clk = '1' then
         if state = IDLE then
            count <= max_cnt;
         elsif count = 0 then
            count <= max_cnt;
         else
            count <= count - 1;
         end if;
      end if;
   end process;

   process(rst, clk)
   begin
      if rst = '1' then
         mem_addr_r <= (others => '0');
      elsif clk'event and clk = '1' then
         if mem_addr_rst = '1' then
            mem_addr_r <= (others => '0');
         elsif mem_addr_rnk = '1' then
            mem_addr_r <= (27 => '1', others => '0');
         elsif mem_addr_inc = '1' then
            mem_addr_r <= std_logic_vector(unsigned(mem_addr_r)+2);--+2**25);
         elsif mem_addr_row = '1' then
            mem_addr_r <= std_logic_vector(unsigned(mem_addr_r)+2**12);--+2**25);-- 2**12 => 2GB
         elsif mem_addr_bnk = '1' then
            mem_addr_r <= std_logic_vector(unsigned(mem_addr_r)+2**25);
         end if;
      end if;
   end process;
   
   mem_addr <= '0' & mem_addr_cmd & "000" & mem_addr_r(27 downto 10) & '0' & mem_addr_r(9 downto 0);

   process(rst, clk)
   begin
      if rst = '1' then
         mem_data_r <= "101011000011010110101100001101011010110000110101101011000011010110101100001101011010110000110101101011000011010110101100001101011010110000110101";
      elsif clk'event and clk = '1' then
         if mem_data_inc = '1' then
            mem_data_r <= mem_data_r(3 downto 0) & mem_data_r(143 downto 4);
         end if;
      end if;
   end process;

   mem_data <= mem_data_r;

end RTL;
