
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

----------------------------------------------------------------------
-- Entity declaration.
----------------------------------------------------------------------

entity wb_uart_lite is 
   generic(
      CLK_FREQ_HZ : integer := 100_000_000;
      BAUDRATE    : integer := 115_200;
      BAUDRATE_SIM: integer := 6_250_000;
      USE_PARITY  : integer range 0 to 1 := 0;
      ODD_PARITY  : integer range 0 to 1 := 0;
      FAMILY      : string := "virtex4");   
   port (
      WB_MOSI        : in  t_wb_mosi32;
      WB_MISO        : out t_wb_miso32;   
      
      RX             : in  std_logic;
      TX             : out std_logic;
      
      CLK            : in  std_logic;
      ARESET         : in  std_logic
      );
   
end entity wb_uart_lite;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture RTL of wb_uart_lite is    
   
   component uartlite_core
      generic(
         C_DATA_BITS : INTEGER range 5 to 8 := 8;
         C_SPLB_CLK_FREQ_HZ : INTEGER := 100_000_000;
         C_BAUDRATE : INTEGER := 115_200;
         C_BAUDRATE_SIM : INTEGER := 6_250_000;
         C_USE_PARITY : INTEGER range 0 to 1 := 0;
         C_ODD_PARITY : INTEGER range 0 to 1 := 1;
         C_FAMILY : STRING := "virtex4");
      port(
         Clk : in std_logic;
         Reset : in std_logic;
         bus2ip_data : in std_logic_vector(0 to 7);
         bus2ip_rdce : in std_logic_vector(0 to 3);
         bus2ip_wrce : in std_logic_vector(0 to 3);
         ip2bus_rdack : out std_logic;
         ip2bus_wrack : out std_logic;
         ip2bus_error : out std_logic;
         SIn_DBus : out std_logic_vector(0 to 7);
         RX : in std_logic;
         TX : out std_logic;
         Interrupt : out std_logic);
   end component;
   
   signal bus2ip_rdce  : std_logic_vector(0 to 3);
   signal bus2ip_wrce  : std_logic_vector(0 to 3);
   signal ip2bus_rdack : std_logic;
   signal ip2bus_wrack : std_logic;  
   signal SIn_DBus     : std_logic_vector(0 to 7);
   signal ACKi         : std_logic;   
   signal ignore_bus_req : std_logic;
   
   signal SRESET        : std_logic;        
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;   
   
   signal add_ce : std_logic_vector(0 to 3);
   signal sub_add : std_logic_vector(1 downto 0);
   
begin                
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => SRESET, CLK => CLK);  
   
   sub_add <= WB_MOSI.ADR(3 downto 2); 
   
   add_ce <= "0001" when sub_add="11" else
   "0010" when sub_add="10" else
   "0100" when sub_add="01" else
   "1000" when sub_add="00" else
   "0000" ;   
   
   bus2ip_rdce <= add_ce when (WB_MOSI.STB='1' and WB_MOSI.WE='0' and ignore_bus_req='0') else "0000";   
   bus2ip_wrce <= add_ce when (WB_MOSI.STB='1' and WB_MOSI.WE='1' and ignore_bus_req='0') else "0000";   
   
   WB_MISO.DAT <= (31 downto 8 => '0') & SIn_DBus;      
   WB_MISO.ACK <= ACKi;
   ACKi <= ip2bus_rdack or ip2bus_wrack;  
   
   process(CLK)
   begin          
      if rising_edge(CLK) then   
         if ACKi = '1' then       
            ignore_bus_req <= '1';
         else                     
            ignore_bus_req <= '0';
         end if;
         if SRESET = '1' then  
            ignore_bus_req <= '0';
         end if;
      end if;
   end process;
   
   CORE : uartlite_core
   generic map(
      C_DATA_BITS => 8,
      C_SPLB_CLK_FREQ_HZ => CLK_FREQ_HZ,
      C_BAUDRATE => BAUDRATE, 
      C_BAUDRATE_SIM => BAUDRATE_SIM,
      C_USE_PARITY => USE_PARITY,
      C_ODD_PARITY => ODD_PARITY,
      C_FAMILY => FAMILY
      )
   port map(
      Clk => CLK,
      Reset => SRESET,
      bus2ip_data => WB_MOSI.DAT(7 downto 0),
      bus2ip_rdce => bus2ip_rdce,
      bus2ip_wrce => bus2ip_wrce,
      ip2bus_rdack => ip2bus_rdack,
      ip2bus_wrack => ip2bus_wrack,
      ip2bus_error => open,
      SIn_DBus => SIn_DBus,
      RX => RX,
      TX => TX,
      Interrupt => open
      );   
   
end architecture RTL;

