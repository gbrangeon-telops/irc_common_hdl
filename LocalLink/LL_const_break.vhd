-------------------------------------------------------------------------------
--
-- Title       : LL_const_break
-- Design      : Common_HDL
-- Author      : Patrick Daraiche
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_const_break.vhd
-- Generated   : Mon Aug  8 08:06:26 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This block permits to toggle DVAL with two different signal.
--                use with ll_const_value component
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {LL_const_break} architecture {RTL}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity LL_const_break is
   generic(
   DLEN : integer := 16;
   DREM_LEN : integer := 2
   );
   port(
		 CLK : in STD_LOGIC;
		 ARESET : in STD_LOGIC;

       RX_MOSI_SOF : in STD_LOGIC;
		 RX_MOSI_EOF : in STD_LOGIC;
		 RX_MOSI_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
		 RX_MOSI_DREM : in STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		 RX_MOSI_DVAL : in STD_LOGIC;
		 RX_MOSI_SUPPORT_BUSY : in STD_LOGIC;
		 RX_MISO_AFULL : out STD_LOGIC;
		 RX_MISO_BUSY : out STD_LOGIC;
		 
		 TX_MOSI_SOF : out STD_LOGIC;
		 TX_MOSI_EOF : out STD_LOGIC;
		 TX_MOSI_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		 TX_MOSI_DREM : out STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		 TX_MOSI_DVAL : out STD_LOGIC;
       TX_MOSI_SUPPORT_BUSY : out STD_LOGIC;
		 TX_MISO_AFULL : in STD_LOGIC;
		 TX_MISO_BUSY : in STD_LOGIC;
       
       START : in STD_LOGIC;
       STOP : in STD_LOGIC
	     );
end LL_const_break;

--}} End of automatically maintained section

architecture RTL of LL_const_break is

   signal sof_en  : std_logic;
   signal eof_en  : std_logic;
   
   signal TX_MOSI_DVAL_i   : std_logic;

component sync_reset
      port(
         ARESET : in STD_LOGIC;
         SRESET : out STD_LOGIC;
         CLK : in STD_LOGIC);
   end component;

   signal sreset : std_logic;
   
   begin

   -- enter your statements here --
   TX_MOSI_SOF <= START or sof_en;
   TX_MOSI_EOF <= STOP or eof_en;
   TX_MOSI_DATA <= RX_MOSI_DATA;
   TX_MOSI_DREM <= RX_MOSI_DREM;
   TX_MOSI_SUPPORT_BUSY <= RX_MOSI_SUPPORT_BUSY;
   RX_MISO_AFULL <= TX_MISO_AFULL;
   RX_MISO_BUSY <= TX_MISO_BUSY;
   
   Reset : sync_reset port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);   

   TX_MOSI_DVAL   <= TX_MOSI_DVAL_i or (START and RX_MOSI_DVAL);
   
   process(CLK)
   begin
      if rising_edge(CLK) then
         
         if START = '1' and RX_MOSI_DVAL = '1' then
            TX_MOSI_DVAL_i <= '1';
            
            -- Set sof_en to '1' to be able to keep TX_MOSI_SOF high until TX_MISO_BUSY is low  
            if TX_MISO_BUSY = '1' then
               sof_en         <= '1';
            end if;
         elsif STOP = '1' then
            TX_MOSI_DVAL_i <= '0';
            
            -- Set eof_en to '1' to be able to keep TX_MOSI_EOF high until TX_MISO_BUSY is low  
            if TX_MISO_BUSY = '1' then
               eof_en         <= '1';
            end if;
         end if;
         
         if TX_MISO_BUSY = '0' then
            sof_en         <= '0';
            eof_en         <= '0';
         end if;
         
         if sreset = '1' then
            TX_MOSI_DVAL_i <= '0';
            sof_en         <= '0';
            eof_en         <= '0';
         end if;
      end if;
   end process;

end RTL;
