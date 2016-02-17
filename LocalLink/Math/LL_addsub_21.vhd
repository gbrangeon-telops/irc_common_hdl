-------------------------------------------------------------------------------
--
-- Title       : LL_addsub_21
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

entity LL_addsub_21 is
   generic(
      signed_data : BOOLEAN := FALSE;
      SOF_EOF_Mode : natural := 0 -- 0: SOF_EOF taken from A, 1: SOF_EOF taken from B, 2, SOF from A, EOF from B 
      );
   port(
      A_MOSI   : in  t_ll_mosi21;
      A_MISO   : out t_ll_miso;
      
      B_MOSI   : in  t_ll_mosi21;
      B_MISO   : out t_ll_miso;      
      
      RES_MOSI : out t_ll_mosi21;
      RES_MISO : in  t_ll_miso; 
      
      ERR      : out std_logic;
      OP       : in std_logic; -- 0: Add, 1: Sub
      
      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC		
      );
end LL_addsub_21;

--}} End of automatically maintained section

architecture RTL of LL_addsub_21 is    
   
   signal sync_busy  : std_logic;
   signal sync_dval  : std_logic;   
   
   signal break_mosi : t_ll_mosi21;
   signal break_miso : t_ll_miso;
   
   -- Shift registers
   signal SOF           : std_logic;
   signal EOF           : std_logic;
   
   signal unsigned_sum : unsigned(21 downto 0);
   signal signed_sum : signed(21 downto 0);
   
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
   
   --break_MOSI.SOF <= '0';
   --break_MOSI.EOF <= '0';
   
   
   gen_unsigned : if not signed_data generate
   unsigned_sum <= resize(unsigned(A_MOSI.DATA),22) + resize(unsigned(B_MOSI.DATA),22) when OP = '0' 
      else resize(unsigned(A_MOSI.DATA),22) - resize(unsigned(B_MOSI.DATA),22);
      
   break_MOSI.DATA <= std_logic_vector(unsigned_sum(20 downto 0));

   -- Error when Overflow on addition and when below 0 on substraction
   ERR <= '1' when sync_dval = '1' and unsigned_sum(21) = '1' else '0';
   
   end generate gen_unsigned;

   gen_signed : if signed_data generate

   signed_sum <= resize(signed(A_MOSI.DATA),22) + resize(signed(B_MOSI.DATA),22) when OP = '0' 
      else resize(signed(A_MOSI.DATA),22) - resize(signed(B_MOSI.DATA),22);

   break_MOSI.DATA <= std_logic_vector(signed_sum(20 downto 0));

   -- Error when the 2 MSB are not equal
   ERR <= '1' when sync_dval = '1' and ((signed_sum(21) /= signed_sum(20))) else '0';
   
   end generate gen_signed;
   
   
   SOF_EOF_0 : if (SOF_EOF_Mode = 0) generate
      SOF <= A_MOSI.SOF;
      EOF <= A_MOSI.EOF; 
   end generate SOF_EOF_0;
   
   SOF_EOF_1 : if (SOF_EOF_Mode = 1) generate
      SOF <= B_MOSI.SOF;
      EOF <= B_MOSI.EOF; 
   end generate SOF_EOF_1;
   
   SOF_EOF_2 : if (SOF_EOF_Mode = 2) generate
      SOF <= A_MOSI.SOF;
      EOF <= B_MOSI.EOF; 
   end generate SOF_EOF_2;
   
   break_MOSI.SOF <= SOF;
   break_MOSI.EOF <= EOF;
   
   
   break_MOSI.DVAL <= sync_dval; 
   break_MOSI.SUPPORT_BUSY <= '1';
   
   -- Provide output registers
   reg : entity ll_busybreak_21
   port map(
      RX_MOSI => break_mosi,
      RX_MISO => break_miso,
      TX_MOSI => RES_MOSI,
      TX_MISO => RES_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   
   
end RTL;
