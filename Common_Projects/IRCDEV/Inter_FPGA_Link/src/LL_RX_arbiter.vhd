-------------------------------------------------------------------------------
--
-- Title       : LL_RX_arbiter
-- Design      : Inter_FPGA_Link
-- Author      : Khalid Bensadek
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\LL_RX_arbiter.vhd
-- Generated   : Thu Jan 21 09:02:25 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {LL_RX_arbiter} architecture {LL_RX_arbiter}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
library common_HDL;       
use common_HDL.Telops.all;
use work.SerialLink_Defines.all;

entity LL_RX_arbiter is
	 port(
		 ARESET : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 RX_MOSI : in t_ll_mosi8;
		 CH1_TX_MISO : in t_ll_miso;
		 CH2_TX_MISO : in t_ll_miso;
		 CH3_TX_MISO : in t_ll_miso;
		 CH4_TX_MISO : in t_ll_miso;
		 CH5_TX_MISO : in t_ll_miso;
		 CH6_TX_MISO : in t_ll_miso;
		 RX_MISO : out t_ll_miso;
		 CH2_TX_MOSI : out t_ll_mosi8;
		 CH3_TX_MOSI : out t_ll_mosi8;
		 CH4_TX_MOSI : out t_ll_mosi8;
		 CH5_TX_MOSI : out t_ll_mosi8;
		 CH6_TX_MOSI : out t_ll_mosi8;
		 CH1_TX_MOSI : out t_ll_mosi8;
       ARB_ERR : out std_logic;
       RX_CHECKSUM_ERR : out std_logic
	     );
end LL_RX_arbiter;

--}} End of automatically maintained section

architecture LL_RX_arbiter of LL_RX_arbiter is

 component sync_reset
		port(
			ARESET : in std_logic;
			SRESET : out std_logic;
			CLK : in std_logic);
 end component;
 
 signal sreset : std_logic; 
 signal rx_sof, tx_sof : std_logic; 
 signal rx_eof, tx_eof : std_logic; 
 signal rx_dval : std_logic; 
 signal rx_ChInfo_eof, rx_ChInfo_sof : std_logic; 
 signal ch_1_afull,
 		ch_2_afull,
 		ch_3_afull,
 		ch_4_afull,
 		ch_5_afull,
 		ch_6_afull,
 		rx_afull	: std_logic;
 
 signal v8_rx_data,v8_tx_data : std_logic_vector(7 downto 0);
 signal v6_tx_dvals, v6_tx_dvalsOut : std_logic_vector(5 downto 0);
 signal v6_rx_chNbr : std_logic_vector(5 downto 0); 
 signal ValidChNumb : boolean;
 signal RxArbiterErr : std_logic;
 
 --FSM signal and constants  
 type rx_ArbFsm_t is (ch_info_c, ch_data_c, ch_ckSum_c);
 signal rx_arb_fsm_s : rx_ArbFsm_t;
 
 type ch6_fsm_t is (add, byte1, byte0, ForwardD2Ch);
 signal ch6_fsm_s : ch6_fsm_t;
 
 type Fw_Fsm_t is (FwAdd, FwByte1, FwByte0);
 signal Fw_Fsm_s : Fw_Fsm_t;
 
 type ch6_data_t is
   record
      add : std_logic_vector(7 downto 0);
      byte0 : std_logic_vector(7 downto 0);
      byte1 : std_logic_vector(7 downto 0);
   end record;
  signal ch6_data : ch6_data_t; 
 
 signal ChckSum : std_logic_vector(7 downto 0);
 signal ChckSumErr : std_logic;
 signal FwD2ch : std_logic;
 --- For dbg only, to be removed.
 attribute keep : string;
 attribute keep of ChckSumErr : signal is "true";
 attribute keep of rx_ChInfo_eof : signal is "true";
 attribute keep of rx_ChInfo_sof : signal is "true";
 attribute keep of v8_rx_data    : signal is "true";
 attribute keep of rx_dval    : signal is "true";
 
