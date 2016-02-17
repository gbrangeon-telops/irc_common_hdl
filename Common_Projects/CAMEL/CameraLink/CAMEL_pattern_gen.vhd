---------------------------------------------------------------------------------------------------
--
-- Title       : CAMEL_pattern_gen
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
--
---------------------------------------------------------------------------------------------------
--
-- Description : This module is meant to be a universal pattern generator for the CAMEL electronics.
--					  As such, it can generate simple camera patterns, dummy interferograms like a dirac
--					  for easy FFT debug, counters in BIP or BSQ mode, etc.	  
--					  It can be configured to preceed the data by a header or not, depending on the
--					  application.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;

entity CAMEL_pattern_gen is 
   generic(														 
      Half           : boolean := true;   -- Send only half the data (respecting FPGA_ID)
      SendHeader     : boolean := true;   -- Send Image Header
      SendFooter     : boolean := true;   -- Send DataCube Footer
      BSQ            : boolean := true    -- BIP if false
      );
   port(
      --------------------------------
      -- Interface
      --------------------------------
      CONFIG_PARAM 	: in DPBConfig;
      Start				: in std_logic;							-- State machine Start pulse
      FPGA_ID			: in std_logic;
      MODE				: in std_logic_vector(2 downto 0);	-- Used to be able to generate datacubes or camera frames
      DIAG_ACQ_NUM   : in std_logic_vector(3 downto 0);
      --------------------------------
      -- Standard data path
      --------------------------------		
      TX_LL_MISO     : in  t_ll_miso;
      TX_LL_MOSI     : out t_ll_mosi; 
      EOD				: out	std_logic;	-- End of DataCube
      DONE           : out std_logic;
      --------------------------------
      -- Other IOs
      --------------------------------			
      ARESET 			: in STD_LOGIC;							
      CLK 				: in STD_LOGIC							
      );
end CAMEL_pattern_gen;

architecture behavioral of CAMEL_pattern_gen is 

   alias TX_SOF         : std_logic is TX_LL_MOSI.SOF;                     
   alias TX_EOF         : std_logic is TX_LL_MOSI.EOF;                     
   alias TX_DATA        : std_logic_vector(15 downto 0) is TX_LL_MOSI.DATA;                      
   alias TX_DVAL        : std_logic is TX_LL_MOSI.DVAL;                                          
   alias TX_SUPPORT_BUSY: std_logic is TX_LL_MOSI.SUPPORT_BUSY;
   alias TX_BUSY        : std_logic is TX_LL_MISO.BUSY;                     
   alias TX_AFULL       : std_logic is TX_LL_MISO.AFULL;  

   signal XSIZE : integer range 0 to 65535;
   signal YSIZE : integer range 0 to 65535;
   signal ZSIZE : integer range 0 to 16777215;
   signal TAGSIZE : integer range 0 to 255;
   signal IMGSIZE : integer range 0 to (2**20)-1;
   signal X_cnt : integer range 1 to 65535;
   signal Y_cnt : integer range 1 to 65535;
   signal Z_cnt : integer range 1 to 16777215; 
   constant AVGLEN : integer := CONFIG_PARAM.AVGSIZE'LENGTH;
   signal AVGSIZE : unsigned(AVGLEN-1 downto 0);
   
   signal master_cnt : unsigned(15 downto 0); 
   signal data_size : unsigned(15 downto 0);
   signal Tag_cnt : integer range 1 to 65535; 
   signal dcube_cnt : unsigned(9 downto 0);
   signal DIAG_ACQ_NUM_reg : unsigned(9 downto 0);
   -- pragma translate_off
   signal output_debug : t_output_debug;
   signal TimeStamp : unsigned(31 downto 0);
   signal Write_No : unsigned(23 downto 0);
   signal Trig_No : unsigned(23 downto 0);
   -- pragma translate_on
   
   signal EOD_buf		: std_logic;				-- Internal End Of Datacube
   
   --signal VP30Header_array : ROIC_Img_Header_array16;
   signal VP30Header : ROIC_Img_Header;  
   --signal VP30Footer_array :ROIC_Img_Footer_array16;
   signal VP30Footer : ROIC_Img_Footer;
   signal DCubeFooter_array :ROIC_DCube_Footer_array16;
   signal DCubeFooter : ROIC_DCube_Footer;   
   signal MODE_reg : std_logic_vector(2 downto 0); 
   signal Start_req : std_logic;
   
   signal Xadjust_temp : std_logic;
   signal Xadjust : integer range 0 to 1; 
   
   signal RESET : std_logic;
   
   -- State machine
   type t_Run_Mode is (Idle, Init, SendImgHeader, SendPayload, SendDCubeFooter, Pause);
   signal State : t_Run_Mode;
   
   attribute tig: string;
   attribute tig of CONFIG_PARAM : signal is ""; 
   attribute tig of FPGA_ID : signal is ""; 
   
   
