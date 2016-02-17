---------------------------------------------------------------------------------------------------
--
-- Title       : LL_TMI_read
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : Ce module prend simplement un flot LocalLink entrant d'adresses et génère des
--               transactions read sur le port TMI. Il sort le résultat de la lecture sur le port
--               LocalLink RD. Il supporte les signaux SOF et EOF sur le port ADD et regénère ces
--               mêmes SOF et EOF sur la sortie RD.
--
---------------------------------------------------------------------------------------------------

library IEEE;
library Common_HDL;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;        
use common_hdl.telops.all;

entity LL_TMI_read is
   generic(          
      TMI_Latency : natural := 4;  -- Maximum number of clock cycles during which TMI can continue generating RD_DATA after read requests have stopped.
      DLEN : natural := 32;
      ALEN : natural := 21);  
   port(  
      --------------------------------
      -- TMI Interface
      --------------------------------
      TMI_IDLE    : in  std_logic;
      TMI_ERROR   : in  std_logic;
      TMI_RNW     : out std_logic;
      TMI_ADD     : out std_logic_vector(ALEN-1 downto 0);
      TMI_DVAL    : out std_logic;
      TMI_BUSY    : in  std_logic;
      TMI_RD_DATA : in  std_logic_vector(DLEN-1 downto 0);
      TMI_RD_DVAL : in  std_logic;      
      TMI_WR_DATA : out std_logic_vector(DLEN-1 downto 0);   
      --------------------------------
      -- Incoming Addresses
      --------------------------------   
      ADD_LL_SOF	 : in  std_logic;
      ADD_LL_EOF	 : in  std_logic;
      ADD_LL_DATA  : in  std_logic_vector(ALEN-1 downto 0);      
      ADD_LL_DVAL	 : in  std_logic;
      ADD_LL_SUPPORT_BUSY : in std_logic;
      ADD_LL_BUSY  : out std_logic;      
      ADD_LL_AFULL : out std_logic;      
      --------------------------------
      -- Outgoing data from read requests
      --------------------------------   
      RD_LL_SOF	: out std_logic;
      RD_LL_EOF	: out std_logic;
      RD_LL_DATA  : out std_logic_vector(DLEN-1 downto 0);      
      RD_LL_DVAL	: out std_logic;
      RD_LL_SUPPORT_BUSY : out std_logic;
      RD_LL_BUSY  : in  std_logic;      
      RD_LL_AFULL : in  std_logic;
      --------------------------------
      -- Others IOs
      --------------------------------     
      IDLE        : out std_logic;                 -- 1 when TMI_IDLE is 1 and all internal pipelines are empty.
      ERROR       : out std_logic;
      ARESET      : in  std_logic;
      CLK         : in  std_logic
      );
end LL_TMI_read;

