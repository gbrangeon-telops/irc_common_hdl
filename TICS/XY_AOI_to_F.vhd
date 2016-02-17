-------------------------------------------------------------------------------
--
-- Title       : XY_AOI_to_F
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--  $Revision: 7566 $
--  $Author: rd\pdubois $
--  $LastChangedDate: 2010-03-19 15:56:23 -0400 (ven., 19 mars 2010) $
-------------------------------------------------------------------------------
--
-- Description : This module implements equations 6 of the document "Telops
--               Image Coordinate System".
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {XY_AOI_to_F} architecture {XY_AOI_to_F}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity XY_AOI_to_F is  
   generic( 
      -- Default sizes are for a 320x256 window
      XLEN : natural := 9;
      YLEN : natural := 8);    
   port(
      X_AOI       : in  std_logic_vector(XLEN-1 downto 0);
      Y_AOI       : in  std_logic_vector(YLEN-1 downto 0);   
      OFFSET_X    : in std_logic_vector(XLEN-1 downto 0);      
      OFFSET_Y    : in std_logic_vector(YLEN-1 downto 0);            
      DVAL_IN     : in STD_LOGIC;                      
      
      X_F         : out std_logic_vector(XLEN-1 downto 0);
      Y_F         : out std_logic_vector(YLEN-1 downto 0);  
      DVAL_OUT    : out STD_LOGIC;            
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC;      
      CE          : in STD_LOGIC
      );
end XY_AOI_to_F;

--}} End of automatically maintained section

architecture RTL of XY_AOI_to_F is
begin
   
   -- enter your statements here --
   
end RTL;
