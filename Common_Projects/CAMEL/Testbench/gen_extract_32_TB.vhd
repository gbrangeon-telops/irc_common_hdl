---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: gen_extract_32_TB.vhd
--  Use: Test Bench for pattern_gen_32 and header_extractor32
--  By: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------

library ieee,common_hdl;
use work.camel_define.all;
use work.dpb_define.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use common_hdl.telops.all;
use common_hdl.telops_testing.all;

-- Add your library and packages declaration here ...

entity gen_extract_32_tb is
   generic(
      RANDOM : std_logic := '0'; -- random busy
      SUPPORT_CONFIG : boolean := true;
      STRIP_CONTROL_FRAMES : std_logic := '1';
      ODD_EVENn : std_logic := '1');    -- instantiate odd path
end gen_extract_32_tb;

architecture TB_ARCHITECTURE of gen_extract_32_tb is
   
   -- pattern generator signals
   signal PG_CTRL : PatGenConfig;
   signal FRAME_TRIG_gen : std_logic;
   signal FRAME_TYPE_gen : std_logic_vector(7 downto 0);
   signal ROIC_HEADER_gen : ROIC_DCube_Header;
   signal ROIC_FOOTER_gen : ROIC_DCube_Footer;
   signal CLINK_CONF_gen : CLinkConfig;
   signal PROC_HEADER_gen : DPB_DCube_Header;
   signal PROC_CONF_gen : DPConfig_array32;
   signal DONE_gen : std_logic;
   
   -- header extractor signals
   signal NEW_CONFIG_ext : std_logic;
   signal CLINK_CONF_ext : CLinkConfig;
   signal CUBE_HEADER_ext : DPB_DCube_Header;
   signal NEW_FRAME_ext : std_logic;
   signal FRAME_TYPE_ext: std_logic_vector(7 downto 0);
   signal WB_MOSI_ext : t_wb_mosi;
   signal WB_MISO_ext : t_wb_miso;
   
   -- common signals
   signal CLK : std_logic;
   signal ARESET : std_logic;
   signal LL_MISO_gen : t_ll_miso;
   signal LL_MOSI_gen : t_ll_mosi32;
   signal LL_MISO_ext : t_ll_miso;
   signal LL_MOSI_ext : t_ll_mosi32;
   signal LL_MISO_stub : t_ll_miso;
   
   constant VCC : std_logic := '1';
   
