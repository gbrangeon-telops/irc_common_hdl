-------------------------------------------------------------------------------
--
-- Title       : LL_SW_4_1
-- Author      : Patrick Dubois
-- Company     : Radiocommunication and Signal Processing Laboratory (LRTS)
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Switch (mux) 4 to 1
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL; 
use Common_HDL.Telops.all;
--use work.DPB_Define.all; 
use IEEE.numeric_std.all;

entity LL_SW_4_1 is
   port(
      RX0_LL_MOSI : in  t_ll_mosi;
      RX0_LL_MISO : out t_ll_miso;
      
      RX1_LL_MOSI : in  t_ll_mosi;
      RX1_LL_MISO : out t_ll_miso;    
      
      RX2_LL_MOSI : in  t_ll_mosi;
      RX2_LL_MISO : out t_ll_miso;   
      
      RX3_LL_MOSI : in  t_ll_mosi;
      RX3_LL_MISO : out t_ll_miso;       
      
      TX_LL_MOSI  : out t_ll_mosi;
      TX_LL_MISO  : in  t_ll_miso;
      
      WR_ERR      : out std_logic;
      SEL         : in  std_logic_vector(2 downto 0);
      EMPTY       : out std_logic;     
      RX_DVAL     : out std_logic;  -- Monitoring signal only.    
      RX_EOF      : out std_logic;  -- Monitoring signal only.    
      CNT_ERR     : out std_logic;
      
      ARESET      : in  std_logic;
      CLK         : in  STD_LOGIC
      );
end LL_SW_4_1;


architecture RTL of LL_SW_4_1 is
   
   signal RX_LL_MOSI : t_ll_mosi;
   signal RX_LL_MISO : t_ll_miso;
   signal TX_LL_MOSIi : t_ll_mosi;
   
   signal WR_ERRi    : std_logic;
   signal RESET      : std_logic;  
   signal busy       : std_logic; 
   --signal RX_DVALi   : std_logic;
   
   signal rx_dval_cnt : unsigned(31 downto 0);
   signal tx_dval_cnt : unsigned(31 downto 0);
   attribute keep : string; 
   attribute keep of rx_dval_cnt : signal is "true";
   attribute keep of tx_dval_cnt : signal is "true";    
   attribute keep of RX_LL_MOSI : signal is "true"; 
   
   -- pragma translate_off
   --signal output_debug : t_output_debug;   
   -- pragma translate_on
   
   component locallink_fifo
      generic(
         FifoSize : INTEGER := 63;
         Latency : INTEGER := 32;
         ASYNC : BOOLEAN := true);
      port(
         RX_LL_MOSI : in t_ll_mosi;
         RX_LL_MISO : out t_ll_miso;
         CLK_RX : in std_logic;
         FULL : out std_logic;
         WR_ERR : out std_logic;
         TX_LL_MOSI : out t_ll_mosi;
         TX_LL_MISO : in t_ll_miso;
         CLK_TX : in std_logic;
         EMPTY : out std_logic;
         ARESET : in std_logic);
   end component;
   
begin           
   
   sync_rst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, clk => CLK);   
   
   -- Unconditionnal statements 
   TX_LL_MOSIi.SUPPORT_BUSY <= '1';              
   RX_DVAL <= RX_LL_MOSI.DVAL;
   RX_EOF <= RX_LL_MOSI.EOF;
   --RX_DVALi <= RX_LL_MOSI.DVAL;               
   WR_ERR <= WR_ERRi;    
   TX_LL_MOSI <= TX_LL_MOSIi;
   
   -- Conditionnal statements
   RX_SOF_sel : with SEL(1 downto 0) select RX_LL_MOSI.SOF <= 
   RX0_LL_MOSI.SOF when "00",
   RX1_LL_MOSI.SOF when "01",
   RX2_LL_MOSI.SOF when "10",
   RX3_LL_MOSI.SOF when others;  
   
   RX_EOF_sel : with SEL(1 downto 0) select RX_LL_MOSI.EOF <= 
   RX0_LL_MOSI.EOF when "00",
   RX1_LL_MOSI.EOF when "01",
   RX2_LL_MOSI.EOF when "10",
   RX3_LL_MOSI.EOF when others; 
   
   RX_DATA_sel : with SEL(1 downto 0) select RX_LL_MOSI.DATA <= 
   RX0_LL_MOSI.DATA when "00",
   RX1_LL_MOSI.DATA when "01",
   RX2_LL_MOSI.DATA when "10",
   RX3_LL_MOSI.DATA when others; 
   
   RX_DVAL_sel : with SEL select RX_LL_MOSI.DVAL <= 
   RX0_LL_MOSI.DVAL and not busy when "000",
   RX1_LL_MOSI.DVAL and not busy when "001",
   RX2_LL_MOSI.DVAL and not busy when "010",
   RX3_LL_MOSI.DVAL and not busy when "011",
   '0'              when others;
    
   RX0_LL_MISO.AFULL <= '0';   
   RX1_LL_MISO.AFULL <= '0';
   RX2_LL_MISO.AFULL <= '0';
   RX3_LL_MISO.AFULL <= '0'; 
   
   RX0_LL_MISO.BUSY <= busy when SEL = "000" else '1';   
   RX1_LL_MISO.BUSY <= busy when SEL = "001" else '1';
   RX2_LL_MISO.BUSY <= busy when SEL = "010" else '1';
   RX3_LL_MISO.BUSY <= busy when SEL = "011" else '1';       
   
   -- pragma translate_off 
   --output_debug <= to_output_debug(TX_LL_MOSIi.DATA);
   -- pragma translate_on 
   assert_proc : process(CLK)
   begin       
      if rising_edge(CLK) then
         if RESET = '1' then
            rx_dval_cnt <= (others => '0');
            tx_dval_cnt <= (others => '0'); 
            CNT_ERR <= '0';
         else
            -- pragma translate_off
            assert (RX0_LL_MOSI.SUPPORT_BUSY = '1') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;      
            assert (RX1_LL_MOSI.SUPPORT_BUSY = '1') report "RX1 Upstream module must support the BUSY signal" severity FAILURE;      
            assert (RX2_LL_MOSI.SUPPORT_BUSY = '1') report "RX2 Upstream module must support the BUSY signal" severity FAILURE;      
            assert (RX3_LL_MOSI.SUPPORT_BUSY = '1') report "RX3 Upstream module must support the BUSY signal" severity FAILURE;      
            assert (WR_ERRi = '0') report "Fifo overflow" severity ERROR;
            -- pragma translate_on
            
            if RX_LL_MOSI.DVAL = '1' then
               rx_dval_cnt <= rx_dval_cnt + 1;
            end if;      
            if TX_LL_MOSIi.DVAL = '1' and TX_LL_MISO.BUSY = '0' then          
               tx_dval_cnt <= tx_dval_cnt + 1;
            end if;       
            if (rx_dval_cnt - tx_dval_cnt) > 18 then
               CNT_ERR <= '1';
            end if;
         end if;
      end if;
   end process;
   
   
   fifo : LocalLink_Fifo
   generic map(
      FifoSize => 16,
      Latency => 6,
      ASYNC => FALSE
      )
   port map(
      RX_LL_MOSI => RX_LL_MOSI,
      RX_LL_MISO => RX_LL_MISO,
      CLK_RX => CLK,
      FULL => busy,
      WR_ERR => WR_ERRi,   
      TX_LL_MOSI => TX_LL_MOSIi,
      TX_LL_MISO => TX_LL_MISO,
      CLK_TX => CLK,
      EMPTY => EMPTY,
      ARESET => RESET
      );              
   
end RTL;
