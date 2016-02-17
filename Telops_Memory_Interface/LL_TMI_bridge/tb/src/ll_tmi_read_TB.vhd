library common_hdl;
use common_hdl.Telops.all;
library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ll_tmi_read_tb is
	-- Generic declarations of the tested unit
		generic(
		TMI_Latency : NATURAL := 4;
		DLEN : NATURAL := 16;
		ALEN : NATURAL := 16 );
end ll_tmi_read_tb;

architecture TB_ARCHITECTURE of ll_tmi_read_tb is
	-- Component declaration of the tested unit
	component ll_tmi_read
		generic(
		TMI_Latency : NATURAL := 4;
		DLEN : NATURAL := 32;
		ALEN : NATURAL := 21 );
	port(
		TMI_IDLE : in STD_LOGIC;
		TMI_ERROR : in STD_LOGIC;
		TMI_RNW : out STD_LOGIC;
		TMI_ADD : out STD_LOGIC_VECTOR(ALEN-1 downto 0);
		TMI_DVAL : out STD_LOGIC;
		TMI_BUSY : in STD_LOGIC;
		TMI_RD_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
		TMI_RD_DVAL : in STD_LOGIC;
		TMI_WR_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		ADD_LL_SOF : in STD_LOGIC;
		ADD_LL_EOF : in STD_LOGIC;
		ADD_LL_DATA : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
		ADD_LL_DVAL : in STD_LOGIC;
		ADD_LL_SUPPORT_BUSY : in STD_LOGIC;
		ADD_LL_BUSY : out STD_LOGIC;
		ADD_LL_AFULL : out STD_LOGIC;
		RD_LL_SOF : out STD_LOGIC;
		RD_LL_EOF : out STD_LOGIC;
		RD_LL_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		RD_LL_DVAL : out STD_LOGIC;
		RD_LL_SUPPORT_BUSY : out STD_LOGIC;
		RD_LL_BUSY : in STD_LOGIC;
		RD_LL_AFULL : in STD_LOGIC;
		IDLE : out STD_LOGIC;
		ERROR : out STD_LOGIC;
		ARESET : in STD_LOGIC;
		CLK : in STD_LOGIC );
	end component;

	component tmi_bram
	generic(
		C_TMI_DLEN : INTEGER := 32;
		C_TMI_ALEN : INTEGER := 8;
		C_READ_LATENCY : INTEGER := 1;
      C_BUSY_GENERATE : boolean := false;	-- Generate Pseudo-random TMI_BUSY signal  
      C_RANDOM_SEED : std_logic_vector(3 downto 0) := x"1"; -- --Pseudo-random generator seed
      C_BUSY_DURATION : integer := 20);  -- Duration of TMI_BUSY signal in clock cycles
	port(
		TMI_IDLE : out STD_LOGIC;
		TMI_ERROR : out STD_LOGIC;
		TMI_RNW : in STD_LOGIC;
		TMI_ADD : in STD_LOGIC_VECTOR(C_TMI_ALEN-1 downto 0);
		TMI_DVAL : in STD_LOGIC;
		TMI_BUSY : out STD_LOGIC;
		TMI_RD_DATA : out STD_LOGIC_VECTOR(C_TMI_DLEN-1 downto 0);
		TMI_RD_DVAL : out STD_LOGIC;
		TMI_WR_DATA : in STD_LOGIC_VECTOR(C_TMI_DLEN-1 downto 0);
		TMI_CLK : in STD_LOGIC;
		ARESET : in STD_LOGIC);
	end component;

	component ll_aoi_add_gen
	generic(
		XLEN : NATURAL := 9;
		ALEN : NATURAL := 21);
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
		CLK_CTRL : in STD_LOGIC);
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
	signal TMI_IDLE : STD_LOGIC;
	signal TMI_ERROR : STD_LOGIC;
	signal TMI_BUSY : STD_LOGIC;
	signal TMI_RD_DATA : STD_LOGIC_VECTOR(DLEN-1 downto 0);
	signal TMI_RD_DVAL : STD_LOGIC;
	signal ADD_LL_SOF : STD_LOGIC;
	signal ADD_LL_EOF : STD_LOGIC;
	signal ADD_LL_DATA : STD_LOGIC_VECTOR(ALEN-1 downto 0);
	signal ADD_LL_DVAL : STD_LOGIC;
	signal ADD_LL_SUPPORT_BUSY : STD_LOGIC;
	signal RD_LL_BUSY : STD_LOGIC;
	signal RD_LL_AFULL : STD_LOGIC;
	signal ARESET : STD_LOGIC;
