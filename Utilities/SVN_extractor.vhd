-------------------------------------------------------------------------------
--
-- Title       : SVN_extractor
-- Design      : Common_HDL
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\Utilities\SVN_extractor.vhd
-- Generated   : Mon Dec  7 09:59:17 2009
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {SVN_extractor} architecture {rtl}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library Common_Hdl;
use Common_Hdl.telops.all;

entity SVN_extractor is
   port(
      CLK : in STD_LOGIC;
      ARESET : in STD_LOGIC;
      SVN : out STD_LOGIC_VECTOR(31 downto 0)
      );
end SVN_extractor;

--}} End of automatically maintained section

architecture rtl of SVN_extractor is
   
   -- Component declaration of the "sync_reset(rtl)" unit defined in
   -- file: "./../Utilities/sync_reset.vhd"
   component sync_reset
      port(
         ARESET : in STD_LOGIC;
         SRESET : out STD_LOGIC;
         CLK : in STD_LOGIC);
   end component;
   
   -- Component declaration of the "sp_ram(bram)" unit defined in
   -- file: "./../Utilities/sp_ram.vhd"
   component sp_ram
      generic(
         D_WIDTH : INTEGER := 16;
         A_WIDTH : INTEGER := 8);
      port(
         clk : in STD_LOGIC;
         en : in STD_LOGIC;
         we : in STD_LOGIC;
         add : in STD_LOGIC_VECTOR(A_WIDTH-1 downto 0);
         din : in STD_LOGIC_VECTOR(D_WIDTH-1 downto 0);
         dout : out STD_LOGIC_VECTOR(D_WIDTH-1 downto 0));
   end component;
   
   signal sreset : std_logic;
   signal en : std_logic;
   signal we : std_logic;
   signal add : std_logic_vector(7 downto 0);
   signal din : std_logic_vector(15 downto 0);
   signal dout : std_logic_vector(15 downto 0);
   signal add_req : std_logic_vector(7 downto 0);
   
begin
   
   -- enter your statements here --
   reset : sync_reset
   port map(
      ARESET => ARESET,
      SRESET => sreset,
      CLK => CLK
      );
   
   ram : sp_ram
--   generic map(
--      D_WIDTH => D_WIDTH,
--      A_WIDTH => A_WIDTH
--      )
   port map(
      clk => CLK,
      en => en,
      we => we,
      add => add,
      din => din,
      dout => dout
      ); 
   
   we <= '0';
   din <= (others => '0');
   en <= '1';
   
   read_ram : process(CLK)
      variable lsb : std_logic;
      variable msb : std_logic;
   begin
      if rising_edge(CLK) then
         if sreset = '1' then
            lsb := '0';
            msb := '0';
            add <= (others => '0');
            SVN <= (others => '0');
         else
            if add(0) = '0' then
               add(0) <= '1';
            end if;
            add_req <= add;
            
            if add_req(0) = '0' then
               SVN(31 downto 16) <= Uto0(dout)
               -- translate off
               or x"C00D"
               -- translate on
               ;
            else
               SVN(15 downto 0) <= Uto0(dout)
               -- translate off
               or x"BEEF"
               -- translate on
               ;
            end if;
         end if;
      end if;
   end process;
   
   
end rtl;
