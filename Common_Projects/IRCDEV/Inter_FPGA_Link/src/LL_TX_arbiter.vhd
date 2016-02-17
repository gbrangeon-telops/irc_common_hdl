-------------------------------------------------------------------------------
--
-- Title       : LL_TX_arbiter
-- Design      : Inter_FPGA_Link
-- Author      : Khalid Bensadek
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\Common_HDL\Common_Projects\IRCDEV\Inter_FPGA_Link\src\LL_TX_arbiter.vhd
-- Generated   : Wed Jan 13 09:20:14 2010
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
--{entity {LL_TX_arbiter} architecture {LL_TX_arbiter}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
library common_HDL;       
use common_HDL.Telops.all;
library work;
use work.SerialLink_Defines.all;

entity LL_TX_arbiter is
	port(
		CH1_RX_MOSI : in t_ll_mosi8;
		CH2_RX_MOSI : in t_ll_mosi8;
		CH3_RX_MOSI : in t_ll_mosi8;
		CH4_RX_MOSI : in t_ll_mosi8;
		CH5_RX_MOSI : in t_ll_mosi8;
		CH6_RX_MOSI : in t_ll_mosi8;
		TX_MISO : in t_ll_miso;
		CLK : in std_logic;
		ARESET : in std_logic;
		CH1_RX_MISO : out t_ll_miso;
		CH2_RX_MISO : out t_ll_miso;
		CH3_RX_MISO : out t_ll_miso;
		CH4_RX_MISO : out t_ll_miso;
		CH5_RX_MISO : out t_ll_miso;
		CH6_RX_MISO : out t_ll_miso;
		TX_MOSI : out t_ll_mosi8
		);
end LL_TX_arbiter;

--}} End of automatically maintained section

architecture LL_TX_arbiter_a of LL_TX_arbiter is

