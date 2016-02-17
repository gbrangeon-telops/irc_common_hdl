---------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_write
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description :  
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;   
library Common_HDL;

entity LL_TMI_write is
   generic(   
      DLEN : natural := 32;
      XLEN : natural := 9;
      ALEN : natural := 21);  
   port(  
      --------------------------------
      -- TMI Interface
      --------------------------------
      TMI_IDLE    : in  std_logic;
      TMI_ERROR   : in  std_logic;
      TMI_RNW     : out std_logic;
      TMI_ADD     : out std_logic_vector(ALEN-1 downto 0);
      TMI_DVAL    : out std_logic;
      TMI_BUSY    : in  std_logic;
      TMI_WR_DATA : out std_logic_vector(DLEN-1 downto 0);   
      --------------------------------
      -- Incoming Addresses
      --------------------------------   
      ADD_LL_SOF	 : in  std_logic;
      ADD_LL_EOF	 : in  std_logic;
      ADD_LL_DATA  : in  std_logic_vector(ALEN-1 downto 0);      
      ADD_LL_DVAL	 : in  std_logic;
      ADD_LL_SUPPORT_BUSY : in std_logic;
      ADD_LL_BUSY  : out std_logic;      
      ADD_LL_AFULL : out std_logic;          
      --------------------------------
      -- Incoming data for write requests
      --------------------------------   
      WR_LL_SOF	: in  std_logic;
      WR_LL_EOF	: in  std_logic;
      WR_LL_DATA  : in  std_logic_vector(DLEN-1 downto 0);      
      WR_LL_DVAL	: in  std_logic;
      WR_LL_SUPPORT_BUSY : in std_logic;
      WR_LL_BUSY  : out std_logic;      
      WR_LL_AFULL : out std_logic;    
      --------------------------------
      -- Others IOs
      --------------------------------   
      IDLE        : out std_logic;                 -- 1 when TMI_IDLE is 1 and all internal pipelines are empty.
      ERROR       : out std_logic;
      ARESET      : in  std_logic;
      
      CLK_DATA    : in  std_logic;                 -- Clk domain for TMI and LocalLink ports
      CLK_CTRL    : in  std_logic                  -- Clk domain for CFG port
      );
end LL_TMI_write;

architecture RTL of LL_TMI_write is    
   
   signal sync_busy : std_logic;
   signal sync_dval : std_logic;
   signal dval : std_logic; 
   
	component ll_sync_flow
	port(
		RX0_DVAL : in STD_LOGIC;
		RX0_BUSY : out STD_LOGIC;
		RX0_AFULL : out STD_LOGIC;
		RX1_DVAL : in STD_LOGIC;
		RX1_BUSY : out STD_LOGIC;
		RX1_AFULL : out STD_LOGIC;
		SYNC_BUSY : in STD_LOGIC;
		SYNC_DVAL : out STD_LOGIC);
	end component;
   
begin               
   
   SYNC : ll_sync_flow
   port map(
      RX0_DVAL => ADD_LL_DVAL,
      RX0_BUSY => ADD_LL_BUSY,
      RX0_AFULL => ADD_LL_AFULL,
      RX1_DVAL => WR_LL_DVAL,
      RX1_BUSY => WR_LL_BUSY,
      RX1_AFULL => WR_LL_AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => sync_dval
      );   
   
   sync_busy <= TMI_BUSY;  
   ERROR <= TMI_ERROR;  
   IDLE <= TMI_IDLE;
   
   -- Utilisez le signal dval pour générer les transactions TMI 
   dval <= sync_dval and not sync_busy;  
   
   -- Version simpliste. Pipelining peut-être nécessaire pour opération à 160 MHz.  
   -- Si pipelining nécessaire, commencer par simplement utiliser LL_BusyBreak sur chaque
   -- port LocalLink en entrée.
   TMI_ADD <= ADD_LL_DATA;  
   TMI_WR_DATA <= WR_LL_DATA;
   TMI_DVAL <= dval;  
   TMI_RNW <= '0'; -- Always write.
   
end RTL;
