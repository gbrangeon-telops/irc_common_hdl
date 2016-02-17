---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005-2007
--
--  File: spi_master.vhd
--  Use: SSI / SPI serial interface master controler
--  Author: Edem Nofodjie
--
--  $Revision: 1959 $
--  $Author: rd\obourgois $
--  $LastChangedDate$
--
--  References:
--    SPI and Microwire protocols
--
--  Notes:
--    Hardwired to 24 bit transfers, SPI_NBITS can limit this and only send MSBs
--    Future improvements: generic clock division, better bit width scalling, spi_slave
--    module for future applications 
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library common_hdl;
use common_hdl.telops.all;

entity new_spi_master is
   generic(
      SLV_NUM             : natural := 3;
      MAXDLEN			     : natural := 32;
      SPICLK_DELAY_IN_CLK : natural := 4;
      SCLK_PROVIDED	     : boolean := true);
   port(
      CLK        		  : in    std_logic; 		--clk frequency higher than  sclk frequency
      SCLK		        : in    std_logic; 
      RESET     		  : in    std_logic;                       -- async reset
      DIN_WORD    	  : in    std_logic_vector(MAXDLEN-1 downto 0);
      STROBE			  : in    std_logic;                       -- Strobe = 1 to initiate SPI transfer
      NBITS  		     : in    std_logic_vector(log2(MAXDLEN) downto 0);    -- nb bits total to transfer  SPI_DIN_WORD(NBITS-1 downto 0)
      SLAVE_SELECT	  : in    std_logic_vector(SLV_NUM-1 downto 0);
      
      DONE    	        : out   std_logic;                       -- goes 1 when transfer complete
      DOUT_WORD   	  : out   std_logic_vector(MAXDLEN-1 downto 0); 
      
      SPI_SCLK    	  : out   std_logic;
      SPI_MOSI   		  : out   std_logic;
      SPI_SLVSYNC_N    : out   std_logic_vector(SLV_NUM-1 downto 0):=(others =>'1'));
end entity new_spi_master;

architecture rtl of new_spi_master is
   
   type fsm_state is 
   (rst, idle, send, pause);
   
   -- signal declarations
   signal din_word_buf       : std_logic_vector(MAXDLEN-1 downto 0);
   signal spi_ctrl_fsm		  : fsm_state;
   signal slave_select_buf   : std_logic_vector(SLV_NUM-1 downto 0);
   signal transfert_data     : std_logic :='0';
   signal transfert_done     : std_logic :='1';
   signal transfert_done_last: std_logic :='1';
   signal transfert_data_last: std_logic :='0'; 
   signal NBITS_buf       	  : unsigned(log2(MAXDLEN) downto 0);
   signal SCLK_last          : std_logic;
   --signal bit_cnt        	 : integer range 0 to MAXDLEN-1;
   
begin
   
   --SPI_SCLK	 <= spiclk_sr(SPICLK_DELAY_IN_CLK-1);
   
   
   crtl_sm : process (CLK)
   begin
      if rising_edge(clk)  then  
         if RESET ='1'  then
            transfert_data  <= '0'; 
            spi_ctrl_fsm    <= rst;
            din_word_buf    <= (others =>'0');    
            slave_select_buf<= (others =>'0');
            DONE <='0';
         else 
            case spi_ctrl_fsm is 
               
               when rst =>	  
                  spi_ctrl_fsm   <= idle;	
               when idle =>
                  transfert_data  <= '0'; 
                  din_word_buf    <= (others =>'0');    
                  slave_select_buf<= (others =>'0');
                  DONE <='1';
                  if STROBE ='1' and    transfert_done_last='1' and  transfert_done='1'  then    --on est certain que le transfert_done est stable à '1' 
                     din_word_buf    <= DIN_WORD;    
                     NBITS_buf  		<= unsigned(NBITS);  		 
                     slave_select_buf<= SLAVE_SELECT;
                     spi_ctrl_fsm	<= send;
                     DONE <='0';
                  end if;  
               when send =>
                  transfert_data    <= '1';
                  --if transfert_done ='0' then
                  --                     transfert_data <='0';
                  --                     spi_ctrl_fsm   <= pause;
                  --                  end if;	                  
                  --    when pause =>
                  if transfert_done_last ='0' and transfert_done ='1' then     -- montée de transfert_done
                     spi_ctrl_fsm   <= idle; 
                     transfert_data <='0';
                  end if;	  
               when others =>
            end case;
         end if;
      end if;
   end  process ;
   
   
   --  transfert process
   transfert_proc : process(CLK)
      variable bit_cnt : unsigned(log2(MAXDLEN) downto 0);
   begin
      if rising_edge(CLK) then
         if RESET ='1' then 
            SCLK_last <='0';
			SPI_MOSI <= '0'; -- ENO : 30 oct 2009: indispensable pour ISC0207
			SPI_SLVSYNC_N <= (others  =>'1');-- ENO : 30 oct 2009: indispensable pour ISC0207 
         else
            SCLK_last <= SCLK ;
            if SCLK_last = '1' and SCLK ='0'  then 
               transfert_data_last <= 	transfert_data; 
               transfert_done_last <= transfert_done;
               --transfert_done <='0';
               if transfert_data_last ='0' and transfert_data ='1'   then  
                  bit_cnt := NBITS_buf;
               end if;
               if 	transfert_data ='1' then 
                  if 	bit_cnt > 0 then 
                     bit_cnt:= bit_cnt-1;
                     transfert_done <='0';
                     SPI_MOSI      <= din_word_buf(to_integer(bit_cnt));
                     SPI_SLVSYNC_N <= not slave_select_buf;  -- logique inverse 
                     DOUT_WORD     <= (others =>'0');
                     DOUT_WORD(to_integer(NBITS_buf)-1 downto 0) <= din_word_buf(to_integer(NBITS_buf)-1 downto 0);
                  else 
                     SPI_SLVSYNC_N <= (others  =>'1'); 
                     transfert_done <='1';
                  end if;
               else 
                  SPI_SLVSYNC_N <= (others  =>'1'); 
                  SPI_MOSI <= '0';	-- ENO : 30 oct 2009: indispensable pour ISC0207
               end if;
            end if;
         end if;
      end if;
   end  process; 
   
   -- The  SPI Clock is delayed to allow a setup time for the 
   -- other signals
   SPI_CLK_GEN : process(CLK)
      variable spiclk_sr	: std_logic_vector(SPICLK_DELAY_IN_CLK-1 downto 0);
   begin
      if rising_edge(CLK) then
         if Reset = '1' then
            spiclk_sr	:= (others => '0');
         else 
            SPI_SCLK	 <= spiclk_sr(SPICLK_DELAY_IN_CLK-1);
            spiclk_sr(SPICLK_DELAY_IN_CLK-1 downto 1):= spiclk_sr(SPICLK_DELAY_IN_CLK-2 downto 0);				
            spiclk_sr(0)	:= SCLK ;
         end if;
      end if;	
   end process;
   
   
   
   
end rtl;
