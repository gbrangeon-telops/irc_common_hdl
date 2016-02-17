---------------------------------------------------------------------------------------------------
--                                                      ..`??!````??!..
--                                                  .?!                `1.
--                                               .?`                      i
--                                             .!      ..vY=!``?74.        i
--.........          .......          ...     ?      .Y=` .+wA..   ?,      .....              ...
--"""HMM"""^         MM#"""5         .MM|    :     .H\ .JQgNa,.4o.  j      MM#"MMN,        .MM#"WMF
--   JM#             MMNggg2         .MM|   `      P.;,jMt   `N.r1. ``     MMmJgMM'        .MMMNa,.
--   JM#             MM%````         .MM|   :     .| 1A Wm...JMy!.|.t     .MMF!!`           . `7HMN
--   JMM             MMMMMMM         .MMMMMMM!     W. `U,.?4kZ=  .y^     .!MMt              YMMMMB=
--                                          `.      7&.  ?1+...JY'     J
--                                           ?.        ?""""7`       .?`
--                                             :.                ..?`
--                                               `!...........??`
---------------------------------------------------------------------------------------------------
--
-- Title       : LocalLink_Fifo
-- Design      : VP30
-- Author      : Patrick Daraiche
-- Company     : Telops Inc.
--
--  $Revision: 
--  $Author: 
--  $LastChangedDate:
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;    
library Common_HDL; 
use Common_HDL.Telops.all;

entity LocalLink_Fifo8 is
   generic(
      FifoSize		   : integer := 256;  -- 256
      Latency        : integer := 32;  -- Input module latency (to control RX_LL_MISO.AFULL)      
      ASYNC          : boolean := true);	-- Use asynchronous fifos
   port(
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      RX_LL_MOSI  : in  t_ll_mosi8;
      RX_LL_MISO  : out t_ll_miso;
      CLK_RX 		: in 	std_logic;
      FULL        : out std_logic;
      WR_ERR      : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      TX_LL_MOSI  : out t_ll_mosi8;
      TX_LL_MISO  : in  t_ll_miso;
      CLK_TX 		: in 	std_logic;
      EMPTY       : out std_logic; -- This signal should actually be called "IDLE"
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET		: in std_logic
      );
end LocalLink_Fifo8;

architecture RTL of LocalLink_Fifo8 is 
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component s_fifo_w10_d256
      port(
         clk : in std_logic;
         din : in std_logic_vector(9 downto 0);
         rd_en : in std_logic;
         rst : in std_logic;
         wr_en : in std_logic;
         data_count : out std_logic_vector(7 downto 0);
         dout : out std_logic_vector(9 downto 0);
         empty : out std_logic;
         full : out std_logic;
         overflow : out std_logic;
         valid : out std_logic);
   end component;
   
   component as_fifo_w10_d15
      port (
         din: IN std_logic_VECTOR(9 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(9 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(3 downto 0));
   end component;
   
   component s_fifo_w10_d16
      port (
         clk: IN std_logic;
         din: IN std_logic_VECTOR(9 downto 0);
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_en: IN std_logic;
         data_count: OUT std_logic_VECTOR(3 downto 0);
         dout: OUT std_logic_VECTOR(9 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;
   
   component s_fifo_w10_d32
      port (
         clk: IN std_logic;
         din: IN std_logic_VECTOR(9 downto 0);
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_en: IN std_logic;
         data_count: OUT std_logic_VECTOR(4 downto 0);
         dout: OUT std_logic_VECTOR(9 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;	
   
   component s_fifo_w10_d512
      port (
         clk: IN std_logic;
         din: IN std_logic_VECTOR(9 downto 0);
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_en: IN std_logic;
         data_count: OUT std_logic_VECTOR(8 downto 0);
         dout: OUT std_logic_VECTOR(9 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;
   
   component s_fifo_w10_d1024
      port (
         clk: IN std_logic;
         din: IN std_logic_VECTOR(9 downto 0);
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_en: IN std_logic;
         data_count: OUT std_logic_VECTOR(9 downto 0);
         dout: OUT std_logic_VECTOR(9 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;
   
   
   signal fifo_count_16   : std_logic_vector(3 downto 0);
   signal fifo_count_32   : std_logic_vector(4 downto 0);
   signal fifo_count_256  : std_logic_vector(7 downto 0);
   signal fifo_count_512  : std_logic_vector(8 downto 0); 
   signal fifo_count_1024 : std_logic_vector(9 downto 0);
   --   signal fifo_wr_count_63 : std_logic_vector(5 downto 0);  
   --   signal fifo_wr_count_511 : std_logic_vector(8 downto 0);
   --   signal fifo_wr_count_8191 : std_logic_vector(12 downto 0);
   signal fifo_dout : std_logic_vector(9 downto 0);
   signal fifo_din : std_logic_vector(9 downto 0);
   signal fifo_rd_ack : std_logic;			
   signal fifo_rd_en : std_logic;
   
   signal hold_dval  : std_logic;
   signal TX_DVAL_buf: std_logic;
   signal FULLi      : std_logic;    
   signal AFULLi     : std_logic;    
   signal WR_ERRi    : std_logic;
   signal EMPTYi     : std_logic;
   signal fifo_wr_en : std_logic;
   
   signal FoundGenCase : boolean;      
   signal RESET_TX : std_logic;                  
   signal RESET_RX : std_logic;   
   
   -- This signal is for debug only and will be optimized out by xst
   signal tx_cnt     : unsigned(31 downto 0); 
   --   attribute keep    : string; 
   --   attribute keep of tx_cnt : signal is "true";     
   
begin      
   
   sync_RESET_TX :  sync_reset
   port map(ARESET => ARESET, SRESET => RESET_TX, CLK => CLK_TX); 
   
   sync_RESET_RX :  sync_reset
   port map(ARESET => ARESET, SRESET => RESET_RX, CLK => CLK_RX);
   
   gen_8_16 : if (FifoSize <= 16 and not ASYNC) generate
      begin
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_count_16) > (15-(Latency+1)) or FULLi = '1') else '0';
      s_fifo_w10_d16_inst : s_fifo_w10_d16
      port map(
         clk => CLK_RX,
         din => fifo_din,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_en => fifo_wr_en,
         data_count => fifo_count_16,
         dout => fifo_dout,
         empty => EMPTYi,
         full => FULLi,
         overflow => WR_ERRi,
         valid => fifo_rd_ack
         );
   end generate gen_8_16;
   
   gen_8_32 : if (FifoSize > 16 and FifoSize <= 32 and not ASYNC) generate
      begin
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_count_32) > (15-(Latency+1)) or FULLi = '1') else '0';
      s_fifo_w10_d32_inst : s_fifo_w10_d32
      port map(
         clk => CLK_RX,
         din => fifo_din,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_en => fifo_wr_en,
         data_count => fifo_count_32,
         dout => fifo_dout,
         empty => EMPTYi,
         full => FULLi,
         overflow => WR_ERRi,
         valid => fifo_rd_ack
         );
   end generate gen_8_32;
   
   gen_8_256 : if (FifoSize > 32 and FifoSize <= 256 and not ASYNC) generate
      begin
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_count_256) > (255-(Latency+1)) or FULLi = '1') else '0';
      s_fifo_w10_d256_inst : s_fifo_w10_d256
      port map(
         clk => CLK_RX,
         din => fifo_din,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_en => fifo_wr_en,
         data_count => fifo_count_256,
         dout => fifo_dout,
         empty => EMPTYi,
         full => FULLi,
         overflow => WR_ERRi,
         valid => fifo_rd_ack
         );
   end generate gen_8_256;	
   
   gen_8_512 : if (FifoSize > 256 and FifoSize <= 512 and not ASYNC) generate
      begin
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_count_512) > (511-(Latency+1)) or FULLi = '1') else '0';
      s_fifo_w10_d512_inst : s_fifo_w10_d512
      port map(
         clk => CLK_RX,
         din => fifo_din,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_en => fifo_wr_en,         
         data_count => fifo_count_512,
         dout => fifo_dout,
         empty => EMPTYi,
         full => FULLi,
         overflow => WR_ERRi,
         valid => fifo_rd_ack
         );
   end generate gen_8_512;	 
   
   gen_8_1024 : if (FifoSize > 512 and FifoSize <= 1024 and not ASYNC) generate
      begin
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_count_1024) > (1023-(Latency+1)) or FULLi = '1') else '0';
      s_fifo_w10_d1024_inst : s_fifo_w10_d1024
      port map(
         clk => CLK_RX,
         din => fifo_din,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_en => fifo_wr_en,
         data_count => fifo_count_1024,
         dout => fifo_dout,
         empty => EMPTYi,
         full => FULLi,
         overflow => WR_ERRi,
         valid => fifo_rd_ack
         );
   end generate gen_8_1024;	 
   
   
   gen_8_15 : if (FifoSize <= 16 and ASYNC) generate
      begin
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_count_16) > (15-(Latency+1)) or FULLi = '1') else '0';
      as_fifo_w10_d15_inst : as_fifo_w10_d15
      port map (
         din => fifo_din,
         wr_en => fifo_wr_en,
         rd_clk => CLK_TX,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         wr_clk => CLK_RX,
         dout => fifo_dout,
         full => FULLi,
         overflow => WR_ERRi,
         empty => EMPTYi,
         wr_data_count => fifo_count_16,
         valid => fifo_rd_ack);      
   end generate gen_8_15;		
   
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   
   -- Fifo write control
   fifo_wr_en <= RX_LL_MOSI.DVAL and not FULLi;
   
   -- Fifo read control
   fifo_rd_en <= not TX_LL_MISO.AFULL and not (TX_LL_MISO.BUSY and TX_DVAL_buf);
   
   -- Write interface signals
   fifo_din <= (RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA);	
   
   -- OUTPUT MAPPING                       
   TX_LL_MOSI.DVAL <= TX_DVAL_buf when FoundGenCase else '0';
   TX_DVAL_buf <= fifo_rd_ack or hold_dval;
   TX_LL_MOSI.DATA <= fifo_dout(7 downto 0) when FoundGenCase else (others => '0');
   TX_LL_MOSI.EOF <= fifo_dout(8) when FoundGenCase else '0';	 
   TX_LL_MOSI.SOF <= fifo_dout(9) when FoundGenCase else '0';                  
   
   FULL <= FULLi when FoundGenCase else '1'; 
   --RX_LL_MISO.AFULL <= AFULLi when FoundGenCase else '1'; 
   
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
   
   
   RX_LL_MISO.BUSY <= FULLi or RESET_RX;
   WR_ERR <= WR_ERRi when FoundGenCase else '0'; 
   
   -- DVALID latch (when RX is not ready, all we have to do is hold the DVal signal, the fifo interface does the rest)
   tx_proc : process (CLK_TX)
   begin	
      if rising_edge(CLK_TX) then
         if RESET_TX = '1' then
            hold_dval <= '0';
            tx_cnt <= (others => '0');
         else
            if TX_DVAL_buf = '1' and TX_LL_MISO.BUSY = '0' then
               tx_cnt <= tx_cnt + 1;
            end if;
            
            hold_dval <= TX_LL_MISO.BUSY and TX_DVAL_buf;  
            -- pragma translate_off   
            assert (FoundGenCase or FifoSize = 0) report "Invalid LocalLink fifo generic settings!" severity FAILURE;
            if FoundGenCase then
               assert (WR_ERRi /= '1') report "LocalLink fifo overflow!!!" severity ERROR;
            end if;
            -- pragma translate_on
         end if;		
      end if;
   end process;   
   
   rx_proc : process (CLK_RX)
      variable empty_mid : std_logic;
   begin	
      if rising_edge(CLK_RX) then
         if RESET_RX = '1' or EMPTYi = '0' or TX_DVAL_buf = '1' then
            empty_mid := '0';
            EMPTY <= '0';
         else
            empty_mid := EMPTYi;
            EMPTY <= empty_mid;
         end if;		
      end if;
   end process;
   
end RTL;
