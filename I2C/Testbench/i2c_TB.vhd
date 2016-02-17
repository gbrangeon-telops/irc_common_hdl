---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: i2c_tb.vhd
--  Hierarchy: submodule testbench
--  Use: Testing I2C/SMBus serial interface components
--	 Project: POF2005 - Temperature sensing diodes SMBus peripheral access
--	 By: Olivier Bourgois
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
library work;
use work.sim_pack.clk_gen;

entity i2c_tb is
  generic(
    CLK_PERIOD : time := 10ns;				                    -- Generate 100 Mhz Clock
    DUTY_CYCLE : real := 0.5;				                       -- 50 % duty cycle
	 RST_CYCLES : natural := 10;                               -- drive reset 10 clocks
    SLV1_ADR    : std_logic_vector(6 downto 0) := "1010101"); -- setting for slave address
end i2c_tb;

architecture TB_ARCHITECTURE of i2c_tb is
	-- Component declaration of the tested unit
	component i2c_master
   port(
     CLK          : in    std_logic;
     ARESET       : in    std_logic;
     SCL4XSRC     : in    std_logic;
     I2C_ADR      : in    std_logic_vector(6 downto 0);
     I2C_STB      : in    std_logic;
     I2C_WE       : in    std_logic;
     I2C_NACK     : in    std_logic;
     I2C_ACK      : out   std_logic;
     I2C_ERR      : out   std_logic;
     I2C_ACT      : out   std_logic;
     I2C_TX       : in    std_logic_vector(7 downto 0);
     I2C_RX       : out   std_logic_vector(7 downto 0);   
     I2C_SCL_PIN  : out   std_logic;
     I2C_SDA_PIN  : inout std_logic);
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

	-- Signal Decalarations
	signal CLK : std_logic;
	signal RST : std_logic;
   signal SCL4XSRC : std_logic;
	signal I2C_ADR : std_logic_vector(6 downto 0);
	signal I2C_STB : std_logic;
	signal I2C_WE : std_logic;
	signal I2C_TX : std_logic_vector(7 downto 0);
	signal I2C_SDA_PIN : std_logic;
	signal I2C_ACK : std_logic;
	signal I2C_ERR : std_logic;
   signal I2C_ACT : std_logic;
	signal I2C_RX : std_logic_vector(7 downto 0);
	signal I2C_SCL_PIN : std_logic;
   signal REG_ADR : std_logic_vector(7 downto 0);
   signal REG_WE  : std_logic;
   signal REG_OUT : std_logic_vector(7 downto 0);
   signal REG_IN : std_logic_vector(7 downto 0);
   
   -- ram array inference
   type   ram_w8x256_type is array (255 downto 0) of std_logic_vector (7 downto 0);
   signal ram_w8x256 : ram_w8x256_type;
   
   constant SLV_DEAD : std_logic_vector(6 downto 0) := "0011001";
   
   -- set to '0' if master acks slave data reception
   constant I2C_NACK : std_logic := '0';
   