architecture RTL of LL_TMI_read is      

   component sync_reset is
   port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;

	component locallink_fifo32
	generic(       
      BusyBreak  : boolean := true;
		FifoSize : INTEGER := 512;
		Latency : INTEGER := 0;
		ASYNC : BOOLEAN := false);
	port(
		RX_LL_MOSI : in t_ll_mosi32;
		RX_LL_MISO : out t_ll_miso;
		CLK_RX : in STD_LOGIC;
		FULL : out STD_LOGIC;
		WR_ERR : out STD_LOGIC;
		TX_LL_MOSI : out t_ll_mosi32;
		TX_LL_MISO : in t_ll_miso;
		CLK_TX : in STD_LOGIC;
		EMPTY : out STD_LOGIC;
		ARESET : in STD_LOGIC);
	end component;
      
	component ll_fanout_generic
	generic(
		DLEN : NATURAL := 32;
		DREM_LEN : NATURAL := 2);
	port(
		RX_MOSI_SOF : in STD_LOGIC;
		RX_MOSI_EOF : in STD_LOGIC;
		RX_MOSI_DVAL : in STD_LOGIC;
		RX_MOSI_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
		RX_MOSI_DREM : in STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		RX_MOSI_SUPPORT_BUSY : in STD_LOGIC;
		RX_MISO_BUSY : out STD_LOGIC;
		RX_MISO_AFULL : out STD_LOGIC;
		TX1_MOSI_SOF : out STD_LOGIC;
		TX1_MOSI_EOF : out STD_LOGIC;
		TX1_MOSI_DVAL : out STD_LOGIC;
		TX1_MOSI_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		TX1_MOSI_DREM : out STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		TX1_MOSI_SUPPORT_BUSY : out STD_LOGIC;
		TX1_MISO_BUSY : in STD_LOGIC;
		TX1_MISO_AFULL : in STD_LOGIC;
		TX2_MOSI_SOF : out STD_LOGIC;
		TX2_MOSI_EOF : out STD_LOGIC;
		TX2_MOSI_DVAL : out STD_LOGIC;
		TX2_MOSI_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		TX2_MOSI_DREM : out STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		TX2_MOSI_SUPPORT_BUSY : out STD_LOGIC;
		TX2_MISO_BUSY : in STD_LOGIC;
		TX2_MISO_AFULL : in STD_LOGIC;
		ARESET : in STD_LOGIC;
		CLK : in STD_LOGIC);
	end component;

	component ll_sof_eof_merger
	generic(
		DLEN : NATURAL := 32;
		DREM_LEN : NATURAL := 2);
	port(
		FRAME_MOSI_SOF : in STD_LOGIC;
		FRAME_MOSI_EOF : in STD_LOGIC;
		FRAME_MOSI_DVAL : in STD_LOGIC;
		FRAME_MOSI_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
		FRAME_MOSI_DREM : in STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		FRAME_MOSI_SUPPORT_BUSY : in STD_LOGIC;
		FRAME_MISO_BUSY : out STD_LOGIC;
		FRAME_MISO_AFULL : out STD_LOGIC;
		DATA_MOSI_SOF : in STD_LOGIC;
		DATA_MOSI_EOF : in STD_LOGIC;
		DATA_MOSI_DVAL : in STD_LOGIC;
		DATA_MOSI_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
		DATA_MOSI_DREM : in STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		DATA_MOSI_SUPPORT_BUSY : in STD_LOGIC;
		DATA_MISO_BUSY : out STD_LOGIC;
		DATA_MISO_AFULL : out STD_LOGIC;
		TX_MOSI_SOF : out STD_LOGIC;
		TX_MOSI_EOF : out STD_LOGIC;
		TX_MOSI_DVAL : out STD_LOGIC;
		TX_MOSI_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		TX_MOSI_DREM : out STD_LOGIC_VECTOR(DREM_LEN-1 downto 0);
		TX_MOSI_SUPPORT_BUSY : out STD_LOGIC;
		TX_MISO_BUSY : in STD_LOGIC;
		TX_MISO_AFULL : in STD_LOGIC;
		ARESET : in STD_LOGIC;
		CLK : in STD_LOGIC);
	end component;

	component locallink_fifo1
	generic(
		FifoSize : INTEGER := 512;
		Latency : INTEGER := 0;
		ASYNC : BOOLEAN := false);
	port(
		RX_LL_MOSI : in t_ll_mosi1;
		RX_LL_MISO : out t_ll_miso;
		CLK_RX : in STD_LOGIC;
		FULL : out STD_LOGIC;
		WR_ERR : out STD_LOGIC;
		TX_LL_MOSI : out t_ll_mosi1;
		TX_LL_MISO : in t_ll_miso;
		CLK_TX : in STD_LOGIC;
		EMPTY : out STD_LOGIC;
		ARESET : in STD_LOGIC);
	end component;

   signal sreset : std_logic;
   signal dval_tmi : std_logic;
   signal fifo_empty : std_logic;
   signal fifo_error : std_logic;
   signal fifo_full : std_logic;
   signal fifo_1bit_empty : std_logic;
   signal fifo_1bit_error : std_logic;
   signal fifo_1bit_full : std_logic;
   
   signal frame_mosi_sof : std_logic;
   signal frame_mosi_eof : std_logic;
   signal frame_mosi_dval : std_logic;
   signal frame_mosi_data : std_logic_vector(DLEN-1 downto 0);
   signal frame_mosi_support_busy : std_logic;
   signal frame_miso_busy : std_logic;
   signal frame_miso_afull : std_logic;

   signal data_mosi_sof : std_logic;
   signal data_mosi_eof : std_logic;
   signal data_mosi_dval : std_logic;
   signal data_mosi_data : std_logic_vector(DLEN-1 downto 0);
   signal data_mosi_support_busy : std_logic;
   signal data_miso_busy : std_logic;
   signal data_miso_afull : std_logic;

   signal add1_mosi_sof : std_logic;
   signal add1_mosi_eof : std_logic;
   signal add1_mosi_dval : std_logic;
   signal add1_mosi_data : std_logic_vector(ALEN-1 downto 0);
   signal add1_mosi_support_busy : std_logic;
   signal add1_miso_busy : std_logic;
   signal add1_miso_afull : std_logic;

   signal add2_mosi_sof : std_logic;
   signal add2_mosi_eof : std_logic;
   signal add2_mosi_dval : std_logic;
   signal add2_mosi_data : std_logic_vector(ALEN-1 downto 0);
   signal add2_mosi_support_busy : std_logic;
   signal add2_miso_busy : std_logic;
   signal add2_miso_afull : std_logic;
   
   signal ll_1bit_rx_mosi : t_ll_mosi1;
   signal ll_1bit_rx_miso : t_ll_miso;
   signal ll_1bit_tx_mosi : t_ll_mosi1;
   signal ll_1bit_tx_miso : t_ll_miso;
   
   signal rx_ll_mosi : t_ll_mosi32;
   signal rx_ll_miso : t_ll_miso;
   signal tx_ll_mosi : t_ll_mosi32;
   signal tx_ll_miso : t_ll_miso;
   
   signal error_s : std_logic;
   
   signal dump : std_logic_vector(DLEN-2 downto 0);                    
   
   signal drem_ones : std_logic_vector(1 downto 0)  := (others => '1');
   
   signal Ignore_err_AtRst, Ignore_err_AtRst_tmp : std_logic;
   
