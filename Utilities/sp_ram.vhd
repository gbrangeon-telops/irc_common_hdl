-------------------------------------------------------------------------------
--
-- Title       : sp_ram
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : Single-Port RAM with Synchronous Read (Read Through), directly
--               mapped onto block-ram. Heavily inspired by the XST user guide.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;  

entity sp_ram is
   generic(
      D_WIDTH : integer := 16;
      A_WIDTH : integer := 8);
   port (
      clk   : in  std_logic;                             -- Clock
      en    : in  std_logic;                             -- Global Enable
      we    : in  std_logic;                             -- Synchronous Write Enable (Active High)
      add   : in  std_logic_vector(A_WIDTH-1 downto 0);  -- Write Address/Primary Read Address
      din   : in  std_logic_vector(D_WIDTH-1 downto 0);  -- Data Input
      dout  : out std_logic_vector(D_WIDTH-1 downto 0)); -- Primary Output Port   
   
end sp_ram;     

architecture bram of sp_ram is
   type ram_type is array ((2**A_WIDTH)-1 downto 0) of std_logic_vector (D_WIDTH-1 downto 0);
   signal RAM : ram_type
   -- translate_off
   := (others=> (others => '0'))
   -- translate_on
   ;
   attribute ram_style: string;
   attribute ram_style of RAM: signal is "block";   
   
   signal read_a : std_logic_vector(A_WIDTH-1 downto 0);
begin
   process (clk)
   begin
      if rising_edge(clk) then
         if en = '1' then
            if (we = '1') then
               RAM(conv_integer(add)) <= din;
            end if;
            read_a <= add;  
         end if;
      end if;
   end process;
   dout <= RAM(conv_integer(read_a));
end bram;