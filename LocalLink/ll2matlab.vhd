---------------------------------------------------------------------------------------------------
--
-- Title       : ll2matlab
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
---------------------------------------------------------------------------------------------------
--
-- Description : LocaLink 21-bit block floating-point to Matlab interface.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library Common_HDL;
use Common_HDL.Telops.all; 

entity ll2matlab is  
   generic(                      
      signed_fi   : BOOLEAN := TRUE;
      TDM_flow    : boolean := FALSE; -- Time Division Multiplexed flow
      Vector_name : string
      --Vector_len  : integer
      );
   port(
      RX_LL_MOSI  : in t_ll_mosi21; 
      RX_LL_MISO  : out t_ll_miso;
      
      STALL_AFULL : in STD_LOGIC;
      STALL_BUSY  : in STD_LOGIC;
      RESET       : in STD_LOGIC;
      CLK         : in STD_LOGIC
      );
end ll2matlab;        

-- Declare these librairies only for the architecture  
library IEEE;
use ieee.numeric_std.all;
library aldec;
use aldec.matlab.all;     

architecture SIM of ll2matlab is   
   shared variable INIT_DONE  : boolean := FALSE;
   shared variable Vector_Id  : integer := 0;
   signal BUSYi               : std_logic;
   signal expon1              : integer;
   signal expon2              : integer;
   constant Vectors_cnt       : integer := 1000;
   signal Toggle              : std_logic;   
   signal SOF_just_arrived    : std_logic;
   constant Vector_len        : integer := 10000;
begin           
   
   RX_LL_MISO.BUSY <= BUSYi;
   
   -------------------------------------------------------
   -- Flow control
   -------------------------------------------------------   
   main : process(CLK)
   begin
      if RESET = '1' then
         Toggle <= '0';
         SOF_just_arrived <= '1';
      elsif rising_edge(CLK) then
         
         if RX_LL_MOSI.DVAL='1' and BUSYi='0' then
            if TDM_flow then
               Toggle <= not Toggle;   
            end if;
            
            -- Exponent extraction
            if RX_LL_MOSI.SOF='1' then
               expon1 <= to_integer(signed(RX_LL_MOSI.DATA(7 downto 0)));      
               SOF_just_arrived <= '1';
            else
               SOF_just_arrived <= '0';
            end if;              
            
            if Toggle='1' and SOF_just_arrived='1' then
               expon2 <= to_integer(signed(RX_LL_MOSI.DATA(7 downto 0)));       
            end if;
            
         end if; 
      end if; 
   end process;   
   
   MATLAB_INIT: process
      variable dim_constr : TDims (1 to 2) := (Vectors_cnt,Vector_len);
   begin     
      if RESET = '1' then
         wait until RESET = '0';
      end if;        
      -- Create array "Vector_name" in the Matlab workspace and get its ID
      Vector_Id := create_array( Vector_name, 2, dim_constr );
      INIT_DONE := true;      
      wait; 
   end process;    
   
   MATLAB_UPDATE: process(CLK)          
      variable Vector_var : std_logic_vector(20 downto 0); 
      variable dim_constr : TDims (1 to 2) := (1,1);      
   begin 
      if RESET = '1' then
         
      elsif rising_edge(CLK) then 
         RX_LL_MISO.AFULL <= STALL_AFULL;
         BUSYi <= STALL_BUSY;
         
         if INIT_DONE and BUSYi='0' and RX_LL_MOSI.DVAL='1' then                        
            
            if RX_LL_MOSI.SOF='0' and not(SOF_just_arrived='1' and TDM_flow) then       
               -- Send one point to the Matlab array
               Vector_var := RX_LL_MOSI.DATA;
               if Toggle='0' then
                  put_item( Vector_var, -expon1, Vector_Id, dim_constr );                                     
               else
                  put_item( Vector_var, -expon2, Vector_Id, dim_constr );      
               end if;               
               
               
               if RX_LL_MOSI.EOF='1' then 
                  put_variable(Vector_name & "_col_len", dim_constr(1));
                  put_variable(Vector_name & "_row_len", dim_constr(2));
                  hdl2ml(Vector_Id); 
                  
                  dim_constr(2) := 0;
                  if dim_constr(1) < Vectors_cnt then 
                     dim_constr(1) := dim_constr(1) + 1;                  
                  else
                     dim_constr(1) := 1;
                  end if;               
               end if;                                             
               
               if dim_constr(2) < Vector_len then 
                  dim_constr(2) := dim_constr(2) + 1;                  
               else
                  dim_constr(2) := 1;                   
               end if;                            
               
            end if;                 
            
         end if;              
      end if;      
   end process;   
   
   
end SIM;