begin                      
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);

   fifo : locallink_fifo32
   generic map(       
      BusyBreak => false,
      FifoSize => 16,
      Latency => TMI_Latency + 3,
      ASYNC => FALSE
   )
   port map(
      RX_LL_MOSI => rx_ll_mosi,
      RX_LL_MISO => rx_ll_miso,
      CLK_RX => CLK,
      FULL => fifo_full,
      WR_ERR => fifo_error,
      TX_LL_MOSI => tx_ll_mosi,
      TX_LL_MISO => tx_ll_miso,
      CLK_TX => CLK,
      EMPTY => fifo_empty,
      ARESET => ARESET
   );
   
   
   fanout : ll_fanout_generic
   generic map(
      DLEN => ALEN
   )
   port map(
      RX_MOSI_SOF => ADD_LL_SOF,
      RX_MOSI_EOF => ADD_LL_EOF,
      RX_MOSI_DVAL => ADD_LL_DVAL,
      RX_MOSI_DATA => ADD_LL_DATA,
      RX_MOSI_DREM => drem_ones,
      RX_MOSI_SUPPORT_BUSY => ADD_LL_SUPPORT_BUSY,
      RX_MISO_BUSY => ADD_LL_BUSY,
      RX_MISO_AFULL => ADD_LL_AFULL,
      TX1_MOSI_SOF => add1_mosi_sof,
      TX1_MOSI_EOF => add1_mosi_eof,
      TX1_MOSI_DVAL => add1_mosi_dval,
      TX1_MOSI_DATA => add1_mosi_data,
      TX1_MOSI_DREM => open,
      TX1_MOSI_SUPPORT_BUSY => add1_mosi_support_busy,
      TX1_MISO_BUSY => add1_miso_busy,
      TX1_MISO_AFULL => add1_miso_afull,
      TX2_MOSI_SOF => add2_mosi_sof,
      TX2_MOSI_EOF => add2_mosi_eof,
      TX2_MOSI_DVAL => add2_mosi_dval,
      TX2_MOSI_DATA => add2_mosi_data,
      TX2_MOSI_DREM => open,
      TX2_MOSI_SUPPORT_BUSY => add2_mosi_support_busy,
      TX2_MISO_BUSY => add2_miso_busy,
      TX2_MISO_AFULL => add2_miso_afull,
      ARESET => ARESET,
      CLK => CLK
   );

   merger : ll_sof_eof_merger
   generic map(
      DLEN => DLEN,
      DREM_LEN => 2
   )
   port map(
      FRAME_MOSI_SOF => frame_mosi_sof,
      FRAME_MOSI_EOF => frame_mosi_eof,
      FRAME_MOSI_DVAL => frame_mosi_dval,
      FRAME_MOSI_DATA => frame_mosi_data,
      FRAME_MOSI_DREM => drem_ones,
      FRAME_MOSI_SUPPORT_BUSY => frame_mosi_support_busy,
      FRAME_MISO_BUSY => frame_miso_busy,
      FRAME_MISO_AFULL => frame_miso_afull,
      DATA_MOSI_SOF => data_mosi_sof,
      DATA_MOSI_EOF => data_mosi_eof,
      DATA_MOSI_DVAL => data_mosi_dval,
      DATA_MOSI_DATA => data_mosi_data,
      DATA_MOSI_DREM => drem_ones,
      DATA_MOSI_SUPPORT_BUSY => data_mosi_support_busy,
      DATA_MISO_BUSY => data_miso_busy,
      DATA_MISO_AFULL => data_miso_afull,
      TX_MOSI_SOF => RD_LL_SOF,
      TX_MOSI_EOF => RD_LL_EOF,
      TX_MOSI_DVAL => RD_LL_DVAL,
      TX_MOSI_DATA => RD_LL_DATA,
      TX_MOSI_DREM => open,
      TX_MOSI_SUPPORT_BUSY => RD_LL_SUPPORT_BUSY,
      TX_MISO_BUSY => RD_LL_BUSY,
      TX_MISO_AFULL => RD_LL_AFULL,
      ARESET => ARESET,
      CLK => CLK
   );
   
   fifo_1bit : locallink_fifo1
   generic map(
      FifoSize => 16,
      Latency => TMI_Latency,
      ASYNC => FALSE
   )
   port map(
      RX_LL_MOSI => ll_1bit_rx_mosi,
      RX_LL_MISO => ll_1bit_rx_miso,
      CLK_RX => CLK,
      FULL => fifo_1bit_full,
      WR_ERR => fifo_1bit_error,
      TX_LL_MOSI => ll_1bit_tx_mosi,
      TX_LL_MISO => ll_1bit_tx_miso,
      CLK_TX => CLK,
      EMPTY => fifo_1bit_empty,
      ARESET => ARESET
   );
   
   ll_1bit_rx_mosi.dval <= add1_mosi_dval;
   ll_1bit_rx_mosi.sof <= add1_mosi_sof;
   ll_1bit_rx_mosi.eof <= add1_mosi_eof;
   ll_1bit_rx_mosi.data <= add1_mosi_data(0);
   ll_1bit_rx_mosi.support_busy <= '1';
   add1_miso_busy <= ll_1bit_rx_miso.busy;
   add1_miso_afull <= ll_1bit_rx_miso.afull;
   
   frame_mosi_dval <= ll_1bit_tx_mosi.dval;
   frame_mosi_sof <= ll_1bit_tx_mosi.sof;
   frame_mosi_eof <= ll_1bit_tx_mosi.eof;
   dump <= (others => '0');
   frame_mosi_data <= dump & ll_1bit_tx_mosi.data;
   frame_mosi_support_busy <= ll_1bit_tx_mosi.support_busy;
   ll_1bit_tx_miso.busy <= frame_miso_busy;
   ll_1bit_tx_miso.afull <= frame_miso_afull;
   
   data_mosi_sof	<= tx_ll_mosi.sof;
   data_mosi_eof	<= tx_ll_mosi.eof;
   data_mosi_data  <= tx_ll_mosi.data(DLEN-1 downto 0);      
   data_mosi_dval	<= tx_ll_mosi.dval;
   data_mosi_support_busy <= tx_ll_mosi.support_busy;
   tx_ll_miso.busy <= data_miso_busy;      
   tx_ll_miso.afull <= data_miso_afull;
   add2_miso_busy <= TMI_BUSY or rx_ll_miso.busy or rx_ll_miso.afull;
   add2_miso_afull <= '0';
   
   TMI_WR_DATA <= (others => '0');
   TMI_RNW <= '1'; -- Always in read mode
   IDLE <= TMI_IDLE and fifo_empty;
   
   -------------------------------------------------------------------
   -- Error handling: Fifos Full signal is high on reset so we want to
   -- use a streched version of sreset to force error signal to low
   -- at reset.
   -------------------------------------------------------------------
   process(CLK)
   begin
      if rising_edge(CLK) then
         if(sreset = '1') then
            Ignore_err_AtRst_tmp <= '1';
         else
            Ignore_err_AtRst_tmp <= '0';            
         end if; 
         Ignore_err_AtRst <= Ignore_err_AtRst_tmp;
       end if;
   end process;
   
   
   ERROR <= (TMI_ERROR or fifo_full or fifo_1bit_full) and not(Ignore_err_AtRst or sreset);

      
   dval_tmi <= add2_mosi_dval and not TMI_BUSY and not rx_ll_miso.afull;

   process(CLK)
   begin
      if rising_edge(CLK) then
         if(sreset = '1') then
            TMI_DVAL <= '0';
            TMI_ADD <= (others => '0');
         else      
            -- translate_off   
            --assert (TMI_ERROR='0' and fifo_full='0' and fifo_1bit_full='0') report "Error in LL_TMI_read" severity ERROR;
            --assert (fifo_full='0') report "fifo full! please increase the generic TMI_Latency" severity level ERROR;  
                        
            -- translate_on
            if(TMI_BUSY = '0') then
               if (rx_ll_miso.afull = '0') then
                  if (TMI_BUSY = '0' and add2_mosi_dval = '1') then
                     TMI_DVAL <= '1';
                     TMI_ADD <= add2_mosi_data;
                  else
                     TMI_DVAL <= '0';
                  end if;
               else
                  TMI_DVAL <= '0';
               end if;
