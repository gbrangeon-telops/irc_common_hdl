-------------------------------------------------------------------------------
--
-- Title       : TMI_SW_2_1
-- Author      : Patrick Dubois, Simon Savary
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

library ieee;
use ieee.std_logic_1164.all;
library Common_HDL;     
use Common_HDL.all;
use Common_HDL.telops.all;  

entity TMI_SW_2_1_a21_d32 is     
   port(
      --------------------------------
      -- TMI in #1
      --------------------------------
      TMI1_MOSI    : in t_tmi_mosi_a21_d32;         
      TMI1_MISO    : out  t_tmi_miso_d32;
      --------------------------------
      -- TMI in #2
      -------------------------------- 
      TMI2_MOSI    : in t_tmi_mosi_a21_d32;  
      TMI2_MISO    : out  t_tmi_miso_d32;
      --------------------------------
      -- TMI out
      --------------------------------       
      TMI_MOSI    : out t_tmi_mosi_a21_d32;  
      TMI_MISO    : in  t_tmi_miso_d32;
      --------------------------------
      -- Others
      --------------------------------       
      SEL            : in  std_logic_vector(1 downto 0);      
      ARESET         : in  std_logic;
      CLK            : in  std_logic        
      );
end TMI_SW_2_1_a21_d32;


architecture RTL_a21_d32 of TMI_SW_2_1_a21_d32 is
	   
component TMI_SW_2_1  
   generic(            
      DLEN : natural := 32;
      ALEN : natural := 21);     
   port(
      --------------------------------
      -- TMI in #1
      --------------------------------       
      TMI1_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI1_RNW       : in  std_logic;
      TMI1_DVAL      : in  std_logic;
      TMI1_BUSY      : out std_logic;
      TMI1_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI1_RD_DVAL   : out std_logic; 
      TMI1_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI1_IDLE      : out std_logic;
      TMI1_ERROR     : out std_logic;
      --------------------------------
      -- TMI in #2
      -------------------------------- 
      TMI2_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI2_RNW       : in  std_logic;      
      TMI2_DVAL      : in  std_logic;
      TMI2_BUSY      : out std_logic;
      TMI2_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI2_RD_DVAL   : out std_logic;                           
      TMI2_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);   
      TMI2_IDLE      : out std_logic;
      TMI2_ERROR     : out std_logic;      
      --------------------------------
      -- TMI out
      --------------------------------       
      TMI_ADD        : out std_logic_vector(ALEN-1 downto 0);
      TMI_RNW        : out std_logic;
      TMI_DVAL       : out std_logic;
      TMI_BUSY       : in  std_logic;
      TMI_RD_DATA    : in  std_logic_vector(DLEN-1 downto 0);
      TMI_RD_DVAL    : in  std_logic;
      TMI_WR_DATA    : out std_logic_vector(DLEN-1 downto 0);
      TMI_IDLE       : in  std_logic;
      TMI_ERROR      : in  std_logic;   
      --------------------------------
      -- Others
      --------------------------------       
      SEL            : in  std_logic_vector(1 downto 0);      
      ARESET         : in  std_logic;
      CLK            : in  std_logic        
      );
end component;

begin   

U0_TMI_SW_2_1 : TMI_SW_2_1
   generic map(            
      DLEN => 32,
      ALEN => 21
      )     
   port map(
      --------------------------------
      -- TMI in #1
      --------------------------------       
      TMI1_ADD       => TMI1_MOSI.ADD,
      TMI1_RNW       => TMI1_MOSI.RNW,
      TMI1_DVAL      => TMI1_MOSI.DVAL,
      TMI1_BUSY      => TMI1_MISO.BUSY,
      TMI1_RD_DATA   => TMI1_MISO.RD_DATA,
      TMI1_RD_DVAL   => TMI1_MISO.RD_DVAL,
      TMI1_WR_DATA   => TMI1_MOSI.WR_DATA,  
      TMI1_IDLE      => TMI1_MISO.IDLE,
      TMI1_ERROR     => TMI1_MISO.ERROR,
      --------------------------------
      -- TMI in #2
      -------------------------------- 
      TMI2_ADD       => TMI2_MOSI.ADD,    
      TMI2_RNW       => TMI2_MOSI.RNW,    
      TMI2_DVAL      => TMI2_MOSI.DVAL,   
      TMI2_BUSY      => TMI2_MISO.BUSY,   
      TMI2_RD_DATA   => TMI2_MISO.RD_DATA,
      TMI2_RD_DVAL   => TMI2_MISO.RD_DVAL,  
      TMI2_WR_DATA   => TMI2_MOSI.WR_DATA,  
      TMI2_IDLE      => TMI2_MISO.IDLE,   
      TMI2_ERROR     => TMI2_MISO.ERROR,  
      --------------------------------
      -- TMI out
      --------------------------------       
      TMI_ADD        => TMI_MOSI.ADD,    
      TMI_RNW        => TMI_MOSI.RNW,    
      TMI_DVAL       => TMI_MOSI.DVAL,   
      TMI_BUSY       => TMI_MISO.BUSY,   
      TMI_RD_DATA    => TMI_MISO.RD_DATA,
      TMI_RD_DVAL    => TMI_MISO.RD_DVAL,
      TMI_WR_DATA    => TMI_MOSI.WR_DATA,
      TMI_IDLE       => TMI_MISO.IDLE,   
      TMI_ERROR      => TMI_MISO.ERROR,  
      --------------------------------
      -- Others
      --------------------------------       
      SEL            => SEL,     
      ARESET         => ARESET,
      CLK            => CLK
      );

end RTL_a21_d32;