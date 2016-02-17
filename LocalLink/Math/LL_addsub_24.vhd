-------------------------------------------------------------------------------
--
-- Title       : LL_addsub_24
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : WARNING: The carry bit is dropped.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use ieee.numeric_std.all;

library Common_HDL; 
use Common_HDL.all;
use Common_HDL.Telops.all;

entity LL_addsub_24 is
   generic(
      SOF_EOF_Mode : natural := 0; -- 0: SOF_EOF taken from A, 1: SOF_EOF taken from B, 2, SOF from A, EOF from B    
      OP       : in std_logic := '0'); -- 0: Add, 1: Sub
   port(
      A_MOSI   : in  t_ll_mosi24;
      A_MISO   : out t_ll_miso;
      
      B_MOSI   : in  t_ll_mosi24;
      B_MISO   : out t_ll_miso;      
      
      RES_MOSI : out t_ll_mosi24;
      RES_MISO : in  t_ll_miso;
      
      SYNC_ERR : out std_logic; -- EOF/SOF from A & B sync error
      
      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC		
      );
end LL_addsub_24;


architecture RTL of LL_addsub_24 is
      
   signal sync_busy  : std_logic;
   signal sync_dval  : std_logic;   
   
   signal break_mosi : t_ll_mosi24;
   signal break_miso : t_ll_miso;
   
   signal addsub_ce : std_logic;
     
   
begin                                         
   
   sync_A_B : entity ll_sync_flow
   port map(
      RX0_DVAL => A_MOSI.DVAL,
      RX0_BUSY => A_MISO.BUSY,
      RX0_AFULL => A_MISO.AFULL,
      RX1_DVAL => B_MOSI.DVAL,
      RX1_BUSY => B_MISO.BUSY,
      RX1_AFULL => B_MISO.AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => sync_dval
      ); 
   sync_busy <= break_MISO.BUSY;   
   
   -- AddSub CE
   addsub_ce <= (not break_MISO.AFULL) and (not break_MISO.BUSY); 
      
   -- SOF/EOF A & B sync error
   SYNC_ERR <= sync_dval and ((A_MOSI.SOF xor B_MOSI.SOF) or (A_MOSI.EOF xor B_MOSI.EOF));
   
   -- SOF EOF management
   SOF_EOF_0 : if (SOF_EOF_Mode = 0) generate
      break_MOSI.SOF <= A_MOSI.SOF;
      break_MOSI.EOF <= A_MOSI.EOF; 
   end generate SOF_EOF_0;
   
   SOF_EOF_1 : if (SOF_EOF_Mode = 1) generate
      break_MOSI.SOF <= B_MOSI.SOF;
      break_MOSI.EOF <= B_MOSI.EOF; 
   end generate SOF_EOF_1;
   
   SOF_EOF_2 : if (SOF_EOF_Mode = 2) generate
      break_MOSI.SOF <= A_MOSI.SOF;
      break_MOSI.EOF <= B_MOSI.EOF; 
   end generate SOF_EOF_2;
        
   gen_add : if (OP = '0') generate
      break_MOSI.DATA <= std_logic_vector(unsigned(A_MOSI.DATA) + unsigned(B_MOSI.DATA));   
   end generate;  
      
   gen_sub : if (OP = '1') generate
      break_MOSI.DATA <= std_logic_vector(unsigned(A_MOSI.DATA) - unsigned(B_MOSI.DATA));
   end generate;   

   break_MOSI.DVAL <= sync_dval; 
   break_MOSI.SUPPORT_BUSY <= '1';
   
   -- Provide output registers
   reg : entity ll_busybreak_24
   port map(
      RX_MOSI => break_mosi,
      RX_MISO => break_miso,
      TX_MOSI => RES_MOSI,
      TX_MISO => RES_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   
   
end RTL;
