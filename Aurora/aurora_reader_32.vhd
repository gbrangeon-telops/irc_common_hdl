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
-- Title       : aurora_reader_32
-- Design      : Aurora
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;             
library Common_HDL;
use Common_HDL.Telops.all;

entity aurora_reader_32 is  
   generic(
      RX_FifoSize : integer := 511);   -- If RX_FifoSize = 0, do not generate internal components
   port (
      --------------------------------
      -- Aurora IO
      --------------------------------	
      Rx_Src_Rdy_N: in std_logic; -- Message is being received
      Rx_D			: in std_logic_vector(0 to 31);
      Rx_Eof_N 	: in std_logic;
      Rx_Sof_N 	: in std_logic;	
      Rx_Rem      : in std_logic_vector(0 to 1);
      Channel_UP	: in std_logic;
      NFC_ACK_N 	: in std_logic;
      NFC_REQ_N 	: out std_logic;
      NFC_NB 		: out std_logic_vector(0 to 3);
      --------------------------------
      -- User IO
      --------------------------------
      TX_LL_MOSI  : out t_ll_mosi32;
      TX_LL_MISO  : in  t_ll_miso;        
      NFC_ERR     : out std_logic;
      --------------------------------
      -- Other IOs
      --------------------------------	
      CLK 			: in std_logic;		-- System Clock
      RESET 		: in std_logic	      -- This MUST be synchronous to CLK
      );
end aurora_reader_32;

architecture rtl of aurora_reader_32 is																	
   
   component aurora_nfc
      port (
         CHANNEL_UP: in STD_LOGIC;
         CLK: in STD_LOGIC;
         EN: in STD_LOGIC;
         NFC_ACK_N: in STD_LOGIC;
         DVAL : in STD_LOGIC;
         RESET: in STD_LOGIC;
         NFC_ERR :out STD_LOGIC;
         NFC_NB: out STD_LOGIC_VECTOR (0 to 3);
         NFC_REQ_N: out STD_LOGIC);
   end component;
   
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
               -- Rem should only be read on EOF! => ideally all blocks should abide by this rule
               if Rx_Eof_N = '0' then
                  TX_LL_MOSI.DREM <= Rx_Rem;
               else
                  TX_LL_MOSI.DREM <= (others => '1');
               end if;
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
      
      NFC_machine :  Aurora_NFC
      port map (
      CHANNEL_UP 	=> CHANNEL_UP,
      CLK 			=> CLK,
      EN				=> EN,  
      DVAL        => dval,
      NFC_ACK_N	=> NFC_ACK_N,
      RESET			=> RESET,
      NFC_NB		=> NFC_NB,
      NFC_ERR     => NFC_ERR,
      NFC_REQ_N	=> NFC_REQ_N);         
      
   end generate gen_on;
   
   gen_off : if (RX_FifoSize = 0) generate
      begin  
      
      TX_LL_MOSI.DATA <= (others => '0');
      TX_LL_MOSI.DREM <= (others => '0');
      TX_LL_MOSI.SOF <= '0';
      TX_LL_MOSI.EOF <= '0';
      TX_LL_MOSI.DVAL <= '0';   
      NFC_REQ_N <= '1';
      NFC_NB <= X"0";
      NFC_ERR <= '0';
      
   end generate gen_off;
   
   
end RTL;
