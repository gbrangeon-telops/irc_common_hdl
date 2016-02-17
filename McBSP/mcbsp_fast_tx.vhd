---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: mcbsp_fast_tx.vhd
--  Hierarchy: Sub-module file
--  Use: send N bits of data into N/M M bits mcbsp chunks using the fastest throughput 
--  (fsx for next word during the LSB from previous word).
--
--  M can be either 8, 16, or 32. N must be an integer multiple of M.
--
--  use with a fifo : fifo_valid => nd_in, rfd => fifo_rd_en, fifo_dout => din
--  all inputs in McBSP_CLKX domain
--
-- TO DO: DONE and RFD rising delay should be configurable using generics.
--
--  Revision history:  (use SVN for exact code history)
--    SSA : Apr 05, 2007 - original implementation
--
--  Notes:
--  $Revision$ 
--  $Author$
--  $LastChangedDate$
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity mcbsp_fast_tx is
   generic (
      N: integer := 32;
      M: integer := 8
      );
   port(
      McBSP_CLKX : in std_logic;
      ND_IN : in std_logic;
      DIN : in std_logic_vector(N-1 downto 0);
      McBSP_DX : out std_logic;
      McBSP_FSX : out std_logic;
      RFD : out std_logic;                        -- stays high when all the data bits have been shifted
      DONE : out std_logic		          -- 1 CP large when all data bits have been shifted
      );
end mcbsp_fast_tx;


architecture rtl of mcbsp_fast_tx is
   
   signal data_sr: std_logic_vector(N-1 downto 0) := (others => '0');
   -- shifted when a complete M bit word is shifted
   signal word_valid: std_logic_vector(N/M-1 downto 0) := (others => '0');
   signal rfd_int: std_logic := '0';
   signal done_int: std_logic := '0';
   
   signal mcbsp_valid: std_logic_vector(M-1 downto 0) := (others => '0');
   signal fsx_int: std_logic := '0';
   
begin
   
   RFD <= rfd_int;
   DONE <= done_int;
   
   McBSP_FSX <= fsx_int;
   McBSP_DX <= data_sr(N-1);
   
   mcbsp_shift: process(McBSP_CLKX)
      variable wait1: std_logic := '0';
   begin
      if rising_edge(McBSP_CLKX) then
         if ND_IN = '1' then
            data_sr <= DIN;
            word_valid <= (others => '1');
            word_valid(N/M-1) <= '0';
            mcbsp_valid <= (others => '1');
            fsx_int <= '1';
            wait1 := '0';
            rfd_int <= '0';
            done_int <= '0';
         else
            rfd_int <= not mcbsp_valid(1) and not word_valid(0);
            done_int <= not mcbsp_valid(1) and mcbsp_valid(0) and not word_valid(0);
            fsx_int <= '0';
            -- begin serial data after frame sync only 
            if wait1 = '1' then
               data_sr <= data_sr(N-2 downto 0) & '0';
               mcbsp_valid <= '0' & mcbsp_valid(M-1 downto 1);
            else
               wait1 := '1';
            end if;
            
            if mcbsp_valid(2 downto 1) = "01" and word_valid(0) = '1' then
               fsx_int <= '1';
            end if;
            
            if mcbsp_valid(1 downto 0) = "01" and word_valid(0) = '1' then
               mcbsp_valid <= (others => '1');
               word_valid <= '0' & word_valid(N/M-1 downto 1);
            end if;
         end if;
      end if;
   end process;	   
   
end rtl;
