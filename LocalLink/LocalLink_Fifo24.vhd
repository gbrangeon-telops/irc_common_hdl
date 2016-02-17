---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: LocalLink_Fifo24.vhd
--  Use: Fifo with standardized LocaLlink Interface
--  By: Patrick Dubois & Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  OBO : June 12, 2007 converted for use with new MOSI.DREM LocalLink field
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;    
library Common_HDL; 
use Common_HDL.Telops.all;


entity LocalLink_Fifo24 is
   generic(                            
      BusyBreak      : boolean := true;   -- Add a LL_BusyBreak component to get completely registered outputs
      FifoSize		   : integer := 512;    -- 512 is minimal size with block ram (1 bram used)
      Latency        : integer := 0;      -- Input module latency (to control RX_LL_MISO.AFULL)      
      ASYNC          : boolean := false);	-- Use asynchronous fifos
   port(
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      RX_MOSI     : in  t_ll_mosi24;
      RX_MISO     : out t_ll_miso;
      CLK_RX 		: in 	std_logic;
      FULL        : out std_logic;
      WR_ERR      : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      TX_MOSI     : out t_ll_mosi24;
      TX_MISO     : in  t_ll_miso;
      CLK_TX 		: in 	std_logic;
      EMPTY       : out std_logic; -- This signal should actually be called "IDLE"
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET		: in std_logic
      );
end LocalLink_Fifo24;

