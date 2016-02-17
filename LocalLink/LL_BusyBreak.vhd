-------------------------------------------------------------------------------
--
-- Title       : LL_BusyBreak
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Breaks the busy combinatorial feedback. Use this block to
--               improve timing closure.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;   
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_BusyBreak is                  
   generic(DLEN : natural := 32);
   port(
      RX_MOSI  : in  t_ll_mosi32; 
      RX_MISO  : out t_ll_miso; 
      
      TX_MOSI  : out t_ll_mosi32;
      TX_MISO  : in  t_ll_miso;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end LL_BusyBreak;

architecture RTL of LL_BusyBreak is

   attribute KEEP_HIERARCHY : string;
   attribute KEEP_HIERARCHY of RTL: architecture is "true";
   
   signal sreset           : std_logic; 
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
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
   
   signal rx_data : std_logic_vector(DLEN+3 downto 0);
   signal tx_data : std_logic_vector(DLEN+3 downto 0);
   
   
begin          
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);   
   
   fifo : fifo_2byte
   generic map(
      data_width => DLEN+4
      )
   port map(
      RST => sreset,
      CLK => CLK,
      RX_DVAL => RX_MOSI.DVAL,
      RX_BUSY => RX_MISO.BUSY,
      RX_DATA => rx_data,
      TX_DVAL => TX_MOSI.DVAL,
      TX_BUSY => TX_MISO.BUSY,
      TX_DOUT => tx_data
      );
      
   --RX_MISO.AFULL <= TX_MISO.AFULL;      
   rx_data <= RX_MOSI.DREM & RX_MOSI.SOF & RX_MOSI.EOF & RX_MOSI.DATA(DLEN-1 downto 0);
   TX_MOSI.DREM <= tx_data(DLEN+3 downto DLEN+2);
   TX_MOSI.SOF <= tx_data(DLEN+1);
   TX_MOSI.EOF <= tx_data(DLEN);
   TX_MOSI.DATA <= std_logic_vector(resize(unsigned(tx_data(DLEN-1 downto 0)), 32));   
   TX_MOSI.SUPPORT_BUSY <= '1';

   AFULL : process(CLK)
   begin
      if rising_edge(CLK) then
            RX_MISO.AFULL <= TX_MISO.AFULL;
      end if;
   end process;

end RTL;
