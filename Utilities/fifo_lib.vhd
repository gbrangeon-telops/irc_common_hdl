---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: fifo_lib.vhd
--  Use: handy fifo blocks of all sorts...
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  notes: need to add asynchronous mode fifos
---------------------------------------------------------------------------------------------------
--  sfifo_std - basic synchronous type of fifo for depths > 16
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library common_hdl;
use common_hdl.sync_reset;

entity sfifo_std is
   generic(
      DWIDTH   : natural := 8;     -- data bit width
      AWIDTH   : natural := 8);
   port(
      CLK     : in  std_logic;
      ARESET  : in  std_logic;
      WR_EN   : in  std_logic;
      RD_EN   : in  std_logic;
      DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
      DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
      LEVEL   : out std_logic_vector(AWIDTH-1 downto 0);
      VALID   : out std_logic;
      OVFLOW  : out std_logic;
      FULL    : out std_logic;
      EMPTY   : out std_logic);
end sfifo_std;

architecture rtl of sfifo_std is
   
   type ram_type is array ((2**AWIDTH)-1 downto 0) of std_logic_vector (DWIDTH-1 downto 0);
   signal RAM      : ram_type;
   signal wr_ptr   : unsigned(AWIDTH-1 downto 0) := (others => '0');
   signal wr_en_i  : std_logic := '0';
   signal rd_ptr   : unsigned(AWIDTH-1 downto 0) := (others => '0');
   signal level_i  : unsigned(AWIDTH-1 downto 0) := (others => '0');
   signal rd_en_i  : std_logic := '0';
   signal valid_i  : std_logic := '0';
   signal empty_i  : std_logic := '1';
   signal ovflow_i : std_logic := '0';
   signal full_i   : std_logic := '0';
   signal rst_sync : std_logic := '0';
   
   component sync_reset is
      port(
         ARESET : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1';
         CLK    : in STD_LOGIC);
   end component;
   
