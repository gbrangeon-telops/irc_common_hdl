---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: wb32_lib.vhd
--  Use: 32 bit wide wishbone package and library of parts
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------
-- Main package defining basic 32 bit wishbone bus types
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package wb32_pkg is
   
   type wb32_mosi_t is
   record
      ADR  : std_logic_vector(31 downto 0);
      DAT  : std_logic_vector(31 downto 0);
      SEL  : std_logic_vector(3 downto 0);
      STB  : std_logic;
      WE   : std_logic;
      CYC  : std_logic;
   end record;
   
   type wb32_miso_t is
   record
      DAT  : std_logic_vector(31 downto 0);
      ACK  : std_logic;
   end record;
   
   -- function prototypes for simulation
   -- translate_off
   procedure wr_wb(signal clk : in std_logic; addr : in std_logic_vector(31 downto 0); data : in  std_logic_vector(31 downto 0); signal wb_mosi : out wb32_mosi_t; signal wb_miso : in wb32_miso_t);
   procedure rd_wb(signal clk : in std_logic; addr : in std_logic_vector(31 downto 0); data : out  std_logic_vector(31 downto 0); signal wb_mosi : out wb32_mosi_t; signal wb_miso : in wb32_miso_t);
   -- translate_on
   function log2(x : natural) return integer; -- handy function for calculating bit ranges
   
end package wb32_pkg;

package body wb32_pkg is
   
   -- translate_off
   -- this part of package body is only provided for simulating stuff
   -- WishBone data transmition procedures
   procedure wr_wb(signal clk : in std_logic; addr : in std_logic_vector(31 downto 0); data : in  std_logic_vector(31 downto 0); signal wb_mosi : out wb32_mosi_t; signal wb_miso : in wb32_miso_t) is
   begin
      wb_mosi.DAT <= data;
      wb_mosi.ADR <= addr;
      wb_mosi.SEL <= (others => '1');
      wb_mosi.CYC <= '1';
      wb_mosi.STB <= '1';
      wb_mosi.WE  <= '1';
      wait until falling_edge(clk);
      while wb_miso.ACK /= '1' loop
         wait until falling_edge(clk);
      end loop;
      wb_mosi.DAT <= (others => '0');
      wb_mosi.ADR <= (others => '0');
      wb_mosi.CYC <= '0';
      wb_mosi.STB <= '0';
      wb_mosi.WE  <= '0';
   end procedure wr_wb;
   
   procedure rd_wb(signal clk : in std_logic; addr : in std_logic_vector(31 downto 0); data : out  std_logic_vector(31 downto 0); signal wb_mosi : out wb32_mosi_t; signal wb_miso : in wb32_miso_t) is
   begin
      wb_mosi.DAT <= (others => '0');
      wb_mosi.ADR <= addr;
      wb_mosi.SEL <= (others => '1');
      wb_mosi.CYC <= '1';
      wb_mosi.STB <= '1';
      wb_mosi.WE  <= '0';
      wait until rising_edge(clk);
      while wb_miso.ACK /= '1' loop
         wait until rising_edge(clk);
      end loop;
      data := wb_miso.DAT;
      wb_mosi.DAT <= (others => '0');
      wb_mosi.ADR <= (others => '0');
      wb_mosi.CYC <= '0';
      wb_mosi.STB <= '0';
      wb_mosi.WE  <= '0';
   end procedure rd_wb;
   -- translate_on
   
   -------------------------------------------------------------------------------
   -- Function log2 -- returns number of bits needed to encode x choices
   --   x = 0  returns 0
   --   x = 1  returns 0
   --   x = 2  returns 1
   --   x = 4  returns 2, etc.
   -------------------------------------------------------------------------------
   function log2(x : natural) return integer is
      variable i  : integer := 0; 
      variable val: integer := 1;
   begin 
      if x = 0 then return 0;
      else
         for j in 0 to 29 loop -- for loop for XST 
            if val >= x then null; 
            else
               i := i+1;
               val := val*2;
            end if;
         end loop;
         assert val >= x
         report "Function log2 received argument larger" &
         " than its capability of 2^30. "
         severity failure;
         return i;
      end if;  
   end function log2;
   
end package body wb32_pkg;

---------------------------------------------------------------------------------------------------
-- 32bit wishbone record to std logic adaptation block
-- be careful, there is no support for sel lines, only 32 bit accesses permitted
---------------------------------------------------------------------------------------------------
library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wb32_pkg.all;

entity wb32bit_slv_adapt is
   port(
      -- master side signals
      wb_data_o : in std_logic_vector(31 downto 0);
      wb_addr_o : in std_logic_vector(31 downto 0);
      wb_cyc_o  : in std_logic;
      wb_stb_o  : in std_logic;
      wb_we_o   : in std_logic;
      wb_data_i : out std_logic_vector(31 downto 0);
      wb_ack_i  : out std_logic;
      wb_err_i  : out std_logic;
      wb_rty_i  : out std_logic;
      -- slave side signals
      WB_MOSI   : out wb32_mosi_t;
      WB_MISO   : in wb32_miso_t);
end wb32bit_slv_adapt;

architecture rtl of wb32bit_slv_adapt is
   
begin
   WB_MOSI.DAT <= wb_data_o;
   WB_MOSI.ADR <= wb_addr_o;
   WB_MOSI.STB <= wb_stb_o;
   WB_MOSI.WE  <= wb_we_o;
   WB_MOSI.CYC <= wb_cyc_o;
   
   wb_data_i <= WB_MISO.DAT;
   wb_ack_i <= WB_MISO.ACK;
   wb_err_i <= '0';
   wb_rty_i <= '0';
   
end rtl;