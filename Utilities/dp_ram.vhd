-------------------------------------------------------------------------------
--
-- Title       : dp_ram
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : Dual-Port RAM with Synchronous Read (Read Through), directly
--               mapped onto block-ram. Heavily inspired by the XST user guide.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;  

entity dp_ram is
   generic(
      D_WIDTH : integer := 16;
      A_WIDTH : integer := 8);
   port (
      clk   : in std_logic;
      we    : in std_logic;                              -- Synchronous Write Enable (Active High)
      add   : in std_logic_vector(A_WIDTH-1 downto 0);   -- Write Address/Primary Read Address
      dpra  : in std_logic_vector(A_WIDTH-1 downto 0);   -- Dual Read Address
      din   : in std_logic_vector(D_WIDTH-1 downto 0);   -- Data Input
      dout  : out std_logic_vector(D_WIDTH-1 downto 0);  -- Primary Output Port
      dpo   : out std_logic_vector(D_WIDTH-1 downto 0)); -- Dual Output Port 
   
end dp_ram;     

architecture bram of dp_ram is
   type ram_type is array ((2**A_WIDTH)-1 downto 0) of std_logic_vector (D_WIDTH-1 downto 0);
   signal RAM : ram_type
   -- translate_off
   := (others=> (others => '0'))
   -- translate_on
   ;      
   attribute ram_style: string;
   attribute ram_style of RAM: signal is "block"; 
   
   signal read_a : std_logic_vector(A_WIDTH-1 downto 0);
   signal read_dpra : std_logic_vector(A_WIDTH-1 downto 0);
begin
   process (clk)
   begin
      if rising_edge(clk) then
         if (we = '1') then
            RAM(conv_integer(add)) <= din;
         end if;
         read_a <= add;
         read_dpra <= dpra;
      end if;
   end process;
   dout <= RAM(conv_integer(read_a));
   dpo <= RAM(conv_integer(read_dpra));
end bram;