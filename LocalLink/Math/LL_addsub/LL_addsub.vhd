-------------------------------------------------------------------------------
--
-- Title       : LL_addsub
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink ports are always 32 bits but the real width is 
--               (DLEN-1 downto 0) for the input and (DLEN downto 0) for the output.
--               For simplicity, data is all signed or unsigned for input and output.
--               Could be improved.   
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use ieee.numeric_std.all;

library Common_HDL; 
use Common_HDL.all;
use Common_HDL.Telops.all;

entity LL_addsub is
   generic(
      signed_data : BOOLEAN := FALSE;
      DLEN     : natural := 17
      );
   port(
      A_MOSI   : in  t_ll_mosi32;
      A_MISO   : out t_ll_miso;
      
      B_MOSI   : in  t_ll_mosi32;
      B_MISO   : out t_ll_miso;      
      
      RES_MOSI : out t_ll_mosi32;
      RES_MISO : in  t_ll_miso; 
      
      ERR      : out std_logic;
      OP       : in  std_logic; -- 0: Add, 1: Sub
      
      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC		
      );
end LL_addsub;

--}} End of automatically maintained section

architecture RTL of LL_addsub is    
   
   signal sync_busy  : std_logic;
   signal sync_dval  : std_logic;   
   
   signal break_mosi : t_ll_mosi32;
   signal break_miso : t_ll_miso;
   
   signal unsigned_sum : unsigned(DLEN downto 0);
   signal signed_sum : signed(DLEN downto 0);
   
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
   
   break_MOSI.SOF <= '0';
   break_MOSI.EOF <= '0';
   
   
   gen_both_unsigned : if not signed_data generate
   unsigned_sum <= resize(unsigned(A_MOSI.DATA(DLEN-1 downto 0)),DLEN+1) + resize(unsigned(B_MOSI.DATA(DLEN-1 downto 0)),DLEN+1) when OP = '0' 
      else resize(unsigned(A_MOSI.DATA(DLEN-1 downto 0)),DLEN+1) - resize(unsigned(B_MOSI.DATA(DLEN-1 downto 0)),DLEN+1);
      
   break_MOSI.DATA <= std_logic_vector(resize(unsigned_sum, 32));

   -- Error when Overflow on addition and when below 0 on substraction
   ERR <= '1' when sync_dval = '1' and unsigned_sum(DLEN) = '1' else '0';
   
   end generate gen_both_unsigned;

   gen_signed : if signed_data generate

   signed_sum <= resize(signed(A_MOSI.DATA(DLEN-1 downto 0)),DLEN+1) + resize(signed(B_MOSI.DATA(DLEN-1 downto 0)),DLEN+1) when OP = '0' 
      else resize(signed(A_MOSI.DATA(DLEN-1 downto 0)),DLEN+1) - resize(signed(B_MOSI.DATA(DLEN-1 downto 0)),DLEN+1);

   break_MOSI.DATA <= std_logic_vector(resize(signed_sum, 32));

   -- Error when the 2 MSB are not equal
   ERR <= '1' when sync_dval = '1' and ((signed_sum(DLEN) /= signed_sum(DLEN-1))) else '0';
   
   end generate gen_signed;

   
   break_MOSI.DVAL <= sync_dval; 
   break_MOSI.SUPPORT_BUSY <= '1';
   
   -- Provide output registers
   reg : entity ll_busybreak_32
   port map(
      RX_MOSI => break_mosi,
      RX_MISO => break_miso,
      TX_MOSI => RES_MOSI,
      TX_MISO => RES_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   
   
end RTL;
