---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2010
--
--  File: LL_BERT_32.vhd
--  Use:  
--  By: Edem Nofodjie
--
--  $Revision:
--  $Author:
--  $LastChangedDate:
--
---------------------------------------------------------------------------------------------------
-- description:  testeur de canal de type LL32. Envoie des données aleatoires (loi uniforme) dans le canal et teste les données
--               reçues pour verifier l'integrité du canal
---------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library common_HDL;
use common_HDL.Telops.all;

entity LL_BERT_32 is 
	
	Generic( 
		datavector_length      : integer := 1_000_000; -- nombre de mots LL constituant le processus aleatoire (longueur du vecteur aleatoire)
		rand_seed			   : integer := 100		  -- semence du generateur pseudo-aleatoire
		);
	
	Port ( 
		CLK            : in std_logic;						
		ARESET         : in std_logic;
		
		RUN            : in std_logic;						-- à '1' lance les tests. Si indefiniment à '1', la meme trame LL aleatoire est envoyée continuellement dans le canal
		DONE           : out std_logic;						-- à '1' lorsque le système est idle. Sinon à '0';
		
		TX_MOSI        : out t_ll_mosi32;						-- liens pour données entrant dans le canal à tester
		TX_MISO        : in  t_ll_miso;
		
		RX_MOSI        : in  t_ll_mosi32;					    -- liens pour données sortant du canal à tester
		RX_MISO        : out t_ll_miso;
		
		DATA_SENT_NUM  : out  std_logic_vector(45 downto 0);  -- données totales envoyées (1 donnee = un mot LL_32)
		DATA_ERR_NUM   : out  std_logic_vector(45 downto 0);	-- données totales en erreur (1 donnee = un mot LL_32)
		ERR            : out std_logic						-- monte à '1' lorsqu'une erreur quelconque est détectée (données reçues non correctes ou toute autre erreur de fonctionnement) 
		); 
end LL_BERT_32;   

