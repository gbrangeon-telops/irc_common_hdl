---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--
-- Title       : IRC_Define
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.CAMEL_Define.all;
use work.FPA_define.all;

package IRC_Define is
   ------------------------------------------
   -- Constants
   ------------------------------------------     
   -- Define number of bits used
   constant IMGLEN   : integer := log2(XSIZE_MAX*YSIZE_MAX)+1;
   constant XLEN     : integer := log2(XSIZE_MAX)+1; 
   constant YLEN     : integer := log2(YSIZE_MAX)+1; 
   --constant ZLEN     : integer := 24;
   --constant PLLEN    : integer := 24;
   --constant TAGLEN   : integer := 8;
   --constant DIAGSIZELEN      : integer := 16;
   --constant DIAGMODELEN      : integer := 4;
   
   constant ROICSTATLEN : natural := 64;
   constant PPCSTATLEN : natural := 32;	 
   
   ------------------------------------------
   -- RocketIo frames
   ------------------------------------------
   --constant ROIC_LEGACY_CAMERA_FRM: std_logic_vector(7 downto 0) := ROIC_CAMERA_FRAME;	-- frame camera de l'ancien code ROIC 
   constant ROIC_IRC_HEADER_FRM   : std_logic_vector(7 downto 0) := X"13";
   constant ROIC_IRC_CAMERA_FRM   : std_logic_vector(7 downto 0) := X"10";
   
   constant IRC_HEADER_LENGTH     : integer := 256;  -- Number of bytes in the header MAX
   
   ------------------------------------------
   -- Expansion Board Register Address Map
   ------------------------------------------
   constant EXP_ADC_CH1_ADD : std_logic_vector(7 downto 0) := x"00";
   constant EXP_ADC_CH2_ADD : std_logic_vector(7 downto 0) := x"02";
   constant EXP_ADC_CH3_ADD : std_logic_vector(7 downto 0) := x"04";
   constant EXP_ADC_CH4_ADD : std_logic_vector(7 downto 0) := x"06";
   constant EXP_TEMP1_ADD : std_logic_vector(7 downto 0) := x"08";
   constant EXP_TEMP2_ADD : std_logic_vector(7 downto 0) := x"0A";
   constant EXP_TEMP3_ADD : std_logic_vector(7 downto 0) := x"0C";
   constant EXP_TEMP4_ADD : std_logic_vector(7 downto 0) := x"0E";
   constant EXP_TEMP5_ADD : std_logic_vector(7 downto 0) := x"10";
   constant EXP_TEMP6_ADD : std_logic_vector(7 downto 0) := x"12";
   constant EXP_TEMP7_ADD : std_logic_vector(7 downto 0) := x"14";
   constant EXP_TEMP8_ADD : std_logic_vector(7 downto 0) := x"16";
   constant EXP_IRIG_B_1_ADD : std_logic_vector(7 downto 0) := x"18";
   constant EXP_IRIG_B_2_ADD : std_logic_vector(7 downto 0) := x"1A";
   constant EXP_IRIG_B_3_ADD : std_logic_vector(7 downto 0) := x"1C";
   constant EXP_IRIG_B_4_ADD : std_logic_vector(7 downto 0) := x"1E";
   constant EXP_IRIG_B_5_ADD : std_logic_vector(7 downto 0) := x"20";
   constant EXP_RTC_DATA_ADD : std_logic_vector(7 downto 0) := x"22";
   constant EXP_RTC_ADD_ADD : std_logic_vector(7 downto 0) := x"24";
   constant EXP_HEATER_DC_ADD : std_logic_vector(7 downto 0) := x"26";
   constant EXP_FAN_DC_ADD : std_logic_vector(7 downto 0) := x"28";
   constant EXP_KEYPAD_LED_ADD : std_logic_vector(7 downto 0) := x"2A";
   constant EXP_PPS_MUX_ADD : std_logic_vector(7 downto 0) := x"2C";
   constant EXP_STATUS_ADD : std_logic_vector(7 downto 0) := x"2E";
   constant EXP_CONTROL_ADD : std_logic_vector(7 downto 0) := x"30";
   constant EXP_SVN_VERSION_MSB_ADD : std_logic_vector(7 downto 0) := x"32";
   constant EXP_SVN_VERSION_LSB_ADD : std_logic_vector(7 downto 0) := x"34";
   constant INTERNAL_ERROR_ADD : std_logic_vector(7 downto 0) := x"36";
   constant EXP_RW_REG_ADD : std_logic_vector(7 downto 0) := x"38";
   constant EXP_LENS_MODE_ADD : std_logic_vector(7 downto 0) := x"3A";
   
   constant EXP_IRIG_REG1_ADD : std_logic_vector(7 downto 0) := x"3C";
   constant EXP_IRIG_REG2_ADD : std_logic_vector(7 downto 0) := x"3E";
   constant EXP_IRIG_REG3_ADD : std_logic_vector(7 downto 0) := x"40";
   constant EXP_IRIG_REG4_ADD : std_logic_vector(7 downto 0) := x"42";
   constant EXP_IRIG_REG5_ADD : std_logic_vector(7 downto 0) := x"44";
   constant EXP_IRIG_REG6_ADD : std_logic_vector(7 downto 0) := x"46";
   constant EXP_IRIG_REG7_ADD : std_logic_vector(7 downto 0) := x"48";
   
   
   type POSIX_time is record
      Seconds     : unsigned(31 downto 0); -- Number of seconds elapsed since midnight UTC of January 1, 1970.
      SubSeconds  : unsigned(23 downto 0); -- 100 ns resolution sub-second counter.
   end record;
   
   type IRC_Image_Header_v1_0 is record
      -- Fast Track
      --Header Identification = "TC"
      --CameraLinkHeaderMinorVersion : unsigned(7 downto 0);
      --CameraLinkHeaderMajorVersion : unsigned(7 downto 0);
      CameraLinkHeaderLength : unsigned(15 downto 0);
      ImageGating : unsigned(15 downto 0);
      HDRIIndex : unsigned(15 downto 0);
      SpectralFilterWheelPosition : unsigned(15 downto 0);
      CalibratedDataOffset : unsigned(31 downto 0);
      CalibratedDataLSBValue : unsigned(31 downto 0);
      -- Image Format Control
      Width : unsigned(15 downto 0);
      Height : unsigned(15 downto 0);
      OffsetX : unsigned(15 downto 0);
      OffsetY : unsigned(15 downto 0);
      ReverseX : unsigned(7 downto 0);
      ReverseY : unsigned(7 downto 0);
      TestImageSelector : unsigned(7 downto 0);
      -- Device Control
      DeviceModelName: unsigned(63 downto 0); -- 8 characters
      DeviveFirmwareVersion : unsigned(63 downto 0); -- 8 characters
      DeviceID : unsigned(63 downto 0); -- 8 characters
      DeviceTemperatureSensor : signed(15 downto 0);
      DeviceTemperatureInternalLens : signed(15 downto 0);
      DeviceTemperatureExternalLens : signed(15 downto 0);
      DeviceTemperatureInternalBlackBody : signed(15 downto 0);
      DeviceTemperatureExternalBlackBody : signed(15 downto 0);
      DeviceTemperatureROICFPGA : signed(15 downto 0);
      DeviceTemperatureROICPCB : signed(15 downto 0);
      DeviceTemperatureCameraLinkFPGA : signed(15 downto 0);
      DeviceTemperatureCameraLinkPCB : signed(15 downto 0);
      -- Telops Device Control
      InternalLensTubeTemperatureSetPoint : signed(15 downto 0);
      TimeSource : unsigned(7 downto 0);
      POSIXTime : unsigned(31 downto 0);
      SubSecondTime : unsigned(31 downto 0);
      GPSCoordinateLongitude : unsigned(31 downto 0); -- float
      GPSCoordinateLatitude : unsigned(31 downto 0); -- float
      GPSCoordinateAltitude : unsigned(31 downto 0); -- float
      -- Acquisition Control
      AcquisitionFrameRate : unsigned(31 downto 0); -- float
      ExposureTime : unsigned(31 downto 0); -- float
      TriggerModeAcquisitionStart : unsigned(7 downto 0);
      TriggerSourceAcquisitionStart : unsigned(7 downto 0);
      TriggerDelayAcquisitionStart : unsigned(31 downto 0);
      -- Telops Acquisition Control
      OperationalMode : unsigned(7 downto 0);
      AGCOption : unsigned(7 downto 0);
      IntegrationMode : unsigned(7 downto 0);
      HDRIExpTimeNumber : unsigned(7 downto 0);
      -- Telops Analog Control
      SensorWellDepth : unsigned(7 downto 0);
      NeutralFilterPosition : unsigned(7 downto 0);
      DeviceVersionNumberCalibrationDataSetNumber : unsigned(7 downto 0);
      InstalledExternalLens : unsigned(7 downto 0);
      CalibrationMode : unsigned(7 downto 0);
      InternalBlackBodyPosition : unsigned(7 downto 0);
      SpectralFilterWheelMode : unsigned(7 downto 0);
      SpectralFilterWheelSpeed : unsigned(31 downto 0);
      SpectralFilterWheelEncoderAtExposureStart : unsigned(15 downto 0);
      SpectralFilterWheelEncoderAtExposureEnd : unsigned(15 downto 0);
      AnalogInputValueChannel0 : unsigned(15 downto 0);
      AnalogInputValueChannel1 : unsigned(15 downto 0);
      AnalogInputValueChannel2 : unsigned(15 downto 0);
      AnalogInputValueChannel3 : unsigned(15 downto 0);
   end record;
   
   type IRCImageHeader_array32_v1_0 is array(1 to 65) of std_logic_vector(31 downto 0);   
   
   type exp_time_array_t is array (0 to 3) of std_logic_vector(31 downto 0);
   
   function to_IRCImageHeader_array32_v1_0 (a: IRC_Image_Header_v1_0) return IRCImageHeader_array32_v1_0;
   function to_IRCImageHeader_v1_0 (a: IRCImageHeader_array32_v1_0) return IRC_Image_Header_v1_0;     
   