----------- FIFO threshold definition
constant v4_fifo_thresh : std_logic_vector(3 downto 0):=x"E"; -- 14


	component sync_reset
		port(
			ARESET : in std_logic;
			SRESET : out std_logic;
			CLK : in std_logic);
	end component;
	
	component Ch_RX_FIFO
	port(		
		CLK 		: in std_logic;
		SRESET 		: in std_logic;
		-- Write/RX side
		CH_RX_MOSI : in t_ll_mosi8;
		CH_RX_MISO : out t_ll_miso;
		WR_ERR		: out std_logic;
		PROG_FULL_THRESH : in std_logic_vector(3 downto 0);
		-- Read side
		AEMPTY : out std_logic; 
		RD_EN		: in std_logic;
		DOUT	: out std_logic_vector(9 downto 0);
		DVALID		: out std_logic		
		);
	end component;
		
	
	signal sreset : std_logic;
	-- FSM
	constant IDLE			   : std_logic_vector(4 downto 0):="00000";
   
   constant CH_1_CHINFO 	: std_logic_vector(4 downto 0):="00001";
	constant CH_1_DATA	   : std_logic_vector(4 downto 0):="00010";
   constant CH_1_CHECKSUM 	: std_logic_vector(4 downto 0):="00011";
	
   constant CH_2_CHINFO 	: std_logic_vector(4 downto 0):="00100";
	constant CH_2_DATA	   : std_logic_vector(4 downto 0):="00101";
   constant CH_2_CHECKSUM 	: std_logic_vector(4 downto 0):="00110";
   
	constant CH_3_CHINFO 	: std_logic_vector(4 downto 0):="00111";
	constant CH_3_DATA	   : std_logic_vector(4 downto 0):="01000";
   constant CH_3_CHECKSUM 	: std_logic_vector(4 downto 0):="01001";
   
   constant CH_4_CHINFO 	: std_logic_vector(4 downto 0):="01010";
	constant CH_4_DATA	   : std_logic_vector(4 downto 0):="01011";
   constant CH_4_CHECKSUM 	: std_logic_vector(4 downto 0):="01100";
   
   constant CH_5_CHINFO 	: std_logic_vector(4 downto 0):="01101";
	constant CH_5_DATA	   : std_logic_vector(4 downto 0):="01110";
   constant CH_5_CHECKSUM 	: std_logic_vector(4 downto 0):="01111";
   
   constant CH_6_CHINFO 	: std_logic_vector(4 downto 0):="10000";
	constant CH_6_DATA	   : std_logic_vector(4 downto 0):="10001";
   constant CH_6_CHECKSUM 	: std_logic_vector(4 downto 0):="10010";
		
	signal tx_arb_fsm_s : std_logic_vector(4 downto 0);
	--signal v3_TxMosi_MuxSel : std_logic_vector(2 downto 0);
	
	signal 	ch_1_req,
			ch_2_req,
			ch_3_req,             
			ch_4_req,
			ch_5_req,
			ch_6_req 	: std_logic;
	
	signal 	ch_1_rd,
			ch_2_rd,
			ch_3_rd,
			ch_4_rd,
			ch_5_rd,
			ch_6_rd 	: std_logic;		   	
			
	signal 	ch_1_sof, ch_1_eof,
			ch_2_sof, ch_2_eof,
			ch_3_sof, ch_3_eof,
			ch_4_sof, ch_4_eof,
			ch_5_sof, ch_5_eof,	   	
			ch_6_sof, ch_6_eof	: std_logic;
		
	signal 	tx_dval		: std_logic;	
			
	signal 	v10_ch1_data,
			v10_ch2_data,
	        v10_ch3_data,
	        v10_ch4_data,
	        v10_ch5_data,
	        v10_ch6_data  : std_logic_vector(9 downto 0);		
	
	signal 	v8_ch1_data,
			v8_ch2_data,
			v8_ch3_data,
			v8_ch4_data,
			v8_ch5_data,
			v8_ch6_data 	: std_logic_vector(7 downto 0);
			
			
	signal 	ch_1_aempty,
			ch_2_aempty,
			ch_3_aempty,
			ch_4_aempty,
			ch_5_aempty,
			ch_6_aempty : std_logic;
   
   signal v8_ch1_info,   
          v8_ch2_info,
          v8_ch3_info,
          v8_ch4_info,
          v8_ch5_info,
          v8_ch6_info : std_logic_vector(7 downto 0);
          
   signal tx_eof_tmp : std_logic;
   signal v8_CkSum, v8_CkSum_tmp, v8_ch_data_Tmp :  std_logic_vector(7 downto 0);
			
		       
