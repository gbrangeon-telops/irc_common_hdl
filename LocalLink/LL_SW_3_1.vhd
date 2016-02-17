-------------------------------------------------------------------------------
--
-- Title       : LL_SW_3_1
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Radiocommunication and Signal Processing Laboratory (LRTS)
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink Switch (mux) 3 to 1
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.DPB_Define.ALL;

entity LL_SW_3_1 is
   generic(
      Latency     : integer := 5  -- Input module latency (to control RX_AFULL)
      );
   port(
      RX0_LL_MOSI : in  t_ll_mosi;
      RX0_LL_MISO : out t_ll_miso;
      
      RX1_LL_MOSI : in  t_ll_mosi;
      RX1_LL_MISO : out t_ll_miso;    
      
      RX2_LL_MOSI : in  t_ll_mosi;
      RX2_LL_MISO : out t_ll_miso;   
      
      TX_LL_MOSI  : out t_ll_mosi;
      TX_LL_MISO  : in  t_ll_miso;
      
      WR_ERR      : out std_logic;
      SEL         : in  std_logic_vector(1 downto 0);
      EMPTY       : out std_logic;
      RX_DVAL     : out std_logic;  -- Monitoring signal only.
      
      ARESET      : in  std_logic;
      CLK         : in  STD_LOGIC
      );
end LL_SW_3_1;


architecture RTL of LL_SW_3_1 is
   
   signal RX_LL_MOSI : t_ll_mosi;
   signal RX_LL_MISO : t_ll_miso;
   signal TX_LL_MOSIi : t_ll_mosi;
   
   signal WR_ERRi    : std_logic;        
   signal RESET      : std_logic;     
   signal busy       : std_logic;
   
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
   WR_ERR <= WR_ERRi;    
   TX_LL_MOSI <= TX_LL_MOSIi;
   
   -- Conditionnal statements
   RX_SOF_sel : with SEL select RX_LL_MOSI.SOF <= 
   RX0_LL_MOSI.SOF when "00",
   RX1_LL_MOSI.SOF when "01",
   RX2_LL_MOSI.SOF when others;  
   
   RX_EOF_sel : with SEL select RX_LL_MOSI.EOF <= 
   RX0_LL_MOSI.EOF when "00",
   RX1_LL_MOSI.EOF when "01",
   RX2_LL_MOSI.EOF when others; 
   
   RX_DATA_sel : with SEL select RX_LL_MOSI.DATA <= 
   RX0_LL_MOSI.DATA when "00",
   RX1_LL_MOSI.DATA when "01",
   RX2_LL_MOSI.DATA when others; 
   
   RX_DVAL_sel : with SEL select RX_LL_MOSI.DVAL <= 
   RX0_LL_MOSI.DVAL and not busy when "00",
   RX1_LL_MOSI.DVAL and not busy when "01",
   RX2_LL_MOSI.DVAL and not busy when "10",
   '0'              when others;
  
   RX0_LL_MISO.AFULL <= '0';   
   RX1_LL_MISO.AFULL <= '0';
   RX2_LL_MISO.AFULL <= '0';
   
   RX0_LL_MISO.BUSY <= busy when SEL = "00" else '1';   
   RX1_LL_MISO.BUSY <= busy when SEL = "01" else '1';
   RX2_LL_MISO.BUSY <= busy when SEL = "10" else '1';       
   
   -- pragma translate_off 
   --output_debug <= to_output_debug(TX_LL_MOSIi.DATA);
   assert_proc : process(CLK)
   begin       
      if rising_edge(CLK) then
         if RESET = '0' then
            assert (RX0_LL_MOSI.SUPPORT_BUSY = '1') report "RX0 Upstream module must support the BUSY signal" severity FAILURE;      
            assert (RX1_LL_MOSI.SUPPORT_BUSY = '1') report "RX1 Upstream module must support the BUSY signal" severity FAILURE;      
            assert (RX2_LL_MOSI.SUPPORT_BUSY = '1') report "RX2 Upstream module must support the BUSY signal" severity FAILURE;                  
            assert (WR_ERRi = '0') report "Fifo overflow" severity ERROR;      
         end if;
      end if;
   end process;
   -- pragma translate_on     
   
   fifo : LocalLink_Fifo
   generic map(
      FifoSize => 16,
      Latency => Latency,
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
