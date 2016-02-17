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
-- Title       : Config_Decoder
-- Design      : VP7
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
use ieee.numeric_std.all; 

use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;

entity Config_Decoder is
   port(   
      KEEP_LOCAL_CFG : in  std_logic;
      RS232_DVAL     : in  STD_LOGIC;
      RS232_DIN      : in  STD_LOGIC_VECTOR(7 downto 0);
      RS232_TYPE     : in  t_RS232;
      FRAME_ERR      : in  std_logic;
      CONFIG_CLINK   : out CLinkConfig;
      --NEW_CONFIG     : out std_logic;           -- JPA (Ajout) 
      RAM_ADD        : out std_logic_vector(8 downto 0);
      RAM_DATA       : out std_logic_vector(15 downto 0);
      RAM_WE         : out std_logic;
      RS232_MODE     : out std_logic_vector(2 downto 0);
      RS232_MODE_CTRL: out std_logic;
      DIAG_ACQ_NUM   : out std_logic_vector(3 downto 0);
      CLK            : in  STD_LOGIC;
      RESET          : in  STD_LOGIC      
      );
end Config_Decoder;

architecture BEH of Config_Decoder is
   type t_state is (Idle, Count);
   signal state : t_state;

   --signal CONFIG_CLINK_reg : CLinkConfig;
   signal CONFIG_CLINK_Array : CLinkConfig_Array8;
   signal CLimit : integer range 0 to 1023;
   signal ValidConfig : boolean;
   
begin
    
   CONFIG_CLINK <= to_CLinkConfig(CONFIG_CLINK_Array, ValidConfig);
   --CONFIG_CLINK.Valid <= ValidConfig;
   
   Decoder : process(RESET,CLK)
      variable FCnt : unsigned(9 downto 0);
      variable RAM_data_buf : std_logic_vector(7 downto 0);
      variable array_index : integer range 1 to 127;
   begin 
      if rising_edge(CLK) then
         if RESET = '1' then
            FCnt := to_unsigned(1,FCnt'LENGTH);
            CLimit <= 0;
            --CLimit <= DCUBE_HEADER_size; -- To circumvent a XST bug that causes CLimit to be optimized out to only 4 bit otherwise
            --NEW_CONFIG <= '1';
            RAM_WE <= '0';
            RAM_ADD <= (others => '0');
            RAM_DATA <= (others => '0');
            RAM_data_buf := (others => '0');
            state <= Idle;
            array_index := 1;
            RS232_MODE_CTRL <= '0';
            DIAG_ACQ_NUM <= (others => '0');
            ValidConfig <= false;
         else
            case state is
               
               -- FristTime State --
--               when FirstTime =>
--                  NEW_CONFIG <= '1';
--                  state <= Idle; 
                  
                  -- Idle State --
               when Idle =>
                  --NEW_CONFIG <= '0';
                  if RS232_DVAL = '1' and FRAME_ERR = '0' then
                     state <= Count;
                     FCnt := FCnt + 1;
                     case RS232_TYPE is 
                        
                        when CMD_43 =>
                           -- header V3
                           CLimit <= DCUBE_HEADER_V3_size;
                           RAM_data_buf := RS232_DIN;    
                           
                        when CMD_60 =>
                           CLimit <= CLinkConfig_Array8'LENGTH;
                           CONFIG_CLINK_Array(1) <= RS232_DIN;
                           ValidConfig <= false;
                           
                        when others =>
                        FCnt := to_unsigned(1,FCnt'LENGTH);
                        state <= Idle; 
                        assert FALSE report "Unknown RS232 frame, ignoring" severity WARNING;
                        
                     end case;                     
                  end if;
                  
                  -- Count State --
               when Count =>
                  if FRAME_ERR = '1' then
                     RAM_WE <= '0';	
                     FCnt := to_unsigned(1,FCnt'LENGTH);
                     state <= Idle;
                  else
                     
                     if FCnt > CLimit then
                        RAM_WE <= '0'; 
                        FCnt := to_unsigned(1,FCnt'LENGTH);
                        --NEW_CONFIG <= '1';
                        --CONFIG_CLINK <= CONFIG_CLINK_reg;
                        if RS232_TYPE = CMD_60 then
                           ValidConfig <= true;
                        end if;
                        state <= Idle;                   
                     elsif RS232_DVAL = '1' then
                        case RS232_TYPE is 
                           
                           when CMD_60 =>
                              if FCnt <= CLinkConfig_Array8'LENGTH and FCnt > 0 then
                                 array_index := to_integer(FCnt);
                                 CONFIG_CLINK_Array(array_index) <= RS232_DIN;
                              end if;    
                              
                           when CMD_43 =>
                              if Fcnt(0) = '0' then
                                 RAM_DATA <= RAM_data_buf & RS232_DIN;
                                 RAM_ADD <= std_logic_vector(FCnt(FCnt'LENGTH-1 downto 1)-1);
                                 RAM_WE <= '1';
                              else
                                 RAM_data_buf := RS232_DIN; 
                                 RAM_WE <= '0'; 
                              end if;
                              
                           when others =>
                           assert FALSE report "Unknown RS232 frame" severity ERROR; 
                           
                        end case;
                        FCnt := FCnt + 1;
                     else
                        RAM_WE <= '0'; 
                     end if;  
                  end if;
                  
                  -- Other States --
               when others =>
               assert FALSE report "Others???" severity FAILURE; 
--               RAM_WE <= '0'; 
--               FCnt := to_unsigned(1,FCnt'LENGTH);
--               state <= Idle;
            end case;
         end if; 
      end if;
   end process;
   
end BEH;
