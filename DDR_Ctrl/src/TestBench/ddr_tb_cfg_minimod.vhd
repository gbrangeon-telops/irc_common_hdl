---------------------------------------------------------------------------------------------------
--
-- Title       : ddr_tb_cfg
-- Design      : ddr_tb_cfg
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : Testbench configuration for MIG memory controller
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.all;

configuration ddr_tb_cfg of ddr_tb is
   for functional
      for fpga:ddr_mig
         use entity work.ddr_mig(RTL)
            generic map(SIMULATION => TRUE);
         for RTL
            for ddr_wrap:ddr_wrapper_128d_26a_r0
--               use entity work.ddr_wrapper_128d_26a_r0(STRUCTURE); -- to use with ddr_wrapper_128d_26a_r0.vhm
               use entity work.ddr_wrapper_128d_26a_r0(SIM); -- to use with ddr_wrapper_128d_26a_r0.vhd
               for STRUCTURE
                  for ddr:ddr_top
                     for RTL
                        for ddr_arbiter:ddr_block
                           for ddr_block
                              for U32:ddr_tester
                                 for from_bde
                                    for U1:mctrl_iface
                                       use entity work.mctrl_iface(rtl)
                                       generic map(SIMULATION => FALSE);
                                    end for;
                                    for U5:dat_path
                                       use entity work.dat_path(rtl)
                                       generic map(SIMULATION => FALSE);
                                    end for;
                                 end for;
                              end for;
                           end for;
                        end for;
                     end for;
                  end for;
               end for;
            end for;
         end for;
      end for;
   end for;
end ddr_tb_cfg;
