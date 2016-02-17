-------------------------------------------------------------------------------
--
-- Title       : Test Bench for pattern_gen_32
-- Design      : FIR_00142
-- Author      : Olivier Bourgois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\pattern_gen_32_TB.vhd
-- Generated   : 2007-04-18, 10:25
-- From        : $DSN\src\FIR_00142\pattern_gen_32.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Automatically generated Test Bench for pattern_gen_32_tb
--
-------------------------------------------------------------------------------

library ieee,common_hdl;
use work.camel_define.all;
use work.dpb_define.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use common_hdl.telops.all;

-- Add your library and packages declaration here ...

entity gen_extract_32_tb is
    generic(
        INTERNAL_FSM : boolean := true;
        ODD_EVENn : std_logic := '1');    -- instantiate odd path
end gen_extract_32_tb;

architecture TB_ARCHITECTURE of gen_extract_32_tb is
    -- Component declaration of the tested unit
    component pattern_gen_32
        generic(
            INTERNAL_FSM : boolean := false);
        port(
            CLK          : in std_logic;
            PG_CTRL      : in PatGenConfig;      -- configuration and control port of the pattern generator
            DONE         : out std_logic;        -- frame in progress monitoring
            ODD_EVENn    : in std_logic;         -- set to 1 for odd path, 0 for even.
            ROIC_HEADER  : in ROIC_DCube_Header;
            ROIC_FOOTER  : in ROIC_DCube_Footer;
            CLINK_CONF   : in CLinkConfig;
            PROC_HEADER  : in DPB_DCube_Header;  -- not supported yet
            PROC_CONF    : in DPConfig;          -- not supported yet
            TX_LL_MOSI   : out t_ll_mosi32;
            TX_LL_MISO   : in t_ll_miso);
    end component;
    
    component header_extractor32
        port(
            CLK : in std_logic;
            RX_LL_MOSI : in t_ll_mosi32;
            RX_LL_MISO : out t_ll_miso;
            TX_LL_MOSI : out t_ll_mosi32;
            TX_LL_MISO : in t_ll_miso;
            NEW_CONFIG : out std_logic;
            ROIC_HEADER : out ROIC_DCube_Header;
            ROIC_FOOTER : out ROIC_DCube_Footer;
            CLINK_CONF : out CLinkConfig;
            PROC_HEADER : out DPB_DCube_Header;
            PROC_CONF : out DPConfig;
            NEW_FRAME : out std_logic;
            FRAME_TYPE : out std_logic_vector(7 downto 0) );
    end component;
    
    -- pattern generator signals
    signal PG_CTRL : PatGenConfig;
    signal FRAME_TRIG_gen : std_logic;
    signal FRAME_TYPE_gen : std_logic_vector(7 downto 0);
    signal ROIC_HEADER_gen : ROIC_DCube_Header;
    signal ROIC_FOOTER_gen : ROIC_DCube_Footer;
    signal CLINK_CONF_gen : CLinkConfig;
    signal PROC_HEADER_gen : DPB_DCube_Header;
    signal PROC_CONF_gen : DPConfig;
    signal DONE_gen : std_logic;
    
    -- header extractor signals
    signal NEW_CONFIG_ext : std_logic;
    signal ROIC_HEADER_ext : ROIC_DCube_Header;
    signal ROIC_FOOTER_ext : ROIC_DCube_Footer;
    signal CLINK_CONF_ext : CLinkConfig;
    signal PROC_HEADER_ext : DPB_DCube_Header;
    signal PROC_CONF_ext : DPConfig;
    signal NEW_FRAME_ext : std_logic;
    signal FRAME_TYPE_ext: std_logic_vector(7 downto 0);
    
    -- common signals
    signal CLK : std_logic;
    signal LL_MISO_gen : t_ll_miso;
    signal LL_MOSI_gen : t_ll_mosi32;
    signal LL_MISO_ext : t_ll_miso;
    signal LL_MOSI_ext : t_ll_mosi32;
    
