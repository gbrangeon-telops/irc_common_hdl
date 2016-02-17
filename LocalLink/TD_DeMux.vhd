-------------------------------------------------------------------------------
--
-- Title       : TD_DeMux
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : Time Division Demultiplexer. 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity TD_DeMux is
   port(
      RX_MOSI  : in  t_ll_mosi32; 
      RX_MISO  : out t_ll_miso; 
      
      TX1_MOSI : out t_ll_mosi32;
      TX1_MISO : in  t_ll_miso;
      
      TX2_MOSI : out t_ll_mosi32;
      TX2_MISO : in  t_ll_miso;  
      
      EN       : in  std_logic; -- Enable Time Division Multiplexing. When disabled, all data goes out on the TX1 port.
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end TD_DeMux;

architecture RTL of TD_DeMux is
   signal Sel : std_logic;
   signal TX1_BUSYi : std_logic;
   signal TX2_BUSYi : std_logic;
   signal TX1_DVALi : std_logic;
   signal TX2_DVALi : std_logic;
   signal TX1_SOFi  : std_logic;
   signal TX1_EOFi  : std_logic;
   signal TX2_SOFi  : std_logic;
   signal TX2_EOFi  : std_logic;     
   
   signal sr_mosi : t_ll_mosi32;
   signal sr_miso : t_ll_miso;
   
begin                                                          
   
   SR : entity ll_shiftreg_32
   generic map(
      DEPTH => 1,
      TAP_INDEX => 0
      )
   port map(
      RX_MOSI => RX_MOSI,
      RX_MISO => RX_MISO,
      TX_MOSI => sr_mosi,
      TX_MISO => sr_miso,
      TAP => open,
      ARESET => ARESET,
      CLK => CLK
      );    
   
   TX1_MOSI.SOF <= TX1_SOFi;
   TX1_MOSI.EOF <= TX1_EOFi; 
   TX2_MOSI.SOF <= TX2_SOFi;
   TX2_MOSI.EOF <= TX2_EOFi;      
   
   TX1_MOSI.SUPPORT_BUSY <= '1';
   TX2_MOSI.SUPPORT_BUSY <= '1';
   
   TX1_MOSI.DVAL <= TX1_DVALi; 
   TX2_MOSI.DVAL <= TX2_DVALi; 
   
   TX1_BUSYi <= TX1_DVALi and TX1_MISO.BUSY;
   TX2_BUSYi <= TX2_DVALi and TX2_MISO.BUSY;
   
   sr_miso.AFULL <= TX1_MISO.AFULL when Sel = '0' else TX2_MISO.AFULL;   
   sr_miso.BUSY <= TX1_BUSYi when Sel = '0' else TX2_BUSYi;          
   
   process(CLK, ARESET)      
   begin
      if ARESET = '1' then
         Sel <= '0';
         TX1_DVALi <= '0';
         TX2_DVALi <= '0';
      elsif rising_edge(CLK) then
         
         if TX1_DVALi='1' and TX1_MISO.BUSY='0' then
            TX1_DVALi <= '0';
         end if;
         
         if TX2_DVALi='1' and TX2_MISO.BUSY='0' then
            TX2_DVALi <= '0';
         end if;          
         
         if sr_mosi.DVAL='1' and sr_miso.BUSY='0' then
            TX2_SOFi <= TX1_SOFi;
            if Sel='0' then  
               TX1_SOFi <= sr_mosi.SOF;
               TX1_EOFi <= RX_MOSI.EOF; -- Look ahead one data point. This trick requires the shift register.
               TX1_MOSI.DATA <= sr_mosi.DATA  ;
               TX1_DVALi <= '1';
            else
               TX2_EOFi <= sr_mosi.EOF;
               TX2_MOSI.DATA <= sr_mosi.DATA  ;
               TX2_DVALi <= '1';
            end if;
         end if;                 
         
         if EN = '0' then
            Sel <= '0';
         elsif sr_mosi.DVAL='1' and sr_miso.BUSY='0' then
            Sel <= not Sel;   
         end if;
         -- pragma translate_off
         assert (sr_mosi.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;                        
         -- pragma translate_on         
      end if;      
   end process;         
   
end RTL;
