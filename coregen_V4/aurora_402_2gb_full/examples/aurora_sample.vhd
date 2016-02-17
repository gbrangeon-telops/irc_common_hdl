--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date: 2005/12/15 00:35:57 $
--          Tag:  $Name: i+IP+98818 $
--         File:  $RCSfile: aurora_sample_v4_vhd.ejava,v $
--          Rev:  $Revision: 1.1.2.9 $
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  AURORA_SAMPLE
--
--  Aurora Generator
--
--  Author: Nigel Gulstone,
--          Xilinx Embedded Networking Systems Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: Sample Instantiation of a 2 4-byte lane module.
--               Only tests initialization in hardware.
--
--  Note:  This sample design is intended for use on a Xilinx ML421
--         prototyping Board which contains an 4VFX60 part.  Aurora
--         configurations that are too large to fit within this part
--         cannot use this sample design as is.  If you wish to use
--         this design with larger configurations of Aurora or with
--         a custom board, you must modify this source file and the
--         aurora_sample.ucf file as needed.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.AURORA.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.all;
-- synthesis translate_on

entity aurora_sample is
    generic (
            LANE0_GT11_MODE_P  : string  := "B";  -- Based on MGT Location
            LANE0_MGT_ID_P     : integer := 1;
            LANE1_GT11_MODE_P  : string  := "A";  -- Based on MGT Location
            LANE1_MGT_ID_P     : integer := 0;
            EXTEND_WATCHDOGS   : boolean := FALSE;
            SIMULATION_P       : integer := 0;                            -- Set to 1 for simulation
            TX_FD_MIN_P        : std_logic_vector(8 downto 0) := "001111101";  -- floor (128*Tpclk/Tdclk) - 3
            RX_FD_MIN_P        : std_logic_vector(8 downto 0) := "001111101";  -- floor (128*Tpclk/Tdclk) - 3
            DCLK_PERIOD_NS_P   : integer   := 20;                            -- 40ns to 20 ns, default 20 ns (50 Mhz)
            TXPOST_TAP_PD_P    : boolean   := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis    
            );
    port (

    -- User I/O

            RESET             : in std_logic;
            HARD_ERROR        : out std_logic;
            SOFT_ERROR        : out std_logic;
            FRAME_ERROR       : out std_logic;
            ERROR_COUNT       : out std_logic_vector(0 to 7);
            LANE_UP           : out std_logic_vector(0 to 1);
            CHANNEL_UP        : out std_logic;
            INIT_CLK          : in  std_logic;
            PMA_INIT          : in  std_logic;
            RX_SIGNAL_DETECT  : in  std_logic_vector(0 to 1);
            RESET_CALBLOCKS   : in  std_logic;

    -- Clocks

           REF_CLK1_LEFT_P : in  std_logic;
           REF_CLK1_LEFT_N : in  std_logic;

    -- MGT I/O

            RXP               : in std_logic_vector(0 to 1);
            RXN               : in std_logic_vector(0 to 1);
            TXP               : out std_logic_vector(0 to 1);
            TXN               : out std_logic_vector(0 to 1)

         );

end aurora_sample;

architecture MAPPED of aurora_sample is

-- Parameter Declarations --

    constant DLY : time := 1 ns;

-- External Register Declarations --

    signal HARD_ERROR_Buffer  : std_logic;
    signal SOFT_ERROR_Buffer  : std_logic;
    signal FRAME_ERROR_Buffer : std_logic;
    signal LANE_UP_Buffer     : std_logic_vector(0 to 1);
    signal CHANNEL_UP_Buffer  : std_logic;
    signal TXP_Buffer         : std_logic_vector(0 to 1);
    signal TXN_Buffer         : std_logic_vector(0 to 1);

-- Internal Register Declarations --

    signal reset_debounce_r   : std_logic_vector(0 to 3);
    signal pma_init_r         : std_logic;
    signal init_clk_i         : std_logic;
    signal reset_calblocks_r  : std_logic;
    signal rx_signal_detect_r : std_logic_vector(0 to 1);

