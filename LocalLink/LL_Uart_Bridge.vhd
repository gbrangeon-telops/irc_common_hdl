---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2009
--
--  File: LL_Uart_Bridge.vhd
--  Use: Brigde interfacing the UART with the Local Link interface
--  By: Patrick Daraiche
--
--  $Revision: 
--  $Author: 
--  $LastChangedDate:
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_Uart_Bridge is
   generic(
      Fxtal : INTEGER := 3686400;
      Parity : BOOLEAN := false;
      Even : BOOLEAN := false;
      Baud_RTL : INTEGER := 115200;
      Baud_SIM : INTEGER := 6250000;
      NbStopBit : INTEGER := 2);
   port(
      -- Common Section
      CLK : in STD_LOGIC;
      ARESET : in STD_LOGIC;
      -- RS-232 Section
      TX : out std_logic;
      RX : in std_logic;
      RS232_ERR : out std_logic;
      -- Local Link Section
      RX1_MOSI : out t_ll_mosi8;
      RX1_MISO : in t_ll_miso;
      TX1_MOSI : in t_ll_mosi8;
      TX1_MISO : out t_ll_miso
      );
end LL_Uart_Bridge;

architecture rtl of LL_Uart_Bridge is
   
   -- declaring components explicitly eases synthesis file ordering mess!
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   component uarts
      generic(
         Fxtal : INTEGER := 3686400;
         Parity : BOOLEAN := false;
         Even : BOOLEAN := false;
         Baud1 : INTEGER := 115200;
         Baud2 : INTEGER := 6250000;
         NbStopBit : INTEGER := 2);
      port(
         CLK : in std_logic;
         RST : in std_logic;
         Din : in std_logic_vector(7 downto 0);
         LD : in std_logic;
         Rx : in std_logic;
         Baud : in std_logic;
         Dout : out std_logic_vector(7 downto 0);
         Tx : out std_logic;
         TxBusy : out std_logic;
         RxErr : out std_logic;
         RxRDY : out std_logic);
   end component;            
   -- translate_off
   for all: uarts use entity common_hdl.uarts(asim);
   -- translate_on
   
   signal sreset : std_logic;   
   signal Baud : std_logic;   
   signal TX_Busy : std_logic;
   signal TX_Dval : std_logic;
   --signal RxRDY : std_logic;
   signal RxErr : std_logic;
   --signal data_rdy_to_send : std_logic := '0';
   
begin
   
   -- enter your statements here --
   -- synchronize reset locally
   synchronize_reset : sync_reset port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   uart : uarts
   generic map(
      Fxtal => Fxtal,
      Parity => Parity,
      Even => Even,
      Baud1 => Baud_RTL,
      Baud2 => Baud_SIM,
      NbStopBit => NbStopBit
      )
   port map(
      CLK => CLK,
      RST => sreset,
      Din => TX1_MOSI.DATA,
      LD => TX_Dval,
      Rx => Rx,
      Baud => Baud,
      Dout => RX1_MOSI.DATA,
      Tx => Tx,
      TxBusy => TX_Busy,
      RxErr => RxErr,
      RxRDY => RX1_MOSI.DVAL
      );
   
--   rx_process : process(CLK)
--   begin
--      if rising_edge(CLK) then
--         if(RXRDY = '1') then
--            data_rdy_to_send <= '1';
--         else
--            data_rdy_to_send <= '0';
--         end if;
--      end if;
--   end process;
      
   TX1_MISO.BUSY <= TX_Busy;
   TX_Dval <= TX1_MOSI.DVAL and not TX_Busy;
   TX1_MISO.AFULL <= TX_Busy;
       
   --RX1_MOSI.DVAL <= '1' when data_rdy_to_send = '1' else '0';
   RX1_MOSI.SOF <= '0';
   RX1_MOSI.EOF <= '0';

   RS232_ERR <= RxErr;
   RX1_MOSI.SUPPORT_BUSY <= '0';
   
   BAUD <= 'H';
   -- pragma translate_off
   BAUD <= '0';
   -- pragma translate_on
   
   
end rtl;