architecture RTL of LocalLink_Fifo24 is      
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
	component ll_busybreak_24
	port(
		RX_MOSI : in t_ll_mosi24;
		RX_MISO : out t_ll_miso;
		TX_MOSI : out t_ll_mosi24;
		TX_MISO : in t_ll_miso;
		ARESET : in STD_LOGIC;
		CLK : in STD_LOGIC);
	end component; 
     
   
   component as_fifo_w26_d15
      port (
         din: IN std_logic_VECTOR(25 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(25 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(3 downto 0));
   end component;
      
   signal fifo_wr_count_16 : std_logic_vector(3 downto 0);
   signal fifo_rd_count_16 : std_logic_vector(3 downto 0);
   signal fifo_wr_count_64 : std_logic_vector(5 downto 0);
   signal fifo_wr_count_512 : std_logic_vector(8 downto 0);
   signal fifo_rd_count_512 : std_logic_vector(8 downto 0); 
   signal fifo_wr_count_2048 : std_logic_vector(10 downto 0); 
   signal fifo_wr_count_8192 : std_logic_vector(12 downto 0); 
   signal fifo_wr_count_32768 : std_logic_vector(14 downto 0); 
   signal fifo_dout : std_logic_vector(25 downto 0);
   signal fifo_din : std_logic_vector(25 downto 0);
   signal fifo_rd_ack : std_logic;			
   signal fifo_rd_en : std_logic;    
   signal fifo_dval : std_logic;
   
   signal hold_dval  : std_logic;
   signal TX_DVAL_buf: std_logic;
   signal FULLi      : std_logic;    
   signal RX_BUSYi   : std_logic;
   signal AFULLi     : std_logic;    
   signal WR_ERRi    : std_logic;
   signal EMPTYi     : std_logic;
   
   signal FoundGenCase : boolean := FALSE;      
   signal RESET_TX : std_logic;                  
   signal RESET_RX : std_logic;     
   
   signal txmosi  : t_ll_mosi24;
   signal txmiso  : t_ll_miso;   
   
begin      
   
   -- synchronize reset locally
   sync_RESET_TX :  sync_reset port map(ARESET => ARESET, SRESET => RESET_TX, CLK => CLK_TX); 
   sync_RESET_RX :  sync_reset port map(ARESET => ARESET, SRESET => RESET_RX, CLK => CLK_RX);
   

   
   -- asynchrnonous fifo types...
   asgen_w26_d15 : if (FifoSize > 0 and FifoSize <= 15 and ASYNC) generate
      begin                  
      FoundGenCase <= true;                   
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_16) > (15-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
      as_fifo_w26_d15_inst : as_fifo_w26_d15
      port map (
         din => fifo_din,
         wr_en => fifo_dval,
         rd_clk => CLK_TX,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_clk => CLK_RX,
         dout => fifo_dout,
         full => FULLi,
         overflow => WR_ERRi,
         empty => EMPTYi,
         wr_data_count => fifo_wr_count_16,
         valid => fifo_rd_ack);        
   end generate asgen_w26_d15;       
   


   
   txmosi.SUPPORT_BUSY <= '1';
   
   -- Fifo read control
   fifo_rd_en <= not txmiso.AFULL and not (txmiso.BUSY and TX_DVAL_buf);
   
   -- Write interface signals
   fifo_din <= (RX_MOSI.SOF & RX_MOSI.EOF & RX_MOSI.DATA);
   
   -- Fifo write control.            
   -- If SUPPORT_BUSY=0, the busy signal is ignored so we can't use RX_BUSYi.
   fifo_dval <= (RX_MOSI.DVAL and not RX_BUSYi) when (RX_MOSI.SUPPORT_BUSY='1') else RX_MOSI.DVAL;    
   
   -- OUTPUT MAPPING                       
   txmosi.DVAL <= TX_DVAL_buf when FoundGenCase else '0';
   
   txmosi.DATA <= fifo_dout(23 downto 0) when FoundGenCase else (others => '0');
   txmosi.EOF <= fifo_dout(24) when FoundGenCase else '0';	 
   txmosi.SOF <= fifo_dout(25) when FoundGenCase else '0';
                
   
   no_latency : if Latency = 0 generate
      RX_MISO.AFULL <= '0';
   end generate no_latency;
   
   with_latency : if Latency > 0 generate   
      -- PDU: We register AFULL to help timing closure. Anyway one extra clock cycle on 
      -- AFULL should not matter in the vast majority of cases. Just to make sure, we
      -- added +1 to the generic Latency.
      process (CLK_RX)
      begin                  
         if rising_edge(CLK_RX) then      
            if FoundGenCase then
               RX_MISO.AFULL <= AFULLi or RESET_RX;
            else
               RX_MISO.AFULL <= '1';   
            end if;    
         end if;
      end process;
   end generate with_latency;
   
   RX_BUSYi <= FULLi or RESET_RX;
   RX_MISO.BUSY <= RX_BUSYi;
   
   FULL <= FULLi when FoundGenCase else '1';
   EMPTY <= EMPTYi when FoundGenCase else '1';
   WR_ERR <= WR_ERRi when FoundGenCase else '0';     
   
   gen_break : if (BusyBreak) generate
      begin             
      BB : ll_busybreak_24
      port map(
         RX_MOSI => txmosi,
         RX_MISO => txmiso,
         TX_MOSI => TX_MOSI,
         TX_MISO => TX_MISO,
         ARESET => ARESET,
         CLK => CLK_TX
         );               
   end generate gen_break;  
   
   not_gen_break : if (not BusyBreak) generate
      begin             
      TX_MOSI <= txmosi;
      txmiso <= TX_MISO;        
   end generate not_gen_break;   
   
   -- DVALID latch (when RX is not ready, all we have to do is hold the DVal signal, the fifo interface does the rest)
   tx_proc : process (CLK_TX)
   begin	
      if rising_edge(CLK_TX) then
         if RESET_TX = '1' then
            hold_dval <= '0'; 
         else       
            hold_dval <= txmiso.BUSY and TX_DVAL_buf;  
            -- translate_off
            assert (FoundGenCase or FifoSize = 0) report "Invalid LocalLink fifo generic settings!" severity FAILURE;
            if FoundGenCase then
               assert (WR_ERRi = '0') report "LocalLink fifo overflow!!!" severity ERROR;
            end if;
            -- translate_on
         end if;		
      end if;
   end process; 
   
end RTL;