begin      
	       
	-- enter your statements here --
	
	-- Sync Reset
	sync_RESET_TX :  sync_reset
	port map(
		ARESET 	=> ARESET,
		SRESET 	=> sreset,
		CLK 	=> CLK
		); 
	
	Ch1_Rxfifo: Ch_RX_FIFO
	port map(		
		CLK 				=> CLK,
		SRESET 				=> sreset,
		CH_RX_MOSI			=> CH1_RX_MOSI,
		CH_RX_MISO			=> CH1_RX_MISO,
		WR_ERR				=> open,
		PROG_FULL_THRESH	=> v4_fifo_thresh,
		AEMPTY				=> ch_1_aempty,
		RD_EN				=> ch_1_rd,
		DOUT				=> v10_ch1_data,
		DVALID				=> ch_1_req
		);	
		
	Ch2_Rxfifo: Ch_RX_FIFO
	port map(		
		CLK 				=> CLK,
		SRESET 				=> sreset,
		CH_RX_MOSI			=> CH2_RX_MOSI,
		CH_RX_MISO			=> CH2_RX_MISO,
		WR_ERR				=> open,
		PROG_FULL_THRESH	=> v4_fifo_thresh,
		AEMPTY				=> ch_2_aempty,
		RD_EN				=> ch_2_rd,
		DOUT				=> v10_ch2_data,
		DVALID				=> ch_2_req
		);
	
	Ch3_Rxfifo: Ch_RX_FIFO
	port map(		
		CLK 				=> CLK,
		SRESET 				=> sreset,
		CH_RX_MOSI			=> CH3_RX_MOSI,
		CH_RX_MISO			=> CH3_RX_MISO,
		WR_ERR				=> open,
		PROG_FULL_THRESH	=> v4_fifo_thresh,
		AEMPTY				=> ch_3_aempty,
		RD_EN				=> ch_3_rd,
		DOUT				=> v10_ch3_data,
		DVALID				=> ch_3_req
		);	
		
	Ch4_Rxfifo: Ch_RX_FIFO
	port map(		
		CLK 				=> CLK,
		SRESET 				=> sreset,
		CH_RX_MOSI			=> CH4_RX_MOSI,
		CH_RX_MISO			=> CH4_RX_MISO,
		WR_ERR				=> open,
		PROG_FULL_THRESH	=> v4_fifo_thresh,
		AEMPTY				=> open,
		RD_EN				=> ch_4_rd,
		DOUT				=> v10_ch4_data,
		DVALID				=> ch_4_req
		);	
		
	Ch5_Rxfifo: Ch_RX_FIFO
	port map(		
		CLK 				=> CLK,
		SRESET 				=> sreset,
		CH_RX_MOSI			=> CH5_RX_MOSI,
		CH_RX_MISO			=> CH5_RX_MISO,
		WR_ERR				=> open,
		PROG_FULL_THRESH	=> v4_fifo_thresh,
		AEMPTY				=> open,
		RD_EN				=> ch_5_rd,
		DOUT				=> v10_ch5_data,
		DVALID				=> ch_5_req
		);	
		
	Ch6_Rxfifo: Ch_RX_FIFO
	port map(		
		CLK 				=> CLK,
		SRESET 				=> sreset,
		CH_RX_MOSI			=> CH6_RX_MOSI,
		CH_RX_MISO			=> CH6_RX_MISO,
		WR_ERR				=> open,
		PROG_FULL_THRESH	=> v4_fifo_thresh,
		AEMPTY				=> open,
		RD_EN				=> ch_6_rd,
		DOUT				=> v10_ch6_data,
		DVALID				=> ch_6_req
		);								
	
	ch_1_sof	   <= v10_ch1_data(9);	
	ch_1_eof 	<= v10_ch1_data(8);
   v8_ch1_info <= ch_1_eof & ch_1_sof & SLINK_CH1;
	v8_ch1_data <= v10_ch1_data(7 downto 0);
	
	ch_2_sof	   <= v10_ch2_data(9);	           
	ch_2_eof 	<= v10_ch2_data(8);           
   v8_ch2_info <= ch_2_eof & ch_2_sof & SLINK_CH2;
	v8_ch2_data <= v10_ch2_data(7 downto 0);
	
	ch_3_sof	   <= v10_ch3_data(9);	           
	ch_3_eof 	<= v10_ch3_data(8);           
   v8_ch3_info <= ch_3_eof & ch_3_sof & SLINK_CH3;
	v8_ch3_data <= v10_ch3_data(7 downto 0);
	
	ch_4_sof	   <= v10_ch4_data(9);	           
	ch_4_eof 	<= v10_ch4_data(8);           
   v8_ch4_info <= ch_4_eof & ch_4_sof & SLINK_CH4;
	v8_ch4_data <= v10_ch4_data(7 downto 0);
	
	ch_5_sof	   <= v10_ch5_data(9);	           
	ch_5_eof 	<= v10_ch5_data(8);           
   v8_ch5_info <= ch_5_eof & ch_5_sof & SLINK_CH5;
	v8_ch5_data <= v10_ch5_data(7 downto 0);
	
	ch_6_sof	   <= v10_ch6_data(9);	           
	ch_6_eof 	<= v10_ch6_data(8);           
   v8_ch6_info <= ch_6_eof & ch_6_sof & SLINK_CH6;
	v8_ch6_data <= v10_ch6_data(7 downto 0);
					
	process(CLK)
	begin
		if rising_edge(CLK) then
			if sreset ='1' then
				tx_arb_fsm_s 	<= IDLE;				
			elsif TX_MISO.AFULL = '0' then	
					
				case tx_arb_fsm_s is
					
					when IDLE =>												
						if ch_1_req = '1' then								
                       tx_arb_fsm_s <= CH_1_CHINFO;
						elsif ch_2_req = '1' then								
							tx_arb_fsm_s <= CH_2_CHINFO;
						elsif ch_3_req = '1' then
							tx_arb_fsm_s <= CH_3_CHINFO;
						elsif ch_4_req = '1' then								
							tx_arb_fsm_s <= CH_4_CHINFO;
						elsif ch_5_req = '1' then								
							tx_arb_fsm_s <= CH_5_CHINFO;
						elsif ch_6_req = '1' then
							tx_arb_fsm_s <= CH_6_CHINFO;
						else
								tx_arb_fsm_s <= IDLE;		
						end if;
											
					when CH_1_CHINFO =>					    												
						tx_arb_fsm_s <= CH_1_DATA;						
																		
					when CH_1_DATA => 						
						tx_arb_fsm_s <= CH_1_CHECKSUM;		
                                 
               when CH_1_CHECKSUM =>                  
						if ch_1_req = '1' and tx_eof_tmp = '0' then								
							tx_arb_fsm_s <= CH_1_CHINFO;
						elsif tx_eof_tmp = '1' then								
							if ch_2_req = '1' then										
								tx_arb_fsm_s <= CH_2_CHINFO;
							elsif ch_3_req = '1' then
								tx_arb_fsm_s <= CH_3_CHINFO;
							elsif ch_4_req = '1' then								
								tx_arb_fsm_s <= CH_4_CHINFO;									
							elsif ch_5_req = '1' then								
								tx_arb_fsm_s <= CH_5_CHINFO;
							elsif ch_6_req = '1' then
								tx_arb_fsm_s <= CH_6_CHINFO;
                     elsif ch_1_req = '1' then
                        tx_arb_fsm_s <= CH_1_CHINFO;      
							else
								tx_arb_fsm_s <= IDLE;
							end if;
						else
							tx_arb_fsm_s <= IDLE;			
						end if;		
																
					when CH_2_CHINFO =>	
						tx_arb_fsm_s <= CH_2_DATA;						
																		
					when CH_2_DATA => 																							
						tx_arb_fsm_s <= CH_2_CHECKSUM;		
                                 
               when CH_2_CHECKSUM =>                  
						if ch_2_req = '1' and tx_eof_tmp = '0' then								
							tx_arb_fsm_s <= CH_2_CHINFO;
						elsif tx_eof_tmp = '1' then																
							if ch_3_req = '1' then
								tx_arb_fsm_s <= CH_3_CHINFO;
							elsif ch_4_req = '1' then								
								tx_arb_fsm_s <= CH_4_CHINFO;									
							elsif ch_5_req = '1' then								
								tx_arb_fsm_s <= CH_5_CHINFO;
							elsif ch_6_req = '1' then
								tx_arb_fsm_s <= CH_6_CHINFO;
                       elsif ch_1_req = '1' then										
								tx_arb_fsm_s <= CH_1_CHINFO;   
                     elsif ch_2_req = '1' then
                        tx_arb_fsm_s <= CH_2_CHINFO;   
							else
								tx_arb_fsm_s <= IDLE;
							end if;
						else
							tx_arb_fsm_s <= IDLE;			
						end if;		
						                  
               when CH_3_CHINFO =>							
							tx_arb_fsm_s <= CH_3_DATA;						
						
					when CH_3_DATA =>						
						tx_arb_fsm_s <= CH_3_CHECKSUM;		
                  
                  
               when CH_3_CHECKSUM =>                  
						if ch_3_req = '1' and tx_eof_tmp = '0' then								
							tx_arb_fsm_s <= CH_3_CHINFO;
						elsif tx_eof_tmp = '1' then																								
							if ch_4_req = '1' then								
								tx_arb_fsm_s <= CH_4_CHINFO;									
							elsif ch_5_req = '1' then								
								tx_arb_fsm_s <= CH_5_CHINFO;
							elsif ch_6_req = '1' then
                        tx_arb_fsm_s <= CH_6_CHINFO;
                     elsif ch_1_req = '1' then										
								tx_arb_fsm_s <= CH_1_CHINFO;
                     elsif ch_2_req = '1' then
								tx_arb_fsm_s <= CH_2_CHINFO;
                     elsif ch_3_req = '1' then
                        tx_arb_fsm_s <= CH_3_CHINFO;         
							else
								tx_arb_fsm_s <= IDLE;
							end if;
						else
							tx_arb_fsm_s <= IDLE;			
						end if;		
               
               when CH_4_CHINFO =>							
							tx_arb_fsm_s <= CH_4_DATA;						
						
					when CH_4_DATA =>						
						tx_arb_fsm_s <= CH_4_CHECKSUM;		
                  
                  
               when CH_4_CHECKSUM =>                  
						if ch_4_req = '1' and tx_eof_tmp = '0' then								
							tx_arb_fsm_s <= CH_4_CHINFO;
						elsif tx_eof_tmp = '1' then																								
							if ch_5_req = '1' then								
								tx_arb_fsm_s <= CH_5_CHINFO;																
							elsif ch_6_req = '1' then
                        tx_arb_fsm_s <= CH_6_CHINFO;
                     elsif ch_1_req = '1' then										
								tx_arb_fsm_s <= CH_1_CHINFO;
                     elsif ch_2_req = '1' then
								tx_arb_fsm_s <= CH_2_CHINFO;
                     elsif ch_3_req = '1' then
                        tx_arb_fsm_s <= CH_3_CHINFO;         
                     elsif ch_4_req = '1' then								
								tx_arb_fsm_s <= CH_4_CHINFO;   
							else
								tx_arb_fsm_s <= IDLE;
							end if;
						else
							tx_arb_fsm_s <= IDLE;			
						end if;      
               
               when CH_5_CHINFO =>							
							tx_arb_fsm_s <= CH_5_DATA;						
						
					when CH_5_DATA =>						
						tx_arb_fsm_s <= CH_5_CHECKSUM;		
                  
                  
               when CH_5_CHECKSUM =>                  
						if ch_5_req = '1' and tx_eof_tmp = '0' then								
							tx_arb_fsm_s <= CH_5_CHINFO;
						elsif tx_eof_tmp = '1' then																								
							if ch_6_req = '1' then								
								tx_arb_fsm_s <= CH_6_CHINFO;																							
                     elsif ch_1_req = '1' then										
								tx_arb_fsm_s <= CH_1_CHINFO;
                     elsif ch_2_req = '1' then
								tx_arb_fsm_s <= CH_2_CHINFO;
                     elsif ch_3_req = '1' then
                        tx_arb_fsm_s <= CH_3_CHINFO;         
                     elsif ch_4_req = '1' then								
								tx_arb_fsm_s <= CH_4_CHINFO;
                     elsif ch_5_req = '1' then
                        tx_arb_fsm_s <= CH_5_CHINFO;      
							else
								tx_arb_fsm_s <= IDLE;
							end if;
						else
							tx_arb_fsm_s <= IDLE;			
						end if;   

               when CH_6_CHINFO =>							
							tx_arb_fsm_s <= CH_6_DATA;						
						
					when CH_6_DATA =>						
						tx_arb_fsm_s <= CH_6_CHECKSUM;		
                  
                  
               when CH_6_CHECKSUM =>                  
						if ch_6_req = '1' and tx_eof_tmp = '0' then								
							tx_arb_fsm_s <= CH_6_CHINFO;
						elsif tx_eof_tmp = '1' then																								
							if ch_1_req = '1' then										
								tx_arb_fsm_s <= CH_1_CHINFO;
                     elsif ch_2_req = '1' then
								tx_arb_fsm_s <= CH_2_CHINFO;
                     elsif ch_3_req = '1' then
                        tx_arb_fsm_s <= CH_3_CHINFO;         
                     elsif ch_4_req = '1' then								
								tx_arb_fsm_s <= CH_4_CHINFO;
                     elsif ch_5_req = '1' then
                        tx_arb_fsm_s <= CH_5_CHINFO;      
                     elsif ch_6_req = '1' then
                        tx_arb_fsm_s <= CH_6_CHINFO;      
							else
								tx_arb_fsm_s <= IDLE;
							end if;
						else
							tx_arb_fsm_s <= IDLE;			
						end if;   
                  
					when others =>
						tx_arb_fsm_s <= IDLE;
					
				end case;
			end if;
		end if;
	end process;
	
