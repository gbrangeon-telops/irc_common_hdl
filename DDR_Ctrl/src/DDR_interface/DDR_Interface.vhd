---------------------------------------------------------------------------------------------------
--
-- Title       : DDR_Interface
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;   
library common_hdl;
--use common_hdl.double_sync;

entity DDR_Interface is
   generic(
      USER_DATA_WIDTH         : integer range 128 to 144 := 144; -- 128 or 144
      USER_ADDR_WIDTH         : integer range 25 to 27 := 27;
      CMD_TO_CMD_DLY          : std_logic_vector(5 downto 0) := "100000";
      CONSECUTIVE_CMD         : std_logic_vector(4 downto 0) := "01111"; -- < WF_AFULL_CNT et < RF_AFULL_CNT
      WF_AFULL_CNT            : std_logic_vector(4 downto 0) := "11000";
      RF_AFULL_CNT            : std_logic_vector(4 downto 0) := "11010"
      );
   port(
      --------------------------------
      -- DDR Core Signals
      --------------------------------
      CORE_DATA_VLD  : in  std_logic;
      CORE_DATA_RD   : in  std_logic_vector(143 downto 0);
      CORE_AFULL     : in  std_logic;
      CORE_DATA_WR   : out std_logic_vector(143 downto 0);
      CORE_ADDR      : out std_logic_vector( 27 downto 0);
      CORE_CMD       : out std_logic_vector(  2 downto 0);
      CORE_CMD_VALID : out std_logic;
      --------------------------------
      -- Write Interface Signals #1
      --------------------------------
      WR1_EN         : in  std_logic;
      WR1_ADD        : in  std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
      WR1_DATA       : in  std_logic_vector(USER_DATA_WIDTH-1 downto 0);
      WR1_AFULL      : out std_logic;           
      --------------------------------
      -- Write Interface Signals #2
      --------------------------------
      WR2_EN         : in  std_logic;
      WR2_ADD        : in  std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
      WR2_DATA       : in  std_logic_vector(USER_DATA_WIDTH-1 downto 0);
      WR2_AFULL      : out std_logic;      
      --------------------------------
      -- Read Interface Signals #1
      --------------------------------
      RD1_ADD        : in  std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
      RD1_ADD_EN     : in  std_logic;
      RD1_DATA       : out std_logic_vector(USER_DATA_WIDTH-1 downto 0);
      RD1_DVAL       : out std_logic;
      RD1_AFULL      : out std_logic;
      RD1_DATA_EN    : in  std_logic;
      --------------------------------
      -- Read Interface Signals #2
      --------------------------------
      RD2_ADD        : in  std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
      RD2_ADD_EN     : in  std_logic;
      RD2_DATA       : out std_logic_vector(USER_DATA_WIDTH-1 downto 0);
      RD2_DVAL       : out std_logic;
      RD2_AFULL      : out std_logic;
      RD2_DATA_EN    : in  std_logic;
      --------------------------------
      -- Read Interface Signals #3
      --------------------------------
      RD3_ADD        : in  std_logic_vector(USER_ADDR_WIDTH-1 downto 0);
      RD3_ADD_EN     : in  std_logic;
      RD3_DATA       : out std_logic_vector(USER_DATA_WIDTH-1 downto 0);
      RD3_DVAL       : out std_logic;
      RD3_AFULL      : out std_logic;
      RD3_DATA_EN    : in  std_logic;
      --------------------------------
      -- Other Signals
      --------------------------------         
      CLEAR_FIFOS    : in  std_logic;
      IDLE           : out std_logic;  -- '1' when the controller is idle (there might be still data in the Read Data Fifos)
      --EMPTY          : out std_logic;  -- '1' when all fifos are empty.  
      FIFO_ERR       : out std_logic;
      ARESET         : in  std_logic;
      MEM_CLK        : in  std_logic;
      USER_CLK       : in  std_logic
      );
end DDR_Interface;

