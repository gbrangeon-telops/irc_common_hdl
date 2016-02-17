-------------------------------------------------------------------------------
--
-- Title       : LL_BERT_16
-- Design      : FIR180_shake_bake
-- Author      : telops
-- Company     : Telops Inc
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180\STARTUP\FIR180_shake_bake\src\LL_BERT_16.vhd
-- Generated   : Thu Dec  9 14:24:53 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library common_HDL;
use common_HDL.Telops.all;

entity LL_BERT_16 is 
	
	Generic( 
		datavector_length      : integer := 1_000_000; -- nombre de mots LL constituant le processus aleatoire (longueur du vecteur aleatoire)
		rand_seed			   : integer := 100
		);
	
	Port ( 
		CLK            : in std_logic;						
		ARESET         : in std_logic;
		
		RUN            : in std_logic;						-- à '1' lance les tests. Si indefiniment à '1', la meme trame LL aleatoire est envoyée continuellement dans le canal
		DONE           : out std_logic;						-- à '1' lorsque le système est idle. Sinon à '0';
		
		TX_MOSI        : out t_ll_mosi;						-- liens pour données entrant dans le canal à tester
		TX_MISO        : in  t_ll_miso;
		
		RX_MOSI        : in  t_ll_mosi;					    -- liens pour données sortant du canal à tester
		RX_MISO        : out t_ll_miso;
		
		DATA_SENT_NUM  : out  std_logic_vector(45 downto 0);  -- données totales envoyées (1 donnee = un mot LL_32)
		DATA_ERR_NUM   : out  std_logic_vector(45 downto 0);	-- données totales en erreur (1 donnee = un mot LL_32)
		ERR            : out std_logic						-- monte à '1' lorsqu'une erreur quelconque est détectée (données reçues non correctes ou toute autre erreur de fonctionnement) 
		); 
end LL_BERT_16;   

