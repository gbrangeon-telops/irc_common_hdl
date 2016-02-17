---------------------------------------------------------------------------------------------------
--                                                      ..`??!````??!..
--                                                  .?!                `1.
--                                               .?`                      i
--                                             .!      ..vY=!``?74.        i
--.........          .......          ...     ?      .Y=` .+wA..   ?,      .....              ...
--"""HMM"""^         MM#"""5         .MM|    :     .H\ .JQgNa,.4o.  j      MM#"MMN,        .MM#"WMF
--   JM#             MMNggg2         .MM|   `      P.;,jMt   `N.r1. ``     MMmJgMM'        .MMMNa,.
--   JM#             MM%````         .MM|   :     .| 1A Wm...JMy!.|.t     .MMF!!`           . `7HMN
--   JMM             MMMMMMM         .MMMMMMM!     W. `U,.?4kZ=  .y^     .!MMt              YMMMMB=
--                                          `.      7&.  ?1+...JY'     .J
--                                           ?.        ?""""7`       .?`
--                                             :.                ..?`
--                                               `!...........??`
---------------------------------------------------------------------------------------------------
--
-- Title       : Header_Extractor
-- Design      : VP30
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
--
-- Description : This module simply extracts the ROIC_Img_Header from the dataflow and outputs it
--               on the signal ROIC_HEADER. When the data is not a header, the data simply flows
--               through.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;
use work.CAMEL_Define.all;
use work.DPB_Define.ALL;

entity Header_Extractor is
   generic(
      SupportProc : boolean := true); -- Support data processing (vp30-40) header
   port(
      --------------------------------
      -- ROIC Rocket IO Link
      --------------------------------  
      RX_LL_MOSI  : in  t_ll_mosi;
      RX_LL_MISO  : out t_ll_miso;          
      --------------------------------
      -- Configuration Parameters
      --------------------------------
      ROIC_HEADER    : out ROIC_DCube_Header;
      ROIC_FOOTER    : out ROIC_DCube_Footer;
      --DCUBE_FOOTER   : out ROIC_DCube_Footer;
      PROC_HEADER    : out DPB_DCube_Header;
      NEW_CONFIG     : out std_logic;     -- Signal will go high one clock after the last word of the header is received. 
      VP30_PRESENT   : in  std_logic;     -- Necessary because header is not the same in Camera Mode
      -- In other words, it will be high for the first word of the payload.
      --------------------------------
      -- Output Data Interface
      --------------------------------
      TX_LL_MOSI        : out t_ll_mosi;
      TX_LL_MISO        : in  t_ll_miso;  
      EOD               : out std_logic;  -- End Of Datacube, asserted when a ROIC_DCube_Footer is received.
      FRINGE_ERR        : out std_logic;    
      PAYLOAD_BEGIN     : out std_logic; 
      FRAME_TYPE        : out std_logic_vector(7 downto 0);
      DCUBE_BEGIN       : out std_logic;     -- Signal will go high one clock after the last word of the header is received IF this is the first image of a datacube. 
      --IMAGE_BEGIN     : out std_logic;     -- A frame can either be an image or a full datacube, depending on the context.          
      UNKNOWN_FRAME_ERR : out std_logic;
      --------------------------------
      -- Others IOs
      --------------------------------
      CLK            : in STD_LOGIC;
      ARESET         : in STD_LOGIC
      --------------------------------
      );
end Header_Extractor;

architecture RTL of Header_Extractor is  
--   attribute keep_hierarchy : string; 
--   attribute keep_hierarchy of RTL : architecture is "true";  
   
   alias RX_SOF    : std_logic is RX_LL_MOSI.SOF;                     
   alias RX_EOF    : std_logic is RX_LL_MOSI.EOF;                     
   alias RX_DATA   : std_logic_vector(15 downto 0) is RX_LL_MOSI.DATA;                      
   alias RX_DVAL   : std_logic is RX_LL_MOSI.DVAL;
   alias RX_SUPPORT_BUSY : std_logic is RX_LL_MOSI.SUPPORT_BUSY;
   alias RX_BUSY   : std_logic is RX_LL_MISO.BUSY;                     
   alias RX_AFULL  : std_logic is RX_LL_MISO.AFULL;  
   
   signal TX_SOF      : std_logic                    ;
   signal TX_EOF      : std_logic                    ;
   signal TX_DATA     : std_logic_vector(15 downto 0);                
   signal TX_DVAL     : std_logic                    ;               
   signal TX_SUPPORT_BUSY : std_logic                ;
   signal TX_BUSY     : std_logic                    ;
   signal TX_AFULL    : std_logic                    ;
   
   signal HeaderData : std_logic;
   signal PreviousAcqNumber : unsigned(ACQLEN-1 downto 0); 
   signal RESET : std_logic;
   signal RX_DVAL_buf : std_logic;
   signal TX_DVAL_buf : std_logic;  
   signal RX_BUSY_buf : std_logic;
   signal FRAME_BEGINi : std_logic;      
   signal Footer_In_Progress : std_logic;
   -- pragma translate_off
   signal output_debug : t_output_debug;
   -- pragma translate_on         
   
   signal rx_cnt     : unsigned(31 downto 0);
   attribute keep    : string; 
   attribute keep of rx_cnt : signal is "true";    
   
   signal tx_cnt     : unsigned(31 downto 0);   
   attribute keep of tx_cnt : signal is "true";      
   
begin    
   
   sync_RST : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);   
   
   TX_LL_MOSI.SOF          <= TX_SOF;                                   
   TX_LL_MOSI.EOF          <= TX_EOF;                                   
   TX_LL_MOSI.DATA         <= TX_DATA;              
   TX_LL_MOSI.DVAL         <= TX_DVAL;                                  
   TX_LL_MOSI.SUPPORT_BUSY <= '1';                            
   TX_BUSY                 <= TX_LL_MISO.BUSY;                                          
   TX_AFULL                <= TX_LL_MISO.AFULL;                                         
   
   RX_AFULL <= TX_AFULL;
   RX_BUSY <= RX_BUSY_buf; 
   RX_BUSY_buf <= TX_BUSY and not (RX_LL_MOSI.SOF and RX_LL_MOSI.DVAL) and not Footer_In_Progress; -- Always let SOF data in.
   RX_DVAL_buf <= RX_DVAL and not RX_BUSY_buf;
   TX_DVAL <= TX_DVAL_buf and not TX_BUSY;
   
   PAYLOAD_BEGIN <= FRAME_BEGINi;    
   
   --------------------------------
   -- ROIC Header Processing
   --------------------------------
   ROIC_header_processing : process (CLK, RESET)
      constant RoicHeaderLimit : integer := (ROIC_Img_Header_array16'LENGTH+1); 
      constant RoicFooterLimit : integer := (ROIC_Img_Footer_array16'LENGTH+1); 
      constant DCubeFooterLimit : integer := (ROIC_DCube_Footer_array16'LENGTH+1); 
      constant ProcHeaderLimit : integer := (DPB_DCube_Header_array16'LENGTH+1); 
      variable Header_cnt : integer range 1 to 63;
      variable ROICFooter_cnt : integer range 1 to RoicFooterLimit;
      variable FrameInProgress : std_logic;
      variable ROIC_HEADER_var : ROIC_Img_Header;
      variable ROIC_HEADER_array_var : ROIC_Img_Header_array16;
      variable ROIC_FOOTER_var : ROIC_Img_Footer;
      variable ROIC_FOOTER_array_var : ROIC_Img_Footer_array16; 
      variable DCUBE_FOOTER_var : ROIC_DCube_Footer;
      variable DCUBE_FOOTER_array_var : ROIC_DCube_Footer_array16;       
      --variable PROC_HEADER_var : DataCubeInfo;
      --variable PROC_HEADER_array_var : DataCubeInfo_array;
      variable PROC_HEADER_var : DPB_DCube_Header;
      variable PROC_HEADER_array_var : DPB_DCube_Header_array16;      
      variable FRAME_TYPE_v : std_logic_vector(7 downto 0);
      variable AllowImageBegin : std_logic;
   begin
      if rising_edge(CLK) then
         if RESET = '1' then
            FrameInProgress := '0';
            Header_cnt := 1;
            ROICFooter_cnt := 1;
            HeaderData <= '1';
            -- pragma translate_off
            output_debug <= to_output_debug((others => 'U'));
            -- pragma translate_on
            TX_DVAL_buf <= '0';
            DCUBE_BEGIN <= '0';
            NEW_CONFIG <= '0';
            FRINGE_ERR <= '0';
            PreviousAcqNumber <= (others => '0');
            FRAME_BEGINi <= '0';
            tx_cnt <= (others => '0');
            rx_cnt <= (others => '0');
            EOD <= '0'; 
            Footer_In_Progress <= '0';
            UNKNOWN_FRAME_ERR <= '0';
         else
            if RX_DVAL_buf = '1' then
               rx_cnt <= rx_cnt + 1;
            end if;
            
            if TX_DVAL = '1' and TX_BUSY = '0' then
               tx_cnt <= tx_cnt + 1;
            end if;
            
            -- pragma translate_off
            assert (RX_SUPPORT_BUSY = '1') report "Upstream module must support the BUSY signal" severity FAILURE;
            -- pragma translate_on
            
            if TX_BUSY = '0' then
               --TX_DVAL_buf <= RX_DVAL and (not HeaderData) and FrameInProgress;
               TX_DVAL_buf <= RX_DVAL_buf and (not HeaderData) and FrameInProgress and not RX_SOF;
               TX_DATA <= RX_DATA;
               TX_EOF <= RX_EOF;
               -- pragma translate_off
               output_debug <= to_output_debug(RX_DATA(15 downto 0));
               -- pragma translate_on               
            else
               -- Hold previous TX_DVAL_buf
            end if;
            
            -- Default values
            DCUBE_BEGIN <= '0';   
            NEW_CONFIG <= '0'; 
            FRAME_BEGINi <= '0'; 
            EOD <= '0';
            
            if RX_DVAL_buf = '1' then
               -- Detect beginning and end of image frames
               if RX_SOF = '1' then
                  Header_cnt := 1;
                  ROICFooter_cnt := 1;
                  AllowImageBegin := '1';
                  FrameInProgress := '1';
                  FRINGE_ERR <= '0';
                  FRAME_TYPE_v := RX_DATA(7 downto 0);
               elsif RX_EOF = '1' and FRAME_TYPE_v /= ROIC_FOOTER_FRAME and FRAME_TYPE_v /= PROC_HEADER_FRAME then
                  FrameInProgress := '0';
               end if; 
               
               -- Process header
               if FrameInProgress = '1' then
                  
                  ----------------------------
                  -- ROIC datacube header     
                  ----------------------------
                  if FRAME_TYPE_v = ROIC_DCUBE_FRAME_OLD or (FRAME_TYPE_v = ROIC_CAMERA_FRAME and VP30_PRESENT = '1') then   
                     
                     if Header_cnt < RoicHeaderLimit then
                        ROIC_HEADER_array_var(Header_cnt) := unsigned(RX_DATA);
                        ROIC_HEADER_var := to_ROIC_Img_Header(ROIC_HEADER_array_var);
                        Header_cnt := Header_cnt + 1;
                     elsif ROICFooter_cnt < RoicFooterLimit then
                        -- added this for footer info which will be eventually processed elsewhere
                        ROIC_FOOTER_array_var(ROICFooter_cnt) := std_logic_vector(RX_DATA(15 downto 0));
                        ROIC_FOOTER_var := to_ROIC_Img_Footer(ROIC_FOOTER_array_var);
                        ROICFooter_cnt := ROICFooter_cnt + 1;                        
                     end if;       
                     
                     -- Detect beginning of datacube
                     if Header_cnt = RoicHeaderLimit and ROICFooter_cnt = 1 and (ROIC_HEADER_var.Acq_Number /= PreviousAcqNumber) then
                        DCUBE_BEGIN <= '1';
                        if ROIC_HEADER_var.Fringe_Number /= 1 and ROIC_HEADER_var.CmdHeader = ROIC_DCUBE_FRAME_OLD then                  
                           FRINGE_ERR <= '1';
                        else
                           FRINGE_ERR <= '0';   
                        end if;
                     else
                        DCUBE_BEGIN <= '0';
                     end if;                                             
                     
                     -- Detect beginning of image  
                     if Header_cnt = RoicHeaderLimit and ROICFooter_cnt = RoicFooterLimit and AllowImageBegin = '1' then
                        FRAME_BEGINi <= '1';                                      
                        AllowImageBegin := '0';
                     else                  
                        FRAME_BEGINi <= '0';
                     end if;    
                     
                     -- Update HeaderData flag
                     if Header_cnt < RoicHeaderLimit or ROICFooter_cnt < RoicFooterLimit then 
                        HeaderData <= '1';                
                     else                     
                        HeaderData <= '0';                
                        PreviousAcqNumber <= ROIC_HEADER_var.Acq_Number;
                     end if;  
                     
                     ----------------------------
                     -- ROIC datacube footer (RIO v2.4 and onward)
                     ----------------------------                     
                  elsif FRAME_TYPE_v = ROIC_FOOTER_FRAME then                      
                     
                     if Header_cnt = DCubeFooterLimit-1 then
                        EOD <= '1';          
                        FrameInProgress := '0';
                        Footer_In_Progress <= '0';
                     else                         
                        Footer_In_Progress <= '1';
                        EOD <= '0';
                     end if;
                     
                     if Header_cnt < DCubeFooterLimit then
                        DCUBE_FOOTER_array_var(Header_cnt) := RX_DATA;
                        DCUBE_FOOTER_var := to_ROIC_DCube_Footer(DCUBE_FOOTER_array_var);
                        Header_cnt := Header_cnt + 1;                                 
                        HeaderData <= '1';                
                     else
                        HeaderData <= '0'; 
                     end if;                           
                     
                     FRAME_BEGINi <= '0';
                     DCUBE_BEGIN <= '0';                    
                     
                     ----------------------------
                     -- ROIC camera frame
                     ----------------------------
                  elsif FRAME_TYPE_v = ROIC_CAMERA_FRAME and VP30_PRESENT = '0' then   
                     
                     if Header_cnt < RoicHeaderLimit then
                        ROIC_HEADER_array_var(Header_cnt) := unsigned(RX_DATA);
                        ROIC_HEADER_var := to_ROIC_Img_Header(ROIC_HEADER_array_var);
                        Header_cnt := Header_cnt + 1;                      
                     elsif ROICFooter_cnt < RoicFooterLimit then
                        ROICFooter_cnt := ROICFooter_cnt + 1;                        
                     end if;                                        
                     
                     -- Detect beginning of image  
                     if Header_cnt = RoicHeaderLimit and AllowImageBegin = '1' then
                        FRAME_BEGINi <= '1'; 
                        DCUBE_BEGIN <= '1';
                        AllowImageBegin := '0';
                     else                  
                        FRAME_BEGINi <= '0';
                        DCUBE_BEGIN <= '0';
                     end if;    
                     
                     -- Update HeaderData flag
                     if Header_cnt < RoicHeaderLimit then 
                        HeaderData <= '1';                
                     else                     
                        HeaderData <= '0';                
                     end if;  
                     
                     ------------------------------------
                     -- Data processing datacube header
                     -------------------------------------
                  elsif SupportProc and (FRAME_TYPE_v = PROC_HEADER_FRAME) then   
                     
                     if Header_cnt = 1 and RX_SOF = '0' then
                        DCUBE_BEGIN <= '1';
                     else
                        DCUBE_BEGIN <= '0';
                     end if;                
                     FRAME_BEGINi <= '0';                 
                     HeaderData <= '1'; 
                     
                     if RX_EOF = '1' then
                        FrameInProgress := '0';  
                        PreviousAcqNumber <= PROC_HEADER_var.ROICHeader.Acq_Number;
                     end if;
                     
                     --if Header_cnt < ProcHeaderLimit and RX_SOF = '0' then
                     if RX_SOF = '0' then
                        PROC_HEADER_array_var(Header_cnt) := RX_DATA;
                        PROC_HEADER_var := to_DPB_DCube_Header(PROC_HEADER_array_var);
                        Header_cnt := Header_cnt + 1;                      
                     end if;                                                   
                     
                     ------------------------------------
                     -- Data processing datacube payload
                     -------------------------------------
                  elsif SupportProc and (FRAME_TYPE_v = PROC_DCUBE_FRAME) then   
                     
                     if Header_cnt < 2 and RX_SOF = '0' then
                        Header_cnt := Header_cnt + 1;                      
                     end if;   
                     
                     -- Detect beginning of BIP frame
                     FRAME_BEGINi <= RX_SOF;
                     --                     if Header_cnt = 1 and AllowImageBegin = '1' and RX_SOF = '0' then
                     --                        FRAME_BEGINi <= '1';                                      
                     --                        AllowImageBegin := '0';
                     --                     else                  
                     --                        FRAME_BEGINi <= '0';
                     --                     end if;    
                     
                     -- Update HeaderData flag                                       
                     HeaderData <= '0';      
                  else
                     UNKNOWN_FRAME_ERR <= '1';
                     assert FALSE report "Unknown frame!!!" severity ERROR;                                                                      
                  end if;                  
               end if;     
               
               if RX_EOF = '1' then -- Next data is a header for sure.
                  HeaderData <= '1';
               end if;
               
            end if; -- if RX_DVAL_buf = '1'
            
            FRAME_TYPE <= FRAME_TYPE_v;
            
            --            ROIC_HEADER <= ROIC_HEADER_var;            
            --            ROIC_FOOTER <= ROIC_FOOTER_var; 
            
            -- Convert old headers to new v2.5 headers
            ROIC_HEADER <= to_ROIC_DCube_Header(ROIC_HEADER_var, ROIC_FOOTER_var);
            ROIC_FOOTER <= to_ROIC_DCube_Footer(ROIC_HEADER_var, ROIC_FOOTER_var);
            
            --DCUBE_FOOTER <= DCUBE_FOOTER_var; -- Not used yet.
            PROC_HEADER <= PROC_HEADER_var;
         end if;
      end if;
   end process;
   
end RTL;
