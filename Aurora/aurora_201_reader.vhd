---------------------------------------------------------------------------------------------------
--                                                      ..`??!````??!..
--                                                  .?!                `1.
--                                               .?`                      i
--                                             .!      ..vY=!``?74.        i
--.........          .......          ...     ?      .Y=` .+wA..   ?,      .....              ...
--"""HMM"""^         MM#"""5         .MM|    :     .H\ .JQgNa,.4o.  j      MM#"MMN,        .MM#"WMF
--   JM#             MMNggg2         .MM|   `      P.;,jMt   `N.r1. ``     MMmJgMM'        .MMMNa,.
--   JM#             MM%````         .MM|   :     .| 1A Wm...JMy!.|.t     .MMF!!`           . `7HMN
--   JMM             MMMMMMM         .MMMMMMM!     W. `U,.?4kZ=  .y^     .!MMt              YMMMMB=
--                                          `.      7&.  ?1+...JY'     .J
--                                           ?.        ?""""7`       .?`
--                                             :.                ..?`
--
---------------------------------------------------------------------------------------------------
--
-- Title       : Aurora_201_reader
-- Design      : Aurora
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;             
library Common_HDL;
use Common_HDL.Telops.all;

entity Aurora_201_reader is  
   generic(
      RX_FifoSize : integer := 511);   -- If RX_FifoSize = 0, do not generate internal components
   port (
      --------------------------------
      -- Aurora IO
      --------------------------------	
      Rx_Src_Rdy_N 	: in 	std_logic; -- Message is being received
      Rx_D				: in 	std_logic_vector(0 to 15);
      Rx_Eof_N 		: in 	std_logic;
      Rx_Sof_N 		: in 	std_logic;		
      Channel_UP		: in 	std_logic;
      NFC_ACK_N 		: in 	std_logic;
      NFC_REQ_N 		: out std_logic;
      NFC_NB 			: out std_logic_vector(0 to 3);
      --------------------------------
      -- User IO
      --------------------------------
      TX_LL_MOSI     : out t_ll_mosi;
      TX_LL_MISO     : in  t_ll_miso;
      --------------------------------
      -- Other IOs
      --------------------------------	
      CLK 				: in 	std_logic;		-- System Clock
      RESET 			: in 	std_logic	-- External push-button SW2
      );
end Aurora_201_reader;

architecture RTL of Aurora_201_reader is																	
   
   signal Counter : integer range 0 to 255;		-- Counts the received Word
   signal Rst_Count : integer range 0 to 7;
   constant XOFF : std_logic_vector(0 to 3) := "1111";
   constant XON : std_logic_vector(0 to 3) := "0000";  
   signal EN : std_logic;     
   signal dval : std_logic;
   
begin                   
   
   TX_LL_MOSI.SUPPORT_BUSY <= '0';
   
   gen_on : if (RX_FifoSize > 0) generate
      begin
      EN <= not TX_LL_MISO.AFULL;
      
      Output_data_control : process (RESET, CLK)
      begin									
         if rising_edge(CLK) then
            if (RESET = '1') then
               TX_LL_MOSI.DVAL <= '0';
            else
               -- Data buffering
               TX_LL_MOSI.DATA <= Rx_D;
               TX_LL_MOSI.SOF <= not Rx_Sof_N;
               TX_LL_MOSI.EOF <= not Rx_Eof_N;
               -- Flow control for FIFO
               if (Rx_Src_Rdy_N = '0' and Channel_UP = '1') then
                  TX_LL_MOSI.DVAL <= '1';
                  dval <= '1';
               else					
                  TX_LL_MOSI.DVAL <= '0';
                  dval <= '0';
               end if;						
            end if; 
         end if;
      end process;
      
      NFC_machine : entity work.Aurora_NFC
      port map (
         CHANNEL_UP 	=> CHANNEL_UP,
         CLK 			=> CLK,
         EN				=> EN,
         DVAL        => dval,
         NFC_ACK_N	=> NFC_ACK_N,
         NFC_ERR     => open,
         RESET			=> RESET,
         NFC_NB		=> NFC_NB,
         NFC_REQ_N	=> NFC_REQ_N);         
      
   end generate gen_on;
   
   gen_off : if (RX_FifoSize = 0) generate
      begin  
      
      TX_LL_MOSI.DATA <= (others => '0');
      TX_LL_MOSI.SOF <= '0';
      TX_LL_MOSI.EOF <= '0';
      TX_LL_MOSI.DVAL <= '0';   
      NFC_REQ_N <= '1';
      NFC_NB <= X"0";
      
   end generate gen_off;
   
   
end RTL;
