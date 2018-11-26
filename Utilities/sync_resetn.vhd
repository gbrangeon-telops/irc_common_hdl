---------------------------------------------------------------------------------------------------
--
-- Title       : sync_resetn
-- Design      : 
-- Author      : Patrick Daraiche
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

entity sync_resetn is
   port(
      ARESETN : in STD_LOGIC;
      SRESETN : out STD_LOGIC := '0';
      CLK    : in STD_LOGIC
      );
end sync_resetn;

architecture RTL of sync_resetn is
   signal temp : std_logic := '0';     
   
   attribute ASYNC_REG : string;   
   attribute ASYNC_REG of SRESETN: signal is "TRUE";
   attribute ASYNC_REG of temp: signal is "TRUE";
  
   
--   component FDCP
--      -- synthesis translate_off
--      generic (INIT : bit := '0');
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
--   generic map (INIT => '0')
--   -- synthesis translate_on
--   port map (Q => temp,
--      C => CLK,
--      CLR => '0',
--      D => ARESET,
--      PRE => ARESET);
--   
--   flop2 : FDCP
--   -- synthesis translate_off
--   generic map (INIT => '0')
--   -- synthesis translate_on
--   port map (Q => SRESET,
--      C => CLK,
--      CLR => '0',
--      D => temp,
--      PRE => ARESET);    
      
      
   process(CLK, ARESETN)
   begin
      if ARESETN = '0' then
         SRESETN <= '0'; 
         temp <= '0'; 
      elsif rising_edge(CLK) then
         temp <= ARESETN;
         SRESETN <= temp;
      end if;
   end process;   
   
end RTL;
