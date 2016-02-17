-------------------------------------------------------------------------------
--
-- Title       : XYAOI_to_IndexF
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--  $Revision$
--  $Author$
--  $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description : This module implements equations 6 of the document "Telops
--               Image Coordinate System".
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {XYAOI_to_IndexF} architecture {XYAOI_to_IndexF}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity XYAOI_to_IndexF is  
   generic( 
      -- Default sizes are for a 320x256 window
      ILEN : natural := 17;
      XLEN : natural := 9;
      YLEN : natural := 8;
      WIDTHMAX : natural := 320);    
   port(
      X_AOI       : in  std_logic_vector(XLEN-1 downto 0);
      Y_AOI       : in  std_logic_vector(YLEN-1 downto 0);   
      OFFSET_X    : in std_logic_vector(XLEN-1 downto 0);      
      OFFSET_Y    : in std_logic_vector(YLEN-1 downto 0);            
      DVAL_IN     : in STD_LOGIC;                      
      
      INDEX_F     : out std_logic_vector(ILEN-1 downto 0);
      DVAL_OUT    : out STD_LOGIC;            
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC;      
      CE          : in STD_LOGIC
      );
end XYAOI_to_IndexF;

--}} End of automatically maintained section

architecture RTL of XYAOI_to_IndexF is
begin
   
   -- enter your statements here --
   
end RTL;
