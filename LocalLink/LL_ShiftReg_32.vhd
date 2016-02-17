-------------------------------------------------------------------------------
--
-- Title       : LL_ShiftReg_32
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Shift Register
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_ShiftReg_32 is 
   generic(
      DEPTH       : in  integer := 1;   -- Depth of the Shift Register
      TAP_INDEX   : in  integer := 1
      );
   port(
      RX_MOSI  : in  t_ll_mosi32; 
      RX_MISO  : out t_ll_miso; 
      
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso;
      
      TAP      : out std_logic_vector(31 downto 0);
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end LL_ShiftReg_32;

architecture RTL of LL_ShiftReg_32 is
   signal RX_BUSYi : std_logic;
   
   type t_ll_array_32 is array(0 to DEPTH-1) of t_ll_mosi32;
   
   signal ll_data_reg : t_ll_array_32;
   signal tx_afull_reg : std_logic;
   
begin     
   
   RX_BUSYi <= TX_MISO.BUSY or tx_afull_reg;
   RX_MISO.BUSY <= RX_BUSYi;          
   RX_MISO.AFULL <= tx_afull_reg;  
   
   TX_MOSI.SUPPORT_BUSY <= '1';   
   TX_MOSI.SOF <= ll_data_reg(DEPTH-1).SOF;      
   TX_MOSI.EOF <= ll_data_reg(DEPTH-1).EOF;      
   TX_MOSI.DATA <= ll_data_reg(DEPTH-1).DATA;      
   TX_MOSI.DREM <= ll_data_reg(DEPTH-1).DREM;  
   TX_MOSI.DVAL <= ll_data_reg(DEPTH-1).DVAL;
   
   TAP <= ll_data_reg(TAP_INDEX).DATA;
   
   process(CLK, ARESET)      
   begin
      if rising_edge(CLK) then  
         tx_afull_reg <= TX_MISO.AFULL;
         
         if DEPTH = 1 then
            if RX_BUSYi = '0' then
               ll_data_reg(0) <= RX_MOSI;
            end if;             
         else
            if RX_BUSYi = '0' then
               ll_data_reg(1 to DEPTH-1) <= ll_data_reg(0 to DEPTH-2); 
               ll_data_reg(0) <= RX_MOSI;
            end if;          
         end if;
         
         
         if ARESET = '1' then
            -- translate_off
            assert (RX_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;                                    
            -- translate_on   
         end if;         
         
      end if;             
      
      if ARESET = '1' then   
         reset_loop : for n in 0 to DEPTH-1 loop
            ll_data_reg(n).DVAL <= '0';
         end loop;         
      end if;
      
   end process;       
   
end RTL;
