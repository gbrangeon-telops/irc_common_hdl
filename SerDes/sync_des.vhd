---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006-2007
--
--  File: sync_des.vhd
--  Use: Data Deserializer with embeded framing control and seperate clock line
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Status: Hardware proven for data rates up to 100Mbit/s on a Backplane with VME connectors
--  and using LVDS signaling
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;

entity sync_des is
    generic(
        width : integer;
        lines : integer);
    port(
        CLK : in std_logic;
        SDAT : in std_logic_vector(lines-1 downto 0);
        DVAL : out std_logic;
        DOUT : out std_logic_vector(width-1 downto 0));
end sync_des;

architecture rtl of sync_des is
    
    constant sync_word : std_logic_vector(lines-1 downto 0) := (others => '0'); -- frame start word
    constant total_width : integer := width+sync_word'length;
    constant max_rx_cnts : integer := (total_width+lines-1)/lines; -- integer division rounding trick to calculate number of transmissions required
    constant dreg_width : integer := max_rx_cnts*lines;
    
    signal dreg : std_logic_vector(dreg_width-1 downto 0);
    signal frm_symbol : std_logic_vector(sync_word'range);

begin
    
    -- zoom in on the right bits of data reg to detect incomming synchronization symbol
    frm_symbol <= dreg(frm_symbol'length-1 downto 0);
    
    -- deserializing state machine
    deserializer_sm : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (frm_symbol = sync_word) then  -- detect SOF at right end of dreg before
                DVAL <= '1';
                DOUT <= dreg(DOUT'length+sync_word'length-1 downto sync_word'length); -- register valid output data
                dreg(dreg'length-1 downto dreg'length-SDAT'length) <= SDAT;   -- shift in next symbol
                dreg(dreg'length-SDAT'length-1 downto 0) <= (others => '1');  -- clear remainder of reg
            else
                DVAL <= '0';
                dreg <= SDAT & dreg(dreg'length-1 downto SDAT'length); -- shift dreg right by the correct amount
            end if;
        end if;
    end process deserializer_sm;

end rtl;