--	signal CLK : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal TMI_RNW : STD_LOGIC;
	signal TMI_ADD : STD_LOGIC_VECTOR(ALEN-1 downto 0);
	signal TMI_DVAL : STD_LOGIC;
	signal TMI_WR_DATA : STD_LOGIC_VECTOR(DLEN-1 downto 0);
	signal ADD_LL_BUSY : STD_LOGIC;
	signal ADD_LL_AFULL : STD_LOGIC;
	signal RD_LL_SOF : STD_LOGIC;
	signal RD_LL_EOF : STD_LOGIC;
	signal RD_LL_DATA : STD_LOGIC_VECTOR(DLEN-1 downto 0);
	signal RD_LL_DVAL : STD_LOGIC;
	signal RD_LL_SUPPORT_BUSY : STD_LOGIC;
	signal IDLE : STD_LOGIC;
	signal ERROR : STD_LOGIC;

	-- Add your code here ...

   signal CFG_START_ADD : STD_LOGIC_VECTOR(ALEN-1 downto 0);
	signal CFG_END_ADD : STD_LOGIC_VECTOR(ALEN-1 downto 0);
	signal CFG_WIDTH : STD_LOGIC_VECTOR(DLEN-1 downto 0);
	signal CFG_SKIP : STD_LOGIC_VECTOR(DLEN-1 downto 0);
	signal CFG_CONTROL : STD_LOGIC_VECTOR(2 downto 0);
	signal CFG_CONFIG : STD_LOGIC_VECTOR(4 downto 0);
	signal CLK_DATA : STD_LOGIC;
	signal CLK_CTRL : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal CFG_DONE : STD_LOGIC;
	signal ERROR_ADD_GEN : STD_LOGIC;
   
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
	UUT : ll_tmi_read
		generic map (
			TMI_Latency => TMI_Latency,
			DLEN => DLEN,
			ALEN => ALEN
		)

		port map (
			TMI_IDLE => TMI_IDLE,
			TMI_ERROR => TMI_ERROR,
			TMI_RNW => TMI_RNW,
			TMI_ADD => TMI_ADD,
			TMI_DVAL => TMI_DVAL,
			TMI_BUSY => TMI_BUSY,
			TMI_RD_DATA => TMI_RD_DATA,
			TMI_RD_DVAL => TMI_RD_DVAL,
			TMI_WR_DATA => TMI_WR_DATA,
			ADD_LL_SOF => ADD_LL_SOF,
			ADD_LL_EOF => ADD_LL_EOF,
			ADD_LL_DATA => ADD_LL_DATA,
			ADD_LL_DVAL => ADD_LL_DVAL,
			ADD_LL_SUPPORT_BUSY => ADD_LL_SUPPORT_BUSY,
			ADD_LL_BUSY => ADD_LL_BUSY,
			ADD_LL_AFULL => ADD_LL_AFULL,
			RD_LL_SOF => RD_LL_SOF,
			RD_LL_EOF => RD_LL_EOF,
			RD_LL_DATA => RD_LL_DATA,
			RD_LL_DVAL => RD_LL_DVAL,
			RD_LL_SUPPORT_BUSY => RD_LL_SUPPORT_BUSY,
			RD_LL_BUSY => RD_LL_BUSY,
			RD_LL_AFULL => RD_LL_AFULL,
			IDLE => IDLE,
			ERROR => ERROR,
			ARESET => ARESET,
			CLK => CLK_DATA
		);

BRAM : tmi_bram
   generic map(
      C_TMI_DLEN => DLEN,
      C_TMI_ALEN => ALEN,
      C_READ_LATENCY => TMI_Latency,
      C_BUSY_GENERATE => TRUE
--      C_RANDOM_SEED => C_RANDOM_SEED,
--      C_BUSY_DURATION => C_BUSY_DURATION
   )
   port map(
      TMI_IDLE => TMI_IDLE,
      TMI_ERROR => TMI_ERROR,
      TMI_RNW => TMI_RNW,
      TMI_ADD => TMI_ADD,
      TMI_DVAL => TMI_DVAL,
      TMI_BUSY => TMI_BUSY,
      TMI_RD_DATA => TMI_RD_DATA,
      TMI_RD_DVAL => TMI_RD_DVAL,
      TMI_WR_DATA => TMI_WR_DATA,
      TMI_CLK => CLK_DATA,
      ARESET => ARESET
   );
   
add_gen : ll_aoi_add_gen
   generic map(
      XLEN => DLEN,
      ALEN => ALEN
   )
   port map(
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
      ERROR => ERROR_ADD_GEN,
      ARESET => ARESET,
      CLK_DATA => CLK_DATA,
      CLK_CTRL => CLK_CTRL
   );
   
   Rand1 : ll_randommiso16
   generic map(
   random_seed => x"2")
   port map(
      RX_MOSI.DATA => RD_LL_DATA,
      RX_MOSI.DVAL => RD_LL_DVAL,
      RX_MOSI.SOF => RD_LL_SOF,
      RX_MOSI.EOF => RD_LL_EOF,
      RX_MOSI.SUPPORT_BUSY => RD_LL_SUPPORT_BUSY,
      RX_MISO.BUSY => RD_LL_BUSY,
      RX_MISO.AFULL => RD_LL_AFULL,
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
   
   Filename(1 to 78) <= "D:\Telops\Common_hdl\Telops_Memory_Interface\LL_TMI_bridge\tb\src\data_out.raw";
   
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
         CFG_START_ADD <= x"0000";
         CFG_END_ADD <= x"0000";
         CFG_WIDTH <= x"0000";
         CFG_SKIP <= x"0000"; 
         CFG_CONFIG <= "00000";
         CFG_CONTROL <= "000";
         wait for 200ns;
         ARESET <= '0';
         TX_MISO.BUSY <= '0';
         TX_MISO.AFULL <= '0';
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
--         CFG_CONTROL <= "000";
         wait for 10us;
         CFG_CONTROL <= "010";
         wait for 1000ns;
         wait for 5us;
         END_SIM <= TRUE;
         wait for 50ns;
      else
         wait;
      end if;
   end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ll_tmi_read of ll_tmi_read_tb is
	for TB_ARCHITECTURE
		for UUT : ll_tmi_read
			use entity work.ll_tmi_read(rtl);
		end for;
	end for;
end TESTBENCH_FOR_ll_tmi_read;

