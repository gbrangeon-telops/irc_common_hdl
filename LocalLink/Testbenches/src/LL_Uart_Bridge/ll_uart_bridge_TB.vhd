-------------------------------------------------------------------------------
--
-- Title       : Test Bench for ll_uart_bridge
-- Design      : Common_HDL
-- Author      : Telops Inc.
-- Company     : Telops Inc.
--
--  $Revision: 
--  $Author: 
--  $LastChangedDate:
-------------------------------------------------------------------------------
--
-- File        : $DSN\src\TestBench\ll_uart_bridge_TB.vhd
-- Generated   : 2009-10-28, 09:28
-- From        : $DSN\src\LocalLink\LL_Uart_Bridge.vhd
-- By          : Active-HDL Built-in Test Bench Generator ver. 1.2s
--
-------------------------------------------------------------------------------
--
-- Description : Test Bench for ll_uart_bridge_tb
--             : Get values from a file called RS232_REF.raw then feed them to 
--             : uart1. Then send them to uart2.  After, it send them to 2
--             : LL_randommiso8 and finally to a file called RS232_OUT.raw
--             : Use Comparefile.m
-------------------------------------------------------------------------------

library Common_HDL;
use Common_HDL.telops.all;
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library Common_HDL;
use Common_HDL.Telops.all;
use Common_HDL.telops_testing.all;

-- Add your library and packages declaration here ...

entity ll_uart_bridge_tb is
end ll_uart_bridge_tb;

architecture TB_ARCHITECTURE of ll_uart_bridge_tb is
   -- Component declaration of the tested unit
   component ll_uart_bridge
      generic(
         Fxtal : INTEGER := 3686400;
         Parity : BOOLEAN := false;
         Even : BOOLEAN := false;
         Baud1 : INTEGER := 115200;
         Baud2 : INTEGER := 6250000;
         NbStopBit : INTEGER := 2);
      port(
         -- Common Section
         CLK : in std_logic;
         ARESET : in std_logic;
         -- RS-232 Section
         RX : in std_logic;
         TX : out std_logic;
         RS232_ERR : out std_logic;
         --Local Link Section
         TX_MOSI : out t_ll_mosi8;
         TX_MISO : in t_ll_miso;
         RX_MOSI : in t_ll_mosi8;
         RX_MISO : out t_ll_miso );
   end component;
   
   -- Component declaration of the "ll_file_input_8(BIN)" unit defined in
   -- file: "./src/LocalLink/LL_file_input_8.vhd"
   component ll_file_input_8
      generic(
         Signed_Data : BOOLEAN := false
         );
      port(
         FILENAME : in STRING(1 to 255);
         TX_MOSI : out t_ll_mosi8;
         TX_MISO : in t_ll_miso;
         STALL : in std_logic;
         RESET : in std_logic;
         CLK : in std_logic);
   end component;
   for all: ll_file_input_8 use entity work.ll_file_input_8(BIN);
   
   -- Component declaration of the "ll_file_output_8(BIN)" unit defined in
   -- file: "./src/LocalLink/LL_file_output_8.vhd"
   component ll_file_output_8
      generic(
         Signed_Data : BOOLEAN := false
         );
      port(
         FILENAME : in STRING(1 to 255);
         RX_MOSI : in t_ll_mosi8;
         RX_MISO : out t_ll_miso;
         RESET : in std_logic;
         CLK : in std_logic);
   end component;
   for all: ll_file_output_8 use entity work.ll_file_output_8(BIN);
   
   -- Component declaration of the "ll_rx_stub8(rtl)" unit defined in
   -- file: "./../LocalLink/ll_rx_stub8.vhd"
   component ll_rx_stub8
      port(
         RX_LL_MOSI : in t_ll_mosi8;
         RX_LL_MISO : out t_ll_miso);
   end component;
   for all: ll_rx_stub8 use entity work.ll_rx_stub8(rtl);
   
   -- Component declaration of the "ll_tx_stub8(rtl)" unit defined in
   -- file: "./../LocalLink/ll_tx_stub8.vhd"
   component ll_tx_stub8
      port(
         TX_LL_MOSI : out t_ll_mosi8;
         TX_LL_MISO : in t_ll_miso);
   end component;
   for all: ll_tx_stub8 use entity work.ll_tx_stub8(rtl);
   
   -- Component declaration of the "ll_randommiso8(rtl)" unit defined in
   -- file: "./src/LocalLink/LL_RandomMiso8.vhd"
   component ll_randommiso8
      generic(
         random_seed : std_logic_vector(3 downto 0) := x"1");
      port(
         RX_MOSI : in t_ll_mosi8;
         RX_MISO : out t_ll_miso;
         TX_MOSI : out t_ll_mosi8;
         TX_MISO : in t_ll_miso;
         RANDOM : in std_logic;
         FALL : in std_logic;
         ARESET : in std_logic;
         CLK : in std_logic);
   end component;
   for all: ll_randommiso8 use entity work.ll_randommiso8(rtl);
   
   -- Stimulus signals - signals mapped to the input and inout ports of tested entity
   signal CLK : std_logic;
   signal ARESET : std_logic;
   
   signal END_SIM: BOOLEAN:=FALSE;
   signal ask_new_data : std_logic;
   signal input_data : std_logic_vector(7 downto 0);
   signal rx_i : std_logic;
   signal tx_i : std_logic;
   signal baud : std_logic;
   signal RS232_ERR1 : std_logic;
   signal RS232_ERR2 : std_logic;
   signal TX_MOSI1 : t_ll_mosi8;
   signal TX_MISO1 : t_ll_miso;
   signal RX_MOSI2 : t_ll_mosi8;
   signal RX_MISO2 : t_ll_miso;
   signal LL_FILE_TO_UART_TX_MOSI : t_ll_mosi8;
   signal LL_FILE_TO_UART_TX_MISO : t_ll_miso;
   signal LL_UART_TO_RAND1_TX_MOSI : t_ll_mosi8;
   signal LL_UART_TO_RAND1_TX_MISO : t_ll_miso;
   signal LL_RAND1_TO_RAND2_TX_MOSI : t_ll_mosi8;
   signal LL_RAND1_TO_RAND2_TX_MISO : t_ll_miso;
   signal LL_RAND2_TO_FILE_TX_MOSI : t_ll_mosi8;
   signal LL_RAND2_TO_FILE_TX_MISO : t_ll_miso;
   signal Stall : std_logic;
   signal filename_input : string (1 to 255);
   signal filename_output : string (1 to 255);
   signal random : std_logic;
   signal fall : std_logic;
   
   constant Fxtal : INTEGER := 100_000_000;
   constant Parity : BOOLEAN := false;
   constant Even : BOOLEAN := false;
   constant Baud1 : INTEGER := 115200;
   constant Baud2 : INTEGER := 6250000;
   constant NbStopBit : INTEGER := 2;
   constant random_seed1 : STD_LOGIC_VECTOR(3 downto 0) := x"1";
   constant random_seed2 : STD_LOGIC_VECTOR(3 downto 0) := x"2";
   
   --file RS232_REF : BINARY;  -- Test pattern generated by the TestBench
   --   file RS232_OUT : BINARY;  -- Output file to compare with RS232_REF 
   
