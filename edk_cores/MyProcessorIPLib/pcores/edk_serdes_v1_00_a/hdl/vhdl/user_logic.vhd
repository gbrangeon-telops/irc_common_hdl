------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Mon Jan 07 11:30:54 2008 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library proc_common_v2_00_a;
use proc_common_v2_00_a.proc_common_pkg.all;
-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_DWIDTH                     -- User logic data bus width
--   C_NUM_CE                     -- User logic chip enable bus width
--   C_IP_INTR_NUM                -- User logic number of interrupt event
--   C_RDFIFO_DWIDTH              -- Data width of Read FIFO
--   C_RDFIFO_DEPTH               -- Depth of Read FIFO
--   C_WRFIFO_DWIDTH              -- Data width of Write FIFO
--   C_WRFIFO_DEPTH               -- Depth of Write FIFO
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   IP2Bus_IntrEvent             -- IP to Bus interrupt event
--   Bus2IP_Data                  -- Bus to IP data bus for user logic
--   Bus2IP_BE                    -- Bus to IP byte enables for user logic
--   Bus2IP_RdCE                  -- Bus to IP read chip enable for user logic
--   Bus2IP_WrCE                  -- Bus to IP write chip enable for user logic
--   IP2Bus_Data                  -- IP to Bus data bus for user logic
--   IP2Bus_Ack                   -- IP to Bus acknowledgement
--   IP2Bus_Retry                 -- IP to Bus retry response
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_ToutSup               -- IP to Bus timeout suppress
--   IP2RFIFO_WrReq               -- IP to RFIFO : IP write request
--   IP2RFIFO_Data                -- IP to RFIFO : IP write data
--   IP2RFIFO_WrMark              -- IP to RFIFO : mark beginning of packet being written
--   IP2RFIFO_WrRelease           -- IP to RFIFO : return RFIFO to normal FIFO operation
--   IP2RFIFO_WrRestore           -- IP to RFIFO : restore the RFIFO to the last packet mark
--   RFIFO2IP_WrAck               -- RFIFO to IP : RFIFO write acknowledge
--   RFIFO2IP_AlmostFull          -- RFIFO to IP : RFIFO almost full
--   RFIFO2IP_Full                -- RFIFO to IP : RFIFO full
--   RFIFO2IP_Vacancy             -- RFIFO to IP : RFIFO vacancy
--   IP2WFIFO_RdReq               -- IP to WFIFO : IP read request
--   IP2WFIFO_RdMark              -- IP to WFIFO : mark beginning of packet being read
--   IP2WFIFO_RdRelease           -- IP to WFIFO : Return WFIFO to normal FIFO operation
--   IP2WFIFO_RdRestore           -- IP to WFIFO : restore the WFIFO to the last packet mark
--   WFIFO2IP_Data                -- WFIFO to IP : WFIFO read data
--   WFIFO2IP_RdAck               -- WFIFO to IP : WFIFO read acknowledge
--   WFIFO2IP_AlmostEmpty         -- WFIFO to IP : WFIFO almost empty
--   WFIFO2IP_Empty               -- WFIFO to IP : WFIFO empty
--   WFIFO2IP_Occupancy           -- WFIFO to IP : WFIFO occupancy
------------------------------------------------------------------------------

