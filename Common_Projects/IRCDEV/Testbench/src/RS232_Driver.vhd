---------------------------------------------------------------------------------------------------
--
-- Title       : RS232_Driver
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--
-- Description : This module sends RS232 config(of type RS232_TYPE) when SEND_CONFIG is asserted.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;     

library Common_HDL;
use Common_HDL.Telops.all;
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;

entity RS232_Driver is
   port(
      --------------------------------
      -- TX UART INTERFACE
      --------------------------------		
      TX_AFULL 		: in 	STD_LOGIC;
      TX_LOAD 			: out STD_LOGIC;
      TX_DOUT 			: out STD_LOGIC_VECTOR(7 downto 0);		 
      TX_EMPTY			: in	std_logic;
      
      --------------------------------
      -- RX UART INTERFACE
      --------------------------------		
      RX_EN     		: out	STD_LOGIC;
      RX_DATA 			: in STD_LOGIC_VECTOR(7 downto 0);		 
      RX_DVAL 			: in std_logic;		
      
      --------------------------------
      -- USER INTERFACE
      --------------------------------			
      CLINK_CONFIG   : in  CLinkConfig;
      PROC_CONFIG 	: in  DPConfig;    
      MISSING_IMAGES : in  integer;
      HEADER43       : in  DCUBE_HEADER_array; 
      HEADER44       : in  DCUBE_Header_part1_array8_v4;
      SEND_CONFIG 	: in 	std_logic;
      RS232_TYPE 		: in 	t_RS232;
      DONE				: out std_logic;	
      RS232_MODE		: in  std_logic_vector(2 downto 0);
      DIAG_ACQ_NUM   : in  std_logic_vector(3 downto 0); 
      MODE_INPUT_SEL : in  std_logic;  
      
      QUERY_94       : in  std_logic;
      VP30_DONE      : out std_logic;
      --------------------------------
      -- MISC
      --------------------------------	
      CLK 				: in 	STD_LOGIC;
      RESET 			: in 	STD_LOGIC		
      );
end RS232_Driver;

architecture BEH of RS232_Driver is
   type t_state is (Idle, Init, Send_Data, Process94);
   signal state : t_state;
   
   --signal Config : DPBConfig; -- := DPBConfig_default;
   --signal Frame : DPBConfig_array;	
   signal Frame60 : CLinkConfig_array8;	
   signal Frame61 : DPConfig_array8;	
   
   --signal header : DCUBE_HEADER_array;
   
   type A94 is array(1 to 18) of std_logic_vector(7 downto 0);
   
