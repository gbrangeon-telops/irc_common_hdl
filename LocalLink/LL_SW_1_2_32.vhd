-------------------------------------------------------------------------------
--
-- Title       : LL_SW_1_2_32
-- Author      : Patrick Dubois
-- Company     : Telops/COPL/LRTS
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Switch (demux) 1 to 2
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_SW_1_2_32 is 
   generic(
      SW_ON_EOF_g     : boolean := false
      );    
   port(
      RX_MOSI  : in  t_ll_mosi32;
      RX_MISO  : out t_ll_miso;
      
      TX0_MOSI : out t_ll_mosi32;
      TX0_MISO : in  t_ll_miso;
      
      TX1_MOSI : out t_ll_mosi32;
      TX1_MISO : in  t_ll_miso;
      
      SEL         : in  std_logic_vector(1 downto 0);

      ARESET      : in  std_logic;
      CLK         : in  STD_LOGIC     
      );
end LL_SW_1_2_32;


architecture RTL of LL_SW_1_2_32 is 
   
   signal RESET      : std_logic;
   signal RX_BUSYi   : std_logic;
   signal RX_DVALi   : std_logic;
   
   signal Valid_SOF, Valid_EOF : std_logic;
   signal RX_MISO_BUSY_i : std_logic;
   signal ProcFrame : std_logic;
   signal SEL_i     :std_logic_vector(1 downto 0);
     
begin   
   
   TX0_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   TX1_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;    
   
   TX0_MOSI.SOF  <= RX_MOSI.SOF   ;
   TX0_MOSI.EOF  <= RX_MOSI.EOF   ;
   TX0_MOSI.DATA <= RX_MOSI.DATA  ;
   TX0_MOSI.DREM <= RX_MOSI.DREM  ;
   TX1_MOSI.SOF  <= RX_MOSI.SOF   ;
   TX1_MOSI.EOF  <= RX_MOSI.EOF   ;
   TX1_MOSI.DATA <= RX_MOSI.DATA  ;
   TX1_MOSI.DREM <= RX_MOSI.DREM  ;      
              
   TX0_MOSI.DVAL <= RX_MOSI.DVAL when SEL_i = "00" else '0';
   TX1_MOSI.DVAL <= RX_MOSI.DVAL when SEL_i = "01" else '0';
   
   busy_sel : with SEL_i select RX_MISO_BUSY_i <=
   TX0_MISO.BUSY when "00",
   TX1_MISO.BUSY when "01",
   '1' when others;
   
   RX_MISO.BUSY <= RX_MISO_BUSY_i;
   
   afull_sel : with SEL_i select RX_MISO.AFULL <=
   TX0_MISO.AFULL when "00",
   TX1_MISO.AFULL when "01",
   '1' when others;    

   
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
      
      Valid_EOF <= RX_MOSI.DVAL and RX_MOSI.EOF and not(RX_MISO_BUSY_i);
      Valid_SOF <= RX_MOSI.DVAL and RX_MOSI.SOF and not(RX_MISO_BUSY_i);
      
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
