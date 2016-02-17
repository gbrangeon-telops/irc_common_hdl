---------------------------------------------------------------------------------------------------
--
-- Title       : ZBT_Ctrl_Interface
-- Author      : Patrick Dubois
-- Company     : Telops
-- Date        : April 2007
--
---------------------------------------------------------------------------------------------------
-- SVN modified fields:
-- $Revision$
-- $Author $
-- $LastChangedDate$
---------------------------------------------------------------------------------------------------
--
-- Description : This module provides a fifo-like interface to a Write client and a separate Read
--               client. This module needs to connect to a core ZBT controller.
--             

---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;     
use ieee.numeric_std.all;                
library Common_HDL;                 
use Common_HDL.LfsrStd_Pkg.all;

entity ZBT_Ctrl_Interface is
   generic(                    
      Random_Pattern    : boolean := TRUE;   -- Pseudo-random data pattern for self-test. Linear data is false.
      SelfTest          : boolean := TRUE; 
      Delay_Adjust      : boolean := TRUE;   -- Perform IDELAY Adjustment
      Delay_Adjust_Sim  : boolean := FALSE;  -- Perform IDELAY during simulation
      Fixed_Delay       : integer := 0;      -- Delay to use if Delay_Adjust is false.     
      WRF_Latency       : integer := 6;      -- The number of clock cycles the WRF interface needs to stop when WR_AFULL becomes '1'
      RAF_Latency       : integer := 6;      -- The number of clock cycles the RAF interface needs to stop when RD_ADD_AFULL becomes '1'
      RDF_Latency       : integer := 13;     -- The number of clock cycles the RDF interface needs to stop when RDF_AFULL becomes '1'
      DLEN              : integer := 16;
      ALEN              : integer := 21      -- Supports only 21-bit wide OR LESS
      );
   port(
      ----------------------------------------------
      -- Write Interface Signals (using CLK)
      ----------------------------------------------
      WR_EN          : in  STD_LOGIC;
      WR_ADD         : in  STD_LOGIC_VECTOR(ALEN-1 downto 0);
      WR_DATA        : in  STD_LOGIC_VECTOR(DLEN-1 downto 0);
      WR_AFULL       : out STD_LOGIC;
      
      ----------------------------------------------
      -- Read Command Interface Signals (using CLK)
      ----------------------------------------------
      RD_ADD         : in  STD_LOGIC_VECTOR(ALEN-1 downto 0);
      RD_ADD_EN      : in  STD_LOGIC;
      RD_ADD_AFULL   : out STD_LOGIC;
      
      ----------------------------------------------
      -- ReadBack Interface Signals (using CLK)
      ----------------------------------------------
      RD_DATA_BUSY   : in  std_logic;
      RD_DATA        : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
      RD_DVAL        : out STD_LOGIC;
      RD_DATA_EN     : in  std_logic;       
      
      ----------------------------------
      -- Delay control
      ----------------------------------
      DLY_EN         : out std_logic;
      DLY_INC        : out std_logic;   
      DLY_RST        : out std_logic;
      DLY_CTRL_RDY   : in  std_logic; -- IDELAY_CTRL is ready (NOT SYNCHRONOUS)
      VALID_WINDOW   : out std_logic_vector(5 downto 0);
      CACHE_DETECTED : out std_logic;          
      EXTRA_CYCLE    : out std_logic;
      
      ----------------------------------------------
      -- ZBT core controller interface (using CLK_CORE)
      ----------------------------------------------
      WRF_RD_EN      : in  std_logic;
      WRF_DOUT       : out std_logic_vector(ALEN+DLEN-1 downto 0);       
      WRF_RD_ACK     : out std_logic;          
      WRF_EMPTY      : out std_logic; 
      
      RAF_RD_EN      : in  std_logic;
      RAF_DOUT       : out std_logic_vector(ALEN-1 downto 0);       
      RAF_RD_ACK     : out std_logic;       
      RAF_EMPTY      : out std_logic;  
      
      RDF_WR_EN      : in  std_logic;
      RDF_DIN        : in  std_logic_vector(DLEN-1 downto 0);       
      RDF_AFULL      : out std_logic;                   
      
      ----------------------------------------------
      -- Misc
      ----------------------------------------------
      RD_IDLE        : out std_logic;  -- '1' if both read fifos are empty
      WR_IDLE        : out std_logic;  -- '1' if both write fifo is empty      
      FIFO_ERR       : out std_logic;
      
      CTRL_BUSY        : out std_logic;  -- '1' when the controller is busy doing its self-test.
      SELF_TEST_PASS   : out std_logic;   
      RECALIBRATE      : in  std_logic;  -- Relaunch IDelay calibration
      DO_SELFTEST      : in  std_logic;  -- Continuously do the self-test once the Idelay tuning is done.
      TEST_ERROR_FOUND : out std_logic;  
      RESET_CORE       : out std_logic;
      
      CLK            : in  STD_LOGIC;  -- General system clock (probably 100 MHz)
      CLK_CORE       : in  std_logic;  -- Clock for the zbt core controller (probably 200 MHz)
      ARESET         : in  STD_LOGIC      
      );