architecture RTL of LL_BERT_32 is
	
	-- sync _reset
	component sync_reset
		port(
			ARESET                 : in std_logic;
			SRESET                 : out std_logic;
			CLK                    : in std_logic);
	end component;
	
	-- LL_BERT_16
	component LL_BERT_16 
		
		Generic( 
			datavector_length      : integer := 1_000_000;
			rand_seed			   : integer := 100
			);
		
		Port ( 
			CLK            : in std_logic;						
			ARESET         : in std_logic;
			
			RUN            : in std_logic;						
			DONE           : out std_logic;						
			
			TX_MOSI        : out t_ll_mosi;						
			TX_MISO        : in  t_ll_miso;
			
			RX_MOSI        : in  t_ll_mosi;					   
			RX_MISO        : out t_ll_miso;
			
			DATA_SENT_NUM  : out  std_logic_vector(45 downto 0);  
			DATA_ERR_NUM   : out  std_logic_vector(45 downto 0);	
			ERR            : out std_logic						
			); 
	end component; 
	
	--ll_16_merge_32
	component ll_16_merge_32
		port(
			CLK       : in  std_logic;
			RX0_MOSI  : in  t_ll_mosi;
			RX0_MISO  : out t_ll_miso;
			RX1_MOSI  : in  t_ll_mosi;
			RX1_MISO  : out t_ll_miso;
			TX_MOSI   : out t_ll_mosi32;
			TX_MISO   : in  t_ll_miso);
	end component;	
	
	-- LL_BusyBreak_16
	component LL_BusyBreak_16 
		port(
			RX_MOSI  : in  t_ll_mosi; 
			RX_MISO  : out t_ll_miso;			
			TX_MOSI  : out t_ll_mosi;
			TX_MISO  : in  t_ll_miso;			
			ARESET   : in  std_logic;
			CLK      : in  std_logic
			);
	end component;
	
	-- LL_32_split_2x16	
	component LL_32_split_2x16 
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
			ERR        	: out std_logic 
			);
	end component;
	
	signal sreset               : std_logic;
	signal done_i               : std_logic; 
	signal bb0_tx_mosi_i       : t_ll_mosi; 
	signal bb0_tx_miso_i       : t_ll_miso;
	signal chn0_tx_mosi_i       : t_ll_mosi; 
	signal chn0_tx_miso_i       : t_ll_miso; 
	signal chn0_rx_mosi_i       : t_ll_mosi; 
	signal chn0_rx_miso_i       : t_ll_miso;
	signal chn0_data_sent_num_i : std_logic_vector(DATA_SENT_NUM'LENGTH-1 downto 0); 
	signal chn0_data_err_num_i  : std_logic_vector(DATA_ERR_NUM'LENGTH-1 downto 0);
	signal chn0_err_i			: std_logic; 
	signal chn0_done_i			: std_logic; 
	
	signal bb1_tx_mosi_i       : t_ll_mosi; 
	signal bb1_tx_miso_i       : t_ll_miso;
	signal chn1_tx_mosi_i       : t_ll_mosi; 
	signal chn1_tx_miso_i       : t_ll_miso; 
	signal chn1_rx_mosi_i       : t_ll_mosi; 
	signal chn1_rx_miso_i       : t_ll_miso;
	signal chn1_data_err_num_i  : std_logic_vector(DATA_ERR_NUM'LENGTH-1 downto 0);	
	signal chn1_err_i			: std_logic;
	signal chn1_done_i			: std_logic;
	
	signal data_err_num_i       : std_logic_vector(DATA_ERR_NUM'LENGTH-1 downto 0);	
	signal merger_tx_mosi_i     : t_ll_mosi32; 
	signal merger_tx_miso_i     : t_ll_miso; 
	
	signal splitter_err_i       : std_logic;	
	signal err_i                : std_logic;
	
	
begin  
	--------------------------------------------------
	-- mapping sortie
	--------------------------------------------------    
	TX_MOSI <= merger_tx_mosi_i;     -- sortie du mergeur connectée à la sortie du module
	merger_tx_miso_i <= TX_MISO;     -- sortie du mergeur connectée à la sortie du module
	
	ERR  <= err_i;
	DONE <= done_i;
	DATA_SENT_NUM <= chn0_data_sent_num_i; 
	DATA_ERR_NUM <= std_logic_vector(data_err_num_i);
	
	--------------------------------------------------
	-- synchro reset 
	--------------------------------------------------   
	sreset_map : sync_reset
	port map(
		ARESET => ARESET,
		CLK    => CLK,
		SRESET => sreset
		); 
	
	------------------------------------------------- 
	-- process pour diverses choses                                  
	-------------------------------------------------
	U1 : process(CLK)
	begin 
		if rising_edge(CLK) then 
			if sreset = '1' then    
				err_i <= '0'; 
				data_err_num_i <= (others => '0'); 
				done_i <= '0';
			else	
				-- done
				done_i <= chn0_done_i and chn1_done_i;
				
				-- erreur 
				err_i <= chn0_err_i or chn1_err_i or splitter_err_i;
				
				-- le nombre de données en erreur sur le canal de 32bits est le max des erreurs sur les canaux de 16bits
				if chn0_data_err_num_i > chn1_data_err_num_i then
					data_err_num_i <= chn0_data_err_num_i;
				else
					data_err_num_i <= chn1_data_err_num_i;
				end if;
			end if;		
		end if; 
	end process;   
	
	----------------------------------------------------------------- 
	-- instantiation de deux LL_BERT_16                                 
	-----------------------------------------------------------------  
	-- teste le canal0 LL de 16 bits
	U2: LL_BERT_16
	Generic map( 
		datavector_length  => datavector_length, 
		rand_seed          => rand_seed   
		)
	port map(
		CLK            	=> CLK,
		ARESET         	=> ARESET,
		RUN            	=> RUN,
		DONE        	   => chn0_done_i,      
		TX_MOSI        	=> chn0_tx_mosi_i,
		TX_MISO 	         => chn0_tx_miso_i,
		RX_MOSI           => chn0_rx_mosi_i,
		RX_MISO           => chn0_rx_miso_i,
		DATA_SENT_NUM     => chn0_data_sent_num_i,
		DATA_ERR_NUM      => chn0_data_err_num_i,
		ERR               => chn0_err_i
		);   
	-- teste le canal1 LL de 16 bits
	U3: LL_BERT_16
	Generic map( 
		datavector_length  => datavector_length, 
		rand_seed          => 2*rand_seed    -- semence differente pour avoir deux lanes de 16 differents   
		)
	port map(
		CLK            	=> CLK,
		ARESET         	=> ARESET,
		RUN            	=> RUN,
		DONE        	   => chn1_done_i,      
		TX_MOSI        	=> chn1_tx_mosi_i,
		TX_MISO 	         => chn1_tx_miso_i,
		RX_MOSI           => chn1_rx_mosi_i,
		RX_MISO           => chn1_rx_miso_i,
		DATA_SENT_NUM     => open,		-- inutile car celui du canal0 suffit du fait de la synchro des canaux
		DATA_ERR_NUM      => chn1_data_err_num_i,
		ERR               => chn1_err_i
		); 
	
	--  connexion des sorties des testeurs à des busy_break pour timing
	U2_BB: LL_BusyBreak_16 
	port map(
		RX_MOSI  => chn0_tx_mosi_i,
		RX_MISO  => chn0_tx_miso_i,			
		TX_MOSI  => bb0_tx_mosi_i,
		TX_MISO  => bb0_tx_miso_i,			
		ARESET   => ARESET,
		CLK      => CLK
		);
	
	U3_BB: LL_BusyBreak_16 
	port map(
		RX_MOSI  => chn1_tx_mosi_i,
		RX_MISO  => chn1_tx_miso_i,			
		TX_MOSI  => bb1_tx_mosi_i,
		TX_MISO  => bb1_tx_miso_i,			
		ARESET   => ARESET,
		CLK      => CLK
		);
	
	--  connexion des sorties des busybreaks à ll_16_merge_32. Lmergeur est connecté à la sortie du module	
	U4: LL_16_merge_32
	port map(
		CLK       => CLK,
		RX0_MOSI  => bb0_tx_mosi_i,
		RX0_MISO  => bb0_tx_miso_i,
		RX1_MOSI  => bb1_tx_mosi_i,
		RX1_MISO  => bb1_tx_miso_i,
		TX_MOSI   => merger_tx_mosi_i,	     
		TX_MISO   => merger_tx_miso_i
		);
	
	-- LL_32_split_2x16	
	U5: LL_32_split_2x16 
	generic map(
		use_fifos => true)	        -- l'utilisation des fifos permet de desynchroniser les deux sorties du splitter
	port map( 
		ARESET      => ARESET,
		CLK         => CLK,	
		RX_MOSI     => RX_MOSI,	        -- l'entree du bloc est brannchée sur le splitter
		RX_MISO     => RX_MISO,		
		TX0_MOSI    => chn0_rx_mosi_i,  -- la sortie 0 est branchée sur l'entrée du tester du canal0
		TX0_MISO    => chn0_rx_miso_i,		
		TX1_MOSI    => chn1_rx_mosi_i,  -- la sortie 1 est branchée sur l'entrée du tester du canal1
		TX1_MISO    => chn1_rx_miso_i,		
		ERR        	=> splitter_err_i
		);
	
	
end RTL;

