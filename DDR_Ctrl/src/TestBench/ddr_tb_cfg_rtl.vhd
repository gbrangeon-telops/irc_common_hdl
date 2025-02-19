---------------------------------------------------------------------------------------------------
--
-- Title       : ddr_tb_cfg
-- Design      : ddr_tb_cfg
-- Author      : Jean-Philippe D�ry
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

configuration ddr_tb_cfg_rtl of ddr_tb is
   for functional
      for fpga:ddr_mig
         use entity work.ddr_mig(RTL)
         generic map(SIMULATION => TRUE);
         for RTL
            for ddr_wrap:ddr_wrapper_128d_27a_r1
               use entity work.ddr_wrapper_128d_27a_r1(STRUCTURE); -- to use with ddr_wrapper_128d_27a_r1.vhm
               -- use entity work.ddr_wrapper_128d_27a_r1(SIM); -- to use with ddr_wrapper_128d_27a_r1.vhd
               for STRUCTURE
                  for ddr:ddr_top
                     use entity work.ddr_top(RTL);
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
end ddr_tb_cfg_rtl;
