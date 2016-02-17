---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: temp_reader_tb.vhd
--  Hierarchy: submodule testbench
--  Use: Testing I2C/SMBus serial interface temperature reading loop
--	 Project: POF2005 - Temperature sensing diodes SMBus peripheral access
--	 By: Olivier Bourgois
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
library work;
use work.sim_pack.clk_gen;

entity temp_reader_tb is
  generic(
    CLK_PERIOD : time := 10ns;				                    -- Generate 100 Mhz Clock
    DUTY_CYCLE : real := 0.5;				                    -- 50 % duty cycle
	RST_CYCLES : natural := 10;                                 -- drive reset 10 clocks
    I2C_ADR    : std_logic_vector(6 downto 0) := "0011000");    -- setting for slave address
end temp_reader_tb;

architecture TB_ARCHITECTURE of temp_reader_tb is
    
	component temp_reader
	generic(
		I2C_ADR : std_logic_vector(6 downto 0) := "0011000" );
	port(
		CLK : in std_logic;
		ARESET : in std_logic;
		FPGA_TEMP : out std_logic_vector(7 downto 0);
		EXT_TEMP : out std_logic_vector(7 downto 0);
		I2C_SCL_PIN : out std_logic;
		I2C_SDA_PIN : inout std_logic );
	end component;
   
   component i2c_slave is
   generic(
     SLV_ADR : std_logic_vector(6 downto 0));
   port(
     CLK : in std_logic;
     ARESET : in std_logic;
     ADR : out std_logic_vector(7 downto 0);
     WE : out std_logic;
     I2C_TX : in std_logic_vector(7 downto 0);
     I2C_RX : out std_logic_vector(7 downto 0);
     I2C_SCL_PIN : in std_logic;
     I2C_SDA_PIN : inout std_logic);
   end component;

	-- Signal Declarations
   signal CLK : std_logic;
   signal RST : std_logic;
   signal FPGA_TEMP : std_logic_vector(7 downto 0);
   signal EXT_TEMP : std_logic_vector(7 downto 0);
   signal I2C_SDA_PIN : std_logic;
   signal I2C_SCL_PIN : std_logic;
   signal REG_ADR : std_logic_vector(7 downto 0);
   signal REG_WE  : std_logic;
   signal REG_OUT : std_logic_vector(7 downto 0);
   signal REG_IN : std_logic_vector(7 downto 0);
   signal MAX1617_CONF : std_logic_vector(7 downto 0);
   signal MAX1617_RATE : std_logic_vector(7 downto 0);
   signal LOC_TRET   : std_logic_vector(7 downto 0);    -- local temperature
   signal REM_TRET   : std_logic_vector(7 downto 0);    -- remote temperature 
   
begin

	-- Unit Under Test port map
	UUT : temp_reader
		generic map (
			I2C_ADR => I2C_ADR
		)

		port map (
			CLK => CLK,
			ARESET => RST,
			FPGA_TEMP => FPGA_TEMP,
			EXT_TEMP => EXT_TEMP,
			I2C_SCL_PIN => I2C_SCL_PIN,
			I2C_SDA_PIN => I2C_SDA_PIN
		);
      
   -- generate some bogus fixed temperature data;
   LOC_TRET <= x"b1";
   REM_TRET <= x"b2";

   -- fake the chip with a generic slave interface
   Fake_MAX1617 : i2c_slave
     generic map(
       SLV_ADR => I2C_ADR)
     port map(
			CLK => CLK,
			ARESET => RST,
         ADR => REG_ADR,
         WE  => REG_WE,
         I2C_TX => REG_OUT,
         I2C_RX => REG_IN,
			I2C_SCL_PIN => I2C_SCL_PIN,
			I2C_SDA_PIN => I2C_SDA_PIN
      );
      
   -- fake the registers
   fake_reg : process(CLK)
   begin
     if (CLK'event and CLK = '1') then
       if (REG_WE = '1') then
         case REG_ADR is
           when x"09" =>
             MAX1617_CONF <= REG_IN;
           when x"0A" =>
             MAX1617_RATE <= REG_IN;
           when x"0F" =>
             null; -- one shot register
           when others =>
             null;
         end case;
       end if;
       case REG_ADR is
         when x"00" =>
           REG_OUT <= LOC_TRET;
         when x"01" =>
           REG_OUT <= REM_TRET;
         when x"02" =>
           REG_OUT <= x"00";  -- bit 7 = 0 when conversion completed
         when others =>
           REG_OUT <= x"FF";
       end case;
     end if;
   end process fake_reg;

   -- pullups on I2C Pins
   I2C_SDA_PIN <= 'H';
   I2C_SCL_PIN <= 'H';
   
   -- generate appropriate clock
   clock_generate : process(CLK)
   begin
	 if CLK = '1' then
		CLK  <= '0' after (CLK_PERIOD * DUTY_CYCLE);
	 elsif CLK = '0' then
		CLK	 <=	'1' after (CLK_PERIOD * (1.0 - DUTY_CYCLE));
	 else
		CLK	<= '1';
	 end if;
   end process clock_generate;
   
   -- generate reset
   reset_proc : process
   begin
	 RST <= '1';
	 wait for (CLK_PERIOD * RST_CYCLES);
	 RST <= '0';
	 wait for 308 ns;
	 RST <= '1';
	 wait for 100 ns;
	 RST <= '0';
	 wait;
   end process reset_proc;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_temp_reader of temp_reader_tb is
	for TB_ARCHITECTURE
		for UUT : temp_reader
			use entity work.temp_reader(rtl);
		end for;
	end for;
end TESTBENCH_FOR_temp_reader;