begin 									
   
   --Frame <= to_DPBConfig_array(CONFIG_PARAM);
   Frame60 <= to_CLinkConfig_array8(CLINK_CONFIG);
   Frame61 <= to_DPConfig_array8(PROC_CONFIG, MISSING_IMAGES);
   
   main_process : process (CLK, RESET)	
      variable i : integer;    
      variable Cmd94_ary : A94;   
      variable limit : integer;
   begin
      if RESET = '1' then 
         i := 0;
         --MODE <= "000";
         state <= Idle;
         --header <= DCUBE_HEADER_array_default;
         TX_LOAD <= '0';
         TX_DOUT <= (others => '0');			  
         DONE <= '0'; 
         VP30_DONE <= '0';
         RX_EN <= '0';
      elsif rising_edge(CLK) then
         
         case state is
            
            when Idle =>
               TX_LOAD <= '0';
               i := 0;   
               
               if TX_EMPTY = '1' then
                  DONE <= '1';
                  if SEND_CONFIG = '1' then                     
                     DONE <= '0';
                     state <= Init;
                  elsif QUERY_94 = '1' then
                     DONE <= '0';
                     state <= Init;                     
                  end if;
               else
                  DONE <= '0';
               end if;
               
               -- Idle State --
            when Init =>
               TX_LOAD <= '0';
               if QUERY_94 = '1' then
                  if TX_AFULL = '0' then
                     TX_LOAD <= '1';
                     TX_DOUT <= X"94";  
                     i := 1;
                     state <= Process94;
                  end if;  
                  
               else
                  case RS232_TYPE is                     
                     
                     when CMD_43 =>
                        limit := DCUBE_HEADER_V3_size;
                        state <= Send_Data;
                        
                     when CMD_44 =>
                        limit := DCUBE_part1_V4_size;
                        state <= Send_Data;                        
                        
                     when CMD_50 =>
                        limit := 1;
                        state <= Send_Data;
                        
                     when CMD_60 =>
                        limit := CLinkConfig_array8'length;              
                        state <= Send_Data;
                        
                     when CMD_61 =>
                        limit := DPConfig_array8'length;
                        state <= Send_Data;
                        
                     when CMD_92 =>
                        if TX_AFULL = '0' then
                           TX_LOAD <= '1';
                           TX_DOUT <= X"92";
                           state <= Idle;
                        end if;	
                        
                     when CMD_93 =>
                        if TX_AFULL = '0' then
                           TX_LOAD <= '1';
                           TX_DOUT <= X"93";
                           state <= Idle;
                        end if;
                        
                     when CMD_94 =>
                        if TX_AFULL = '0' then
                           TX_LOAD <= '1';
                           TX_DOUT <= X"94";
                           state <= Idle;
                        end if;       
                        
                     when others =>
                     assert FALSE report "Unsupported RS-232 command." severity ERROR;
                     
                  end case;	
               end if; 
               
            when Process94 => 
               TX_LOAD <= '0'; 
               RX_EN <= '1';
               
               if i <= Cmd94_ary'LENGTH then
                  if RX_DVAL = '1' then
                     Cmd94_ary(i) := RX_DATA;
                     i := i + 1;
                  end if;
               else             
                  if Cmd94_ary(4)(2) = '1' and Cmd94_ary(10)(2) = '1' then
                     VP30_DONE <= '1';
                  else                
                     VP30_DONE <= '0';
                  end if;
                  RX_EN <= '0';
                  state <= Idle;   
                  DONE <= '1';
               end if;
               
               
               -- ShiftOut State --
            when Send_Data =>  
               TX_LOAD <= '0';   -- Default
               if i > limit then
                  state <= Idle;
               else
                  if TX_AFULL = '0' then          
                     TX_LOAD <= '1';
                     if i = 0 then
                        case RS232_TYPE is
                           when CMD_43 =>
                           TX_DOUT <= X"43";                  
                           when CMD_44 =>
                              TX_DOUT <= X"44";                             
                           when CMD_50 =>
                              TX_DOUT <= X"50";
                           when CMD_60 =>						
                              TX_LOAD <= '0'; -- Already in the array
                           when CMD_61 =>						
                              TX_LOAD <= '0'; -- Already in the array
                           when others =>
                           TX_DOUT <= (others => 'X');
                        end case;
                     else
                        case RS232_TYPE is
                           when CMD_43 =>
                           TX_DOUT <= HEADER43(i);                  
                           when CMD_44 =>                             
                           TX_DOUT <= HEADER44(i);                           
                           --TX_DOUT <= std_logic_vector(to_unsigned(i, 8)); 
                           when CMD_50 =>
                              TX_DOUT <= MODE_INPUT_SEL & Uto0(DIAG_ACQ_NUM) & RS232_MODE;	
                           when CMD_60 =>
                              TX_DOUT <= Frame60(i);
                           when CMD_61 =>
                              TX_DOUT <= Frame61(i);
                           when others =>
                           TX_DOUT <= (others => 'X');
                        end case;					
                     end if;
                     i := i + 1;  
                  end if;              
                  
               end if;
               --state <= Wait_State;
               
--            when Wait_State =>
--               TX_LOAD <= '0';
--               state <= Wait_For_Ready;                
               
               -- Others State --
            when others =>
            state <= Idle;
         end case;
      end if;
   end process;
   
end BEH;
