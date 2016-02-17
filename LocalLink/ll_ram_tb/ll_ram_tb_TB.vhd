-------------------------------------------------------------------------------
--
-- Title       : Test Bench for ll_ram_tb
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for ll_ram_tb_tb
--
-------------------------------------------------------------------------------

library ieee,common_hdl;
use ieee.std_logic_1164.all; 
use ieee.math_real.trunc;
use ieee.std_logic_arith.conv_std_logic_vector;
use common_hdl.telops.all;

library aldec;
use aldec.matlab.all;
use aldec.random_pkg.all;

-- Add your library and packages declaration here ...

entity ll_ram_tb_tb is
end ll_ram_tb_tb;

architecture TB_ARCHITECTURE of ll_ram_tb_tb is
   -- Component declaration of the tested unit
   component ll_ram_tb
      port(
         ARESET : in std_logic;
         CLK : in std_logic;
         LOAD : in std_logic;
         RST_PTR : in std_logic;
         STALL_AFULL : in std_logic;
         STALL_BUSY : in std_logic;
         VIN_MOSI_BUF : out t_ll_mosi21;
         VIN_MISO_BUF : out t_ll_miso;
         STALL_VIN : in std_logic );
   end component;
   
   -- Stimulus signals - signals mapped to the input and inout ports of tested entity
   signal ARESET : std_logic;
   signal CLK : std_logic := '0';
   signal LOAD : std_logic;
   signal RST_PTR : std_logic;
   signal STALL_AFULL : std_logic;
   signal STALL_BUSY : std_logic;
   signal STALL_VIN : std_logic;
   signal VIN_MOSI_BUF : t_ll_mosi21;
   signal VIN_MISO_BUF : t_ll_miso;   
   -- Observed signals - signals mapped to the output ports of tested entity
   
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
   
   
   MATLAB_INIT: process
   begin 
      eval_string("prepare_workspace");
      LOAD <= '1';
      RST_PTR <= '0';
      wait until (VIN_MOSI_BUF.EOF='1' and VIN_MOSI_BUF.DVAL='1' and VIN_MISO_BUF.BUSY='0');
      LOAD <= '0';
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
         --STALL_VIN <= '0';
         --STALL_BUSY <= '0';
         --STALL_AFULL <= '0';
         STALL_VIN <= r_slv(3);
         STALL_BUSY <= r_slv(4);
         STALL_AFULL <= r_slv(5);
         wait for cycle;
      end loop;
   end process uniform_prc;   
   
   
   -- Unit Under Test port map
   UUT : ll_ram_tb
   port map (
      ARESET => ARESET,
      CLK => CLK,
      LOAD => LOAD,
      RST_PTR => RST_PTR,
      STALL_AFULL => STALL_AFULL,
      STALL_BUSY => STALL_BUSY,
      STALL_VIN => STALL_VIN,
      VIN_MOSI_BUF => VIN_MOSI_BUF,
      VIN_MISO_BUF => VIN_MISO_BUF
      );
   
   -- Add your stimulus here ...
   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_ram_tb of ll_ram_tb_tb is
   for TB_ARCHITECTURE
      for UUT : ll_ram_tb
         use entity work.ll_ram_tb(ll_ram_tb);
      end for;
   end for;
end TESTBENCH_FOR_ll_ram_tb;