-- Wire Declarations --

    -- LocalLink TX Interface

    signal tx_d_i             : std_logic_vector(0 to 63);
    signal tx_rem_i           : std_logic_vector(0 to 2);
    signal tx_src_rdy_n_i     : std_logic;
    signal tx_sof_n_i         : std_logic;
    signal tx_eof_n_i         : std_logic;

    signal tx_dst_rdy_n_i     : std_logic;

    -- LocalLink RX Interface

    signal rx_d_i             : std_logic_vector(0 to 63);
    signal rx_rem_i           : std_logic_vector(0 to 2);
    signal rx_src_rdy_n_i     : std_logic;
    signal rx_sof_n_i         : std_logic;
    signal rx_eof_n_i         : std_logic;

    -- Native Flow Control Interface

    signal nfc_req_n_i        : std_logic;
    signal nfc_nb_i           : std_logic_vector(0 to 3);
    signal nfc_ack_n_i        : std_logic;

    -- MGT Reference Clock Interface

    signal ref_clk1_left_i      : std_logic;
    signal ref_clk2_left_i      : std_logic;

    -- Error Detection Interface

    signal hard_error_i       : std_logic;
    signal soft_error_i       : std_logic;
    signal frame_error_i      : std_logic;

    -- Status

    signal channel_up_i       : std_logic;
    signal lane_up_i          : std_logic_vector(0 to 1);

    -- Clock Compensation Control Interface

    signal warn_cc_i          : std_logic;
    signal do_cc_i            : std_logic;

    -- System Interface

    signal dcm_not_locked_i   : std_logic;
    signal user_clk_i         : std_logic;
    signal reset_i            : std_logic;
    signal power_down_i       : std_logic;
    signal loopback_i         : std_logic_vector(0 to 1);
    signal tx_lock_i          : std_logic;
    signal tx_out_clk_i       : std_logic;

    -- Frame check signals

    signal error_count_i      : std_logic_vector(0 to 7);
    signal ERROR_COUNT_Buffer : std_logic_vector(0 to 7);
    signal test_reset_i       : std_logic;

    signal debounce_pma_init_r  : std_logic_vector(0 to 3);

    -- Ports for simulation
    signal mgt0_combusout_i : std_logic_vector(15 downto 0);
    signal mgt1_combusout_i : std_logic_vector(15 downto 0);

    -- ground and tied_to_vcc_i signals
    signal  tied_to_ground_i                :   std_logic;
    signal  tied_to_ground_vec_i            :   std_logic_vector(63 downto 0);
    signal  tied_to_vcc_i                   :   std_logic;
    signal  tied_to_vcc_vec_i               :   std_logic_vector(63 downto 0);

