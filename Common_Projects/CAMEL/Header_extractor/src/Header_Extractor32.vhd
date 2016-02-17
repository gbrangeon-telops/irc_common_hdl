---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: header_extractor32.vhd
--  Use: Extracts Control Data from data stream (new 32 bit data path version)
--  By: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------
-- Wishbone RAM Memory Map
---------------------------------------------------------------------------------------------------
-- The ram is 16-bit wide and only the 8 LSBs of the address are
-- decoded.
--
-- data areas :
-- 0x00 to 0x2F : Data Processing Config (PROC_CONF)
-- 0x30 to 0x42 : ROIC Datacube Header (ROIC_HEADER)
-- 0x50 to 0x66 : ROIC Datacube Footer (ROIC_FOOTER) 
-- 0x70 to 0xD8 : ROIC NAV Footer
--
-- flags :
-- 0x2E : PROC_CONF_VALID         -- '0' initially until first config received '1' afterwards
-- 0x2F : PROC_CONF_CONFLICT      -- '1' if colision occured during WB read access
-- 0x3E : ROIC_HEADER_VALID
-- 0x3F : ROIC_HEADER_CONFLICT
-- 0x4E : ROIC_FOOTER_VALID
-- 0x4F : ROIC_FOOTER_CONFLICT
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--use ieee.math_real.log2; -- to calculate an address width constant
library Common_HDL;
use Common_HDL.Telops.all;
use work.CAMEL_Define.all;
use work.DPB_Define.all;

entity Header_Extractor32 is    
   port(
      CLK : in std_logic;
      ARESET : in std_logic;
      --------------------------------
      -- LocalLink input stream
      --------------------------------  
      RX_LL_MOSI  : in  t_ll_mosi32;
      RX_LL_MISO  : out t_ll_miso; 
      --------------------------------
      -- LocalLink output stream
      -------------------------------- 
      TX_LL_MOSI  : out t_ll_mosi32;
      TX_LL_MISO  : in  t_ll_miso;        
      --------------------------------
      -- Wishbone RAM Interface     
      --------------------------------                         
      WB_MOSI : in  t_wb_mosi;            -- This RAM contains PROC_CONF, ROIC_HEADER and ROIC_FOOTER. See below for memory map.
      WB_MISO : out t_wb_miso;            
      --------------------------------
      -- Configuration Parameters
      --------------------------------
      --NEW_CONFIG  : out std_logic;          -- Signal will go high when following headers /footers or configs are updated 
      --EOF_CTL_FRM     : out std_logic;          -- Signal will go high when following headers /footers or configs are updated
      CLINK_CONF      : out CLinkConfig;
      CUBE_HEADER     : out DPB_DCube_Header_v2_6;
      CUBE_HEADER_RDY : out std_logic;
      --------------------------------
      -- Output Data Interface
      --------------------------------
      --PAYLOAD_BEGIN : out std_logic;    -- no longer needed, data frames are pure payload once the header is striped by extractor
      --EOD           : out std_logic;    -- no longer needed, controller can monitor New frame and check for frame_type=0x03 (footer)
      --FRINGE_ERR    : out std_logic;    -- we no longer keep accounting of fringe number in RIO communications v2.5   
      --DCUBE_BEGIN   : out std_logic;    -- no longer needed, controller can monitor New frame and check for frame_types=0x04 & 0x81 (BSQ & BIP Dcubes)
      NEW_FRAME     : out std_logic; 
      FRAME_TYPE    : out std_logic_vector(7 downto 0);
      DP_PRESENT    : out Std_logic;                       
      PERMIT_FLOW   : in  std_logic;      -- By default, data flow stop after a datacube footer. To permit flow again, pulse PERMIT_FLOW.
      --------------------------------
      -- HX LOCATION (in CLINK or DATA_PROCESSING)
      ---------------------------------       
      HX_IN_CLINK   : in std_logic
      
      );
end Header_Extractor32;

