library ieee;
library common_hdl;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use common_hdl.telops.all;

	-- Add your library and packages declaration here ...

entity ll_aoi_add_gen_tb is
	-- Generic declarations of the tested unit
		generic(
		XLEN : NATURAL := 16;
		ALEN : NATURAL := 16 );
end ll_aoi_add_gen_tb;

architecture TB_ARCHITECTURE of ll_aoi_add_gen_tb is
	-- Component declaration of the tested unit
	component ll_aoi_add_gen
		generic(
		XLEN : NATURAL := 9;
		ALEN : NATURAL := 21 );
	port(
		CFG_START_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
		CFG_END_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
		CFG_WIDTH : in STD_LOGIC_VECTOR(XLEN-1 downto 0);
		CFG_SKIP : in STD_LOGIC_VECTOR(XLEN-1 downto 0);
		CFG_CONTROL : in STD_LOGIC_VECTOR(2 downto 0);
		CFG_DONE : out STD_LOGIC;
		CFG_CONFIG : in STD_LOGIC_VECTOR(4 downto 0);
		ADD_LL_SOF : out STD_LOGIC;
		ADD_LL_EOF : out STD_LOGIC;
		ADD_LL_DATA : out STD_LOGIC_VECTOR(ALEN-1 downto 0);
		ADD_LL_DVAL : out STD_LOGIC;
		ADD_LL_SUPPORT_BUSY : out STD_LOGIC;
		ADD_LL_BUSY : in STD_LOGIC;
		ADD_LL_AFULL : in STD_LOGIC;
		IDLE : in STD_LOGIC;
		ERROR : out STD_LOGIC;
		ARESET : in STD_LOGIC;
		CLK_DATA : in STD_LOGIC;
		CLK_CTRL : in STD_LOGIC );
	end component;
   
	component ll_randommiso16
	generic(
		random_seed : STD_LOGIC_VECTOR(3 downto 0) := x"1");
	port(
		RX_MOSI : in t_ll_mosi;
		RX_MISO : out t_ll_miso;
		TX_MOSI : out t_ll_mosi;
		TX_MISO : in t_ll_miso;
		RANDOM : in STD_LOGIC;
		FALL : in STD_LOGIC;
		ARESET : in STD_LOGIC;
		CLK : in STD_LOGIC);
	end component;

	component ll_file_output_16
	generic(
		Signed_Data : BOOLEAN := false);
	port(
		FILENAME : in STRING(1 to 255);
		RX_MOSI : in t_ll_mosi;
		RX_MISO : out t_ll_miso;
		RESET : in STD_LOGIC;
		CLK : in STD_LOGIC);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CFG_START_ADD : STD_LOGIC_VECTOR(ALEN-1 downto 0);
	signal CFG_END_ADD : STD_LOGIC_VECTOR(ALEN-1 downto 0);
	signal CFG_WIDTH : STD_LOGIC_VECTOR(XLEN-1 downto 0);
	signal CFG_SKIP : STD_LOGIC_VECTOR(XLEN-1 downto 0);
	signal CFG_CONTROL : STD_LOGIC_VECTOR(2 downto 0);
	signal CFG_CONFIG : STD_LOGIC_VECTOR(4 downto 0);
	signal ADD_LL_BUSY : STD_LOGIC;
	signal ADD_LL_AFULL : STD_LOGIC;
	signal IDLE : STD_LOGIC;
	signal ARESET : STD_LOGIC;
	signal CLK_DATA : STD_LOGIC;
	signal CLK_CTRL : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal CFG_DONE : STD_LOGIC;
	signal ADD_LL_SOF : STD_LOGIC;
	signal ADD_LL_EOF : STD_LOGIC;
	signal ADD_LL_DATA : STD_LOGIC_VECTOR(ALEN-1 downto 0);
	signal ADD_LL_DVAL : STD_LOGIC;
	signal ADD_LL_SUPPORT_BUSY : STD_LOGIC;
	signal ERROR : STD_LOGIC;

	-- Add your code here ...
   signal END_SIM : BOOLEAN := FALSE;
   signal ll_dut_rand1_mosi : t_ll_mosi;
   signal ll_rand1_rand2_mosi : t_ll_mosi;
   signal ll_dut_rand1_miso : t_ll_miso;
   signal ll_rand1_rand2_miso : t_ll_miso;
   signal RANDOM : std_logic;
   signal FALL : std_logic;
   signal TX_MOSI : t_ll_mosi;
   signal TX_MISO : t_ll_miso;
   signal Filename : string(1 to 255);
   
   
