library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

-- synthesis translate_off

library UNISIM;
use UNISIM.all;

-- synthesis translate_on

entity aurora_402_2gb_v4_core is
    generic 
    (                    
            --SIMULATION_P       :   integer  :=   0;
            EXTEND_WATCHDOGS   : boolean := FALSE;
            LANE0_GT11_MODE_P    :   string   :=   "B";  -- Based on MGT Location
            LANE0_MGT_ID_P       :   integer  :=   1;
            LANE1_GT11_MODE_P    :   string   :=   "A";  -- Based on MGT Location
            LANE1_MGT_ID_P       :   integer  :=   0;
            TXPOST_TAP_PD_P              :   boolean  := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis    
    );
    port (
    
      -- Simulation
      --RX_SIM         : inout t_aurora_channel;
      --TX_SIM         : inout t_aurora_channel;    

    -- LocalLink TX Interface

            TX_D             : in std_logic_vector(0 to 31);
            TX_REM           : in std_logic_vector(0 to 1);
            TX_SRC_RDY_N     : in std_logic;
            TX_SOF_N         : in std_logic;
            TX_EOF_N         : in std_logic;
            TX_DST_RDY_N     : out std_logic;

    -- LocalLink RX Interface

            RX_D             : out std_logic_vector(0 to 31);
            RX_REM           : out std_logic_vector(0 to 1);
            RX_SRC_RDY_N     : out std_logic;
            RX_SOF_N         : out std_logic;
            RX_EOF_N         : out std_logic;

    -- Native Flow Control Interface

            NFC_REQ_N        : in std_logic;
            NFC_NB           : in std_logic_vector(0 to 3);
            NFC_ACK_N        : out std_logic;

    -- MGT Serial I/O

            RXP              : in std_logic_vector(0 to 1);
            RXN              : in std_logic_vector(0 to 1);
            TXP              : out std_logic_vector(0 to 1);
            TXN              : out std_logic_vector(0 to 1);

    --MGT Reference Clock Interface

            REF_CLK    : in  std_logic;

    -- Error Detection Interface

            HARD_ERROR       : out std_logic;
            SOFT_ERROR       : out std_logic;
            FRAME_ERROR      : out std_logic;

    -- Status

            CHANNEL_UP       : out std_logic;
            LANE_UP          : out std_logic_vector(0 to 1);

    -- Clock Compensation Control Interface

            WARN_CC          : in std_logic;
            DO_CC            : in std_logic;

    -- Calibration Block Interface

            CALBLOCK_ACTIVE : out std_logic_vector(0 to 1);
            RESET_CALBLOCKS : in  std_logic;
            RX_SIGNAL_DETECT: in  std_logic_vector(0 to 1); 
            DCLK            : in  std_logic; 

    -- Ports for simulation

            MGT0_COMBUSIN   : in  std_logic_vector(15 downto 0); 
            MGT0_COMBUSOUT  : out std_logic_vector(15 downto 0); 

    -- Ports for simulation

            MGT1_COMBUSIN   : in  std_logic_vector(15 downto 0); 
            MGT1_COMBUSOUT  : out std_logic_vector(15 downto 0); 

    

    -- System Interface

            DCM_NOT_LOCKED   : in  std_logic;
            USER_CLK         : in  std_logic;
            SYNC_CLK         : in  std_logic;
            RESET            : in  std_logic;
            POWER_DOWN       : in  std_logic;
            LOOPBACK         : in  std_logic_vector(1 downto 0);
            PMA_INIT         : in  std_logic;
            TX_LOCK          : out std_logic;
            RX_LOCK          : out std_logic;
            TX_OUT_CLK       : out std_logic

         );

end aurora_402_2gb_v4_core;

-- translate_off
architecture asim of aurora_402_2gb_v4_core is       
   constant LATENCY : time := 801 ns;
   signal TX_DST_RDY_N_buf : std_logic;
   signal TX_DST_RDY_N_buf2 : std_logic;
   signal RX_SRC_RDY_N_buf : std_logic;
   signal RX_D_buf : std_logic_vector(0 to 31);
   signal RX_SOF_N_buf : std_logic;
   signal RX_EOF_N_buf : std_logic;  
   signal TX_OUT_CLKi : std_logic;   
   
   signal tx_mosi    : t_ll_mosi32;
   signal rx_mosi    : t_ll_mosi32;
   signal tx_miso    : t_ll_miso;
   signal rx_miso    : t_ll_miso;
   
   signal tx_busy    : std_logic;
   signal tx_dval    : std_logic;
   
   signal CHANNEL_UPi : std_logic;
   
   
begin
   --TX_DST_RDY_N <= TX_DST_RDY_N_buf2;
   HARD_ERROR <= '0';
   SOFT_ERROR <= '0';
   FRAME_ERROR <= '0';     
   --RX_REM <= (others => '0');   
   CALBLOCK_ACTIVE <= (others => '0');
   
   TX_OUT_CLK <= not TX_OUT_CLKi;
   tx_clock : process (REF_CLK)
      variable delay : integer range 0 to 31 := 0;
   begin      
      if rising_edge(REF_CLK) then
         if delay < 31 then
            delay := delay + 1;
         end if;                                
         if delay > 25 then
            TX_LOCK <= '1';
         else              
            TX_LOCK <= '0';
         end if;     
         if delay < 3 then
            TX_OUT_CLKi <= '0';   
         else
            TX_OUT_CLKi <= not TX_OUT_CLKi;
         end if;
      end if;
         
   end process;
   
   CHANNEL_UP <= CHANNEL_UPi;
   up_proc : process(USER_CLK, RESET)
   begin               
      if RESET = '1' then
         CHANNEL_UPi <= '0'; 
         LANE_UP <= "00";  
      elsif rising_edge(USER_CLK) then
         LANE_UP <= "11" after 12550 ns;         
         CHANNEL_UPi <= '1' after 16780 ns; 
      end if;
   end process;         
   
   -- TX mapping
   tx_mosi.sof  <= not TX_SOF_N;
   tx_mosi.eof  <= not TX_EOF_N;     
   tx_mosi.data <= TX_D;
   tx_mosi.drem <= TX_REM;   
   tx_dval      <= (not TX_SRC_RDY_N) and not tx_busy;
   tx_mosi.dval <= tx_dval;
   tx_busy      <= (tx_miso.busy or not CHANNEL_UPi);
   TX_DST_RDY_N <= tx_busy;    
   
   -- RX mapping  
   RX_SOF_N     <= not rx_mosi.sof;
   RX_EOF_N     <= not rx_mosi.eof; 
   RX_D         <= rx_mosi.data;
   RX_REM       <= rx_mosi.drem;
   RX_SRC_RDY_N <= not rx_mosi.dval;
   
serial : entity ll_serial_32
   generic map(
      Use_NFC => TRUE,
      baud_rate => 4_000_000_000.0,
      Latency => 820 ns
   )
   port map(
      NFC_REQ_N => NFC_REQ_N,
      NFC_NB => NFC_NB,
      NFC_ACK_N => NFC_ACK_N,
      TX_MOSI => tx_mosi,
      TX_MISO => tx_miso,
      RX_MOSI => rx_mosi,
      RX_MISO => rx_miso,
      SERIAL_TX => TXP(0),
      SERIAL_RX => RXP(0),
      ARESET => RESET,
      CLK => USER_CLK
   );   
   
end asim;   
-- translate_on
