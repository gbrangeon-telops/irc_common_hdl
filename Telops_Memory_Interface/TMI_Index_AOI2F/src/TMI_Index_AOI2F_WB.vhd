-------------------------------------------------------------------------------
--
-- Title       : TMI_Index_AOI2F_WB
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {TMI_Index_AOI2F_WB} architecture {TMI_Index_AOI2F_WB}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.telops.all;

entity TMI_Index_AOI2F_WB is
   generic(
      ILEN : natural := 17; 
      XLEN : natural := 9; 
      YLEN : natural := 8; 
      WIDTHMAX : natural := 320 
      );    
   port(
      --------------------------------
      -- Wishbone
      --------------------------------   
      WB_MOSI        : in  t_wb_mosi32;
      WB_MISO        : out t_wb_miso32;   
   
      OFFSET_X       : out std_logic_vector(XLEN-1 downto 0);
      OFFSET_Y       : out std_logic_vector(YLEN-1 downto 0);
      WIDTH_AOI      : out std_logic_vector(XLEN-1 downto 0);

      ERR_DATA       : in  std_logic;                       -- Warning: Clk domain = CLK_DATA
      ERROR          : out std_logic;                       -- Single bit, OR of every possible errors.
      
      ARESET         : in std_logic;
      CLK            : in std_logic       
      );
end TMI_Index_AOI2F_WB;

--}} End of automatically maintained section

architecture RTL of TMI_Index_AOI2F_WB is
begin
   
   -- enter your statements here --
   
end RTL;