begin

	-- Unit Under Test port map
	UUT : ll_aoi_add_gen
		generic map (
			XLEN => XLEN,
			ALEN => ALEN
		)

		port map (
			CFG_START_ADD => CFG_START_ADD,
			CFG_END_ADD => CFG_END_ADD,
			CFG_WIDTH => CFG_WIDTH,
			CFG_SKIP => CFG_SKIP,
			CFG_CONTROL => CFG_CONTROL,
			CFG_DONE => CFG_DONE,
			CFG_CONFIG => CFG_CONFIG,
			ADD_LL_SOF => ADD_LL_SOF,
			ADD_LL_EOF => ADD_LL_EOF,
			ADD_LL_DATA => ADD_LL_DATA,
			ADD_LL_DVAL => ADD_LL_DVAL,
			ADD_LL_SUPPORT_BUSY => ADD_LL_SUPPORT_BUSY,
			ADD_LL_BUSY => ADD_LL_BUSY,
			ADD_LL_AFULL => ADD_LL_AFULL,
			IDLE => IDLE,
			ERROR => ERROR,
			ARESET => ARESET,
			CLK_DATA => CLK_DATA,
			CLK_CTRL => CLK_CTRL
		);
  
   Rand1 : ll_randommiso16
   generic map(
   random_seed => x"2")
   port map(
      RX_MOSI.DATA => ADD_LL_DATA,
      RX_MOSI.DVAL => ADD_LL_DVAL,
      RX_MOSI.SOF => ADD_LL_SOF,
      RX_MOSI.EOF => ADD_LL_EOF,
      RX_MOSI.SUPPORT_BUSY => ADD_LL_SUPPORT_BUSY,
      RX_MISO.BUSY => ADD_LL_BUSY,
      RX_MISO.AFULL => ADD_LL_AFULL,
      TX_MOSI => ll_rand1_rand2_mosi,
      TX_MISO => ll_rand1_rand2_miso,
      RANDOM => RANDOM,
      FALL => FALL,
      ARESET => ARESET,
      CLK => CLK_DATA
   );
   
   Rand2 : ll_randommiso16
   generic map(
   random_seed => x"3")
   port map(
      RX_MOSI => ll_rand1_rand2_mosi,
      RX_MISO => ll_rand1_rand2_miso,
      TX_MOSI => TX_MOSI,
      TX_MISO => TX_MISO,
      RANDOM => RANDOM,
      FALL => FALL,
      ARESET => ARESET,
      CLK => CLK_DATA
   );
   
   Filename(1 to 77) <= "D:\Telops\Common_hdl\Telops_Memory_Interface\LL_TMI_bridge\tb\src\add_out.raw";
   
   File_out : ll_file_output_16
   port map(
      FILENAME => Filename,
      RX_MOSI => TX_MOSI,
      RX_MISO => TX_MISO,
      RESET => ARESET,
      CLK => CLK_DATA
   );   
	-- Add your stimulus here ...
   CLOCK_DATA : process
   begin
      --this process was generated based on formula: 0 0 ns, 1 12500 ps -r 25 ns
      --wait for <time to next event>; -- <current time>
      if END_SIM = FALSE then
         CLK_DATA <= '0';
         wait for 3.125 ns;
      else
         wait;
      end if;
      if END_SIM = FALSE then
         CLK_DATA <= '1';
         wait for 3.125 ns; 
      else
         wait;
      end if;
   end process;
   
   CLOCK_CTRL : process
   begin
      --this process was generated based on formula: 0 0 ns, 1 12500 ps -r 25 ns
      --wait for <time to next event>; -- <current time>
      if END_SIM = FALSE then
         CLK_CTRL <= '0';
         wait for 5 ns;
      else
         wait;
      end if;
      if END_SIM = FALSE then
         CLK_CTRL <= '1';
         wait for 5 ns; 
      else
         wait;
      end if;
   end process;

   STIMILUS : process
   begin
      if END_SIM = FALSE then
         ARESET <= '1';
         RANDOM <= '0';
         FALL <= '0';
         wait for 200ns;
         ARESET <= '0';
         TX_MISO.BUSY <= '0';
         TX_MISO.AFULL <= '0';
         IDLE <= '1';
         RANDOM <= '1';
         wait for 200ns;
         CFG_START_ADD <= x"0000";
         CFG_END_ADD <= x"00FF";
         CFG_WIDTH <= x"000F";
         CFG_SKIP <= x"0021"; 
         CFG_CONFIG <= "11111";
         wait for 200ns;
         CFG_CONTROL <= "001";
         wait for 10ns;
         CFG_CONTROL <= "000";
         IDLE <= '0';
         wait for 10us;
         CFG_CONTROL <= "010";
         wait for 1000ns;
         IDLE <= '1';
         wait for 1us;
         END_SIM <= TRUE;
         wait for 50ns;
      else
         wait;
      end if;
   end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_aoi_add_gen of ll_aoi_add_gen_tb is
	for TB_ARCHITECTURE
		for UUT : ll_aoi_add_gen
			use entity work.ll_aoi_add_gen(rtl);
		end for;
	end for;
end TESTBENCH_FOR_ll_aoi_add_gen;