--            TMI_DVAL <= '0';
--               if(dval_tmi = '1') then
--                  TMI_DVAL <= '1';
--                  TMI_ADD <= add2_mosi_data;
--               end if;
            end if;
         end if;
      end if;
   end process;

--   process(CLK)
--   begin
--      if rising_edge(CLK) then
--         if(sreset = '1') then
--            rx_ll_mosi.dval <= '0';
--            rx_ll_mosi.sof <= '0';
--            rx_ll_mosi.eof <= '0';
--            rx_ll_mosi.data <= (others => '0');
--         else
--            rx_ll_mosi.dval <= '0';
--            if(TMI_RD_DVAL = '1') then
--               rx_ll_mosi.data(DLEN-1 downto 0) <= TMI_RD_DATA;
--               rx_ll_mosi.dval <= '1';
--            end if;
--         end if;
--      end if;
--   end process;
   
   rx_ll_mosi.sof <= '0';
   rx_ll_mosi.eof <= '0';
   rx_ll_mosi.data(DLEN-1 downto 0) <= TMI_RD_DATA;
   rx_ll_mosi.dval <= TMI_RD_DVAL;
   rx_ll_mosi.support_busy <= '1';
   rx_ll_mosi.drem <= (others => '1');
   

   process(CLK)
   begin
      if rising_edge(CLK) then
         if sreset = '1' then
            error_s <= '0';
         else
            if error_s <= '0' then  -- Latch the error
               if TMI_ERROR = '1' or fifo_error = '1' or fifo_1bit_error = '1' then
                  error_s <= '1';
               end if;
            end if;
         end if;
      end if;
   end process;
      
         
   
   
   -- pragma translate_off 
   assert_proc : process(CLK)
   begin       
      if rising_edge(CLK) then
         if sreset = '0' then
            assert (ADD_LL_SUPPORT_BUSY = '1') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;      
            assert (fifo_error = '0') report "Fifo overflow" severity WARNING;
            assert (fifo_1bit_error = '0') report "Fifo 1bit overflow" severity WARNING;
            --assert (TMI_ERROR = '0') report "TMI_ERROR in entity LL_TMI_read.vhd" severity WARNING;
         end if;
      end if;
   end process;
   -- pragma translate_on 
   
end RTL;
