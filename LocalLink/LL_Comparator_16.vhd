---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2010
--
--  File: LL_Comparator_16.vhd
--  Use:  
--  By: Edem Nofodjie
--
--  $Revision:
--  $Author:
--  $LastChangedDate:
--
---------------------------------------------------------------------------------------------------
-- description:  compare deux flow en entrée et sort une erreur si difference remarquée
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
library Common_HDL;
use Common_HDL.telops.all;


entity LL_Comparator_16 is    
   port(
      CLK         : in std_logic;
      ARESET      : in std_logic;
      -----------------------------------------------------------
      -- flow1  LL entrant 
      -----------------------------------------------------------  
      RX0_MOSI     : in  t_ll_mosi;
      RX0_MISO     : out t_ll_miso;
      
      -----------------------------------------------------------
      -- flow2  LL entrant    
      -----------------------------------------------------------                         
      RX1_MOSI     : in  t_ll_mosi; 
      RX1_MISO     : out t_ll_miso;            
      
      -----------------------------------------------------------
      -- Statuts
      -----------------------------------------------------------      
      ERR         : out std_logic  -- pulse lorsqu'erreur (sort un coup de clock plus tard)   
      );
end LL_Comparator_16;


architecture RTL of LL_Comparator_16 is 
   
   component sync_reset
      port(
         ARESET                 : in std_logic;
         SRESET                 : out std_logic;
         CLK                    : in std_logic);
   end component;
   
   
   -- pour ls synchrtonisation des flows LL _entrants
   component ll_sync_flow
      port(
         RX0_DVAL   : in std_logic;
         RX0_BUSY   : out std_logic;
         RX0_AFULL  : out std_logic;
         RX1_DVAL   : in std_logic;
         RX1_BUSY   : out std_logic;
         RX1_AFULL  : out std_logic;
         SYNC_BUSY  : in std_logic;
         SYNC_DVAL  : out std_logic);
   end component;    
   
   -- signal reset resynchronisé sur CLK.
   signal sreset       : std_logic;
   
   -- synchronisation des flows entrants
   signal sync_busy    : std_logic;
   signal sync_afull   : std_logic;
   signal sync_dval    : std_logic;
   
   -- données en entrée
   signal data0        : std_logic_vector(RX0_MOSI.DATA'LENGTH + 1 downto 0);
   signal data1        : std_logic_vector(RX0_MOSI.DATA'LENGTH + 1 downto 0);  
   
begin  
   
   --------------------------------------------------
   -- mapping des entrées
   -------------------------------------------------- 
   data0 <= RX0_MOSI.SOF & RX0_MOSI.DATA & RX0_MOSI.EOF;
   data1 <= RX1_MOSI.SOF & RX1_MOSI.DATA & RX1_MOSI.EOF;
   
   
   --------------------------------------------------
   -- synchronisation des flows
   --------------------------------------------------
   SYNC : ll_sync_flow
   port map(
      RX0_DVAL  => RX0_MOSI.DVAL,
      RX0_BUSY  => RX0_MISO.BUSY,
      RX0_AFULL => RX0_MISO.AFULL,
      RX1_DVAL  => RX1_MOSI.DVAL,
      RX1_BUSY  => RX1_MISO.BUSY,
      RX1_AFULL => RX1_MISO.AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => sync_dval
      );    
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   sreset_map : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   --------------------------------------------------
   -- Comparateur
   --------------------------------------------------
   comp_proc : process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then
            sync_busy <= '0';
            ERR <= '0'; 
         else 
            
            if sync_dval = '1' then     -- si donnée valide aux deux entrée
               if data0 /= data1 then
                  ERR <= '1';
               else
                  ERR <= '0';
               end if;          
            end if;
            
         end if; 
      end if;
   end process;  
   
end RTL;

