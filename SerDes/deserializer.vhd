---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006-2007
--
--  File: deserializer.vhd
--  Use: Data Deserializer with embeded framing control and seperate clock line
--  Author: Olivier Bourgois
--  Notes: Improved version of sync_des which can be used without a DCM and even in CPLDs
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
      SCLK : in std_logic;                             -- serial input clock (CD1)
      SDAT : in std_logic_vector(lines-1 downto 0);    -- serial input data
      CLK  : in std_logic;                             -- system clock (CD2)
      DVAL : out std_logic;                            -- parallel data valid
      DOUT : out std_logic_vector(width-1 downto 0));  -- parallel data out
end deserializer;

architecture rtl of deserializer is
   
   constant sync_word : std_logic_vector(lines-1 downto 0) := (others => '0'); -- frame start word
   constant total_width : integer := width+sync_word'length;
   constant max_rx_cnts : integer := (total_width+lines-1)/lines; -- integer division rounding trick to calculate number of transmissions required
   constant dreg_width : integer := max_rx_cnts*lines;
   
   signal dreg : std_logic_vector(dreg_width-1 downto 0) := (others => '0');
   signal frm_symbol : std_logic_vector(sync_word'range) := (others => '0');
   signal data : std_logic_vector(width-1 downto 0) := (others => '0');
   signal data_vld : std_logic_vector(width-1 downto 0) := (others => '0');
   
   signal dval_sync : std_logic := '0';
   
   component sync_pulse is
      port(
         Pulse : in STD_LOGIC;
         Clk : in STD_LOGIC;
         Pulse_out_sync : out STD_LOGIC
         );
   end component;
   
begin
   
   -- zoom in on the right bits of data reg to detect incomming synchronization symbol
   frm_symbol <= dreg(frm_symbol'length-1 downto 0);
   
   -- deserializing state machine
   deserializer_sm : process(SCLK)
   begin
      -- sample data on a falling edge
      if (SCLK'event and SCLK = '0') then
         if (frm_symbol = sync_word) then  -- detect SOF at right end of dreg
            data_vld <= (others => '1');
            data <= dreg(DOUT'length+sync_word'length-1 downto sync_word'length); -- register valid output data
            dreg(dreg'length-1 downto dreg'length-SDAT'length) <= SDAT;   -- shift in next symbol
            dreg(dreg'length-SDAT'length-1 downto 0) <= (others => '1');  -- clear remainder of reg
         else
            data_vld <= data_vld(data_vld'length-2 downto 0) & '0';
            dreg <= SDAT & dreg(dreg'length-1 downto SDAT'length); -- shift dreg right by the correct amount
         end if;
    
      end if;
   end process deserializer_sm;
   
   sync_dval: sync_pulse
   port map (
      Pulse => data_vld(data_vld'left),
      Clk => CLK,
      Pulse_out_sync => dval_sync
      );
         
   -- resync data to system clock
   resync : process(CLK)
   begin
      if rising_edge(CLK) then
         DVAL <= dval_sync;
         if dval_sync = '1' then
            DOUT <= data;                                -- DOUT will be ok by the time DVAL goes hi
         end if;
      end if;
   end process resync;
   
end rtl;