architecture rtl of Header_Extractor32 is  
   
   -- declaring components explicitly eases synthesis file ordering mess!
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   component ram_dist_dp is
      generic (
         D_WIDTH : integer := 16;
         A_WIDTH : integer := 8);
      port (
         CLK : in std_logic;
         WEA : in std_logic;
         ADDRA : in std_logic_vector(A_WIDTH-1 downto 0);
         DIA : in std_logic_vector(D_WIDTH-1 downto 0);
         DOA : out std_logic_vector(D_WIDTH-1 downto 0);
         ADDRB : in std_logic_vector(A_WIDTH-1 downto 0);
         DOB : out std_logic_vector(D_WIDTH-1 downto 0));
   end component;
   
   constant CTRL_PIPE_DEPTH : integer := DPB_DCube_Header_array32_v2_6'length;  -- set to the longest control frame type we know of!
   type stream_array is array (natural range <>) of std_logic_vector(31 downto 0); -- for storing complete headers
   
   signal data_array : stream_array(1 to CTRL_PIPE_DEPTH);         -- DATA pipe
   signal control_sof : std_logic_vector(1 to CTRL_PIPE_DEPTH);    -- SOF control pipe
   signal control_eof : std_logic_vector(1 to CTRL_PIPE_DEPTH);    -- EOF control pipe
   signal cube_header_i : DPB_DCube_Header_v2_6;                        -- internal copy of CUBE_HEADER
   
   -- ram interfacing
   --constant AWIDTH : integer := integer(log2(real(DPConfig_array32'length + DPB_DCube_Header_array32'length)));
   constant AWIDTH : integer := integer(log2(40)) +1;
   signal ram_we : std_logic;
   signal ram_addr : std_logic_vector(AWIDTH-1 downto 0);
   signal ram_data : std_logic_vector(31 downto 0);
   signal rd_addr : std_logic_vector(AWIDTH-1 downto 0);
   signal rd_data : std_logic_vector(31 downto 0);
   signal ack_i : std_logic;
   signal rst_sync : std_logic; 
   
   -- frame type indexing
   constant i_conf    : natural := 0;
   constant i_hdr     : natural := 1;
   constant i_ftr     : natural := 2; 
   constant i_navhdr  : natural := 3;
   constant conf_ram_map : std_logic_vector(7 downto 0) := x"00";
   constant conf_hdr_map : std_logic_vector(7 downto 0) := x"18"; -- Corresponds to 0x30 WB address
   constant conf_ftr_map : std_logic_vector(7 downto 0) := x"28"; -- Corresponds to 0x50 WB address
   constant conf_nav_map : std_logic_vector(7 downto 0) := x"38"; -- Corresponds to 0x70 WB address
   
   -- Pixel decoder                                                                       
   --synopsys translate_off                                                    
   signal DECODED_PIXEL   :   t_output_debug32;  -- ajouté pour le decodage des pixels extraits 
   --synopsys translate_on       
   
   signal rx_busy          : std_logic;
   signal rx_dval          : std_logic; 
   signal stop_data_flow   : std_logic;
   signal new_frame_i      : std_logic;   
   signal permit_flow_latch : std_logic;   
   signal FRAME_TYPE_i     : std_logic_vector(7 downto 0);        
   signal currently_decoding_head_foot : std_logic; -- When this signal is '1', ignore TX_BUSY
   
   signal RXdataCount        : std_logic_vector(27 downto 0);
   signal TXdataCount        : std_logic_vector(27 downto 0);
   signal TXdataDval_i       : std_logic;  
   signal cube_header_rdy_i    : std_logic; -- pour savoir si le header est reçu au complet
   
   attribute KEEP : string;
   attribute KEEP of RXdataCount : signal is "true";
   attribute KEEP of TXdataCount : signal is "true";
   
