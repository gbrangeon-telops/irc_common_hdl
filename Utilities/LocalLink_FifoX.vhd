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
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;    
-- pragma translate_off
library Common_HDL; 
-- pragma translate_on

entity LocalLink_FifoX is
   generic(
      FifoSize		   : integer := 63;  -- 63, 511 or 8191
      Latency        : integer := 32;  -- Input module latency (to control RX_AFULL)
      W              : integer := 16;  -- Width (16 or 21)
      ASYNC          : boolean := true);	-- Use asynchronous fifos
   port(
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      RX_SOF			: in	std_logic;
      RX_EOF			: in	std_logic;
      RX_DATA			: in	std_logic_vector(W-1 downto 0);
      RX_DVAL			: in	std_logic;
      RX_AFULL			: out	std_logic;
      CLK_RX 			: in 	std_logic;
      FULL           : out std_logic;
      WR_ERR         : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      TX_SOF			: out std_logic;
      TX_EOF			: out std_logic;
      TX_DATA			: out	std_logic_vector(W-1 downto 0);
      TX_DVAL			: out std_logic;
      TX_BUSY			: in 	std_logic;
      TX_AFULL			: in 	std_logic;
      CLK_TX 			: in 	std_logic;
      EMPTY          : out std_logic;
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET				: in std_logic
      );
end LocalLink_FifoX;

