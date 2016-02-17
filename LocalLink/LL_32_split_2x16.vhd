---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2010
--
--  File: LL_32_split_2x16.vhd
--  Use:  
--  By: Edem Nofodjie
--
--  $Revision:
--  $Author:
--  $LastChangedDate:
--
---------------------------------------------------------------------------------------------------
-- Description : 	sortir une paire de pixels entrants en deux pixels 
--	(pix0, pix1) =>	(pix0) et(pix1)
-- 10 dec 2010: implementation pour un nombre entrant de pixels valides multiple de 2
---------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL; 
use Common_HDL.Telops.all;


entity LL_32_split_2x16 is 
	generic(
		use_fifos : boolean := false);
	port( 
		ARESET      : in std_logic;
		CLK         : in std_logic;
		
		RX_MOSI     : in t_ll_mosi32;
		RX_MISO     : out t_ll_miso;
		
		TX0_MOSI    : out t_ll_mosi;
		TX0_MISO    : in t_ll_miso;
		
		TX1_MOSI    : out t_ll_mosi;
		TX1_MISO    : in t_ll_miso;
		
		ERR        	: out std_logic  -- monte à '1' lorsque DREM est diffrenet de '11'
		);
end LL_32_split_2x16;


architecture RTL of LL_32_split_2x16 is
	signal RX_BUSYi : std_logic; 
	signal fifo1_mosi : t_ll_mosi;
	signal fifo2_mosi : t_ll_mosi;
	signal fifo1_miso : t_ll_miso;
	signal fifo2_miso : t_ll_miso;  
	signal sreset     : std_logic;	
	
	component sync_reset
		port(
			ARESET                 : in std_logic;
			SRESET                 : out std_logic;
			CLK                    : in std_logic);
	end component;
	
	component LocalLink_Fifo
		generic(
			FifoSize	 : integer := 512;    
			Latency      : integer := 0;          
			ASYNC        : boolean := false);	
		port(
			RX_LL_MOSI  : in  t_ll_mosi;
			RX_LL_MISO  : out t_ll_miso;
			CLK_RX 		: in 	std_logic;
			FULL        : out std_logic;
			WR_ERR      : out std_logic;
			TX_LL_MOSI  : out t_ll_mosi;
			TX_LL_MISO  : in  t_ll_miso;
			CLK_TX 		: in 	std_logic;
			EMPTY       : out std_logic; 
			ARESET		: in std_logic
			);
	end component;
	
begin
	
	-- sreset
	sreset_map : sync_reset
	port map(
		ARESET => ARESET,
		CLK    => CLK,
		SRESET => sreset
		); 
	
	-- statut
	process(CLK)
	begin
		if rising_edge(CLK) then 
			if sreset = '1' then
				ERR <= '0'; 
			else
				if RX_MOSI.DREM /= "11" then  --pour l'instant on ne supporte qu'une paire de pixels vaildes
					ERR <= RX_MOSI.DVAL;
				else
					ERR <= '0';
				end if;
			end if;	
		end if;
	end process;
	
	-- lorsque pas de fifo	
	no_fifos : if not use_fifos generate            
		RX_MISO.AFULL <= TX0_MISO.AFULL or TX1_MISO.AFULL;
		RX_BUSYi      <= TX0_MISO.BUSY or TX1_MISO.BUSY;
		RX_MISO.BUSY  <= RX_BUSYi; 
		-- TX0 path
		TX0_MOSI.SUPPORT_BUSY <= '1';
		TX0_MOSI.SOF  <= RX_MOSI.SOF;
		TX0_MOSI.EOF  <= RX_MOSI.EOF;
		TX0_MOSI.DATA <= RX_MOSI.DATA(31 downto 16);
		TX0_MOSI.DVAL <= RX_MOSI.DVAL and not RX_BUSYi;
		-- TX1 path
		TX1_MOSI.SUPPORT_BUSY <= '1';
		TX1_MOSI.SOF  <= RX_MOSI.SOF;
		TX1_MOSI.EOF  <= RX_MOSI.EOF;
		TX1_MOSI.DATA <= RX_MOSI.DATA(15 downto 0);
		TX1_MOSI.DVAL <= RX_MOSI.DVAL and not RX_BUSYi;  
	end generate no_fifos;
	
	-- lorsque fifo
	fifos : if use_fifos generate
		
		RX_MISO.AFULL  <= fifo1_miso.AFULL or fifo2_miso.AFULL;
		RX_BUSYi       <= fifo1_miso.BUSY or fifo2_miso.BUSY;
		RX_MISO.BUSY   <= RX_BUSYi; 
		
		fifo1_mosi.SUPPORT_BUSY <= '1';
		fifo1_mosi.SOF  <= RX_MOSI.SOF;
		fifo1_mosi.EOF  <= RX_MOSI.EOF;
		fifo1_mosi.DATA <= RX_MOSI.DATA(31 downto 16);
		fifo1_mosi.DVAL <= RX_MOSI.DVAL and not RX_BUSYi;  
		
		fifo2_mosi.SUPPORT_BUSY <= '1';
		fifo2_mosi.SOF <=  RX_MOSI.SOF;
		fifo2_mosi.EOF <=  RX_MOSI.EOF;
		fifo2_mosi.DATA <= RX_MOSI.DATA(15 downto 0);		  
		fifo2_mosi.DVAL <= RX_MOSI.DVAL and not RX_BUSYi;
		
		
		fifo1 :  locallink_fifo
		generic map(
			FifoSize => 2,
			Latency => 0,
			ASYNC => false)
		port map(
			RX_LL_MOSI => fifo1_mosi,
			RX_LL_MISO => fifo1_miso,
			CLK_RX => CLK,
			FULL => open,
			WR_ERR => open,
			TX_LL_MOSI => TX0_MOSI,
			TX_LL_MISO => TX0_MISO,
			CLK_TX => CLK,
			EMPTY => open,
			ARESET => ARESET);    
		
		fifo2 :  locallink_fifo
		generic map(
			FifoSize => 2,
			Latency => 0,
			ASYNC => false)
		port map(
			RX_LL_MOSI => fifo2_mosi,
			RX_LL_MISO => fifo2_miso,
			CLK_RX => CLK,
			FULL => open,
			WR_ERR => open,
			TX_LL_MOSI => TX1_MOSI,
			TX_LL_MISO => TX1_MISO,
			CLK_TX => CLK,
			EMPTY => open,
			ARESET => ARESET);       
	end generate fifos;
	
	-- synopsys translate_off 
	assert_proc : process(ARESET)
	begin       
		if ARESET = '0' then
			assert (RX_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;          
		end if;
	end process;
	-- synopsys translate_on   
	
	
end RTL;
