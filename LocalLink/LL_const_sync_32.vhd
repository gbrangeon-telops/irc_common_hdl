-------------------------------------------------------------------------------
--
-- Title       : LL_const_sync_32
-- Design      : Common_HDL
-- Author      : Patrick Daraiche
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\LocalLink\LL_const_sync_32.vhd
-- Generated   : Mon Aug  8 08:06:26 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : This block permits to toggle DVAL with a constant value 
--               with sync input. 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {LL_const_sync_32} architecture {RTL}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.telops.all;

entity LL_const_sync_32 is
   port(
		 CLK : in STD_LOGIC;
		 ARESET : in STD_LOGIC;

       RX_MOSI : in t_ll_mosi32;
       RX_MISO : out t_ll_miso;
       TX_MOSI : out t_ll_mosi32;
       TX_MISO : in t_ll_miso;
       
       SYNC_MOSI : in t_ll_mosi32;
       SYNC_MISO : in t_ll_miso
       
     );
end LL_const_sync_32;

--}} End of automatically maintained section

architecture RTL of LL_const_sync_32 is

   component sync_reset is
   port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;

   signal sreset : std_logic;

begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);

   TX_MOSI.SUPPORT_BUSY <= '1';

   RX_MISO.AFULL <= TX_MISO.AFULL;
   RX_MISO.BUSY <= TX_MISO.BUSY;

   process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then
            TX_MOSI.DVAL <= '0';
         else
            if TX_MISO.BUSY = '0' then
               if RX_MOSI.DVAL = '1' and SYNC_MOSI.DVAL = '1' and SYNC_MISO.BUSY = '0' then
                  TX_MOSI.DVAL <= '1';
                  TX_MOSI.SOF <= SYNC_MOSI.SOF;
                  TX_MOSI.EOF <= SYNC_MOSI.EOF;
                  TX_MOSI.DATA <= RX_MOSI.DATA;
                  TX_MOSI.DREM <= RX_MOSI.DREM;
               else
                  TX_MOSI.DVAL <= '0';
               end if;
            end if;
         end if;
      end if;
   end process;
   
end RTL;
