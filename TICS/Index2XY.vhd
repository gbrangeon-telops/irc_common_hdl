-------------------------------------------------------------------------------
--
-- Title       : Index2XY
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--  $Revision$
--  $Author$
--  $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description : This module implements equations 2 & 3 of the document "Telops
--               Image Coordinate System".
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Index2XY is  
   generic( 
      -- Default sizes are for a 320x256 window
      ILEN : natural := 17;
      XLEN : natural := 9;
      YLEN : natural := 8);    
   port(
      INDEX    : in std_logic_vector(ILEN-1 downto 0);
      WIDTH    : in std_logic_vector(XLEN-1 downto 0);
      DVAL_IN  : in STD_LOGIC;
      
      X        : out std_logic_vector(XLEN-1 downto 0);
      Y        : out std_logic_vector(YLEN-1 downto 0);
      DVAL_OUT : out STD_LOGIC;
      
      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC;      
      CE       : in STD_LOGIC
      );
end Index2XY;


architecture RTL of Index2XY is
begin
   
   -- enter your statements here --
   
end RTL;
