---------------------------------------------------------------------------------------------------
--
-- Title       : LL_SOF_EOF_Merger
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

entity LL_SOF_EOF_Merger is
   generic(
      DLEN : natural := 32;
      DREM_LEN : natural := 2
      );
   port(
      FRAME_MOSI_SOF  : in  std_logic;
      FRAME_MOSI_EOF  : in  std_logic;
      FRAME_MOSI_DVAL  : in  std_logic;
      FRAME_MOSI_DATA  : in  std_logic_vector(DLEN-1 downto 0);
      FRAME_MOSI_DREM  : in  std_logic_vector(DREM_LEN-1 downto 0);
      FRAME_MOSI_SUPPORT_BUSY : in std_logic;
      FRAME_MISO_BUSY  : out std_logic;
      FRAME_MISO_AFULL  : out std_logic;
      
      DATA_MOSI_SOF  : in  std_logic;
      DATA_MOSI_EOF  : in  std_logic;
      DATA_MOSI_DVAL  : in  std_logic;
      DATA_MOSI_DATA  : in  std_logic_vector(DLEN-1 downto 0);
      DATA_MOSI_DREM  : in  std_logic_vector(DREM_LEN-1 downto 0);
      DATA_MOSI_SUPPORT_BUSY : in std_logic;
      DATA_MISO_BUSY  : out std_logic;
      DATA_MISO_AFULL  : out std_logic;
      
      TX_MOSI_SOF : out std_logic;
      TX_MOSI_EOF : out std_logic;
      TX_MOSI_DVAL : out std_logic;
      TX_MOSI_DATA : out std_logic_vector(DLEN-1 downto 0);
      TX_MOSI_DREM : out std_logic_vector(DREM_LEN-1 downto 0);
      TX_MOSI_SUPPORT_BUSY : out std_logic;
      TX_MISO_BUSY : in  std_logic;
      TX_MISO_AFULL : in  std_logic;
      
      ARESET   : in  STD_LOGIC;
      CLK      : in  STD_LOGIC
      );
end LL_SOF_EOF_Merger;

architecture RTL of LL_SOF_EOF_Merger is

   component sync_reset is
   port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;

   component ll_sync_flow
	port(
		RX0_DVAL : in STD_LOGIC;
		RX0_BUSY : out STD_LOGIC;
		RX0_AFULL : out STD_LOGIC;
		RX1_DVAL : in STD_LOGIC;
		RX1_BUSY : out STD_LOGIC;
		RX1_AFULL : out STD_LOGIC;
		SYNC_BUSY : in STD_LOGIC;
		SYNC_DVAL : out STD_LOGIC);
	end component;

   signal sync_busy : std_logic;
   signal sync_dval : std_logic;
   signal dval : std_logic;
   signal sreset : std_logic;

begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);

   SYNC : ll_sync_flow
   port map(
      RX0_DVAL => FRAME_MOSI_DVAL,
      RX0_BUSY => FRAME_MISO_BUSY,
      RX0_AFULL => FRAME_MISO_AFULL,
      RX1_DVAL => DATA_MOSI_DVAL,
      RX1_BUSY => DATA_MISO_BUSY,
      RX1_AFULL => DATA_MISO_AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => sync_dval
      );   

   sync_busy <= TX_MISO_BUSY;  
   dval <= sync_dval and not sync_busy;  
   
   process(CLK)
   begin
      if rising_edge(CLK) then
         if(sreset = '1') then
            TX_MOSI_DVAL <= '0';
            TX_MOSI_SOF <= '0';
            TX_MOSI_EOF <= '0';
         else
            if(sync_busy = '0') then
               TX_MOSI_DVAL <= '0';
               TX_MOSI_SOF <= '0';
               TX_MOSI_EOF <= '0';
               if(dval = '1') then
                  TX_MOSI_DVAL <= '1';
                  TX_MOSI_SOF <= FRAME_MOSI_SOF;
                  TX_MOSI_EOF <= FRAME_MOSI_EOF;
                  TX_MOSI_DATA <= DATA_MOSI_DATA;
               end if;
            end if;
         end if;
      end if;
   end process;
   
   TX_MOSI_DREM <= (others => '1'); 
   TX_MOSI_SUPPORT_BUSY <= '1';
   
   -- pragma translate_off 
   assert_proc : process(ARESET)
   begin       
      if ARESET = '0' then
         assert (FRAME_MOSI_SUPPORT_BUSY = '1') report "Frame Upstream module must support the BUSY signal" severity FAILURE;          
         assert (DATA_MOSI_SUPPORT_BUSY = '1') report "Data Upstream module must support the BUSY signal" severity FAILURE;          
      end if;
   end process;
   -- pragma translate_on   
   
end RTL;