end ZBT_Ctrl_Interface;

architecture RTL of ZBT_Ctrl_Interface is        
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component double_sync 
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D : in STD_LOGIC;
         Q : out STD_LOGIC := '0';
         RESET : in STD_LOGIC;
         CLK : in STD_LOGIC
         );
   end component;
   
   attribute keep : string;     
   
   -- translate_off
   signal random_vec : unsigned(7 downto 0) := (others => '0');
   -- translate_on                     
   
   -------------------------------------
   -- Common signals between blocks
   ------------------------------------- 
   signal RD_DATA_i     : STD_LOGIC_VECTOR(DLEN-1 downto 0);
   signal RST           : std_logic; 
   signal RESET_COREi    : std_logic;   
   signal busy_ad       : std_logic;  
   signal busy_st       : std_logic; 
   signal sel           : std_logic;   
   signal RD_IDLEi      : std_logic;
   signal WR_IDLEi      : std_logic;      
   signal EXTRA_CYCLEi  : std_logic;
   constant MAX_ALEN    : natural := 21;
   
   component fwft_fifo_w37_d16
      port (
         din: IN std_logic_VECTOR(36 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(36 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(3 downto 0));
   end component;    
   
   component fwft_fifo_w21_d16
      port (
         din: IN std_logic_VECTOR(20 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(20 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(3 downto 0));
   end component;  
   
   component as_fifo_w16_d31
      port (
         din: IN std_logic_VECTOR(15 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(15 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(4 downto 0));
   end component; 
   
   component fwft_fifo_w57_d16
      port (
         din: IN std_logic_VECTOR(56 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(56 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(3 downto 0));
   end component;       
   
   component as_fifo_w36_d31
      port (
         din: IN std_logic_VECTOR(35 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(35 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic;
         wr_data_count: OUT std_logic_VECTOR(4 downto 0));
   end component;                 
   
   -- Write Fifo
   signal wrf_din16_override : std_logic_vector(16 + MAX_ALEN-1 downto 0);                
   signal wrf_din36_override : std_logic_vector(36 + MAX_ALEN-1 downto 0);                
   signal wrf_wr_err : std_logic; attribute keep of wrf_wr_err : signal is "true";   
   signal wrf_din16   : std_logic_vector(16 + MAX_ALEN-1 downto 0);  
   signal wrf_din36   : std_logic_vector(36 + MAX_ALEN-1 downto 0); 
   signal wrf_dout16  : std_logic_vector(16 + MAX_ALEN-1 downto 0);  
   signal wrf_dout36  : std_logic_vector(36 + MAX_ALEN-1 downto 0);    
   signal wrf_wr_en : std_logic;
   signal wrf_afull : std_logic; 
   signal wrf_full  : std_logic;  
   signal WRF_EMPTY_i : std_logic;
   signal wrf_empty_sync : std_logic;   
   signal wrf_data_count : std_logic_vector(3 downto 0);   
   
   -- Read Address Fifo                             
   signal raf_wr_err : std_logic; attribute keep of raf_wr_err : signal is "true";                         
   signal raf_din   : std_logic_vector(ALEN-1 downto 0); 
   signal raf_din21 : std_logic_vector(MAX_ALEN-1 downto 0); 
   signal raf_dout21 : std_logic_vector(MAX_ALEN-1 downto 0); 
   signal raf_afull : std_logic;   
   signal raf_full  : std_logic; 
   signal raf_wr_en : std_logic;   
   signal RAF_EMPTY_i : std_logic;
   signal raf_empty_sync : std_logic;
   signal raf_data_count : std_logic_vector(3 downto 0);   
   
   -- Read Data Fifo  
   signal rdf_wr_err_sync : std_logic; attribute keep of rdf_wr_err_sync : signal is "true";
   signal rdf_wr_err : std_logic;  
   signal rdf_wr_count : std_logic_vector(4 downto 0);                   
   signal rdf_rd_ack : std_logic; 
   signal rdf_rd_ack_hold : std_logic;
   signal rdf_dout16 : std_logic_vector(15 downto 0);
   signal rdf_dout36 : std_logic_vector(35 downto 0);
   signal rdf_rd_en : std_logic;
   signal rdf_empty : std_logic;
   signal rdf_full : std_logic;
   signal RDF_AFULLi : std_logic;
   attribute keep of rdf_dout16 : signal is "true";
   attribute keep of rdf_dout36 : signal is "true";
   attribute keep of rdf_rd_ack : signal is "true";         
   
   signal DATA_ALL_5 : std_logic_vector(DLEN-1 downto 0);
   signal DATA_ALL_A : std_logic_vector(DLEN-1 downto 0);   
   signal ADD_ALL_5 : std_logic_vector(ALEN-1 downto 0);        
   signal ADD_ALL_A : std_logic_vector(ALEN-1 downto 0);        
   
   -- Self-test
   signal DATA_st          : std_logic_vector(DLEN-1 downto 0);
   signal RD_ADD_st        : std_logic_vector(ALEN-1 downto 0);
   signal WR_ADD_st        : std_logic_vector(ALEN-1 downto 0);
   signal raf_wr_en_st     : std_logic;
   signal wrf_wr_en_st     : std_logic; 
   signal self_test_pass_i : std_logic;  
   signal test_error_found_i : std_logic;     
   signal request_st       : std_logic;
   
   -- Auto-detect
   signal DLY_CTRL_RDY_sync     : std_logic;
   
   attribute KEEP of SELF_TEST_PASS : signal is "true";         
   attribute KEEP of TEST_ERROR_FOUND : signal is "true"; 
   attribute KEEP of VALID_WINDOW : signal is "true";    
   
   function RESIZE (ARG: STD_LOGIC_VECTOR; NEW_SIZE: NATURAL) return
      STD_LOGIC_VECTOR is
   begin
      return(STD_LOGIC_VECTOR(RESIZE(UNSIGNED(ARG), NEW_SIZE)));
   end;    
   
begin 
   
   CTRL_BUSY <= busy_st or busy_ad;   
   SELF_TEST_PASS <= self_test_pass_i;     
   TEST_ERROR_FOUND <= test_error_found_i;            
   
   -------------------------------------
   -- Synchronize towards CLK_CORE domain
   -------------------------------------
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET_COREi, CLK => CLK_CORE);	
   RESET_CORE <= RESET_COREi;
   
   sync_extra_cycle :  double_sync		     
   port map(d => EXTRA_CYCLEi, q => EXTRA_CYCLE, reset => '0', clk => CLK_CORE);    
   
   -------------------------------------
   -- Synchronize towards CLK domain
   -------------------------------------
   sync_RST_CLK : sync_reset
   port map(ARESET => ARESET, SRESET => RST, CLK => CLK);
   
   RAF_EMPTY <= RAF_EMPTY_i;
   sync_raf_empty :  double_sync
   port map(d => RAF_EMPTY_i, q => raf_empty_sync, reset => '0', clk => CLK); 
   
   WRF_EMPTY <= WRF_EMPTY_i;
   sync_wrf_empty :  double_sync
   port map(d => WRF_EMPTY_i, q => wrf_empty_sync, reset => '0', clk => CLK);   
   
   sync_rdf_wr_err : double_sync
   port map(d => rdf_wr_err, q => rdf_wr_err_sync, reset => '0', clk => CLK);   
   
   sync_DLY_CTRL_RDY :  double_sync
   port map(d => DLY_CTRL_RDY, q => DLY_CTRL_RDY_sync, reset => '0', clk => CLK);   
   -------------------------------------
   
   -------------------------------------   
   -- Multiplexers between blocks
   -------------------------------------   
   sel <= busy_ad or busy_st;
   
   wrf_din_For_16_Bit : if DLEN=16 generate
      wrf_din16 <=     
      resize(WR_ADD_st, MAX_ALEN) & resize(DATA_st, 16) when sel = '1' else
      resize(WR_ADD, MAX_ALEN) & resize(WR_DATA, 16);  
   end generate;
   
   wrf_din_For_36_Bit : if DLEN>16 generate
      wrf_din36 <=           
      resize(WR_ADD_st, MAX_ALEN) & resize(DATA_st, 36) when sel = '1' else
      resize(WR_ADD, MAX_ALEN) & resize(WR_DATA, 36);   
   end generate;   
   
   wrf_wr_en <=   
   wrf_wr_en_st when sel = '1' else
   WR_EN;        
   
   raf_din <=    
   RD_ADD_st when sel = '1' else
   RD_ADD;
   
   raf_wr_en <=   
   raf_wr_en_st when sel = '1' else
   RD_ADD_EN;        
   
   rdf_rd_en <=    
   '1' when sel = '1' else
   (RD_DATA_EN and not RD_DATA_BUSY);      
   
   RD_DVAL <= (rdf_rd_ack or rdf_rd_ack_hold) and not busy_st and not busy_ad;    
   ------------------------------------- 
   
   -------------------------------------   
   -- Register AFULL signals for 
   -- timing closure
   -------------------------------------    
   reg_afull : process(CLK)
   begin
      if rising_edge(CLK) then
         WR_AFULL <= wrf_afull or busy_st or busy_ad;
         RD_ADD_AFULL <= raf_afull or busy_st or busy_ad;     
      end if;      
   end process;    
   
   reg_afull_core : process(CLK_CORE)
   begin
      if rising_edge(CLK_CORE) then
         RDF_AFULL <= RDF_AFULLi;  
      end if;      
   end process;         
   -------------------------------------    
   
   
   FIFO_ERR <= raf_wr_err or rdf_wr_err_sync or wrf_wr_err;          
   
   WR_IDLE <= WR_IDLEi;
   RD_IDLE <= RD_IDLEi;
   idle_proc : process (CLK)
      variable zbt_rd_idle_cnt : unsigned(3 downto 0) := "0000";
      variable zbt_wr_idle_cnt : unsigned(2 downto 0) := "000";
   begin
      if rising_edge(CLK) then
         if zbt_rd_idle_cnt = "1111" then
            RD_IDLEi <= '1';
         else
            RD_IDLEi <= '0';
         end if;
         if raf_empty_sync = '1' and rdf_empty = '1' and zbt_rd_idle_cnt /= "1111" and RD_ADD_EN = '0' then
            zbt_rd_idle_cnt := zbt_rd_idle_cnt + 1;
         elsif raf_empty_sync = '0' or rdf_empty = '0' or RD_ADD_EN = '1' then
            zbt_rd_idle_cnt := "0000";
         end if;
         
         if zbt_wr_idle_cnt = "111" then
            WR_IDLEi <= '1';
         else
            WR_IDLEi <= '0';
         end if;
         if wrf_empty_sync = '0' or WR_EN = '1' then
            zbt_wr_idle_cnt := "000";
         elsif wrf_empty_sync = '1' and zbt_wr_idle_cnt /= "111" then
            zbt_wr_idle_cnt := zbt_wr_idle_cnt + 1;
         end if;            
      end if;
   end process;
   
   Fifo_For_16_Bit : if DLEN=16 generate
      
      ----------------------------
      -- Write Fifo (16 bit)
      ---------------------------- 
      wrf_afull <= '1' when (unsigned(wrf_data_count) > (15-WRF_Latency)) or wrf_full='1' or RST='1' else '0';    
      WRF_DOUT <= resize(wrf_dout16, ALEN+DLEN);
      wrf : fwft_fifo_w37_d16
      port map (     
         -- Write
         wr_clk => CLK,
         din => wrf_din16,         
         wr_en => wrf_wr_en, 
         full => wrf_full,  
         overflow => wrf_wr_err,
         wr_data_count => wrf_data_count,                
         -- Read
         rd_clk => CLK_CORE,
         rd_en => wrf_rd_en,
         dout => wrf_dout16,
         empty => WRF_EMPTY_i,
         valid => wrf_rd_ack,         
         -- Misc
         rst => ARESET);    
      
      ------------------------
      -- Read Data Fifo (16 bit)   
      ------------------------   
      RD_DATA_i <= resize(rdf_dout16, DLEN);  
      RD_DATA <= RD_DATA_i;
      rdf : as_fifo_w16_d31
      port map (
         --Write
         wr_clk => CLK_CORE,         
         din => RDF_DIN,
         wr_en => RDF_WR_EN,         
         full => rdf_full,
         wr_data_count => rdf_wr_count,
         overflow => rdf_wr_err,
         -- Read
         rd_clk => CLK,
         rd_en => rdf_rd_en,
         dout => rdf_dout16,
         valid => rdf_rd_ack,
         empty => rdf_empty,                   
         -- Misc
         rst => ARESET);                     
      
   end generate Fifo_For_16_Bit;  
   
   Fifo_For_36_Bit : if DLEN=36 generate
      
      ----------------------------
      -- Write Fifo (36 bit)
      ---------------------------- 
      wrf_afull <= '1' when (unsigned(wrf_data_count) > (15-WRF_Latency)) or wrf_full='1' or RST='1' else '0';    
      WRF_DOUT <= resize(wrf_dout36, ALEN+DLEN);
      wrf : fwft_fifo_w57_d16
      port map (     
         -- Write
         wr_clk => CLK,
         din => wrf_din36,         
         wr_en => wrf_wr_en, 
         full => wrf_full,  
         overflow => wrf_wr_err,
         wr_data_count => wrf_data_count,                
         -- Read
         rd_clk => CLK_CORE,
         rd_en => wrf_rd_en,
         dout => wrf_dout36,
         empty => WRF_EMPTY_i,
         valid => wrf_rd_ack,         
         -- Misc
         rst => ARESET);    
      
      ------------------------
      -- Read Data Fifo (36 bit)   
      ------------------------   
      RD_DATA_i <= resize(rdf_dout36, DLEN);  
      RD_DATA <= RD_DATA_i;
      rdf : as_fifo_w36_d31
      port map (
         --Write
         wr_clk => CLK_CORE,         
         din => RDF_DIN,
         wr_en => RDF_WR_EN,         
         full => rdf_full,
         wr_data_count => rdf_wr_count,
         overflow => rdf_wr_err,
         -- Read
         rd_clk => CLK,
         rd_en => rdf_rd_en,
         dout => rdf_dout36,
         valid => rdf_rd_ack,
         empty => rdf_empty,                   
         -- Misc
         rst => ARESET);                     
      
   end generate Fifo_For_36_Bit;     
   
   ----------------------------  
   -- Read Address Fifo 
   ---------------------------- 
   raf_afull <= '1' when (unsigned(raf_data_count) > (15-RAF_Latency)) or raf_full='1' or RST='1' else '0';                
   RAF_DOUT <= resize(raf_dout21, ALEN);    
   raf_din21 <= resize(raf_din, MAX_ALEN);
   raf : fwft_fifo_w21_d16
   port map (  
      --Write   
      wr_clk => CLK,
      wr_en => raf_wr_en,
      din => raf_din21, 
      full => raf_full,  
      overflow => raf_wr_err, 
      wr_data_count => raf_data_count,                        
      --Read
      rd_clk => CLK_CORE,
      rd_en => raf_rd_en,
      dout => raf_dout21,
      valid => raf_rd_ack,
      empty => RAF_EMPTY_i,
      --Misc
      rst => ARESET);         
   
   ------------------------
   -- Read Data Fifo    
   ------------------------       
   RDF_AFULLi <= '1' when (unsigned(rdf_wr_count) > (31-RDF_Latency+1)) or rdf_full='1' or RESET_COREi='1' else '0';         
   process(CLK, RST) begin
      if rising_edge(CLK) then
         if RST = '1' then
            rdf_rd_ack_hold <= '0'; 
         else
            if RD_DATA_BUSY = '1' and rdf_rd_ack = '1' and busy_ad = '0' and busy_st = '0' then -- Set
               rdf_rd_ack_hold <= '1';
            elsif RD_DATA_BUSY = '0' then -- Reset 
               rdf_rd_ack_hold <= '0';
            end if;
         end if;
      end if;
   end process;   
   
   
   
   --*********************************
   -- Self-test block
   --*********************************     
   self_test : block
      signal SIM : std_logic; 
      constant TESTLEN : integer := ALEN
      -- translate_off
      - (ALEN-7)
      -- translate_on
      ;              
      signal long_seed_WR   : std_logic_vector(19 downto 0);  
      signal long_seed_RD   : std_logic_vector(19 downto 0);
      signal LFSR_seed_WR   : std_logic_vector(TESTLEN-1 downto 0);
      signal LFSR_seed_RD   : std_logic_vector(TESTLEN-1 downto 0);  
      
      type t_st_fsm_state is (Idle, Init, DoTest, WaitForIdle, Done); 
      signal state_st : t_st_fsm_state;
      
      begin        
      
      Random_Pattern_TRUE : if Random_Pattern generate         
         long_seed_WR <= x"E9D30";   
         long_seed_RD <= x"A1E24";
         LFSR_seed_WR <= resize(long_seed_WR, TESTLEN);
         LFSR_seed_RD <= resize(long_seed_RD, TESTLEN);       
      end generate Random_Pattern_TRUE;
      
      Random_Pattern_FALSE : if not Random_Pattern generate         
         long_seed_WR <= (others => '0');
         long_seed_RD <= (others => '0');
         LFSR_seed_WR <= (others => '0');
         LFSR_seed_RD <= (others => '0');       
      end generate Random_Pattern_FALSE;      
      
      gen_Self_Test : if SelfTest generate            
         SIM <= 'L';
         -- translate_off
         SIM <= '1';
         -- translate_on         
         
         self_test_proc : process(CLK)                     
            variable wr_add_test : std_logic_vector(TESTLEN-1 downto 0);
            variable wr_add_test_full : std_logic_vector(ALEN-1 downto 0);
            variable rd_add_test : std_logic_vector(TESTLEN-1 downto 0);
            variable rd_add_test_full : std_logic_vector(ALEN-1 downto 0);
            variable rd_add_check : std_logic_vector(TESTLEN-1 downto 0);                     
            variable data_golden  : std_logic_vector(DLEN-1 downto 0);            
            variable enable_read : std_logic;
            variable enable_write : std_logic;
            variable error_found : std_logic; 
            
            -- translate_off
            variable wrf_afull_sim : std_logic;
            variable raf_afull_sim : std_logic;
            -- translate_on     
            
            variable wr_looped_once : std_logic;
            variable rd_looped_once : std_logic;                  
            
            function ADD_to_DATA(add : std_logic_vector; seed : std_logic_vector) return std_logic_vector is    
               variable data : unsigned(DLEN-1 downto 0); 
               variable add_full : unsigned(ALEN-1 downto 0);
            begin                     
               
               -- First, adjust address length
               add_full := resize(unsigned(add), ALEN);
               
               -- Do xor with seed to scramble data
               data := resize(add_full, DLEN) xor resize(unsigned(seed), DLEN); -- This is to make data different than address.
               
               if ALEN > DLEN then                  
                  -- Add the address LSBs to make sure that the data doesn't repeat (if there are more address bits than data bits).               
                  data := data + add_full(ALEN-1 downto DLEN);
               else
                  -- Make sure to fill the whole data range with data and not zeros
                  data := resize(data(ALEN-1 downto 0) & data(ALEN-1 downto 0), DLEN);
               end if;
               
               return std_logic_vector(data);
               
            end function ADD_to_DATA;  
            
            function myLFSR(S : Std_Logic_Vector) return Std_Logic_Vector is
            begin   
               if Random_Pattern then
                  return LFSR(S);
               else                             
                  return Std_Logic_Vector(unsigned(S) + 1);
               end if;
            end function;
            
            
         begin                 
            
            if rising_edge(CLK) then 
               
               -- translate_off
               wrf_afull_sim := random_vec(0);     
               raf_afull_sim := random_vec(1); 
               -- translate_on                                                                                  
               
               case state_st is
                  
                  when Idle =>         
                     busy_st <= '0';   
                     if request_st = '1' then
                        state_st <= Init;
                        busy_st <= '1';
                     end if;                  
                  
                  when Init =>      
                     busy_st <= '1';   
                     raf_wr_en_st <= '0';
                     wrf_wr_en_st <= '0';      
                     wr_add_test := LFSR_seed_WR;
                     rd_add_test := LFSR_seed_RD;
                     rd_add_check := LFSR_seed_RD;
                     enable_write := '1';
                     enable_read := '0';
                     self_test_pass_i <= '0';
                     error_found := '0';     
                     state_st <= DoTest;  
                     wr_looped_once := '0';
                     rd_looped_once := '0';
                  
                  when DoTest =>   
                     -- Write data
                     if wrf_afull = '0'        
                        -- translate_off
                        and wrf_afull_sim = '0'
                        -- translate_on
                        and enable_write = '1' then
                        busy_st <= '1';   
                        wrf_wr_en_st <= '1';   
                        
                        wr_add_test := myLFSR(wr_add_test);                         
                        wr_add_test_full := std_logic_vector(resize(wr_add_test, ALEN)); 
                        WR_ADD_st <= wr_add_test_full;    
                        DATA_st <= ADD_to_DATA(wr_add_test_full, long_seed_WR);
                        
                        -- Stop the write process when we went through all addresses twice.
                        if wr_add_test = LFSR_seed_WR then -- We looped once thru the addresses.
                           if wr_looped_once = '1' then
                              enable_write := '0'; -- We stop.
                           else
                              enable_read := '1'; 
                              wr_looped_once := '1';
                           end if;
                        end if;
                        
                     else
                        wrf_wr_en_st <= '0'; 
                     end if;                                                           
                     
                     -- Read data
                     if enable_read = '1' -- and busy_ad = '0'
                        -- translate_off
                        and raf_afull_sim = '0'
                        -- translate_on                     
                        and raf_afull = '0' then 
                        raf_wr_en_st <= '1';        
                        
                        rd_add_test := myLFSR(rd_add_test);                                                                                                                   
                        RD_ADD_st <= std_logic_vector(resize(rd_add_test, ALEN));                          
                        
                        -- Stop the read process when we went through all addresses twice.    
                        if rd_add_test = LFSR_seed_RD then -- We looped once thru the addresses.
                           if rd_looped_once = '1' then
                              enable_read := '0'; -- We stop.
                           else                              
                              rd_looped_once := '1';
                           end if;
                        end if;                        
                        
                     else   
                        raf_wr_en_st <= '0';
                     end if;  
                     
                     -- Process read data
                     if busy_st = '1' and rdf_rd_ack = '1' then
                        
                        rd_add_check := myLFSR(rd_add_check);                             
                        data_golden := ADD_to_DATA(rd_add_check, long_seed_WR);                        
                        
                        if RD_DATA_i /= data_golden then 
                           error_found := '1';    
                           assert FALSE report "ZBT self-test error found!" severity ERROR;                        
                        end if;                                                  
                        
                     end if; 
                     
                     -- Release hold from self-test when done
                     if (enable_read = '0' and enable_write = '0' and RD_IDLEi = '1') or error_found = '1' then                        
                        if error_found = '0' then
                           self_test_pass_i <= '1';                          
                        end if;  
                        state_st <= WaitForIdle;
                     end if;
                     test_error_found_i <= error_found; 
                  
                  when WaitForIdle =>  
                     wrf_wr_en_st <= '0'; 
                     raf_wr_en_st <= '0';
                     if WR_IDLEi = '1' and RD_IDLEi = '1' then     
                        state_st <= Done;  
                        busy_st <= '0';
                     end if;
                  
                  when Done =>  
                     if request_st = '1' then
                        state_st <= Init; 
                     end if;
                     
                  
                  when others =>
               end case;
               
               if RST = '1' then 
                  state_st <= Idle;
                  busy_st <= '0';  
                  self_test_pass_i <= '0';
                  error_found := '0';                   
               end if;
               
            end if; -- if rising_edge
            
         end process; 
      end generate gen_Self_Test; 
      
      gen_Not_Self_Test : if not SelfTest generate            
         
         busy_st <= '0';   
         raf_wr_en_st <= '0';
         wrf_wr_en_st <= '0';
         self_test_pass_i <= '1';   
         
      end generate gen_Not_Self_Test;       
      
   end block;        
   
   --*********************************************************
   -- Cache auto detection, idelay adjust and self-test
   --*********************************************************
   auto_detect : block         
      type t_detect_fsm_state is (Init, Read1, Read2, Write1, Write2, AnalyzeResponse1, AnalyzeResponse2, AnalyzeResponse3, FindDelayLimits, AdjustDelay, WaitForStableDelay, Done);
      constant DLYLEN   : integer := 6;                     
      constant max_delay : integer := 63;
      signal DLY_ENi : std_logic;      
      
      begin                                 
      
      auto_detect_proc : process(CLK)      
         variable detect_state: t_detect_fsm_state;      
         variable delay                : unsigned(DLYLEN-1 downto 0); 
         variable FinalDelay           : std_logic;
         variable FinalCheck           : std_logic;
         variable DelayCnt             : integer range 0 to 15;                   
         constant INC : std_logic      := '1';
         constant DEC : std_logic      := '0'; 
         variable previous_st_pass     : std_logic;    
         variable first_time           : boolean;   
         variable first_pass           : std_logic;
         variable target_delay         : unsigned(DLYLEN-1 downto 0); 
         variable best_delay           : unsigned(DLYLEN-1 downto 0); 
         variable best_delay_temp      : unsigned(DLYLEN downto 0); 
         variable best_window          : unsigned(DLYLEN-1 downto 0);        
         variable best_extra_cycle     : std_logic;
         variable current_window       : unsigned(DLYLEN-1 downto 0); 
         variable last_transition_delay: unsigned(DLYLEN-1 downto 0); 
         constant middle_delay         : unsigned(DLYLEN-1 downto 0) := '0' & (DLYLEN-2 downto 0 => '1');
         constant max_delay            : unsigned(DLYLEN-1 downto 0) := (others => '1'); 
         variable currently_in_valid_window : std_logic;
         
         constant fixed_delay_uns      : unsigned(DLYLEN-1 downto 0) := to_unsigned(Fixed_Delay, DLYLEN);
         
         
         variable toggle               : std_logic := '0';
         
         attribute keep of detect_state   		: variable is "true";
         attribute keep of delay          		: variable is "true";
         attribute keep of FinalDelay     		: variable is "true";
         attribute keep of FinalCheck         	: variable is "true";
         attribute keep of DelayCnt           	: variable is "true";
         attribute keep of previous_st_pass   	: variable is "true";
         attribute keep of first_time         	: variable is "true";
         attribute keep of target_delay       	: variable is "true";
         attribute keep of best_window       	: variable is "true";
         attribute keep of current_window       : variable is "true";
         attribute keep of last_transition_delay: variable is "true";
         
      begin        
         
         DLY_EN <= DLY_ENi; 
         
         toggle := '0';
         gen_test_data : for i in 0 to DLEN-1 loop                        
            DATA_ALL_A(i) <= toggle;
            toggle := not toggle;
            DATA_ALL_5(i) <= toggle;            
         end loop;
         
         toggle := '0';
         Test_Add_For_21_Bit : for i in 0 to ALEN-1 loop   
            ADD_ALL_A(i) <= toggle;
            toggle := not toggle;
            ADD_ALL_5(i) <= toggle;             
         end loop;       
         
         if rising_edge(CLK) then
            if RST = '1' then          
               DLY_ENi <= '0';
               detect_state := Init;  
               DelayCnt := 0;               
               delay := to_unsigned(0, delay'LENGTH);  -- Only reset the delay during reset, NOT during Init state.
               EXTRA_CYCLEi <= '0';
            else      
               
               case detect_state is
                  
                  when Init =>    
                     request_st <= '0';
                     busy_ad <= '1';
                     CACHE_DETECTED <= '0';                     
                     DLY_ENi <= '0'; 
                     DLY_INC <= INC;
                     FinalDelay := '0';
                     FinalCheck := '0'; 
                     best_window := (others => '0'); 
                     best_delay  := (others => '0'); 
                     best_extra_cycle := '0';
                     current_window := (others => '0');           
                     currently_in_valid_window := '0';
                     last_transition_delay := (others => '0');
                     VALID_WINDOW <= (others => '0');
                     target_delay := middle_delay;   
                     EXTRA_CYCLEi <= '0';
                     first_time := true;   
                     first_pass := '1';
                     if DelayCnt = 15 and DLY_CTRL_RDY_sync = '1' then
                        detect_state := Write1;                         
                        DelayCnt := 0;
                     elsif DelayCnt < 15 then
                        DelayCnt := DelayCnt + 1; -- To make sure that all the clocks are stable enough.
                     end if;
                  
                  when Write1 =>    
                     if FinalDelay = '0' or FinalCheck = '1' then                        
                        request_st <= '1';   
                     end if;                                      
                     previous_st_pass := self_test_pass_i;
                     detect_state := AnalyzeResponse2;
                  
                  when AnalyzeResponse2 =>
                     if FinalDelay = '0' or FinalCheck = '1' then                        
                        request_st <= '0';   
                        if DelayCnt = 4 then  
                           DelayCnt := 0; 
                           if busy_st = '0' then    
                              if first_time then
                                 first_time := false;        
                                 previous_st_pass := self_test_pass_i;
                                 if self_test_pass_i = '1' then
                                    currently_in_valid_window := '1';
                                 end if;
                              end if;
                              CACHE_DETECTED <= self_test_pass_i;                           
                              detect_state := AnalyzeResponse3;                                                                                                                         
                              
                           end if;   
                        else   
                           DelayCnt := DelayCnt + 1;
                        end if;     
                     else
                        detect_state := AdjustDelay;
                     end if;
                     
                  
                  when AnalyzeResponse3 =>    
                     
                     if FinalCheck = '1' then
                        detect_state := Done;
                     elsif FinalDelay = '1'  then
                        detect_state := AdjustDelay;
                     else
                        detect_state := FindDelayLimits;
                     end if;                                            
                     
                  
                  when FindDelayLimits =>   
                     if Delay_Adjust = FALSE 
                        -- translate_off
                        or (Delay_Adjust_Sim = FALSE)
                        -- translate_on
                        then
                        target_delay := fixed_delay_uns;  
                        detect_state := AdjustDelay;
                     else  
                        if previous_st_pass = '0' and self_test_pass_i = '1' then
                           -- Found BAD -> GOOD transition    
                           current_window := (others => '0');
                           currently_in_valid_window := '1';
                           last_transition_delay := delay;
                           
                        elsif (previous_st_pass = '1' and self_test_pass_i = '0') 
                           or (delay = max_delay and currently_in_valid_window = '1') then
                           -- Found GOOD -> BAD transition                          
                           currently_in_valid_window := '0';
                           if current_window > best_window then
                              best_window  := current_window;  
                              best_extra_cycle := EXTRA_CYCLEi;
                              VALID_WINDOW <= std_logic_vector(current_window);
                              best_delay_temp := delay + resize(last_transition_delay, best_delay_temp'LENGTH);
                              best_delay := resize(best_delay_temp / 2, best_delay'LENGTH);
                           end if;
                           current_window := (others => '0');  
                        end if;
                        
                        if delay = max_delay then
                           -- Reached limit of the range. Time to make final choice.
                           detect_state := AdjustDelay;   
                           if first_pass = '1' then
                              target_delay := (others => '0');  
                              current_window := (others => '0');  
                              last_transition_delay := (others => '0');
                              EXTRA_CYCLEi <= '1'; 
                           else
                              target_delay := best_delay;
                              EXTRA_CYCLEi <= best_extra_cycle;
                           end if;
                        else
                           DLY_INC <= INC;  
                           DLY_ENi <= '1';
                           delay := delay + 1; 
                           if currently_in_valid_window = '1' then
                              current_window := current_window +1 ;
                           end if;
                           detect_state := WaitForStableDelay;
                        end if;                         
                     end if;
                  
                  when AdjustDelay =>                        
                     FinalDelay := '1';
                     if delay > target_delay then
                        DLY_INC <= DEC; -- Decrement delay                  
                        DLY_ENi <= '1';                                  
                        delay := delay - 1;
                        detect_state := WaitForStableDelay;
                     elsif delay < target_delay then
                        DLY_INC <= INC; -- Increment delay                  
                        DLY_ENi <= '1';                                  
                        delay := delay + 1;
                        detect_state := WaitForStableDelay;                        
                     else                                                  
                        DLY_ENi <= '0';                                 
                        detect_state := Write1;
                        if first_pass = '1' then
                           first_pass := '0';
                           FinalCheck := '0';  
                           FinalDelay := '0';
                        else
                           FinalCheck := '1';                                                                                                                               
                        end if;
                     end if;   
                     
                  
                  when WaitForStableDelay =>  
                     DLY_ENi <= '0';
                     detect_state := Write1;                                     
                     
                  
                  when Done =>          
                     busy_ad <= '0';         
                     if RECALIBRATE = '1' then
                        DLY_RST <= '1';      
                        detect_state := Init;            
                        delay := to_unsigned(0, delay'LENGTH);  
                        DelayCnt := 0;
                     elsif DO_SELFTEST = '1' then
                        request_st <= '1';      
                     else
                        request_st <= '0';
                     end if;
                     
                  
                  when others =>
                     detect_state := Init;
                  
               end case;               
               
            end if;
         end if;
      end process; 
   end block;   
   
end RTL;

