-------------------------------------------------------------------------------
--
-- Title       : TMI_arbiter_2
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

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity TMI_arbiter_2 is  
   generic(            
      DLEN : natural := 32;
      ALEN : natural := 21);     
   port(
      
      TMI1_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI1_RNW       : in  std_logic;
      TMI1_DVAL      : in  std_logic;
      TMI1_BUSY      : out std_logic;
      TMI1_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI1_RD_DVAL   : out std_logic; 
      TMI1_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI1_IDLE      : out std_logic;
      TMI1_ERROR     : out std_logic;
                  
      TMI2_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI2_RNW       : in  std_logic;      
      TMI2_DVAL      : in  std_logic;
      TMI2_BUSY      : out std_logic;
      TMI2_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI2_RD_DVAL   : out std_logic;                           
      TMI2_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI2_IDLE      : out std_logic;
      TMI2_ERROR     : out std_logic;      
      
      TMI_ADD        : out std_logic_vector(ALEN-1 downto 0);
      TMI_RNW        : out std_logic;
      TMI_DVAL       : out std_logic;
      TMI_BUSY       : in  std_logic;
      TMI_RD_DATA    : in  std_logic_vector(DLEN-1 downto 0);
      TMI_RD_DVAL    : in  std_logic;
      TMI_WR_DATA    : out std_logic_vector(DLEN-1 downto 0);
      TMI_IDLE       : in  std_logic;
      TMI_ERROR      : in  std_logic;    
      
      ARESET         : in std_logic;
      CLK            : in std_logic        
      );
end TMI_arbiter_2;


architecture RTL of TMI_arbiter_2 is
begin
   
   -- enter your statements here --
   
end RTL;
