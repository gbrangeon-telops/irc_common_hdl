---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: LocalLink_Fifo64.vhd
--  Use: Fifo with standardized LocaLlink Interface
--  By: Patrick Dubois & Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
--  OBO : Dec 5, 2006 - ported to 64 bit data path width for CameraLink
--  OBO : June 12, 2007 converted for use with new MOSI.DREM LocalLink field
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity LocalLink_Fifo64 is
   generic(
      FifoSize : integer := 512;  
      Latency : integer := 10;  -- Input module latency (to control RX_LL_MISO.AFULL)      
      ASYNC : boolean := false);	-- Use asynchronous fifos
   port(
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      RX_LL_MOSI  : in  t_ll_mosi64;
      RX_LL_MISO  : out t_ll_miso;
      CLK_RX 	    : in std_logic;
      FULL        : out std_logic;
      WR_ERR      : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      TX_LL_MOSI  : out t_ll_mosi64;
      TX_LL_MISO  : in  t_ll_miso;
      CLK_TX 	    : in std_logic;
      RD_CNT      : out std_logic_vector(13 downto 0);
      EMPTY       : out std_logic; 
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET	  : in std_logic);
end LocalLink_Fifo64;

architecture rtl of LocalLink_Fifo64 is
   
   -- explicit component declarations because sometimes they are in Common_HDL (sim) and sometimes they are in work (synthesis)
   component s_fifo_w72_d16 is
      port (
         din         : in std_logic_vector(71 downto 0);  
         wr_en       : in std_logic;
         clk         : in std_logic;
         rd_en       : in std_logic;
         rst         : in std_logic;
         dout        : out std_logic_vector(71 downto 0);
         full        : out std_logic;
         overflow    : out std_logic;
         empty       : out std_logic;
         data_count  : out std_logic_vector(3 downto 0);
         valid       : out std_logic);
   end component;
   
   component s_fifo_w72_d512 is
      port (
         din         : in std_logic_vector(71 downto 0);  
         wr_en       : in std_logic;
         clk         : in std_logic;
         rd_en       : in std_logic;
         rst         : in std_logic;
         dout        : out std_logic_vector(71 downto 0);
         full        : out std_logic;
         overflow    : out std_logic;
         empty       : out std_logic;
         data_count  : out std_logic_vector(8 downto 0);
         valid       : out std_logic);
   end component;
   
   component as_fifo_w72_d511
      port (
         din: IN std_logic_VECTOR(71 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(71 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         rd_data_count: OUT std_logic_VECTOR(8 downto 0);
         wr_data_count: OUT std_logic_VECTOR(8 downto 0));
   end component;
   
   component as_fifo_w72_d15
      port (
         din: IN std_logic_VECTOR(71 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(71 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(3 downto 0));
   end component;
   
   component as_fifo_w72_d2047 is
      port (
         din           : in std_logic_vector(71 downto 0);  
         wr_en         : in std_logic;
         wr_clk        : in std_logic;
         rd_en         : in std_logic;
         rd_clk        : in std_logic;
         rst           : in std_logic;
         dout          : out std_logic_vector(71 downto 0);
         full          : out std_logic;
         overflow      : out std_logic;
         empty         : out std_logic;
         wr_data_count : out std_logic_vector(10 downto 0);
         rd_data_count : out std_logic_vector(10 downto 0);
         valid         : out std_logic);
   end component;   
   
   component as_fifo_w72_d4095 is
      port (
         din           : in std_logic_vector(71 downto 0);  
         wr_en         : in std_logic;
         wr_clk        : in std_logic;
         rd_en         : in std_logic;
         rd_clk        : in std_logic;
         rst           : in std_logic;
         dout          : out std_logic_vector(71 downto 0);
         full          : out std_logic;
         overflow      : out std_logic;
         empty         : out std_logic;
         wr_data_count : out std_logic_vector(11 downto 0);
         rd_data_count : out std_logic_vector(11 downto 0);
         valid         : out std_logic);
   end component;
   
   component as_fifo_w72_d8191 is
      port (
         din           : in std_logic_vector(71 downto 0);  
         wr_en         : in std_logic;
         wr_clk        : in std_logic;
         rd_en         : in std_logic;
         rd_clk        : in std_logic;
         rst           : in std_logic;
         dout          : out std_logic_vector(71 downto 0);
         full          : out std_logic;
         overflow      : out std_logic;
         empty         : out std_logic;
         wr_data_count : out std_logic_vector(12 downto 0);
         rd_data_count : out std_logic_vector(12 downto 0);
         valid         : out std_logic);
   end component;
   
   component as_fifo_w72_d16383 is
      port (
         din           : in std_logic_vector(71 downto 0);  
         wr_en         : in std_logic;
         wr_clk        : in std_logic;
         rd_en         : in std_logic;
         rd_clk        : in std_logic;
         rst           : in std_logic;
         dout          : out std_logic_vector(71 downto 0);
         full          : out std_logic;
         overflow      : out std_logic;
         empty         : out std_logic;
         wr_data_count : out std_logic_vector(13 downto 0);
         rd_data_count : out std_logic_vector(13 downto 0);
         valid         : out std_logic);
   end component;   
	
   component SYNC_RESET is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;	
    
   signal fifo_wr_count_16 : std_logic_vector(3 downto 0);
   signal fifo_rd_count_16 : std_logic_vector(3 downto 0);
   signal fifo_wr_count_512 : std_logic_vector(8 downto 0);
   signal fifo_rd_count_512 : std_logic_vector(8 downto 0);
   signal fifo_wr_count_2048 : std_logic_vector(10 downto 0);
   signal fifo_rd_count_2048 : std_logic_vector(10 downto 0);   
   signal fifo_wr_count_4096 : std_logic_vector(11 downto 0);
   signal fifo_rd_count_4096 : std_logic_vector(11 downto 0);
   signal fifo_wr_count_8192 : std_logic_vector(12 downto 0);
   signal fifo_rd_count_8192 : std_logic_vector(12 downto 0);
   signal fifo_wr_count_16384 : std_logic_vector(13 downto 0);
   signal fifo_rd_count_16384 : std_logic_vector(13 downto 0);   
   signal fifo_dout : std_logic_vector(71 downto 0);
   signal fifo_din : std_logic_vector(71 downto 0);
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
   
begin
   
   -- synchronize reset locally
   sync_RESET_TX : sync_reset port map(ARESET => ARESET, SRESET => RESET_TX, CLK => CLK_TX);
   sync_RESET_RX : sync_reset port map(ARESET => ARESET, SRESET => RESET_RX, CLK => CLK_RX);
   
   -- synchrnonous fifo types...
   sgen_w72_d16 : if (FIfoSize > 0 and FifoSize <= 16 and not ASYNC) generate
      begin                  
      FoundGenCase <= true;                   
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_16) > (16-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
      s_fifo_w72_d16_inst : s_fifo_w72_d16
      port map (
         din => fifo_din,   
         wr_en => fifo_dval,               
         clk => CLK_RX,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         dout => fifo_dout,
         full => FULLi,
         overflow => WR_ERRi,
         empty => EMPTYi,
         data_count => fifo_wr_count_16,
         valid => fifo_rd_ack);         
   end generate sgen_w72_d16;
   
   sgen_w72_d512 : if (FifoSize > 16 and FifoSize <= 512 and not ASYNC) generate
      begin                  
      FoundGenCase <= true;                   
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_512) > (512-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
      s_fifo_w72_d512_inst : s_fifo_w72_d512
      port map (
         din => fifo_din,   
         wr_en => fifo_dval,               
         clk => CLK_RX,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         dout => fifo_dout,
         full => FULLi,
         overflow => WR_ERRi,
         empty => EMPTYi,
         data_count => fifo_wr_count_512,
         valid => fifo_rd_ack);         
   end generate sgen_w72_d512;
   
   -- asynchrnonous fifo types...
   asgen_w72_d15 : if (FIfoSize > 0 and FifoSize <= 15 and ASYNC) generate
      begin                  
      FoundGenCase <= true;                   
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_16) > (15-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
      
      as_fifo_w72_d15_inst : as_fifo_w72_d15
      port map (
         din => fifo_din,
         rd_clk => CLK_TX,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_clk => CLK_RX,
         wr_en => fifo_dval,
         dout => fifo_dout,
         empty => EMPTYi,
         full => FULLi,
         overflow => WR_ERRi,
         valid => fifo_rd_ack,
         wr_data_count => fifo_wr_count_16);      
      
   end generate asgen_w72_d15;
   
   asgen_w72_d511 : if (FifoSize > 15 and FifoSize <= 511 and ASYNC) generate
      begin                  
      FoundGenCase <= true;
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_512) > (511-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
      
      RD_CNT <= std_logic_vector(resize(unsigned(fifo_rd_count_512), RD_CNT'length));
      
      as_fifo_w72_d511_inst : as_fifo_w72_d511
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
         wr_data_count => fifo_wr_count_512,
         rd_data_count => fifo_rd_count_512,
         valid => fifo_rd_ack);         
   end generate asgen_w72_d511;
   
   asgen_w72_d2047 : if (FifoSize > 511 and FifoSize <= 2047 and ASYNC) generate
      begin                  
      FoundGenCase <= true;
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_2048) > (2047-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
            
      RD_CNT <= std_logic_vector(resize(unsigned(fifo_rd_count_2048), RD_CNT'length));
      
      as_fifo_w72_d2047_inst : as_fifo_w72_d2047
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
         wr_data_count => fifo_wr_count_2048,
         rd_data_count => fifo_rd_count_2048,
         valid => fifo_rd_ack);         
   end generate asgen_w72_d2047;   
   
   asgen_w72_d4095 : if (FifoSize > 2047 and FifoSize <= 4095 and ASYNC) generate
      begin                  
      FoundGenCase <= true;
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_4096) > (4095-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
            
      RD_CNT <= std_logic_vector(resize(unsigned(fifo_rd_count_4096), RD_CNT'length));      
      
      as_fifo_w72_d4095_inst : as_fifo_w72_d4095
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
         wr_data_count => fifo_wr_count_4096,
         rd_data_count => fifo_rd_count_4096,
         valid => fifo_rd_ack);         
   end generate asgen_w72_d4095;
   
   asgen_w72_d8191 : if (FifoSize > 4095 and FifoSize <= 8191 and ASYNC) generate
      begin                  
      FoundGenCase <= true;
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_8192) > (8191-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
            
      RD_CNT <= std_logic_vector(resize(unsigned(fifo_rd_count_8192), RD_CNT'length));      
      
      as_fifo_w72_d8191_inst : as_fifo_w72_d8191
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
         wr_data_count => fifo_wr_count_8192,
         rd_data_count => fifo_rd_count_8192,
         valid => fifo_rd_ack);         
   end generate asgen_w72_d8191;
   
   asgen_w72_d16383 : if (FifoSize > 8191 and FifoSize <= 16383 and ASYNC) generate
      begin                  
      FoundGenCase <= true;
      TX_DVAL_buf <= fifo_rd_ack or hold_dval;
      disable_afull : if Latency = 0 generate
         AFULLi <= '0';
      end generate disable_afull;
      enable_afull : if Latency > 0 generate
         AFULLi <= '1' when (unsigned(fifo_wr_count_16384) > (16383-(Latency+1)) or FULLi = '1') else '0'; 
      end generate enable_afull;
      
      RD_CNT <= std_logic_vector(resize(unsigned(fifo_rd_count_16384), RD_CNT'length));     
      
      as_fifo_w72_d16383_inst : as_fifo_w72_d16383
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
         wr_data_count => fifo_wr_count_16384,
         rd_data_count => fifo_rd_count_16384,
         valid => fifo_rd_ack);         
   end generate asgen_w72_d16383;   
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   
   -- Fifo read control
   fifo_rd_en <= not TX_LL_MISO.AFULL and not (TX_LL_MISO.BUSY and TX_DVAL_buf);
   
   -- Write interface signals
   fifo_din <= ("000" & RX_LL_MOSI.DREM & RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA);    
   
	-- Fifo write control.            
   -- If SUPPORT_BUSY=0, the busy signal is ignored so we can't use RX_BUSYi.
   fifo_dval <= (RX_LL_MOSI.DVAL and not RX_BUSYi) when (RX_LL_MOSI.SUPPORT_BUSY='1') else RX_LL_MOSI.DVAL;   
   
   -- OUTPUT MAPPING                       
   TX_LL_MOSI.DVAL <= TX_DVAL_buf when FoundGenCase else '0';
   
   TX_LL_MOSI.DATA <= fifo_dout(63 downto 0) when FoundGenCase else (others => '0');
   TX_LL_MOSI.EOF <= fifo_dout(64) when FoundGenCase else '0';	 
   TX_LL_MOSI.SOF <= fifo_dout(65) when FoundGenCase else '0';
   TX_LL_MOSI.DREM <= fifo_dout(68 downto 66) when FoundGenCase else "000";                  
   
   no_latency : if Latency = 0 generate
      RX_LL_MISO.AFULL <= '0';
   end generate no_latency;
   
   with_latency : if Latency > 0 generate   
      -- PDU: We register AFULL to help timing closure. Anyway one extra clock cycle on 
      -- AFULL should not matter in the vast majority of cases. Just to make sure, we
      -- added +1 to the generic Latency.
      process (CLK_RX)
      begin                  
         if rising_edge(CLK_RX) then      
            if FoundGenCase then
               RX_LL_MISO.AFULL <= AFULLi or RESET_RX;
            else
               RX_LL_MISO.AFULL <= '1';   
            end if;    
         end if;
      end process;
   end generate with_latency;   
   
   RX_BUSYi <= FULLi or RESET_RX; -- we must be busy during the reset
   RX_LL_MISO.BUSY <= RX_BUSYi;
   
   FULL <= FULLi when FoundGenCase else '1';
   EMPTY <= EMPTYi when FoundGenCase else '1';
   WR_ERR <= WR_ERRi when FoundGenCase else '0'; 
   
   -- DVALID latch (when RX is not ready, all we have to do is hold the DVal signal, the fifo interface does the rest)
   tx_proc : process (CLK_TX)
   begin	
      if rising_edge(CLK_TX) then
         if RESET_TX = '1' then
            hold_dval <= '0'; 
         else       
            hold_dval <= TX_LL_MISO.BUSY and TX_DVAL_buf;  
            -- translate_off
            assert (FoundGenCase or FifoSize = 0) report "Invalid LocalLink fifo generic settings!" severity FAILURE;
            if FoundGenCase then
               assert (WR_ERRi = '0') report "LocalLink fifo overflow!!!" severity ERROR;
            end if;
            -- translate_on
         end if;		
      end if;
   end process;   
   
end rtl;
