---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006-2007
--
--  File: deserializer.vhd
--  Use: Data Deserializer with embeded framing control and seperate clock line
--  Author: Olivier Bourgois
--  Notes: Improved version of sync_des which can be used without a DCM
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Status: New version needs hardware validation
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity deserializer is
   generic(
      width : integer;
      lines : integer);
   port(
      SCLK : in std_logic;                             -- serial input clock
      SDAT : in std_logic_vector(lines-1 downto 0);    -- serial input data
      CLK  : in std_logic;                             -- system clock
      DVAL : out std_logic;                            -- parallel data valid
      DOUT : out std_logic_vector(width-1 downto 0));  -- parallel data out
end deserializer;

architecture rtl of deserializer is
   
   constant sync_word : std_logic_vector(lines-1 downto 0) := (others => '0'); -- frame start word
   constant total_width : integer := width+sync_word'length;
   constant max_rx_cnts : integer := (total_width+lines-1)/lines; -- integer division rounding trick to calculate number of transmissions required
   constant dreg_width : integer := max_rx_cnts*lines;
   
   -- signals on SCK domain
   signal dreg : std_logic_vector(dreg_width-1 downto 0);
   signal frm_symbol : std_logic_vector(sync_word'range);
   signal data_sclk : std_logic_vector(width-1 downto 0);
   signal dval_sclk : std_logic;
   
   -- signals for resyncing dval accross clock domains
   signal dval_hold : std_logic := '0'; 
   signal dval_hold_1p : std_logic := '0';
   signal dval_hold_2p : std_logic := '0';
   signal dval_hold_3p : std_logic := '0';
   --signal data_vld : std_logic_vector(width-1 downto 0);
   
begin
   
   -- zoom in on the right bits of data reg to detect incomming synchronization symbol
   frm_symbol <= dreg(frm_symbol'length-1 downto 0);
   
   -- deserializing state machine
   deserializer_sm : process(SCLK)
   begin
      if (SCLK'event and SCLK = '0') then   -- we use falling clock to be 180 degrees dephased with data (middle of eye)
         if (frm_symbol = sync_word) then  -- detect SOF at right end of dreg
            dval_sclk <= '1';
            data_sclk <= dreg(DOUT'length+sync_word'length-1 downto sync_word'length); -- register valid output data
            dreg(dreg'length-1 downto dreg'length-SDAT'length) <= SDAT;   -- shift in next symbol
            dreg(dreg'length-SDAT'length-1 downto 0) <= (others => '1');  -- clear remainder of reg
         else
            dval_sclk <= '0';
            dreg <= SDAT & dreg(dreg'length-1 downto SDAT'length); -- shift dreg right by the correct amount
         end if;
      end if;
   end process deserializer_sm;
   
   -- resync to system clock using same method as sync_pulse block
   resync : process(dval_sclk, CLK)
   begin
      -- DVAL resync
      if (dval_sclk'event and dval_sclk = '1') then
         dval_hold <= not dval_hold_2p;
      end if;
      if (CLK'event and CLK = '1') then
         dval_hold_1p <= dval_hold;
         dval_hold_2p <= dval_hold_1p;
         dval_hold_3p <= dval_hold_2p;	
         DVAL <= dval_hold_2p xor  dval_hold_3p;
      end if;
      -- DOUT resync
      if (CLK'event and CLK = '1') then
         DOUT <= data_sclk;      -- DOUT will be ok by the time DVAL goes hi because it is stable for many clocks
      end if;
   end process resync;
   
end rtl;
