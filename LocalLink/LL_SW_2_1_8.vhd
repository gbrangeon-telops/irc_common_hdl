-------------------------------------------------------------------------------
--
-- Title       : LL_SW_2_1_8
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

entity LL_SW_2_1_8 is
    port(
        RX0_MOSI : in  t_ll_mosi8;
        RX0_MISO : out t_ll_miso;
        
        RX1_MOSI : in  t_ll_mosi8;
        RX1_MISO : out t_ll_miso;
        
        TX_MOSI  : out t_ll_mosi8;
        TX_MISO  : in  t_ll_miso;
        
        SEL      : in  std_logic_vector(1 downto 0)
        
        --      ARESET      : in  std_logic;
        --      CLK         : in  STD_LOGIC
        );
end LL_SW_2_1_8;


architecture RTL of LL_SW_2_1_8 is
    
begin    
    
    TX_MOSI.SUPPORT_BUSY <= '1';   
    
    SOF_sel : with SEL(0) select TX_MOSI.SOF <=
    RX0_MOSI.SOF when '0',   
    RX1_MOSI.SOF when others;  
    
    EOF_sel : with SEL(0) select TX_MOSI.EOF <=
    RX0_MOSI.EOF when '0',   
    RX1_MOSI.EOF when others; 
    
    DATA_sel : with SEL(0) select TX_MOSI.DATA <= 
    RX0_MOSI.DATA when '0',
    RX1_MOSI.DATA when others;
    
    --DREM_sel : with SEL(0) select TX_MOSI.DREM <=
    --RX0_MOSI.DREM when '0',
    --RX1_MOSI.DREM when others;
    
    DVAL_sel : with SEL select TX_MOSI.DVAL <= 
    RX0_MOSI.DVAL when "00",   
    RX1_MOSI.DVAL when "01",
    '0' when others;

    RX0_MISO.AFULL <= TX_MISO.AFULL;  
    RX1_MISO.AFULL <= TX_MISO.AFULL;   
    
    RX0_MISO.BUSY <= TX_MISO.BUSY when SEL = "00" else '1';      
    RX1_MISO.BUSY <= TX_MISO.BUSY when SEL = "01" else '1';   
    
    -- pragma translate_off
    assert (RX0_MOSI.SUPPORT_BUSY /= '0') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;               
    assert (RX1_MOSI.SUPPORT_BUSY /= '0') report "RX1 Upstream module must support the BUSY signal" severity FAILURE;               
    -- pragma translate_on         
    
end RTL;