end IRC_Define;

------------------------------------------
-- *** ADMET_DEFINE PACKAGE BODY***
------------------------------------------
package body IRC_Define is
   
   function to_IRCImageHeader_array32_v1_0 (a: IRC_Image_Header_v1_0) return IRCImageHeader_array32_v1_0 is
      variable y: IRCImageHeader_array32_v1_0;
      variable k: integer := 1;
      -- Header Version
      constant CameraLinkHeaderMajorVersion : std_logic_vector(7 downto 0) := x"01";
      constant CameraLinkHeaderMinorVersion : std_logic_vector(7 downto 0) := x"00";
   begin
      -- Attention Little Endian Format !!!!!!!!!!!!!!!!
      y(k) := std_logic_vector(ROIC_IRC_HEADER_FRM) & x"000000"; -- To tell header extractor the incoming frame
      k := k + 1;
      y(k) := x"43" & x"54" & CameraLinkHeaderMajorVersion & CameraLinkHeaderMinorVersion;
      k := k + 1;
      y(k) := std_logic_vector(a.CameraLinkHeaderLength) & std_logic_vector(a.ImageGating);
      k := k + 1;
      y(k) := std_logic_vector(a.HDRIIndex) & std_logic_vector(a.SpectralFilterWheelPosition);
      k := k + 1;
      y(k) := std_logic_vector(a.CalibratedDataOffset(15 downto 0)) & std_logic_vector(a.CalibratedDataOffset(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.CalibratedDataLSBValue(15 downto 0)) & std_logic_vector(a.CalibratedDataLSBValue(31 downto 16));
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.Width) & std_logic_vector(a.Height);
      k := k + 1;
      y(k) := std_logic_vector(a.OffsetX) & std_logic_vector(a.OffsetY);
      k := k + 1;
      y(k) := std_logic_vector(a.ReverseY) & std_logic_vector(a.ReverseX) & x"00" & std_logic_vector(a.TestImageSelector);
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceModelName(15 downto 0)) & std_logic_vector(a.DeviceModelName(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceModelName(47 downto 32)) & std_logic_vector(a.DeviceModelName(63 downto 48));
      k := k + 1;
      y(k) := std_logic_vector(a.DeviveFirmwareVersion(63 downto 32));
      k := k + 1;
      y(k) := std_logic_vector(a.DeviveFirmwareVersion(31 downto 0));
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceID(63 downto 32));
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceID(31 downto 0));
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceTemperatureSensor) & x"0000";
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceTemperatureInternalLens) & std_logic_vector(a.DeviceTemperatureExternalLens);
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceTemperatureInternalBlackBody) & std_logic_vector(a.DeviceTemperatureExternalBlackBody);
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceTemperatureROICFPGA) & std_logic_vector(a.DeviceTemperatureROICPCB); 
      k := k + 1;
      y(k) := std_logic_vector(a.DeviceTemperatureCameraLinkFPGA) & std_logic_vector(a.DeviceTemperatureCameraLinkPCB);
      k := k + 1;
      y(k) := std_logic_vector(a.InternalLensTubeTemperatureSetPoint) & x"0000";
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := x"00" & std_logic_vector(a.TimeSource) & x"0000";
      k := k + 1;
      y(k) := std_logic_vector(a.POSIXTime(15 downto 0)) & std_logic_vector(a.POSIXTime(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.SubSecondTime(15 downto 0)) & std_logic_vector(a.SubSecondTime(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.GPSCoordinateLongitude(15 downto 0)) & std_logic_vector(a.GPSCoordinateLongitude(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.GPSCoordinateLatitude(15 downto 0)) & std_logic_vector(a.GPSCoordinateLatitude(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.GPSCoordinateAltitude(15 downto 0)) & std_logic_vector(a.GPSCoordinateAltitude(31 downto 16));
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.AcquisitionFrameRate(15 downto 0)) & std_logic_vector(a.AcquisitionFrameRate(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.ExposureTime(15 downto 0)) & std_logic_vector(a.ExposureTime(31 downto 16));
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.TriggerSourceAcquisitionStart) & std_logic_vector(a.TriggerModeAcquisitionStart) & x"0000";
      k := k + 1;
      y(k) := std_logic_vector(a.TriggerDelayAcquisitionStart(15 downto 0)) & std_logic_vector(a.TriggerDelayAcquisitionStart(31 downto 16));
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.AGCOption) & std_logic_vector(a.OperationalMode) & std_logic_vector(a.HDRIExpTimeNumber) & std_logic_vector(a.IntegrationMode);
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.NeutralFilterPosition) & std_logic_vector(a.SensorWellDepth) & x"0000";
      k := k + 1;
      y(k) := std_logic_vector(a.InstalledExternalLens) & std_logic_vector(a.DeviceVersionNumberCalibrationDataSetNumber) & std_logic_vector(a.InternalBlackBodyPosition) & std_logic_vector(a.CalibrationMode);
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := x"00" & std_logic_vector(a.SpectralFilterWheelMode) & x"0000";
      k := k + 1;
      y(k) := std_logic_vector(a.SpectralFilterWheelSpeed(15 downto 0)) & std_logic_vector(a.SpectralFilterWheelSpeed(31 downto 16));
      k := k + 1;
      y(k) := std_logic_vector(a.SpectralFilterWheelEncoderAtExposureStart) & std_logic_vector(a.SpectralFilterWheelEncoderAtExposureEnd);
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := std_logic_vector(a.AnalogInputValueChannel0) & std_logic_vector(a.AnalogInputValueChannel1);
      k := k + 1;
      y(k) := std_logic_vector(a.AnalogInputValueChannel2) & std_logic_vector(a.AnalogInputValueChannel3);
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '0'); --reserved
      k := k + 1;
      y(k) := (others => '1'); --reserved to indicate the end of header.  Easier to see in file.
      
      return y;
   end to_IRCImageHeader_array32_v1_0;
   
   function to_IRCImageHeader_v1_0 (a: IRCImageHeader_array32_v1_0) return IRC_Image_Header_v1_0 is
      variable y: IRC_Image_Header_v1_0;
      variable k: integer := 3; 
   begin
      -- Fast Track
      y.CameraLinkHeaderLength := unsigned(a(k)(31 downto 16));
      y.ImageGating := unsigned(a(k)(15 downto 0));
      k := k + 1;
      y.HDRIIndex := unsigned(a(k)(31 downto 16));
      y.SpectralFilterWheelPosition := unsigned(a(k)(15 downto 0));
      k := k + 1;
      y.CalibratedDataOffset := unsigned(a(k));
      k := k + 1;
      y.CalibratedDataLSBValue := unsigned(a(k));
      k := k + 3;
      -- Image Format Control
      y.Width := unsigned(a(k)(31 downto 16));
      y.Height := unsigned(a(k)(15 downto 0));
      k := k + 1;
      y.OffsetX := unsigned(a(k)(31 downto 16));
      y.OffsetY := unsigned(a(k)(15 downto 0));
      k := k + 1;
      y.ReverseX := unsigned(a(k)(23 downto 16));
      y.ReverseY := unsigned(a(k)(31 downto 24));
      y.TestImageSelector := unsigned(a(k)(7 downto 0));
      k := k + 3;
      -- Device Control
      y.DeviceModelName:= unsigned(a(k)) & unsigned(a(k+1));
      k := k + 2;
      y.DeviveFirmwareVersion := unsigned(a(k)) & unsigned(a(k+1));
      k := k + 2;
      y.DeviceID := unsigned(a(k)) & unsigned(a(k+1));
      k := k + 4;
      y.DeviceTemperatureSensor := signed(a(k)(31 downto 16));
      k := k + 1;
      y.DeviceTemperatureInternalLens := signed(a(k)(31 downto 16));
      y.DeviceTemperatureExternalLens := signed(a(k)(15 downto 0));
      k := k + 1;
      y.DeviceTemperatureInternalBlackBody := signed(a(k)(31 downto 16));
      y.DeviceTemperatureExternalBlackBody := signed(a(k)(15 downto 0));
      k := k + 1;
      y.DeviceTemperatureROICFPGA := signed(a(k)(31 downto 16));
      y.DeviceTemperatureROICPCB := signed(a(k)(15 downto 0));
      k := k + 1;
      y.DeviceTemperatureCameraLinkFPGA := signed(a(k)(31 downto 16));
      y.DeviceTemperatureCameraLinkPCB := signed(a(k)(15 downto 0));
      k := k + 1;
      -- Telops Device Control
      y.InternalLensTubeTemperatureSetPoint := signed(a(k)(31 downto 16));
      k := k + 3;
      y.TimeSource := unsigned(a(k)(23 downto 16));
      k := k + 1;
      y.POSIXTime := unsigned(a(k));
      k := k + 1;
      y.SubSecondTime := unsigned(a(k));
      k := k + 1;
      y.GPSCoordinateLongitude := unsigned(a(k)); 
      k := k + 1;
      y.GPSCoordinateLatitude := unsigned(a(k)); 
      k := k + 1;
      y.GPSCoordinateAltitude := unsigned(a(k)); 
      k := k + 3;
      -- Acquisition Control
      y.AcquisitionFrameRate := unsigned(a(k)); 
      k := k + 1;
      y.ExposureTime := unsigned(a(k)); 
      k := k + 3;
      y.TriggerModeAcquisitionStart := unsigned(a(k)(23 downto 16));
      y.TriggerSourceAcquisitionStart := unsigned(a(k)(31 downto 24));
      k := k + 1;
      y.TriggerDelayAcquisitionStart := unsigned(a(k));
      k := k + 3;
      -- Telops Acquisition Control
      y.OperationalMode := unsigned(a(k)(23 downto 16));
      y.AGCOption := unsigned(a(k)(31 downto 24));
      y.IntegrationMode := unsigned(a(k)(7 downto 0));
      y.HDRIExpTimeNumber := unsigned(a(k)(15 downto 8));
      k := k + 3;
      -- Telops Analog Control
      y.SensorWellDepth := unsigned(a(k)(31 downto 24));
      y.NeutralFilterPosition := unsigned(a(k)(23 downto 16));
      k := k + 1;
      y.DeviceVersionNumberCalibrationDataSetNumber := unsigned(a(k)(23 downto 16));
      y.InstalledExternalLens := unsigned(a(k)(31 downto 24));
      y.CalibrationMode := unsigned(a(k)(7 downto 0));
      y.InternalBlackBodyPosition := unsigned(a(k)(15 downto 8));
      k := k + 3;
      y.SpectralFilterWheelMode := unsigned(a(k)(31 downto 24));
      k := k + 1;
      y.SpectralFilterWheelSpeed := unsigned(a(k));
      k := k + 1;
      y.SpectralFilterWheelEncoderAtExposureStart := unsigned(a(k)(31 downto 16));
      y.SpectralFilterWheelEncoderAtExposureEnd := unsigned(a(k)(15 downto 0));
      k := k + 3;
      y.AnalogInputValueChannel0 := unsigned(a(k)(31 downto 16));
      y.AnalogInputValueChannel1 := unsigned(a(k)(15 downto 0));
      k := k + 1;
      y.AnalogInputValueChannel2 := unsigned(a(k)(31 downto 16));
      y.AnalogInputValueChannel3 := unsigned(a(k)(15 downto 0));
      
      return y;
   end to_IRCImageHeader_v1_0;      
   
end package body IRC_Define;
