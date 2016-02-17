---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: controller_tb.vhd
--  Use: CRYOM system controller test bench
--
--  Revision history:  (use SVN for exact code history)
--    OBO : Oct 16, 2006 - original implementation
--
--  References:
--
--  Notes:
--
---------------------------------------------------------------------------------------------------

library ieee;
use work.pico_define.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity controller_tb is
end controller_tb;

architecture TB_ARCHITECTURE of controller_tb is
	-- Component declaration of the tested unit
	component controller
	port(
		CLK : in std_logic;
		RST : in std_logic;
        UART_TX0 : out std_logic;
        UART_RX0 : in std_logic;
        GPIO_IN : in std_logic_vector(7 downto 0);
        GPIO_OUT : out std_logic_vector(7 downto 0);
        PICO_MISO_EXT : in pico_miso_vector_t(2 downto 0);
        PICO_MOSI_EXT : out pico_mosi_vector_t(2 downto 0));
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : std_logic;
	signal RST : std_logic;
    signal UART_RX0 : std_logic;
    signal GPIO_IN  : std_logic_vector(7 downto 0);
    
	-- Observed signals - signals mapped to the output ports of tested entity
    signal UART_TX0 : std_logic;
    signal GPIO_OUT : std_logic_vector(7 downto 0);
    
    -- unused external PicoBlaze bus hooks
    signal PICO_MISO_EXT : pico_miso_vector_t(2 downto 0);
    signal PICO_MOSI_EXT : pico_mosi_vector_t(2 downto 0);
    
	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : controller
		port map (
			CLK => CLK,
			RST => RST,
            UART_TX0 => UART_TX0,
            UART_RX0 => UART_RX0,
            GPIO_IN => GPIO_IN,
            GPIO_OUT => GPIO_OUT,
            PICO_MISO_EXT => PICO_MISO_EXT,
            PICO_MOSI_EXT => PICO_MOSI_EXT
		);

   -- Add your stimulus here ...
    
   -- make sure to drive unused in_port signals to zero!
   unused_drive : for i in 0 to 2 generate
       PICO_MISO_EXT(i).in_port <= x"00";
   end generate unused_drive;
   
   -- generate a clock source
   clock : process
   begin
      CLK <= '0';
      loop
         wait for 10 ns;
         CLK <= not CLK;
      end loop;
   end process clock;
   
   -- pulse the reset at start of simulation for 10 clock cycles
   reset : process(CLK)
   variable cnt : integer := 10;
   begin
      if (CLK'event and CLK = '1') then
         if cnt = 0 then
            RST <= '0';
         else
            cnt := cnt -1;
            RST <= '1';
         end if;
      end if;
   end process reset;
   
   -- loop back the UART  and GPIO ports
   UART_RX0 <= UART_TX0;
   GPIO_IN <= GPIO_OUT;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_controller of controller_tb is
	for TB_ARCHITECTURE
		for UUT : controller
			use entity work.controller(from_bde);
		end for;
	end for;
end TESTBENCH_FOR_controller;

