---------------------------------------------------------------------------------------------------
--
-- Title       : Test Bench for div_float32_tb
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Université Laval-Faculté des Sciences et de Génie
--
---------------------------------------------------------------------------------------------------
--
-- File        : $DSN\src\Calibration\Testbench\div_float32_tb_TB.vhd
-- Generated   : 2006-11-10, 11:45
-- From        : $DSN\compile\div_float32_tb.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
---------------------------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for div_float32_tb_tb
--
---------------------------------------------------------------------------------------------------

library ieee,common_hdl;
use ieee.std_logic_1164.all;
use ieee.math_real.trunc;
use ieee.std_logic_arith.conv_std_logic_vector;
use common_hdl.telops.all;  
library aldec;
use aldec.matlab.all;
use aldec.random_pkg.all;

entity div_float32_tb_tb is
end div_float32_tb_tb;

architecture TB_ARCHITECTURE of div_float32_tb_tb is
   -- Component declaration of the tested unit
   component div_float32_tb
      port(
         ARESET : in std_logic;
         CLK : in std_logic;
         STALL1 : in std_logic;
         STALL2 : in std_logic;
         STALL_AFULL : in std_logic;
         STALL_BUSY : in std_logic;
         EXPON : in std_logic_vector(7 downto 0);
         DIV_ERR : out std_logic );
   end component;
   
   -- Stimulus signals - signals mapped to the input and inout ports of tested entity
   signal ARESET : std_logic;
   signal CLK : std_logic := '0';
   signal STALL1 : std_logic;
   signal STALL2 : std_logic;
   signal STALL_AFULL : std_logic;
   signal STALL_BUSY : std_logic := '0';
   signal EXPON : std_logic_vector(7 downto 0);
   -- Observed signals - signals mapped to the output ports of tested entity
   signal DIV_ERR : std_logic;
   
   -- Add your code here ...
   constant CLK_PERIOD : time := 10 ns;
   
begin
   
   CLK_GEN: process(CLK)
   begin
   	CLK<= not CLK after CLK_PERIOD/2; 
   end process; 
   
   RESET_GEN: process
   begin       
      ARESET <= '1';
      wait for 115 ns;
      ARESET <= '0';
      wait;
   end process;  
    
   -- Unit Under Test port map
   UUT : div_float32_tb
   port map (
      ARESET => ARESET,
      CLK => CLK,
      STALL1 => STALL1,
      STALL2 => STALL2,
      STALL_AFULL => STALL_AFULL,
      STALL_BUSY => STALL_BUSY,
      EXPON => EXPON,
      DIV_ERR => DIV_ERR
      );
   
   MATLAB_INIT: process 
      variable fi_expon : integer;
   begin   
      eval_string("prepare_workspace");
      get_variable("fi_expon", fi_expon);
      EXPON <= conv_std_logic_vector(fi_expon, EXPON'LENGTH);            
      wait; 
   end process;     
   
   uniform_prc: process
      -- parameters of waveform -----
      constant cycle:	time	:= 10 ns;													 									  
      constant seed:	integer	:= 1;
      constant rlow:	integer	:= 0;
      constant rhigh:	integer	:= 127;
      --------------------------------
      
      variable vseed:	integer := seed;
      variable rlow_v:	integer := rlow;
      variable rhigh_v:	integer := rhigh;	
      variable r:			real;         
      variable r_slv:   std_logic_vector(7 downto 0);
      
      variable result:	integer;		
   begin 
      loop	-- while(not endsim) loop
         if (rlow > rhigh) then
            rlow_v := rhigh;
            rhigh_v := rlow;
         end if;
         if (rhigh /= integer'high) then
            rhigh_v := rhigh + 1;
            uniform_p(vseed, rlow_v, rhigh_v, r);  
            if (r >= 0.0) then
               result := integer(trunc(r));
            else
               result := integer(trunc(r-1.0));
            end if;
            if (result < rlow_v) then result := rlow_v; end if;
            if (result >= rhigh_v) then result := rhigh_v-1; end if;
         elsif (rlow /= integer'low) then
            rlow_v := rlow - 1;
            uniform_p(vseed, rlow_v, rhigh_v, r);
            r := r + 1.0;
            if (r >= 0.0) then
               result := integer(trunc(r));
            else
               result := integer(trunc(r-1.0));
            end if;
            if (result <= rlow_v) then result := rlow_v+1; end if;
            if (result > rhigh_v) then result := rhigh_v; end if;
         else
            uniform_p(vseed, rlow_v, rhigh_v, r);
            r := (r + 2147483648.0)/4294967295.0;
            r := r*4294967296.0 - 2147483648.0;
            if (r >= 0.0) then
               result := integer(trunc(r));
            else
               result := integer(trunc(r-1.0));
            end if;
         end if;		
         
         -- main assigment(s):
         r_slv := conv_std_logic_vector(result,r_slv'LENGTH);
--         STALL1 <= '0';
--         STALL2 <= '0';
--         --STALL_BUSY <= '0';
--         STALL_BUSY <= not STALL_BUSY;
--         STALL_AFULL <= '0';         
         STALL1 <= r_slv(0);
         STALL2 <= r_slv(1);
         STALL_BUSY <= r_slv(2);
         STALL_AFULL <= r_slv(3);
         -- sig1 <= result;									-- integer
         -- sig2 <= r;										-- real
         -- sig3 <= conv_std_logic_vector(result, WIDTH);	-- std_logic_vector
         -- sig4 <= conv_unsigned(result, WIDTH);			-- unsigned
         -- sig5 <= conv_signed(result, WIDTH);				-- signed
         wait for cycle;
      end loop;
   end process uniform_prc;   
   
end TB_ARCHITECTURE;

--configuration TESTBENCH_FOR_div_float32_tb of div_float32_tb_tb is
--   for TB_ARCHITECTURE
--      for UUT : div_float32_tb
--         use entity work.div_float32_tb(sch);
--      end for;
--   end for;
--end TESTBENCH_FOR_div_float32_tb;

