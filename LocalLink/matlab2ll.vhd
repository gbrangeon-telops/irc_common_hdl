-------------------------------------------------------------------------------
--
-- Title       : matlab2ll
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--
-- Description : This module sends a Matlab vector to the LocalLink output 
--               (in 21-bit block floating point format).
--               The testbench must initialize the Matlab worspace.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all; 
library Common_HDL;
use Common_HDL.Telops.all;

entity matlab2ll is
   generic(
      vector_name : string
      );
   port(                   
      TX_LL_MOSI  : out t_ll_mosi21;
      TX_LL_MISO  : in  t_ll_miso;    
      STALL       : in STD_LOGIC; -- This is to introduce "stalling" or pause in the dataflow.
      RESET       : in std_logic; -- The module won't attempt to load the Matlab variable until RESET is deasserted.
      CLK         : in STD_LOGIC
      );
end matlab2ll;

-- Declare these librairies only for the architecture
library aldec;
use aldec.matlab.all;   


architecture SIM of matlab2ll is
   shared variable INIT_DONE : boolean := FALSE;
   shared variable Vector_Id : integer := 0;
   shared variable Vector_len : integer;
begin          
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   
   MATLAB_INIT: process     
   begin     
      if RESET = '1' then
         wait until RESET = '0';
      end if;
      Vector_Id := ml2hdl( vector_name ); 
      Vector_len := get_dim(Vector_Id,2);
      INIT_DONE := true;      
      wait; 
   end process;      
   
   MATLAB_UPDATE: process(CLK)          
      variable Vector_var : std_logic_vector(20 downto 0); 
      variable dim_constr : TDims (1 to 2) := (1,1);      
   begin 
      if RESET = '1' then
         TX_LL_MOSI.DVAL <= '0';      
      elsif rising_edge(CLK) and TX_LL_MISO.BUSY = '0' then -- BUSY acts as clock-enable
         
         if INIT_DONE and TX_LL_MISO.AFULL = '0' and STALL = '0' then
            get_item( Vector_var, 0, Vector_Id, dim_constr );
            TX_LL_MOSI.DATA <= Vector_var;
            TX_LL_MOSI.DVAL <= '1';  
            
            if dim_constr(2) = 1 then
               TX_LL_MOSI.SOF <= '1';
            else
               TX_LL_MOSI.SOF <= '0';
            end if;   
            
            if dim_constr(2) = Vector_len then
               TX_LL_MOSI.EOF <= '1';              
               dim_constr(2) := 1; 
            else
               TX_LL_MOSI.EOF <= '0';
               dim_constr(2) := dim_constr(2) + 1; 
            end if;    
                        
         else
            TX_LL_MOSI.DVAL <= '0';  
         end if;                                          
         
      end if;  
   end process;   
   
end SIM;