begin
   
   -- Unit Under Test #1 port map
   UUT1 : entity pattern_gen_32
   generic map (
      SUPPORT_CONFIG => SUPPORT_CONFIG)
   port map (
      CLK => CLK,
      PG_CTRL => PG_CTRL,
      DONE => DONE_gen,
      ODD_EVENn => ODD_EVENn,
      --ROIC_HEADER => ROIC_HEADER_gen,
      --ROIC_FOOTER => ROIC_FOOTER_gen,
      CLINK_CONF => CLINK_CONF_gen,
      PROC_HEADER => PROC_HEADER_gen,
      DP_CONF_ARRAY32 => PROC_CONF_gen,
      TX_LL_MOSI => LL_MOSI_gen,
      TX_LL_MISO => LL_MISO_gen );
   
   -- Unit Under Test  #2 port map
   UUT2 : entity header_extractor32
   port map (
      CLK => CLK,
      ARESET => ARESET,
      STRIP_CONTROL_FRAMES => STRIP_CONTROL_FRAMES,
      RX_LL_MOSI => LL_MOSI_gen,
      RX_LL_MISO => LL_MISO_gen,
      TX_LL_MOSI => LL_MOSI_ext,
      TX_LL_MISO => LL_MISO_ext,
      WB_MOSI => WB_MOSI_ext,
      WB_MISO => WB_MISO_ext,
      NEW_CONFIG => NEW_CONFIG_ext,
      CLINK_CONF => CLINK_CONF_ext,
      CUBE_HEADER => CUBE_HEADER_ext,
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
   
   -- hold reset low
   ARESET <= '0';
   
   -- Hold the output LocalLink bus in a flowing state
   LL_MISO_stub.BUSY <= '0';
   LL_MISO_stub.AFULL <= '0';
   
   -- instantiate a LL_RANDOM_BUSY for nastier testing
   inst_random_busy : entity LL_RandomBusy32
   port map (     
      RX_MOSI  => LL_MOSI_ext,
      RX_MISO  => LL_MISO_ext,
      TX_MOSI  => open,
      TX_MISO  => LL_MISO_stub,  
      RANDOM   => RANDOM,
      FALL     => VCC,
      ARESET   => ARESET,
      CLK      => CLK);

   -- CameraLink configuration
   CLINK_CONF_gen <= 
   (True,                                                     -- Valid
   to_unsigned(16,LVALLEN),	                                -- LValSize
   to_unsigned(16,FVALLEN),		                             -- FValSize 
   to_unsigned(320,HEADERLEN), 	                             -- HeaderSize
   to_unsigned(5,LPAUSELEN),		                             -- LValPause
   to_unsigned(1,FRAMESPERCUBE),		                          -- FramesPerCube
   "0001",                                                    -- CLinkMode (Full)
   conv_std_logic_vector(3,4));                               -- HeaderVersion

   -- PatGenConfig Settings Calculated from CLinkConfig
   -------------------------------------------------------------------------------
   PG_CTRL.Trig <= FRAME_TRIG_gen;
   PG_CTRL.FrameType <= FRAME_TYPE_gen;
   PG_CTRL.YSize <= CLINK_CONF_gen.FValSize(YLEN-1 downto 0);
   PG_CTRL.ZSize <= to_unsigned(5, ZLEN);
   PG_CTRL.PayloadSize <= to_unsigned(0,PLLEN);
   PG_CTRL.TagSize <= to_unsigned(8, TAGLEN);
   PG_CTRL.DiagSize <= to_unsigned(1, DIAGSIZELEN);
   
   calc_pg_size : process(CLINK_CONF_gen.CLinkMode, CLINK_CONF_gen.LValSize)
   begin
      if (CLINK_CONF_gen.CLinkMode(CL_FULL_BIT) = '1') then  -- latch config on start of frame
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
   
   -- Default PROC_HEADER
   PROC_HEADER_gen.DUI <= (others => '0');
   PROC_HEADER_gen.VP30Status.Stat <= x"01020304";
   PROC_HEADER_gen.VP30Status.ExtTemp <= x"05";
   PROC_HEADER_gen.VP30Status.IntTemp <= x"06";
   PROC_HEADER_gen.ROICHeader <= ROIC_HEADER_gen;
   PROC_HEADER_gen.ROICFooter <= ROIC_FOOTER_gen;
   
   -- Default PROC Config
   PROC_CONF_gen <= (
   x"61000013",
   x"00000001",
   x"00020003",
   x"00040005",
   x"00060007",
   x"00080009",
   x"000A000B",
   x"000C000D",
   x"000E000F",
   x"00100011",
   x"00120013",
   x"00140015",
   x"00160017",
   x"00180019",
   x"001A001B",
   x"001C001D",
   x"001E001F",
   x"00200021");
   
   -- OK generate some patterns at one end and verify they are extracted out the other end
   stimulus : process(CLK)
      variable state : integer := 1;
   begin
      if CLK'event and CLK = '1' then
         -- what kind of frame to send
         case state is
            when 1 =>
               PG_CTRL.DiagMode <= PG_FRAME; -- undefined diag mode FSM passes over control
               FRAME_TYPE_gen <= CLINK_CONFIG_FRAME;
            when 2 =>
               FRAME_TYPE_gen <= PROC_CONFIG_FRAME;
            when 3 =>
               PG_CTRL.DiagMode <= PG_CAM_CNT;        -- generate a camera frame
            when 4 =>
               PG_CTRL.DiagMode <= PG_BSQ_XYZ;        -- generate a ROIC BSQ DCUBE frame
            when 5 =>
               PG_CTRL.DiagMode <= PG_BIP_XYZ;        -- generate a PROC BIP DCUBE frame
            when others => null; 
         end case;
         -- manage the state counter and triggering
         if DONE_gen = '0' then
            if FRAME_TRIG_gen = '1' then
               FRAME_TRIG_gen <= '0';
               state := state + 1;
            end if;
         else
            if state <= 6 then
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
                  assert (ROIC_HEADER_gen = CUBE_HEADER_ext.ROICHeader) report "ROIC_HEADER does not match" severity ERROR;
                  assert (ROIC_HEADER_gen /= CUBE_HEADER_ext.ROICHeader) report "ROIC_HEADER matches" severity NOTE;
               when ROIC_FOOTER_FRAME =>
                  assert (ROIC_FOOTER_gen = CUBE_HEADER_ext.ROICFooter) report "ROIC_FOOTER does not match" severity ERROR;
                  assert (ROIC_FOOTER_gen /= CUBE_HEADER_ext.ROICFooter) report "ROIC_FOOTER matches" severity NOTE;
               when PROC_HEADER_FRAME =>
                  assert (PROC_HEADER_gen = CUBE_HEADER_ext) report "PROC_HEADER does not match" severity ERROR;
                  assert (PROC_HEADER_gen /= CUBE_HEADER_ext) report "PROC_HEADER matches" severity NOTE;
               when others => null;
            end case;
         end if;
      end if;
   end process assert_header_recovery;
   
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
            assert (frame_type /= ROIC_DCUBE_FRAME) report "BSQ DCube XY frame received" severity NOTE;
            assert (frame_type /= ROIC_FOOTER_FRAME) report "ROIC Footer received" severity NOTE;
            assert (frame_type /= PROC_HEADER_FRAME) report "PROC Header received" severity NOTE;
            assert (frame_type /= PROC_DCUBE_FRAME) report "BIP DCube Z frame received" severity NOTE;
         end if;
      end if;
   end process frame_detect;

   -- continuously access the wishbone ram (we should get some colisions and invalid settings
   wb_stimulus : process
      variable addr : std_logic_vector(11 downto 0);
      variable data : std_logic_vector(15 downto 0);
   begin
      -- initial bus levels
      WB_MOSI_ext.DAT <= (others => '0');
      WB_MOSI_ext.ADR <= (others => '0');
      WB_MOSI_ext.STB <= '0';
      WB_MOSI_ext.CYC <= '0';
      WB_MOSI_ext.WE  <= '0';
      wait until rising_edge(CLK);
      
      -- read back in order
      addr := x"000"; 
      loop
         rd_wb(CLK, addr, data, WB_MOSI_ext, WB_MISO_ext);
         if addr = x"04f" then
            addr := x"000";
         else
            addr := addr + 1;
         end if;
      end loop;
      
      wait; --eternally
      
   end process wb_stimulus;
   
   
end TB_ARCHITECTURE;

