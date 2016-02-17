LIBRARY ieee;
	USE ieee.std_logic_1164.all;
	USE ieee.std_logic_textio.all;
--        USE Ieee.std_logic_signed.all;
LIBRARY std;
	USE std.textio.ALL;
	USE work.package_utility.ALL;
	


ENTITY testbench IS
END testbench;

ARCHITECTURE test_SRAM OF testbench IS

    CONSTANT addr_bits	: INTEGER := 20;
    CONSTANT data_bits	: INTEGER := 18;
    CONSTANT tCLK	: TIME    := 15 ns;
    CONSTANT tsetup	: TIME    := 3.0 ns;	-- Greater than Worst case Set-up time
    CONSTANT HiZ	: STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');

    COMPONENT cy7c1372
        PORT (Dq	: INOUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');
              Addr	: IN    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
              Clk	: IN    STD_LOGIC;
              CEN_n	: IN    STD_LOGIC;
              AdvLd_n	: IN    STD_LOGIC;
              Mode	: IN    STD_LOGIC;
              Bwa_n	: IN    STD_LOGIC;
              Bwb_n	: IN    STD_LOGIC;
              Rw_n	: IN    STD_LOGIC;
              Oe_n	: IN    STD_LOGIC;
              Ce1_n	: IN    STD_LOGIC;
              Ce3_n	: IN    STD_LOGIC;
              Ce2	: IN    STD_LOGIC;
              Zz	: IN    STD_LOGIC
        );
    END COMPONENT;
  
    FOR ALL: cy7c1372 USE ENTITY work.cy7c1372(behave);
    
    SIGNAL Dq		: STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');
    SIGNAL Addr		: STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Clk		: STD_LOGIC := '0';
    SIGNAL CEN_n	: STD_LOGIC;
    SIGNAL AdvLd_n	: STD_LOGIC;
    SIGNAL Mode		: STD_LOGIC;
    SIGNAL Bwa_n	: STD_LOGIC;
    SIGNAL Bwb_n	: STD_LOGIC;
    SIGNAL Rw_n		: STD_LOGIC;
    SIGNAL Oe_n		: STD_LOGIC;
    SIGNAL Ce1_n	: STD_LOGIC;
    SIGNAL Ce3_n	: STD_LOGIC;
    SIGNAL Ce2		: STD_LOGIC;
    SIGNAL Zz		: STD_LOGIC;




BEGIN
    U1 : cy7c1372
        PORT MAP (Dq => Dq, Addr => Addr, Clk => Clk, CEN_n => CEN_n,
                  Mode => Mode, AdvLd_n => AdvLd_n, Bwa_n => Bwa_n, Bwb_n => Bwb_n,
                  Rw_n => Rw_n, Oe_n => Oe_n, Ce1_n => Ce1_n, Ce3_n => Ce3_n, Ce2 => Ce2, Zz => Zz);
                  
                  
	vectors: PROCESS
	
--	FILE vector_file : TEXT open read_mode "/projects/apps_training/VHDL_MODELS/NoBL_PL/SRC/vectors.txt";	-- VHDL: 3 Std
--	FILE vector_file : TEXT open write_mode IS "file_io.out";	-- VHDL 93 Std

	FILE vector_file : TEXT is in "vectors.txt";	-- VHDL 87 Std
	FILE my_output : TEXT is out "file_io.out";	-- VHDL 87 Std
	
	VARIABLE invecs		: line;
	VARIABLE my_line 	: LINE;
	VARIABLE ch		: CHARACTER;
	
	
	VARIABLE tmpCEN_n, tmpAdvLd_n, tmpMode, tmpBwa_n, tmpBwb_n, tmpRw_n, tmpCe1_n, tmpCe3_n, tmpCe2: std_logic;
	VARIABLE tmpZz		: std_logic := '0';
	VARIABLE tmpOe_n	: std_logic := '0';
	VARIABLE tmpAddr	: STD_LOGIC_VECTOR (addr_bits - 1  DOWNTO 0);
	VARIABLE tmpDq		: STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => 'Z');
	VARIABLE tmpDq_dup	: STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');
	VARIABLE tmpDq_expected	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	VARIABLE tmpDq_expct_dup: STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);
	
	VARIABLE cnt: integer := 1;
	VARIABLE vector_time: time;
	VARIABLE good_number, good_val: BOOLEAN;
	
	BEGIN

	wait for  10 ns ;
		
	WHILE NOT endfile (vector_file) LOOP
		readline (vector_file, invecs);
		
		read (invecs, tmpAddr, good_val);
		assert good_val REPORT "bad ADDR value";
		
		read (invecs, ch);
				
		read (invecs, tmpDq, good_val);
