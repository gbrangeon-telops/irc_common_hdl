---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: LL_32_to_16.vhd
--  Use: LocalLink Bus Width Compatibility Block
--
--  Revision history:  (use SVN for exact code history)
--    OBO : Dec 12, 2006 - original implementation
--    ENO : June 22,2007 -- prise en compte de DREM et modif pour supporter le BIG Endian
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.DPB_Define.all;

entity LL_32_to_16 is
   generic(
      use_fifos   : boolean := FALSE
      );      
   port(
      CLK      : in  std_logic;
      ARESET   : in  std_logic;
      RX_MOSI  : in  t_ll_mosi32;
      RX_MISO  : out t_ll_miso;
      TX_MOSI  : out t_ll_mosi;
      FIFO_EMPTY : out std_logic;
      TX_MISO  : in  t_ll_miso);
end LL_32_to_16;

architecture rtl of LL_32_to_16 is
   
   signal rx_dval_buf_i    : std_logic;
   signal active_lane      : std_logic := '0';
   signal data_buf_i       : std_logic_vector(15 downto 0);
   signal eof_buf          : std_logic := '0';
   signal data_drem_buf_i  : std_logic_vector(1 downto 0);
   signal sreset           : std_logic;  
   
   --   -- translate_off   
   --   signal rx_data_decode : t_output_debug32;
   --   signal tx_data_decode : t_output_debug;      
   --   -- translate_on  
   
   signal fifo_mosi : t_ll_mosi;   
   signal fifo_miso : t_ll_miso;   
   
begin
   
   the_sync_RESET : entity sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK); 
   
   --   -- translate_off
   --   rx_data_decode <= to_output_debug32(RX_MOSI.DATA);
   --   -- translate_on    
   
   
   -- map outputs   
   fifo_mosi.SUPPORT_BUSY <= '1';
   
   -- Make sure that we are busy during reset (to avoid U values)    
   RX_MISO.BUSY <= fifo_miso.BUSY or active_lane or sreset; -- RX is busy if we are not processing the lower lane
   RX_MISO.AFULL <= fifo_miso.AFULL or sreset;              
   
   -- adjust the data lanes according to CLINK_MODE
   lane_adjust : process(CLK)
      variable fetch_data : std_logic;
   begin
      if CLK'event and CLK = '1' then 
         if sreset = '1' then 
            active_lane    <= '0';
            fifo_mosi.DVAL <= '0';
            
         else 
            if (fifo_miso.BUSY = '0') then
               if (active_lane = '0') then
                  data_buf_i     <= RX_MOSI.DATA(15 downto 0);
                  data_drem_buf_i<= RX_MOSI.DREM;
                  rx_dval_buf_i  <= RX_MOSI.DVAL;
                  fifo_mosi.DATA   <= RX_MOSI.DATA(31 downto 16);
                  --                  -- translate_off
                  --                  TX_DATA_decode <= to_output_debug(RX_MOSI.DATA(31 downto 16));	
                  --                  -- translate_on                  
                  fifo_mosi.SOF    <= RX_MOSI.SOF;
                  fifo_mosi.EOF    <= RX_MOSI.EOF and BooltoStd(RX_MOSI.DREM="01");					
                  fifo_mosi.DVAL   <= RX_MOSI.DVAL and (BooltoStd(RX_MOSI.DREM="01")or BooltoStd(RX_MOSI.DREM="11"));
                  eof_buf        <= RX_MOSI.EOF;
                  active_lane    <= '1';
               else
                  fifo_mosi.DATA   <= data_buf_i;
                  --                  -- translate_off
                  --                  TX_DATA_decode <= to_output_debug(data_buf_i);	
                  --                  -- translate_on                   
                  fifo_mosi.SOF    <= '0';
                  fifo_mosi.EOF    <= eof_buf       and BooltoStd(data_drem_buf_i="11");
                  fifo_mosi.DVAL   <= rx_dval_buf_i and BooltoStd(data_drem_buf_i="11");	  -- tx_dval <= '1'
                  active_lane    <= '0';
               end if;  
            end if;
         end if;    
      end if;
   end process lane_adjust;   
   
   
   no_fifos : if not use_fifos generate
      
      TX_MOSI <= fifo_mosi;
      fifo_miso <= TX_MISO;               
      
   end generate no_fifos;   
   
   yes_fifos : if use_fifos generate 
      
      fifo : entity locallink_fifo
      generic map(
         FifoSize => 16,
         Latency => 2,
         ASYNC => false)
      port map(
         RX_LL_MOSI => fifo_mosi,
         RX_LL_MISO => fifo_miso,
         CLK_RX => CLK,
         FULL => open,
         WR_ERR => open,
         TX_LL_MOSI => TX_MOSI,
         TX_LL_MISO => TX_MISO,
         CLK_TX => CLK,
         EMPTY => FIFO_EMPTY,
         ARESET => ARESET);                         
      
   end generate yes_fifos;    
   
   
   -- make sure upstream modules support LocalLink Busy signal
   -- pragma translate_off
   assert_proc : process(CLK)
   begin       
      if rising_edge(CLK) then
         if sreset = '0' then
            assert (RX_MOSI.SUPPORT_BUSY = '1') report "LL_32_to_16 RX Upstream module must support the BUSY signal" severity WARNING;
         end if;
      end if;
   end process;
   -- pragma translate_on    
   
end rtl;
