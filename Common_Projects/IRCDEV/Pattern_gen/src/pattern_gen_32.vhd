---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: pattern_gen_32.vhd
--  Use: This block generate pseudo CAMEL Frames for a 32 bit datapath
--  By: Olivier Bourgois
--
--  Operation: when PG_Conf.Trig is pulsed high, the generator generates a LocalLink frame of
--  PG_CONF.FrameType according to the other PG_Conf fields if PG_CONF.DiagMode = 0
--  otherwise it generates one or several frames according to the PG_CONF.DiagMode
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library Common_HDL; 
use Common_HDL.Telops.all;
library work;
use work.CAMEL_define.all;
use work.IRC_define.all;
use work.CLINK_define.all;

entity pattern_gen_32 is
   generic(
      SUPPORT_CONFIG : boolean := true; -- set to true to be able to generate configuration frames (testbenches)
      BOARD : integer := 0);    --  0 : HyperCam, 1: Camera Link, 2: ROIC
   port(
      --------------------------------
      -- Control
      --------------------------------
      CLK               : in  std_logic;      
      ARESET            : in  std_logic;
      PG_CTRL           : in  PatGenConfig;      -- configuration and control port of the pattern generator
      DONE              : out std_logic;        -- frame in progress monitoring  
      --ROM_RESTART       : out std_logic;
      --------------------------------
      -- Configuration Parameters
      --------------------------------
      ODD_EVENn         : in  std_logic;         -- set to 1 for odd path, 0 for even.
      CLINK_CONF        : in  CLinkConfig;
      DP_CONF_ARRAY32   : in  DPConfig_array32;  -- ajouté pour supporter le Tesbench de DP_board. Son premier Q-Word  comporte les elemnts d'identification de la trame.  
      --------------------------------
      -- LocalLink output port
      --------------------------------       
      USE_EXTERNAL_INPUT: in  std_logic;
      RX_LL_MOSI        : in  t_ll_mosi32;
      RX_LL_MISO        : out t_ll_miso;    
      TX_LL_MOSI        : out t_ll_mosi32;
      TX_LL_MISO        : in  t_ll_miso);
end entity pattern_gen_32;