architecture RTL of DDR_Interface is  
   
   constant SRDF_AFULL_CNT : std_logic_vector(5 downto 0) := "111100";
   
   component double_sync
      generic(
         INIT_VALUE : bit := '0');
      port(
         D : in std_logic;
         Q : out std_logic := '0';
         RESET : in std_logic;
         CLK : in std_logic);
   end component;
   
   component fwft_fifo_w2_d512
      port (
         din            : IN  std_logic_vector(1 downto 0);
         rd_clk         : IN  std_logic;
         rd_en          : IN  std_logic;
         rst            : IN  std_logic;
         wr_clk         : IN  std_logic;
         wr_en          : IN  std_logic;
         dout           : OUT std_logic_vector(1 downto 0);
         empty          : OUT std_logic;
         full           : OUT std_logic;
         overflow       : OUT std_logic;
         wr_data_count  : OUT std_logic_vector(8 downto 0));
   end component;   
   
   component as_fifo_w27_d32
      port (
         din            : IN  std_logic_vector(26 downto 0);
         rd_clk         : IN  std_logic;
         rd_en          : IN  std_logic;
         rst            : IN  std_logic;
         wr_clk         : IN  std_logic;
         wr_en          : IN  std_logic;
         dout           : OUT std_logic_vector(26 downto 0);
         empty          : OUT std_logic;
         full           : OUT std_logic;
         valid          : OUT std_logic;
         overflow       : OUT std_logic;
         rd_data_count  : OUT std_logic_vector( 4 downto 0);
         wr_data_count  : OUT std_logic_vector( 4 downto 0));
   end component;           
   
   component as_fifo_w128_d511
      port (
         din: IN std_logic_VECTOR(127 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(127 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(8 downto 0));
   end component;
   
   component as_fifo_w144_d64
      port (
         din      : IN std_logic_vector(143 downto 0);
         rd_clk   : IN std_logic;
         rd_en    : IN std_logic;
         rst      : IN std_logic;
         wr_clk   : IN std_logic;
         wr_en    : IN std_logic;
         dout     : OUT std_logic_vector(143 downto 0);
         empty    : OUT std_logic;
         full     : OUT std_logic;
         overflow : OUT std_logic;
         valid    : OUT std_logic);
   end component;    
   
   component as_fifo_w155_d32
      port (
         din            : IN  std_logic_vector(154 downto 0);
         rd_clk         : IN  std_logic;
         rd_en          : IN  std_logic;
         rst            : IN  std_logic;
         wr_clk         : IN  std_logic;
         wr_en          : IN  std_logic;
         dout           : OUT std_logic_vector(154 downto 0);
         empty          : OUT std_logic;
         full           : OUT std_logic;
         overflow       : OUT std_logic;
         rd_data_count  : OUT std_logic_vector(  4 downto 0);
         wr_data_count  : OUT std_logic_vector(  4 downto 0));
   end component;    
   
   component as_fifo_w171_d32
      port (
         din            : IN  std_logic_vector(170 downto 0);
         rd_clk         : IN  std_logic;
         rd_en          : IN  std_logic;
         rst            : IN  std_logic;
         wr_clk         : IN  std_logic;
         wr_en          : IN  std_logic;
         dout           : OUT std_logic_vector(170 downto 0);
         empty          : OUT std_logic;
         full           : OUT std_logic;
         overflow       : OUT std_logic;
         rd_data_count  : OUT std_logic_vector(  4 downto 0);
         wr_data_count  : OUT std_logic_vector(  4 downto 0));
   end component;    
   
   --------------------------------
   -- Asynchronous signals
   --------------------------------
   signal ASYNC_RST        : std_logic := '1';
   
   --------------------------------
   -- USER_CLK signals
   --------------------------------
   
   -- Misc
   signal USER_RESET       : std_logic;
   signal USER_FIFO_werr   : std_logic;
   
   -- Write Fifo #1
   signal WF1_d_cnt        : std_logic_vector( 4 downto 0);
   signal WF1_full         : std_logic;
   signal WF1_werr         : std_logic;
   
   -- Write Fifo #2
   signal WF2_d_cnt        : std_logic_vector( 4 downto 0);
   signal WF2_full         : std_logic;
   signal WF2_werr         : std_logic;
   
   -- Read Address Fifo #1
   signal RAF1_addr_in     : std_logic_vector(26 downto 0);
   signal RAF1_d_cnt       : std_logic_vector( 4 downto 0);
   signal RAF1_full        : std_logic;
   signal RAF1_werr        : std_logic;
   
   -- Read Address Fifo #2
   signal RAF2_addr_in     : std_logic_vector(26 downto 0);
   signal RAF2_d_cnt       : std_logic_vector(4 downto 0);
   signal RAF2_full        : std_logic; 
   signal RAF2_werr        : std_logic;
   
   -- Read Address Fifo #3
   signal RAF3_addr_in     : std_logic_vector(26 downto 0);
   signal RAF3_d_cnt       : std_logic_vector(4 downto 0);
   signal RAF3_full        : std_logic;    
   signal RAF3_werr        : std_logic;
     
   --------------------------------
   -- MEM_CLK signals
   --------------------------------
   
   -- Misc
   signal MEM_RESET        : std_logic;
   signal MEM_FIFO_werr    : std_logic;
   
   -- Write Fifo #1
   signal WF1_rd_en        : std_logic;
   signal WF1_rd_en_dly    : std_logic;
   signal WF1_din          : std_logic_vector(27+USER_DATA_WIDTH-1 downto 0);
   signal WF1_data         : std_logic_vector(27+USER_DATA_WIDTH-1 downto 0);
   signal WF1_dout         : std_logic_vector(170 downto 0);
   signal WF1_empty        : std_logic;
   signal WF1_empty_dly   : std_logic;
   signal WF1_empty_fsm   : std_logic;
   signal WF1_cnt         : std_logic_vector(  4 downto 0);
   signal WF1_cnt_d1      : std_logic_vector(  4 downto 0);
   signal WF1_dly_cnt     : std_logic_vector(  5 downto 0);
   signal WF1_dly_exp     : std_logic;
   
   -- Write Fifo #2
   signal WF2_rd_en        : std_logic;
   signal WF2_rd_en_dly    : std_logic;
   signal WF2_din          : std_logic_vector(27+USER_DATA_WIDTH-1 downto 0);
   signal WF2_data         : std_logic_vector(27+USER_DATA_WIDTH-1 downto 0);
   signal WF2_dout         : std_logic_vector(170 downto 0);
   signal WF2_empty        : std_logic;
   signal WF2_empty_dly   : std_logic;
   signal WF2_empty_fsm   : std_logic;
   signal WF2_cnt         : std_logic_vector(  4 downto 0);
   signal WF2_cnt_d1      : std_logic_vector(  4 downto 0);
   signal WF2_dly_cnt     : std_logic_vector(  5 downto 0);
   signal WF2_dly_exp     : std_logic;
   
   -- Read Address Fifo #1
   signal RAF1_rd_en       : std_logic;
   signal RAF1_rd_en_dly   : std_logic;
   signal RAF1_DVal        : std_logic;
   signal RAF1_dout        : std_logic_vector( 26 downto 0);  
   signal RAF1_empty       : std_logic;
   signal RAF1_empty_dly   : std_logic;
   signal RAF1_empty_fsm   : std_logic;
   signal RAF1_cnt         : std_logic_vector(  4 downto 0);
   signal RAF1_cnt_d1      : std_logic_vector(  4 downto 0);
   signal RAF1_dly_cnt     : std_logic_vector(  5 downto 0);
   signal RAF1_dly_exp     : std_logic;
   
   -- Read Address Fifo #2
   signal RAF2_rd_en       : std_logic;
   signal RAF2_rd_en_dly   : std_logic;
   signal RAF2_DVal        : std_logic;
   signal RAF2_dout        : std_logic_vector( 26 downto 0);  
   signal RAF2_empty       : std_logic;
   signal RAF2_empty_dly   : std_logic;
   signal RAF2_empty_fsm   : std_logic;
   signal RAF2_cnt         : std_logic_vector(  4 downto 0);
   signal RAF2_cnt_d1      : std_logic_vector(  4 downto 0);
   signal RAF2_dly_cnt     : std_logic_vector(  5 downto 0);
   signal RAF2_dly_exp     : std_logic;
   
   -- Read Address Fifo #3
   signal RAF3_rd_en       : std_logic;
   signal RAF3_rd_en_dly   : std_logic;
   signal RAF3_DVal        : std_logic;
   signal RAF3_dout        : std_logic_vector( 26 downto 0);  
   signal RAF3_empty       : std_logic;
   signal RAF3_empty_dly   : std_logic;
   signal RAF3_empty_fsm   : std_logic;
   signal RAF3_cnt         : std_logic_vector(  4 downto 0);
   signal RAF3_cnt_d1      : std_logic_vector(  4 downto 0);
   signal RAF3_dly_cnt     : std_logic_vector(  5 downto 0);
   signal RAF3_dly_exp     : std_logic;
   
   -- Read Data Fifo #1
   signal RDF1_wr_en       : std_logic;
   signal RDF1_werr        : std_logic;
   signal RDF1_cnt         : std_logic_vector(8 downto 0);
   signal RDF1_cnt_xtd     : unsigned(9 downto 0); -- Extended count including SDF_cnt
   signal RDF1_afull       : std_logic;   
   signal RDF1_full        : std_logic;   
   
   -- Read Data Fifo #2
   signal RDF2_wr_en       : std_logic;
   signal RDF2_werr        : std_logic;
   signal RDF2_cnt         : std_logic_vector(8 downto 0);
   signal RDF2_cnt_xtd     : unsigned(9 downto 0); -- Extended count including SDF_cnt
   signal RDF2_afull       : std_logic;
   signal RDF2_full        : std_logic;   
   
   -- Read Data Fifo #3
   signal RDF3_wr_en       : std_logic;   
   signal RDF3_werr        : std_logic;  
   signal RDF3_cnt         : std_logic_vector(8 downto 0);    
   signal RDF3_cnt_xtd     : unsigned(9 downto 0); -- Extended count including SDF_cnt
   signal RDF3_afull       : std_logic;
   signal RDF3_full        : std_logic;                                        
   
   -- Steer Read Data Fifo
   signal SRDF_din         : std_logic_vector(  1 downto 0);
   signal SRDF_wr_en       : std_logic;
   signal SRDF_select      : std_logic_vector(  1 downto 0);
   signal SRDF_empty       : std_logic;
   signal SRDF_full        : std_logic;
   signal SRDF_afull       : std_logic;
   signal SRDF_d_cnt       : std_logic_vector(  8 downto 0); 
   signal SRDF_d_cnt_xtd   : unsigned(9 downto 0);
   signal SRDF_werr        : std_logic;
   
   -- State Machine
   signal FSM_state_wf1    : std_logic;
   signal FSM_state_wf2    : std_logic;
   signal FSM_state_rf1    : std_logic;
   signal FSM_state_rf2    : std_logic;
   signal FSM_state_rf3    : std_logic;
   
   -- Idle generation
   signal new_request            : std_logic;
   signal IDLE_buf               : std_logic;
   signal req_fifos_empty        : std_logic; -- Request fifos are WF and RAF
   signal USER_req_fifos_empty   : std_logic;
   signal USER_SRDF_empty        : std_logic;
   
begin
   
   --------------------------------
   -- Asynchronous logic
   --------------------------------
   ASYNC_RST <= ARESET or CLEAR_FIFOS;
   
   --------------------------------
   -- USER_CLK logic
   --------------------------------
   user_sync_RESET : double_sync
   generic map(INIT_VALUE => '1')
   port map(d => ASYNC_RST, q => USER_RESET, reset => '0', clk => USER_CLK);
   
   srdf_empty_sync : double_sync
   port map(d => SRDF_empty, q => USER_SRDF_empty, reset => '0', clk => USER_CLK);   
   
   req_fifos_empty_sync : double_sync
   port map(d => req_fifos_empty, q => USER_req_fifos_empty, reset => '0', clk => USER_CLK);   
   
   fifo_werr_sync : double_sync
   port map(d => MEM_FIFO_werr, q => USER_FIFO_werr, reset => '0', clk => USER_CLK);
   FIFO_ERR <= USER_FIFO_werr or WF1_werr or WF2_werr or RAF1_werr or RAF2_werr or RAF3_werr;
   
   -- This process produces the IDLE signal which indicates that there are 
   -- no more ddr operations in the pipeline. 
   new_request <= WR1_EN or WR2_EN or RD1_ADD_EN or RD2_ADD_EN or RD3_ADD_EN;
   IDLE <= IDLE_buf and not new_request; 
   Idle_process : process (USER_CLK) 
      variable cnt : unsigned(4 downto 0);
   begin 
      if rising_edge(USER_CLK) then

         if USER_SRDF_empty='0' or USER_req_fifos_empty='0' or new_request='1' then     
            IDLE_buf <= '0';
            cnt := (others => '0');
         elsif cnt < "11111" then
            cnt := cnt + 1;
         else
            IDLE_buf <= '1';
         end if;
         
         if USER_RESET = '1' then 
            IDLE_buf <= '0';
            cnt := (others => '0');            
         end if;
         
      end if;
   end process;   
   
   -- FIFO_FULL process to circumvent the false FULL flag if fifos are reset
   FIFO_FULL_process :  process (USER_CLK, USER_RESET) 
   begin 
      if rising_edge(USER_CLK) then
         if USER_RESET = '1' then 
            WR1_AFULL <= '1';
            WR2_AFULL <= '1';
            RD1_AFULL <= '1';
            RD2_AFULL <= '1';
            RD3_AFULL <= '1';
         else
            -- Write Busy signal depends on the "fullness" of the address and data fifos
            if WF1_d_cnt > WF_AFULL_CNT or WF1_full = '1' then   
               WR1_AFULL <= '1';
            else
               WR1_AFULL <= '0';
            end if;
            if WF2_d_cnt > WF_AFULL_CNT or WF2_full = '1' then   
               WR2_AFULL <= '1';
            else
               WR2_AFULL <= '0';
            end if;
            
            -- Read Busy signal depends on the "fullness" of the address fifo
            if RAF1_d_cnt > RF_AFULL_CNT or RAF1_full = '1' then             
               RD1_AFULL <= '1';
            else
               RD1_AFULL <= '0';
            end if;
            if RAF2_d_cnt > RF_AFULL_CNT or RAF2_full = '1' then
               RD2_AFULL <= '1';
            else
               RD2_AFULL <= '0';
            end if;
            if RAF3_d_cnt > RF_AFULL_CNT or RAF3_full = '1' then
               RD3_AFULL <= '1';
            else
               RD3_AFULL <= '0';
            end if;            
         end if;
      end if;
   end process;
   
   -- User address length conversion to 27 bits when using less
   fifo_din: process (RD1_ADD, RD2_ADD, RD3_ADD, WR1_ADD, WR2_ADD, WR1_DATA, WR2_DATA)
   begin
      RAF1_addr_in                                          <= (others => '0');
      RAF1_addr_in(USER_ADDR_WIDTH-1 downto 0)              <= RD1_ADD;
      RAF2_addr_in                                          <= (others => '0');
      RAF2_addr_in(USER_ADDR_WIDTH-1 downto 0)              <= RD2_ADD;
      RAF3_addr_in                                          <= (others => '0');
      RAF3_addr_in(USER_ADDR_WIDTH-1 downto 0)              <= RD3_ADD;
      WF1_din                                               <= (others => '0');
      WF1_din(USER_ADDR_WIDTH+USER_DATA_WIDTH-1 downto 0)   <= WR1_ADD & WR1_DATA;
      WF2_din                                               <= (others => '0');
      WF2_din(USER_ADDR_WIDTH+USER_DATA_WIDTH-1 downto 0)   <= WR2_ADD & WR2_DATA;
   end process;
   
   --------------------------------
   -- MEM_CLK logic
   --------------------------------
   mem_sync_RESET : double_sync
   generic map(INIT_VALUE => '1')
   port map(d => ASYNC_RST, q => MEM_RESET, reset => '0', clk => MEM_CLK);
   
   MEM_FIFO_werr  <= RDF1_werr or RDF2_werr or RDF3_werr or SRDF_werr;
   
   -- Pipeline (delays)   
   process (MEM_CLK, MEM_RESET)
   begin
      if rising_edge(MEM_CLK) then
         if MEM_RESET = '1' then
            WF1_rd_en_dly  <= '0';
            WF2_rd_en_dly  <= '0';
            RAF1_rd_en_dly <= '0';
            RAF2_rd_en_dly <= '0';
            RAF3_rd_en_dly <= '0';
            WF1_cnt_d1     <= (others => '0');
            WF2_cnt_d1     <= (others => '0');
            RAF1_cnt_d1    <= (others => '0');
            RAF2_cnt_d1    <= (others => '0');
            RAF3_cnt_d1    <= (others => '0');
         else
            WF1_rd_en_dly  <= WF1_rd_en;
            WF2_rd_en_dly  <= WF2_rd_en;
            RAF1_rd_en_dly <= RAF1_rd_en;
            RAF2_rd_en_dly <= RAF2_rd_en;
            RAF3_rd_en_dly <= RAF3_rd_en;
            WF1_cnt_d1     <= WF1_cnt;
            WF2_cnt_d1     <= WF2_cnt;
            RAF1_cnt_d1    <= RAF1_cnt;
            RAF2_cnt_d1    <= RAF2_cnt;
            RAF3_cnt_d1    <= RAF3_cnt;
         end if;
      end if;     
   end process;
   
   -- Core command generation when data is extracted from FIFOs
   process (MEM_CLK, MEM_RESET)
   constant WR_CMD : std_logic_vector := "100";
   constant RD_CMD : std_logic_vector := "101";
   begin
      if rising_edge(MEM_CLK) then
         if MEM_RESET = '1' then
            CORE_CMD       <= RD_CMD;
            CORE_CMD_VALID <= '0';
         else
            CORE_CMD       <= RD_CMD;
            CORE_CMD_VALID <= '0';
            if WF1_rd_en = '1' then 
               CORE_CMD       <= WR_CMD;
               CORE_CMD_VALID <= '1';
            elsif WF2_rd_en = '1' then 
               CORE_CMD       <= WR_CMD;
               CORE_CMD_VALID <= '1';
            elsif RAF1_rd_en = '1' then
               CORE_CMD       <= RD_CMD;
               CORE_CMD_VALID <= '1';
            elsif RAF2_rd_en = '1' then
               CORE_CMD       <= RD_CMD;
               CORE_CMD_VALID <= '1';
            elsif RAF3_rd_en = '1' then
               CORE_CMD       <= RD_CMD;
               CORE_CMD_VALID <= '1';
            else
            end if;
         end if;
      end if;     
   end process;
   
   --Core address selection
   CORE_ADDR      <= WF1_dout(170 downto 144) & '0' when WF1_rd_en_dly  = '1' else
   WF2_dout(170 downto 144) & '0' when WF2_rd_en_dly  = '1' else
   RAF1_dout & '0' when RAF1_rd_en_dly = '1' else
   RAF2_dout & '0' when RAF2_rd_en_dly = '1' else
   RAF3_dout & '0' when RAF3_rd_en_dly = '1' else
   (others => '0');
   -- Core data selection
   CORE_DATA_WR   <= WF1_dout(143 downto 0) when WF1_rd_en_dly = '1' else
   WF2_dout(143 downto 0) when WF2_rd_en_dly = '1' else
   (others => '0');
   
   -- Read Data FIFO selection for incomming data
   RDF1_wr_en <= CORE_DATA_VLD when SRDF_select(0) = '1'  else '0';
   RDF2_wr_en <= CORE_DATA_VLD when SRDF_select(1) = '1'  else '0';
   RDF3_wr_en <= CORE_DATA_VLD when SRDF_select    = "00" else '0';
   
   -- Generates empty signal while FIFO does not contain minimum amount
   -- of data or delay has expired since last command.
   req_fifos_empty <= WF1_empty and WF2_empty and RAF1_empty and RAF2_empty and RAF3_empty;
   process (MEM_CLK, MEM_RESET)
   begin
      if rising_edge(MEM_CLK) then
         if MEM_RESET = '1' then
            WF1_dly_cnt   <= (others => '0');
            WF2_dly_cnt   <= (others => '0');
            RAF1_dly_cnt   <= (others => '0');
            RAF2_dly_cnt   <= (others => '0');
            RAF3_dly_cnt   <= (others => '0');
            WF1_empty_dly <= '1';
            WF2_empty_dly <= '1';
            RAF1_empty_dly <= '1';
            RAF2_empty_dly <= '1';
            RAF3_empty_dly <= '1';
         else
            if WF1_empty = '1' or (WF1_cnt(0) /= WF1_cnt_d1(0)) then
               WF1_dly_cnt <= (others => '0');
            elsif WF1_dly_exp = '0' then
               WF1_dly_cnt <= std_logic_vector(unsigned(WF1_dly_cnt) + 1);
            end if;
            if WF1_dly_exp = '1' then
               WF1_empty_dly <= '0';
            elsif WF1_cnt >= CONSECUTIVE_CMD then
               WF1_empty_dly <= '0';
            elsif FSM_state_wf1 = '1' then
               WF1_empty_dly <= '0';
            else
               WF1_empty_dly <= '1';
            end if;
            
            if WF2_empty = '1' or (WF2_cnt(0) /= WF2_cnt_d1(0)) then
               WF2_dly_cnt <= (others => '0');
            elsif WF2_dly_exp = '0' then
               WF2_dly_cnt <= std_logic_vector(unsigned(WF2_dly_cnt) + 1);
            end if;
            if WF2_dly_exp = '1' then
               WF2_empty_dly <= '0';
            elsif WF2_cnt >= CONSECUTIVE_CMD then
               WF2_empty_dly <= '0';
            elsif FSM_state_wf2 = '1' then
               WF2_empty_dly <= '0';
            else
               WF2_empty_dly <= '1';
            end if;
            
            if RAF1_empty = '1' or (RAF1_cnt(0) /= RAF1_cnt_d1(0)) then
               RAF1_dly_cnt <= (others => '0');
            elsif RAF1_dly_exp = '0' then
               RAF1_dly_cnt <= std_logic_vector(unsigned(RAF1_dly_cnt) + 1);
            end if;
            if RAF1_dly_exp = '1' then
               RAF1_empty_dly <= '0';
            elsif RAF1_cnt >= CONSECUTIVE_CMD then
               RAF1_empty_dly <= '0';
            elsif FSM_state_rf1 = '1' then
               RAF1_empty_dly <= '0';
            else
               RAF1_empty_dly <= '1';
            end if;
            
            if RAF2_empty = '1' or (RAF2_cnt(0) /= RAF2_cnt_d1(0)) then
               RAF2_dly_cnt <= (others => '0');
            elsif RAF2_dly_exp = '0' then
               RAF2_dly_cnt <= std_logic_vector(unsigned(RAF2_dly_cnt) + 1);
            end if;
            if RAF2_dly_exp = '1' then
               RAF2_empty_dly <= '0';
            elsif RAF2_cnt >= CONSECUTIVE_CMD then
               RAF2_empty_dly <= '0';
            elsif FSM_state_rf2 = '1' then
               RAF2_empty_dly <= '0';
            else
               RAF2_empty_dly <= '1';
            end if;
            
            if RAF3_empty = '1' or (RAF3_cnt(0) /= RAF3_cnt_d1(0)) then
               RAF3_dly_cnt <= (others => '0');
            elsif RAF3_dly_exp = '0' then
               RAF3_dly_cnt <= std_logic_vector(unsigned(RAF3_dly_cnt) + 1);
            end if;
            if RAF3_dly_exp = '1' then
               RAF3_empty_dly <= '0';
            elsif RAF3_cnt >= CONSECUTIVE_CMD then
               RAF3_empty_dly <= '0';
            elsif FSM_state_rf3 = '1' then
               RAF3_empty_dly <= '0';
            else
               RAF3_empty_dly <= '1';
            end if;
            
         end if;
      end if;     
   end process;
   -- Delay expired signals
   WF1_dly_exp    <= '1' when WF1_dly_cnt  = CMD_TO_CMD_DLY else '0';
   WF2_dly_exp    <= '1' when WF2_dly_cnt  = CMD_TO_CMD_DLY else '0';
   RAF1_dly_exp   <= '1' when RAF1_dly_cnt = CMD_TO_CMD_DLY else '0';
   RAF2_dly_exp   <= '1' when RAF2_dly_cnt = CMD_TO_CMD_DLY else '0';
   RAF3_dly_exp   <= '1' when RAF3_dly_cnt = CMD_TO_CMD_DLY else '0';
   -- Modified empty signal for state machine
   WF1_empty_fsm  <= '1' when WF1_empty  = '1' else WF1_empty_dly;
   WF2_empty_fsm  <= '1' when WF2_empty  = '1' else WF2_empty_dly;
   RAF1_empty_fsm <= '1' when RAF1_empty = '1' else RAF1_empty_dly;
   RAF2_empty_fsm <= '1' when RAF2_empty = '1' else RAF2_empty_dly;
   RAF3_empty_fsm <= '1' when RAF3_empty = '1' else RAF3_empty_dly; 
         
   
   -- Read Data Fifos almost full generation            
   rdf_afull : process (MEM_CLK, MEM_RESET)
      constant RDF_LIMIT : unsigned(RDF1_cnt_xtd'LENGTH-1 downto 0) := to_unsigned(500, RDF1_cnt_xtd'LENGTH);
   begin
      if rising_edge(MEM_CLK) then 
         
         -- We pre-add both values to improve throughput.
         RDF1_cnt_xtd <= resize(unsigned(RDF1_cnt), RDF1_cnt_xtd'LENGTH) + SRDF_d_cnt_xtd;
         RDF2_cnt_xtd <= resize(unsigned(RDF2_cnt), RDF2_cnt_xtd'LENGTH) + SRDF_d_cnt_xtd;
         RDF3_cnt_xtd <= resize(unsigned(RDF3_cnt), RDF2_cnt_xtd'LENGTH) + SRDF_d_cnt_xtd;
         
         if MEM_RESET = '1' then
            RDF1_afull <= '1';
            RDF2_afull <= '1';
            RDF3_afull <= '1';
         else
            if RDF1_cnt_xtd > RDF_LIMIT or RDF1_full = '1' or SRDF_afull='1' then
               RDF1_afull <= '1';
            else                 
               RDF1_afull <= '0';
            end if;
            if RDF2_cnt_xtd > RDF_LIMIT or RDF2_full = '1' or SRDF_afull='1' then
               RDF2_afull <= '1';
            else                 
               RDF2_afull <= '0';
            end if;
            if RDF3_cnt_xtd > RDF_LIMIT or RDF3_full = '1' or SRDF_afull='1' then
               RDF3_afull <= '1';
            else                 
               RDF3_afull <= '0';
            end if;            
         end if;
      end if;
   end process;  
   
   -- Steer read data fifo almost full signall generation
   process (MEM_CLK, MEM_RESET)
   begin
      if rising_edge(MEM_CLK) then
         if MEM_RESET = '1' then
            SRDF_afull <= '1';
         else
            if unsigned(SRDF_d_cnt) >= 500 or SRDF_full = '1' then
               SRDF_afull <= '1';
            else
               SRDF_afull <= '0';
            end if;
         end if;
      end if;
   end process;
   
   -- Main arbiter state machine
   FSM : entity work.DDR_Interface_FSM 
   generic map (
      SOURCE_CONSECUTIVE_CMDS => CONSECUTIVE_CMD)
   port map (
      RESET       => MEM_RESET,               
      CLK         => MEM_CLK,                 
      CORE_afull  => CORE_AFULL,
      RAF1_empty  => RAF1_empty_fsm,      
      RAF2_empty  => RAF2_empty_fsm,      
      RAF3_empty  => RAF3_empty_fsm,      
      --RDF_afull   => SRDF_afull,
      RDF1_afull  => RDF1_afull,
      RDF2_afull  => RDF2_afull,
      RDF3_afull  => RDF3_afull,
      WF1_empty   => WF1_empty_fsm,     
      WF2_empty   => WF2_empty_fsm,     
      RAF1_rd_en  => RAF1_rd_en,      
      RAF2_rd_en  => RAF2_rd_en,      
      RAF3_rd_en  => RAF3_rd_en,      
      WF1_rd_en   => WF1_rd_en,
      WF2_rd_en   => WF2_rd_en,
      state_wr1   => FSM_state_wf1,
      state_wr2   => FSM_state_wf2,
      state_rd1   => FSM_state_rf1,
      state_rd2   => FSM_state_rf2,
      state_rd3   => FSM_state_rf3);
   
   --------------------------------
   -- FIFOs logic
   --------------------------------
   -- READ Address Fifo #1
   RAF1 : as_fifo_w27_d32
   port map (
      din            => RAF1_addr_in,
      rd_clk         => MEM_CLK,
      rd_en          => RAF1_rd_en,
      rst            => ASYNC_RST,
      wr_clk         => USER_CLK,
      wr_en          => RD1_ADD_EN,
      dout           => RAF1_dout,
      empty          => RAF1_empty,
      full           => RAF1_full,
      overflow       => RAF1_werr,
      valid          => RAF1_DVal,
      rd_data_count  => RAF1_cnt,
      wr_data_count  => RAF1_d_cnt); 
   
   -- READ Address Fifo #2
   RAF2 : as_fifo_w27_d32
   port map (
      din            => RAF2_addr_in,
      rd_clk         => MEM_CLK,
      rd_en          => RAF2_rd_en,
      rst            => ASYNC_RST,
      wr_clk         => USER_CLK,
      wr_en          => RD2_ADD_EN,
      dout           => RAF2_dout,
      empty          => RAF2_empty,
      full           => RAF2_full,
      overflow       => RAF2_werr,
      valid          => RAF2_DVal,
      rd_data_count  => RAF2_cnt,
      wr_data_count  => RAF2_d_cnt); 
   
   -- READ Address Fifo #3
   RAF3 : as_fifo_w27_d32
   port map (
      din            => RAF3_addr_in,
      rd_clk         => MEM_CLK,
      rd_en          => RAF3_rd_en,
      rst            => ASYNC_RST,
      wr_clk         => USER_CLK,
      wr_en          => RD3_ADD_EN,
      dout           => RAF3_dout,
      empty          => RAF3_empty,
      full           => RAF3_full,
      overflow       => RAF3_werr,
      valid          => RAF3_DVal,
      rd_data_count  => RAF3_cnt,
      wr_data_count  => RAF3_d_cnt);      
   
   -- Steer Read Data Fifo        
   SRDF_d_cnt_xtd <= unsigned('0' & SRDF_d_cnt);
   SRDF_din <= RAF2_DVal & RAF1_DVal;
   SRDF_wr_en <= RAF1_DVal or RAF2_DVal or RAF3_DVal;
   SRDF : fwft_fifo_w2_d512
   port map (
      rd_clk         => MEM_CLK,
      wr_clk         => MEM_CLK,
      din            => SRDF_din,
      rd_en          => CORE_DATA_VLD,
      rst            => ASYNC_RST,
      wr_en          => SRDF_wr_en,
      dout           => SRDF_select,
      empty          => SRDF_empty,
      full           => SRDF_full,
      overflow       => SRDF_werr,
      wr_data_count  => SRDF_d_cnt);
   
   -- FIFOs for data width of 128
   use_128_data: if USER_DATA_WIDTH = 128 generate
      -- WRITE Fifo #1
      WF1 : as_fifo_w155_d32
      port map (
         din            => WF1_din,
         rd_clk         => MEM_CLK,
         rd_en          => WF1_rd_en,
         rst            => ASYNC_RST,
         wr_clk         => USER_CLK,
         wr_en          => WR1_EN,
         dout           => WF1_data,
         empty          => WF1_empty,
         full           => WF1_full,
         overflow       => WF1_werr,
         rd_data_count  => WF1_cnt,
         wr_data_count  => WF1_d_cnt);
      WF1_dout <= WF1_data(154 downto 128) & "0000000000000000" & WF1_data(127 downto 0);
      
      -- WRITE Fifo #2
      WF2 : as_fifo_w155_d32
      port map (
         din            => WF2_din,
         rd_clk         => MEM_CLK,
         rd_en          => WF2_rd_en,
         rst            => ASYNC_RST,
         wr_clk         => USER_CLK,
         wr_en          => WR2_EN,
         dout           => WF2_data,
         empty          => WF2_empty,
         full           => WF2_full,
         overflow       => WF2_werr,
         rd_data_count  => WF2_cnt,
         wr_data_count  => WF2_d_cnt);
      WF2_dout <= WF2_data(154 downto 128) & "0000000000000000" & WF2_data(127 downto 0);
      
      -- READ Data Fifo #1                          
      RDF1 : as_fifo_w128_d511
      port map (
         din      => CORE_DATA_RD(127 downto 0),
         rd_clk   => USER_CLK,
         rd_en    => RD1_DATA_EN,
         rst      => ASYNC_RST,
         wr_clk   => MEM_CLK,
         wr_en    => RDF1_wr_en,
         dout     => RD1_DATA,
         empty    => open,
         full     => RDF1_full,
         overflow => RDF1_werr, 
         wr_data_count => RDF1_cnt,
         valid    => RD1_DVAL);
      
      -- READ Data Fifo #2
      RDF2 : as_fifo_w128_d511 
      port map (
         din      => CORE_DATA_RD(127 downto 0),
         rd_clk   => USER_CLK,
         rd_en    => RD2_DATA_EN,
         rst      => ASYNC_RST,
         wr_clk   => MEM_CLK,
         wr_en    => RDF2_wr_en,
         dout     => RD2_DATA,
         empty    => open,
         full     => RDF2_full,
         overflow => RDF2_werr,    
         wr_data_count => RDF2_cnt,
         valid    => RD2_DVAL);
      
      -- READ Data Fifo #3
      RDF3 : as_fifo_w128_d511 
      port map (
         din      => CORE_DATA_RD(127 downto 0),
         rd_clk   => USER_CLK,
         rd_en    => RD3_DATA_EN,
         rst      => ASYNC_RST,
         wr_clk   => MEM_CLK,
         wr_en    => RDF3_wr_en,
         dout     => RD3_DATA,
         empty    => open,
         full     => RDF3_full,
         overflow => RDF3_werr,   
         wr_data_count => RDF3_cnt,
         valid    => RD3_DVAL);
   end generate;
   
   -- FIFOs for data width of 144
   use_144_data: if USER_DATA_WIDTH = 144 generate
      -- WRITE Fifo #1
      WF1 : as_fifo_w171_d32
      port map (
         din            => WF1_din,
         rd_clk         => MEM_CLK,
         rd_en          => WF1_rd_en,
         rst            => ASYNC_RST,
         wr_clk         => USER_CLK,
         wr_en          => WR1_EN,
         dout           => WF1_dout,
         empty          => WF1_empty,
         full           => WF1_full,
         overflow       => WF1_werr,
         rd_data_count  => WF1_cnt,
         wr_data_count  => WF1_d_cnt);
      
      -- WRITE Fifo #2
      WF2 : as_fifo_w171_d32
      port map (
         din            => WF2_din,
         rd_clk         => MEM_CLK,
         rd_en          => WF2_rd_en,
         rst            => ASYNC_RST,
         wr_clk         => USER_CLK,
         wr_en          => WR2_EN,
         dout           => WF2_dout,
         empty          => WF2_empty,
         full           => WF2_full,
         overflow       => WF2_werr,
         rd_data_count  => WF2_cnt,
         wr_data_count  => WF2_d_cnt);
      
      -- READ Data Fifo #1                          
      RDF1 : as_fifo_w144_d64
      port map (
         din      => CORE_DATA_RD,
         rd_clk   => USER_CLK,
         rd_en    => RD1_DATA_EN,
         rst      => ASYNC_RST,
         wr_clk   => MEM_CLK,
         wr_en    => RDF1_wr_en,
         dout     => RD1_DATA,
         empty    => open,
         full     => RDF1_full,
         overflow => RDF1_werr,
         valid    => RD1_DVAL);
      
      -- READ Data Fifo #2
      RDF2 : as_fifo_w144_d64
      port map (
         din      => CORE_DATA_RD,
         rd_clk   => USER_CLK,
         rd_en    => RD2_DATA_EN,
         rst      => ASYNC_RST,
         wr_clk   => MEM_CLK,
         wr_en    => RDF2_wr_en,
         dout     => RD2_DATA,
         empty    => open,
         full     => RDF2_full,
         overflow => RDF2_werr,
         valid    => RD2_DVAL);
      
      -- READ Data Fifo #3
      RDF3 : as_fifo_w144_d64 
      port map (
         din      => CORE_DATA_RD,
         rd_clk   => USER_CLK,
         rd_en    => RD3_DATA_EN,
         rst      => ASYNC_RST,
         wr_clk   => MEM_CLK,
         wr_en    => RDF3_wr_en,
         dout     => RD3_DATA,
         empty    => open,
         full     => RDF3_full,
         overflow => RDF3_werr,
         valid    => RD3_DVAL);
   end generate;
   
end RTL;
