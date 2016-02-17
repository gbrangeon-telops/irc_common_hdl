---------------------------------------------------------------------------------------------------
--
-- Title       : err_sync
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
--------------------------------------------------------------------------------------------
--
-- Description :  Use this component to sync an error signal from one clock domain to another.
--                It will stretch a pulse in a fast clock domain to make sure that it's captured
--                in the slow clock domain.  
--                STRETCH_CYCLES should be >2 if D_CLK is faster than Q_CLK
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity err_sync is
   generic(         
      STRETCH_CYCLES : natural := 2); -- How many clock cycles to strech the source pulse.
   port(
      D        : in  std_logic;
      Q        : out std_logic;
      ARESET   : in  std_logic;
      D_CLK    : in  std_logic;
      Q_CLK    : in  std_logic
      );
end err_sync;

architecture RTL of err_sync is
   signal D_streched : std_logic;  
   
   attribute TIG: string;
   attribute TIG of D: signal is "yes";   
   
   component gh_stretch
      generic(
         stretch_count : INTEGER := 1023);
      port(
         CLK : in STD_LOGIC;
         rst : in STD_LOGIC;
         D : in STD_LOGIC;
         Q : out STD_LOGIC);
   end component;                
   
   component gh_edge_det_xcd
      port(
         iclk : in STD_LOGIC;
         oclk : in STD_LOGIC;
         rst : in STD_LOGIC;
         D : in STD_LOGIC;
         re : out STD_LOGIC;
         fe : out STD_LOGIC);
   end component;   
   
begin         
   
   U1 : gh_stretch
   generic map(
      stretch_count => STRETCH_CYCLES+1
      )
   port map(
      CLK => D_CLK,
      rst => ARESET,
      D => D,
      Q => D_streched
      );   
   
   U2 : gh_edge_det_xcd
   port map(
      iclk => D_CLK,
      oclk => Q_CLK,
      rst => ARESET,
      D => D_streched,
      re => Q,
      fe => open
      );
   
end RTL;
