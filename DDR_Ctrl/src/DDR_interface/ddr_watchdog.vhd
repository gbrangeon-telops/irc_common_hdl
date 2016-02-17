-------------------------------------------------------------------------------
--
-- Title       : ddr_watchdog
-- Design      : FIR_00186
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;   
library Common_HDL;

entity ddr_watchdog is
   port(
      CORE_INITDONE  : in std_logic;
      CORE_RESET     : out std_logic;
      
      ARESET         : in std_logic;
      CLK            : in std_logic      
      );
end ddr_watchdog;


architecture RTL of ddr_watchdog is
   signal reset      : std_logic;   
   signal reset_core : std_logic;
   signal time_delay : unsigned(24 downto 0); -- 320 ms
   
	component sync_reset
	port(
		ARESET : in std_logic;
		SRESET : out std_logic;
		CLK : in std_logic);
	end component;
   
begin                                                      
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => reset, CLK => CLK);   
   
   CORE_RESET <= ARESET or reset_core;
   
   main : process(CLK)
   begin  
      if rising_edge(CLK) then
         
         -- Wrap around every 320 ms
         time_delay <= time_delay + 1;
         
         -- Reset the core if INITDONE is 0.
         if time_delay = 0 and CORE_INITDONE = '0' then
            reset_core <= '1';
         elsif time_delay = 10 then -- Hold the reset for 10 clock cycles.
            reset_core <= '0';
         end if;
         
         if reset = '1' then
            reset_core <= '1';
            time_delay <= (others => '0');
         end if;
      end if;
   end process;
   
end RTL;
