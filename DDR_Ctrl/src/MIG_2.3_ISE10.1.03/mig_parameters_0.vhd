--*****************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under license
-- from Xilinx, Inc., and may be used, copied and/or
-- disclosed only pursuant to the terms of a valid license
-- agreement with Xilinx, Inc. Xilinx hereby grants you a
-- license to use this text/file solely for design, simulation,
-- implementation and creation of design files limited
-- to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and
-- immediately terminates your license unless covered by
-- a separate agreement.
--
-- Xilinx is providing this design, code, or information
-- "as-is" solely for use in developing programs and
-- solutions for Xilinx devices, with no obligation on the
-- part of Xilinx to provide support. By providing this design,
-- code, or information as one possible implementation of
-- this feature, application or standard, Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for
-- obtaining any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are
-- done at the user's sole risk and will be unsupported.
--
-- Copyright (c) 2005-2007 Xilinx, Inc. All rights reserved.
--
-- This copyright and support notice must be retained as part
-- of this text at all times.
--*****************************************************************************
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : 2.3
--  \   \        Application        : MIG
--  /   /        Filename           : mig_parameters_0.vhd
-- /___/   /\    Date Last Modified : $Date$
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
--*****************************************************************************

library ieee;
use ieee.std_logic_1164.all;
library UNISIM;
use UNISIM.vcomponents.all;

package mig_parameters_0 is

-- The reset polarity is set to active low by default.
-- You can change this by editing the parameter RESET_ACTIVE_LOW.
-- Please do not change any of the other parameters directly by editing the RTL.
-- All other changes should be done through the GUI.

constant   DATA_WIDTH                                : INTEGER   :=  72;
constant   DATA_STROBE_WIDTH                         : INTEGER   :=  18;
constant   DATA_MASK_WIDTH                           : INTEGER   :=  9;
constant   CLK_WIDTH                                 : INTEGER   :=  1;
constant   FIFO_16                                   : INTEGER   :=  5;
constant   READENABLE                                : INTEGER   :=  5;
constant   ROW_ADDRESS                               : INTEGER   :=  13;
constant   MEMORY_WIDTH                              : INTEGER   :=  4;
constant   DATABITSPERREADCLOCK                      : INTEGER   :=  4;
constant   DATABITSPERSTROBE                         : INTEGER   :=  4;
constant   NO_OF_CS                                  : INTEGER   :=  1;
constant   DATA_MASK                                 : INTEGER   :=  0;
constant   RESET_PORT                                : INTEGER   :=  1;
constant   REGISTERED                                : INTEGER   :=  1;
constant   CKE_WIDTH                                 : INTEGER   :=  1;
constant   MASK_ENABLE                               : INTEGER   :=  0;
constant   USE_DM_PORT                               : INTEGER   :=  0;
constant   COLUMN_ADDRESS                            : INTEGER   :=  11;
constant   BANK_ADDRESS                              : INTEGER   :=  2;
constant   DEBUG_EN                                  : INTEGER   :=  0;
constant   DQ_BITS                                   : INTEGER   :=  7;
constant   LOAD_MODE_REGISTER                        : std_logic_vector(12 downto 0) := "0000001100001";

constant   EXT_LOAD_MODE_REGISTER                    : std_logic_vector(12 downto 0) := "0000000000000";

constant   CHIP_ADDRESS                              : INTEGER   :=  1;
constant   RESET_ACTIVE_LOW                         : std_logic := '1';
constant   TBY4TAPVALUE                             : INTEGER   :=  34;
constant   RCD_COUNT_VALUE                           : std_logic_vector(2 downto 0) := "001";
constant   RAS_COUNT_VALUE                           : std_logic_vector(3 downto 0) := "0011";
constant   MRD_COUNT_VALUE                           : std_logic_vector(2 downto 0) := "000";
constant   RP_COUNT_VALUE                             : std_logic_vector(2 downto 0) := "001";
constant   RFC_COUNT_VALUE                            : std_logic_vector(5 downto 0) := "000110";
constant   TWR_COUNT_VALUE                            : std_logic_vector(2 downto 0) := "110";
constant   TWTR_COUNT_VALUE                      : std_logic_vector(2 downto 0) := "100";
constant   MAX_REF_WIDTH                                   : INTEGER   :=  10;
constant   MAX_REF_CNT                     : std_logic_vector(9 downto 0) := "1011111000";

constant    PHY_MODE                 : std_logic := '1';
constant    TRTP_COUNT_VALUE         : std_logic_vector(2 downto 0) := "011";
constant    RC_COUNT_VALUE           : std_logic_vector(3 downto 0) := "1111";   -- active to active same bank = tRC-1
constant    READ_ENABLES             : integer := 1;

constant    CS_H0               : std_logic_vector(3 downto 0)  := "0000";
constant    CS_HE               : std_logic_vector(3 downto 0)  := "1110";
constant    CS_HD               : std_logic_vector(3 downto 0)  := "1101";
constant    CS_HB               : std_logic_vector(3 downto 0)  := "1011";
constant    CS_H7               : std_logic_vector(3 downto 0)  := "0111";
constant    CS_HF               : std_logic_vector(3 downto 0)  := "1111" ;
constant    ADD_CONST1          : std_logic_vector(15 downto 0) := X"0400" ;
constant    ADD_CONST2          : std_logic_vector(15 downto 0) := X"0100" ;
constant    ADD_CONST3          : std_logic_vector(15 downto 0) := X"0000" ;
constant    ADD_CONST4          : std_logic_vector(15 downto 0) := X"FBFF" ;
constant    ADD_CONST5          : std_logic_vector(15 downto 0) := X"FEFF" ;
constant    ADD_CONST6          : std_logic_vector(15 downto 0) := X"0001" ;
constant    ADD_CONST7          : std_logic_vector(15 downto 0) := X"0004" ;
constant    ADD_CONST8          : std_logic_vector(15 downto 0) := X"0008" ;
constant    ADD_CONST9          : std_logic_vector(15 downto 0) := X"0002" ;

end mig_parameters_0;
