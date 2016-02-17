---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: bus_split.vhd
--  Revision history:  (use SVN for exact code history)
--   KBE: original implementation
-- Descreption: Takes a portion of data bus and places it on the LSB side of
--              output data bus and fills the rest with zeros or duplicat sign bit
-- Generics : BUS_WIDTH : width of input and output data bus.
--            DLEN is the width of output data bus that will carry the slised input
--            OFFSET_FROM_LSB is the offset from the LSB of the input bus.
-- Example :  BUS_WIDTH = 32, BUS_WIDTH = 8, OFFSET_FROM_LSB = 16, & SIGNED_DATA = False gives:
--             TX_BUS(7 downto 0) <= RX_BUS(23 downto 16);
--             TX_BUS(31 downto 8) <= (others=>'0');
--             if SIGNED_DATA = true, this gives:
--             TX_BUS(7 downto 0) <= RX_BUS(23 downto 16);
--             TX_BUS(31 downto 8) <= (others=>RX_BUS(23));
-- Simulation : The Active-HDL project is located at:
--             "\Common_HDL\Matlab\testbenches\LL_input_Files"
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.DPB_Define.all;

entity bus_split is
   generic(
       BUS_WIDTH        : integer:=32;
       DLEN             : integer:=8;
       OFFSET_FROM_LSB  : integer:=0;
       SIGNED_DATA      : boolean := false
      );
   port(
       RX_BUS    : in  std_logic_vector(BUS_WIDTH-1 downto 0);
       TX_BUS    : out  std_logic_vector(BUS_WIDTH-1 downto 0)
       );
end bus_split;

architecture rtl of bus_split is 

attribute keep_hierarchy : string;
attribute keep_hierarchy of rtl: architecture is "false";

begin

   ------------------------------------------------------
   -- Split data bus depending on the generic data width
   ------------------------------------------------------
   TX_BUS(DLEN-1 downto 0) <= RX_BUS((DLEN-1+OFFSET_FROM_LSB)  downto OFFSET_FROM_LSB);

   Not_Signed: if SIGNED_DATA = FALSE generate
      TX_BUS(BUS_WIDTH-1 downto DLEN) <= (others=>'0');
   end generate;

   -- Signed data support: propagate sign bit
   Its_Signed: if SIGNED_DATA = TRUE generate
      TX_BUS(BUS_WIDTH-1 downto DLEN) <= (others=> RX_BUS(DLEN-1+OFFSET_FROM_LSB));
   end generate;

end rtl;
