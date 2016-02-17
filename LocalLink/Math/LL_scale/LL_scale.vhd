-------------------------------------------------------------------------------
--
-- Title       : LL_scale
-- Author      : PDU
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : This component performs "scaling" of the data. It's simply
--               TX_DATA = RX_DATA * 2^EXP
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;   

entity LL_Scale is
   generic(
      signed_data : boolean := FALSE; -- Data is signed or unsigned, Exponent is always signed.
      DLEN        : natural := 12; -- Data length
      ELEN        : natural := 4   -- Exponent length
      );
   port(
      RX_MOSI    : in  T_LL_MOSI32;
      RX_MISO    : out T_LL_MISO;
      
      TX_MISO    : in  T_LL_MISO;
      TX_MOSI    : out T_LL_MOSI32;

      EXP        : in  signed(ELEN-1 downto 0);
      
      ARESET     : in  std_logic;
      CLK        : in  std_logic
      );
end LL_Scale;

architecture RTL of LL_Scale is
   
   signal break_mosi : t_ll_mosi32;
   signal break_miso : t_ll_miso;
   
begin                                         
   
   
   break_MOSI.SOF <= RX_MOSI.SOF;
   break_MOSI.EOF <= RX_MOSI.EOF;   
   
   gen_unsigned : if not signed_data generate   
      --break_MOSI.DATA <=
      
   end generate gen_unsigned;

   gen_signed : if signed_data generate
 
      --break_MOSI.DATA <=
 
   end generate gen_signed;   
   
   break_MOSI.DVAL <= RX_MOSI.DVAL; 
   break_MOSI.SUPPORT_BUSY <= '1';
   
   -- Provide output registers
   reg : entity ll_busybreak_32
   port map(
      RX_MOSI => break_mosi,
      RX_MISO => break_miso,
      TX_MOSI => TX_MOSI,
      TX_MISO => TX_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   



end RTL;
