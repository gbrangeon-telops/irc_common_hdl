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
use work.wb8bit_define.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity controller_wb_tb is
end controller_wb_tb;

architecture TB_ARCHITECTURE of controller_wb_tb is
	-- Component declaration of the tested unit
	component controller_wb
	port(
		CLK : in std_logic;
		RST : in std_logic;
        UART_TX0 : out std_logic;
        UART_RX0 : in std_logic;
        GPIO_IN : in std_logic_vector(7 downto 0);
        GPIO_OUT : out std_logic_vector(7 downto 0);
        WB_MISO_V_EXT : in wb8bit_miso_v_t(3 downto 0);
        WB_MOSI_V_EXT : out wb8bit_mosi_v_t(3 downto 0));
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
    signal WB_MISO_V_EXT : wb8bit_miso_v_t(3 downto 0);
    signal WB_MOSI_V_EXT : wb8bit_mosi_v_t(3 downto 0);
    
	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : controller_wb
		port map (
			CLK => CLK,
			RST => RST,
            UART_TX0 => UART_TX0,
            UART_RX0 => UART_RX0,
            GPIO_IN => GPIO_IN,
            GPIO_OUT => GPIO_OUT,
            WB_MISO_V_EXT => WB_MISO_V_EXT,
            WB_MOSI_V_EXT => WB_MOSI_V_EXT
		);

   -- Add your stimulus here ...
    
   -- make sure to drive unused in_port signals to zero!
   unused_drive : for i in 0 to 2 generate
       WB_MISO_V_EXT(i).DAT <= x"00";
       WB_MISO_V_EXT(i).ACK <= '0';
       WB_MISO_V_EXT(i).INT <= '0';
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

configuration TESTBENCH_FOR_controller_wb of controller_wb_tb is
	for TB_ARCHITECTURE
		for UUT : controller_wb
			use entity work.controller_wb(from_bde);
		end for;
	end for;
end TESTBENCH_FOR_controller_wb;

