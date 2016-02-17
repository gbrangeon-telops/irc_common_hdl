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

entity DAC8581_iface2 is
    port(
        CLK : in std_logic;
        DIN1 : in std_logic_vector(15 downto 0);
        DIN2 : in std_logic_vector(15 downto 0);
        STB1 : in std_logic;
        STB2 : in std_logic;
        ACK : out std_logic;
        CLRn1 : out std_logic;
        CLRn2 : out std_logic;
        CSn1 : out std_logic;
        CSn2 : out std_logic;
        SDA1 : out std_logic;
        SDA2 : out std_logic;
        SCL : out std_logic);
end DAC8581_iface2;

architecture rtl of DAC8581_iface2 is
    
    type DAC_state_t is (IDLE, ENABLE, SHIFT, TOGGLE_CLOCK, WAITSTATE);
    signal DAC_state : DAC_state_t := IDLE;
    signal shift_reg1 : std_logic_vector(15 downto 0);
    signal shift_reg2 : std_logic_vector(15 downto 0);
    signal init_srl : std_logic_vector(15 downto 0) := x"0000";
    signal stb_reg : std_logic_vector(1 downto 0) := "00";
    signal dac_sel : std_logic_vector(1 downto 0) := "00";
    
begin
    
    -- Reset the DAC for 16 clock ticks after FPGA config (ROC)
    reset_dac : process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            init_srl(15 downto 1) <= init_srl(14 downto 0);
            init_srl(0) <= '1';
            if init_srl(15) = '1' then
               if STB1 = '1' then
                  stb_reg(0) <= '1';
               end if;
               if STB2 = '1' then
                  stb_reg(1) <= '1';
               end if;
               if DAC_state = IDLE then
                  stb_reg <= "00";
               end if;
            end if;
        end if;
    end process reset_dac;
    
    -- map the CLRn pin
    CLRn1 <= init_srl(15);
    CLRn2 <= init_srl(15);
    
    -- Map  bit 15 of shift register to serial data out
    SDA1 <= shift_reg1(15);
    SDA2 <= shift_reg2(15);
    
    -- describe the high speed SPI state machine (SCL at 1/2 system clock frequency)
    SPI_machine : process(CLK)
        variable bit_cnt : integer range 0 to 15;
    begin
        if (CLK'event and CLK = '1') then
            case DAC_state is
                
                when IDLE => -- pull CS low and load shift register when strobed
                   ACK <= '0';
                   SCL <= '0';
                   if (init_srl(15) = '1') and (STB1 = '1' or stb_reg(0) = '1') then
                      shift_reg1 <= DIN1;
                      CSn1 <= '0';
                      dac_sel(0) <= '1';
                   else
                      CSn1 <= '1';
                      dac_sel(0) <= '0';
                   end if;
                   if (init_srl(15) = '1') and (STB2 = '1' or stb_reg(1) = '1') then
                      shift_reg2 <= DIN2;
                      CSn2 <= '0';
                      dac_sel(1) <= '1';
                   else
                      CSn1 <= '1';
                      dac_sel(1) <= '0';
                   end if;
                   if (init_srl(15) = '1') and (STB1 = '1' or stb_reg(0) = '1' or STB2 = '1' or stb_reg(1) = '1') then
                      bit_cnt := 15;
                      DAC_state <= ENABLE;
                   end if;
                    
                when ENABLE => -- wait for tLEAD
                   ACK <= '0';
                   SCL <= '0';
                   DAC_state <= TOGGLE_CLOCK;
                    
                when SHIFT =>  -- pulse clock low and shift the register
                   ACK <= '0';
                   SCL <= '0';
                   if bit_cnt = 0 then
                      CSn1 <= '1';
                      CSn2 <= '1';
                      bit_cnt := 8;
                      DAC_state <= WAITSTATE;
                   else
                      shift_reg1 <= shift_reg1(14 downto 0 ) & '0';
                      shift_reg2 <= shift_reg2(14 downto 0 ) & '0';
                      bit_cnt := bit_cnt - 1;
                      DAC_state <= TOGGLE_CLOCK;
                   end if;
                    
                when TOGGLE_CLOCK =>  -- pulse clock high
                   ACK <= '0';
                   SCL <= '1';
                   DAC_state <= SHIFT;
                    
                when WAITSTATE => -- wait for tWait
                   SCL <= '0';
                   if bit_cnt = 0 then
                      ACK <= '1';
                      DAC_state <= IDLE;
                   else
                      ACK <= '0';
                      bit_cnt := bit_cnt - 1;
                   end if;
                
            end case;
        end if;
    end process SPI_machine;
    
end rtl;
