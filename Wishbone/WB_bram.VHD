
library ieee;
use ieee.std_logic_1164.all;   

library Common_HDL;
use Common_HDL.Telops.all;

----------------------------------------------------------------------
-- Entity declaration.
----------------------------------------------------------------------

entity WB_bram is
   port (
      WB_MOSI : in   t_wb_mosi;
      WB_MISO : out  t_wb_miso;
      
      CLK:  in  std_logic
      );
   
end entity WB_bram;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture RTL of WB_bram is 
   
   signal ram_we  : std_logic; 
   signal ram_add : std_logic_vector(7 downto 0); 
   
	component sp_ram
	generic(
		D_WIDTH : INTEGER := 16;
		A_WIDTH : INTEGER := 8);
	port(
		clk : in std_logic;
		en : in std_logic;
		we : in std_logic;
		add : in std_logic_vector(A_WIDTH-1 downto 0);
		din : in std_logic_vector(D_WIDTH-1 downto 0);
		dout : out std_logic_vector(D_WIDTH-1 downto 0));
	end component;    
   
begin
   
   ram_we  <= WB_MOSI.WE and WB_MOSI.STB;
   ram_add <= WB_MOSI.ADR(7 downto 0);
   
   ram : sp_ram
   generic map(
      D_WIDTH => 16,
      A_WIDTH => 8
      )
   port map(
      clk => CLK,
      en => '1',
      we => ram_we,
      add => ram_add,
      din => WB_MOSI.DAT,
      dout => WB_MISO.DAT
      );   
         
   ctrl: process( CLK )
   begin
      if rising_edge(CLK) then
         WB_MISO.ACK <= WB_MOSI.STB;
      end if;      
   end process ctrl;  
   
end architecture RTL;

