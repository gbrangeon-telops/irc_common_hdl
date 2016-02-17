-------------------------------------------------------------------------------
--
-- Title       : rand_sequence
-- Author      : Simon Savary
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.all;
library work;
use work.LfsrStd_Pkg.all;


entity rand_sequence is  
   generic(            
      Random : boolean := true;
      random_seed : std_logic_vector(19 downto 0) := x"E9D30"; -- --Pseudo-random generator seed
      STATEDURATION : integer := 20;  -- Duration any output state in clock cycles
      LEN : natural := 20);     
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      STATE          : out std_logic_vector(LEN-1 downto 0)
      );
end rand_sequence;


architecture rtl of rand_sequence is
   
   signal lfsr_reg     : std_logic_vector(LEN-1 downto 0) := (others => '0');   -- To avoid X in simulation
   signal count : unsigned(7 downto 0);
   signal sreset : std_logic;
   
   signal LFSR_seed : std_logic_vector(LEN-1 downto 0) := std_logic_vector(resize(signed(random_seed),LEN));
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   STATE <= lfsr_reg;
   
   process(CLK)
   begin
      if rising_edge(CLK) then
         if sreset = '1' then
            lfsr_reg <= LFSR_seed;
            count <= (others =>'0');
         else
            if count = to_unsigned(STATEDURATION,count'length) then
               lfsr_reg <= LFSR(lfsr_reg);
               count <= (others =>'0');
            else
               count <= count + 1;
            end if;
         end if;
      end if;
   end process;
   
end rtl;
