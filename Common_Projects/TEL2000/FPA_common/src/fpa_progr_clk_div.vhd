-------------------------------------------------------------------------------
--
-- Title       : progr_clk_div
-- Design      : Trig_ctrl_tb
-- Author      : Telops Inc
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : 
-- Generated   : Mon Nov  2 14:40:02 2009
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 

entity fpa_progr_clk_div is
   
   port (
      CLK              : in  std_logic; 	
      ARESET           : in  std_logic;
      PULSE_PERIOD     : in  std_logic_vector(7 downto 0); -- si PULSE_PERIOD vaut 1 alors pulse reste à '1' indefiniment et c'est ce qui est voulu
      PULSE            : out std_logic);
end fpa_progr_clk_div;


architecture RTL of fpa_progr_clk_div is
   
   component sync_reset
      port(
         ARESET : in STD_LOGIC;
         SRESET : out STD_LOGIC;
         CLK    : in STD_LOGIC);
   end component;
   
   signal sreset      : std_logic;
   signal pulse_i     : std_logic;
   signal div_cnt     : unsigned(7 downto 0);
   
begin 
   
   -----------------------------------------------------
   -- Synchronisation reset
   -----------------------------------------------------
   U1: sync_reset
   Port map(		
      ARESET   => ARESET,		
      SRESET   => sreset,
      CLK   => CLK);
   
   -----------------------------------------------------
   -- output 
   -----------------------------------------------------
   PULSE <= pulse_i;     
   
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then
         if (sreset = '1') then
            div_cnt <= to_unsigned(1, div_cnt'length);
            pulse_i <= '0';
            
         else	 
            
            pulse_i <= '0';
            div_cnt <= div_cnt - 1;
            if div_cnt = 1 then 
               div_cnt <= unsigned(PULSE_PERIOD);
               pulse_i <= '1';
            end if;
            
         end if;
      end if;
   end process;
   
   
end RTL;
