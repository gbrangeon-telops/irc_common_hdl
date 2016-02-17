-------------------------------------------------------------------------------
--
-- Title       : LL_Serial_32
-- Author      : Patrick Dubois
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This module is used to bridge LocalLink data to serial data.
--               It is primarily used to create an Aurora simulation model.
--
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- This pulse cropper leaves the leading edge of a pulse intact BUT makes sure that the pulse goes back to zero at the very next CLK rising edge.
entity pulse_cropper is
   port(
      PULSE_IN    : in  std_logic;
      PULSE_OUT   : out std_logic;
      CLK         : in  std_logic
      );
end pulse_cropper;

architecture RTL of pulse_cropper is
begin
   
   process(CLK, PULSE_IN)
   begin
      if rising_edge(CLK) then
         PULSE_OUT <= '0';
      end if;
      if rising_edge(PULSE_IN) then
         PULSE_OUT <= '1';
      end if;
   end process;
   
end RTL;

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- This module extends any narrow glitch to a pulse lasting one clock period.
entity glitch_detector is
   port(
      PULSE_IN    : in  std_logic;
      PULSE_OUT   : out std_logic;
      CLK         : in  std_logic
      );
end glitch_detector;

architecture RTL of glitch_detector is
begin
   
   process(CLK, PULSE_IN)
      variable need_to_pulse : std_logic := '0';
   begin
      if rising_edge(PULSE_IN) then
         need_to_pulse := '1';
      end if;
      if rising_edge(CLK) then
         if need_to_pulse = '1' then
            PULSE_OUT <= '1';
            need_to_pulse := '0';
         else
            PULSE_OUT <= '0';
         end if;
      end if;
   end process;
   
end RTL;


library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
use Common_HDL.telops_testing.all;

entity LL_Serial_32 is
   generic(         
      Use_NFC     : boolean := false;        -- Set to TRUE if you want to use the NFC interface. Also pauses one clock cycle per EOF.
      baud_rate   : real := 4_000_000_000.0; -- This is the LINE baud rate (designed to be the same throughput as RocketIO)
      Latency     : time := 820 ns);         -- Transmission latency
   port(       
      
      -- Aurora Native Flow Control Interface
      NFC_REQ_N   : in std_logic;
      NFC_NB      : in std_logic_vector(0 to 3);
      NFC_ACK_N   : out std_logic;
      
      -- Transmitter port
      TX_MOSI     : in  t_ll_mosi32;
      TX_MISO     : out t_ll_miso;
      
      -- Receiver port
      RX_MOSI     : out t_ll_mosi32;
      RX_MISO     : in  t_ll_miso; -- Only AFULL is used. BUSY is not supported.
      
      SERIAL_TX   : out std_logic := '1';
      SERIAL_RX   : in  std_logic;
      
      ARESET      : in  std_logic;
      CLK         : in  std_logic
      );
end LL_Serial_32;

architecture sim of LL_Serial_32 is
   
   signal sreset  : std_logic;
   signal tx_dval : std_logic;
   signal tx_busy, tx_busy_rx, tx_busy_tx, tx_busy_fast : std_logic := '0';
   signal rx_mosi_i : t_ll_mosi32;
   signal rx_afull_previous : std_logic;
   
   constant PAYLOAD        : std_logic_vector(7 downto 0) := x"DA";
   constant NFC_STOP_REQ   : std_logic_vector(7 downto 0) := x"FF";
   constant NFC_FLOW_REQ   : std_logic_vector(7 downto 0) := x"60";
   constant NFC_ACK        : std_logic_vector(7 downto 0) := x"03";    
   
   constant XON            : std_logic_vector(0 to 3) := "0000";
   constant XOFF           : std_logic_vector(0 to 3) := "1111";
   
   signal baud_rate_uart   : real;
   signal serial_tx_i      : std_logic := '1';
   
   -- Inter-process communication.
   signal nfc_ack_received          : std_logic := '0';
   shared variable need_to_toggle_ack : std_logic := '0';
   
   signal need_to_toggle_dval       : std_logic := '0';
   
   shared variable need_to_send_ack : std_logic := '0';   
   
   shared variable tx_byte_array       : byte_array_t(1 to 5);
   shared variable nfc_stop_pending    : std_logic := '0';
   shared variable nfc_flow_pending    : std_logic := '0';
   shared variable waiting_for_ack     : std_logic := '0';
   shared variable last_request        : std_logic_vector(7 downto 0);
   
   shared variable tx_data_ready       : std_logic := '0'; 
   
   signal rx_afull                     : std_logic;
   signal nfc_afull                    : std_logic;
   
