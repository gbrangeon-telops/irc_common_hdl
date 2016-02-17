---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: LL_bus_split.vhd
--  Use: LocalLink Bus Width Compatibility Block
--  Revision history:  (use SVN for exact code history)
--   KBE: original implementation
-- Descreption: Takes a portion of data bus and places it on the LSB side of
--              output data bus and fills the rest with zeros
-- Generics : OUTPUT_WIDTH is the width of output data bus that will carry the slised input
--            OFFSET_FROM_LSB is the offset from the LSB of the input bus.
-- Example : OUTPUT_WIDTH = 8, OFFSET_FROM_LSB = 16, & SIGNED_DATA = False gives:
--             TX_MOSI.DATA(7 downto 0) <= RX_MOSI.DATA(23 downto 16);
--             TX_MOSI.DATA(31 downto 8) <= (others=>'0');
--             if SIGNED_DATA = true, this gives:
--             TX_MOSI.DATA(7 downto 0) <= RX_MOSI.DATA(23 downto 16);
--             TX_MOSI.DATA(31 downto 8) <= (others=>RX_MOSI.DATA(23));
-- Simulation : Vous aller trouver le projet Active-HDL dans :
--             "\Common_HDL\Matlab\testbenches\LL_input_Files"
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.DPB_Define.all;

entity LL_bus_split is
   generic(
       OUTPUT_WIDTH    : integer:=8;
       OFFSET_FROM_LSB : integer:=8;
       SIGNED_DATA     : boolean := false
      );
   port(
       RX_MOSI    : in  T_LL_MOSI32;
       TX_MISO    : in  T_LL_MISO;
       RX_MISO    : out T_LL_MISO;
       TX_MOSI    : out T_LL_MOSI32
       );
end LL_bus_split;

architecture rtl of LL_bus_split is

attribute keep_hierarchy : string;
attribute keep_hierarchy of rtl: architecture is "false";


begin

   -- All signals maps one to one (except data bus signal)
   TX_MOSI.SOF  <= RX_MOSI.SOF;
   TX_MOSI.EOF  <= RX_MOSI.EOF;
   TX_MOSI.DVAL <= RX_MOSI.DVAL;
   TX_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   --
   RX_MISO.BUSY   <= TX_MISO.BUSY;
   RX_MISO.AFULL  <= TX_MISO.AFULL;

   ------------------------------------------------------
   -- Split data bus depending on the generic data width
   ------------------------------------------------------
   TX_MOSI.DATA(OUTPUT_WIDTH-1 downto 0) <= RX_MOSI.DATA((OUTPUT_WIDTH-1+OFFSET_FROM_LSB)  downto OFFSET_FROM_LSB);

   Not_Signed: if SIGNED_DATA = FALSE generate
      TX_MOSI.DATA(31 downto OUTPUT_WIDTH) <= (others=>'0');
   end generate;

   -- Signed data support: propagate sign bit
   Its_Signed: if SIGNED_DATA = TRUE generate
      TX_MOSI.DATA(31 downto OUTPUT_WIDTH) <= (others=> RX_MOSI.DATA(OUTPUT_WIDTH-1+OFFSET_FROM_LSB));
   end generate;

end rtl;
