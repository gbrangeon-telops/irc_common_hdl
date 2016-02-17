library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity aurora_402_2gb_v2p is
    generic (                    
            EXTEND_WATCHDOGS   : boolean := FALSE
    );
    port (     

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

    -- MGT Reference Clock Interface

            BREF_CLK     : in std_logic;

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

    -- System Interface

            DCM_NOT_LOCKED   : in std_logic;
            USER_CLK         : in std_logic;
            RESET            : in std_logic;
            POWER_DOWN       : in std_logic;
            LOOPBACK         : in std_logic_vector(1 downto 0)

         );

end aurora_402_2gb_v2p;

-- translate_off
architecture asim of aurora_402_2gb_v2p is       
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
