-----------------------------------------------------
--	Clok out ODDR
-- 	Khalid Bensadek
 -----------------------------------------------------
 library ieee; 
 use ieee.std_logic_1164.all;
 use ieee.numeric_std.all;

 library UNISIM;
 use UNISIM.vcomponents.all;

 entity oddr_clkout is
    port (
        clk_i : in std_logic;
        rst_i : in std_logic;
        clk_o : out std_logic
        );
 end oddr_clkout;

 architecture rtl of oddr_clkout is

 signal clkn_s: std_logic;
 
 begin


 clkn_s <= not clk_i; 
   
 InstVidClk_DDRFF: OFDDRRSE
 port map (
      Q   => clk_o,
      C0  => clk_i,
      C1  => clkn_s,
      CE  => '1',
      D0  => '0',
      D1  => '1',
      R   => rst_i,
      S   => '0'
         );             

 end rtl;