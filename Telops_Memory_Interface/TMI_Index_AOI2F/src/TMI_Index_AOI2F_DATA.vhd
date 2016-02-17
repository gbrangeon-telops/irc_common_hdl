-------------------------------------------------------------------------------
--
-- Title       : TMI_Index_AOI2F_DATA
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
library Common_HDL;
use Common_HDL.telops.all;

entity TMI_Index_AOI2F_DATA is
   generic(
      ILEN : natural := 17;
      DLEN : natural := 32);    
   port(
      --------------------------------
      -- Index converter
      --------------------------------   
      INDEX_AOI         : out std_logic_vector(ILEN-1 downto 0); 
      AOI_DVAL          : out std_logic;
      INDEX_F           : in  std_logic_vector(ILEN-1 downto 0);         
      F_DVAL            : in  std_logic;
      CE                : out std_logic;
      --------------------------------
      -- AOI Index TMI Interface
      --------------------------------        
      TMI_AOI_ADD       : in  std_logic_vector(ILEN-1 downto 0);
      TMI_AOI_RNW       : in  std_logic;
      TMI_AOI_DVAL      : in  std_logic;
      TMI_AOI_BUSY      : out std_logic;
      TMI_AOI_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI_AOI_RD_DVAL   : out std_logic;       
      TMI_AOI_IDLE      : out std_logic;
      TMI_AOI_ERROR     : out std_logic;                                    
      --------------------------------
      -- Full Index TMI Interface
      --------------------------------        
      TMI_F_ADD         : out std_logic_vector(ILEN-1 downto 0);
      TMI_F_RNW         : out std_logic;
      TMI_F_DVAL        : out std_logic;
      TMI_F_BUSY        : in  std_logic;
      TMI_F_RD_DATA     : in  std_logic_vector(DLEN-1 downto 0);
      TMI_F_RD_DVAL     : in  std_logic;
      TMI_F_WR_DATA     : out std_logic_vector(DLEN-1 downto 0);
      TMI_F_IDLE        : in  std_logic;
      TMI_F_ERROR       : in  std_logic;          
      --------------------------------
      -- Misc
      --------------------------------       
      ERROR             : out std_logic;                       -- Single bit, OR of every possible errors.      
      ARESET            : in std_logic;
      CLK               : in std_logic       
      );
end TMI_Index_AOI2F_DATA;


architecture RTL of TMI_Index_AOI2F_DATA is    
   
   attribute keep_hierarchy : string;
   attribute keep_hierarchy of RTL: architecture is "no";
   
begin
   
   -- Direct connections  
   ERROR           <= TMI_F_ERROR;
   TMI_AOI_ERROR   <= TMI_F_ERROR;
   INDEX_AOI       <= TMI_AOI_ADD;       
   TMI_F_ADD       <= INDEX_F;  
   TMI_AOI_RD_DATA <= TMI_F_RD_DATA;
   TMI_AOI_RD_DVAL <= TMI_F_RD_DVAL and not ARESET;  
   TMI_AOI_BUSY    <= TMI_F_BUSY or ARESET;
   
   -- The handling of DVAL and BUSY is as simple as it gets.
   CE <= not TMI_F_BUSY;
   AOI_DVAL <= TMI_AOI_DVAL and not ARESET;
   TMI_F_DVAL <= F_DVAL and not ARESET;
   
   -- Constant signals
   TMI_F_WR_DATA <= (others => '0'); 
   TMI_F_RNW <= '1';   
   
   -- Sanity checks
   assert (TMI_AOI_RNW = '1') report "Only read operations are supported" severity FAILURE;     
   
   -- The only process necessary is to generate TMI_AOI_IDLE
   -- based on the latency of the index converter
   main : process(CLK)
      constant Converter_Latency : natural := 10;
      variable idle_cnt : natural range 0 to Converter_Latency;   
      
   begin         
      if ARESET = '1' then
         idle_cnt := 0;
         TMI_AOI_IDLE <= '0';
      elsif rising_edge(CLK) then
         if TMI_F_IDLE = '0' or TMI_AOI_DVAL = '1' then
            idle_cnt := 0;
            TMI_AOI_IDLE <= '0';
         elsif idle_cnt < Converter_Latency then     
            idle_cnt := idle_cnt + 1;
            TMI_AOI_IDLE <= '0';
         else                   
            TMI_AOI_IDLE <= '1';
         end if;
      end if;
   end process;
   
end RTL;
