
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.DPB_Define.all;

----------------------------------------------------------------------
-- Entity declaration.
----------------------------------------------------------------------

entity wb_8i8o is
   port (
      WB_MOSI : in t_wb_mosi;
      WB_MISO : out  t_wb_miso;
      
      CLK_I:  in  std_logic;
      RST_I:  in  std_logic;
      GP_OUT: out std_logic_vector(7 downto 0);
      GP_IN:  in  std_logic_vector(7 downto 0)
      );
   
end entity wb_8i8o;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture RTL of wb_8i8o is  

   alias ACK_O : std_logic is WB_MISO.ACK;
   alias DAT_O : std_logic_vector(WB_MISO.DAT'LENGTH-1 downto 0) is WB_MISO.DAT;
   alias ADR_I : std_logic_vector(WB_MOSI.ADR'LENGTH-1 downto 0) is WB_MOSI.ADR;
   alias DAT_I : std_logic_vector(WB_MOSI.DAT'LENGTH-1 downto 0) is WB_MOSI.DAT;
   alias STB_I : std_logic is WB_MOSI.STB;
   alias WE_I  : std_logic is WB_MOSI.WE;
   
   signal Q: std_logic_vector( 7 downto 0 ); 
   
begin 
   
   REG: process( CLK_I )
   begin
      if( rising_edge( CLK_I ) ) then
         if( RST_I = '1' ) then
            Q <= B"00000000";
         elsif( (STB_I and WE_I) = '1' and ADR_I(0) = '0') then
            Q <= DAT_I( 7 downto 0 );
         end if;
         
         
      end if;
   end process REG;
   ACK_O <= STB_I;
   DAT_O <= (X"00" & Q) when ADR_I(0) = '0' else (X"00" & GP_IN);   
   GP_OUT <= Q;

end architecture RTL;

