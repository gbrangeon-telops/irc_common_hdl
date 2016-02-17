---------------------------------------------------------------------------------------------------
--
-- Title       : data_cdc_sync
-- Design      : 
-- Author      : Simon Savary
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--
-- Description : fifo-based clock domain crossing synchronizer for traversing data buses between 
--               two clock domains
--
--               Assumption on clock frequencies : f_WR <= f_RD
-- 
---------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity data_cdc_sync is
   port(
      ARESET : in std_logic;
      D : in std_logic_vector;
      WR : in std_logic;
      Q : out std_logic_vector;
      DVAL: out std_logic;
      WCLK : in std_logic;
      RCLK : in std_logic;
      ERR : out std_logic
      );
end data_cdc_sync;


architecture RTL of data_cdc_sync is
   
   component double_sync
      generic(
         INIT_VALUE : BIT := '0'
         );
      port (
         CLK : in STD_LOGIC;
         D : in STD_LOGIC;
         RESET : in STD_LOGIC;
         Q : out STD_LOGIC := '0'
         );
   end component;
   
   component gh_fifo_async_sr is
      GENERIC (add_width: INTEGER :=4; -- min value is 2 (4 memory locations)
         data_width: INTEGER :=8 ); -- size of data bus
      port (					
         clk_WR : in STD_LOGIC; -- write clock
         clk_RD : in STD_LOGIC; -- read clock
         rst    : in STD_LOGIC; -- resets counters
         srst   : in STD_LOGIC:='0'; -- resets counters (sync with clk_WR)
         WR     : in STD_LOGIC; -- write control 
         RD     : in STD_LOGIC; -- read control
         D      : in STD_LOGIC_VECTOR (data_width-1 downto 0);
         Q      : out STD_LOGIC_VECTOR (data_width-1 downto 0);
         empty  : out STD_LOGIC; 
         full   : out STD_LOGIC);
   end component;
   
   signal full_i, empty_i : std_ulogic;
   signal srst : std_ulogic;
   
begin
   
   DVAL <= not empty_i; 
   ERR <= full_i;
   
   sync_rst : double_sync
   port map(
      CLK => WCLK,
      D => ARESET,
      RESET=> '0',
      Q => srst
      );
   
   fifo : gh_fifo_async_sr
   generic map(
      data_width => D'LENGTH,
      add_width => 2
      )
   port map(
      rst => ARESET,
      srst => srst,
      clk_WR => WCLK,
      WR => WR,
      D => D,
      clk_RD => RCLK,
      RD => '1',
      Q => Q,
      empty => empty_i,
      full => full_i
      );

end RTL;