begin
   
   -- Unit Under Test port map
   UUT1 : ll_uart_bridge
   generic map(
      Fxtal => Fxtal,
      Parity => Parity,
      Even => Even,
      Baud1 => Baud1,
      Baud2 => Baud2,
      NbStopBit => NbStopBit
      )
   port map (
      CLK => CLK,
      ARESET => ARESET,
      RX => rx_i,
      TX => tx_i,
      RS232_ERR => RS232_ERR1,
      TX_MOSI => TX_MOSI1,
      TX_MISO => TX_MISO1,
      RX_MOSI => LL_FILE_TO_UART_TX_MOSI,
      RX_MISO => LL_FILE_TO_UART_TX_MISO
      );
   
   -- Unit Under Test port map
   UUT2 : ll_uart_bridge
   generic map(
      Fxtal => Fxtal,
      Parity => Parity,
      Even => Even,
      Baud1 => Baud1,
      Baud2 => Baud2,
      NbStopBit => NbStopBit
      )
   port map (
      CLK => CLK,
      ARESET => ARESET,
      RX => tx_i,
      TX => rx_i,
      RS232_ERR => RS232_ERR2,
      TX_MOSI => LL_UART_TO_RAND1_TX_MOSI,
      TX_MISO => LL_UART_TO_RAND1_TX_MISO,
      RX_MOSI => RX_MOSI2,
      RX_MISO => RX_MISO2
      );
   
   
   FileInput : ll_file_input_8
   port map(
      FILENAME => filename_input,
      TX_MOSI => LL_FILE_TO_UART_TX_MOSI,
      TX_MISO => LL_FILE_TO_UART_TX_MISO,
      STALL => STALL,
      RESET => ARESET,
      CLK => CLK
      );
   
   FileOutput : ll_file_output_8
   port map(
      FILENAME => filename_output,
      RX_MOSI => LL_RAND2_TO_FILE_TX_MOSI,
      RX_MISO => LL_RAND2_TO_FILE_TX_MISO,
      RESET => ARESET,
      CLK => CLK
      );
   
   Ramdom1 : ll_randommiso8
   generic map( random_seed => random_seed1
      )
   port map(
      RX_MOSI => LL_UART_TO_RAND1_TX_MOSI,
      RX_MISO => LL_UART_TO_RAND1_TX_MISO,
      TX_MOSI => LL_RAND1_TO_RAND2_TX_MOSI,
      TX_MISO => LL_RAND1_TO_RAND2_TX_MISO,
      RANDOM => RANDOM,
      FALL => FALL,
      ARESET => ARESET,
      CLK => CLK
      );
   
   Random2 : ll_randommiso8
   generic map( random_seed => random_seed2
      )
   port map(
      RX_MOSI => LL_RAND1_TO_RAND2_TX_MOSI,
      RX_MISO => LL_RAND1_TO_RAND2_TX_MISO,
      TX_MOSI => LL_RAND2_TO_FILE_TX_MOSI,
      TX_MISO => LL_RAND2_TO_FILE_TX_MISO,
      RANDOM => RANDOM,
      FALL => FALL,
      ARESET => ARESET,
      CLK => CLK
      );
   
   Stub1 : ll_rx_stub8
   port map(
      RX_LL_MOSI => TX_MOSI1,
      RX_LL_MISO => TX_MISO1
      );
   
   Stub2 : ll_tx_stub8
   port map(
      TX_LL_MOSI => RX_MOSI2,
      TX_LL_MISO => RX_MISO2
      ); 
   
   -- Add your stimulus here ...
   filename_input(1 to 37) <= "$DSN\src\LL_Uart_Bridge\RS232_REF.raw";
   filename_output(1 to 37) <= "$DSN\src\LL_Uart_Bridge\RS232_OUT.raw";
   
   CLOCK_CLK : process
   begin
      --this process was generated based on formula: 0 0 ns, 1 12500 ps -r 25 ns
      --wait for <time to next event>; -- <current time>
      if END_SIM = FALSE then
         CLK <= '0';
         wait for 5000 ps; --0 fs
      else
         wait;
      end if;
      if END_SIM = FALSE then
         CLK <= '1';
         wait for 5000 ps; --12500 ps
      else
         wait;
      end if;
   end process;
   
   STIMILUS : process
   begin
      if END_SIM = FALSE then
         ARESET <= '1';                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
         STALL <= '1';
         random <= '0';
         fall <= '0';
         wait for 20ns;
         ARESET <= '0';
         --         wait for 20ns;
         wait for 1us;
         wait for 5ns;
         for i in 1 to 1024 loop
            --            Stall <= '1';
            --            wait for 10 ns;
            Stall <= '0';
            wait for 10 ns;
            Stall <= '1';
            wait for 5us;
         end loop;
         ARESET <= '1';  -- To close files correctly
         wait for 1us;
         END_SIM <= TRUE;
         wait for 10ns;
      else
         wait;
      end if;
   end process;
   
   -- This section is used to generate the reference file
   -- Comment Stimulus process before generate the reference file
   -- Uncomment to generate the file then comment it after
   
   --   RANDOM_GENERATOR : process
   --      -- Seed values for random generator 
   --      variable seed1, seed2: positive; 
   --      -- Random real-number value in range 0 to 1.0 
   --      variable rand:  real; 
   --      -- Random integer value in range 0..65535 
   --      variable int_rand: integer; 
   --      -- Random 15-bit stimulus 
   --      variable stim: std_logic_vector(7 downto 0); 
   --   begin 
   --      -- initialise seed1, seed2 if you want - 
   --      -- otherwise they're initialised to 1 by default 
   --      loop -- testbench stimulus loop? 
   --         UNIFORM(seed1, seed2, rand); 
   --         -- get a 12-bit random value... 
   --         -- 1. rescale to 0..(nearly)256, find integer part 
   --         int_rand := INTEGER(TRUNC(rand*256.0)); 
   --         -- 2. convert to std_logic_vector 
   --         wait until ask_new_data = '1';
   --         stim := std_logic_vector(to_unsigned(int_rand, stim'LENGTH));
   --         input_data <= stim;
   --         wait until ask_new_data = '0';
   --      end loop;
   --   end process;
   --   
   --   Generate_RS232_Pattern : process
   --      variable file_opened : boolean := false;
   --      file RS232_REF : BINARY;  -- Test pattern generated by the TestBench
   --   begin
   --      if end_sim = FALSE then
   --         if ARESET = '1' then         
   --            if file_opened then
   --               FILE_CLOSE(RS232_REF);
   --               file_opened := false;
   --            end if;
   --         else    
   --            FILE_OPEN(RS232_REF, "$DSN\src\LL_Uart_Bridge\RS232_REF.raw", WRITE_MODE);
   --            file_opened := true;
   --            for i in 1 to 1024 loop
   --               wait for 1us;
   --               ask_new_data <= '1';
   --               write(RS232_REF, input_data);
   --               wait for 1us;
   --               ask_new_data <= '0';
   --            end loop;
   --            FILE_CLOSE(RS232_REF);
   --            file_opened := false;
   --            end_sim <= TRUE;
   --            wait for 1us;
   --         end if;
   --      end if;
   --   end process;
   
   
   
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_uart_bridge of ll_uart_bridge_tb is
   for TB_ARCHITECTURE
      for all : ll_uart_bridge
         use entity work.ll_uart_bridge(rtl);
      end for;
   end for;
end TESTBENCH_FOR_ll_uart_bridge;