--		read (invecs, tmpDq );

		assert good_val REPORT "bad DQ value";

		read (invecs, ch);
				
		read (invecs, tmpDq_expected, good_val);
		assert good_val REPORT "bad DQ_Expected value";
		
		read (invecs, ch);
				
		read (invecs, tmpCEN_n, good_val);
		assert good_val REPORT "bad CEN_n value";
		
		read (invecs, ch);
				
		read (invecs, tmpCe1_n, good_val);
		assert good_val REPORT "bad Ce1_n value";
		
		read (invecs, ch);
				
		read (invecs, tmpCe2, good_val);
		assert good_val REPORT "bad Ce3_n value";
		
		read (invecs, ch);
				
		read (invecs, tmpCe3_n, good_val);
		assert good_val REPORT "bad Ce2 value";
		
		read (invecs, ch);
				
		read (invecs, tmpRw_n, good_val);
		assert good_val REPORT "bad Rw_n value";

		read (invecs, ch);
				
		read (invecs, tmpBwb_n, good_val);
		assert good_val REPORT "bad Bwb_n value";
		
		read (invecs, ch);
				
		read (invecs, tmpBwa_n, good_val);
		assert good_val REPORT "bad Bwa_n value";
		
		read (invecs, ch);
				
		read (invecs, tmpAdvLd_n, good_val);
		assert good_val REPORT "bad AdvLd_n value";

		read (invecs, ch);
				
		read (invecs, tmpMode, good_val);
		assert good_val REPORT "bad Mode value";
		
		-- read (l, tmpOutput);

	if (tmpDq = "ZZZZZZZZZZZZZZZZ") THEN

     		tmpDq_dup := "ZZZZZZZZZZZZZZZZZZ";

	else
      		tmpDq_dup(16 downto 13) := tmpDq(7 downto 4);
      		tmpDq_dup(12 downto 9) := tmpDq(7 downto 4);
      		tmpDq_dup(7 downto 4) := tmpDq(3 downto 0);
      		tmpDq_dup(3 downto 0) := tmpDq(3 downto 0);

      		tmpDq_dup(17) := tmpDq_dup(16) xor tmpDq_dup(15) xor tmpDq_dup(14) xor tmpDq_dup(13) xor tmpDq_dup(12) xor tmpDq_dup(11) xor tmpDq_dup(10) xor tmpDq_dup(9);
      		tmpDq_dup(8) := tmpDq_dup(7) xor tmpDq_dup(6) xor tmpDq_dup(5) xor tmpDq_dup(4) xor tmpDq_dup(3) xor tmpDq_dup(2) xor tmpDq_dup(1) xor tmpDq_dup(0);

	end if;


	if (tmpDq_expected(15 downto 0) /= "XXXXXXXXXXXXXXXX" or tmpDq_expected(15 downto 0) /= "ZZZZZZZZZZZZZZZZ") THEN

      		tmpDq_expct_dup(16 downto 13) := tmpDq_expected(7 downto 4);
      		tmpDq_expct_dup(12 downto 9) := tmpDq_expected(7 downto 4);
      		tmpDq_expct_dup(7 downto 4) := tmpDq_expected(3 downto 0);
      		tmpDq_expct_dup(3 downto 0) := tmpDq_expected(3 downto 0);

      		tmpDq_expct_dup(17) := tmpDq_expct_dup(16) xor tmpDq_expct_dup(15) xor tmpDq_expct_dup(14) xor tmpDq_expct_dup(13) xor tmpDq_expct_dup(12) xor tmpDq_expct_dup(11) xor tmpDq_expct_dup(10) xor tmpDq_expct_dup(9);
     		tmpDq_expct_dup(8) := tmpDq_expct_dup(7) xor tmpDq_expct_dup(6) xor tmpDq_expct_dup(5) xor tmpDq_expct_dup(4) xor tmpDq_expct_dup(3) xor tmpDq_expct_dup(2) xor tmpDq_expct_dup(1) xor tmpDq_expct_dup(0);

	else

     		tmpDq_expct_dup := "ZZZZZZZZZZZZZZZZZZ";

	end if;

		
		wait for (tCLK/2 - tsetup) ;
		
		-- Assigning temp variables to signals
		Ce1_n <= tmpCe1_n;
		Ce3_n <= tmpCe3_n;
		Ce2 <= tmpCe2;
		CEN_n <= tmpCEN_n;
		AdvLd_n <= tmpAdvLd_n;
		Mode <= tmpMode;
		Bwa_n <= tmpBwa_n;
		Bwb_n <= tmpBwb_n;
		Rw_n <= tmpRw_n;


		if tmpDq(15 downto 0) = "XXXXXXXXXXXXXXXX" then 
		Dq(data_bits - 1 DOWNTO 0) <= "ZZZZZZZZZZZZZZZZZZ" ;
		else 
		Dq <= tmpDq_dup;
		end if;
		
		Oe_n <= tmpOe_n;
		Zz <= tmpZz;
		Addr <=  tmpAddr( 19 downto 0);
		
		wait for tsetup;
		Clk <= not (Clk);

		
		if (tmpDq_expected(15 downto 0) = "XXXXXXXXXXXXXXXX" or tmpDq_expected(15 downto 0) = "ZZZZZZZZZZZZZZZZ") THEN
			--- do nothing
		elsif (Dq /= tmpDq_expct_dup) THEN

			write(my_line, string'("Vector Mismatch at Line No: "));
			write(my_line, cnt);
        		writeline(my_output, my_line);

		end if;

		wait for tCLK/2 ;
		Clk <= not (Clk) after 0 ns;
		cnt := cnt + 1;
		
	END LOOP;
			
	ASSERT FALSE
    REPORT "Test Complete!" SEVERITY NOTE;
	WAIT;
	
	END PROCESS;

END test_SRAM;

