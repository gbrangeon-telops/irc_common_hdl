--------------------------------------------------------------------
--          *********   ******   *        ******   *****   *****    *
--             *       *        *        *    *   *   *   *         *
--            *       ******   *        *    *   *****   *****      *
--           *       *        *        *    *   *           *       *
--          *       ******   ******   ******   *       *****        *
--------------------------------------------------------------------
-- Copyright (c) Telops Inc. 2009
--------------------------------------------------------------------
-- Project: IRCDEV
-- 
-- Board : ROIC
-- 
-- Description: UCF file for tb
-- The errors are latched on the user LED as follow:
-- LED0 : TX Overflow             
-- LED1 : RX Overflow
-- LED2 : RX error
-- LED3 : Transmission error
-- LED4 to LED7 : Errors count
-- Use reset to clear error status on LED and start the process over.
-- 
-- Note: design can run on 50 MHZ TX/RX clock with a 20 cm cables for
--		SDA and SCLK and with no errors. This results in rate up to 
--		5 MB/s
--
-- Revisions: 1.00 a -- Initial version  
--------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
library common_HDL;
use common_HDL.Telops.all;

library UNISIM;
 use UNISIM.vcomponents.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_TB is
    Port ( CLK_50M : in  STD_LOGIC;
           ARESET : in  STD_LOGIC;
           SERIAL_RX : in  STD_LOGIC;
           CLK_RX : in  STD_LOGIC;
           SERIAL_TX : out  STD_LOGIC;
           CLK_TX : out  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR (7 downto 0));
end Top_TB;

architecture Behavioral of Top_TB is
 
component clkgen
   port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLKDV_OUT       : out   std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic; 
          CLK2X_OUT       : out   std_logic; 
          LOCKED_OUT      : out   std_logic);
   end component;
   
component SyncSerialLink_TX
  port(
       ARESET : in STD_LOGIC;
       CLK : in STD_LOGIC;
       CLK_20MHz : in STD_LOGIC;
       RX_MOSI : in t_ll_mosi8;
       CLK_20MHz_TX : out STD_LOGIC;
       SERIAL_TX : out STD_LOGIC;
       TX_OVFLW : out STD_LOGIC;
       RX_MISO : out t_ll_miso
  );
end component;   

component SyncSerialLink_RX
  port(
       ARESET : in STD_LOGIC;
       CLK : in STD_LOGIC;
       CLK_20MHz_RX : in STD_LOGIC;
       SERIAL_RX : in STD_LOGIC;
       TX_MISO : in t_ll_miso;
       RX_ERR : out STD_LOGIC;
       RX_OVFLW : out STD_LOGIC;
       TX_MOSI : out t_ll_mosi8
  );
end component;

component LL_random_gen_8
   Generic( 
      datavector_length      : integer := 4096; -- taille du processus aleatoire
      rand_mean              : integer := 0;    -- moyenne du processus aleatoire
      rand_std_deviation     : integer := 10;   -- deviation standard du processus aleatoire
      rand_seed              : integer := 100   
      );
   port(
      CLK            : in std_logic;
      ARESET         : in std_logic;
      START          : in std_logic;
      TX_MISO        : in t_ll_miso;
      DATA_WIDTH_ERR : out std_logic;
      TX_MOSI        : out t_ll_mosi8
      );
end component;

component LL_sync_flow is
   port(           
      
      RX0_DVAL    : in std_logic;
      RX0_BUSY    : out std_logic;
      RX0_AFULL   : out std_logic;
      
      RX1_DVAL    : in std_logic;
      RX1_BUSY    : out std_logic;
      RX1_AFULL   : out std_logic;   
      
      SYNC_BUSY   : in std_logic;      
      SYNC_DVAL   : out std_logic               
      
      );
end component;

component Error_Check 
    Port ( CLK : in  STD_LOGIC;
    	   ARESET	: in  STD_LOGIC;	
    	   TX_OVFLW : in  STD_LOGIC;
           RX_OVFLW : in  STD_LOGIC;
           RX_ERR : in  STD_LOGIC;
           SYNC_DVAL : in  STD_LOGIC;
           RX0_MOSI : in  t_ll_mosi8;
           RX1_MOSI : in  t_ll_mosi8;
           LED : out  STD_LOGIC_VECTOR (7 downto 0));
end component;
   
signal clk_20M_s,
		clk_100M_s,		
		aresetN_s		: std_logic;
		
signal tx_overflow_s,
		rx_overflow_s,
		rx_err_s 	: std_logic;		

signal randgen0_tx_mosi_s,
		randgen1_tx_mosi_s,
		sslrx_tx_mosi_s : t_ll_mosi8;
						
signal ssltx_rx_miso,
		sslrx_tx_miso_s,
		randgen1_tx_miso_s 	: t_ll_miso;
		
signal sync_dval_s,
		randgen_start_s,
		CLK_TX_s,
		CLK_TXn_s,
		SERIAL_TX_s,
		SERIAL_RX_s : std_logic;		

attribute keep : string;
attribute keep of sync_dval_s: signal is "true"; 		         

begin

--LED(0) <= '1';

sslrx_tx_miso_s.afull <= '0';

