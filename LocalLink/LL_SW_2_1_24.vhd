-------------------------------------------------------------------------------
--
-- Title       : LL_SW_2_1_24
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Switch (mux) 2 to 1
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_SW_2_1_24 is
   generic(
      SW_ON_EOF_g     : boolean := false
      );   
   port(
      RX0_MOSI : in  t_ll_mosi24;
      RX0_MISO : out t_ll_miso;
      
      RX1_MOSI : in  t_ll_mosi24;
      RX1_MISO : out t_ll_miso;
      
      TX_MOSI  : out t_ll_mosi24;
      TX_MISO  : in  t_ll_miso;
      
      SEL      : in  std_logic_vector(1 downto 0);
      
      ARESET      : in  std_logic;
      CLK         : in  STD_LOGIC
      );
end LL_SW_2_1_24;


architecture RTL of LL_SW_2_1_24 is

signal Valid_SOF, Valid_EOF : std_logic;
signal RX_MOSI_DVAL_i : std_logic;
signal RX_MOSI_EOF_i : std_logic;
signal RX_MOSI_SOF_i : std_logic;
signal ProcFrame : std_logic;
signal SEL_i     :std_logic_vector(1 downto 0);

begin    
   
   TX_MOSI.SUPPORT_BUSY <= '1';   
   
   SOF_sel : with SEL_i(0) select RX_MOSI_SOF_i <=
   RX0_MOSI.SOF when '0',   
   RX1_MOSI.SOF when others;  
   TX_MOSI.SOF <= RX_MOSI_SOF_i;

   EOF_sel : with SEL_i(0) select RX_MOSI_EOF_i <=
   RX0_MOSI.EOF when '0',   
   RX1_MOSI.EOF when others; 
   TX_MOSI.EOF <= RX_MOSI_EOF_i;
     
   DATA_sel : with SEL_i(0) select TX_MOSI.DATA <= 
   RX0_MOSI.DATA when '0',
   RX1_MOSI.DATA when others;
      
   DVAL_sel : with SEL_i select RX_MOSI_DVAL_i <= 
   RX0_MOSI.DVAL when "00",   
   RX1_MOSI.DVAL when "01",
   '0'              when others;
   TX_MOSI.DVAL <= RX_MOSI_DVAL_i; 
  
   RX0_MISO.AFULL <= TX_MISO.AFULL;  
   RX1_MISO.AFULL <= TX_MISO.AFULL;   
   
   RX0_MISO.BUSY <= TX_MISO.BUSY when SEL_i = "00" else '1';         
   RX1_MISO.BUSY <= TX_MISO.BUSY when SEL_i = "01" else '1';
      
   ----------------------------------------------------------
   -- The classic switch
   ----------------------------------------------------------
   OrdinarySwitch: IF SW_ON_EOF_g = FALSE GENERATE
      SEL_i <= SEL; -- No change
   END GENERATE OrdinarySwitch;
   
   ----------------------------------------------------------
   -- The SEL input port is evaluated only on a valid EOF:
   -- we wait for the current frame to end before accepting 
   -- a change on SEL control port.
   ----------------------------------------------------------
   SwitchOnEOF: IF SW_ON_EOF_g = TRUE GENERATE
      
      Valid_EOF <= RX_MOSI_DVAL_i and RX_MOSI_EOF_i and not(TX_MISO.BUSY);
      Valid_SOF <= RX_MOSI_DVAL_i and RX_MOSI_SOF_i and not(TX_MISO.BUSY);
      
      -- Process to ceate ProcFrame signal
      process(CLK, ARESET)
      begin
         if ARESET = '1' then
            ProcFrame <= '0';
         elsif rising_edge(CLK) then
         
            if Valid_SOF = '1' then
               ProcFrame <= '1';
            end if;   
            
            if Valid_EOF = '1' then
               ProcFrame <= '0';
            end if;   
            
         end if;
      end process;            
      
      -- Process to control SEL_i
      process(CLK, ARESET)
      begin
         if ARESET = '1' then            
            SEL_i <= "11"; -- Busy at reset                           
         elsif rising_edge(CLK) then
                     
            if (Valid_SOF = '0' and (ProcFrame = '0' or Valid_EOF = '1')) then
               SEL_i <= SEL;
            end if;            
            
         end if;
      end process;   
            
   END GENERATE SwitchOnEOF;   
   
end RTL;