architecture rtl of pattern_gen_32 is
   
   constant MAX_LL_CONF_LEN : integer := DPConfig_array32'length;  -- set to the longest config frame type we know of!
   --   constant MAX_LL_CTRL_LEN : integer := DPB_DCube_Header_array32_v2_6'length;  -- set to the longest control frame type we know of!
   constant MAX_LL_CTRL_LEN : integer := IRCImageHeader_array32_v1_0'length;  -- set to the longest control frame type we know of!
   
   -- flag for knowing if we use dummy or external config values
   signal dummy_configs : std_logic;
   
   signal data_fip : std_logic := '0';        -- generated data frame in progress
   signal ctrl_fip : std_logic := '0';        -- control frame in progress
   signal conf_fip : std_logic := '0';        -- config frame in progress
   
   -- config frame generator outputs
   signal config_frame_dat : std_logic_vector(31 downto 0);
   signal config_frame_sof : std_logic;
   signal config_frame_eof : std_logic;
   
   -- data frame generator outputs
   signal data_frame_dat : std_logic_vector(31 downto 0);
   signal data_frame_drem : std_logic_vector(1 downto 0);     
   signal data_frame_dval : std_logic;
   signal data_frame_sof : std_logic;
   signal data_frame_eof : std_logic;
   
   -- control frame generator outputs
   signal ctrl_frame_dat : std_logic_vector(31 downto 0);
   signal ctrl_frame_sof : std_logic;
   signal ctrl_frame_eof : std_logic;
   
   -- counters
   signal TagCnt   : unsigned(PG_CTRL.TagSize'LENGTH-1 downto 0) := (others => '0');
   signal TagCnt_L : unsigned(PG_CTRL.TagSize'LENGTH-1 downto 0) := (others => '0');
   signal XCnt     : unsigned(PG_CTRL.XSize'LENGTH-1 downto 0) := (others => '0');
   signal XCnt_L   : unsigned(PG_CTRL.XSize'LENGTH-1 downto 0) := (others => '0');
   signal YCnt     : unsigned(PG_CTRL.YSize'LENGTH-1 downto 0) := (others => '0');
   signal ZCnt     : unsigned(PG_CTRL.ZSize'LENGTH-1 downto 0) := (others => '0');
   signal ZCnt_L   : unsigned(PG_CTRL.ZSize'LENGTH-1 downto 0) := (others => '0');
   
   -- Pixel decoder
   -- translate_off
   signal  DECODED_PIXEL   : t_output_debug32;  -- added for decoding generated pixels
   -- translate_on
   
   signal pg_ctrl_i : PatGenConfig;
   type Diag_State_t is (WaitExtTrig, OtherModule, TriggerFrame, DiagFrameInProgress, SingleFrame);  
   
   signal ROIC_HEADER      : ROIC_DCube_Header_v2_6;
   signal ROIC_FOOTER      : ROIC_DCube_Footer_v2_6;
   
   signal PROC_HEADER_i    : DPB_DCube_Header_v2_6;
   
   signal IRC_HEADER       : IRC_Image_Header_v1_0;
   
   signal Acq_Number       : unsigned(ACQLEN-1 downto 0);  
   
   signal use_ext_input    : std_logic;
   
begin  
   
   use_ext_input <= '1' when (USE_EXTERNAL_INPUT = '1' or PG_CTRL.DiagMode = PG_BSQ_COLD or PG_CTRL.DiagMode = PG_BSQ_HOT or PG_CTRL.DiagMode = PG_BSQ_SCENE) else '0';
   
   -- header Definition
   ROIC_HEADER.Status     <= x"0EADE678";
   ROIC_HEADER.Direction  <= '0';
   ROIC_HEADER.Acq_Number <= Acq_Number;
   ROIC_HEADER.Code_Rev   <= x"C0DE";
   
   ROIC_HEADER.Xmin       <= resize('1'&x"BB",RXLEN);
   -- aka FOVStartX
   ROIC_HEADER.Ymin       <= resize("01"&x"CC",RYLEN);
   -- aka FOVStartY
   --ROIC_HEADER.StartTimeStamp  <= x"ABCDEF23";  
   
   ROIC_HEADER.StartTimeStamp   <= x"12345678";
   ROIC_HEADER.FPGATemp         <= to_unsigned(60,8);
   ROIC_HEADER.PCBTemp          <= to_unsigned(60,8);
   ROIC_HEADER.FilterPosition   <= "00";
   ROIC_HEADER.ArmedStatus      <= '0';
   ROIC_HEADER.RealIntTime      <= to_unsigned(100,16);
   ROIC_HEADER.Spare            <= (others=>'0');
   -- Footer  Definition                                       
   ROIC_FOOTER.Status     <= x"F007E000";
   ROIC_FOOTER.Direction  <= '0';
   ROIC_FOOTER.Acq_Number <= Acq_Number;
   ROIC_FOOTER.Write_No   <= resize(pg_ctrl_i.ZSize,FRINGELEN);
   ROIC_FOOTER.Trig_No    <= resize(pg_ctrl_i.ZSize,FRINGELEN);   
   -- aka FOVStartX
   ROIC_FOOTER.ZPDPosition<= resize(x"01",FRINGELEN);
   -- aka FOVStartY
   ROIC_FOOTER.ZPDPeakVal <= (x"ABCD");
   ROIC_FOOTER.EndTimeStamp  <= (x"FBCD1234"); 
   ROIC_FOOTER.NbPixelsAboveHighLimit <= to_unsigned(100,32);
   ROIC_FOOTER.NbPixelsAboveLowLimit  <= to_unsigned(200,32); 
   ROIC_FOOTER.Nav_Data_Tag           <= (x"10102332");
   
   
   ---------------------------------------------------------------------------------------------------
   --Proc_header
   ---------------------------------------------------------------------------------------------------
   PROC_HEADER_i.DPBStatus          <=  (others =>'0'); 
   PROC_HEADER_i.FirmwareVersion    <=  x"B9F3";         
   PROC_HEADER_i.FPGATemp           <=   x"77"; 
   PROC_HEADER_i.PCBTemp            <=   x"88";
   PROC_HEADER_i.PixelsReceivedCnt  <=  (others =>'0');
   
   -- roic par¸t
   PROC_HEADER_i.ROICHeader   <= ROIC_HEADER;
   PROC_HEADER_i.ROICFooter   <= ROIC_FOOTER; 
   
   ---------------------------------------------------------------------------------------------------
   --IRC_header
   ---------------------------------------------------------------------------------------------------
   -- Fast Track
   --IRC_HEADER.CameraLinkHeaderMajorVersion <= x"01";
   --IRC_HEADER.CameraLinkHeaderMinorVersion <= x"00";
   IRC_HEADER.ImageGating <= x"2011";
   IRC_HEADER.HDRIIndex <= x"3022";
   IRC_HEADER.SpectralFilterWheelPosition <= x"4033";
   IRC_HEADER.CalibratedDataOffset <= x"50102030";
   IRC_HEADER.CalibratedDataLSBValue <= x"60000000";
   -- Image Format Control
   IRC_HEADER.Width <= resize(PG_CTRL.XSize,16);
   IRC_HEADER.Height <= resize(PG_CTRL.YSize,16);
   IRC_HEADER.OffsetX <= x"9000";
   IRC_HEADER.OffsetY <= x"A000";
   IRC_HEADER.TestImageSelector <= x"B0";
   -- Device Control
   IRC_HEADER.DeviceModelName <= x"CAFEFADEB0B0BABE";
   IRC_HEADER.DeviveFirmwareVersion <= x"F00DC0CA12345678";
   IRC_HEADER.DeviceID <= x"BABEFACE12345678";
   IRC_HEADER.DeviceTemperatureSensor <= x"1C00";
   IRC_HEADER.DeviceTemperatureInternalLens <= x"2C00";
   IRC_HEADER.DeviceTemperatureExternalLens <= x"3C00";
   IRC_HEADER.DeviceTemperatureInternalBlackBody <= x"4C00";
   IRC_HEADER.DeviceTemperatureExternalBlackBody <= x"5C00";
   IRC_HEADER.DeviceTemperatureROICFPGA <= x"6C00";
   IRC_HEADER.DeviceTemperatureROICPCB <= x"7C00";
   IRC_HEADER.DeviceTemperatureCameraLinkFPGA <= x"8C00"; 
   IRC_HEADER.DeviceTemperatureCameraLinkPCB <= x"9C00";
   -- Telops Device Control
   IRC_HEADER.InternalLensTubeTemperatureSetPoint <= x"0C00";
   IRC_HEADER.TimeSource <= x"10";
   IRC_HEADER.POSIXTime <= x"20A0B0C0";
   IRC_HEADER.SubSecondTime <= x"30A0B0C0";
   IRC_HEADER.GPSCoordinateLongitude <= x"40A0B0C0"; 
   IRC_HEADER.GPSCoordinateLatitude <= x"50A0B0C0"; 
   IRC_HEADER.GPSCoordinateAltitude <= x"60A0B0C0"; 
   -- Acquisition Control
   IRC_HEADER.AcquisitionFrameRate <= x"70A0B0C0"; 
   IRC_HEADER.ExposureTime <= x"80A0B0C0"; 
   IRC_HEADER.TriggerModeAcquisitionStart <= x"90";
   IRC_HEADER.TriggerSourceAcquisitionStart <= x"A0";
   IRC_HEADER.TriggerDelayAcquisitionStart <= x"B0000000";
   -- Telops Acquisition Control
   IRC_HEADER.OperationalMode <= x"C0";
   IRC_HEADER.AGCOption <= x"D0";
   IRC_HEADER.IntegrationMode <= x"E0";
   IRC_HEADER.HDRIExpTimeNumber <= x"E5";
   -- Telops Analog Control
   IRC_HEADER.SensorWellDepth <= x"F0";
   IRC_HEADER.NeutralFilterPosition <= x"10";
   IRC_HEADER.DeviceVersionNumberCalibrationDataSetNumber <= x"15";
   IRC_HEADER.InstalledExternalLens <= x"20";
   IRC_HEADER.CalibrationMode <= x"30";
   IRC_HEADER.InternalBlackBodyPosition <= x"40";
   IRC_HEADER.SpectralFilterWheelMode <= x"50";
   IRC_HEADER.SpectralFilterWheelSpeed <= x"60000000";
   IRC_HEADER.SpectralFilterWheelEncoderAtExposureStart <= x"7000";
   IRC_HEADER.SpectralFilterWheelEncoderAtExposureEnd <= x"8000";
   IRC_HEADER.AnalogInputValueChannel0 <= x"9000";
   IRC_HEADER.AnalogInputValueChannel1 <= x"A000";
   IRC_HEADER.AnalogInputValueChannel2 <= x"B000";
   IRC_HEADER.AnalogInputValueChannel3 <= x"C023";
   
   
   --------------------------------------------------------------------------------------------------- 
   -- Depending on requirements, the pattern generator can have an internal state machine to
   -- manage internal frame generation based on PG_CTRL.DiagMode. However if DiagMode is set to zero
   -- we can still generate individual frames for testbench purposes
   ---------------------------------------------------------------------------------------------------
   
   -- state machine description
   diag_fsm : process(CLK, ARESET)
      variable Diag_State : Diag_State_t;
      variable diag_cnt : unsigned(DIAGSIZELEN-1 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         case diag_state is 
            when WaitExtTrig =>          
               pg_ctrl_i.ImagePause <= PG_CTRL.ImagePause;
               pg_ctrl_i.XSize <= PG_CTRL.XSize;
               pg_ctrl_i.YSize <= PG_CTRL.YSize;
               pg_ctrl_i.ZSize <= PG_CTRL.ZSize;
               pg_ctrl_i.PayloadSize <= PG_CTRL.PayloadSize;
               pg_ctrl_i.DiagSize <= PG_CTRL.DiagSize;
               pg_ctrl_i.DiagMode <= PG_CTRL.DiagMode;
               if (PG_CTRL.Trig = '1' and PG_CTRL.DiagMode /= PG_STOP) then
                  diag_cnt := PG_CTRL.DiagSize;  -- reload diag_cnt
                  case PG_CTRL.DiagMode is
                     when PG_CAM_CNT | PG_CAM_VIS => -- ROIC Camera Diagnostic modes
                        DONE <= '0';
                        pg_ctrl_i.FrameType <= ROIC_CAMERA_FRAME;
                        pg_ctrl_i.TagSize <= (others => '0');
                        dummy_configs <= '1';
                     diag_state := TriggerFrame;
                     when PG_BSQ_XYZ | PG_BSQ_COLD | PG_BSQ_HOT | PG_BSQ_SCENE => -- ROIC BSQ DCube mode
                        DONE <= '0';
                        pg_ctrl_i.FrameType <= ROIC_HEADER_FRAME;
                        pg_ctrl_i.TagSize <= PG_CTRL.TagSize;
                        dummy_configs <= '1';
                     diag_state := TriggerFrame;
                     when PG_BIP_XYZ => -- PROC BIP DCube mode
                        DONE <= '0';
                        pg_ctrl_i.FrameType <= PROC_HEADER_FRAME;
                        pg_ctrl_i.TagSize <= PG_CTRL.TagSize;
                        dummy_configs <= '1';
                     diag_state := TriggerFrame;
                     when PG_IRC_BSQ_XYZ =>
                     DONE <= '0';
                     Acq_Number <= (others => '0');
                        if(BOARD = 1) then  -- IRC Camera Link
                           pg_ctrl_i.FrameType <= ROIC_IRC_HEADER_FRM;
                        elsif (BOARD = 2) then -- IRC ROIC  No header generated
                           pg_ctrl_i.FrameType <= ROIC_IRC_CAMERA_FRM;
                        else
                           pg_ctrl_i.FrameType <= ROIC_IRC_HEADER_FRM;
                        end if;
                        pg_ctrl_i.TagSize <= PG_CTRL.TagSize;
                        dummy_configs <= '1';
                     diag_state := TriggerFrame;
                     when others =>  -- pass control to another module
                        DONE <= '0';
                        pg_ctrl_i.FrameType <= PG_CTRL.FrameType;
                        pg_ctrl_i.TagSize <= PG_CTRL.TagSize;
                        pg_ctrl_i.Trig <= '1';
                        dummy_configs <= '0';
                     diag_state := OtherModule;
                  end case;
               else
                  DONE <= '1';
                  pg_ctrl_i.Trig <= '0';
               end if;
            
            when OtherModule =>
               pg_ctrl_i.trig <= '0';
               if (pg_ctrl_i.trig = '0' and conf_fip = '0' and ctrl_fip = '0' and data_fip ='0') then -- once trig is de-asserted wait for other module to finish up
                  DONE <= '1';
                  diag_state := WaitExtTrig;
               end if;
            
            when TriggerFrame =>
               case pg_ctrl_i.FrameType is
                  when ROIC_CAMERA_FRAME | ROIC_HEADER_FRAME | ROIC_DCUBE_FRAME | ROIC_FOOTER_FRAME | ROIC_IRC_HEADER_FRM | ROIC_IRC_CAMERA_FRM =>
                     if ctrl_fip = '1' or data_fip = '1' then
                        pg_ctrl_i.Trig <= '0';
                        diag_state := DiagFrameInProgress;
                        if pg_ctrl_i.FrameType = ROIC_DCUBE_FRAME or pg_ctrl_i.FrameType = ROIC_IRC_CAMERA_FRM then
                           Acq_Number <= Acq_Number + 1;
                        end if;
                     else
                        pg_ctrl_i.Trig <= '1';
                  end if;
                  when PROC_HEADER_FRAME | PROC_DCUBE_FRAME  | PROC_FOOTER_FRAME =>
                     if ctrl_fip = '1' or data_fip = '1' then
                        pg_ctrl_i.Trig <= '0';
                        diag_state := DiagFrameInProgress; 
                        if pg_ctrl_i.FrameType = PROC_DCUBE_FRAME then
                           Acq_Number <= Acq_Number + 1;
                        end if;
                     else
                        pg_ctrl_i.Trig <= '1';
                  end if;
                  when others =>
                     -- catch exceptions
                     pg_ctrl_i.Trig <= '0';
                  diag_state := WaitExtTrig;
               end case;
            
            when DiagFrameInProgress =>
               if (ctrl_fip = '0' and data_fip = '0') then -- detect frame finished
                  case pg_ctrl_i.FrameType is
                     when ROIC_CAMERA_FRAME  =>
                        if (PG_CTRL.DiagMode = PG_STOP or diag_cnt = 1) then
                           diag_state := WaitExtTrig;
                        elsif (diag_cnt < 1 ) then
                           diag_state := TriggerFrame;   -- size = 0 gives eternal diag until mode is PG_STOP
                        else -- diag_cnt > 1
                           diag_cnt := diag_cnt -1;
                           diag_state := TriggerFrame;
                        end if;
                     
                     when ROIC_FOOTER_FRAME =>
                        pg_ctrl_i.FrameType <= ROIC_HEADER_FRAME;
                        if (PG_CTRL.DiagMode = PG_STOP or diag_cnt = 1) then
                           diag_state := WaitExtTrig;
                        elsif (diag_cnt < 1 ) then
                           diag_state := TriggerFrame;   -- size = 0 gives eternal diag until mode is PG_STOP
                        else -- diag_cnt > 1
                           diag_cnt := diag_cnt -1;
                           diag_state := TriggerFrame;
                        end if;
                     
                     when ROIC_IRC_HEADER_FRM =>
                        pg_ctrl_i.FrameType <= ROIC_IRC_CAMERA_FRM;
                        diag_state := TriggerFrame;
                     
                     when ROIC_IRC_CAMERA_FRM =>
                        pg_ctrl_i.FrameType <= ROIC_IRC_HEADER_FRM;
                        if (PG_CTRL.DiagMode = PG_STOP or diag_cnt = 1) then
                           diag_state := WaitExtTrig;
                        elsif (diag_cnt < 1 ) then
                           diag_state := TriggerFrame;   -- size = 0 gives eternal diag until mode is PG_STOP
                        else -- diag_cnt > 1
                           diag_cnt := diag_cnt -1;
                           diag_state := TriggerFrame;
                        end if;
                     
                     when ROIC_HEADER_FRAME =>
                        pg_ctrl_i.FrameType <= ROIC_DCUBE_FRAME;
                        diag_state := TriggerFrame;
                     
                     when ROIC_DCUBE_FRAME =>
                        pg_ctrl_i.FrameType <= ROIC_FOOTER_FRAME;
                        diag_state := TriggerFrame;
                     
                     when PROC_HEADER_FRAME =>
                        pg_ctrl_i.FrameType <= PROC_DCUBE_FRAME;
                        diag_state := TriggerFrame;
                     
                     when PROC_DCUBE_FRAME =>
                        pg_ctrl_i.FrameType <= PROC_FOOTER_FRAME;
                        diag_state := TriggerFrame;   -- size = 0 gives eternal diag until mode changes on RS232
                     
                     when PROC_FOOTER_FRAME =>
                        pg_ctrl_i.FrameType <= PROC_HEADER_FRAME;
                        if (PG_CTRL.DiagMode = PG_STOP or diag_cnt = 1) then
                           diag_state := WaitExtTrig;
                        elsif (diag_cnt < 1 ) then
                           diag_state := TriggerFrame;   -- size = 0 gives eternal diag until mode is PG_STOP
                        else -- diag_cnt > 1
                           diag_cnt := diag_cnt -1;
                           diag_state := TriggerFrame;
                        end if;
                     
                     when others =>
                        diag_state := WaitExtTrig;
                     
                  end case;
               end if;
            
            when others => -- defaults for uncoded modes
               pg_ctrl_i.Trig <= '0';
               diag_state := WaitExtTrig;
            
         end case;
      end if;
      
      if ARESET = '1' then
         Acq_Number <= (others => '0');
         diag_state := WaitExtTrig;
      end if;
      
   end process diag_fsm;
   
   --------------------------------------------------------------------------------------------------- 
   -- This process generates config frames (for testbenches)
   -- (0x60, 0x61)
   -- it is implemented as a shift register which we load with the appropriate frame type and shoot it
   ---------------------------------------------------------------------------------------------------
   gen_conf_support : if SUPPORT_CONFIG generate
      begin
      
      conf_frame_proc : process(CLK)
         type stream_array is array (natural range <>) of std_logic_vector(31 downto 0); -- for storing complete control frames
         variable data_array : stream_array(1 to MAX_LL_CONF_LEN);        -- DATA pipe
         variable config_sof : std_logic;    -- SOF control pipe
         variable config_eof : std_logic_vector(1 to MAX_LL_CONF_LEN);    -- EOF control pipe
         variable clink_conf_array : CLinkConfig_array32;
      begin
         if CLK'event and CLK = '1' then
            
            if (TX_LL_MISO.BUSY = '0' and TX_LL_MISO.AFULL = '0') then -- use the BUSY and AFULL signal as an enable
               ------------------------------------
               -- detect start of a new config frame
               ------------------------------------
               if conf_fip = '0' and pg_ctrl_i.Trig = '1' then 
                  case pg_ctrl_i.FrameType is
                     when CLINK_CONFIG_FRAME => -- generate CLink Config frame (x61)
                        clink_conf_array := to_CLinkConfig_array32(CLINK_CONF);
                        for i in CLinkConfig_array32'range loop
                           if (dummy_configs = '1' and i > 1) then
                              data_array(i):= std_logic_vector(to_unsigned(i-1,32));
                           else
                              data_array(i):= clink_conf_array(i);
                           end if;
                           config_eof(i) := '0';
                        end loop;
                        config_sof := '1';
                        config_eof(clink_conf_array'length) := '1';
                     conf_fip <= '1';
                     when PROC_CONFIG_FRAME => -- generate PROC config frame (x60)
                        for i in DPConfig_array32'range loop
                           if (dummy_configs = '1' and i > 1) then
                              data_array(i):= std_logic_vector(to_unsigned(i-1,32));
                           else
                              data_array(i):= DP_CONF_ARRAY32(i);
                           end if;
                           config_eof(i) := '0';
                        end loop;
                        config_sof := '1';
                        config_eof(DPConfig_array32'length) := '1';
                     conf_fip <= '1';
                     when others => null; -- unrecognized configuration frame type
                  end case;
               else
                  ------------------------------------  
                  -- control frame in progress
                  ------------------------------------
                  for i in 1 to MAX_LL_CONF_LEN -1 loop
                     data_array(i) := data_array(i+1);
                     config_eof(i) := config_eof(i+1);
                  end loop;
                  data_array(MAX_LL_CONF_LEN) := (others => '0');
                  config_eof(MAX_LL_CONF_LEN) := '0';
                  config_sof := '0';
                  -- detect end of frame transmission
                  if config_frame_eof = '1' then
                     conf_fip <= '0';
                  end if;
               end if;
               config_frame_dat <= data_array(1);
               config_frame_sof <= config_sof;
               config_frame_eof <= config_eof(1);
            end if;
         end if;
      end process conf_frame_proc;
   end generate;
   
   --------------------------------------------------------------------------------------------------- 
   -- This process generates control frames such as headers and footers)
   -- (0x05, 0x03, 0x82, 0x83)
   -- it is implemented as a shift register which we load with the appropriate frame type and shoot it
   ---------------------------------------------------------------------------------------------------
   control_frame_proc : process(CLK)
      type stream_array is array (natural range <>) of std_logic_vector(31 downto 0); -- for storing complete control frames
      variable data_array : stream_array(1 to MAX_LL_CTRL_LEN);         -- DATA pipe
      variable control_sof : std_logic;    -- SOF control pipe
      variable control_eof : std_logic_vector(1 to MAX_LL_CTRL_LEN);    -- EOF control pipe
      variable roic_header_array : ROIC_DCube_Header_array32_v2_6;
      variable roic_footer_array : ROIC_DCube_Footer_array32_v2_6;
      variable proc_header_array : DPB_DCube_Header_array32_v2_6;
      variable irc_image_header : IRCImageHeader_array32_v1_0;
      variable width : integer range 0 to 2**XLEN; 
      variable x_counter : integer range 0 to 2**XLEN; 
      --variable PROC_HEADER_buf   : DPB_DCube_Header_v2_6;
   begin
      if CLK'event and CLK = '1' then
         
         width := to_integer(PG_CTRL.XSize);
         
         if (TX_LL_MISO.BUSY = '0' and TX_LL_MISO.AFULL = '0') then -- use the BUSY and AFULL signal as an enable
            ------------------------------------
            -- detect start of a new ctrl frame
            ------------------------------------
            if ctrl_fip = '0' and pg_ctrl_i.Trig = '1' then
               case pg_ctrl_i.FrameType is
                  when ROIC_HEADER_FRAME => -- generate ROIC Header frame (x05)
                     roic_header_array := to_ROIC_DCube_Header_array32_v2_6(ROIC_HEADER);
                     
                     for i in ROIC_DCube_Header_array32_v2_6'range loop
                        --                        if (dummy_configs = '1' and i > 1) then
                        --                           data_array(i):= std_logic_vector(to_unsigned(i-1,32));
                        --                        else
                        data_array(i):= roic_header_array(i);
                        --                        end if;
                        control_eof(i) := '0';
                     end loop;
                     control_sof := '1';
                     control_eof(roic_header_array'length) := '1';
                  ctrl_fip <= '1';
                  when ROIC_IRC_HEADER_FRM =>
                        irc_image_header := to_IRCImageHeader_array32_v1_0(IRC_HEADER);
                        
                        for i in IRCImageHeader_array32_v1_0'range loop
                           --                        if (dummy_configs = '1' and i > 1) then
                           --                           data_array(i):= std_logic_vector(to_unsigned(i-1,32));
                           --                        else
                           data_array(i):= irc_image_header(i);
                           --                        end if;
                           control_eof(i) := '0';
                        end loop;
                        control_sof := '1';
                        control_eof(irc_image_header'length) := '1';
                        x_counter := 0;
                  ctrl_fip <= '1';
                  when ROIC_FOOTER_FRAME => -- generate ROIC footer frame (x03)
                     roic_footer_array := to_ROIC_DCube_footer_array32_v2_6(ROIC_FOOTER);
                     
                     for i in ROIC_DCube_Footer_array32_v2_6'range loop
                        --                        if (dummy_configs = '1' and i > 1) then
                        --                           data_array(i):= std_logic_vector(to_unsigned(i-1,32));
                        --                        else
                        data_array(i):= roic_footer_array(i);
                        --                        end if;
                        control_eof(i) := '0';                                
                     end loop;
                     control_sof := '1';
                     control_eof(roic_footer_array'length) := '1';
                  ctrl_fip <= '1';
                  when PROC_HEADER_FRAME => -- generate PROC Header frame (x82)                     
                     proc_header_array := to_DPB_DCube_Header_array32_v2_6(PROC_HEADER_i);       
                     for i in DPB_DCube_Header_array32_v2_6'range loop
                        --if i > 1 then
                        data_array(i):= proc_header_array(i);  --std_logic_vector(to_unsigned(i-1,32));
                        --end if;
                        control_eof(i) := '0';
                     end loop;
                     control_sof := '1';
                     control_eof(proc_header_array'length) := '1';
                  ctrl_fip <= '1';
                  when PROC_FOOTER_FRAME => -- generate PROC footer frame (x83)
                     data_array(1) := PROC_FOOTER_FRAME & x"000000";
                     data_array(2) := (others => '0');
                     control_sof := '1';
                     control_eof(1) := '0';
                     control_eof(2) := '1';
                  ctrl_fip <= '1';
                  when others => null; -- unrecognized control frame type
               end case;
            else
               ------------------------------------  
               -- control frame in progress
               ------------------------------------
               if ctrl_fip = '1' and pg_ctrl_i.FrameType =  ROIC_IRC_HEADER_FRM then  -- Camera Link
                  for i in 1 to MAX_LL_CTRL_LEN -1 loop
                     data_array(i) := data_array(i+1);
                     --                     control_eof(i) := control_eof(i+1);
                  end loop;
                  
                  x_counter := x_counter + 1;
                  
                  
                  if x_counter <= MAX_LL_CTRL_LEN then
                     data_array(1) := data_array(1);
                  else
                     data_array(1) := x"00000000";
                  end if;
                  
                  if x_counter = width then
                     control_eof(1) := '1';
                  else
                     control_eof(1) := '0';
                  end if;   
                  
                  data_array(MAX_LL_CTRL_LEN) := (others => '0');
                  --                  control_eof(MAX_LL_CTRL_LEN) := '0';
                  control_sof := '0';
                  -- detect end of frame transmission
                  if ctrl_frame_eof = '1' then
                     ctrl_fip <= '0';
--                     x_counter := 0;
                  end if;
               else  -- HyperCAM
                  for i in 1 to MAX_LL_CTRL_LEN -1 loop
                     data_array(i) := data_array(i+1);
                     control_eof(i) := control_eof(i+1);
                  end loop;
                  data_array(MAX_LL_CTRL_LEN) := (others => '0');
                  control_eof(MAX_LL_CTRL_LEN) := '0';
                  control_sof := '0';
                  -- detect end of frame transmission
                  if ctrl_frame_eof = '1' then
                     ctrl_fip <= '0';
                  end if;
               end if;
               
            end if;
            ctrl_frame_dat <= data_array(1);
            ctrl_frame_sof <= control_sof;
            ctrl_frame_eof <= control_eof(1);
         end if;
      end if;
   end process control_frame_proc;
   
   ---------------------------------------------------------------------------------------------------
   -- This process takes care of data frame generation patterns 
   -- (0x00, 0x04, 0x81)
   ---------------------------------------------------------------------------------------------------
   data_frame_proc : process(CLK, ARESET)
      variable done_v : std_logic;
      variable snd_tag : std_logic;
      variable bip : std_logic;
      
      -- next counter values
      variable nxt_XCnt : unsigned(XCnt'range);
      variable nxt_XCnt_L : unsigned(XCnt_L'range);
      variable nxt_YCnt   : unsigned(YCnt'range);
      variable nxt_ZCnt : unsigned(ZCnt'range);
      variable nxt_ZCnt_L : unsigned(ZCnt_L'range);
      variable nxt_TagCnt : unsigned(TagCnt'range);
      variable nxt_TagCnt_L : unsigned(TagCnt_L'range);
      
      -- counter initialization constants
      variable init_XCnt : unsigned(XCnt'range);
      variable init_XCnt_L : unsigned(XCnt_L'range);
      variable init_YCnt   : unsigned(YCnt'range);
      variable init_ZCnt : unsigned(ZCnt'range);
      variable init_ZCnt_L : unsigned(ZCnt_L'range);
      variable init_TagCnt : unsigned(TagCnt'range);
      variable init_TagCnt_L : unsigned(TagCnt_L'range);   
      
      variable image_pause_cnt : unsigned(PG_CTRL.ImagePause'RANGE);  
      --constant ImagePause : unsigned(15 downto 0) := to_unsigned(100, 16);
      
   begin
      if CLK'event and CLK = '1' then
         if (TX_LL_MISO.BUSY = '0' and TX_LL_MISO.AFULL = '0') then -- use the BUSY and AFULL signal as an enable
            -- counter initialization values based on ODD_EVENn
            init_XCnt := (1 => not ODD_EVENn, 0 => ODD_EVENn, others => '0');                       -- start at 1 or 2
            init_XCnt_L := (2 => not ODD_EVENn, 1 => ODD_EVENn, 0 => ODD_EVENn, others => '0');     -- start at 3 or 4
            init_YCnt := (0 => '1', others => '0');                                                 -- start at 1
            init_ZCnt := (0 => '1', others => '0');                                                 -- start at 1
            init_ZCnt_L := (1 => '1', others => '0');                                               -- start at 2
            init_TagCnt := (1 => not ODD_EVENn, 0 => ODD_EVENn, others => '0');                     -- start at 1 or 2
            init_TagCnt_L := (2 => not ODD_EVENn, 1 => ODD_EVENn, 0 => ODD_EVENn, others => '0');   -- start at 3 or 4  
            
            data_frame_dval <= '1'; --default
            
            if (data_fip = '0' and pg_ctrl_i.Trig = '1') or (data_frame_eof = '1' and done_v = '0') then
               ------------------------------------
               -- detect start of a new data frame
               ------------------------------------
               if (data_fip = '0') then
                  TagCnt <= init_TagCnt;
                  TagCnt_L <= init_TagCnt_L;
                  if(pg_ctrl_i.DiagMode /= PG_IRC_BSQ_XYZ or Acq_number < 1) then
                     ZCnt <= init_ZCnt;
                     ZCnt_L <= init_ZCnt_L;
                  end if;
                  YCnt   <= init_YCnt;
                  XCnt <= init_XCnt;
                  XCnt_L <= init_XCnt_L; 
                  --ROM_RESTART <= '1';    
               else
                  --ROM_RESTART <= '0';
               end if;
               
               done_v := '0';
               data_frame_drem <= "11";
               data_frame_sof <= '1';
               data_frame_eof <= '0'; 
               image_pause_cnt := (others => '0'); 
               
               -- frame specific initializations
               case pg_ctrl_i.FrameType is     
                  when ROIC_CAMERA_FRAME =>    
                     data_frame_dat <= ROIC_CAMERA_FRAME & std_logic_vector(pg_ctrl_i.PayloadSize);
                     data_fip <= '1';
                     snd_tag := '0';
                  bip := '0';
                  when ROIC_IRC_CAMERA_FRM =>    
                     data_frame_dat <= ROIC_IRC_CAMERA_FRM & std_logic_vector(pg_ctrl_i.PayloadSize);
                     data_fip <= '1';
                     snd_tag := '0';
                  bip := '0';
                  when ROIC_DCUBE_FRAME =>    
                     data_frame_dat <= ROIC_DCUBE_FRAME & std_logic_vector(pg_ctrl_i.PayloadSize);
                     data_fip <= '1';
                     snd_tag := '1';
                  bip := '0';
                  when PROC_DCUBE_FRAME =>    
                     data_frame_dat <= PROC_DCUBE_FRAME & std_logic_vector(pg_ctrl_i.PayloadSize);
                     data_fip <= '1';
                     snd_tag := '1';
                  bip := '1';
                  when others => null;
               end case;
               
            else 
               ------------------------------------  
               -- data frame in progress
               ------------------------------------ 
               data_frame_sof <= '0';
               
               if (data_fip = '1') then
                  data_fip <= not done_v;
               end if;               
               
               
               if data_frame_eof = '1' then
                  image_pause_cnt := (others => '0'); 
                  data_frame_dval <= '0';
                  data_frame_eof <= '0';
               elsif image_pause_cnt < pg_ctrl_i.ImagePause then
                  image_pause_cnt := image_pause_cnt + 1;  
                  data_frame_dval <= '0';
               else
                  -- "BASIC" incrementers
                  if (bip = '1') then
                     nxt_ZCnt := ZCnt + 2;
                     nxt_XCnt := XCnt + 2;
                     nxt_YCnt := YCnt + 1;
                     nxt_TagCnt := TagCnt + 2;
                  else
                     if data_fip = '1' then
                        nxt_ZCnt := ZCnt + 1;
                        nxt_XCnt := XCnt + 4;
                        nxt_YCnt := YCnt + 1;
                        nxt_TagCnt := TagCnt + 4;
                     end if;
                  end if;
                  
                  -- "EXTENDED" incrementers for Low LocalLink Lane data for 2nd pixel data
                  nxt_ZCnt_L := ZCnt_L + 2;     -- second Z pixel in BIP mode
                  nxt_XCnt_L := XCnt_L + 4;     -- second X pixel in BSQ mode
                  nxt_TagCnt_L := TagCnt_L + 4;  -- second Tag pixel in BSQ mode
                  
                  if use_ext_input = '0' then
                     -- Data Counters
                     if bip = '1' then -- BIP incrementation
                        --!!!! PDU: Warning, the Y and X counters should not be incremented when Tagcnt is being incremented (to be fixed).
                        
                        -- X axis and Tag counter
                        if nxt_ZCnt > pg_ctrl_i.ZSize then
                           if TagCnt > pg_ctrl_i.TagSize then
                              if nxt_XCnt > pg_ctrl_i.XSize then
                                 XCnt <= init_XCnt;
                                 if nxt_YCnt > pg_ctrl_i.YSize then
                                    TagCnt <= init_TagCnt;
                                 end if;
                              else
                                 XCnt <= nxt_XCnt;
                              end if;
                           else
                              TagCnt <= nxt_TagCnt;
                           end if;
                        end if;
                        
                        -- Y axis counter
                        if nxt_ZCnt > pg_ctrl_i.ZSize then
                           if nxt_XCnt > pg_ctrl_i.XSize then
                              if nxt_YCnt > pg_ctrl_i.YSize then
                                 done_v := '1';
                                 YCnt <= init_YCnt;
                              else
                                 YCnt <= nxt_YCnt;
                              end if;
                           end if;
                        end if;
                        
                        -- Z axis counter
                        if nxt_ZCnt > pg_ctrl_i.ZSize then
                           data_frame_eof <= '1';
                           if pg_ctrl_i.ZSize(0) = '1' then
                              data_frame_drem <= "01";
                           else
                              data_frame_drem <= "11";
                           end if;
                           ZCnt <= init_ZCnt;
                           ZCnt_L <= init_ZCnt_L;
                        else
                           ZCnt <= nxt_ZCnt;
                           ZCnt_L <= nxt_ZCnt_L;
                        end if;
                        
                     else -- BSQ incrementation
                        
                        -- X axis and Tag counter
                        if TagCnt > pg_ctrl_i.TagSize then
                           if nxt_XCnt > pg_ctrl_i.XSize then
                              XCnt <= init_XCnt;
                              XCnt_L <= init_XCnt_L;
                              if nxt_YCnt > pg_ctrl_i.YSize then
                                 TagCnt <= init_TagCnt;
                                 TagCnt_L <= init_TagCnt_L;
                              end if;
                           else
                              XCnt_L <= nxt_XCnt_L;
                              XCnt <= nxt_XCnt;
                           end if;
                        else
                           TagCnt <= nxt_TagCnt;
                           TagCnt_L <= nxt_TagCnt_L;
                        end if;
                        
                        -- Y axis counter
                        if TagCnt > pg_ctrl_i.TagSize then
                           if nxt_XCnt > pg_ctrl_i.XSize then
                              if nxt_YCnt > pg_ctrl_i.YSize then
                                 data_frame_eof <= '1';
                                 data_frame_drem <= "11";
                                 YCnt <= init_YCnt;
                              else
                                 YCnt <= nxt_YCnt;
                              end if;
                           end if;  
                        end if;
                        
                        -- Z axis counter
                        if TagCnt > pg_ctrl_i.TagSize then
                           if nxt_XCnt > pg_ctrl_i.XSize then
                              if nxt_YCnt > pg_ctrl_i.YSize then
                                 if pg_ctrl_i.DiagMode = PG_IRC_BSQ_XYZ then
                                    done_v := '1';
                                 end if;
                                 if nxt_ZCnt > pg_ctrl_i.ZSize then
                                    if pg_ctrl_i.DiagMode /= PG_IRC_BSQ_XYZ then
                                       done_v := '1';
                                    end if;
                                    ZCnt <= init_ZCnt;
                                 else
                                    ZCnt <= nxt_ZCnt;
                                 end if;
                              end if;
                           end if;  
                        end if;
                     end if;
                     
                     -- output patterns
                     if (TagCnt > pg_ctrl_i.TagSize) then  -- Is the tag necessary or done?
                        -- data pattern update see DPB_Define for mode description    
                        case pg_ctrl_i.DiagMode is
                           when PG_CAM_CNT =>
                              -- Camera Frame simple pixel incrementation using only the x counter
                              data_frame_dat(31 downto 16) <= std_logic_vector(resize(XCnt,16));
                           data_frame_dat(15 downto 0)  <= std_logic_vector(resize(XCnt_L,16));
                           when PG_CAM_VIS =>
                              -- Camera Frame visible "gradient" pattern lightens up right and down using x and y counters (stable image)
                              data_frame_dat(31 downto 16) <= std_logic_vector(resize(YCnt,8)) & std_logic_vector(resize(XCnt,8));
                           data_frame_dat(15 downto 0)  <= std_logic_vector(resize(YCnt,8)) & std_logic_vector(resize(XCnt_L,8));
                           when PG_BSQ_XYZ | PG_BSQ_COLD | PG_BSQ_HOT | PG_BSQ_SCENE | PG_BIP_XYZ | PG_IRC_BSQ_XYZ =>
                              -- DCube Frame X,Y,Z encoding (note: encoding starts at ZYX = (1,1,1)
                              if (bip = '1') then
                                 data_frame_dat(31 downto 16) <= ODD_EVENn & std_logic_vector(resize(ZCnt,5)) & std_logic_vector(resize(YCnt,5)) & std_logic_vector(resize(XCnt,5));
                                 data_frame_dat(15 downto 0) <= ODD_EVENn & std_logic_vector(resize(ZCnt_L,5)) & std_logic_vector(resize(YCnt,5)) & std_logic_vector(resize(XCnt,5));
                              else
                                 data_frame_dat(31 downto 16) <= ODD_EVENn & std_logic_vector(resize(ZCnt,5)) & std_logic_vector(resize(YCnt,5)) & std_logic_vector(resize(XCnt,5));
                                 data_frame_dat(15 downto 0) <= ODD_EVENn & std_logic_vector(resize(ZCnt,5)) & std_logic_vector(resize(YCnt,5)) & std_logic_vector(resize(XCnt_L,5));
                           end if;
                           when others => null;
                        end case;
                     else
                        -- image tag data (image number & tag count)
                        if (bip = '1') then
                           data_frame_dat(31 downto 16) <= std_logic_vector(resize(ZCnt,8)) & std_logic_vector(resize(TagCnt,8));
                           data_frame_dat(15 downto 0) <= std_logic_vector(resize(ZCnt_L,8)) & std_logic_vector(resize(TagCnt,8));
                        else
                           data_frame_dat(31 downto 16) <= std_logic_vector(resize(ZCnt,8)) & std_logic_vector(resize(TagCnt,8));
                           data_frame_dat(15 downto 0) <= std_logic_vector(resize(ZCnt,8)) & std_logic_vector(resize(TagCnt_L,8));
                        end if; -- bip = '1'
                     end if;
                     
                  else -- use_ext_input = '1'
                     if RX_LL_MOSI.DVAL = '1' or TagCnt <= pg_ctrl_i.TagSize then
                        if bip = '1' then
                           -- X, Y, Z axis and Tag counter
                           if RX_LL_MOSI.EOF = '1' then
                              if TagCnt > pg_ctrl_i.TagSize then
                                 if nxt_XCnt > pg_ctrl_i.XSize then
                                    XCnt <= init_XCnt;
                                    if nxt_YCnt > pg_ctrl_i.YSize then
                                       TagCnt <= init_TagCnt;
                                       done_v := '1';
                                       YCnt <= init_YCnt;
                                    else
                                       YCnt <= nxt_YCnt;
                                    end if;
                                 else
                                    XCnt <= nxt_XCnt;
                                 end if;
                              else
                                 TagCnt <= nxt_TagCnt;
                              end if;
                              ZCnt <= init_ZCnt;
                              ZCnt_L <= init_ZCnt_L;
                           else
                              ZCnt <= nxt_ZCnt;
                              ZCnt_L <= nxt_ZCnt_L;
                           end if;
                        else
                           -- X, Y, Z axis and Tag counters
                           if TagCnt > pg_ctrl_i.TagSize then
                              if RX_LL_MOSI.EOF = '1' then
                                 if nxt_ZCnt > pg_ctrl_i.ZSize then
                                    done_v := '1';
                                    ZCnt <= init_ZCnt;
                                 else
                                    ZCnt <= nxt_ZCnt;
                                 end if;
                                 
                                 YCnt <= init_YCnt;
                                 TagCnt <= init_TagCnt;
                                 TagCnt_L <= init_TagCnt_L;
                              else
                                 YCnt <= nxt_YCnt;
                              end if;  
                           else
                              TagCnt <= nxt_TagCnt;
                              TagCnt_L <= nxt_TagCnt_L;
                           end if;
                        end if;
                        
                        -- output patterns
                        if (TagCnt > pg_ctrl_i.TagSize) then  -- Is the tag necessary or done?
                           data_frame_dat    <= RX_LL_MOSI.DATA;
                           data_frame_dval   <= RX_LL_MOSI.DVAL;
                           data_frame_drem   <= RX_LL_MOSI.DREM;
                           data_frame_eof    <= RX_LL_MOSI.EOF;
                        else
                           data_frame_dval   <= '1';
                           data_frame_drem   <= "11";
                           data_frame_eof    <= '0';
                           -- image tag data (image number & tag count)
                           if (bip = '1') then
                              data_frame_dat(31 downto 16) <= std_logic_vector(resize(ZCnt,8)) & std_logic_vector(resize(TagCnt,8));
                              data_frame_dat(15 downto 0) <= std_logic_vector(resize(ZCnt_L,8)) & std_logic_vector(resize(TagCnt,8));
                           else
                              data_frame_dat(31 downto 16) <= std_logic_vector(resize(ZCnt,8)) & std_logic_vector(resize(TagCnt,8));
                              data_frame_dat(15 downto 0) <= std_logic_vector(resize(ZCnt,8)) & std_logic_vector(resize(TagCnt_L,8));
                           end if; -- bip = '1'
                        end if;
                        
                     else
                        data_frame_dval   <= '0';
                        
                     end if; -- if RX_LL_MOSI.DVAL = '1'
                     
                  end if; -- if use_ext_input = '0'
                  
               end if;-- use_ext_input = '0'
               
            end if; -- (data_fip = '0' and pg_ctrl_i.Trig = '1') or (data_frame_eof = '1' and done_v = '0')
            
         end if; -- (TX_LL_MISO.BUSY = '0' and TX_LL_MISO.AFULL = '0')
      end if; -- clk'event               
      
      if ARESET = '1' then
         data_frame_dval <= '0';            
         image_pause_cnt := (others => '0');   
         --ROM_RESTART <= '0';
      end if;
      
      -- Anychronous process?? Why??
      if (TX_LL_MISO.BUSY = '0' and TX_LL_MISO.AFULL = '0' and
         data_fip = '1' and
         data_frame_eof = '0' and
         image_pause_cnt = pg_ctrl_i.ImagePause and
         TagCnt > pg_ctrl_i.TagSize and
         use_ext_input = '1') then
         RX_LL_MISO.BUSY <= '0';
      else
         RX_LL_MISO.BUSY <= '1';
      end if;
      RX_LL_MISO.AFULL <= '0';
      
   end process data_frame_proc;
   
   ---------------------------------------------------------------------------------------------------
   -- This process acts as a mux for the various pattern generator modules (ie data and config)
   -- we can easily add new pattern generator modules and plug them into this mux!
   ---------------------------------------------------------------------------------------------------
   output_map_registers : process(CLK, ARESET)
      variable fip_vector : std_logic_vector(2 downto 0);
   begin
      if CLK'event and CLK = '1' then
         if (TX_LL_MISO.BUSY = '0') then
            if (TX_LL_MISO.AFULL = '0') then
               fip_vector := conf_fip & ctrl_fip & data_fip;
               case fip_vector is
                  when "001" =>
                     TX_LL_MOSI.DATA <= data_frame_dat;
                     -- translate_off
                     DECODED_PIXEL <= to_output_debug32(data_frame_dat);  
                     -- translate_on    
                     TX_LL_MOSI.DVAL <= data_frame_dval;
                     TX_LL_MOSI.DREM <= data_frame_drem;
                     TX_LL_MOSI.SOF <= data_frame_sof;
                  TX_LL_MOSI.EOF <= data_frame_eof;
                  when "010" =>
                     TX_LL_MOSI.DATA <= ctrl_frame_dat;
                     TX_LL_MOSI.DVAL <= '1';
                     TX_LL_MOSI.DREM <= "11";
                     TX_LL_MOSI.SOF <= ctrl_frame_sof;
                  TX_LL_MOSI.EOF <= ctrl_frame_eof;
                  when "100" =>
                     TX_LL_MOSI.DATA <= config_frame_dat;
                     TX_LL_MOSI.DVAL <= '1';
                     TX_LL_MOSI.DREM <= "11";
                     TX_LL_MOSI.SOF <= config_frame_sof;
                  TX_LL_MOSI.EOF <= config_frame_eof;
                  when others => 
                     TX_LL_MOSI.DATA <= (others => '0');
                     TX_LL_MOSI.DVAL <= '0';
                     TX_LL_MOSI.DREM <= "11";
                     TX_LL_MOSI.SOF <= '0';
                  TX_LL_MOSI.EOF <= '0';
               end case;
            else
               TX_LL_MOSI.DVAL <= '0';
            end if;
         end if; -- if TX_LL_MISO.BUSY = '0' 
      end if;
      
      if ARESET = '1' then
         TX_LL_MOSI.DVAL <= '0';
      end if;
      
   end process output_map_registers;
   
   -- translate_off
   -- We support busy!
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   -- translate_on
   
end rtl;
