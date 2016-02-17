---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: DAC8581_iface.vhd
--  Use: interface to a TI DAC8581 SPI 3MHz DAC
--  Author: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  Notes: core divides incoming clock by 2 to generate SPI clock, optimized for a 100Mhz Clock
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity DAC8581_iface is
    port(
        CLK : in std_logic;
        DIN : in std_logic_vector(15 downto 0);
        STB : in std_logic;
        ACK : out std_logic;
        CLRn : out std_logic;
        CSn : out std_logic;
        SDA : out std_logic;
        SCL : out std_logic);
end DAC8581_iface;

architecture rtl of DAC8581_iface is
    
    type DAC_state_t is (IDLE, ENABLE, SHIFT, TOGGLE_CLOCK, WAITSTATE);
    signal DAC_state : DAC_state_t := IDLE;
    signal shift_reg : std_logic_vector(15 downto 0);
    signal init_srl : std_logic_vector(15 downto 0) := x"0000";
    
begin
    
    -- Reset the DAC for 16 clock ticks after FPGA config (ROC)
    reset_dac : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            init_srl(15 downto 1) <= init_srl(14 downto 0);
            init_srl(0) <= '1';
        end if;
    end process reset_dac;
    
    -- map the CLRn pin
    CLRn <= init_srl(15);
    
    -- Map  bit 15 of shift register to serial data out
    SDA <= shift_reg(15);
    
    -- describe the high speed SPI state machine (SCL at 1/2 system clock frequency)
    SPI_machine : process(CLK)
        variable bit_cnt : integer range 0 to 15;
    begin
        if (CLK'event and CLK = '1') then
            case DAC_state is
                
                when IDLE => -- pull CS low and load shift register when strobed
                    ACK <= '0';
                    if (STB = '1' and init_srl(15) = '1') then
                        shift_reg <= DIN;
                        CSn <= '0';
                        bit_cnt := 15;
                        DAC_state <= ENABLE;
                    else
                        CSn <= '1';
                        SCL <= '0';
                    end if;
                    
                when ENABLE => -- wait for tLEAD
                    DAC_state <= TOGGLE_CLOCK;
                    
                when SHIFT =>  -- pulse clock low and shift the register
                    SCL <= '0';
                    if bit_cnt = 0 then
                        CSn <= '1';
                        bit_cnt := 8;
                        DAC_state <= WAITSTATE;
                    else
                        shift_reg <= shift_reg(14 downto 0 ) & '0';
                        bit_cnt := bit_cnt - 1;
                        DAC_state <= TOGGLE_CLOCK;
                    end if;
                    
                when TOGGLE_CLOCK =>  -- pulse clock high
                    SCL <= '1';
                    DAC_state <= SHIFT;
                    
                when WAITSTATE => -- wait for tWait
                SCL <= '0';
                if bit_cnt = 0 then
                    ACK <= '1';
                    DAC_state <= IDLE;
                else
                    bit_cnt := bit_cnt - 1;
                end if;
                
            end case;
        end if;
    end process SPI_machine;
    
end rtl;