begin

	-- Unit Under Test port map
	UUT_master : i2c_master
		port map (
			CLK => CLK,
			ARESET => RST,
         SCL4XSRC => SCL4XSRC,
			I2C_STB => I2C_STB,
			I2C_WE => I2C_WE,
         I2C_NACK => I2C_NACK,
			I2C_ACK => I2C_ACK,
         I2C_ERR => I2C_ERR,
         I2C_ADR => I2C_ADR,
         I2C_ACT => I2C_ACT,
			I2C_TX => I2C_TX,
			I2C_RX => I2C_RX,
			I2C_SCL_PIN => I2C_SCL_PIN,
			I2C_SDA_PIN => I2C_SDA_PIN
		);
      
   UUT_slave1 : i2c_slave
     generic map(
       SLV_ADR => SLV1_ADR)
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

   -- pullups on I2C Pins
   I2C_SDA_PIN <= 'H';
   I2C_SCL_PIN <= 'H';
   
   -- Clock and reset generation from sim_pack
	clk_gen_inst : clk_gen
	  generic map (
	    period      => CLK_PERIOD,
	    duty_cycle  => DUTY_CYCLE,
		rst_cycles   => RST_CYCLES)
	  port map (
	    RST_SYNC => RST,
	    CLK      => CLK);
       
   -- divide the clock by 6 to generate SCL4XGEN
   scl4xgen_proc : process (CLK)
   variable delay : std_logic_vector(1 downto 0);
   begin
     if (CLK'event and CLK = '1') then
       if (RST = '1') then
         SCL4XSRC <= '0';
         delay := "00";
       else
         SCL4XSRC <= delay(1);
         delay(1) := delay(0);
         delay(0) := not SCL4XSRC;
       end if;
     end if;
   end process scl4xgen_proc;
       
  -- Slave register file
  reg_file_proc : process (CLK)
    begin
    if (CLK'event and CLK = '1') then
      if (REG_WE = '1') then
        ram_w8x256(conv_integer(REG_ADR)) <= REG_IN;
      end if;
    end if;
  end process reg_file_proc;  
  REG_OUT <= ram_w8x256(conv_integer(REG_ADR));
   
   -- main test stimulus
   i2c_test : process
   begin
     -- wait for reset and interface to be ready
     I2C_ADR <= "XXXXXXX";
     I2C_STB <= '0';
     I2C_WE  <= '0';
     I2C_TX  <= "XXXXXXXX";
     wait until (RST = '0' and CLK = '1');
     wait until CLK = '0';
     wait until CLK = '1';
     
     --  write three consecutive bytes to slave
     --  write command byte
     I2C_ADR <= SLV1_ADR;   -- slave address
     
     -- write address byte
     I2C_STB <= '1';        -- start a write cycle
     I2C_WE  <= '1';        -- write cycle
     I2C_TX  <= x"00";      -- data byte 1   
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
      -- write data byte 1
     I2C_STB <= '1';        -- start a write cycle
     I2C_WE  <= '1';        -- write cycle
     I2C_TX  <= x"a1";      -- data byte 1   
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
      -- write data byte 2
     I2C_STB <= '1';        -- start a write cycle
     I2C_WE  <= '1';        -- write cycle
     I2C_TX  <= x"a2";      -- data byte 2  
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
      -- write data byte 3
     I2C_STB <= '1';        -- start a write cycle
     I2C_WE  <= '1';        -- write cycle
     I2C_TX  <= x"a3";      -- data byte 3    
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
     wait for 1 us;       -- wait for interface to disable
     wait until CLK = '0';
     wait until CLK = '1';
     
     
     --  read back three consecutive bytes from slave
     I2C_ADR <= SLV1_ADR;   -- slave address
     
     -- write address byte
     I2C_STB <= '1';        -- start a write cycle
     I2C_WE  <= '1';        -- write cycle
     I2C_TX  <= x"00";      -- data byte 1   
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
     -- read cycle 1 data turnaround (should trigger a restart condition) 
     I2C_STB <= '1';        -- start a read cycle
     I2C_WE  <= '0';        -- read cycle
     I2C_TX  <= "XXXXXXXX"; -- no data will be transfered   
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
     -- read cycle 2
     I2C_ADR <= SLV1_ADR;   -- same slave address
     I2C_STB <= '1';        -- start a read cycle
     I2C_WE  <= '0';        -- read cycle
     I2C_TX  <= "XXXXXXXX"; -- no data will be transfered   
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
     -- read cycle 3
     I2C_ADR <= SLV1_ADR;   -- same slave address
     I2C_STB <= '1';        -- start a read cycle
     I2C_WE  <= '0';        -- read cycle
     I2C_TX  <= "XXXXXXXX"; -- no data will be transfered   
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
     wait for 1 us;       -- wait for interface to disable
     wait until CLK = '0';
     wait until CLK = '1';
     
     --  try to write to non existent slave
     I2C_ADR <= SLV_DEAD;   -- slave address
     
     I2C_STB <= '1';        -- start a write cycle
     I2C_WE  <= '1';        -- write cycle
     I2C_TX  <= x"00";      -- first register address   
     wait until CLK = '0';
     wait until CLK = '1';
     wait until I2C_ACK = '1';
     wait until CLK = '0';
     wait until CLK = '1';
     I2C_STB <= '0';
     
     wait; -- indefinitely
     
   end process i2c_test;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_i2c of i2c_tb is
	for TB_ARCHITECTURE
		for UUT_master : i2c_master
			use entity work.i2c_master(rtl);
		end for;
      for UUT_slave1 : i2c_slave
			use entity work.i2c_slave(rtl);
		end for;
	end for;
end TESTBENCH_FOR_i2c;

