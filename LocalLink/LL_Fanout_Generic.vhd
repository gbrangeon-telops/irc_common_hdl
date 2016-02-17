---------------------------------------------------------------------------------------------------
--
-- Title       : LL_Fanout_Generic
-- Author      : Patrick Daraiche
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : Ce module dédouble une entrée Local_link.
--
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_Fanout_Generic is
   generic(
      DLEN : natural := 32;
      DREM_LEN : natural := 2
      );
   port(
      RX_MOSI_SOF  : in  std_logic;
      RX_MOSI_EOF  : in  std_logic;
      RX_MOSI_DVAL  : in  std_logic;
      RX_MOSI_DATA  : in  std_logic_vector(DLEN-1 downto 0);
      RX_MOSI_DREM  : in  std_logic_vector(DREM_LEN-1 downto 0);
      RX_MOSI_SUPPORT_BUSY : in std_logic;
      RX_MISO_BUSY  : out std_logic;
      RX_MISO_AFULL  : out std_logic;
      
      
      TX1_MOSI_SOF : out std_logic;
      TX1_MOSI_EOF : out std_logic;
      TX1_MOSI_DVAL : out std_logic;
      TX1_MOSI_DATA : out std_logic_vector(DLEN-1 downto 0);
      TX1_MOSI_DREM : out std_logic_vector(DREM_LEN-1 downto 0);
      TX1_MOSI_SUPPORT_BUSY : out std_logic;
      TX1_MISO_BUSY : in  std_logic;
      TX1_MISO_AFULL : in  std_logic;
      
      TX2_MOSI_SOF : out std_logic;
      TX2_MOSI_EOF : out std_logic;
      TX2_MOSI_DVAL : out std_logic;
      TX2_MOSI_DATA : out std_logic_vector(DLEN-1 downto 0);
      TX2_MOSI_DREM : out std_logic_vector(DREM_LEN-1 downto 0);
      TX2_MOSI_SUPPORT_BUSY : out std_logic;
      TX2_MISO_BUSY : in  std_logic;
      TX2_MISO_AFULL : in  std_logic;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end LL_Fanout_Generic;

architecture RTL of LL_Fanout_Generic is
   signal RX_BUSYi : std_logic; 
begin
   
   RX_MISO_AFULL <= TX1_MISO_AFULL or TX2_MISO_AFULL;
   RX_BUSYi <= TX1_MISO_BUSY or TX2_MISO_BUSY;
   RX_MISO_BUSY <= RX_BUSYi; 
   
   TX1_MOSI_SUPPORT_BUSY <= '1';
   TX1_MOSI_SOF <= RX_MOSI_SOF;
   TX1_MOSI_EOF <= RX_MOSI_EOF;
   TX1_MOSI_DATA <= RX_MOSI_DATA;
   TX1_MOSI_DREM <= RX_MOSI_DREM;
   TX1_MOSI_DVAL <= RX_MOSI_DVAL and not RX_BUSYi;
   
   TX2_MOSI_SUPPORT_BUSY <= '1';
   TX2_MOSI_SOF <= RX_MOSI_SOF;
   TX2_MOSI_EOF <= RX_MOSI_EOF;
   TX2_MOSI_DATA <= RX_MOSI_DATA;
   TX2_MOSI_DREM <= RX_MOSI_DREM;
   TX2_MOSI_DVAL <= RX_MOSI_DVAL and not RX_BUSYi;  
   
   -- pragma translate_off 
   assert_proc : process(ARESET)
   begin       
      if ARESET = '0' then
         assert (RX_MOSI_SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;          
      end if;
   end process;
   -- pragma translate_on   
   
end RTL;