-- Component Declarations --

    component IBUFGDS

        port (
                O  :  out STD_ULOGIC;
                I  : in STD_ULOGIC;
                IB : in STD_ULOGIC
             );

    end component;


    component BUFG

        port (

                O : out std_ulogic;
                I : in  std_ulogic

             );

    end component;

    component GT11CLK_MGT
    generic (
                SYNCLK1OUTEN : string := "ENABLE";
                SYNCLK2OUTEN : string := "DISABLE"
            );

     port (
               SYNCLK1OUT : out std_ulogic;
               SYNCLK2OUT : out std_ulogic;
               MGTCLKN    : in std_ulogic;
               MGTCLKP    : in std_ulogic
           );
    end component;

    component IBUFG

        port (

                O : out std_ulogic;
                I : in  std_ulogic

             );

    end component;


    component CLOCK_MODULE
        port (
                MGT_CLK                 : in std_logic;
                MGT_CLK_LOCKED          : in std_logic;
                USER_CLK                : out std_logic;
                SYNC_CLK                : out std_logic;
                DCM_NOT_LOCKED          : out std_logic
             );
    end component;


    component aurora_402_2gb_full
        generic (
                EXTEND_WATCHDOGS     :   boolean  := FALSE;
                SIMULATION_P         :   integer  :=   0;
                LANE0_GT11_MODE_P    :   string   :=   "B";  -- Based on MGT Location
                LANE0_MGT_ID_P       :   integer  :=   1;
                LANE1_GT11_MODE_P    :   string   :=   "A";  -- Based on MGT Location
                LANE1_MGT_ID_P       :   integer  :=   0;
                TX_FD_MIN_P          :   std_logic_vector(8 downto 0) :=   "001111101";      -- floor (128*Tpclk/Tdclk) - 3
                RX_FD_MIN_P          :   std_logic_vector(8 downto 0) :=   "001111101";      -- floor (128*Tpclk/Tdclk) - 3
                DCLK_PERIOD_NS_P     :   integer                      :=   20;    -- Integer period between 20ns and 40ns (50Mhz to 25Mhz). Default is 20 ns
                TXPOST_TAP_PD_P      :   boolean                      := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis    

                );
        port (
        -- LocalLink TX Interface

                TX_D             : in std_logic_vector(0 to 63);
                TX_REM           : in std_logic_vector(0 to 2);
                TX_SRC_RDY_N     : in std_logic;
                TX_SOF_N         : in std_logic;
                TX_EOF_N         : in std_logic;
                TX_DST_RDY_N     : out std_logic;

        -- LocalLink RX Interface

                RX_D             : out std_logic_vector(0 to 63);
                RX_REM           : out std_logic_vector(0 to 2);
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

                REF_CLK1_LEFT : in std_logic;


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
                DISABLE_CALBLOCK: in  std_logic_vector(0 to 1);
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

                DCM_NOT_LOCKED   : in std_logic;
                USER_CLK         : in std_logic;
                PMA_INIT         : in std_logic;
                RESET            : in std_logic;
                POWER_DOWN       : in std_logic;
                LOOPBACK         : in std_logic_vector(1 downto 0);
                TX_OUT_CLK       : out std_logic
            );

    end component;


    component UNUSED_MGT

        generic (
                SIMULATION_P      : integer := 0;        -- Set to 1 when using module in simulation
                GT11_MODE_P       : string  := "A";      -- Default Location
                MGT_ID_P          : integer :=  1;       -- Default Location 
                TX_FD_MIN_P       : std_logic_vector(8 downto 0) := "001111101"; -- Floor (128*Ttxoutclk1/Tdclk) - 3
                TX_FD_EN_P        : std_logic := '1'; -- 1 = enable calblock TX frequency test
                RX_FD_MIN_P       : std_logic_vector(8 downto 0) := "001111101"; -- Floor (128*Trxrecclk1/Tdclk) - 3
                RX_FD_EN_P        : std_logic := '1'; -- 1 = enable calblock RX frequency test
                TX_FD_WIDTH_P     : integer := 9;       -- TX Fdetect MIN value width
                RX_FD_WIDTH_P     : integer := 9;       -- RX Fdetect MIN value width
                DCLK_PERIOD_NS_P  : integer := 20;      -- Must be between 25Mhz and 50Mhz, default is 50Mhz
                TXPOST_TAP_PD_P   : boolean := FALSE  -- Default is false, set to true for serial loopback or tuned preemphasis
             );

        port (

            -- Calibration Block Ports

                MGT0_ACTIVE_OUT          : out std_logic;
                MGT0_DISABLE_IN          : in  std_logic;
                MGT0_DRP_RESET_IN        : in  std_logic;
                MGT0_RX_SIGNAL_DETECT_IN : in  std_logic;
                MGT0_TX_SIGNAL_DETECT_IN : in  std_logic;

            -- Dynamic Reconfiguration Port (DRP)

                MGT0_DCLK_IN             : in  std_logic;

            -- PLL Lock

                MGT0_RXLOCK_OUT          : out std_logic;
                MGT0_TXLOCK_OUT          : out std_logic;

            -- Ports for Simulation

                MGT0_COMBUSIN_IN         : in  std_logic_vector(15 downto 0);
                MGT0_COMBUSOUT_OUT       : out std_logic_vector(15 downto 0);

            -- Reference Clocks

                MGT0_GREFCLK_IN          : in  std_logic;
                MGT0_REFCLK1_IN          : in  std_logic;
                MGT0_REFCLK2_IN          : in  std_logic;

            -- Resets

                MGT0_RXPMARESET_IN       : in  std_logic;
                MGT0_RXRESET_IN          : in  std_logic;
                MGT0_TXPMARESET_IN       : in  std_logic;
                MGT0_TXRESET_IN          : in  std_logic;

            -- Serial Ports

                MGT0_RX1N_IN             : in  std_logic;
                MGT0_RX1P_IN             : in  std_logic;
                MGT0_TX1N_OUT            : out std_logic;
                MGT0_TX1P_OUT            : out std_logic

             );
    end component;


    component STANDARD_CC_MODULE

        port (

        -- Clock Compensation Control Interface

                WARN_CC        : out std_logic;
                DO_CC          : out std_logic;

        -- System Interface

                DCM_NOT_LOCKED : in std_logic;
                USER_CLK       : in std_logic;
                CHANNEL_UP     : in std_logic

             );

    end component;


    component FRAME_GEN
    port
    (
        -- User Interface
        TX_D            : out  std_logic_vector(0 to 63);
        TX_REM          : out  std_logic_vector(0 to 2);
        TX_SOF_N        : out  std_logic;
        TX_EOF_N        : out  std_logic;
        TX_SRC_RDY_N    : out  std_logic;
        TX_DST_RDY_N    : in  std_logic;

        -- System Interface
        USER_CLK        : in  std_logic;
        RESET           : in  std_logic
    );
    end component;


    component FRAME_CHECK
    port
    (
        -- User Interface
        RX_D            : in  std_logic_vector(0 to 63);
        RX_REM          : in  std_logic_vector(0 to 2);
        RX_SOF_N        : in  std_logic;
        RX_EOF_N        : in  std_logic;
        RX_SRC_RDY_N    : in  std_logic;

        -- System Interface
        USER_CLK        : in  std_logic;
        RESET           : in  std_logic;
        ERROR_COUNT     : out std_logic_vector(0 to 7)

    );
    end component;