U0_clkgen : clkgen
	port map( CLKIN_IN     => CLK_50M,
    	RST_IN             => '0',
    	CLKDV_OUT          => clk_20M_s,
    	CLKIN_IBUFG_OUT    => open,
    	CLK0_OUT           => open,
    	CLK2X_OUT          => clk_100M_s,
    	LOCKED_OUT         => open
    	);
    	
    	--clk_20M_s <= clk_100M_s;
    	
U0_LLRandGen: LL_random_gen_8
	Generic map( 
	   datavector_length      => 4096, -- taille du processus aleatoire
	   rand_mean              => 0,    -- moyenne du processus aleatoire
	   rand_std_deviation     => 10,   -- deviation standard du processus aleatoire
	   rand_seed              => 100   
	   )
	port map(
	   CLK            	=> clk_100M_s,
	   ARESET         	=> ARESET,
	   START          	=> randgen_start_s,
	   TX_MISO        	=> ssltx_rx_miso,
	   DATA_WIDTH_ERR 	=> open,
	   TX_MOSI        	=> randgen0_tx_mosi_s
	   );   
	   
U0_SSL_TX: SyncSerialLink_TX
	port map(
       	ARESET			=> ARESET,
       	CLK				=> clk_100M_s,
       	CLK_20MHz		=> clk_20M_s,	
       	RX_MOSI			=> randgen0_tx_mosi_s,
       	CLK_20MHz_TX	=> CLK_TX_s,
       	SERIAL_TX		=> SERIAL_TX_s,
       	TX_OVFLW		=> tx_overflow_s,
       	RX_MISO			=> ssltx_rx_miso
  );

-- 180 deg phase clock out to align TX CLK rising edge to centre of TX data 
CLK_TXn_s <= not CLK_TX_s; 
U0_ClokoutODD: OFDDRRSE
	port map (
    	Q   => CLK_TX,
    	C0  => CLK_TX_s,
    	C1  => CLK_TXn_s,
    	CE  => '1',
    	D0  => '0',
    	D1  => '1',
    	R   => '0',
    	S   => '0'
    	);             
  
  -- IOB_DFF
  process(clk_20M_s)
  begin
  	if rising_edge(clk_20M_s) then
  		SERIAL_TX <= SERIAL_TX_s;
  	end if;
  end process;		 
  

  -- IOB_DFF
  process(CLK_RX)
  begin
  	if rising_edge(CLK_RX) then
  		SERIAL_RX_s <= SERIAL_RX;
  	end if;
  end process;		 
  
  
U0_SSL_RX: SyncSerialLink_RX 
  port map(
       ARESET			=> ARESET,
       CLK				=> clk_100M_s,
       CLK_20MHz_RX		=> CLK_RX,
       SERIAL_RX		=> SERIAL_RX_s,
       TX_MISO			=> sslrx_tx_miso_s,
       RX_ERR			=> rx_err_s,
       RX_OVFLW			=> rx_overflow_s,
       TX_MOSI			=> sslrx_tx_mosi_s
  ); 
	   
U2_LLRandGen: LL_random_gen_8
	Generic map( 
	   datavector_length      => 4096, -- taille du processus aleatoire
	   rand_mean              => 0,    -- moyenne du processus aleatoire
	   rand_std_deviation     => 10,   -- deviation standard du processus aleatoire
	   rand_seed              => 100   
	   )
	port map(
	   CLK            	=> clk_100M_s,
	   ARESET         	=> ARESET,
	   START          	=> randgen_start_s,
	   TX_MISO        	=> randgen1_tx_miso_s,
	   DATA_WIDTH_ERR 	=> open,
	   TX_MOSI        	=> randgen1_tx_mosi_s
	   ); 
	   
U0_LLSyncFlow: LL_sync_flow
   port map (           
      
      RX0_DVAL    => randgen1_tx_mosi_s.dval,
      RX0_BUSY    => randgen1_tx_miso_s.busy,
      RX0_AFULL   => randgen1_tx_miso_s.afull,
                  
      RX1_DVAL    => sslrx_tx_mosi_s.dval,
      RX1_BUSY    => sslrx_tx_miso_s.busy,
      RX1_AFULL   => open,--sslrx_tx_miso_s.afull,   
                  
      SYNC_BUSY   => '0',     
      SYNC_DVAL   => sync_dval_s      
      );
      
U0_ErrorCheck: Error_Check
    Port map(
    	CLK 		=> clk_100M_s,
    	ARESET      => ARESET,
    	TX_OVFLW 	=> tx_overflow_s,
        RX_OVFLW	=> rx_overflow_s,
        RX_ERR		=> rx_err_s,
        SYNC_DVAL	=> sync_dval_s, 
        RX0_MOSI	=> randgen1_tx_mosi_s,
        RX1_MOSI	=> sslrx_tx_mosi_s,
        LED			=> LED
        );
    
U0_SRL16Delay: SRL16 
 	-- synthesis translate_off
    generic map(
    		INIT => hex_value)
   -- synthesis translate_on             
	port map (Q => randgen_start_s,
             A0 => '1',
             A1 => '1',
             A2 => '1',
             A3 => '1',
             CLK => clk_100M_s,
             D => aresetN_s);         
        
 aresetN_s <= not ARESET;    	     	   

end Behavioral;

