-------------------------------------------------------------------------------
--
-- Title       : LL_SW_3_1_32
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Radiocommunication and Signal Processing Laboratory (LRTS)
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Switch (mux) 3 to 1
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.DPB_Define.ALL;

entity LL_SW_3_1_32 is
   generic(
      SW_ON_EOF_g     : boolean := false
      );    
   port(
      RX0_MOSI : in  t_ll_mosi32;
      RX0_MISO : out t_ll_miso;
      
      RX1_MOSI : in  t_ll_mosi32;
      RX1_MISO : out t_ll_miso;    
      
      RX2_MOSI : in  t_ll_mosi32;
      RX2_MISO : out t_ll_miso;   
      
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso;
      
      SEL         : in  std_logic_vector(1 downto 0);

      ARESET      : in  std_logic;
      CLK         : in  STD_LOGIC     
      );
end LL_SW_3_1_32;


architecture RTL of LL_SW_3_1_32 is

signal Valid_SOF, Valid_EOF : std_logic;
signal RX_MOSI_DVAL_i : std_logic;
signal RX_MOSI_EOF_i : std_logic;
signal RX_MOSI_SOF_i : std_logic;
signal ProcFrame : std_logic;
signal SEL_i     :std_logic_vector(1 downto 0);
signal tx_afull_i : std_logic;
   
begin
   TX_MOSI.SUPPORT_BUSY <= '1';   
   
   SOF_sel : with SEL_i select RX_MOSI_SOF_i <=
   RX0_MOSI.SOF when "00",   
   RX1_MOSI.SOF when "01",  
   RX2_MOSI.SOF when others;  
   TX_MOSI.SOF <= RX_MOSI_SOF_i; 
   
   EOF_sel : with SEL_i select RX_MOSI_EOF_i <=
   RX0_MOSI.EOF when "00",   
   RX1_MOSI.EOF when "01", 
   RX2_MOSI.EOF when others; 
   TX_MOSI.EOF <= RX_MOSI_EOF_i; 
   
   DATA_sel : with SEL_i select TX_MOSI.DATA <= 
   RX0_MOSI.DATA when "00",
   RX1_MOSI.DATA when "01",
   RX2_MOSI.DATA when others;
   
   DREM_sel : with SEL_i select TX_MOSI.DREM <=
   RX0_MOSI.DREM when "00",
   RX1_MOSI.DREM when "01",
   RX2_MOSI.DREM when others;
   
   DVAL_sel : with SEL_i select RX_MOSI_DVAL_i <= 
   RX0_MOSI.DVAL when "00",   
   RX1_MOSI.DVAL when "01",
   RX2_MOSI.DVAL when "10",
   '0' when others;
   TX_MOSI.DVAL <= RX_MOSI_DVAL_i;
   
   RX0_MISO.AFULL <= tx_afull_i;  
   RX1_MISO.AFULL <= tx_afull_i;   
   RX2_MISO.AFULL <= tx_afull_i;   
   
   RX0_MISO.BUSY <= TX_MISO.BUSY when SEL_i = "00" else '1';      
   RX1_MISO.BUSY <= TX_MISO.BUSY when SEL_i = "01" else '1';   
   RX2_MISO.BUSY <= TX_MISO.BUSY when SEL_i = "10" else '1';   
   
   -- pragma translate_off
   assert (RX0_MOSI.SUPPORT_BUSY /= '0') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;               
   assert (RX1_MOSI.SUPPORT_BUSY /= '0') report "RX1 Upstream module must support the BUSY signal" severity FAILURE;               
   assert (RX2_MOSI.SUPPORT_BUSY /= '0') report "RX2 Upstream module must support the BUSY signal" severity FAILURE;               
   -- pragma translate_on         

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
   
   process(CLK)
   begin
      if ARESET = '1' then
         tx_afull_i <= '0';
      elsif rising_edge(CLK) then
         tx_afull_i <= TX_MISO.AFULL;
      end if;
   end process;

end RTL;