begin

    HARD_ERROR  <= HARD_ERROR_Buffer;
    SOFT_ERROR  <= SOFT_ERROR_Buffer;
    FRAME_ERROR <= FRAME_ERROR_Buffer;
    ERROR_COUNT <= ERROR_COUNT_Buffer;
    LANE_UP     <= LANE_UP_Buffer;
    CHANNEL_UP  <= CHANNEL_UP_Buffer;
    TXP         <= TXP_Buffer;
    TXN         <= TXN_Buffer;

-- Main Body of Code --


    -- Bufg used to drive user clk on global clock net.
    user_clock_bufg_i : BUFG

        port map (

                    I => tx_out_clk_i,
                    O => user_clk_i

                 );


    -- Debouncing circuit for PMA_INIT --

    -- Assign an IBUFG to INIT_CLK

    init_clk_ibufg_i : IBUFG
    port map
    (
        I   =>  INIT_CLK,
        O   =>  init_clk_i
    );


    -- Debounce the PMA_INIT signal using the INIT_CLK

    process(init_clk_i)
    begin
        if(init_clk_i'event and init_clk_i='1') then
            debounce_pma_init_r <=  PMA_INIT & debounce_pma_init_r(0 to 2);
        end if;
    end process;

    pma_init_r  <=   debounce_pma_init_r(0) and
                     debounce_pma_init_r(1) and
                     debounce_pma_init_r(2) and
                     debounce_pma_init_r(3);


    -- Register the calblock control signals

    process(init_clk_i)
    begin
        if (init_clk_i'event and init_clk_i = '1') then
            reset_calblocks_r  <= RESET_CALBLOCKS;
            rx_signal_detect_r <= RX_SIGNAL_DETECT;
        end if;
    end process;


    -- Clock Buffers --

    GT11CLK_MGT_LEFT : GT11CLK_MGT
    generic map
    (
        SYNCLK1OUTEN   => "ENABLE",
        SYNCLK2OUTEN   => "DISABLE"
    )
    port map
    (
        MGTCLKN    =>  REF_CLK1_LEFT_N,
        MGTCLKP    =>  REF_CLK1_LEFT_P,
        SYNCLK1OUT =>  ref_clk1_left_i,
        SYNCLK2OUT =>  ref_clk2_left_i
    );




    -- Register User I/O --

    -- Register User Outputs from core.

    process (user_clk_i)

    begin

        if (user_clk_i 'event and user_clk_i = '1') then

            HARD_ERROR_Buffer  <= hard_error_i;
            SOFT_ERROR_Buffer  <= soft_error_i;
            FRAME_ERROR_Buffer <= frame_error_i;
            ERROR_COUNT_Buffer <= error_count_i;
            LANE_UP_Buffer     <= lane_up_i;
            CHANNEL_UP_Buffer  <= channel_up_i;

        end if;

    end process;
   --

    -- Tie off static signals --
    
    tied_to_ground_i        <=    '0';
    tied_to_ground_vec_i    <=    (others=>'0');
    tied_to_vcc_i           <=    '1';
    tied_to_vcc_vec_i       <=    (others=>'1');
    
    -- Tie off unused signals --

    -- Native Flow Control Interface

    nfc_req_n_i <= '1';
    nfc_nb_i    <= "0000";


    -- System Interface

    dcm_not_locked_i <= '0';
    power_down_i     <= '0';
    loopback_i       <= "00";


    -- Debounce the Reset signal --

    -- Simple Debouncer for Reset button. The debouncer has an
    -- asynchronous reset tied to PMA_INIT. This is primarily for simulation, to ensure
    -- that unknown values are not driven into the reset line

    process (user_clk_i, pma_init_r)
    begin
        if (pma_init_r = '1') then
            reset_debounce_r <= "1111";
        elsif (user_clk_i 'event and user_clk_i = '1') then
            reset_debounce_r <= RESET & reset_debounce_r(0 to 2);
        end if;
    end process;


    reset_i <= reset_debounce_r(0) and
               reset_debounce_r(1) and
               reset_debounce_r(2) and
               reset_debounce_r(3);


    -- Module Instantiations --

    -- Use one of the lane up signals to reset the test logic

    test_reset_i <= not lane_up_i(0);


    -- Connect a frame checker to the user interface

    frame_check_i : FRAME_CHECK
    port map
    (
        -- User Interface
        RX_D            =>  rx_d_i,
        RX_REM          =>  rx_rem_i,
        RX_SOF_N        =>  rx_sof_n_i,
        RX_EOF_N        =>  rx_eof_n_i,
        RX_SRC_RDY_N    =>  rx_src_rdy_n_i,

        -- System Interface
        USER_CLK        =>  user_clk_i,
        RESET           =>  test_reset_i,
        ERROR_COUNT     =>  error_count_i

    );


    --Connect a frame generator to the user interface

    frame_gen_i : FRAME_GEN
    port map
    (
        -- User Interface
        TX_D            =>  tx_d_i,
        TX_REM          =>  tx_rem_i,
        TX_SOF_N        =>  tx_sof_n_i,
        TX_EOF_N        =>  tx_eof_n_i,
        TX_SRC_RDY_N    =>  tx_src_rdy_n_i,
        TX_DST_RDY_N    =>  tx_dst_rdy_n_i,

        -- System Interface
        USER_CLK        =>  user_clk_i,
        RESET           =>  test_reset_i
    );


    -- Module Instantiations --

    aurora_module_i : aurora_402_2gb_full
        generic map (
                LANE0_GT11_MODE_P => LANE0_GT11_MODE_P,  -- Based on MGT Location
                LANE0_MGT_ID_P    => LANE0_MGT_ID_P,
                LANE1_GT11_MODE_P => LANE1_GT11_MODE_P,  -- Based on MGT Location
                LANE1_MGT_ID_P    => LANE1_MGT_ID_P,
                EXTEND_WATCHDOGS  => EXTEND_WATCHDOGS,
                SIMULATION_P      => SIMULATION_P,       -- Set to 1 for simulation
                TX_FD_MIN_P       => TX_FD_MIN_P,        -- floor (128*Tpclk/Tdclk) - 3
                RX_FD_MIN_P       => RX_FD_MIN_P,        -- floor (128*Tpclk/Tdclk) - 3
                DCLK_PERIOD_NS_P  => DCLK_PERIOD_NS_P,   -- Default to 50 Mhz
                TXPOST_TAP_PD_P   => TXPOST_TAP_PD_P
                )

        port map (

        -- LocalLink TX Interface

                    TX_D             => tx_d_i,
                    TX_REM           => tx_rem_i,
                    TX_SRC_RDY_N     => tx_src_rdy_n_i,
                    TX_SOF_N         => tx_sof_n_i,
                    TX_EOF_N         => tx_eof_n_i,
                    TX_DST_RDY_N     => tx_dst_rdy_n_i,

        -- LocalLink RX Interface

                    RX_D             => rx_d_i,
                    RX_REM           => rx_rem_i,
                    RX_SRC_RDY_N     => rx_src_rdy_n_i,
                    RX_SOF_N         => rx_sof_n_i,
                    RX_EOF_N         => rx_eof_n_i,

        -- Native Flow Control Interface

                    NFC_REQ_N        => nfc_req_n_i,
                    NFC_NB           => nfc_nb_i,
                    NFC_ACK_N        => nfc_ack_n_i,

        -- MGT Serial I/O

                    RXP              => RXP(0 to 1),
                    RXN              => RXN(0 to 1),
                    TXP              => TXP_Buffer(0 to 1),
                    TXN              => TXN_Buffer(0 to 1),

        -- MGT Reference Clock Interface

                   REF_CLK1_LEFT    =>  ref_clk1_left_i,

        -- Error Detection Interface

                    HARD_ERROR       => hard_error_i,
                    SOFT_ERROR       => soft_error_i,
                    FRAME_ERROR      => frame_error_i,

        -- Status

                    CHANNEL_UP       => channel_up_i,
                    LANE_UP          => lane_up_i,

        -- Clock Compensation Control Interface

                    WARN_CC          => warn_cc_i,
                    DO_CC            => do_cc_i,

        -- Calibration Block Interface

                    CALBLOCK_ACTIVE  => open,
                                      
                    DISABLE_CALBLOCK => tied_to_ground_vec_i(1 downto 0),
                    RESET_CALBLOCKS  => reset_calblocks_r,
                    RX_SIGNAL_DETECT => rx_signal_detect_r,
                    DCLK             => init_clk_i,

        --Ports for simulation
                    MGT0_COMBUSIN    => mgt1_combusout_i,
                    MGT0_COMBUSOUT   => mgt0_combusout_i,
        --Ports for simulation
                    MGT1_COMBUSIN    => mgt0_combusout_i,
                    MGT1_COMBUSOUT   => mgt1_combusout_i,
        
    
        -- System Interface

                    DCM_NOT_LOCKED   => dcm_not_locked_i,
                    USER_CLK         => user_clk_i,
                    RESET            => reset_i,
                    POWER_DOWN       => power_down_i,
                    LOOPBACK         => loopback_i,
                    PMA_INIT         => pma_init_r,
                    TX_OUT_CLK       => tx_out_clk_i

                 );


    standard_cc_module_i : STANDARD_CC_MODULE

        port map (

        -- Clock Compensation Control Interface

                    WARN_CC        => warn_cc_i,
                    DO_CC          => do_cc_i,

        -- System Interface

                    DCM_NOT_LOCKED => dcm_not_locked_i,
                    USER_CLK       => user_clk_i,
                    CHANNEL_UP     => channel_up_i

                 );

end MAPPED;
