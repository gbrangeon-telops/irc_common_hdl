-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_parameters_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: According to the user inputs the parameters are defined here.
--              These parameters are used for the generic memory interface
--              code. Various parameters are address widths, data widths,
--              timing parameters according to the frequency selected by
--              the user and some internal parameters also.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

package mem_interface_top_parameters_0 is

constant   data_width                                : INTEGER   :=  16;
constant   data_strobe_width                         : INTEGER   :=  2;
constant   data_mask_width                           : INTEGER   :=  2;
constant   clk_width                                 : INTEGER   :=  1;
constant   fifo_16                                   : INTEGER   :=  1;
constant   ReadEnable                                : INTEGER   :=  1;
constant   memory_width                              : INTEGER   :=  8;
constant   DatabitsPerReadClock                      : INTEGER   :=  8;
constant   DatabitsPerMask                           : INTEGER   :=  8;
constant   no_of_cs                                  : INTEGER   :=  1;
constant   data_mask                                 : INTEGER   :=  1;
constant   mask_disable                              : INTEGER   :=  0;
constant   RESET                                     : INTEGER   :=  0;
constant   cke_width                                 : INTEGER   :=  1;
constant   registered                                : INTEGER   :=  0;
constant   col_ap_width                              : INTEGER   :=  11;
constant   DatabitsPerStrobe                         : INTEGER   :=  4;
constant   low_frequency                             : INTEGER   :=  1;
constant   high_frequency                            : INTEGER   :=  0;
constant   row_address                               : INTEGER   :=  13;
constant   column_address                            : INTEGER   :=  10;
constant   bank_address                              : INTEGER   :=  2;
constant   burst_length                             		: std_logic_vector(2 downto 0) := "001";
constant   burst_type                               		: std_logic :=  '0';
constant   cas_latency_value                        		: std_logic_vector(2 downto 0) := "011";
constant   Operating_mode                           		: std_logic_vector(4 downto 0) := "00000";
constant   load_mode_register                        : std_logic_vector(12 downto 0) := "0000000110001";

constant   drive_strengh                            		: std_logic :=  '0';
constant   dll_enable                               		: std_logic :=  '0';
constant   ext_load_mode_register                    : std_logic_vector(12 downto 0) := "0000000000000";

constant   chip_address                              : INTEGER   :=  1;
constant   reset_active_low                         : std_logic := '1';
constant   tby4tapvalue                             : std_logic_vector(5 downto 0) := "010001";
constant   rcd_count_value                           : std_logic_vector(2 downto 0) := "010";
constant   ras_count_value                           : std_logic_vector(3 downto 0) := "0110";
constant   mrd_count_value                           : std_logic := '0';
constant   rp_count_value                             : std_logic_vector(2 downto 0) := "010";
constant   rfc_count_value                            : std_logic_vector(5 downto 0) := "001101";
constant   twr_count_value                            : std_logic_vector(2 downto 0) := "110";
constant   twtr_count_value                      : std_logic_vector(2 downto 0) := "100";
constant   max_ref_width                                   : INTEGER   :=  11;
constant   max_ref_cnt                     : std_logic_vector(10 downto 0) := "10011101101";

constant    Phy_Mode                 : std_logic := '1';
constant    trtp_count_value         : std_logic_vector(2 downto 0) := "011";
constant    rc_count_value           : std_logic_vector(3 downto 0) := "1111";   -- active to active same bank = tRC-1
constant    read_enables             : integer := 1;

constant    cs_h0               : std_logic_vector(3 downto 0)  := "0000";
constant    cs_hE               : std_logic_vector(3 downto 0)  := "1110";
constant    cs_hD               : std_logic_vector(3 downto 0)  := "1101";
constant    cs_hB               : std_logic_vector(3 downto 0)  := "1011";
constant    cs_h7               : std_logic_vector(3 downto 0)  := "0111";
constant    cs_hF               : std_logic_vector(3 downto 0)  := "1111" ;
constant    add_const1          : std_logic_vector(15 downto 0) := X"0400" ;
constant    add_const2          : std_logic_vector(15 downto 0) := X"0100" ;
constant    add_const3          : std_logic_vector(15 downto 0) := X"0000" ;
constant    add_const4          : std_logic_vector(15 downto 0) := X"FBFF" ;
constant    add_const5          : std_logic_vector(15 downto 0) := X"FEFF" ;
constant    add_const6          : std_logic_vector(15 downto 0) := X"0002" ;
constant    add_const7          : std_logic_vector(15 downto 0) := X"0004" ;
constant    add_const8          : std_logic_vector(15 downto 0) := X"0008" ;

end mem_interface_top_parameters_0;
