---------------------------------------------------------------------------------------------------
--
-- Title       : sync_reset
-- Design      : VP7
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
--------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- pragma translate_off
library unisim;
-- pragma translate_on

entity sync_reset is
   port(
      ARESET : in STD_LOGIC;
      SRESET : out STD_LOGIC := '1';
      CLK    : in STD_LOGIC
      );
end sync_reset;

architecture RTL of sync_reset is
   signal temp : std_logic := '1';
   
   attribute ASYNC_REG : string;   
   attribute ASYNC_REG of SRESET: signal is "TRUE";
   attribute ASYNC_REG of temp: signal is "TRUE";
   
--   component FDCP
--      -- synthesis translate_off
--      generic (INIT : bit := '1');
--      -- synthesis translate_on
--      port (Q : out STD_ULOGIC;
--         C : in STD_ULOGIC;
--         CLR : in STD_ULOGIC;
--         D : in STD_ULOGIC;
--         PRE : in STD_ULOGIC);
--   end component;
   
begin  
   
--   flop1 : FDCP
--   -- synthesis translate_off
--   generic map (INIT => '1')
--   -- synthesis translate_on
--   port map (Q => temp,
--      C => CLK,
--      CLR => '0',
--      D => ARESET,
--      PRE => ARESET);
--   
--   flop2 : FDCP
--   -- synthesis translate_off
--   generic map (INIT => '1')
--   -- synthesis translate_on
--   port map (Q => SRESET,
--      C => CLK,
--      CLR => '0',
--      D => temp,
--      PRE => ARESET);    
      
      
   process(CLK, ARESET)
   begin
      if ARESET = '1' then
         SRESET <= '1'; 
         temp <= '1'; 
      elsif rising_edge(CLK) then
         temp <= ARESET;
         SRESET <= temp;
      end if;
   end process;   
   
end RTL;
