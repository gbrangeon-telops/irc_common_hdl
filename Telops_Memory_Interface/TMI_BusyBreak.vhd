-------------------------------------------------------------------------------
--
-- Title       : TMI_BusyBreak
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author: rd\pdubois $
-- $LastChangedDate: 2010-03-26 14:28:59 -0400 (ven., 26 mars 2010) $
-- $Revision: 7590 $
-------------------------------------------------------------------------------
-- Description : TMI Busy Break
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;   
library Common_HDL;
use Common_HDL.Telops.all;

entity TMI_BusyBreak is
   generic(
      DLEN  : natural := 32;
      ALEN  : natural := 21);
   port(
      --------------------------------
      -- Client Interface (aka IN)
      --------------------------------
      IN_MOSI    : in  t_tmi_mosi_a21_d32;
      IN_MISO    : out t_tmi_miso_d32;
      
      OUT_MOSI   : out t_tmi_mosi_a21_d32;
      OUT_MISO   : in  t_tmi_miso_d32;      
      
      CLK        : in  std_logic;
      ARESET     : in  std_logic
      );
end TMI_BusyBreak;

architecture RTL of TMI_BusyBreak is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component fifo_2byte
      generic(
         data_width : NATURAL := 32);
      port(
         RST : in STD_LOGIC;
         CLK : in STD_LOGIC;
         RX_DVAL : in STD_LOGIC;
         RX_BUSY : out STD_LOGIC;
         RX_DATA : in STD_LOGIC_VECTOR(data_width-1 downto 0);
         TX_DVAL : out STD_LOGIC;
         TX_BUSY : in STD_LOGIC;
         TX_DOUT : out STD_LOGIC_VECTOR(data_width-1 downto 0));
   end component;  
   
   signal sreset : std_logic;
   signal in_data : std_logic_vector(DLEN+ALEN downto 0);
   signal out_data : std_logic_vector(DLEN+ALEN downto 0);     
   
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   fifo : fifo_2byte
   generic map(
      data_width => DLEN+ALEN+1
      )
   port map(
      RST => sreset,
      CLK => CLK,
      RX_DVAL => IN_MOSI.DVAL,
      RX_BUSY => IN_MISO.BUSY,
      RX_DATA => in_data,
      TX_DVAL => OUT_MOSI.DVAL,
      TX_BUSY => OUT_MISO.BUSY,
      TX_DOUT => out_data
      );
   
   in_data <= IN_MOSI.RNW & IN_MOSI.WR_DATA(DLEN-1 downto 0) & IN_MOSI.ADD(ALEN-1 downto 0);
   
   OUT_MOSI.RNW <= out_data(DLEN+ALEN);
   OUT_MOSI.WR_DATA <= std_logic_vector(resize(unsigned(out_data(DLEN+ALEN-1 downto ALEN)), 32));
   OUT_MOSI.ADD <= std_logic_vector(resize(unsigned(out_data(ALEN-1 downto 0)), 21));
   
   
   
   process(CLK)
   begin
      if rising_edge(CLK) then
         IN_MISO.RD_DATA <= OUT_MISO.RD_DATA;
         IN_MISO.RD_DVAL <= OUT_MISO.RD_DVAL;         
         IN_MISO.ERROR <= OUT_MISO.ERROR;
         IN_MISO.IDLE    <= OUT_MISO.IDLE;
         if sreset = '1' then
            IN_MISO.RD_DVAL <= '0';
         end if;
      end if;
   end process;
   
   
   
   
   
end RTL;