begin		        
   sync_RESET_inst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);
   
   TX_SUPPORT_BUSY <= '1';
   
   Xadjust_temp <= not(FPGA_ID xor std_logic(CONFIG_PARAM.XSIZE(0)));
   Xadjust <= 1 when ((Xadjust_temp = '1') and Half) else 0;
   
   EOD <= EOD_buf;
   XSIZE <= to_integer(CONFIG_PARAM.XSIZE);
   YSIZE <= to_integer(CONFIG_PARAM.YSIZE);
   ZSIZE <= to_integer(CONFIG_PARAM.Fringe_Total);
   IMGSIZE <= to_integer(CONFIG_PARAM.IMGSIZE);
   
   data_size <= to_unsigned((TAGSIZE*ZSIZE + IMGSIZE*(ZSIZE+1)),16);
   
   --VP30Header_array <= to_ROIC_Img_Header_array16(VP30Header);
   
   -- allways follow header for repeated footer fields
   VP30Footer.ROIC_Direction     <= VP30Header.Direction;
   VP30Footer.ROIC_Acq_Number    <= VP30Header.Acq_Number;
   -- others are default values for now
   --VP30Footer.ROIC_Write_No      <= ROIC_Img_Footer_default.ROIC_Write_No;
   --VP30Footer.ROIC_Trig_No       <= ROIC_Img_Footer_default.ROIC_Trig_No;
   VP30Footer.ROIC_Version       <= ROIC_Img_Footer_default.ROIC_Version;
   VP30Footer.ROIC_Status        <= ROIC_Img_Footer_default.ROIC_Status;
   --   VP30Footer.ROIC_Xmin          <= ROIC_Img_Footer_default.ROIC_Xmin;
   --   VP30Footer.ROIC_Ymin          <= ROIC_Img_Footer_default.ROIC_Ymin;
   --   VP30Footer.ROIC_ZPDPosition   <= ROIC_Img_Footer_default.ROIC_ZPDPosition;
   --   VP30Footer.ROIC_ZPDPeakVal    <= ROIC_Img_Footer_default.ROIC_ZPDPeakVal;
   VP30Footer.ROIC_Xmin          <= to_unsigned(312, VP30Footer.ROIC_Xmin'LENGTH);
   VP30Footer.ROIC_Ymin          <= to_unsigned(113, VP30Footer.ROIC_Ymin'LENGTH);
   VP30Footer.ROIC_ZPDPosition   <= to_unsigned(97123, VP30Footer.ROIC_ZPDPosition'LENGTH);
   VP30Footer.ROIC_ZPDPeakVal    <= to_unsigned(14830, VP30Footer.ROIC_ZPDPeakVal'LENGTH);
   --VP30Footer.ROIC_TimeStamp     <= ROIC_Img_Footer_default.ROIC_TimeStamp;
   -- pragma translate_off
   VP30Footer.ROIC_Write_No      <= Write_No;
   VP30Footer.ROIC_Trig_No       <= Trig_No;
   --VP30Footer.ROIC_TimeStamp     <= TimeStamp;   
   
   --   VP30Footer <= ROIC_Img_Footer_default;
   --VP30Footer_array <= to_ROIC_Img_Footer_array16(VP30Footer);
   
   DCubeFooter.Direction   <= VP30Header.Direction;
   DCubeFooter.Acq_Number  <= VP30Header.Acq_Number;
   DCubeFooter.Write_No    <= Write_No;
   DCubeFooter.Trig_No     <= Trig_No;
   DCubeFooter.Acq_Number  <= VP30Header.Acq_Number;
   DCubeFooter.Status      <= ROIC_Img_Footer_default.ROIC_Status;
   DCubeFooter.ZPDPosition <= to_unsigned(97123, VP30Footer.ROIC_ZPDPosition'LENGTH);
   DCubeFooter.ZPDPeakVal  <= to_unsigned(14830, VP30Footer.ROIC_ZPDPeakVal'LENGTH);
   DCubeFooter.TimeStamp   <= TimeStamp;             
   
   DCubeFooter_array <= to_ROIC_DCube_Footer_array16(DCubeFooter);
   
   -- pragma translate_on
   
   -- Frame generation
   Frame_generation : process (CLK, RESET)
      variable Header_cnt : integer range 0 to ROIC_Img_Header_array16'LENGTH;
      variable Footer_cnt : integer range 0 to ROIC_Img_Footer_array16'LENGTH;
      variable Pause_cnt : integer range 0 to 32767;
      --variable NoImgHeader : std_logic;  
      variable output15 : std_logic_vector(14 downto 0);	  
      variable CRC_val : std_logic_vector(0 downto 0);  
      variable VP30Header_array : ROIC_Img_Header_array16; 
      variable VP30Footer_array :ROIC_Img_Footer_array16;
   begin	
      if rising_edge(CLK) then
         if RESET = '1' then
            master_cnt <= (others => '0');
            Y_cnt <= 1;		
            if (Half) and FPGA_ID = '1' then
               X_cnt <= 2;
               Tag_cnt <= 2; 			 
            else
               X_cnt <= 1; 
               Tag_cnt <= 1; 				
            end if;
            Start_req <= '0';
            Z_cnt <= 1;
            Header_cnt := 0;
            Footer_cnt := 0;
            TX_EOF <= '0';
            EOD_buf <= '0';
            TX_SOF <= '0';
            TX_DVAL <= '0';
            VP30Header.CmdHeader <= X"01";
            VP30Header.Direction <= '1';
            VP30Header.Acq_Number <= to_unsigned(1,23);
            VP30Header.Fringe_Number <= to_unsigned(1,24);	
            State <= Idle;
            --NoImgHeader := '0';
            Pause_cnt := 0;
            DONE <= '1';                 
            -- pragma translate_off
            TimeStamp <= (others => '0');
            Write_No <= (others => '0');
            Trig_No <= (others => '0');
            assert not (SendHeader and not BSQ) report "SendHeader and BIP together not supported." severity FAILURE;	
            
            -- pragma translate_on
         else                      
            -- pragma translate_off
            TimeStamp <= TimeStamp + 1;
            -- pragma translate_on
            if CONFIG_PARAM.Fringe_Total > 65535 then
               -- Averaging limited to 16-bit ZSize.
               AVGSIZE <= to_unsigned(1, AVGSIZE'LENGTH);
            else
               AVGSIZE <= CONFIG_PARAM.AVGSIZE;
            end if;            
            
            if MODE_reg = "001" or MODE_reg = "011" then	-- Camera mode			 
               VP30Header.CmdHeader <= X"00";
            else
               VP30Header.CmdHeader <= X"01";
            end if;
            
            case State is
               
               -----------------------
               -- Idle State		  
               -----------------------					
               when Idle =>
                  if TX_BUSY = '0' then
                     DONE <= '1';
                     TX_DVAL <= '0';
                     dcube_cnt <= (others => '0');
                     -- pragma translate_off
                     output_debug <= to_output_debug((others => 'U'));
                     Write_No <= (others => '0');
                     Trig_No <= (others => '0');
                     -- pragma translate_on	
                     if (Start = '1' or Start_req = '1') and TX_AFULL = '0' and (MODE = "001" or MODE = "010" or MODE = "011" or MODE = "100" or MODE = "101") then							 
                        State <= Init;
                        DONE <= '0';
                        Pause_cnt := 0; 
                        MODE_reg <= MODE;
                        Start_req <= '0';
                     elsif Start = '1' and (MODE = "001" or MODE = "010" or MODE = "011" or MODE = "100" or MODE = "101") then							 
                        Start_req <= '1';
                     end if;			 
                  else
                     -- hold values
                  end if;
                  
                  -----------------------
                  -- Init State		  
                  -----------------------						
               when Init =>
                  if TX_BUSY = '0' then
                     -- pragma translate_off
                     output_debug <= to_output_debug((others => 'U'));
                     Write_No <= (others => '0');
                     Trig_No <= (others => '0');
                     -- pragma translate_on                  
                     TX_DVAL <= '0';                  
                     if Pause_cnt = 32767 -- Let the time for RS232 DIAG_ACQ_NUM to arrive
                        -- synthesis translate_off
                        or Pause_cnt >= 10
                        -- synthesis translate_on
                        then
                        Pause_cnt := 0;
                        dcube_cnt <= dcube_cnt + 1;
                        State <= SendImgHeader;                     
                        DIAG_ACQ_NUM_reg <= unsigned(DIAG_ACQ_NUM) * AVGSIZE;
                        -- pragma translate_off
                        Write_No <= Write_No + 1;
                        Trig_No <= Trig_No + 1;
                        -- pragma translate_on                     
                     end if;
                     
                     if MODE_reg = "001" or MODE_reg = "011" then -- Camera Mode
                        TAGSIZE <= 0;
                     else													  
                        TAGSIZE <= to_integer(CONFIG_PARAM.TAGSIZE);
                     end if;	
                     Header_cnt := 0;
                     Footer_cnt := 0;
                     VP30Header.Fringe_Number <= to_unsigned(1,24);
                     master_cnt <= (others => '0');
                     Y_cnt <= 1;
                     if (Half) and FPGA_ID = '1' then
                        X_cnt <= 2;
                        Tag_cnt <= 2; 			 
                     else
                        X_cnt <= 1; 
                        Tag_cnt <= 1; 				
                     end if;
                     Z_cnt <= 1;
                  else
                     -- hold values
                  end if;
                  if Pause_cnt < 32767 then
                     Pause_cnt := Pause_cnt + 1;
                  end if;
                  
                  -----------------------
                  -- SendImgHeader State		  
                  -----------------------						
               when SendImgHeader =>               
                  if (not SendHeader) then
                     State <= SendPayload;
                  elsif TX_BUSY = '0' then
                     if TX_AFULL = '0' then -- Receiving module is ready
                        TX_DVAL <= '1';
                        TX_SOF <= '0';
                        TX_EOF <= '0';
                        EOD_buf <= '0';
                        -- Send Header
                        if Header_cnt < ROIC_Img_Header_array16'LENGTH then 			-- Header is not completed
                           if Header_cnt = 0 then
                              TX_SOF <= '1';
                           end if;
                           Header_cnt := Header_cnt + 1;	
                           VP30Header_array := to_ROIC_Img_Header_array16(VP30Header);
                           TX_DATA <= std_logic_vector(VP30Header_array(Header_cnt));
                           Y_cnt <= 1;
                           if FPGA_ID = '0' then X_cnt <= 1; else X_cnt <= 2;	end if;
                           -- pragma translate_off
                           output_debug <= to_output_debug((others => 'U'));
                           -- pragma translate_on          
                        elsif Footer_cnt < ROIC_Img_Footer_array16'length and MODE /= "001" then      -- Footer is not completed
                           Footer_cnt := Footer_cnt + 1;              
                           -- pragma translate_off
                           VP30Footer.ROIC_TimeStamp     <= TimeStamp;
                           -- pragma translate_on
                           VP30Footer_array := to_ROIC_Img_Footer_array16(VP30Footer);
                           TX_DATA <= std_logic_vector(VP30Footer_array(Footer_cnt));
                           Y_cnt <= 1;
                           if FPGA_ID = '0' then X_cnt <= 1; else X_cnt <= 2; end if;
                           -- pragma translate_off
                           output_debug <= to_output_debug((others => 'U'));
                           -- pragma translate_on
                           
                        else 
                           State <= SendPayload;
                           TX_DVAL <= '0';
                        end if; 
                     else						
                        TX_DVAL <= '0';
                        -- pragma translate_off
                        output_debug <= to_output_debug((others => 'U'));
                        -- pragma translate_on						
                     end if;
                  else
                     -- TX_BUSY = '1' : hold values.
                  end if;
                  
                  -----------------------
                  -- SendPayload State		  
                  -----------------------						
               when SendPayload =>              
                  if TX_BUSY = '0' then
                     if TX_AFULL = '0' then -- Receiving module is ready
                        TX_SOF <= '0';
                        TX_EOF <= '0';
                        EOD_buf <= '0';
                        TX_DVAL <= '1';
                        if BSQ and (not SendHeader) and X_cnt = 1 and Y_cnt = 1 and Tag_cnt = 1 then
                           TX_SOF <= '1';
                        else
                           TX_SOF <= '0';
                        end if;
                        
                        -- pragma translate_off
                        output_debug <= to_output_debug(FPGA_ID & std_logic_vector(to_unsigned(Z_cnt,5)) & std_logic_vector(to_unsigned(Y_cnt,5)) & std_logic_vector(to_unsigned(X_cnt,5)));					
                        -- pragma translate_on
                        if CONFIG_PARAM.DP_Mode="01" and (Half) then -- Special output for spectro mode
                           if Z_cnt = 3 then
                              TX_DATA <= X"0200";
                           else
                              TX_DATA <= (others => '0');
                           end if;								 
                           --OUTPUT <= std_logic_vector(to_unsigned(Z_cnt,16));
                           --                     elsif CONFIG_PARAM.DP_Mode="01" and (LOCATION = VP7) then
                           --                        OUTPUT <= std_logic_vector(master_cnt);
                           --elsif CONFIG_PARAM.Bit_Per_Pixel <= 16 then
                        else
                           output15 := std_logic_vector(to_unsigned(Z_cnt,5)) & std_logic_vector(to_unsigned(Y_cnt,5)) & std_logic_vector(to_unsigned(X_cnt,5));
                           if MODE = "100" then		
                              CRC_val := CRC(output15, 1);
                              TX_DATA <= CRC_val(0) & output15;																
                           else
                              TX_DATA <= FPGA_ID & output15;
                           end if;
                           --else
                           --OUTPUT <= "0" & std_logic_vector(to_unsigned(Z_cnt,5)) & std_logic_vector(to_unsigned(Y_cnt,5)) & std_logic_vector(to_unsigned(X_cnt,5));																
                        end if;    
                        
                        -- Generate frame			
                        if ((Half) and Z_cnt = ZSIZE and X_cnt >= (XSIZE-Xadjust) and Y_cnt = YSIZE and Tag_cnt >= (TAGSIZE+1))
                           or (not Half and CONFIG_PARAM.DP_Mode="00" and Z_cnt = ZSIZE and X_cnt >= (XSIZE-Xadjust) and Y_cnt = YSIZE and Tag_cnt >= (TAGSIZE+1))
                           or (not Half and CONFIG_PARAM.DP_Mode="01" and master_cnt = data_size-1) then -- End of Datacube
                           TX_EOF <= '1';
--                           if dcube_cnt >= unsigned(DIAG_ACQ_NUM_reg) or DIAG_ACQ_NUM_reg = "0000" then
--                              State <= Pause;
--                           else
--                              State <= Init;
--                           end if;
                           State <= SendDCubeFooter;
                           Header_cnt := 0;
                           Footer_cnt := 0;
                           VP30Header.Fringe_Number <= to_unsigned(1,24);
                           VP30Header.Acq_Number <= VP30Header.Acq_Number + 1;						
                           EOD_buf <= '1'; -- End of DataCube 
                           master_cnt <= (others => '0');
                           Y_cnt <= 1;
                           if (Half) and FPGA_ID = '1' then
                              X_cnt <= 2;
                              Tag_cnt <= 2; 			 
                           else
                              X_cnt <= 1; 
                              Tag_cnt <= 1; 				
                           end if;
                           Z_cnt <= 1;
                        else
                           master_cnt <= master_cnt + 1;  
                           if BSQ then
                              if	Tag_cnt >= (TAGSIZE+1) then
                                 if X_cnt >= (XSIZE-Xadjust) and Y_cnt = YSIZE then -- End of Image
                                    TX_EOF <= '1';
                                    State <= SendImgHeader;
                                    Header_cnt := 0;
                                    Footer_cnt := 0;
                                    VP30Header.Fringe_Number <= VP30Header.Fringe_Number + 1;
                                    -- pragma translate_off
                                    Write_No <= Write_No + 1;
                                    Trig_No <= Trig_No + 1;
                                    -- pragma translate_on                              
                                    if (Half) and FPGA_ID = '1' then
                                       X_cnt <= 2;
                                       Tag_cnt <= 2; 			 
                                    else
                                       X_cnt <= 1; 
                                       Tag_cnt <= 1; 				
                                    end if;
                                    Y_cnt <= 1;
                                    Z_cnt <= Z_cnt + 1;
                                 else
                                    if X_cnt >= (XSIZE-Xadjust) then
                                       if (Half) and FPGA_ID = '1' then X_cnt <= 2; else X_cnt <= 1; end if;
                                       Y_cnt <= Y_cnt + 1;
                                    else				
                                       if (Half) then X_cnt <= X_cnt + 2; else X_cnt <= X_cnt + 1; end if;
                                    end if; 		
                                 end if; -- if End of Image
                              else -- if Tag_cnt >= (TAGSIZE+1)
                                 output15 := std_logic_vector(resize(VP30Header.Fringe_Number,7)) & std_logic_vector(to_unsigned(Tag_cnt,8));
                                 if MODE = "100" then		
                                    CRC_val := CRC(output15, 1);
                                    TX_DATA <= CRC_val(0) & output15;																
                                 else
                                    TX_DATA <= std_logic_vector(resize(VP30Header.Fringe_Number,8)) & std_logic_vector(to_unsigned(Tag_cnt,8));
                                 end if;									                           
                                 -- pragma translate_off
                                 output_debug <= to_output_debug((others => 'U'));
                                 -- pragma translate_on
                                 if (Half) then Tag_cnt <= Tag_cnt + 2;	else Tag_cnt <= Tag_cnt + 1; end if;
                              end if; -- if tag
                              
                           else  -- BIP 
                              if Tag_cnt < (TAGSIZE+1) then
                                 TX_DATA <= std_logic_vector(to_unsigned(Z_cnt,8)) & std_logic_vector(to_unsigned(Tag_cnt,8));   
                              end if;
                              if Z_cnt = ZSIZE then -- End of interferogram
                                 Z_cnt <= 1;
                                 TX_EOF <= '1';
                                 if	Tag_cnt >= (TAGSIZE+1) then
                                    
                                    if X_cnt >= (XSIZE-Xadjust) then
                                       if (Half) and FPGA_ID = '1' then X_cnt <= 2; else X_cnt <= 1; end if;
                                       Y_cnt <= Y_cnt + 1;
                                    else				
                                       if (Half) then X_cnt <= X_cnt + 2; else X_cnt <= X_cnt + 1; end if;
                                    end if;                                     
                                 else                                    
                                    if (Half) then Tag_cnt <= Tag_cnt + 2;	else Tag_cnt <= Tag_cnt + 1; end if;
                                 end if;
                              else
                                 Z_cnt <= Z_cnt + 1;
                                 if Z_cnt = 1 then
                                    TX_SOF <= '1';
                                 end if;                                 
                              end if; -- if End of vector   
                           end if; -- if BSQ
                        end if; -- if End of Datacube
                        
                        -- Receiving module is not ready
                     else	-- TX_AFULL = '1' 
                        TX_DVAL <= '0';
                        -- pragma translate_off
                        output_debug <= to_output_debug((others => 'U'));
                        -- pragma translate_on
                     end if; -- if TX_AFULL = '0'
                  else
                     -- TX_BUSY = '1' : hold values.
                  end if;
                  
                  -----------------------
                  -- SendDCubeFooter State		  
                  -----------------------						
               when SendDCubeFooter =>               
                  if (not SendFooter) then
                     TX_DVAL <= '0';
                     if dcube_cnt >= unsigned(DIAG_ACQ_NUM_reg) or DIAG_ACQ_NUM_reg = "0000" then
                        State <= Pause;
                     else
                        State <= Init;
                     end if;
                  elsif TX_BUSY = '0' then
                     if TX_AFULL = '0' then -- Receiving module is ready
                        TX_DVAL <= '1';
                        TX_SOF <= '0';
                        TX_EOF <= '0';
                        EOD_buf <= '0';
                        
                        -- SOF & EOF
                        if Footer_cnt = 0 then
                           TX_SOF <= '1';
                        end if;                        
                        if Footer_cnt = ROIC_DCube_Footer_array16'LENGTH-1 then
                           TX_EOF <= '1';
                        end if;       
                                         
                        -- Send Header
                        if Footer_cnt < ROIC_DCube_Footer_array16'LENGTH then 			-- Footer is not completed
                           Footer_cnt := Footer_cnt + 1;	
                           TX_DATA <= std_logic_vector(DCubeFooter_array(Footer_cnt));
                           -- pragma translate_off
                           output_debug <= to_output_debug((others => 'U'));
                           -- pragma translate_on                                    
                        else 
                           if dcube_cnt >= unsigned(DIAG_ACQ_NUM_reg) or DIAG_ACQ_NUM_reg = "0000" then
                              State <= Pause;
                           else
                              State <= Init;
                           end if;
                           TX_DVAL <= '0';
                        end if; 
                     else						
                        TX_DVAL <= '0';
                        -- pragma translate_off
                        output_debug <= to_output_debug((others => 'U'));
                        -- pragma translate_on						
                     end if;
                  else
                     -- BUSY = '1' : hold values.
                  end if;                  
                  
               when Pause => 
               if TX_BUSY = '0' then
                  TX_DVAL <= '0';
               end if;
               --               if Pause_cnt = 63 and MODE = "000" then
               --                  State <= Idle;
               --               elsif Pause_cnt < 63 then
               --                  Pause_cnt := Pause_cnt + 1;
               --               end if; 
               if MODE = "000" or DIAG_ACQ_NUM_reg = "0000" then
                  State <= Idle;
               end if;
               DONE <= '1';
               
               
            end case;
         end if; -- if RESET					
      end if; -- if rising_edge(CLK)
   end process;
   
end behavioral;