begin
    
    -- Unit Under Test #1 port map
    UUT1 : pattern_gen_32
    generic map (
        INTERNAL_FSM => INTERNAL_FSM)
    port map (
        CLK => CLK,
        PG_CTRL => PG_CTRL,
        DONE => DONE_gen,
        ODD_EVENn => ODD_EVENn,
        ROIC_HEADER => ROIC_HEADER_gen,
        ROIC_FOOTER => ROIC_FOOTER_gen,
        CLINK_CONF => CLINK_CONF_gen,
        PROC_HEADER => PROC_HEADER_gen,
        PROC_CONF => PROC_CONF_gen,
        TX_LL_MOSI => LL_MOSI_gen,
        TX_LL_MISO => LL_MISO_gen );
    
    -- Unit Under Test  #2 port map
    UUT2 : header_extractor32
    port map (
        CLK => CLK,
        RX_LL_MOSI => LL_MOSI_gen,
        RX_LL_MISO => LL_MISO_gen,
        TX_LL_MOSI => LL_MOSI_ext,
        TX_LL_MISO => LL_MISO_ext,
        NEW_CONFIG => NEW_CONFIG_ext,
        ROIC_HEADER => ROIC_HEADER_ext,
        ROIC_FOOTER => ROIC_FOOTER_ext,
        CLINK_CONF => CLINK_CONF_ext,
        PROC_HEADER => PROC_HEADER_ext,
        PROC_CONF => PROC_CONF_ext,
        NEW_FRAME => NEW_FRAME_ext,
        FRAME_TYPE => FRAME_TYPE_ext );
    
    -- generate a clock source
    clock : process
    begin
        CLK <= '0';
        loop
            wait for 5 ns;
            CLK <= not CLK;
        end loop;
    end process clock;
    
    -- Hold the output LocalLink bus in a flowing state
    LL_MISO_ext.BUSY <= '0';
    LL_MISO_ext.AFULL <= '0';
    
    -- CameraLink configuration
    CLINK_CONF_gen <= 
    (True,                                                     -- Valid
    to_unsigned(16,LVALLEN),	                               -- LValSize
    to_unsigned(16,FVALLEN),		                           -- FValSize 
    to_unsigned(312,HEADERLEN), 	                           -- HeaderSize
    to_unsigned(5,LPAUSELEN),		                           -- LValPause
    to_unsigned(2,FRAMESPERCUBELEN),                           -- FramesPerCube
    CLINK_BASE_MODE,                                           -- CLinkMode
    conv_std_logic_vector(3,4),                                -- HeaderVersion
    conv_std_logic_vector(7,3),                                -- Mode     -- CL_XTRA1 pix increment mode
    to_unsigned(3,DIAGSIZELEN));                               -- DiagSize
    
    -- PatGenConfig Settings Calculated from CLinkConfig
    -------------------------------------------------------------------------------
    PG_CTRL.Trig <= FRAME_TRIG_gen;
    PG_CTRL.FrameType <= FRAME_TYPE_gen;
    PG_CTRL.YSize <= CLINK_CONF_gen.FValSize(YLEN-1 downto 0);
    PG_CTRL.ZSize <= to_unsigned(1, ZLEN);
    PG_CTRL.PayloadSize <= to_unsigned(0,PLLEN);
    PG_CTRL.TagSize <= to_unsigned(0, TAGLEN);
    PG_CTRL.DiagSize <= to_unsigned(1, DIAGSIZELEN);
    
    calc_pg_size : process(CLINK_CONF_gen.CLinkMode, CLINK_CONF_gen.LValSize)
    begin
        if (CLINK_CONF_gen.CLinkMode = CLINK_BASE_MODE) then  -- latch config on start of frame
            PG_CTRL.XSize <= ("00" & CLINK_CONF_gen.LValSize(XLEN-1 downto 2)); -- in base mode we feed pipe 4x too fast   
        else
            PG_CTRL.XSize <= CLINK_CONF_gen.LValSize(XLEN-1 downto 0);
        end if;
    end process calc_pg_size;
    -------------------------------------------------------------------------------
    
    -- Default ROIC Header
    ROIC_HEADER_gen <=
    ( '0',                                                     -- Direction
    to_unsigned(1,ACQLEN),                                     -- Acq_Number
    x"0002",                                                   -- Code_Rev
    x"00000003",                                               -- Status
    to_unsigned(4,RXLEN),                                      -- Xmin 
    to_unsigned(5,RYLEN),                                      -- Ymin 
    to_unsigned(6,32));                                        -- TimeStamp 
    
    -- Default ROIC Footer
    ROIC_FOOTER_gen <=
    ( '0',                                                     -- Direction 
    to_unsigned(1,ACQLEN),                                     -- Acq_Number
    to_unsigned(2,FRINGELEN),                                  -- Write_No
    to_unsigned(3,FRINGELEN),                                  -- Trig_No  
    x"00000004",                                               -- Status
    to_unsigned(5,FRINGELEN),                                  -- ZPDPosition
    to_unsigned(6,16),                                         -- ZPDPeakVal -- aka MaxFPACount      
    to_unsigned(7,32));                                        -- TimeStamp
    
    -- PROC_HEADER_gen not supported yet
    -- PROC_CONF_gen not supported yet
    
    ---------------------------------------------------------------------------------------------------
    -- test UUT1 instantiated without an internal state machine to verify control frames
    -- are properly transmitted
    ---------------------------------------------------------------------------------------------------
    gen_fsm : if not INTERNAL_FSM generate
        begin
        
        PG_CTRL.DiagMode <= CLINK_CONF_gen.Mode;
        
        -- OK generate some patterns at one end and verify they are extracted out the other end
        stimulus : process(CLK)
            variable state : integer := 1;
        begin
            if CLK'event and CLK = '1' then
                -- what kind of frame to send
                case state is
                    when 1 =>
                        FRAME_TYPE_gen <= CLINK_CONFIG_FRAME;
                    when 2 =>
                        FRAME_TYPE_gen <= ROIC_CAMERA_FRAME;
                    when 3 =>
                        FRAME_TYPE_gen <= ROIC_HEADER_FRAME;
                    when 4 =>
                        FRAME_TYPE_gen <= ROIC_DCUBE_FRAME;
                    when 5 =>
                        FRAME_TYPE_gen <= ROIC_FOOTER_FRAME;
                    when others => null; 
                end case;
                -- manage the state counter and triggering
                if DONE_gen = '0' then
                    if FRAME_TRIG_gen = '1' then
                        FRAME_TRIG_gen <= '0';
                        state := state + 1;
                    end if;
                else
                    if state <= 5 then
                        FRAME_TRIG_gen <= '1';
                    end if;
                end if;
                
            end if;
        end process stimulus;
        
        -- Make sure that the data we put in one end comes back out of the other end uncorrupted
        assert_header_recovery : process(CLK)
            variable frame_type : std_logic_vector(7 downto 0);
        begin
            if CLK'event and CLK = '1' then
                if NEW_FRAME_ext = '1' then
                    frame_type := FRAME_TYPE_ext; -- detect the type of frame comming
                end if;
                if NEW_CONFIG_ext = '1' then
                    case frame_type is
                        when CLINK_CONFIG_FRAME =>
                            assert (CLINK_CONF_gen = CLINK_CONF_ext) report "CLINK_CONFIG does not match" severity ERROR;
                            assert (CLINK_CONF_gen /= CLINK_CONF_ext) report "CLINK_CONFIG matches" severity NOTE;
                        when ROIC_HEADER_FRAME =>
                            assert (ROIC_HEADER_gen = ROIC_HEADER_ext) report "ROIC_HEADER does not match" severity ERROR;
                            assert (ROIC_HEADER_gen /= ROIC_HEADER_ext) report "ROIC_HEADER matches" severity NOTE;
                        when ROIC_FOOTER_FRAME =>
                            assert (ROIC_FOOTER_gen = ROIC_FOOTER_ext) report "ROIC_FOOTER does not match" severity ERROR;
                            assert (ROIC_FOOTER_gen /= ROIC_FOOTER_ext) report "ROIC_FOOTER matches" severity NOTE;
                        when others => null;
                    end case;
                end if;
            end if;
        end process assert_header_recovery;
        
    end generate;
    
    ---------------------------------------------------------------------------------------------------
    -- test UUT1 instantiated with an internal state machine
    -- to verify the operation of the state machine to build diagnostic frames 
    ---------------------------------------------------------------------------------------------------
    gen_no_FSM : if INTERNAL_FSM generate
        begin
        
        stimulus : process(CLK)
            variable state : integer := 1;
        begin
            if CLK'event and CLK = '1' then
                -- what kind of frame to send
                case state is
                    when 1 =>
                        PG_CTRL.DiagMode <= PG_CAM_CNT;
                    when 2 =>
                        PG_CTRL.DiagMode <= PG_CAM_VIS;
                    when 3 =>
                        PG_CTRL.DiagMode <= PG_BSQ_XYZ;
                    when others => null; 
                end case;
                -- manage the state counter and triggering
                if DONE_gen = '0' then
                    if FRAME_TRIG_gen = '1' then
                        FRAME_TRIG_gen <= '0';
                        state := state + 1;
                    end if;
                else
                    if state <= 3 then
                        FRAME_TRIG_gen <= '1';
                    end if;
                end if;
                
            end if;
        end process stimulus;
        
        -- Detect the frame sequence recovered
        frame_detect : process(CLK)
            variable frame_type : std_logic_vector(7 downto 0);
        begin
            if CLK'event and CLK = '1' then
                if NEW_FRAME_ext = '1' then
                    frame_type := FRAME_TYPE_ext; -- detect the type of frame comming
                    assert (frame_type /= CLINK_CONFIG_FRAME) report "CLINK Config received" severity NOTE;
                    assert (frame_type /= PROC_CONFIG_FRAME) report "PROC Config received" severity NOTE;
                    assert (frame_type /= ROIC_CAMERA_FRAME) report "Camera Frame received" severity NOTE;
                    assert (frame_type /= ROIC_HEADER_FRAME) report "ROIC Header received" severity NOTE;
                    assert (frame_type /= ROIC_DCUBE_FRAME) report "ROIC DCube received" severity NOTE;
                    assert (frame_type /= ROIC_FOOTER_FRAME) report "ROIC Footer received" severity NOTE;
                    assert (frame_type /= PROC_HEADER_FRAME) report "PROC Header received" severity NOTE;
                    assert (frame_type /= PROC_DCUBE_FRAME) report "PROC DCube received" severity NOTE;
                end if;
            end if;
        end process frame_detect;
        
    end generate;
    
end TB_ARCHITECTURE;