begin
   
   datCnt: process (CLK)
   begin
      if rising_edge(CLK) then
         if rst_sync = '1' then
            RXdataCount <= (others => '0');
         elsif rx_dval = '1' then
            --            if RX_LL_MOSI.EOF = '1' and FRAME_TYPE_i = PROC_FOOTER_FRAME then
            --               dataCount <= (others => '0');
            --            else
            RXdataCount <= RXdataCount + 1;
            --            end if;
         end if;
         if rst_sync = '1' then
            TXdataCount <= (others => '0');
         elsif TX_LL_MISO.BUSY = '0' and TXdataDval_i = '1' then
            TXdataCount <= TXdataCount + 1;
            --            end if;
         end if;
      end if;
   end process;
   
   -- output external copy of cube_header
   CUBE_HEADER <= cube_header_i;
   CUBE_HEADER_RDY <= cube_header_rdy_i;
   NEW_FRAME <= new_frame_i;
   FRAME_TYPE <= FRAME_TYPE_i;
   
   -- Mappings
   RX_LL_MISO.AFULL <= TX_LL_MISO.AFULL and not currently_decoding_head_foot;  
   rx_busy <= ((TX_LL_MISO.BUSY or stop_data_flow) and not currently_decoding_head_foot);
   RX_LL_MISO.BUSY  <= rx_busy;
   rx_dval <= RX_LL_MOSI.DVAL and not rx_busy;
   
   TX_LL_MOSI.SUPPORT_BUSY <= RX_LL_MOSI.SUPPORT_BUSY;
   
   
   -- ram addressing      
   rd_addr <= WB_MOSI.ADR(rd_addr'length downto 1) when HX_IN_CLINK='0' else (others => '0');
   
   -- instantiate a dual port ram
   ram_instantiate : ram_dist_dp
   generic map(
      D_WIDTH => 32,
      A_WIDTH => AWIDTH)
   port map(
      CLK => CLK,
      WEA => ram_we,
      ADDRA => ram_addr,
      DIA => ram_data,
      DOA => open,
      ADDRB => rd_addr,
      DOB => rd_data);        
   
   wait_for_clink_ready : process(CLK)
   begin
      if rising_edge(CLK) then
         
         if PERMIT_FLOW = '1' then
            permit_flow_latch <= '1';
         end if;
         if rx_dval='1' and RX_LL_MOSI.EOF='1' and (FRAME_TYPE_i = PROC_FOOTER_FRAME or FRAME_TYPE_i = ROIC_FOOTER_FRAME) then
            stop_data_flow <= '1';
         end if;
         if HX_IN_CLINK = '1' then
            if stop_data_flow = '1' and permit_flow_latch = '1' then
               stop_data_flow <= '0';
               permit_flow_latch <= '0';
            end if;
         else
            if PERMIT_FLOW = '1' then 
               stop_data_flow <= '0';
            end if;
         end if;
         
         if rst_sync = '1' then
            stop_data_flow <= '1';
            permit_flow_latch <= '0';
         end if;          
         
      end if; -- if rising_edge(CLK)                    
   end process;                  
   
   -- shoot localink data into appropriate ram locations
   localink_to_ram : process(CLK)
      variable frame_type : std_logic_vector(7 downto 0); 
      variable frame_in_progress : boolean := false;
   begin
      if (CLK'event and CLK = '1') then
         -- map Localink Data to RAM input port. PDU: And do everything synchronously!
         ram_data <= RX_LL_MOSI.DATA;
         if (rst_sync = '1') then
            ram_we <= '0';         
            ram_addr <= (others => '0');
            frame_in_progress := false;     
            currently_decoding_head_foot <= '0';
         else
            if (rx_dval = '1') then  -- use BUSY and DVAL as clock enable
               if (RX_LL_MOSI.SOF = '1') then
                  frame_type := RX_LL_MOSI.DATA(31 downto 24);
                  case frame_type is
                     when PROC_CONFIG_FRAME =>
                        ram_we <= '1';
                        frame_in_progress := true;
                        ram_addr <= conf_ram_map(ram_addr'range);
                     currently_decoding_head_foot <= '1';
                     when ROIC_HEADER_FRAME =>
                        ram_we <= '1';
                        frame_in_progress := true;
                        ram_addr <= conf_hdr_map(ram_addr'range);
                     currently_decoding_head_foot <= '1';
                     when ROIC_FOOTER_FRAME =>
                        ram_we <= '1';         
                        frame_in_progress := true;
                        ram_addr <= conf_ftr_map(ram_addr'range);
                     currently_decoding_head_foot <= '1';     
                     when NAV_HEADER_FRAME =>
                        ram_we <= '1';
                        frame_in_progress := true;
                        ram_addr <= conf_nav_map(ram_addr'range);
                     currently_decoding_head_foot <= '1';
                     when others =>
                        ram_we <= '0';            
                        frame_in_progress := false;   
                     currently_decoding_head_foot <= '0';
                  end case;
               else
                  ram_addr <= ram_addr + 1;
                  if frame_in_progress then
                     ram_we <= '1';
                  end if;
               end if;
               if (RX_LL_MOSI.EOF = '1') then
                  frame_in_progress := false;   
                  currently_decoding_head_foot <= '0';
               end if;
            else
               ram_we <= '0'; -- PDU: No ram_we when DVAL is not perfect! (That means DVAL='1' and BUSY='0')  
            end if;
            
         end if;
      end if;
   end process localink_to_ram;
   
   
   -- Wishbone data reading / data lane multiplexing
   wb_read_access : process(CLK)
      variable addr16 : std_logic_vector(7 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            ack_i <= '0';
         else
            if (WB_MOSI.STB = '1' and WB_MOSI.WE = '0') then
               addr16 := WB_MOSI.ADR(addr16'range);
               case addr16 is
                  when others =>
                     -- data area (RAM)
                     if (addr16(0) = '1') then -- lane selection
                        WB_MISO.DAT <= rd_data(15 downto 0);
                     else
                        WB_MISO.DAT <= rd_data(31 downto 16);
                  end if;
               end case;
               -- ack generation has 1 pipeline delays to match output registering delays
               ack_i <= not ack_i; -- modulate ack to make sure it is deaserted every transfer
            else
               ack_i <= '0';
            end if;
         end if;
      end if;
   end process wb_read_access;
   
   WB_MISO.ACK <= ack_i and WB_MOSI.STB; -- make sure we deassert ack as soon as stb comes down
   
   -- implement an array based control pipeline for storing control header/footer data
   -- basically a shift register for buffering up to the maximum header length
   control_pipe_proc : process(CLK)
   begin
      if CLK'event and CLK = '1' then
         -- accumulate the stream in the shift register (data enters 1st element and exits last element)
         if (rx_dval = '1') then  -- use BUSY and DVAL as clock enable
            for i in CTRL_PIPE_DEPTH -1 downto 1 loop
               data_array(i+1) <= data_array(i);
               control_sof(i+1) <= control_sof(i);
               control_eof(i+1) <= control_eof(i);
            end loop;
            data_array(1)  <= RX_LL_MOSI.DATA;
            control_sof(1) <= RX_LL_MOSI.SOF;
            control_eof(1) <= RX_LL_MOSI.EOF;
            -- detect the frame type when it enters the pipe
            if RX_LL_MOSI.SOF = '1' then
               FRAME_TYPE_i <= RX_LL_MOSI.DATA(31 downto 24);
            end if;
            new_frame_i <= RX_LL_MOSI.SOF;
         else
            new_frame_i <= '0';
         end if;
      end if;
   end process control_pipe_proc;
   
   -----------------------------------------------------------------------
   -- extract config and control frames from the stream
   -- ROIC frame types: 0x00, 0x04, 0x05, 0x03, 0x60
   -- PROC frame types: 0x81, 0x82
   -----------------------------------------------------------------------
   control_extract : process(CLK)
      variable new_config_i : std_logic;
      variable new_config_dly : std_logic;
      variable frame_type_i : std_logic_vector(7 downto 0);
      variable roic_header_array : ROIC_DCube_Header_array32_v2_6;
      variable roic_footer_array : ROIC_DCube_Footer_array32_v2_6;
      variable proc_header_array : DPB_DCube_Header_array32_v2_6; 
      variable nav_header_array  : NAV_DCube_Header_v2_6;
      variable clink_conf_array : CLinkConfig_array32;
      variable sof_pixels : std_logic;
      variable dval_pixels : std_logic := '0';
      constant roic_header_pos : integer := ROIC_DCube_Header_array32_v2_6'length;
      constant roic_footer_pos : integer := ROIC_DCube_Footer_array32_v2_6'length;
      constant clink_conf_pos : integer := CLinkConfig_array32'length;
      constant proc_header_pos : integer := DPB_DCube_Header_array32_v2_6'length;
      constant proc_footer_pos : integer := 1; -- no payload for this frame type 
      constant nav_header_pos : integer := NAV_DCube_Header_v2_6'length;
      
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            TX_LL_MOSI.SOF <= '0';
            TX_LL_MOSI.EOF <= '0';
            TX_LL_MOSI.DVAL <= '0';
            TXdataDval_i <= '0';
            TX_LL_MOSI.DATA <= (others => '0');
            TX_LL_MOSI.DREM <= (others => '1'); 
            DP_PRESENT <='1';
            cube_header_rdy_i <= '0';
         else
            if (TX_LL_MISO.BUSY = '0') then  -- use BUSY as clock enable
               
               new_config_i := '0';
               sof_pixels := '0';

               ------------------------------------------------------------------
               -- detection of various types of frames)
               ------------------------------------------------------------------
               
               -- detect ROIC camera frames (x00)
               if control_sof(1) = '1' and data_array(1)(31 downto 24) = ROIC_CAMERA_FRAME then
                  new_config_i := '0';
                  sof_pixels := '1';
                  dval_pixels := '1';
                  frame_type_i := ROIC_CAMERA_FRAME;
               end if;
               
               -- detect beginning of ROIC Header frames (x05)
               if control_sof(1) = '1' and data_array(1)(31 downto 24) = ROIC_HEADER_FRAME then
                  cube_header_rdy_i <= '0';                  
               end if;                     
               
               -- detect beginning of PROC Header frames (0x82)
               if control_sof(1) = '1' and data_array(1)(31 downto 24) = PROC_HEADER_FRAME then
                  cube_header_rdy_i <= '0';                  
               end if;               
               
               -- detect beginning of ROIC Header frames (x05)
               if control_sof(1) = '1' and data_array(1)(31 downto 24) = ROIC_DCUBE_FRAME then
                  new_config_i := '0';
                  sof_pixels := '1';
                  dval_pixels := '1';
                  frame_type_i := ROIC_DCUBE_FRAME;
               end if;                
               
               -- detect the whole ROIC Header frames (x05)
               if control_sof(roic_header_pos) = '1' and data_array(roic_header_pos)(31 downto 24) = ROIC_HEADER_FRAME then
                  DP_PRESENT <='0';
                  new_config_i := '1';
                  sof_pixels := '0';
                  frame_type_i := ROIC_HEADER_FRAME; 
                  cube_header_rdy_i <= '1';
                  for i in ROIC_DCube_Header_array32_v2_6'range loop
                     roic_header_array(i):= data_array(roic_header_pos-i + 1);
                  end loop;
                  cube_header_i.ROICHeader <= to_ROIC_DCube_Header_v2_6(roic_header_array);
                  -- ROIC Headers set unused CUBE_HEADER fields to zero   
                  cube_header_i.DPBStatus          <= (others => '0');
                  cube_header_i.FirmwareVersion    <= (others => '0');
                  cube_header_i.FPGATemp           <= (others => '0');
                  cube_header_i.PCBTemp            <= (others => '0');
                  cube_header_i.PixelsReceivedCnt  <= (others => '0');
                  -- si NAV data non présent, envoyer des '0'
                  for i in cube_header_i.NAVHeader'range loop
                     cube_header_i.NAVHeader(i)<= (others =>'0');
                  end loop; 
               end if;
               
               -- detect ROIC footer frames (x03)
               if control_sof(roic_footer_pos) = '1' and data_array(roic_footer_pos)(31 downto 24) = ROIC_FOOTER_FRAME then
                  cube_header_rdy_i <= '0'; 
                  DP_PRESENT <='0';
                  new_config_i := '1';
                  sof_pixels := '0';
                  frame_type_i := ROIC_FOOTER_FRAME; 
                  --                  if HX_IN_CLINK = '1' then     -- si HX dans CLINK alors ne jamais tenir compte du footer
                  --                     for i in ROIC_DCube_Footer_array32_v2_6'range loop
                  --                        roic_footer_array(i):= (others =>'0');
                  --                     end loop;
                  --                  else                         -- si HX dans DP alors extraire le footer
                  for i in ROIC_DCube_Footer_array32_v2_6'range loop
                     roic_footer_array(i):= data_array(roic_footer_pos-i + 1);
                  end loop;
                  --                  end if;
                  cube_header_i.ROICFooter <= to_ROIC_DCube_Footer_v2_6(roic_footer_array);
                  -- ROIC Headers set unused CUBE_HEADER fields to zero   
                  cube_header_i.DPBStatus          <= (others => '0');
                  cube_header_i.FirmwareVersion    <= (others => '0');
                  cube_header_i.FPGATemp           <= (others => '0');
                  cube_header_i.PCBTemp            <= (others => '0');
                  cube_header_i.PixelsReceivedCnt  <= (others => '0'); 
               end if;
               
               -- detect a CLINK configuration frame (0x60)
               if control_sof(clink_conf_pos) = '1' and data_array(clink_conf_pos)(31 downto 24) = CLINK_CONFIG_FRAME then
                  new_config_i := '1';
                  sof_pixels := '0';
                  frame_type_i := CLINK_CONFIG_FRAME;
                  for i in CLinkConfig_array32'range loop
                     clink_conf_array(i) := data_array(clink_conf_pos-i + 1);
                  end loop;
                  CLINK_CONF <= to_CLinkConfig(clink_conf_array, true);
               else
                  CLINK_CONF.Valid <= false;
               end if;
               
               -- detect PROC BIP data cube frames (0x81)
               if control_sof(1) = '1' and data_array(1)(31 downto 24) = PROC_DCUBE_FRAME then
                  new_config_i := '0';
                  sof_pixels := '1';
                  dval_pixels := '1';
                  frame_type_i := PROC_DCUBE_FRAME;
               end if;
               
               -- detect the whole PROC Header frames (0x82)
               if control_sof(proc_header_pos) = '1' and data_array(proc_header_pos)(31 downto 24) = PROC_HEADER_FRAME then
                  new_config_i := '1';
                  sof_pixels := '0';
                  frame_type_i := PROC_HEADER_FRAME;
                  for i in DPB_DCube_Header_array32_v2_6'range loop
                     proc_header_array(i) := data_array(proc_header_pos-i + 1);
                  end loop;
                  cube_header_i <= to_DPB_DCube_Header_v2_6(proc_header_array);
                  cube_header_rdy_i <= '1';
               end if;
               
               -- detect PROC Footer frames (0x83)
               if control_sof(proc_footer_pos) = '1' and data_array(proc_footer_pos)(31 downto 24) = PROC_FOOTER_FRAME then
                  cube_header_rdy_i <= '0'; 
                  new_config_i := '1';
                  sof_pixels := '0';
                  frame_type_i := PROC_FOOTER_FRAME;
               end if; 
               
               -- detect NAV Header frames (x06)
               if control_sof(nav_header_pos) = '1' and data_array(nav_header_pos)(31 downto 24) = NAV_HEADER_FRAME then
                  new_config_i := '1';
                  sof_pixels := '0';
                  frame_type_i := NAV_HEADER_FRAME; 
                  for i in NAV_DCube_Header_v2_6'range loop
                     nav_header_array(i):= data_array(nav_header_pos-i + 1);
                  end loop;
                  cube_header_i.NAVHeader <= nav_header_array;
               end if;
               
               ------------------------------------------------------------------
               -- appropriate LocalLink pass through of pixel type frames
               -- when stripping control frames
               ------------------------------------------------------------------
               TX_LL_MOSI.DATA <= RX_LL_MOSI.DATA;
               TX_LL_MOSI.DREM <= RX_LL_MOSI.DREM;
               TX_LL_MOSI.SOF  <= sof_pixels; 
               TX_LL_MOSI.EOF  <= RX_LL_MOSI.EOF;
               TX_LL_MOSI.DVAL <= RX_LL_MOSI.DVAL and dval_pixels; 
               TXdataDval_i <= RX_LL_MOSI.DVAL and dval_pixels;
               --synopsys translate_off                              
               DECODED_PIXEL <= to_output_debug32(RX_LL_MOSI.DATA);   
               --synopsys translate_on                               
               
               -- disable dval_pixel at end of frame
               if RX_LL_MOSI.EOF = '1' and RX_LL_MOSI.DVAL = '1' then
                  dval_pixels := '0';
               end if;
               
            end if;
            
            -- pulse NEW_CONFIG for one clock as required
            --NEW_CONFIG <= new_config_i and not new_config_dly;
            --EOF_CTL_FRM <= new_config_i and not new_config_dly; -- pulse pour signaler l'entrée complete d'une trame de contrôle (pas une trame de données)
            new_config_dly := new_config_i;
         end if;
         
      end if; -- clk'event
   end process control_extract;
   
   -- synchronize reset locally
   synchronize_reset : sync_reset port map(ARESET => ARESET, SRESET => rst_sync, CLK => CLK);
   
end rtl;
