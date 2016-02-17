---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: sfifo.vhd
--  Use: synchronous fifo with configurable depth and width
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
library common_hdl;
use common_hdl.sync_reset;

entity sfifo is
   generic(
      DWIDTH   : natural := 8;     -- data bit width
      AWIDTH   : natural := 8;    -- address bit width for infered storage element
      PROG_EMPTY_LEVEL : natural := 255;
      PROG_FULL_LEVEL : natural := 4
      );
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
      EMPTY   : out std_logic;
      PROG_EMPTY : out std_logic;
      PROG_FULL : out std_logic
      );
end sfifo;

architecture rtl of sfifo is
   
   type ram_type is array ((2**AWIDTH)-1 downto 0) of std_logic_vector (DWIDTH-1 downto 0);
   signal RAM : ram_type;
   signal wr_ptr   : unsigned(AWIDTH-1 downto 0) := (others => '0');
   signal wr_en_i  : std_logic := '0';
   signal rd_ptr   : unsigned(AWIDTH-1 downto 0) := (others => '0');
   signal level_i    : unsigned(AWIDTH-1 downto 0) := (others => '0');
   signal rd_en_i  : std_logic := '0';
   signal valid_i  : std_logic := '0';
   signal empty_i  : std_logic := '1';
   signal ovflow_i  : std_logic := '0';
   signal full_i   : std_logic := '0';
   signal rst_sync : std_logic := '0';
   
   component sync_reset is
      port(
         ARESET : in STD_LOGIC;
         SRESET : out STD_LOGIC := '1';
         CLK    : in STD_LOGIC
         );
   end component;
   
begin
   
   PROG_EMPTY <= '1' when level_i <= PROG_EMPTY_LEVEL else '0';
   PROG_FULL <= '1' when level_i >= PROG_FULL_LEVEL else '0';
   
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
