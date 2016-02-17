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
library Common_HDL; 
use Common_HDL.Telops.all;

entity CAML_Fifo is
   generic(
      FifoSize       : integer := 63;     -- Several choices...
      Latency        : integer := 32;     -- Input module latency (to control RX_LL_MISO.AFULL)      
      ASYNC          : boolean := true;   -- Use asynchronous fifos
      SOF_EOF        : boolean := true);  -- Support SOF and EOF   
   port(
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      RX_LL_MOSI  : in  t_ll_mosi;
      RX_LL_MISO  : out t_ll_miso;
      CLK_RX      : in  std_logic;
      FULL        : out std_logic;
      WR_ERR      : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      TX_LL_MOSI  : out t_ll_mosi;
      TX_LL_MISO  : in  t_ll_miso;
      CLK_TX      : in  std_logic;
      EMPTY       : out std_logic;
      RD_CNT      : out std_logic_vector;
      --RD_ERR      : out std_logic;  
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET      : in std_logic
      );
end CAML_Fifo;

architecture RTL of CAML_Fifo is   
   
   component as_fifo_w16_d16383
      port (
         din: IN std_logic_VECTOR(15 downto 0);
         wr_en: IN std_logic;
         wr_clk: IN std_logic;
         rd_en: IN std_logic;
         rd_clk: IN std_logic;
         rst: IN std_logic;
         dout: OUT std_logic_VECTOR(15 downto 0);
         full: OUT std_logic;
         empty: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(13 downto 0);
         rd_data_count: OUT std_logic_VECTOR(13 downto 0);
         valid: OUT std_logic;
         overflow: OUT std_logic;
         underflow: OUT std_logic);
   end component;                
   
   component as_fifo_w16_d32767
      port (
         din: IN std_logic_VECTOR(15 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         almost_full: OUT std_logic;
         dout: OUT std_logic_VECTOR(15 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         underflow: OUT std_logic;
         wr_ack: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(14 downto 0);
         rd_data_count: OUT std_logic_VECTOR(14 downto 0));
   end component;   
   
   signal fifo_wr_count_16383 : std_logic_vector(13 downto 0);
   signal fifo_wr_count_32767 : std_logic_vector(14 downto 0);
   signal fifo_dout           : std_logic_vector(17 downto 0);
   signal fifo_din            : std_logic_vector(17 downto 0);
   signal fifo_rd_ack         : std_logic;        
   signal fifo_rd_en          : std_logic;
   
   signal hold_dval   : std_logic;
   signal TX_DVAL_buf : std_logic;
   signal FULLi       : std_logic;    
   signal AFULLi      : std_logic;    
   signal WR_ERRi     : std_logic;
   signal fifo_wr_en  : std_logic;
   
   signal FoundGenCase : boolean;      
   signal RESET_TX : std_logic;
   
begin      
   
   sync_RESET_inst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET_TX, CLK => CLK_TX);
    
   gen_16383_no_sof : if (FifoSize = 16383 and ASYNC and not SOF_EOF) generate
      begin         
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_wr_count_16383) > (16383-Latency) or FULLi = '1') else '0'; 
      fifo : as_fifo_w16_d16383
      port map (
         din => RX_LL_MOSI.DATA,
         wr_en => fifo_wr_en,
         wr_clk => CLK_RX,
         rd_en => fifo_rd_en,
         rd_clk => CLK_TX,
         rst => ARESET,
         dout => TX_LL_MOSI.DATA,
         full => FULLi,
         empty => EMPTY,
         wr_data_count => fifo_wr_count_16383,
         rd_data_count => RD_CNT,
         valid => fifo_rd_ack,
         underflow => open,
         overflow => WR_ERRi);      
   end generate gen_16383_no_sof;   
   
   gen_32767_no_sof : if (FifoSize = 32767 and ASYNC and not SOF_EOF) generate
      begin       
      FoundGenCase <= true;
      AFULLi <= '1' when (unsigned(fifo_wr_count_32767) > (32767-Latency) or FULLi = '1') else '0'; 
      fifo : as_fifo_w16_d32767
      port map (
         din => RX_LL_MOSI.DATA,
         wr_en => fifo_wr_en,
         wr_clk => CLK_RX,
         rd_en => fifo_rd_en,
         rd_clk => CLK_TX,
         rst => ARESET,
         dout => TX_LL_MOSI.DATA,
         full => FULLi,
         empty => EMPTY,
         wr_data_count => fifo_wr_count_32767,
         rd_data_count => RD_CNT,         
         valid => fifo_rd_ack,
         wr_ack => open,
         underflow => open,
         overflow => WR_ERRi);      
   end generate gen_32767_no_sof;     
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   
   gen_SOF_EOF : if SOF_EOF generate
   begin
      -- Write interface signals
      fifo_din <= (RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA);  
      
      -- Read signals 
      TX_LL_MOSI.DATA <= fifo_dout(15 downto 0) when FoundGenCase else (others => '0');
      TX_LL_MOSI.EOF <= fifo_dout(16) when FoundGenCase else '0';  
      TX_LL_MOSI.SOF <= fifo_dout(17) when FoundGenCase else '0';           
   end generate gen_SOF_EOF;
   
   gen_not_SOF_EOF : if not SOF_EOF generate
   begin
      TX_LL_MOSI.EOF <= '0';  
      TX_LL_MOSI.SOF <= '0';     
   end generate gen_not_SOF_EOF;
   
   -- Fifo write control
   fifo_wr_en <= RX_LL_MOSI.DVAL and not FULLi;
   
   -- Fifo read control
   fifo_rd_en <= not TX_LL_MISO.AFULL and not (TX_LL_MISO.BUSY and TX_DVAL_buf);   
   
   -- OUTPUT MAPPING                       
   TX_LL_MOSI.DVAL <= TX_DVAL_buf when FoundGenCase else '0';
   TX_DVAL_buf <= fifo_rd_ack or hold_dval;             
   
   FULL <= FULLi when FoundGenCase else '1'; 
   RX_LL_MISO.AFULL <= AFULLi when FoundGenCase else '1'; 
   RX_LL_MISO.BUSY <= FULLi;
   WR_ERR <= WR_ERRi when FoundGenCase else '0'; 
   
   -- DVALID latch (when RX is not ready, all we have to do is hold the DVal signal, the fifo interface does the rest)
   main_proc : process (CLK_TX)
   begin 
      if rising_edge(CLK_TX) then
         if RESET_TX = '1' then
            hold_dval <= '0';
         else
            hold_dval <= TX_LL_MISO.BUSY and TX_DVAL_buf;  
            -- pragma translate_off   
            if FoundGenCase then
               assert (WR_ERRi = '0') report "LocalLink fifo overflow!!!" severity ERROR;
            end if;
            -- pragma translate_on
         end if;     
      end if;
   end process;   
   
end RTL;
