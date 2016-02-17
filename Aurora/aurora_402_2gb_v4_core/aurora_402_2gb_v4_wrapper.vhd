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
            SIMULATION_P       :   integer  :=   0;
            EXTEND_WATCHDOGS   : boolean := FALSE;
            LANE0_GT11_MODE_P    :   string   :=   "B";  -- Based on MGT Location
            LANE0_MGT_ID_P       :   integer  :=   1;    -- 0=A, 1=B
            LANE1_GT11_MODE_P    :   string   :=   "A";  -- Based on MGT Location
            LANE1_MGT_ID_P       :   integer  :=   0;    -- 0=A, 1=B
            TXPOST_TAP_PD_P              :   boolean  := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis    
    );
    port (                
    
      -- Simulation
      RX_SIM         : inout t_aurora_channel;
      TX_SIM         : inout t_aurora_channel;    

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

            REF_CLK1_LEFT    : in  std_logic;

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
            TX_OUT_CLK       : out std_logic

         );

end aurora_402_2gb_v4_core;                          



