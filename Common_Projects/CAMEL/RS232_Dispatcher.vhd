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
-- Title       : RS232_Dispatcher
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library Common_HDL;
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;

entity RS232_Dispatcher is
   Port ( 
      --------------------------------
      -- RX UART UNIT
      -------------------------------- 
      RX_DATA_IN     : in  std_logic_vector(7 downto 0);    -- RS232 Received Data
      RX_DATA_RDY    : in  std_logic;                       -- RS232 Receive Flag 
      RX_RD          : out std_logic;                       -- Pulse to zero at data reception to RESET the RS232 controller
      --------------------------------
      -- TX UART UNIT
      -------------------------------- 
      TX_DATA_OUT    : out std_logic_vector(7 downto 0);
      TX_EMPTY       : in  std_logic;
      TX_LOAD        : out std_logic;
      --------------------------------
      -- USER INTERFACE
      --------------------------------
      DATA_OUT       : out std_logic_vector(7 downto 0);
      DATA_VALID     : out std_logic;
      FRAME_TYPE     : out t_RS232;
      FRAME_ERR      : out std_logic;
      CFG_REQ        : out std_logic;                       -- Request to send configuration back by RS-232
      STAT_REQ       : out std_logic;                       -- Request to send current status back by RS-232
      STAT94_REQ     : out std_logic; 
      INSIDE_CLINK   : in  std_logic;                       -- True if VP7, false if VP30 (would be better replaced by a generic, but I'm afraid of xst bugs)
      --------------------------------
      -- MISC SIGNALS
      --------------------------------
      CLK            : in  std_logic;                       -- System General Clock
      RESET          : in  std_logic);                      -- RESETs the state machine to wait for the first byte and write default values on Period, Low_limit and High_Limit
   ---------------------------------
end RS232_Dispatcher;

architecture Behavioral of RS232_Dispatcher is

   type t_state is (Idle, Header, GetSize, Count);
   signal state : t_state;
   
--   signal RX_DATA_RDY_Sync : std_logic;  
--   signal TX_EMPTY_Sync : std_logic; 
   
   signal Data_Buf_Valid : std_logic;
   signal Data_Buf : std_logic_vector(7 downto 0);
   signal RX_RD_buf : std_logic;
   
   constant MS_Cnt_Limit : integer := integer(real(50_000_000)*0.001);        -- Clock cycles in one milisecond
   constant TimeOut_MS_Limit : integer := 50;      -- Time out Limit in miliseconds 
   
   signal MS_Cnt : integer range 0 to MS_Cnt_Limit;
   signal TimeOut_cnt : integer range 0 to TimeOut_MS_Limit;
   signal TimeOut : std_logic;            -- TimeOut between two bytes (Active HIGH)   
   
begin
   
   -- Concurrent statements 
   DATA_OUT <= Data_Buf;
   TX_DATA_OUT <= Data_Buf;
   RX_RD <= RX_RD_buf and not RX_DATA_RDY and TX_EMPTY;
   
   Data_Buf <= RX_DATA_IN;
   Data_Buf_Valid <= RX_DATA_RDY;  
   
   -- Time-out counter
   Timeout_Check : process(CLK)
   begin
      if rising_edge(CLK) then
         if RESET = '1' then
            TimeOut <= '0';
            MS_Cnt <= 0;
            TimeOut_cnt <= 0;
         else
            -- Every new received byte reset the counter
            if Data_Buf_Valid = '1' then  
               MS_Cnt <= 0;
               TimeOut_cnt <= 0;
               TimeOut <= '0';
            else
               if MS_Cnt = MS_Cnt_Limit then
                  MS_Cnt <= 0;
                  if TimeOut_cnt = TimeOut_MS_Limit then
                     TimeOut <= '1';   -- Counter stops once timeout is reached
                  else
                     TimeOut_cnt <= TimeOut_cnt + 1;
                  end if;
               else
                  MS_Cnt <= MS_Cnt + 1;
               end if;
            end if;
         end if;
      end if;
   end process;   
   
   Dispatch : process(RESET,CLK)
      variable Frame_Counter : integer range 0 to 1023;
      variable Destination_Internal : std_logic;
      variable Destination_External : std_logic;
      variable Timeout_cnt : integer range 0 to 5_000_000;
      variable LetHeaderPass : boolean;
      --variable Cmd_Header : std_logic_vector(7 downto 0);
   begin
      if RESET = '1' then
         Frame_Counter := 0;
         Destination_Internal := '0';
         Destination_External := '0';
         DATA_VALID <= '0';
         TX_LOAD <= '0';
         FRAME_TYPE <= CMD_40;
         state <= Idle;
         FRAME_ERR <= '0';
         RX_RD_buf <= '0';
         CFG_REQ <= '0';
         STAT_REQ <= '0'; 
         STAT94_REQ <= '0';
         Timeout_cnt := 0;
      elsif rising_edge(CLK) then
         case state is
            ----------------
            -- Idle State --
            ----------------
            when Idle =>
            RX_RD_buf <= '1';
            CFG_REQ <= '0';
            STAT_REQ <= '0';           
            STAT94_REQ <= '0';  
            LetHeaderPass := false;
            if Data_Buf_Valid = '1' then
               state <= Header; 
               RX_RD_buf <= '0';
            end if;
            
            ------------------
            -- Header State --
            ------------------
            when Header =>
            
            -- Default values
            state <= Count;
            TX_LOAD <= '0';
            RX_RD_buf <= '0';
            CFG_REQ <= '0';
            STAT_REQ <= '0';
            STAT94_REQ <= '0';
            
            -- Decide the flow of data, internal, external or both, based on first byte
            if ((Data_Buf = X"60" or Data_Buf = X"43") and INSIDE_CLINK = '1') or (Data_Buf = X"61" and INSIDE_CLINK = '0') then
               Destination_Internal := '1';  
            else                             
               Destination_Internal := '0';  
            end if;
            
            if (Data_Buf = X"61" and INSIDE_CLINK = '1') or (Data_Buf = X"92") or (Data_Buf = X"94") then
               Destination_External := '1';
            else
               Destination_External := '0';
            end if;
            
            -- Take decisions based on first byte
            case Data_Buf is 
               
               when X"40" =>
               Frame_Counter := DPBConfig_array'LENGTH;
               FRAME_TYPE <= CMD_40; 
               
               when X"42" => 
               Frame_Counter := DCUBE_HEADER_V2_size;
               FRAME_TYPE <= CMD_42; 
               -- debug header V3 with command 0x43
               when X"43" => 
               Frame_Counter := DCUBE_HEADER_V3_size;
               FRAME_TYPE <= CMD_43;
               
               when X"50" => 
               Frame_Counter := 1;
               FRAME_TYPE <= CMD_50;               
               
               when X"60" => 
               Frame_Counter := 2;
               FRAME_TYPE <= CMD_60;
               LetHeaderPass := true;
               state <= GetSize;
               
               when X"61" => 
               Frame_Counter := 2;
               FRAME_TYPE <= CMD_61;   
               LetHeaderPass := true;
               state <= GetSize;
               
               when X"92" =>
               STAT_REQ <= '1';
               Frame_Counter := 0; -- no payload
               
               when X"93" | X"95" => -- these 2 commands are equivalent at DPB board level
               CFG_REQ <= '1';
               Frame_Counter := 0; -- no payload 
               
               when X"94" =>
               STAT94_REQ <= '1';
               Frame_Counter := 0; -- no payload
               
               when others =>
               FRAME_ERR <= '1';
               state <= Idle; -- special case    
               
            end case;
            
            -- If need to send data externally, override previous state decisions and wait until RS-232 TX is ready
            if Destination_External = '1' then
               if TX_EMPTY = '1' then
                  --state <= Count; -- Don't override state decision
                  TX_LOAD <= '1';
               else                  
                  TX_LOAD <= '0';
                  state <= Header;
               end if;              
            end if;   
            
            if Destination_Internal = '1' and LetHeaderPass then
               DATA_VALID <= '1';
            end if;
            
            -----------------
            -- GetSize State --
            -----------------
            when GetSize =>
            RX_RD_buf <= '1';
            CFG_REQ <= '0';
            STAT_REQ <= '0';    
            
            if TimeOut = '1' then
               RX_RD_buf <= '0';
               FRAME_ERR <= TimeOut;
               state <= Idle;
            end if;   
            
            if Data_Buf_Valid = '1' then
               state <= Count;
               Frame_Counter := to_integer(unsigned(Data_Buf));
            end if;
            
            if Destination_Internal = '1' then
               DATA_VALID <= Data_Buf_Valid;
            else
               DATA_VALID <= '0';
            end if;           
            
            if Destination_External = '1' then
               TX_LOAD <= Data_Buf_Valid;   
            else
               TX_LOAD <= '0';
            end if;            
            
            -----------------
            -- Count State --
            -----------------
            when Count =>
            RX_RD_buf <= '1';
            CFG_REQ <= '0';
            STAT_REQ <= '0';           
            if TimeOut = '1' or Frame_Counter = 0 then
               RX_RD_buf <= '0';
               FRAME_ERR <= TimeOut;
               state <= Idle;
            elsif Data_Buf_Valid = '1' then
               Frame_Counter := Frame_Counter - 1;
            end if;
            if Destination_Internal = '1' then
               DATA_VALID <= Data_Buf_Valid;
            else
               DATA_VALID <= '0';
            end if;
            if Destination_External = '1' then
               TX_LOAD <= Data_Buf_Valid;   
            else
               TX_LOAD <= '0';
            end if;           
            
            ------------------
            -- Others State --
            ------------------
            when others =>
            state <= Idle;    
            
         end case;
      end if;
   end process;
   
   ----------------------------------
   -- Asynchronous Signal Sampling --
   ----------------------------------
--   Double_Input_Sync : process(RESET,CLK)
--      variable RX_DATA_RDY_buf : std_logic;
--      variable TX_EMPTY_buf : std_logic;
--   begin
--      if (RESET = '1') then
--         RX_DATA_RDY_Sync <= '0';
--         RX_DATA_RDY_buf := '0';
--         TX_EMPTY_Sync <= '1';
--         TX_EMPTY_buf := '0';
--      elsif (rising_edge(CLK)) then
--         RX_DATA_RDY_Sync <= RX_DATA_RDY_buf;
--         RX_DATA_RDY_buf := RX_DATA_RDY;
--         TX_EMPTY_Sync <= TX_EMPTY_buf;
--         TX_EMPTY_buf := TX_EMPTY; 
--      end if;
--   end process;
   
end Behavioral;