-----------------------------------------------------------------------------------
-- process for final TX_MISO with corrected info about channel number,
--  SOF and EOF at the end of a frame.
-----------------------------------------------------------------------------------
    tx_mosi_mux: process(CLK)
 	begin
 		if rising_edge(CLK) then
 			if sreset ='1' then
 				TX_MOSI.DATA	<= (others=>'0'); 			    
 				TX_MOSI.DVAL	<= '0';
            v8_CkSum_tmp   <= x"00";   
            v8_CkSum       <= x"00";
            ch_1_rd <= '0';
				ch_2_rd <= '0';
				ch_3_rd <= '0';
				ch_4_rd <= '0';
				ch_5_rd <= '0';				
				ch_6_rd <= '0';				
            tx_eof_tmp <= '0';
            v8_ch_data_Tmp <= (others=>'0');
 			else
            -- default values
            TX_MOSI.DVAL	<= '0';
            ch_1_rd <= '0';
				ch_2_rd <= '0';
				ch_3_rd <= '0';
				ch_4_rd <= '0';
				ch_5_rd <= '0';				
				ch_6_rd <= '0';
            
            if TX_MISO.AFULL = '0' then
               case tx_arb_fsm_s is
 				 
                  when CH_1_CHINFO =>
                     TX_MOSI.DATA   <= v8_ch1_info;
                     v8_CkSum_tmp   <= v8_ch1_info;                                          
                     TX_MOSI.DVAL	<= '1';
                     v8_ch_data_Tmp <= v8_ch1_data; -- Store channel data into a tmp buffer
                     tx_eof_tmp     <= ch_1_eof; -- Store Channel EOF 
                     ch_1_rd        <= '1';   -- fetch next data from ch fifo
 						 						
                  when CH_1_DATA =>	
                     TX_MOSI.DATA   <= v8_ch_data_Tmp;                                          
                     TX_MOSI.DVAL	<= '1';
                     v8_CkSum       <= std_logic_vector(unsigned(v8_CkSum_tmp) + unsigned(v8_ch_data_Tmp));
                      						 						
                  when CH_1_CHECKSUM =>
                     TX_MOSI.DATA <= v8_CkSum;
                     TX_MOSI.DVAL	<= '1';
                     
                  when CH_2_CHINFO =>
                     TX_MOSI.DATA   <= v8_ch2_info;
                     v8_CkSum_tmp   <= v8_ch2_info;                     
                     TX_MOSI.DVAL	<= '1';
                     v8_ch_data_Tmp <= v8_ch2_data; -- Store channel data into a tmp buffer
                     tx_eof_tmp     <= ch_2_eof; -- Store Channel EOF 
                     ch_2_rd        <= '1';   -- fetch next data from ch fifo
 						 						
                  when CH_2_DATA =>	
                     TX_MOSI.DATA   <= v8_ch_data_Tmp;                                          
                     TX_MOSI.DVAL	<= '1';
                     v8_CkSum       <= std_logic_vector(unsigned(v8_CkSum_tmp) + unsigned(v8_ch_data_Tmp));
                      						 						
                  when CH_2_CHECKSUM =>
                     TX_MOSI.DATA   <= v8_CkSum;
                     TX_MOSI.DVAL	<= '1';

 						when CH_3_CHINFO =>
                     TX_MOSI.DATA   <= v8_ch3_info;
                     v8_CkSum_tmp   <= v8_ch3_info;                     
                     TX_MOSI.DVAL	<= '1';
                     v8_ch_data_Tmp <= v8_ch3_data; -- Store channel data into a tmp buffer
                     tx_eof_tmp     <= ch_3_eof; -- Store Channel EOF 
                     ch_3_rd        <= '1';   -- fetch next data from ch fifo
 						 						
                  when CH_3_DATA =>	
                     TX_MOSI.DATA   <= v8_ch_data_Tmp;                                          
                     TX_MOSI.DVAL	<= '1';
                     v8_CkSum       <= std_logic_vector(unsigned(v8_CkSum_tmp) + unsigned(v8_ch_data_Tmp));
                      						 						
                  when CH_3_CHECKSUM =>
                     TX_MOSI.DATA <= v8_CkSum;
                     TX_MOSI.DVAL	<= '1';

                  when CH_4_CHINFO =>
                     TX_MOSI.DATA   <= v8_ch4_info;
                     v8_CkSum_tmp   <= v8_ch4_info;                     
                     TX_MOSI.DVAL	<= '1';
                     v8_ch_data_Tmp <= v8_ch4_data; -- Store channel data into a tmp buffer
                     tx_eof_tmp     <= ch_4_eof; -- Store Channel EOF 
                     ch_4_rd        <= '1';   -- fetch next data from ch fifo
 						 						
                  when CH_4_DATA =>	
                     TX_MOSI.DATA   <= v8_ch_data_Tmp;                                          
                     TX_MOSI.DVAL	<= '1';
                     v8_CkSum       <= std_logic_vector(unsigned(v8_CkSum_tmp) + unsigned(v8_ch_data_Tmp));
                      						 						
                  when CH_4_CHECKSUM =>
                     TX_MOSI.DATA <= v8_CkSum;
                     TX_MOSI.DVAL	<= '1';

                  when CH_5_CHINFO =>
                     TX_MOSI.DATA   <= v8_ch5_info;
                     v8_CkSum_tmp   <= v8_ch5_info;                     
                     TX_MOSI.DVAL	<= '1';
                     v8_ch_data_Tmp <= v8_ch5_data; -- Store channel data into a tmp buffer
                     tx_eof_tmp     <= ch_5_eof; -- Store Channel EOF 
                     ch_5_rd        <= '1';   -- fetch next data from ch fifo
 						 						
                  when CH_5_DATA =>	
                     TX_MOSI.DATA   <= v8_ch_data_Tmp;                                          
                     TX_MOSI.DVAL	<= '1';
                     v8_CkSum       <= std_logic_vector(unsigned(v8_CkSum_tmp) + unsigned(v8_ch_data_Tmp));
                      						 						
                  when CH_5_CHECKSUM =>
                     TX_MOSI.DATA <= v8_CkSum;
                     TX_MOSI.DVAL	<= '1'; 

                  when CH_6_CHINFO =>
                     TX_MOSI.DATA   <= v8_ch6_info;
                     v8_CkSum_tmp   <= v8_ch6_info;                     
                     TX_MOSI.DVAL	<= '1';
                     v8_ch_data_Tmp <= v8_ch6_data; -- Store channel data into a tmp buffer
                     tx_eof_tmp     <= ch_6_eof; -- Store Channel EOF 
                     ch_6_rd        <= '1';   -- fetch next data from ch fifo
 						 						
                  when CH_6_DATA =>	
                     TX_MOSI.DATA   <= v8_ch_data_Tmp;                                          
                     TX_MOSI.DVAL	<= '1';
                     v8_CkSum       <= std_logic_vector(unsigned(v8_CkSum_tmp) + unsigned(v8_ch_data_Tmp));
                      						 						
                  when CH_6_CHECKSUM =>
                     TX_MOSI.DATA <= v8_CkSum;
                     TX_MOSI.DVAL	<= '1';
                     
                  when others => 
                     TX_MOSI.DATA	<= (others=>'0');
 			    						
               end case;
            end if;      
			end if;
		end if;						 		
 	end process tx_mosi_mux;

	-----------------------------
	-- Outputs assignations
	-----------------------------
	TX_MOSI.SUPPORT_BUSY <= '0'; 
   TX_MOSI.SOF 	<= '0';
 	TX_MOSI.EOF 	<= '0';
	--      		
end LL_TX_arbiter_a;
