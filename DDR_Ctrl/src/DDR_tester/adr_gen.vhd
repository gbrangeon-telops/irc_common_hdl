---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: adr_gen.vhd
--  Hierarchy: Sub-module file
--  Use: pseudo-random 28 bit address generator for memory test
--	 Project: GATORADE2 - In system memory tester
--	 By: Olivier Bourgois
--  Date: October 27, 2005
--
--  Note: most bits switch every enabled clock to maximize Simultaneous Switching outputs
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adr_gen is
   port(
      CLK     : in std_logic;
      RST_ADR : in std_logic;
      NXT_ADR : in std_logic;
      LST_ADR : out std_logic;
      ADR     : out std_logic_vector(27 downto 0));
end entity adr_gen;

architecture rtl of adr_gen is
   -- the memory test address paterns are generated as follows:
   -- 1) a counter generates a linear address, but it is updated every second access
   -- 2) to maximize SSO every second address is the inversion of the first
   
   signal acnt      : std_logic_vector(26 downto 0);
   signal adr_q     : std_logic_vector(26 downto 0);
   
   -- in synthesis we let the counter max out but in sim we stop much earlier
   constant acnt_end     : std_logic_vector(25 downto 0) := (others => '1');
   -- translate_off
   constant acnt_simend   : std_logic_vector(25 downto 0) := "00" & x"00007F";
   -- translate_on
   
begin

   -- address counter
   acnt_proc : process(CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST_ADR = '1') then
               acnt <= (0 => '1', others => '0');
         elsif (NXT_ADR = '1') then
               acnt <= acnt + 1;
         end if;
      end if;
   end process acnt_proc;
   
   -- last address detector
   end_detect : process(CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST_ADR = '1') then
            LST_ADR <= '0';
         elsif (NXT_ADR = '1') then
            if (acnt = acnt_end) then
               LST_ADR <= '1';
            -- translate_off
            elsif (acnt = acnt_simend) then
               LST_ADR <= '1';
            -- translate_on
            end if;
         end if;
      end if;
   end process end_detect;
   
   -- address generator from acnt
   adr_gen_proc : process(CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (RST_ADR = '1') then
            adr_q <= (others => '0');
            --acnt_incr <= '1';
         elsif (NXT_ADR = '1') then
            if (acnt(0) = '1') then
               adr_q <= not adr_q;
            else
               adr_q <= '0' & acnt(acnt'length-1 downto 1);
            end if;
         end if;
      end if;
   end process adr_gen_proc;
   
   -- output mapping (note we always write two data starting at even address so ADR(0) is always 0)
   ADR(0) <= '0';
   ADR(ADR'length -1 downto 1) <= adr_q;
   
end rtl;