entity user_logic is
	generic
		(
		-- ADD USER GENERICS BELOW THIS LINE ---------------
		C_TXDLINES                     : integer              := 1;     -- number of serial data lines to use for tx channel
		C_RXDLINES                     : integer              := 1;     -- number of serial data lines to use for rx channel
		-- ADD USER GENERICS ABOVE THIS LINE ---------------
		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol parameters, do not add to or delete
		C_DWIDTH                       : integer              := 32;
		C_NUM_CE                       : integer              := 1;
		C_IP_INTR_NUM                  : integer              := 1;
		C_RDFIFO_DWIDTH                : integer              := 32;
		C_RDFIFO_DEPTH                 : integer              := 512;
		C_WRFIFO_DWIDTH                : integer              := 32;
		C_WRFIFO_DEPTH                 : integer              := 512
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
		);
	port
		(
		-- ADD USER PORTS BELOW THIS LINE ------------------
		TX_SDAT                        : out std_logic_vector(0 to C_TXDLINES-1);
		TX_SCLK                        : out std_logic;
		RX_SDAT                        : in std_logic_vector(0 to C_RXDLINES-1);
		RX_SCLK                        : in std_logic;
		-- ADD USER PORTS ABOVE THIS LINE ------------------
		
		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add to or delete
		Bus2IP_Clk                     : in  std_logic;
		Bus2IP_Reset                   : in  std_logic;
		IP2Bus_IntrEvent               : out std_logic_vector(0 to C_IP_INTR_NUM-1);
		Bus2IP_Data                    : in  std_logic_vector(0 to C_DWIDTH-1);
		Bus2IP_BE                      : in  std_logic_vector(0 to C_DWIDTH/8-1);
		Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
		Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
		IP2Bus_Data                    : out std_logic_vector(0 to C_DWIDTH-1);
		IP2Bus_Ack                     : out std_logic;
		IP2Bus_Retry                   : out std_logic;
		IP2Bus_Error                   : out std_logic;
		IP2Bus_ToutSup                 : out std_logic;
		IP2RFIFO_WrReq                 : out std_logic;
		IP2RFIFO_Data                  : out std_logic_vector(0 to C_RDFIFO_DWIDTH-1);
		IP2RFIFO_WrMark                : out std_logic;
		IP2RFIFO_WrRelease             : out std_logic;
		IP2RFIFO_WrRestore             : out std_logic;
		RFIFO2IP_WrAck                 : in  std_logic;
		RFIFO2IP_AlmostFull            : in  std_logic;
		RFIFO2IP_Full                  : in  std_logic;
		RFIFO2IP_Vacancy               : in  std_logic_vector(0 to log2(C_RDFIFO_DEPTH));
		IP2WFIFO_RdReq                 : out std_logic;
		IP2WFIFO_RdMark                : out std_logic;
		IP2WFIFO_RdRelease             : out std_logic;
		IP2WFIFO_RdRestore             : out std_logic;
		WFIFO2IP_Data                  : in  std_logic_vector(0 to C_WRFIFO_DWIDTH-1);
		WFIFO2IP_RdAck                 : in  std_logic;
		WFIFO2IP_AlmostEmpty           : in  std_logic;
		WFIFO2IP_Empty                 : in  std_logic;
		WFIFO2IP_Occupancy             : in  std_logic_vector(0 to log2(C_WRFIFO_DEPTH))
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
		);
end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is
	
	--USER signal declarations added here, as needed for user logic
	signal rd_intr_en : std_logic;
	signal rd_intr_level : std_logic_vector(0 to log2(C_RDFIFO_DEPTH));
	signal wr_intr_en : std_logic;
	signal loopback_en : std_logic;
	
	-- internal localink style signals to talk to serializer and deserializer modules
	signal rx_dval : std_logic;
	signal rx_data : std_logic_vector(C_DWIDTH-1 downto 0);
	signal tx_bsy  : std_logic;
	signal tx_dval : std_logic;
	signal tx_data : std_logic_vector(C_DWIDTH-1 downto 0);
	signal rx_bsy  : std_logic;
	signal des_dval : std_logic;
	signal des_data : std_logic_vector(C_DWIDTH-1 downto 0);
	
	-- transmitted clock division factor
	signal tx_clkdiv : std_logic_vector(2 downto 0);
	
	-- slv_reg0 mapped to ctrl_reg with proper vector direction!
	signal ctrl_reg                      : std_logic_vector(C_DWIDTH-1 downto 0);
	
	------------------------------------------
	-- Signals for user logic slave model s/w accessible register example
	------------------------------------------
	signal slv_reg0                       : std_logic_vector(0 to C_DWIDTH-1);
	signal slv_reg_write_select           : std_logic_vector(0 to 0);
	signal slv_reg_read_select            : std_logic_vector(0 to 0);
	signal slv_ip2bus_data                : std_logic_vector(0 to C_DWIDTH-1);
	signal slv_read_ack                   : std_logic;
	signal slv_write_ack                  : std_logic;
	
	------------------------------------------
	-- Signals for user logic interrupt example
	------------------------------------------
	signal interrupt                      : std_logic_vector(0 to C_IP_INTR_NUM-1);
	