begin
   
   -- write side sequential logic
   wr_logic : process(CLK)
      constant full_level : unsigned(AWIDTH-1 downto 0) := (others => '1');
      constant going_full_level : unsigned(AWIDTH-1 downto 0) := (0 => '0', others => '1'); 
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            wr_ptr <= (others => '0');
            full_i <= '0';
         else
            -- write pointer logic
            if wr_en_i = '1' then
               wr_ptr <= wr_ptr + 1;
               ovflow_i <= full_i;
            end if;
            -- full flag logic
            if ((level_i = going_full_level) and rd_en_i = '0' and wr_en_i = '1' ) or (level_i = full_level) then
               full_i <= '1';
            else
               full_i <= '0';
            end if;
         end if;
      end if;
   end process wr_logic;
   
   -- write side combinational logic
   wr_en_i <= WR_EN and (not full_i);
   FULL  <= full_i;
   
   OVFLOW <= ovflow_i;
   
   -- read side sequential logic
   rd_logic : process(CLK)
      constant empty_level : unsigned(AWIDTH-1 downto 0) := (others => '0');
      constant going_empty_level : unsigned(AWIDTH-1 downto 0) := (0 => '1', others => '0');
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            rd_ptr <= (others => '0');
            empty_i <= '1';
         else
            -- read pointer logic
            if rd_en_i = '1' then
               rd_ptr <= rd_ptr + 1;
            end if;
            
            if level_i /= empty_level then
               valid_i <= rd_en_i; 
            end if;
            
            -- empty flag logic
            if ((level_i = going_empty_level) and wr_en_i = '0' and rd_en_i = '1' ) or (level_i = empty_level) then
               empty_i <= '1';
            else
               empty_i <= '0';
            end if;
         end if;
      end if;
   end process rd_logic;
   
   -- read side combinational logic
   rd_en_i <= RD_EN and (not empty_i);
   EMPTY <= empty_i;
   VALID <= valid_i;
   
   -- level logic
   level_gen : process(CLK)
      variable level_op : std_logic_vector(1 downto 0) := "00";
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            level_i <= (others => '0');
            level_op := "00";
         else
            level_op := wr_en_i & rd_en_i;
            case level_op is
               when "10" =>
                  level_i <= level_i + 1;
               when "01" =>
                  level_i <= level_i - 1;
               when others => null;
            end case;
         end if;
      end if;
   end process level_gen;
   
   -- external version of level
   LEVEL <= std_logic_vector(level_i);
   
   -- add dual port memory here
   ram_infer : process (CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (wr_en_i = '1') then
            RAM(to_integer(wr_ptr)) <= DIN;
         end if;
         if (rd_en_i = '1') then
            DOUT <= RAM(to_integer(rd_ptr));
         end if;
      end if;
   end process ram_infer;
   
   -- synchronize async reset locally
   reset_synchro : sync_reset port map(ARESET => ARESET, SRESET => rst_sync, CLK => CLK);
   
end rtl;

---------------------------------------------------------------------------------------------------
--  sfifo_16 - very small synchronous type fifo using one LUT block per bit of data width
---------------------------------------------------------------------------------------------------
library ieee;
library common_hdl;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sfifo_16 is
   generic(
      DWIDTH  : natural := 8);    -- data bit width
   port(
      ARESET  : in  std_logic;
      CLK     : in  std_logic;
      WR_EN   : in  std_logic;
      RD_EN   : in  std_logic;
      DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
      DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
      LEVEL   : out std_logic_vector(3 downto 0);
      VALID   : out std_logic;
      OVFLOW  : out std_logic;
      FULL    : out std_logic;
      EMPTY   : out std_logic);
end entity sfifo_16;

architecture rtl of sfifo_16 is
   
   component sync_reset is
      port(
         CLK : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic
         );
   end component;
   
   signal ptr         : unsigned(3 downto 0);
   signal read        : std_logic;
   signal write       : std_logic;
   signal empty_local : std_logic;
   signal full_local  : std_logic;
   signal rst_sync    : std_logic;
   
   constant DEPTH     : integer := 16;
   
   type srl_array_t is array (0 to DEPTH-1) of std_logic_vector(DWIDTH-1 downto 0);
   signal srl_reg : srl_array_t;
   
begin
   
   -- infer dynamic SRL
   infer_srl : process (CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (write = '1') then
            srl_reg <= DIN & srl_reg(0 to DEPTH-2);
         end if;
      end if;
   end process;
   
   DOUT <= srl_reg(to_integer(ptr));
   
   -- ptr generation logic
   ptr_gen : process(CLK)
      variable op_code : std_logic_vector(2 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         op_code := rst_sync & write & read;
         case op_code is
            when "100" | "101" | "110" | "111" =>
               ptr <= (others => '1');
            when "010" =>
               ptr <= ptr + 1;
            when "001" =>
               ptr <= ptr - 1;
            when others => null;
         end case;
         VALID  <= read;
         OVFLOW <= WR_EN and full_local;
      end if;
   end process ptr_gen;
   
   -- generate status flags
   empty_local <= ptr(3) and ptr(2) and ptr(1) and ptr(0);
   full_local  <= ptr(3) and ptr(2) and ptr(1) and (not ptr(0));
   
   -- make fifo status flags visible externally
   FULL  <= full_local;
   EMPTY <= empty_local;
   LEVEL <= std_logic_vector(ptr + 1);
   
   -- generate write and read signals
   write <= WR_EN and (not full_local);
   read  <= RD_EN and (not empty_local);
   
   -- synchronize async reset locally
   reset_synchro : entity sync_reset port map(ARESET => ARESET, SRESET => rst_sync, CLK => CLK);
   
end rtl;

---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007 
-- 
--  File: afifo.vhd 
--  Use: Generic asynchronous FIFO. 
-- 
--  Revision history:  (use SVN for exact code history) 
--    SSA : Nov 28, 2007 - original implementation 
-- 
--  Notes: Uses (AWIDTH+1)-bits Gray pointers for cross-domain 
--       synchronization for FIFO with 2^AWIDTH addresses. When both read and write
--       pointers are equal, FIFO is empty. When the 2 MSB are different and the
--       remaining AWIDTH-2 are equal, FIFO is full.
--
--       Asynchronous comparison of cross-domain pointers is performed for full 
--       and empty flags generation.
--
--   References : 
--      Simulation and Synthesis Techniques for Asynchronous FIFO Design
--                                                       by Clifford E. Cummings
--
--      Simulation and Synthesis Techniques for Asynchronous
--      FIFO Design with Asynchronous Pointer Comparisons
--                                      by Clifford E. Cummings and Peter Alfke
-- 
---------------------------------------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

library common_hdl; 
use common_hdl.sync_reset;

entity afifo is 
   generic ( 
      DWIDTH   : natural := 8;     -- data bit width 
      AWIDTH   : natural := 8;    -- address bit width for infered storage element 
      PROG_EMPTY_LEVEL : natural := 0; 
      PROG_FULL_LEVEL : natural := 4 
      ); 
   port ( 
      ARESET : in  std_logic; 
      WR_CLK : in  std_logic; 
      WR_EN : in  std_logic; 
      DIN : in  std_logic_vector(DWIDTH-1 downto 0); 
      WR_LEVEL : out std_logic_vector(AWIDTH downto 0); 
      FULL : out std_logic; 
      RD_CLK : in std_logic; 
      RD_EN : in  std_logic; 
      DOUT : out std_logic_vector(DWIDTH-1 downto 0); 
      VALID : out std_logic; 
      RD_LEVEL : out std_logic_vector(AWIDTH downto 0); 
      OVFLOW : out std_logic; 
      EMPTY : out std_logic; 
      PROG_EMPTY : out std_logic := '0'; 
      PROG_FULL : out std_logic := '0'
      ); 
end afifo;

architecture rtl of afifo is
   
   type ram_type is array ((2**AWIDTH)-1 downto 0) of std_logic_vector (DWIDTH-1 downto 0); 
   signal RAM : ram_type; 
   signal wr_en_i : std_logic := '0'; 
   signal rd_en_i : std_logic := '0'; 
   signal wr_ptr : unsigned(AWIDTH downto 0) := (others => '0'); -- binary representation for memory accesses
   signal rd_ptr   : unsigned(AWIDTH downto 0) := (others => '0');  -- binary representation for memory accesses
   signal gray_wr_ptr : std_logic_vector(AWIDTH downto 0) := (others => '0'); -- gray representation for cross-domain passing
   signal gray_rd_ptr : std_logic_vector(AWIDTH downto 0) := (others => '0'); -- gray representation for cross-domain passing 
   signal valid_i : std_logic := '0'; 
   signal empty_i : std_logic := '1'; 
   signal ovflow_i : std_logic := '0'; 
   signal full_i : std_logic := '0'; 
   signal wr_rst_sync : std_logic := '0'; 
   signal rd_rst_sync : std_logic := '0'; 
   
   component sync_reset is 
      port( 
         ARESET : in STD_LOGIC; 
         SRESET : out STD_LOGIC := '1'; 
         CLK : in STD_LOGIC 
         ); 
   end component;
   
begin
   
   -- write side sequential logic 
   wr_logic : process(WR_CLK, wr_ptr)--, gray_rd_ptr_sync) 
      variable next_wr_ptr_bin : unsigned(AWIDTH downto 0) := (others => '0');
      variable next_wr_ptr_gray : std_logic_vector(AWIDTH downto 0) := (others => '0');
   begin 
      next_wr_ptr_bin := wr_ptr + 1;
      next_wr_ptr_gray := std_logic_vector(next_wr_ptr_bin) xor ('0' & std_logic_vector(next_wr_ptr_bin(AWIDTH downto 1)));
      
      if rising_edge(WR_CLK) then 
         if wr_rst_sync = '1' then 
            wr_ptr <= (others => '0');
            gray_wr_ptr <= (others => '0');
            ovflow_i <= '0';
         else            
            -- write pointer logic 
            if wr_en_i = '1' then 
               wr_ptr <= next_wr_ptr_bin; 
               gray_wr_ptr <= next_wr_ptr_gray;
               ovflow_i <= full_i;
            end if;
            
         end if; 
      end if; 
   end process wr_logic;
   
   -- write side combinational logic 
   wr_en_i <= WR_EN and (not full_i); 
   FULL  <= full_i;
   OVFLOW <= ovflow_i;
   
   -- read side sequential logic 
   rd_logic : process(RD_CLK,rd_ptr) 
      variable next_rd_ptr_bin : unsigned(AWIDTH downto 0) := (others => '0');
      variable next_rd_ptr_gray : std_logic_vector(AWIDTH downto 0) := (others => '0');
   begin 
      next_rd_ptr_bin := rd_ptr + 1; 
      next_rd_ptr_gray := std_logic_vector(next_rd_ptr_bin) xor ('0' & std_logic_vector(next_rd_ptr_bin(AWIDTH downto 1)));
      
      if rising_edge(RD_CLK) then 
         if rd_rst_sync = '1' then 
            rd_ptr <= (others => '0'); 
            gray_rd_ptr <= (others => '0');
         else 
            -- read pointer logic 
            if rd_en_i = '1' then 
               rd_ptr <= rd_ptr + 1; 
               gray_rd_ptr <= next_rd_ptr_gray;
            end if;
            
            valid_i <= rd_en_i; 
         end if; 
      end if; 
   end process rd_logic;
   
   -- read side combinational logic 
   rd_en_i <= RD_EN and (not empty_i); 
   EMPTY <= empty_i; 
   VALID <= valid_i;
   
   empty_and_full_flags: block
      signal afull : std_logic := '0';
      signal aempty : std_logic := '0';
      
      begin
      -- asynchronous comparison of read and write pointers in gray representation.
      -- we use an extra MSB bit for empty and full status differencing
      -- empty : both pointers must be equal
      -- full : pointers are equal, except for the 2 MSB, which must be different
      async_ptr_compare : process(gray_rd_ptr,gray_wr_ptr,wr_rst_sync)
      begin
         if gray_wr_ptr = (not gray_rd_ptr(AWIDTH downto AWIDTH - 1)) & gray_rd_ptr(AWIDTH - 2 downto 0) then
            afull <= '1';
         else
            afull <= '0';
         end if;
         
         if gray_rd_ptr = gray_wr_ptr then
            aempty <= '1';
         else
            aempty <= '0';
         end if;
      end process;
      
      -- when aempty goes high, it sets the registers so we can detect emptiness immediately on the read clock.
      -- This is correct, since a rising aempty is always synchronous to the read clock. When it goes low, 
      -- which is not as critical as a high aempty signal, it takes 2 CP to synchronize.
      sync_aempty : process(RD_CLK,aempty)
         variable tmp : std_logic := '0';
      begin
         if aempty = '1' then
            empty_i <= '1';
            tmp := '1';
         elsif rising_edge(RD_CLK) then
            empty_i <= tmp;
            tmp := aempty;
         end if;
      end process;
      
      -- when afull goes high, it sets the registers so we can detect fullness immediately on the write clock.
      -- This is correct, since a rising afull is always synchronous to the write clock. When it goes low, 
      -- which is not as critical as a high afull signal, it takes 2 CP to synchronize.
      sync_afull : process(WR_CLK,afull)
         variable tmp : std_logic := '0';
      begin
         if afull = '1' then
            full_i <= '1';
            tmp := '1';
         elsif rising_edge(WR_CLK) then
            if wr_rst_sync = '1' then
               tmp := '0';
               full_i <= '0';
            else    
               full_i <= tmp;
               tmp := afull;
            end if;
         end if;
      end process;
   end block empty_and_full_flags;
   
   -- level logic 
   level_gen : block
      
      signal rd_level_i : unsigned(AWIDTH downto 0) := (others => '0');
      signal wr_level_i : unsigned(AWIDTH downto 0) := (others => '0'); 
      signal gray_wr_ptr_sync : std_logic_vector(AWIDTH downto 0) := (others => '0');
      signal gray_rd_ptr_sync : std_logic_vector(AWIDTH downto 0) := (others => '0');
      signal bin_wr_ptr_sync : unsigned(AWIDTH downto 0) := (others => '0');
      signal bin_rd_ptr_sync : unsigned(AWIDTH downto 0) := (others => '0');
      
      begin 
      
      sync_rd_ptr : process(WR_CLK)
         variable tmp : std_logic_vector(AWIDTH downto 0) := (others => '0');
      begin
         if rising_edge(WR_CLK) then
            gray_rd_ptr_sync <= tmp;
            tmp := gray_rd_ptr;
         end if;
      end process;
      
      sync_wr_ptr : process(RD_CLK)
         variable tmp : std_logic_vector(AWIDTH downto 0) := (others => '0');
      begin
         
         if rising_edge(RD_CLK) then
            gray_wr_ptr_sync <= tmp;
            tmp := gray_wr_ptr;
         end if;
      end process;
      
      -- gray to binary converter for cross-domain passing.
      gray_2_bin : process(gray_rd_ptr_sync,gray_wr_ptr_sync,wr_ptr,rd_ptr)
         variable tmp1 : std_logic_vector(AWIDTH downto 0) := (others => '0');
         variable tmp2 : std_logic_vector(AWIDTH downto 0) := (others => '0');         
      begin         
         tmp1(AWIDTH) := gray_wr_ptr_sync(AWIDTH);
         tmp2(AWIDTH) := gray_rd_ptr_sync(AWIDTH);
         
         for i in AWIDTH-1 downto 0 loop
            tmp1(i) := gray_wr_ptr_sync(i) xor tmp1(i+1);
            tmp2(i) := gray_rd_ptr_sync(i) xor tmp2(i+1);
         end loop;
         
         bin_wr_ptr_sync <= unsigned(tmp1);     
         bin_rd_ptr_sync <= unsigned(tmp2);
      end process;
      
      wr_level_gen : process(WR_CLK, wr_ptr, bin_rd_ptr_sync) 
         variable level : unsigned(AWIDTH downto 0) := (others => '0');
         variable tmp_wr_ptr : unsigned(AWIDTH downto 0) := (others => '0');
         variable next_wr_ptr_bin : unsigned(AWIDTH downto 0) := (others => '0');
      begin 
         level := wr_ptr - bin_rd_ptr_sync;
         next_wr_ptr_bin := wr_ptr + 1;
         
         if rising_edge(WR_CLK) then 
            if wr_rst_sync = '1' then 
               wr_level_i <= (others => '0'); 
            else 
               if wr_en_i = '1' then
                  tmp_wr_ptr := next_wr_ptr_bin;
               end if;
               
               wr_level_i <= tmp_wr_ptr - bin_rd_ptr_sync;
               
            end if;
         end if; 
      end process wr_level_gen;
      
      rd_level_gen : process(RD_CLK, bin_wr_ptr_sync, rd_ptr) 
         variable level : unsigned(AWIDTH downto 0) := (others => '0');
         variable tmp_rd_ptr : unsigned(AWIDTH downto 0) := (others => '0');
         variable next_rd_ptr_bin : unsigned(AWIDTH downto 0) := (others => '0');
      begin 
         level := bin_wr_ptr_sync - rd_ptr;
         next_rd_ptr_bin := rd_ptr + 1;
         
         if rising_edge(RD_CLK) then 
            if rd_rst_sync = '1' then 
               rd_level_i <= (others => '0'); 
            else 
               if rd_en_i = '1' then
                  tmp_rd_ptr := next_rd_ptr_bin;
               end if;
               
               rd_level_i <= bin_wr_ptr_sync - tmp_rd_ptr;
               
            end if; 
         end if; 
      end process rd_level_gen;
      
      -- external version of levels
      WR_LEVEL <= std_logic_vector(wr_level_i);
      RD_LEVEL <= std_logic_vector(rd_level_i);
      PROG_EMPTY <= '1' when rd_level_i <= PROG_EMPTY_LEVEL else '0'; 
      PROG_FULL <= '1' when wr_level_i >= PROG_FULL_LEVEL else '0';
   end block level_gen;
   
   -- inferring a dual port RAM with 2 independent clocks 
   dual_clock_ram : block 
      signal read_addr_a : unsigned(rd_ptr'range) := (others => '0'); 
      signal doa : std_logic_vector(DIN'range) := (others => '0'); 
      
      begin
      
      write_part : process(WR_CLK) 
      begin 
         if rising_edge(WR_CLK) then 
            if wr_en_i = '1' then 
               RAM(to_integer(wr_ptr(AWIDTH-1 downto 0))) <= DIN; 
            end if; 
         end if; 
      end process;
      
      read_part : process (RD_CLK) 
      begin 
         if rising_edge(RD_CLK) then 
            if rd_en_i = '1' then 
               DOUT <= RAM(to_integer(rd_ptr(AWIDTH-1 downto 0))); 
            end if; 
         end if; 
      end process; 
   end block dual_clock_ram;
   
   -- synchronize async reset locally 
   wr_reset_synchro : sync_reset port map(ARESET => ARESET, SRESET => wr_rst_sync, CLK => WR_CLK); 
   rd_reset_synchro : sync_reset port map(ARESET => ARESET, SRESET => rd_rst_sync, CLK => RD_CLK);
   
end rtl;

---------------------------------------------------------------------------------------------------
--  sfifo - basic synchronous type of fifo wraps most efficient sfifo based on AWIDTH
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library common_hdl;
use common_hdl.sync_reset;

entity sfifo is
   generic(
      DWIDTH           : natural := 8;
      AWIDTH           : natural := 8;
      PROG_EMPTY_LEVEL : natural := 0;
      PROG_FULL_LEVEL  : natural := 0);
   port(
      CLK        : in  std_logic;
      ARESET     : in  std_logic;
      WR_EN      : in  std_logic;
      RD_EN      : in  std_logic;
      DIN        : in  std_logic_vector(DWIDTH-1 downto 0);
      DOUT       : out std_logic_vector(DWIDTH-1 downto 0);
      LEVEL      : out std_logic_vector(AWIDTH-1 downto 0);
      VALID      : out std_logic;
      OVFLOW     : out std_logic;
      FULL       : out std_logic;
      EMPTY      : out std_logic;
      PROG_FULL  : out std_logic;
      PROG_EMPTY : out std_logic);
end sfifo;

architecture rtl of sfifo is
   
   component sfifo_std is
      generic(
         DWIDTH  : natural;   
         AWIDTH  : natural);
      port(
         CLK     : in  std_logic;
         ARESET  : in  std_logic;
         WR_EN   : in  std_logic;
         RD_EN   : in  std_logic;
         DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
         DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
         LEVEL   : out std_logic_vector(AWIDTH-1 downto 0);
         VALID   : out std_logic;
         OVFLOW  : out std_logic;
         FULL    : out std_logic;
         EMPTY   : out std_logic);
   end component;
   
   component sfifo_16 is
      generic(
         DWIDTH  : natural);
      port(
         CLK     : in  std_logic;
         ARESET  : in  std_logic;
         WR_EN   : in  std_logic;
         RD_EN   : in  std_logic;
         DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
         DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
         LEVEL   : out std_logic_vector(3 downto 0);
         VALID   : out std_logic;
         OVFLOW  : out std_logic;
         FULL    : out std_logic;
         EMPTY   : out std_logic);
   end component;
   
   signal level_i : std_logic_vector(AWIDTH-1 downto 0);
   
begin
   -- instantiate the appropriate fifo
   gen_fifo_16 : if AWIDTH <= 4 generate
      inst_fifo_16 : sfifo_16
      generic map(
         DWIDTH  => DWIDTH)
      port map(
         CLK     => CLK,
         ARESET  => ARESET,
         WR_EN   => WR_EN,
         RD_EN   => RD_EN,
         DIN     => DIN,
         DOUT    => DOUT,
         LEVEL   => level_i,
         VALID   => VALID,
         OVFLOW  => OVFLOW,
         FULL    => FULL,
         EMPTY   => EMPTY);
   end generate;
   
   gen_fifo_std : if AWIDTH > 4 generate
      inst_fifo_std : sfifo_std
      generic map(
         DWIDTH  => DWIDTH,
         AWIDTH  => AWIDTH)
      port map(
         CLK     => CLK,
         ARESET  => ARESET,
         WR_EN   => WR_EN,
         RD_EN   => RD_EN,
         DIN     => DIN,
         DOUT    => DOUT,
         LEVEL   => level_i,
         VALID   => VALID,
         OVFLOW  => OVFLOW,
         FULL    => FULL,
         EMPTY   => EMPTY);
   end generate;
   
   -- add the extra programmable level logic
   LEVEL <= level_i;
   PROG_EMPTY <= '1' when unsigned(level_i) <= PROG_EMPTY_LEVEL else '0';
   PROG_FULL <= '1' when unsigned(level_i) >= PROG_FULL_LEVEL else '0';
   
end rtl;

---------------------------------------------------------------------------------------------------
--  fifo_ll32  - synchronous locallink 32 bit wide fifo
---------------------------------------------------------------------------------------------------
library ieee;
library common_hdl;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use common_hdl.telops.all;

entity fifo_ll32 is
   generic(
      AWIDTH		   : natural := 9;      -- address width of the inffered storage element
      LATENCY        : natural := 0;      -- Input module latency (to control RX_LL_MISO.AFULL)
      ASYNC          : boolean := false); -- not yet supported!
   port(
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET		: in std_logic;
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      CLK_RX      : in std_logic;
      RX_LL_MOSI  : in  t_ll_mosi32;
      RX_LL_MISO  : out t_ll_miso;
      RX_LEVEL    : out std_logic_vector(AWIDTH-1 downto 0);
      FULL        : out std_logic;
      WR_ERR      : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      CLK_TX      : in std_logic;
      TX_LL_MOSI  : out t_ll_mosi32;
      TX_LL_MISO  : in  t_ll_miso;
      TX_LEVEL    : out std_logic_vector(AWIDTH-1 downto 0);
      EMPTY       : out std_logic);
end fifo_ll32;

architecture rtl of fifo_ll32 is
   
   component sfifo_std is
      generic(
         DWIDTH  : natural;   
         AWIDTH  : natural);
      port(
         CLK     : in  std_logic;
         ARESET  : in  std_logic;
         WR_EN   : in  std_logic;
         RD_EN   : in  std_logic;
         DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
         DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
         LEVEL   : out std_logic_vector(AWIDTH-1 downto 0);
         VALID   : out std_logic;
         OVFLOW  : out std_logic;
         FULL    : out std_logic;
         EMPTY   : out std_logic);
   end component;
   
   component sfifo_16 is
      generic(
         DWIDTH  : natural);
      port(
         CLK     : in  std_logic;
         ARESET  : in  std_logic;
         WR_EN   : in  std_logic;
         RD_EN   : in  std_logic;
         DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
         DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
         LEVEL   : out std_logic_vector(3 downto 0);
         VALID   : out std_logic;
         OVFLOW  : out std_logic;
         FULL    : out std_logic;
         EMPTY   : out std_logic);
   end component;
   
   component afifo is 
      generic ( 
         DWIDTH   : natural := 8;
         AWIDTH   : natural := 8; 
         PROG_EMPTY_LEVEL : natural := 0; 
         PROG_FULL_LEVEL : natural := 4 
         ); 
      port ( 
         ARESET : in  std_logic; 
         WR_CLK : in  std_logic; 
         WR_EN : in  std_logic; 
         DIN : in  std_logic_vector(DWIDTH-1 downto 0); 
         WR_LEVEL : out std_logic_vector(AWIDTH downto 0); 
         FULL : out std_logic; 
         RD_CLK : in std_logic; 
         RD_EN : in  std_logic; 
         DOUT : out std_logic_vector(DWIDTH-1 downto 0); 
         VALID : out std_logic; 
         RD_LEVEL : out std_logic_vector(AWIDTH downto 0); 
         OVFLOW : out std_logic; 
         EMPTY : out std_logic; 
         PROG_EMPTY : out std_logic := '0'; 
         PROG_FULL : out std_logic := '0'
         ); 
   end component;
   
   signal fifo_level_i : std_logic_vector(AWIDTH-1 downto 0);
   signal fifo_dout   : std_logic_vector(35 downto 0);
   signal fifo_din    : std_logic_vector(35 downto 0);
   signal fifo_rd_ack : std_logic;			
   signal fifo_rd_en  : std_logic;    
   signal fifo_dval   : std_logic;
   signal hold_dval   : std_logic;
   signal tx_dval_i   : std_logic;
   signal full_i      : std_logic;    
   signal rx_busy_i   : std_logic;
   signal afull_i     : std_logic;    
   signal wr_err_i    : std_logic;
   signal empty_i     : std_logic;
   
   -- we will fix the following when we add async modes
   constant reset_rx    : std_logic := '0';
   constant reset_tx    : std_logic := '0';
   
begin
   
   async_fifo : if ASYNC generate
      
      -- instantiate an async fifo
      inst_afifo : afifo
      generic map(
         DWIDTH  => 36,
         AWIDTH  => AWIDTH,
         PROG_EMPTY_LEVEL => 0,
         PROG_FULL_LEVEL => 0)
      port map(
         WR_CLK  => CLK_RX,
         RD_CLK  => CLK_TX,
         ARESET  => ARESET,
         WR_EN   => fifo_dval,
         RD_EN   => fifo_rd_en,
         DIN     => fifo_din,
         DOUT    => fifo_dout,
         RD_LEVEL   => fifo_level_i,
         WR_LEVEL => TX_LEVEL,
         VALID   => fifo_rd_ack,
         OVFLOW  => wr_err_i,
         FULL    => full_i,
         EMPTY   => empty_i,
         PROG_FULL    => full_i,
         PROG_EMPTY   => empty_i
         );
      
   end generate;
   
   sync_fifo : if not ASYNC generate
      -- instantiate the appropriate fifo
      gen_fifo_16 : if AWIDTH <= 4 generate
         inst_fifo_16 : sfifo_16
         generic map(
            DWIDTH  => 36)
         port map(
            CLK     => CLK_RX,
            ARESET  => ARESET,
            WR_EN   => fifo_dval,
            RD_EN   => fifo_rd_en,
            DIN     => fifo_din,
            DOUT    => fifo_dout,
            LEVEL   => fifo_level_i,
            VALID   => fifo_rd_ack,
            OVFLOW  => wr_err_i,
            FULL    => full_i,
            EMPTY   => empty_i);
      end generate;
      
      gen_fifo_std : if AWIDTH > 4 generate
         inst_fifo_std : sfifo_std
         generic map(
            DWIDTH  => 36,
            AWIDTH  => AWIDTH)
         port map(
            CLK     => CLK_RX,
            ARESET  => ARESET,
            WR_EN   => fifo_dval,
            RD_EN   => fifo_rd_en,
            DIN     => fifo_din,
            DOUT    => fifo_dout,
            LEVEL   => fifo_level_i,
            VALID   => fifo_rd_ack,
            OVFLOW  => wr_err_i,
            FULL    => full_i,
            EMPTY   => empty_i);
      end generate;
      
      RX_LEVEL <= fifo_level_i;
      
   end generate;
   
   -- translate_off
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   -- translate_on
   
   -- it can be handy to know how filled the fifo is
   TX_LEVEL <= fifo_level_i;

   -- Fifo read control
   fifo_rd_en <= not TX_LL_MISO.AFULL and not (TX_LL_MISO.BUSY and tx_dval_i);
   
   tx_dval_i <= fifo_rd_ack or hold_dval;
   
   -- Write interface signals
   fifo_din <= (RX_LL_MOSI.DREM & RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA);
   fifo_dval <= RX_LL_MOSI.DVAL and not rx_busy_i;
   
   -- Output mapping                      
   TX_LL_MOSI.DVAL <= tx_dval_i;
   TX_LL_MOSI.DATA <= fifo_dout(31 downto 0);
   TX_LL_MOSI.EOF <= fifo_dout(32);
   TX_LL_MOSI.SOF <= fifo_dout(33);
   TX_LL_MOSI.DREM <= fifo_dout(35 downto 34);                
   
   no_latency : if Latency = 0 generate
      RX_LL_MISO.AFULL <= '0';
   end generate no_latency;
   
   with_latency : if Latency > 0 generate   
      
      afull_i <= '1' when (unsigned(fifo_level_i) >= (2**AWIDTH)-LATENCY-1) else '0';
      
      process (CLK_RX)
      begin                  
         if rising_edge(CLK_RX) then
            RX_LL_MISO.AFULL <= afull_i or reset_rx;
         end if;
      end process;
   end generate with_latency;
   
   rx_busy_i <= full_i or reset_rx;
   RX_LL_MISO.BUSY <= rx_busy_i;
   FULL <= full_i;
   EMPTY <= empty_i;
   WR_ERR <= wr_err_i; 
   
   -- DVALID latch (when RX is not ready, all we have to do is hold the DVal signal, the fifo interface does the rest)
   tx_proc : process (CLK_TX)
   begin	
      if rising_edge(CLK_TX) then
         if reset_tx = '1' then
            hold_dval <= '0'; 
         else       
            hold_dval <= TX_LL_MISO.BUSY and tx_dval_i;  
            -- translate_off
            assert (wr_err_i = '0') report "LocalLink fifo overflow!!!" severity ERROR;
            -- translate_on
         end if;		
      end if;
   end process; 
   
end rtl;

---------------------------------------------------------------------------------------------------
--  fifo_ll64  - synchronous locallink 64 bit wide fifo
---------------------------------------------------------------------------------------------------
library ieee;
library common_hdl;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use common_hdl.telops.all;

entity fifo_ll64 is
   generic(
      AWIDTH		   : natural := 9;      -- address width of the inffered storage element
      LATENCY        : natural := 0;      -- Input module latency (to control RX_LL_MISO.AFULL)
      ASYNC          : boolean := false); -- not yet supported!
   port(
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET		: in std_logic;
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      CLK_RX      : in std_logic;
      RX_LL_MOSI  : in  t_ll_mosi64;
      RX_LL_MISO  : out t_ll_miso;
      RX_LEVEL    : out std_logic_vector(AWIDTH-1 downto 0);
      FULL        : out std_logic;
      WR_ERR      : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      CLK_TX      : in std_logic;
      TX_LL_MOSI  : out t_ll_mosi64;
      TX_LL_MISO  : in  t_ll_miso;
      TX_LEVEL    : out std_logic_vector(AWIDTH-1 downto 0);
      EMPTY       : out std_logic);
end fifo_ll64;

architecture rtl of fifo_ll64 is
   
   component sfifo_std is
      generic(
         DWIDTH  : natural;   
         AWIDTH  : natural);
      port(
         CLK     : in  std_logic;
         ARESET  : in  std_logic;
         WR_EN   : in  std_logic;
         RD_EN   : in  std_logic;
         DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
         DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
         LEVEL   : out std_logic_vector(AWIDTH-1 downto 0);
         VALID   : out std_logic;
         OVFLOW  : out std_logic;
         FULL    : out std_logic;
         EMPTY   : out std_logic);
   end component;
   
   component sfifo_16 is
      generic(
         DWIDTH  : natural);
      port(
         CLK     : in  std_logic;
         ARESET  : in  std_logic;
         WR_EN   : in  std_logic;
         RD_EN   : in  std_logic;
         DIN     : in  std_logic_vector(DWIDTH-1 downto 0);
         DOUT    : out std_logic_vector(DWIDTH-1 downto 0);
         LEVEL   : out std_logic_vector(3 downto 0);
         VALID   : out std_logic;
         OVFLOW  : out std_logic;
         FULL    : out std_logic;
         EMPTY   : out std_logic);
   end component;
   
   component afifo is 
      generic ( 
         DWIDTH   : natural := 8;
         AWIDTH   : natural := 8; 
         PROG_EMPTY_LEVEL : natural := 0; 
         PROG_FULL_LEVEL : natural := 4 
         ); 
      port ( 
         ARESET : in  std_logic; 
         WR_CLK : in  std_logic; 
         WR_EN : in  std_logic; 
         DIN : in  std_logic_vector(DWIDTH-1 downto 0); 
         WR_LEVEL : out std_logic_vector(AWIDTH downto 0); 
         FULL : out std_logic; 
         RD_CLK : in std_logic; 
         RD_EN : in  std_logic; 
         DOUT : out std_logic_vector(DWIDTH-1 downto 0); 
         VALID : out std_logic; 
         RD_LEVEL : out std_logic_vector(AWIDTH downto 0); 
         OVFLOW : out std_logic; 
         EMPTY : out std_logic; 
         PROG_EMPTY : out std_logic := '0'; 
         PROG_FULL : out std_logic := '0'
         ); 
   end component;
   
   signal fifo_level_i : std_logic_vector(AWIDTH-1 downto 0);
   signal fifo_dout   : std_logic_vector(72 downto 0);
   signal fifo_din    : std_logic_vector(72 downto 0);
   signal fifo_rd_ack : std_logic;			
   signal fifo_rd_en  : std_logic;    
   signal fifo_dval   : std_logic;
   signal hold_dval   : std_logic;
   signal tx_dval_i   : std_logic;
   signal full_i      : std_logic;    
   signal rx_busy_i   : std_logic;
   signal afull_i     : std_logic;    
   signal wr_err_i    : std_logic;
   signal empty_i     : std_logic;
   
   -- we will fix the following when we add async modes
   constant reset_rx    : std_logic := '0';
   constant reset_tx    : std_logic := '0';
   
begin
   
   async_fifo : if ASYNC generate
      
      -- instantiate an async fifo
      inst_afifo : afifo
      generic map(
         DWIDTH  => 36,
         AWIDTH  => AWIDTH,
         PROG_EMPTY_LEVEL => 0,
         PROG_FULL_LEVEL => 0)
      port map(
         WR_CLK  => CLK_RX,
         RD_CLK  => CLK_TX,
         ARESET  => ARESET,
         WR_EN   => fifo_dval,
         RD_EN   => fifo_rd_en,
         DIN     => fifo_din,
         DOUT    => fifo_dout,
         RD_LEVEL   => fifo_level_i,
         WR_LEVEL => TX_LEVEL,
         VALID   => fifo_rd_ack,
         OVFLOW  => wr_err_i,
         FULL    => full_i,
         EMPTY   => empty_i,
         PROG_FULL    => full_i,
         PROG_EMPTY   => empty_i
         );
      
   end generate;
   
   sync_fifo : if not ASYNC generate
      -- instantiate the appropriate fifo
      gen_fifo_16 : if AWIDTH <= 4 generate
         inst_fifo_16 : sfifo_16
         generic map(
            DWIDTH  => 36)
         port map(
            CLK     => CLK_RX,
            ARESET  => ARESET,
            WR_EN   => fifo_dval,
            RD_EN   => fifo_rd_en,
            DIN     => fifo_din,
            DOUT    => fifo_dout,
            LEVEL   => fifo_level_i,
            VALID   => fifo_rd_ack,
            OVFLOW  => wr_err_i,
            FULL    => full_i,
            EMPTY   => empty_i);
      end generate;
      
      gen_fifo_std : if AWIDTH > 4 generate
         inst_fifo_std : sfifo_std
         generic map(
            DWIDTH  => 36,
            AWIDTH  => AWIDTH)
         port map(
            CLK     => CLK_RX,
            ARESET  => ARESET,
            WR_EN   => fifo_dval,
            RD_EN   => fifo_rd_en,
            DIN     => fifo_din,
            DOUT    => fifo_dout,
            LEVEL   => fifo_level_i,
            VALID   => fifo_rd_ack,
            OVFLOW  => wr_err_i,
            FULL    => full_i,
            EMPTY   => empty_i);
      end generate;
      
      RX_LEVEL <= fifo_level_i;
      
   end generate;
   
   -- translate_off
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   -- translate_on
   
   -- it can be handy to know how filled the fifo is
   TX_LEVEL <= fifo_level_i;

   -- Fifo read control
   fifo_rd_en <= not TX_LL_MISO.AFULL and not (TX_LL_MISO.BUSY and tx_dval_i);
   
   tx_dval_i <= fifo_rd_ack or hold_dval;
   
   -- Write interface signals
   fifo_din <= (RX_LL_MOSI.DREM & RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA);
   fifo_dval <= RX_LL_MOSI.DVAL and not rx_busy_i;
   
   -- Output mapping                      
   TX_LL_MOSI.DVAL <= tx_dval_i;
   TX_LL_MOSI.DATA <= fifo_dout(63 downto 0);
   TX_LL_MOSI.EOF <= fifo_dout(64);
   TX_LL_MOSI.SOF <= fifo_dout(65);
   TX_LL_MOSI.DREM <= fifo_dout(68 downto 66);                
   
   no_latency : if Latency = 0 generate
      RX_LL_MISO.AFULL <= '0';
   end generate no_latency;
   
   with_latency : if Latency > 0 generate   
      
      afull_i <= '1' when (unsigned(fifo_level_i) >= (2**AWIDTH)-LATENCY-1) else '0';
      
      process (CLK_RX)
      begin                  
         if rising_edge(CLK_RX) then
            RX_LL_MISO.AFULL <= afull_i or reset_rx;
         end if;
      end process;
   end generate with_latency;
   
   rx_busy_i <= full_i or reset_rx;
   RX_LL_MISO.BUSY <= rx_busy_i;
   FULL <= full_i;
   EMPTY <= empty_i;
   WR_ERR <= wr_err_i; 
   
   -- DVALID latch (when RX is not ready, all we have to do is hold the DVal signal, the fifo interface does the rest)
   tx_proc : process (CLK_TX)
   begin	
      if rising_edge(CLK_TX) then
         if reset_tx = '1' then
            hold_dval <= '0'; 
         else       
            hold_dval <= TX_LL_MISO.BUSY and tx_dval_i;  
            -- translate_off
            assert (wr_err_i = '0') report "LocalLink fifo overflow!!!" severity ERROR;
            -- translate_on
         end if;		
      end if;
   end process; 
   
end rtl;