---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: sync_rising_edge.vhd
--  Hierarchy: Sub-module file
--  Use: synchronize a rising edge from 'Pulse' with the input CLK. 'Pulse' width
--		must at least be as large as a CLK period in order to be "seen".
--
--  Revision history:  (use SVN for exact code history)
--    SSA : Apr 13, 2007
--
--  Notes: 
--
--  $Revision$ 
--  $Author$
--  $LastChangedDate$
---------------------------------------------------------------------------------------------------

library IEEE;
library common_hdl;
use IEEE.STD_LOGIC_1164.all;

entity sync_rising_edge is
   port(
      Pulse : in STD_LOGIC;
      CLK : in STD_LOGIC;
      Pulse_out_sync : out STD_LOGIC
      );
end sync_rising_edge;

architecture rtl of sync_rising_edge is 
   signal pulse_q : std_logic := '0'; 
  
begin
    
   double_buffer: entity double_sync(rtl)
   port map (
      D => Pulse,
      Q => pulse_q,
      RESET => '0',
      CLK => CLK
      );
   
   detect_rising_edge : process(CLK)
      variable pulse_hist : std_logic_vector(1 downto 0);
   begin
      if CLK'event and CLK = '1' then
         if pulse_hist = "01" then
            Pulse_out_sync <= '1';
         else
            Pulse_out_sync <= '0';
         end if;
         pulse_hist := pulse_hist(0) & pulse_q;
      end if;
   end process detect_rising_edge;
   
end rtl;
