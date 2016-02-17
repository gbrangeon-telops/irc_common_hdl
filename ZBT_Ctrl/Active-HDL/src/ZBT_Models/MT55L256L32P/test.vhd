LIBRARY ieee;
    USE ieee.std_logic_1164.ALL;

ENTITY tb IS
END tb;

ARCHITECTURE test OF tb IS

    CONSTANT addr_bits : INTEGER := 18;
    CONSTANT data_bits : INTEGER := 32;
    CONSTANT tKHKH     : TIME    := 10 ns;
    CONSTANT HiZ       : STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');

    COMPONENT mt55l256l32p
        PORT (Dq       : INOUT STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');
              Addr     : IN    STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
              Lbo_n    : IN    STD_LOGIC;
              Clk      : IN    STD_LOGIC;
              Cke_n    : IN    STD_LOGIC;
              Ld_n     : IN    STD_LOGIC;
              Bwa_n    : IN    STD_LOGIC;
              Bwb_n    : IN    STD_LOGIC;
              Bwc_n    : IN    STD_LOGIC;
              Bwd_n    : IN    STD_LOGIC;
              Rw_n     : IN    STD_LOGIC;
              Oe_n     : IN    STD_LOGIC;
              Ce_n     : IN    STD_LOGIC;
              Ce2_n    : IN    STD_LOGIC;
              Ce2      : IN    STD_LOGIC;
              Zz       : IN    STD_LOGIC
        );
    END COMPONENT;
    
    FOR ALL: mt55l256l32p USE ENTITY work.mt55l256l32p(behave);
    
    SIGNAL pDq         : STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0) := (OTHERS => 'Z');
    SIGNAL pAddr       : STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pLbo_n      : STD_LOGIC;
    SIGNAL pClk        : STD_LOGIC;
    SIGNAL pCke_n      : STD_LOGIC;
    SIGNAL pLd_n       : STD_LOGIC;
    SIGNAL pBwa_n      : STD_LOGIC;
    SIGNAL pBwb_n      : STD_LOGIC;
    SIGNAL pBwc_n      : STD_LOGIC;
    SIGNAL pBwd_n      : STD_LOGIC;
    SIGNAL pRw_n       : STD_LOGIC;
    SIGNAL pOe_n       : STD_LOGIC;
    SIGNAL pCe_n       : STD_LOGIC;
    SIGNAL pCe2_n      : STD_LOGIC;
    SIGNAL pCe2        : STD_LOGIC;
    SIGNAL pZz         : STD_LOGIC;
    SIGNAL stim_done   : boolean := false;
    SIGNAL clk_done    : boolean := false;