begin

	-- enter your statements here --
	ARB_ERR <= RxArbiterErr;
	-- Sync Reset
	sync_RESET_TX :  sync_reset
	port map(
		ARESET 	=> ARESET,
		SRESET 	=> sreset,
		CLK 	=> CLK
		); 
	 
	 --RX_MOSI.SUPPORT_BUSY;
	 rx_sof <= RX_MOSI.SOF;
	 rx_eof <= RX_MOSI.EOF;
	 v8_rx_data <= RX_MOSI.DATA;
	 rx_dval <= RX_MOSI.DVAL;
	 --    
	 rx_ChInfo_eof <= v8_rx_data(7);
	 rx_ChInfo_sof <= v8_rx_data(6);
	 v6_rx_chNbr <= v8_rx_data(5 downto 0);	 
	 --
	 ch_1_afull <= CH1_TX_MISO.AFULL;
	 ch_2_afull <= CH2_TX_MISO.AFULL;
	 ch_3_afull <= CH3_TX_MISO.AFULL;
	 ch_4_afull <= CH4_TX_MISO.AFULL;
	 ch_5_afull <= CH5_TX_MISO.AFULL;
	 ch_6_afull <= CH6_TX_MISO.AFULL;
    
	 -----------------------------------------------------------------------
    -- Detect if we have a valid channel number to start the comm
    -----------------------------------------------------------------------
    process(v6_rx_chNbr)
    begin
      case v6_rx_chNbr is
         when SLINK_CH1 | SLINK_CH2 | SLINK_CH3 | SLINK_CH4 | SLINK_CH5 | SLINK_CH6 =>
            ValidChNumb <= true;
         when others =>
            ValidChNumb <= false;
      end case;   
    end process;
    
    -----------------------------------------------------------------------
    -- RX arbiter FSM to handel data channels demultiplexing
    -----------------------------------------------------------------------    
	 process(CLK)
	 begin
	 	if rising_edge(CLK) then
	 		if sreset = '1' then	 				 			
            v6_tx_dvals <= CLOSE_ALLDVAL; 
            v6_tx_dvalsOut <= CLOSE_ALLDVAL;             
	 			tx_sof <= '0';
	 			tx_eof <= '0';	 			
            RxArbiterErr <= '0';            
            ChckSum <= x"00";
            ChckSumErr <= '0';
            v8_tx_data  <= x"00";            
	 			rx_arb_fsm_s <= ch_info_c;	 			
	 		else
            -- Default value
	 			RxArbiterErr <= '0';
            ChckSumErr <= '0';
            v6_tx_dvalsOut <= CLOSE_ALLDVAL; 
            
	 			case rx_arb_fsm_s is
	 			            
	 			when ch_info_c =>	 				
	 				if(rx_dval = '1' and ValidChNumb = true) then
                  tx_sof <= rx_ChInfo_sof;
                  tx_eof <= rx_ChInfo_eof;	 								 						 					
                  v6_tx_dvals <= v6_rx_chNbr; -- store dval value here
                  ChckSum <= v8_rx_data;
	 					rx_arb_fsm_s <= ch_data_c;			
	 				elsif (rx_dval = '1') then
                  -- Comm problem, no dval allowed
                  RxArbiterErr <= '1';                  
                  v6_tx_dvals <= CLOSE_ALLDVAL;   
                  rx_arb_fsm_s <=	ch_info_c;
               else
                  -- We are idle/wainting for new comm to start
                  v6_tx_dvals <= CLOSE_ALLDVAL;   
	 					rx_arb_fsm_s <=	ch_info_c;
	 				end if;
	 				
	 			when ch_data_c =>	 				
	 				if rx_dval = '1' then	 						 					
                  ChckSum <= std_logic_vector(unsigned(ChckSum) + unsigned(v8_rx_data));
                  v8_tx_data  <= v8_rx_data;-- store tx data value here
	 					rx_arb_fsm_s <= ch_ckSum_c;
	 				else
	 					rx_arb_fsm_s <= ch_data_c;	
	 				end if;
               
            when ch_ckSum_c =>      
               if rx_dval = '1' then
                  if (ChckSum = v8_rx_data) then                     
                     v6_tx_dvalsOut <= v6_tx_dvals; -- accept the stored dval
                  else
                     ChckSumErr <= '1';
                     v6_tx_dvals <= CLOSE_ALLDVAL;
                  end if;                  
                  rx_arb_fsm_s <=	ch_info_c;
               else
                  rx_arb_fsm_s <=	ch_ckSum_c;
               end if;
	 				
	 			when others =>
	 				rx_arb_fsm_s <= ch_info_c;
	 				
	 			end case;
	 		end if;
	 	end if;
	 end process;		
	
   -- Chanels outputs   
   CH1_TX_MOSI.SOF   <= tx_sof;
   CH1_TX_MOSI.EOF   <= tx_eof;
   CH1_TX_MOSI.DATA  <= v8_tx_data;
   CH1_TX_MOSI.DVAL  <= v6_tx_dvalsOut(0);
    
   CH2_TX_MOSI.SOF <= tx_sof;
   CH2_TX_MOSI.EOF <= tx_eof;
   CH2_TX_MOSI.DATA <= v8_tx_data;
   CH2_TX_MOSI.DVAL  <= v6_tx_dvalsOut(1);

   CH3_TX_MOSI.SOF <= tx_sof;
   CH3_TX_MOSI.EOF <= tx_eof;
   CH3_TX_MOSI.DATA <= v8_tx_data;
   CH3_TX_MOSI.DVAL  <= v6_tx_dvalsOut(2);

   CH4_TX_MOSI.SOF <= tx_sof;
   CH4_TX_MOSI.EOF <= tx_eof;
   CH4_TX_MOSI.DATA <= v8_tx_data;
   CH4_TX_MOSI.DVAL  <= v6_tx_dvalsOut(3);

   CH5_TX_MOSI.SOF <= tx_sof;
   CH5_TX_MOSI.EOF <= tx_eof;
   CH5_TX_MOSI.DATA <= v8_tx_data;    
   CH5_TX_MOSI.DVAL  <= v6_tx_dvalsOut(4);
   
   -----------------------------------------------------------------------------------   
   -- Special traitement for CH6: we have add, then byte0 and then byte1
   -- So if something goes wrong, we flush these 3 bytes.
   -----------------------------------------------------------------------------------
   ValidCh6Data: process(CLK)
    begin
	 	if rising_edge(CLK) then
         if sreset = '1' then	 				 			            
            ch6_fsm_s <= add;
            ch6_data.add <= x"00";
            ch6_data.byte1 <= x"00";
            ch6_data.byte0 <= x"00";
            FwD2ch <= '0';
         else
         
            -- defaul values
            FwD2ch <= '0';
            
            case ch6_fsm_s is
            
               when add =>
                  if (v6_tx_dvalsOut(5) = '1' and tx_sof = '1' and tx_eof = '0') then
                     ch6_data.add <= v8_tx_data;
                     if ChckSumErr = '1' then
                        ch6_fsm_s <= add;
                     else   
                        ch6_fsm_s <= byte1;
                     end if;   
                  end if;
                  
               when byte1 =>
                  if (v6_tx_dvalsOut(5) = '1' and tx_sof = '0' and tx_eof = '0') then
                     ch6_data.byte1 <= v8_tx_data;
                     if ChckSumErr = '1' then
                        ch6_fsm_s <= add;
                     else   
                        ch6_fsm_s <= byte0;
                     end if;                        
                  end if;
                  
               when byte0 =>
                  if (v6_tx_dvalsOut(5) = '1' and tx_sof = '0' and tx_eof = '1') then
                     ch6_data.byte0 <= v8_tx_data;                     
                     if ChckSumErr = '1' then
                        ch6_fsm_s <= add;
                     else   
                        ch6_fsm_s <= ForwardD2Ch;
                     end if;   
                  end if;
                  
               when ForwardD2Ch =>
                  FwD2ch <= '1';
                  ch6_fsm_s <= add;
                  
               when others =>
                  ch6_fsm_s <= add;
            end case;
               
         end if;                                 
      end if;
   end process ValidCh6Data; 
   
   -- Next process is to forward the validated data to CH6. It can do so
   -- even if we already starting the process of validating the next set of data
   ForwardCh6Data: process(CLK)
    begin
	 	if rising_edge(CLK) then
         if sreset = '1' then	
            CH6_TX_MOSI.DVAL <= '0'; 
            Fw_Fsm_s <= FwAdd;
         else
         
            -- default value
            CH6_TX_MOSI.DVAL <= '0';
            
            case Fw_Fsm_s is
               
               when FwAdd =>
                  if FwD2ch = '1' then
                     CH6_TX_MOSI.SOF <= '1';
                     CH6_TX_MOSI.EOF <= '0';
                     CH6_TX_MOSI.DATA <= ch6_data.add;
                     CH6_TX_MOSI.DVAL  <= '1';
                     Fw_Fsm_s <= FwByte1;
                  end if;
                  
               when FwByte1 =>
                  CH6_TX_MOSI.SOF <= '0';
                  CH6_TX_MOSI.EOF <= '0';
                  CH6_TX_MOSI.DATA <= ch6_data.byte1;
                  CH6_TX_MOSI.DVAL  <= '1';
                  Fw_Fsm_s <= FwByte0;
                  
               when FwByte0 =>
                  CH6_TX_MOSI.SOF <= '0';
                  CH6_TX_MOSI.EOF <= '1';
                  CH6_TX_MOSI.DATA <= ch6_data.byte0;
                  CH6_TX_MOSI.DVAL  <= '1';
                  Fw_Fsm_s <= FwAdd;
               
               when others =>
                  Fw_Fsm_s <= FwAdd;
                  
            end case;   
         end if;
      end if;
   end process ForwardCh6Data;      
   
   	 
	 -- RX_MISO.AFULL signal handling
	 -- rx_afull <= 	ch_1_afull when (v6_rx_chNbr = SLINK_CH1) else 
                  -- ch_2_afull when (v6_rx_chNbr = SLINK_CH2) else 
                  -- ch_3_afull when (v6_rx_chNbr = SLINK_CH3) else 
                  -- ch_4_afull when (v6_rx_chNbr = SLINK_CH4) else 
                  -- ch_5_afull when (v6_rx_chNbr = SLINK_CH5) else 
                  -- ch_6_afull when (v6_rx_chNbr = SLINK_CH6)      
                  -- else '0';                                
	 
	 ---------------------------------------------
	 -- Outputs
	 ---------------------------------------------	 	  	 
--	 RX_MISO.AFULL <= rx_afull;
	 RX_MISO.AFULL <= '0';
	 RX_MISO.BUSY  <= '0';
	 --Busy is not supported in this module
	 CH1_TX_MOSI.SUPPORT_BUSY <= '0';
	 CH2_TX_MOSI.SUPPORT_BUSY <= '0';
	 CH3_TX_MOSI.SUPPORT_BUSY <= '0';
	 CH4_TX_MOSI.SUPPORT_BUSY <= '0';
	 CH5_TX_MOSI.SUPPORT_BUSY <= '0';
	 CH6_TX_MOSI.SUPPORT_BUSY <= '0'; 
	 --
    RX_CHECKSUM_ERR <= ChckSumErr;
	 

end LL_RX_arbiter;