begin  
   
   
   NFC_ACK_N <= not nfc_ack_received;        
   rx_afull  <= nfc_afull when Use_NFC else RX_MISO.AFULL;
   
   nfc_proc : process(CLK)
   begin          
      if rising_edge(CLK) then 
         
         if NFC_REQ_N='0' then
            if NFC_NB=XON then               
               nfc_afull <= '0'; 
            elsif NFC_NB=XOFF then
               nfc_afull <= '1'; 
            else      
               assert FALSE report "NFC_NB value not supported!" severity ERROR;
            end if;
         end if;
         
         if sreset = '1' then
            nfc_afull <= '0';
         end if;
      end if;
   end process;
   
   tx_dval <= TX_MOSI.DVAL and not tx_busy;
   TX_MISO.BUSY <= tx_busy;
   TX_MISO.AFULL <= '0';
   rx_mosi_i.SUPPORT_BUSY <= '0';
   
   SERIAL_TX <= transport serial_tx_i after Latency;
   
   baud_rate_uart <= baud_rate * 6.0/4.0 * 2.0; -- Fudge factor
   
   tx_busy <= tx_busy_tx or tx_busy_rx or tx_busy_fast;
   
   the_sync_RESET :  entity sync_reset port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   -- This process is "fast" because it is garanteed to execute every clock cycle.
   tx_proc_fast : process(CLK)
      variable m                 : natural;
      variable n                 : natural;
   begin
      if rising_edge(CLK) then
         
         rx_afull_previous <= rx_afull;
         if tx_busy_fast = '1' then     
            -- This is necessarily because there was an EOF during last clock cycle.
            tx_busy_fast <= '0';         
            tx_data_ready := '1'; -- Send the EOF now (one clock cycle later to correctly simulate Aurora).
         end if;
         
         
         -- Latch input data
         if tx_dval = '1' then
            for i in tx_byte_array'RANGE loop 
               
               if i = 1 then
                  tx_byte_array(i) := TX_MOSI.SOF & TX_MOSI.EOF & TX_MOSI.DREM & "0000";
               else
                  n := 8*(i-2);
                  m := n+7;
                  tx_byte_array(i) := TX_MOSI.DATA(m downto n);
               end if;
            end loop;
            
            -- Delay EOF sending (to properly simulate Aurora)
            if TX_MOSI.EOF = '1' and Use_NFC then
               tx_busy_fast <= '1'; 
               tx_data_ready := '0';
            else
               tx_data_ready := '1';
            end if;              
            
            
         end if;
         
         -- Detect ack
         if nfc_ack_received = '1' then
            waiting_for_ack := '0';
            
            -- Clear useless pending requests.
            if nfc_stop_pending = '1' and last_request = NFC_STOP_REQ then
               nfc_stop_pending := '0'; -- The sender will stop. No need to ask twice.
            end if;
            if nfc_flow_pending = '1' and last_request = NFC_FLOW_REQ then
               nfc_flow_pending := '0'; -- The sender will restart. No need to ask twice.
            end if;
            
            -- Now let's reevaluate the situation
            if Use_NFC = false then
               if rx_afull = '1' and last_request = NFC_FLOW_REQ then -- Oups, we don't want that!
                  nfc_stop_pending := '1';
               end if;
               if rx_afull = '0' and last_request = NFC_STOP_REQ then -- Oups, we don't want that either!
                  nfc_flow_pending := '1';
               end if;               
            end if;
            
         end if;
         
         -- Detect need to send NFC Stop Request
         if rx_afull = '1' and rx_afull_previous = '0' then
            nfc_stop_pending := '1';
         end if;
         
         -- Detect need to send NFC Flow Request
         if rx_afull = '0' and rx_afull_previous = '1' then
            nfc_flow_pending := '1';
         end if;
         
      end if;
   end process;
   
   -- This process is "slow" because it is NOT garanteed to execute every clock cycle (tx_uart takes time to execute).
   tx_proc_slow : process
   begin
      --if rising_edge(CLK) then  
      loop
         wait until rising_edge(CLK);
         
         tx_busy_tx <= '0'; -- Default
         --tx_data_sent_glitch <= '0';
         
         -- Send NFC ack if required
         if need_to_send_ack = '1' then
            tx_busy_tx <= '1';
            tx_uart(NFC_ACK, baud_rate_uart, serial_tx_i);
            need_to_send_ack := '0';
         end if;
         
         -- Send NFC Stop Request
         if nfc_stop_pending = '1' and waiting_for_ack = '0' then
            tx_busy_tx <= '1';
            tx_uart(NFC_STOP_REQ, baud_rate_uart, serial_tx_i);
            last_request := NFC_STOP_REQ;
            waiting_for_ack := '1';
            nfc_stop_pending := '0';
         end if;
         
         -- Send NFC Flow Request
         if nfc_flow_pending = '1' and waiting_for_ack = '0' then
            tx_busy_tx <= '1';
            tx_uart(NFC_FLOW_REQ, baud_rate_uart, serial_tx_i);
            last_request := NFC_FLOW_REQ;
            waiting_for_ack := '1';
            nfc_flow_pending := '0';
         end if;
         
         if tx_data_ready = '1' then
            tx_busy_tx <= '1';
            
            -- First send a byte indicating that this is a DATA frame
            tx_uart(PAYLOAD, baud_rate_uart, serial_tx_i);
            
            -- Now send the payload
            tx_uart(tx_byte_array, baud_rate_uart, serial_tx_i);
            
            tx_busy_tx <= '0';
            tx_data_ready := '0';
         end if;

      end loop;
      --end if;
   end process;
   
   
   
   rx_resync : process(CLK)
   begin
      if rising_edge(CLK) then
         RX_MOSI <= rx_mosi_i;
         if sreset = '1' then
            RX_MOSI.DVAL <= '0';
         end if;
      end if;
   end process;
   
   rxloop : process
      variable rx_byte_array : byte_array_t(1 to 5);
      variable byte : std_logic_vector(7 downto 0);
   begin
      tx_busy_rx <= '0';
      need_to_toggle_dval <= '0';
      wait until sreset = '0';
      loop
         rx_uart(byte, baud_rate_uart, SERIAL_RX);
         need_to_toggle_dval <= '0';
         
         if byte = PAYLOAD then
            
            -- Now receive payload data
            rx_uart(rx_byte_array, baud_rate_uart, SERIAL_RX);
            
            -- Decode received data
            for i in rx_byte_array'RANGE loop
               if i = 1 then
                  rx_mosi_i.SOF <= rx_byte_array(i)(7);
                  rx_mosi_i.EOF <= rx_byte_array(i)(6);    
                  rx_mosi_i.DREM <= rx_byte_array(i)(5 downto 4);    
               else
                  rx_mosi_i.DATA(8*(i-2)+7 downto 8*(i-2)) <= rx_byte_array(i);
               end if;
            end loop;
            
            -- Toggle DVAL
            need_to_toggle_dval <= '1';
            
         elsif byte = NFC_STOP_REQ then
            tx_busy_rx <= '1';
            need_to_send_ack := '1';
            
         elsif byte = NFC_FLOW_REQ then
            tx_busy_rx <= '0';
            need_to_send_ack := '1';
            
         elsif byte = NFC_ACK then
            need_to_toggle_ack := '1';
            
         else
            assert FALSE report "Unrecognized data!" severity WARNING;
         end if;
         
      end loop;
      wait;
   end process rxloop;
   
   rx_toggle : process(CLK)
   begin
      if rising_edge(CLK) then
         if need_to_toggle_ack = '1' then
            nfc_ack_received <= '1';
            need_to_toggle_ack := '0';
         else
            nfc_ack_received <= '0';
         end if;
      end if;
   end process rx_toggle;
   
   -- Pulse reshapers
   Pulse1 : entity pulse_cropper   port map(PULSE_IN => need_to_toggle_dval, PULSE_OUT => rx_mosi_i.DVAL, CLK => CLK);
   
end sim;