BEGIN
    U1 : mt55l256l32p
        PORT MAP (Dq => pDq, Addr => pAddr, Lbo_n => pLbo_n, Clk => pClk, Cke_n => pCke_n,
                  Ld_n => pLd_n, Bwa_n => pBwa_n, Bwb_n => pBwb_n, Bwc_n => pBwc_n, Bwd_n => pBwd_n,
                  Rw_n => pRw_n, Oe_n => pOe_n, Ce_n => pCe_n, Ce2_n => pCe2_n, Ce2 => pCe2, Zz => pZz);

    stimulator : PROCESS
        PROCEDURE deselect (Ld_in : STD_LOGIC;
                            Dq_in : STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0)) IS
        BEGIN
            pCe_n  <= '1';
            pCe2_n <= '1';
            pCe2   <= '0';
            pZz    <= '0';
            pLd_n  <= Ld_in;
            pRw_n  <= '0';
            pBwa_n <= '0';
            pBwb_n <= '0';
            pBwc_n <= '0';
            pBwd_n <= '0';
            pOe_n  <= '0';
            pCke_n <= '0';
            pLbo_n <= '0';
            pAddr  <= (OTHERS => '0');
            pDq    <= Dq_in;
            WAIT FOR tKHKH;
        END;

        PROCEDURE read (Lbo_in  : STD_LOGIC;
                        Ld_in   : STD_LOGIC;
                        Oe_in   : STD_LOGIC;
                        Addr_in : STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0);
                        Dq_in   : STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0)) IS
        BEGIN
            pCe_n  <= '0';
            pCe2_n <= '0';
            pCe2   <= '1';
            pZz    <= '0';
            pLd_n  <= Ld_in;
            pRw_n  <= '1';
            pBwa_n <= '0';
            pBwb_n <= '0';
            pBwc_n <= '0';
            pBwd_n <= '0';
            pOe_n  <= Oe_in;
            pCke_n <= '0';
            pLbo_n <= Lbo_in;
            pAddr  <= Addr_in;
            pDq    <= Dq_in;
            WAIT FOR tKHKH;
        END;

        PROCEDURE write (Lbo_in  : STD_LOGIC;
                         Ld_in   : STD_LOGIC;
                         Bwa_in  : STD_LOGIC;
                         Bwb_in  : STD_LOGIC;
                         Bwc_in  : STD_LOGIC;
                         Bwd_in  : STD_LOGIC;
                         Addr_in : STD_LOGIC_VECTOR (addr_bits - 1 DOWNTO 0);
                         Dq_in   : STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0)) IS
        BEGIN
            pCe_n  <= '0';
            pCe2_n <= '0';
            pCe2   <= '1';
            pZz    <= '0';
            pLd_n  <= Ld_in;
            pRw_n  <= '0';
            pBwa_n <= Bwa_in;
            pBwb_n <= Bwb_in;
            pBwc_n <= Bwc_in;
            pBwd_n <= Bwd_in;
            pOe_n  <= '0';
            pCke_n <= '0';
            pLbo_n <= Lbo_in;
            pAddr  <= Addr_in;
            pDq    <= Dq_in;
            WAIT FOR tKHKH;
        END;
    BEGIN
        -- Test Vector
        --        LBO#  LD#   BWa#  BWb#  BWc#  BWd#  Oe#   Addr                   Dq                                       Comments
        deselect (      '0',                                                       HiZ);
        write    ('0',  '0',  '0',  '0',  '0',  '0',        "000000000000000001",  HiZ);                                   -- Write (Addr = 1)
        write    ('0',  '0',  '0',  '0',  '0',  '0',        "000000000000000010",  HiZ);                                   -- Write (Addr = 2)
        write    ('0',  '1',  '0',  '0',  '0',  '0',        "000000000000000000",  "00000000000000000000000000001010");    -- Write (Burst)
        read     ('0',  '0',                          '0',  "000000000000000001",  "00000000000000000000000000010100");    -- Read  (Addr = 1)
        read     ('0',  '0',                          '0',  "000000000000000010",  "00000000000000000000000000011110");    -- Read  (Addr = 2)
        read     ('0',  '1',                          '0',  "000000000000000000",  HiZ);                                   -- Read  (Burst)
        write    ('0',  '0',  '0',  '0',  '0',  '0',        "000000000000000100",  HiZ);                                   -- Write (Addr = 4)
        read     ('0',  '0',                          '0',  "000000000000000100",  HiZ);                                   -- Read  (Addr = 4)
        write    ('0',  '0',  '0',  '0',  '0',  '0',        "000000000000000101",  "00000000000000000000000000101000");    -- Write (Addr = 5)
        read     ('0',  '0',                          '0',  "000000000000000101",  HiZ);                                   -- Read  (Addr = 5)
        deselect (      '0',                                                       "00000000000000000000000000110010");    -- Nop
        deselect (      '0',                                                       HiZ);
        deselect (      '0',                                                       HiZ);
        -- Done Test
        ASSERT false
            REPORT "End of stim file detected!"
            SEVERITY note;
        Stim_Done <= True;
        WAIT;
    END PROCESS;
                           
    clock : PROCESS
        VARIABLE done_time : time;
    BEGIN
        pclk <= '0';
        WAIT for 1.5*tKHKH;
        WHILE not stim_done loop
            pclk <= '1';
            WAIT for tKHKH / 2;
                pclk <= '0';
            WAIT for tKHKH / 2;
        END LOOP;
        done_time := now + tKHKH;
        WHILE now < done_time LOOP      -- one last clock to finish last command
            pclk <= '1';
            WAIT for tKHKH / 2;
            pclk <= '0';
            WAIT for tKHKH / 2;
        END LOOP;
        ASSERT false
            REPORT "Suspending clock activity"
            SEVERITY note;
        clk_done <= true;
        WAIT;
    END PROCESS;

END test;