architecture RTL of LL_BERT_16 is
	
	component sync_reset
		port(
			ARESET                 : in std_logic;
			SRESET                 : out std_logic;
			CLK                    : in std_logic);
	end component;
	
	component LL_random_gen_16
		Generic( 
			datavector_length      : integer := 4096; -- taille du processus aleatoire
			rand_mean              : integer := 0;    -- moyenne du processus aleatoire
			rand_std_deviation     : integer := 10;   -- deviation standard du processus aleatoire
			rand_seed              : integer := 100   
			);
		port(
			CLK            : in std_logic;
			ARESET         : in std_logic;
			RUN            : in std_logic;
			TX_MISO        : in t_ll_miso;
			DATA_WIDTH_ERR : out std_logic;
			TX_MOSI        : out t_ll_mosi
			);
	end component;
	
	component LL_Comparator_16 
		Port ( 
			CLK         : in std_logic;
			ARESET      : in std_logic;
			RX0_MOSI    : in  t_ll_mosi;
			RX0_MISO    : out t_ll_miso;                   
			RX1_MOSI    : in  t_ll_mosi; 
			RX1_MISO    : out t_ll_miso;
			ERR         : out std_logic 
			);
	end component;
	
	component LocalLink_Fifo 
		generic(
			FifoSize		   : integer := 63;  
			Latency        : integer := 32;    
			ASYNC          : boolean := true);	
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
	
	component LL_Fanout16 
		generic(
			use_fifos   : boolean := false
			);
		port(
			RX_MOSI  : in  t_ll_mosi;
			RX_MISO  : out t_ll_miso;
			
			TX1_MOSI : out t_ll_mosi;
			TX1_MISO : in  t_ll_miso;
			
			TX2_MOSI : out t_ll_mosi;
			TX2_MISO : in  t_ll_miso;
			
			ARESET   : in  STD_LOGIC;
			CLK      : in  STD_LOGIC
			);
	end component;
	
	type ctler_sm_type  is (idle, wait_end);
	
	signal  ctler_sm            : ctler_sm_type;
	signal sreset               : std_logic;
	signal done_i               : std_logic;
	signal data_sent_num_i      : unsigned(DATA_SENT_NUM'LENGTH-1 downto 0); 
	signal data_err_num_i       : unsigned(DATA_ERR_NUM'LENGTH-1 downto 0);
	signal run_generator_i      : std_logic;
	signal comparator_err_i     : std_logic;
	signal data_width_err_i     : std_logic;
	
	signal fanout_rx_miso_i     : t_ll_miso;
	signal fanout_rx_mosi_i     : t_ll_mosi; 
	
	signal fifo_tx_mosi_i       : t_ll_mosi;
	signal fifo_tx_miso_i       : t_ll_miso; 
	
	signal fifo_rx_mosi_i       : t_ll_mosi;
	signal fifo_rx_miso_i       : t_ll_miso; 
	
	signal rx_miso_i            : t_ll_miso; 
	
	signal fifo_wr_err_i        : std_logic;
	
	signal err_i                : std_logic;
	
	
begin  
	--------------------------------------------------
	-- mapping sortie
	--------------------------------------------------    
	DONE <=  done_i;
   ERR  <= err_i; 
	RX_MISO <= rx_miso_i;
	DATA_SENT_NUM <= std_logic_vector(data_sent_num_i); 
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
	-- contrôleur                                    
	-------------------------------------------------
	U1 : process(CLK)
	begin 
		if rising_edge(CLK) then 
			if sreset = '1' then    
				done_i <= '0';
				ctler_sm <= idle; 
				data_sent_num_i <= (others => '0'); 
				data_err_num_i <= (others => '0');
				err_i <= '0';
			else                                   
				-- erreurs
				err_i  <= comparator_err_i or data_width_err_i or fifo_wr_err_i;
				
				
				-- on compte les données envoyées indefiniment
				if fanout_rx_mosi_i.dval = '1' and fanout_rx_miso_i.busy = '0' then 
					data_sent_num_i <= data_sent_num_i + 1;
					run_generator_i <= '0';
				end if; 
				
				-- on compte les erreurs indefiniment
				if comparator_err_i = '1' then 
					data_err_num_i <= data_err_num_i + 1;               
				end if;           
				
				-- fsm
				case ctler_sm is
					when idle =>
						done_i <= '1';
						if RUN = '1' then 
							run_generator_i <= '1';
							ctler_sm <= wait_end; 
						end if;
					
					when wait_end =>  
						done_i <= '0';                  
						if RX_MOSI.DVAL = '1' and RX_MOSI.EOF = '1' and rx_miso_i.busy = '0' then  -- fin de la trame
							ctler_sm <= idle; 
						end if;             
					
					when others => 
					
				end case;
			end if;
			
		end if; 
	end process;   
	
	----------------------------------------------------------------- 
	-- generateur d'une  trame LL aleatoire                                  
	-----------------------------------------------------------------  
	-- genere une trame de 16 bits de données aleatoire (selon la loi uniforme)
	U2: LL_random_gen_16
	Generic map( 
		datavector_length  => datavector_length, 
		rand_mean          => 0,
		rand_std_deviation => 9463,   -- deviation standard du processus aleatoire
		rand_seed          => rand_seed   
		)
	port map(
		CLK            	=> CLK,
		ARESET         	=> ARESET,
		RUN          	   => run_generator_i,
		TX_MISO        	=> fanout_rx_miso_i,      
		TX_MOSI        	=> fanout_rx_mosi_i,
		DATA_WIDTH_ERR 	=> data_width_err_i
		);   
	
	----------------------------------------------------------------- 
	-- fanout :                                 
	-----------------------------------------------------------------  
	--la trame aleatoir est stockée dans un fifo lors de sa sortie 
	U3 : LL_Fanout16
	generic map (
		use_fifos => true
		)
	port map(
		ARESET   => ARESET,
		CLK      => CLK,
		RX_MISO  => fanout_rx_miso_i,          -- entrée du fanout = sortie du generateur
		RX_MOSI  => fanout_rx_mosi_i,
		TX1_MISO => TX_MISO,                  -- sortie1 du fanout = sortie du bloc
		TX1_MOSI => TX_MOSI,
		TX2_MISO => fifo_rx_miso_i,           -- sortie2 du fanout = LL_fifo pour enregistrer les données envoyées en sortie 
		TX2_MOSI => fifo_rx_mosi_i
		); 
	
	----------------------------------------------------------------- 
	-- fifo :                               
	-----------------------------------------------------------------   
	-- stocke la trame, sinon, lève un busy qui bloque le generateur 
	U4 : LocalLink_Fifo
	generic map (
		ASYNC    => false,
		FifoSize => 512,
		Latency  => 10
		)
	port map(
		ARESET     => ARESET,
		CLK_RX     => CLK,
		CLK_TX     => CLK,
		EMPTY      => open,
		RX_LL_MISO => fifo_rx_miso_i,
		RX_LL_MOSI => fifo_rx_mosi_i,
		TX_LL_MISO => fifo_tx_miso_i,
		TX_LL_MOSI => fifo_tx_mosi_i,
		WR_ERR     => fifo_wr_err_i
		);           
	
	----------------------------------------------------------------- 
	-- comparateur:                               
	----------------------------------------------------------------- 
	-- Compare les flows de données synchro en entrée
	U6 : LL_Comparator_16
	port map(
		CLK          => CLK,
		ARESET       => ARESET,       
		RX0_MOSI     => fifo_tx_mosi_i,      
		RX0_MISO     => fifo_tx_miso_i,
		RX1_MOSI     => RX_MOSI,
		RX1_MISO     => rx_miso_i,
		ERR          => comparator_err_i
		); 
	
	
end RTL;

