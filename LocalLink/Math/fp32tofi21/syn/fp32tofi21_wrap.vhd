---------------------------------------------------------------------------------------------------
--
-- Title       : fp32tofi21_wrap
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
---------------------------------------------------------------------------------------------------
--
-- Description : This is the wrapper to be used by the end user. Its ports are records.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.Telops.all; 

entity fp32tofi21_wrap is
   port(        
      EXTRA_EXPON : in  std_logic_vector(7 downto 0);
      EXPON1      : in  std_logic_vector(7 downto 0);
      EXPON2      : in  std_logic_vector(7 downto 0); -- 2nd exponent used for TDM flow
      
      SIGNED_FI   : in  std_logic;
      TDM_FLOW    : in  std_logic;
      FORCE_16BIT : in  std_logic;
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      
      RX_LL_MOSI  : in  t_ll_mosi32;
      RX_LL_MISO  : out t_ll_miso;
      
      TX_LL_MOSI  : out t_ll_mosi21;
      TX_LL_MISO  : in  t_ll_miso;   
      
      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC		 		 		 
      );
end fp32tofi21_wrap;     


architecture MAPPED of fp32tofi21_wrap is 

   signal RX_LL_MOSI_slv : std_logic_vector(35 downto 0);
   signal RX_LL_MISO_slv : std_logic_vector(1 downto 0);
   signal TX_LL_MOSI_slv : std_logic_vector(24 downto 0);
   signal TX_LL_MISO_slv : std_logic_vector(1 downto 0);   

   component fp32tofi21_syn
      port(        
         EXTRA_EXPON : in  std_logic_vector(7 downto 0);
         EXPON1      : in  std_logic_vector(7 downto 0);
         EXPON2      : in  std_logic_vector(7 downto 0); -- 2nd exponent used for TDM flow
         
         SIGNED_FI   : in  std_logic;
         TDM_FLOW    : in  std_logic;
         FORCE_16BIT : in  std_logic;
         AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
         
         RX_LL_MOSI_slv : in std_logic_vector (35 downto 0);
         RX_LL_MISO_slv : out std_logic_vector (1 downto 0);
         
         TX_LL_MOSI_slv : out std_logic_vector (24 downto 0);
         TX_LL_MISO_slv : in std_logic_vector (1 downto 0);        
              
         OVERFLOW    : out std_logic;
         UNDERFLOW   : out std_logic;
         
         ARESET      : in  STD_LOGIC;
         CLK         : in  STD_LOGIC		 		 		 
         );
   end component; 
   
begin            

   RX_LL_MISO.AFULL <= RX_LL_MISO_slv(1);
   RX_LL_MISO.BUSY <= RX_LL_MISO_slv(0);
   
   RX_LL_MOSI_slv <= RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA & RX_LL_MOSI.DVAL & RX_LL_MOSI.SUPPORT_BUSY;
   
   
   TX_LL_MISO_slv <= TX_LL_MISO.AFULL & TX_LL_MISO.BUSY;
   
   TX_LL_MOSI.SOF <= TX_LL_MOSI_slv(24);
   TX_LL_MOSI.EOF <= TX_LL_MOSI_slv(23);
   TX_LL_MOSI.DATA <= TX_LL_MOSI_slv(22 downto 2);
   TX_LL_MOSI.DVAL <= TX_LL_MOSI_slv(1);
   TX_LL_MOSI.SUPPORT_BUSY <= TX_LL_MOSI_slv(0);                      
 
   U1 : fp32tofi21_syn
   port map(
      EXTRA_EXPON => EXTRA_EXPON,
      EXPON1 => EXPON1,
      EXPON2 => EXPON2,
      SIGNED_FI => SIGNED_FI,
      TDM_FLOW => TDM_FLOW,
      FORCE_16BIT => FORCE_16BIT,
      AVOID_ZERO => AVOID_ZERO,
      RX_LL_MOSI_slv => RX_LL_MOSI_slv,
      RX_LL_MISO_slv => RX_LL_MISO_slv,
      TX_LL_MOSI_slv => TX_LL_MOSI_slv,
      TX_LL_MISO_slv => TX_LL_MISO_slv,
      OVERFLOW => OVERFLOW,
      UNDERFLOW => UNDERFLOW,
      ARESET => ARESET,
      CLK => CLK
   );    
   
end MAPPED;
