-------------------------------------------------------------------------------
--
-- Title       : LL_SW_1_3_21
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Radiocommunication and Signal Processing Laboratory (LRTS)
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

entity LL_SW_1_3_21 is
--   generic(
--      Latency     : integer := 5;  -- Input module latency (to control RX_AFULL)
--      use_fifos   : boolean := FALSE
--      );   
   port(
      RX_MOSI  : in  t_ll_mosi21;
      RX_MISO  : out t_ll_miso;
      
      TX0_MOSI : out t_ll_mosi21;
      TX0_MISO : in  t_ll_miso;
      
      TX1_MOSI : out t_ll_mosi21;
      TX1_MISO : in  t_ll_miso;
      
      TX2_MOSI : out t_ll_mosi21;
      TX2_MISO : in  t_ll_miso;      
      
      --WR_ERR      : out std_logic;
      SEL         : in  std_logic_vector(1 downto 0)
      --EMPTY       : out std_logic;
      
      --ARESET      : in  std_logic;
      --CLK         : in  STD_LOGIC       
      );
end LL_SW_1_3_21;


architecture RTL of LL_SW_1_3_21 is 
   
--   signal TX_LL_MOSI : t_ll_mosi21;
--   signal TX_LL_MISO : t_ll_miso;
--   
--   signal RESET      : std_logic;
--   
--   component locallink_fifo21
--      generic(
--         FifoSize : INTEGER := 63;
--         Latency : INTEGER := 32;
--         ASYNC : BOOLEAN := true);
--      port(
--         RX_LL_MOSI : in t_ll_mosi21;
--         RX_LL_MISO : out t_ll_miso;
--         CLK_RX : in std_logic;
--         FULL : out std_logic;
--         WR_ERR : out std_logic;
--         TX_LL_MOSI : out t_ll_mosi21;
--         TX_LL_MISO : in t_ll_miso;
--         CLK_TX : in std_logic;
--         EMPTY : out std_logic;
--         ARESET : in std_logic);
--   end component;
   
begin        
   
   TX0_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   TX1_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;  
   TX2_MOSI.SUPPORT_BUSY <= RX_MOSI.SUPPORT_BUSY;
   
   TX0_MOSI.SOF  <= RX_MOSI.SOF   ;
   TX0_MOSI.EOF  <= RX_MOSI.EOF   ;
   TX0_MOSI.DATA <= RX_MOSI.DATA  ;
   TX1_MOSI.SOF  <= RX_MOSI.SOF   ;
   TX1_MOSI.EOF  <= RX_MOSI.EOF   ;
   TX1_MOSI.DATA <= RX_MOSI.DATA  ;  
   TX2_MOSI.SOF  <= RX_MOSI.SOF   ;
   TX2_MOSI.EOF  <= RX_MOSI.EOF   ;
   TX2_MOSI.DATA <= RX_MOSI.DATA  ;   
              
   TX0_MOSI.DVAL <= RX_MOSI.DVAL when SEL = "00" else '0';
   TX1_MOSI.DVAL <= RX_MOSI.DVAL when SEL = "01" else '0';
   TX2_MOSI.DVAL <= RX_MOSI.DVAL when SEL = "10" else '0';      
   
   busy_sel : with SEL select RX_MISO.BUSY <=
   TX0_MISO.BUSY when "00",
   TX1_MISO.BUSY when "01",
   TX2_MISO.BUSY when "10",
   '1' when others;
   
   afull_sel : with SEL select RX_MISO.AFULL <=
   TX0_MISO.AFULL when "00",
   TX1_MISO.AFULL when "01",
   TX2_MISO.AFULL when "10",
   '1' when others;    
   
   
--   sync_rst : entity sync_reset
--   port map(ARESET => ARESET, SRESET => RESET, clk => CLK); 
--   
--   fifos : if use_fifos generate
--      
--      TX0_LL_MOSI.SUPPORT_BUSY <= '1';      
--      TX0_LL_MOSI.SOF  <= TX_LL_MOSI.SOF   ;
--      TX0_LL_MOSI.EOF  <= TX_LL_MOSI.EOF   ;
--      TX0_LL_MOSI.DATA <= TX_LL_MOSI.DATA  ; 
--      
--      TX1_LL_MOSI.SUPPORT_BUSY <= '1';
--      TX1_LL_MOSI.SOF  <= TX_LL_MOSI.SOF   ;
--      TX1_LL_MOSI.EOF  <= TX_LL_MOSI.EOF   ;
--      TX1_LL_MOSI.DATA <= TX_LL_MOSI.DATA  ;      
--      
--      TX2_LL_MOSI.SUPPORT_BUSY <= '1';
--      TX2_LL_MOSI.SOF  <= TX_LL_MOSI.SOF   ;
--      TX2_LL_MOSI.EOF  <= TX_LL_MOSI.EOF   ;
--      TX2_LL_MOSI.DATA <= TX_LL_MOSI.DATA  ;     
--      
--      
--      -- We put muxes at the output for DVAL, so DVAL is NOT registered. 
--      -- If this causes timing issues, one could put 2 fifos instead, one for each output.
--      -- That way, outputs would all be registered but it would consume more resources.               
--      TX0_LL_MOSI.DVAL <= TX_LL_MOSI.DVAL when SEL = "00" else '0';
--      TX1_LL_MOSI.DVAL <= TX_LL_MOSI.DVAL when SEL = "01" else '0';
--      TX2_LL_MOSI.DVAL <= TX_LL_MOSI.DVAL when SEL = "10" else '0';
--      
--      busy_sel : with SEL select TX_LL_MISO.BUSY <=
--      TX0_LL_MISO.BUSY when "00",
--      TX1_LL_MISO.BUSY when "01",
--      TX2_LL_MISO.BUSY when "10",   
--      '1' when others;
--      
--      afull_sel : with SEL select TX_LL_MISO.AFULL <=
--      TX0_LL_MISO.AFULL when "00",
--      TX1_LL_MISO.AFULL when "01",
--      TX2_LL_MISO.AFULL when "10",   
--      '1' when others;  
--      
--      fifo : LocalLink_Fifo21
--      generic map(
--         FifoSize => 16,
--         Latency => Latency,
--         ASYNC => FALSE
--         )
--      port map(
--         RX_LL_MOSI => RX_LL_MOSI,
--         RX_LL_MISO => RX_LL_MISO,
--         CLK_RX => CLK,
--         FULL => open,
--         WR_ERR => WR_ERR,
--         TX_LL_MOSI => TX_LL_MOSI,
--         TX_LL_MISO => TX_LL_MISO,
--         CLK_TX => CLK,
--         EMPTY => EMPTY,
--         ARESET => RESET
--         );             
--      
--   end generate fifos;
   
   
end RTL;
