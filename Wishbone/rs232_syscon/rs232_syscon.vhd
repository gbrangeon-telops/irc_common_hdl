-------------------------------------------------------------------------------
--
-- Title       : rs232_syscon
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- SVN modified fields:
-- $Revision$
-- $Author$
-- $LastChangedDate$
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {rs232_syscon} architecture {rs232_syscon}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;



entity rs232_syscon is
	 generic(
		ADR_DIGITS_PP : integer := 3;
		DAT_DIGITS_PP : integer := 4;
		QTY_DIGITS_PP : integer := 2;
		CMD_BUFFER_SIZE_PP : integer := 32;
		CMD_PTR_BITS_PP : integer := 4;
		WATCHDOG_TIMER_VALUE_PP : integer := 200;
		WATCHDOG_TIMER_BITS_PP : integer := 8;
		RD_FIELDS_PP : integer := 8;
		RD_FIELD_COUNT_BITS_PP : integer := 3;
		RD_DIGIT_COUNT_BITS_PP : integer := 2;
		m1_initial_state : integer := 16#0#;
		m1_send_ok : integer := 16#01#;
		m1_send_prompt : integer := 16#02#;
		m1_check_received_char : integer := 16#03#;
		m1_send_crlf : integer := 16#04#;
		m1_parse_error_indicator_crlf : integer := 16#05#;
		m1_parse_error_indicator : integer := 16#06#;
		m1_ack_error_indicator : integer := 16#07#;
		m1_bg_error_indicator : integer := 16#08#;
		m1_cmd_error_indicator : integer := 16#09#;
		m1_adr_error_indicator : integer := 16#0a#;
		m1_dat_error_indicator : integer := 16#0b#;
		m1_qty_error_indicator : integer := 16#0c#;
		m1_scan_command : integer := 16#10#;
		m1_scan_adr_whitespace : integer := 16#11#;
		m1_get_adr_field : integer := 16#12#;
		m1_scan_dat_whitespace : integer := 16#13#;
		m1_get_dat_field : integer := 16#14#;
		m1_scan_qty_whitespace : integer := 16#15#;
		m1_get_qty_field : integer := 16#16#;
		m1_start_execution : integer := 16#17#;
		m1_request_bus : integer := 16#18#;
		m1_bus_granted : integer := 16#19#;
		m1_execute : integer := 16#1a#;
		m1_rd_send_adr_sr : integer := 16#1b#;
		m1_rd_send_separator : integer := 16#1c#;
		m1_rd_send_dat_sr : integer := 16#1d#;
		m1_rd_send_space : integer := 16#1e#;
		m1_rd_send_crlf : integer := 16#1f#
	    );
	 port(
		 ack_i : in STD_LOGIC;
		 clk_i : in STD_LOGIC;
		 err_i : in STD_LOGIC;
		 reset_i : in STD_LOGIC;
		 rs232_rxd_i : in STD_LOGIC;
		 dat_i : in STD_LOGIC_VECTOR(4*DAT_DIGITS_PP-1 downto 0);
		 adr_o : out STD_LOGIC_VECTOR(4*ADR_DIGITS_PP-1 downto 0);
		 cyc_o : out STD_LOGIC;
		 rs232_txd_o : out STD_LOGIC;
		 rst_o : out STD_LOGIC;
		 stb_o : out STD_LOGIC;
		 we_o : out STD_LOGIC;
		 dat_o : out STD_LOGIC_VECTOR(4*DAT_DIGITS_PP-1 downto 0)
	     );
end rs232_syscon;

--}} End of automatically maintained section

architecture rs232_syscon of rs232_syscon is
begin

   cyc_o <= '0';
   stb_o <= '0';

end rs232_syscon;