architecture RTL of LocalLink_FifoX is   
   component s_fifo_w18_d16
      port (
         clk: IN std_logic;
         din: IN std_logic_VECTOR(17 downto 0);
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_en: IN std_logic;
         almost_full: OUT std_logic;
         data_count: OUT std_logic_VECTOR(3 downto 0);
         dout: OUT std_logic_VECTOR(17 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;
   
   component as_fifo_w18_d63
      port (
         din: IN std_logic_VECTOR(17 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         almost_full: OUT std_logic;
         dout: OUT std_logic_VECTOR(17 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(5 downto 0));
   end component;
   
   component as_fifo_w23_d63
      port (
         din: IN std_logic_VECTOR(22 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         almost_full: OUT std_logic;
         dout: OUT std_logic_VECTOR(22 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(5 downto 0));
   end component;   
   
   component as_fifo_w23_d511
      port (
         din: IN std_logic_VECTOR(22 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         almost_full: OUT std_logic;
         dout: OUT std_logic_VECTOR(22 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(8 downto 0));
   end component;    
   
   component as_fifo_w18_d511
      port (
         din: IN std_logic_VECTOR(17 downto 0);
         wr_en: IN std_logic;
         wr_clk: IN std_logic;
         rd_en: IN std_logic;
         rd_clk: IN std_logic;
         rst: IN std_logic;
         dout: OUT std_logic_VECTOR(17 downto 0);
         full: OUT std_logic;
         empty: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(8 downto 0);
         valid: OUT std_logic;
         overflow: OUT std_logic);
   end component; 
   
   component as_fifo_w18_d8191
      port (
         din: IN std_logic_VECTOR(17 downto 0);
         wr_en: IN std_logic;
         wr_clk: IN std_logic;
         rd_en: IN std_logic;
         rd_clk: IN std_logic;
         rst: IN std_logic;
         dout: OUT std_logic_VECTOR(17 downto 0);
         full: OUT std_logic;
         empty: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(12 downto 0);
         valid: OUT std_logic;
         overflow: OUT std_logic);
   end component;
   
   signal fifo_count_16 : std_logic_vector(3 downto 0);
   signal fifo_wr_count_63 : std_logic_vector(5 downto 0);  
   signal fifo_wr_count_511 : std_logic_vector(8 downto 0);
   signal fifo_wr_count_8191 : std_logic_vector(12 downto 0);
   signal fifo_dout : std_logic_vector(W+1 downto 0);
   signal fifo_din : std_logic_vector(W+1 downto 0);
   signal fifo_rd_ack : std_logic;			
   signal fifo_rd_en : std_logic;
   
   signal hold_dval : std_logic;
   signal TX_DVAL_buf : std_logic;
   signal FULLi : std_logic;    
   signal RX_AFULLi : std_logic;    
   signal WR_ERRi : std_logic;
   
   signal FoundGenCase : boolean;      
   signal RESET_TX : std_logic;
   
begin      
   
   sync_RESET_inst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET_TX, CLK => CLK_TX);
   
   gen_16_16 : if (FifoSize = 16 and W = 16 and not ASYNC) generate
      begin      
      FoundGenCase <= true;
      RX_AFULLi <= '1' when (unsigned(fifo_count_16) > (15-Latency) or FULLi = '1') else '0'; 
      s_fifo_w18_d16_inst : s_fifo_w18_d16
      port map (
         din => fifo_din,
         wr_en => RX_DVAL,
         clk => CLK_RX,
         rd_en => fifo_rd_en,
         rst => RESET_TX,
         dout => fifo_dout,
         full => FULLi,
         overflow => WR_ERRi,
         almost_full => open,
         empty => EMPTY,
         data_count => fifo_count_16,
         valid => fifo_rd_ack);         
   end generate gen_16_16;
   
   gen_63_16 : if (FifoSize = 63 and W = 16 and ASYNC) generate
      begin           
      FoundGenCase <= true;
      RX_AFULLi <= '1' when (unsigned(fifo_wr_count_63) > (63-Latency) or FULLi = '1') else '0'; -- 32
      as_fifo_w18_d63_inst : as_fifo_w18_d63
      port map (
         din => fifo_din,
         wr_en => RX_DVAL,
         wr_clk => CLK_RX,
         rd_en => fifo_rd_en,
         rd_clk => CLK_TX,
         rst => ARESET,
         dout => fifo_dout,
         full => FULLi,
         overflow => WR_ERRi,
         almost_full => open,
         empty => EMPTY,
         wr_data_count => fifo_wr_count_63,
         valid => fifo_rd_ack);         
   end generate gen_63_16;       
   
   gen_63_21 : if (FifoSize = 63 and W = 21 and ASYNC) generate
      begin            
      FoundGenCase <= true;
      RX_AFULLi <= '1' when (unsigned(fifo_wr_count_63) > (63-Latency) or FULLi = '1') else '0'; -- 32
      as_fifo_w23_d63_inst : as_fifo_w23_d63
      port map (
         din => fifo_din,
         wr_en => RX_DVAL,
         wr_clk => CLK_RX,
         rd_en => fifo_rd_en,
         rd_clk => CLK_TX,
         rst => ARESET,
         dout => fifo_dout,
         full => FULLi,
         overflow => WR_ERRi,
         almost_full => open,
         empty => EMPTY,
         wr_data_count => fifo_wr_count_63,
         valid => fifo_rd_ack);         
   end generate gen_63_21;   
   
   gen_511_16 : if (FifoSize = 511 and W = 16 and ASYNC) generate
      begin       
      FoundGenCase <= true;
      RX_AFULLi <= '1' when (unsigned(fifo_wr_count_511) > (511-Latency) or FULLi = '1') else '0'; -- 332
      as_fifo_w18_d511_inst : as_fifo_w18_d511
      port map (
         din => fifo_din,
         wr_en => RX_DVAL,
         wr_clk => CLK_RX,
         rd_en => fifo_rd_en,
         rd_clk => CLK_TX,
         rst => ARESET,
         dout => fifo_dout,
         full => FULLi,
         empty => EMPTY,
         wr_data_count => fifo_wr_count_511,
         valid => fifo_rd_ack,
         overflow => WR_ERRi);
      
   end generate gen_511_16;   
   
   gen_511_21 : if (FifoSize = 511 and W = 21 and ASYNC) generate
      begin      
      FoundGenCase <= true;
      RX_AFULLi <= '1' when (unsigned(fifo_wr_count_511) > (511-Latency) or FULLi = '1') else '0'; -- 332
      as_fifo_w23_d511_inst : as_fifo_w23_d511
      port map (
         din => fifo_din,
         wr_en => RX_DVAL,
         wr_clk => CLK_RX,
         rd_en => fifo_rd_en,
         rd_clk => CLK_TX,
         rst => ARESET,
         dout => fifo_dout,
         full => FULLi,
         empty => EMPTY,
         wr_data_count => fifo_wr_count_511,
         valid => fifo_rd_ack,
         overflow => WR_ERRi);
      
   end generate gen_511_21;   
   
   gen_8191 : if (FifoSize = 8191 and W = 16 and ASYNC) generate
      begin     
      FoundGenCase <= true;
      RX_AFULLi <= '1' when (unsigned(fifo_wr_count_8191) > (8191-Latency) or FULLi = '1') else '0'; --8000
      as_fifo_w18_d8191_inst : as_fifo_w18_d8191
      port map (
         din => fifo_din,
         wr_en => RX_DVAL,
         wr_clk => CLK_RX,
         rd_en => fifo_rd_en,
         rd_clk => CLK_TX,
         rst => ARESET,
         dout => fifo_dout,
         full => FULLi,
         empty => EMPTY,
         wr_data_count => fifo_wr_count_8191,
         valid => fifo_rd_ack,
         overflow => WR_ERRi);
      
   end generate gen_8191; 
   
   -- Fifo read control
   fifo_rd_en <= not TX_AFULL and not (TX_BUSY and TX_DVAL_buf);
   
   -- Write interface signals
   fifo_din <= (RX_SOF & RX_EOF & RX_DATA);	
   
   -- OUTPUT MAPPING                       
   TX_DVAL <= TX_DVAL_buf when FoundGenCase else '0';
   TX_DVAL_buf <= fifo_rd_ack or hold_dval;
   TX_DATA <= fifo_dout(W-1 downto 0);
   TX_EOF <= fifo_dout(W);	 
   TX_SOF <= fifo_dout(W+1);                  
   
   FULL <= FULLi when FoundGenCase else '1'; 
   RX_AFULL <= RX_AFULLi when FoundGenCase else '1'; 
   WR_ERR <= WR_ERRi when FoundGenCase else '0'; 
   
   -- DVALID latch (when RX is not ready, all we have to do is hold the DVal signal, the fifo interface does the rest)
   main_proc : process (CLK_TX)
   begin	
      if rising_edge(CLK_TX) then
         if RESET_TX = '1' then
            hold_dval <= '0';
         else
            hold_dval <= TX_BUSY and TX_DVAL_buf;
         end if;		
      end if;
   end process;   
   
end RTL;
