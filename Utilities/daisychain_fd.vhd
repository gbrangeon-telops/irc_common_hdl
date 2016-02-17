---------------------------------------------------------------------------------------------------
--
-- Title       : daisychain_fd
-- Design      : Any FPGA
-- Author      : JPA & DGM
-- Company     : Telops Inc.
--
--------------------------------------------------------------------------------------------
--
-- Description : Cascaded flip-flop with variable length
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- pragma translate_off
library unisim;
-- pragma translate_on

entity daisychain_fd is
   generic(
      Len : integer := 4);
   port(
      D : in STD_LOGIC;
      Q : out STD_LOGIC := '0';
      ARESET : in STD_LOGIC;
      CLK : in STD_LOGIC
      );
end daisychain_fd;

architecture RTL of daisychain_fd is
   signal temp : std_logic_vector(Len-1 downto 1) := (others=> '0');
   component fd
      -- pragma translate_off
      generic ( INIT : bit := '0' );
      -- pragma translate_on
      port (
         Q : out std_ulogic;
         C : in std_ulogic;
         D : in std_ulogic
         );
   end component;	 
   -- pragma translate_off
   for all: fd use entity unisim.fd;
   -- pragma translate_on
begin
   
   flop1: FD port map (D => D, C => CLK, Q => temp(Len-1));
   gen: for i in 1 to Len-2 generate
      flop: FD port map (D => temp(i+1), C => CLK, Q => temp(i));
   end generate;
   flopEnd: FD port map (D => temp(1), C => CLK, Q => Q); 
   
   
end RTL;