begin
	
	--USER logic implementation added here
	
	------------------------------------------
	-- Example code to read/write user logic slave model s/w accessible registers
	-- 
	-- Note:
	-- The example code presented here is to show you one way of reading/writing
	-- software accessible registers implemented in the user logic slave model.
	-- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
	-- to one software accessible register by the top level template. For example,
	-- if you have four 32 bit software accessible registers in the user logic, you
	-- are basically operating on the following memory mapped registers:
	-- 
	--    Bus2IP_WrCE or   Memory Mapped
	--       Bus2IP_RdCE   Register
	--            "1000"   C_BASEADDR + 0x0
	--            "0100"   C_BASEADDR + 0x4
	--            "0010"   C_BASEADDR + 0x8
	--            "0001"   C_BASEADDR + 0xC
	-- 
	------------------------------------------
	slv_reg_write_select <= Bus2IP_WrCE(0 to 0);
	slv_reg_read_select  <= Bus2IP_RdCE(0 to 0);
	slv_write_ack        <= Bus2IP_WrCE(0);
	slv_read_ack         <= Bus2IP_RdCE(0);
	
	-- implement slave model register(s)
	SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
	begin
		
		if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
			if Bus2IP_Reset = '1' then
				slv_reg0 <= (others => '0');
			else
				case slv_reg_write_select is
					when "1" =>
						for byte_index in 0 to (C_DWIDTH/8)-1 loop
							if ( Bus2IP_BE(byte_index) = '1' ) then
								slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
							end if;
						end loop;
					when others => null;
				end case;
			end if;
		end if;
	end process SLAVE_REG_WRITE_PROC;
	
	-- implement slave model register read mux
	SLAVE_REG_READ_PROC : process( slv_reg_read_select, slv_reg0 ) is
	begin
		
		case slv_reg_read_select is
			when "1" => slv_ip2bus_data <= slv_reg0;
			when others => slv_ip2bus_data <= (others => '0');
		end case;
	end process SLAVE_REG_READ_PROC;
	
	-- interupt when enabled and target level reached in the read fifo 
	INTR_PROC : process( Bus2IP_Clk ) is
	begin
		if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
			if ( Bus2IP_Reset = '1' ) then
				interrupt <= (others => '1');
			else
				if (rd_intr_en = '1' and (unsigned(RFIFO2IP_Vacancy) >= unsigned(rd_intr_level)))
					or (wr_intr_en = '1' and WFIFO2IP_Empty = '1') then
					interrupt <= (others => '1');
				else
					interrupt <= (others => '0');
				end if;
			end if;
		end if;
	end process INTR_PROC;
	
	IP2Bus_IntrEvent <= interrupt;
	
	-- interface rx fifo port
	IP2RFIFO_WrMark    <= '0';
	IP2RFIFO_WrRelease <= '0';
	IP2RFIFO_WrRestore <= '0';
	IP2RFIFO_WrReq <= rx_dval and not RFIFO2IP_full;
	IP2RFIFO_Data <= rx_data;
	rx_bsy <= RFIFO2IP_full;
	
	-- interface tx fifo port
	IP2WFIFO_RdMark    <= '0';
	IP2WFIFO_RdRelease <= '0';
	IP2WFIFO_RdRestore <= '0';
	IP2WFIFO_RdReq <= not WFIFO2IP_empty and not tx_bsy;
	tx_data <= WFIFO2IP_Data;
	tx_dval <= WFIFO2IP_RdAck;
	
	-- interface with control register
	ctrl_reg <= slv_reg0;  -- this puts the vector order the right way around
	
	rd_intr_level <= ctrl_reg(rd_intr_level'range);
	tx_clkdiv(0)  <= ctrl_reg(16);
	tx_clkdiv(1)  <= ctrl_reg(17);
	tx_clkdiv(2)  <= ctrl_reg(18);
	loopback_en   <= ctrl_reg(28);
	wr_intr_en    <= ctrl_reg(29);
	rd_intr_en    <= ctrl_reg(31);
	
	------------------------------------------
	-- Interface code to drive IP to Bus signals
	------------------------------------------
	IP2Bus_Data        <= slv_ip2bus_data;
	IP2Bus_Ack         <= slv_write_ack or slv_read_ack;
	IP2Bus_Error       <= '0';
	IP2Bus_Retry       <= '0';
	IP2Bus_ToutSup     <= '0';
	
	-- instantiate the serializer core
	SERIALIZER_I : entity edk_serdes_v1_00_a.serializer
	generic map(
		width => C_DWIDTH,
		lines => C_TXDLINES)
	port map(
		CLK   => Bus2IP_Clk,
		DIV   => tx_clkdiv,
		DIN   => tx_data,
		DVAL  => tx_dval,
		BSY   => tx_bsy,
		SDAT  => TX_SDAT,
		SCLK  => TX_SCLK);
	
	-- instantiate the deserializer core
	DESERIALIZER_I : entity edk_serdes_v1_00_a.deserializer
	generic map(
		width => C_DWIDTH,
		lines => C_RXDLINES)
	port map(
		CLK   => Bus2IP_Clk,
		DOUT  => des_data,
		DVAL  => des_dval,
		SDAT  => RX_SDAT,
		SCLK  => RX_SCLK);
	
	-- loopback bypasses receiver and instead feeds back transmitted data as well as outputing it
	loopback : process(loopback_en, tx_data, tx_dval, des_data, des_dval)
	begin
		if (loopback_en = '1') then
			rx_data <= tx_data;
			rx_dval <= tx_dval;
		else
			rx_data <= des_data;
			rx_dval <= des_dval;
		end if;
	end process loopback;
	
	--  -- Simple loopback known to work...
	--  TX_SDAT <= "0";
	--  TX_SCLK <= '0';
	--  rx_data <= tx_data;
	--  rx_dval <= tx_dval;
	--  tx_bsy <= rx_bsy;
	
end IMP;
