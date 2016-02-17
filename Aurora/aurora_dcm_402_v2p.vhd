--  Author: Patrick Dubois (modified from Xilinx generated file)
--  Modifications for _402_V2p version => revmoved user clock division by 2 (OBO)

library ieee;
use ieee.std_logic_1164.all;
-- synthesis translate_off
library unisim;
use unisim.all;
-- synthesis translate_on

entity aurora_dcm_402_v2p is
    port (
        RST 			: in std_logic;
        MGT_REF_CLK   : in std_logic;
        USER_CLK      : out std_logic;
        DCM_LOCKED    : out std_logic);
end aurora_dcm_402_v2p;

-- pragma translate_off
architecture SIM of aurora_dcm_402_v2p is
    signal init_cnt : integer range 0 to 15;
    signal clk_on : std_logic := '0';
    
begin
    
    USER_CLK <= MGT_REF_CLK and clk_on;
    
    sim_process : process(RST, MGT_REF_CLK)
    begin
        if RST = '1' then
            DCM_LOCKED <= '0';
            init_cnt <= 0;
            clk_on <= '0';
        elsif rising_edge(MGT_REF_CLK) then
            if init_cnt < 15 then
                init_cnt <= init_cnt + 1;
            end if;
            if init_cnt > 8 then
                clk_on <= '1';
            end if;
            if init_cnt > 12 then
                DCM_LOCKED <= '1';
            end if;
        end if;
    end process;
    
end SIM;			
-- pragma translate_on

architecture MAPPED of aurora_dcm_402_v2p is
    
    -- Wire Declarations --
    signal not_connected_i : std_logic_vector(15 downto 0);
    signal clkfb_i         : std_logic;
    signal clk0_i          : std_logic;
    signal locked_i        : std_logic;
    signal reset_local     : std_logic;
    
    constant tied_to_ground_i : std_logic := '0';
    
    -- Component Declarations --
    component DCM_RESET
        port (
            CLK  : in std_logic;
            RST_IN  : in std_logic;
            DCM_RST : out std_logic);
    end component;
    
    component DCM
        generic( CLK_FEEDBACK : string :=  "1X";
            CLKDV_DIVIDE : real :=  2.000000;
            CLKFX_DIVIDE : integer :=  1;
            CLKFX_MULTIPLY : integer :=  4;
            CLKIN_DIVIDE_BY_2 : boolean :=  FALSE;
            CLKIN_PERIOD : real :=  10.000000;
            CLKOUT_PHASE_SHIFT : string :=  "NONE";
            DESKEW_ADJUST : string :=  "SYSTEM_SYNCHRONOUS";
            DFS_FREQUENCY_MODE : string :=  "LOW";
            DLL_FREQUENCY_MODE : string :=  "LOW";
            DUTY_CYCLE_CORRECTION : boolean :=  TRUE;
            FACTORY_JF : bit_vector :=  x"C080";
            PHASE_SHIFT : integer :=  0;
            STARTUP_WAIT : boolean :=  FALSE;
            DSS_MODE : string :=  "NONE");
        port( CLKIN    : in    std_logic; 
            CLKFB    : in    std_logic; 
            RST      : in    std_logic; 
            PSEN     : in    std_logic; 
            PSINCDEC : in    std_logic; 
            PSCLK    : in    std_logic; 
            DSSEN    : in    std_logic; 
            CLK0     : out   std_logic; 
            CLK90    : out   std_logic; 
            CLK180   : out   std_logic; 
            CLK270   : out   std_logic; 
            CLKDV    : out   std_logic; 
            CLK2X    : out   std_logic; 
            CLK2X180 : out   std_logic; 
            CLKFX    : out   std_logic; 
            CLKFX180 : out   std_logic; 
            STATUS   : out   std_logic_vector (7 downto 0); 
            LOCKED   : out   std_logic; 
            PSDONE   : out   std_logic);
    end component;
    
    component BUFG		
        port (			
            O : out std_ulogic;
            I : in  std_ulogic);		
    end component;
    
begin
    
    -- Instantiate a DCM module to divide the reference clock.
    
    DCM_INST : DCM
    
    generic map( CLK_FEEDBACK => "1X",
    CLKDV_DIVIDE => 2.000000,
    CLKIN_DIVIDE_BY_2 => FALSE,
    CLKIN_PERIOD => 10.000000,
    CLKOUT_PHASE_SHIFT => "NONE",
    DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
    DFS_FREQUENCY_MODE => "LOW",
    DLL_FREQUENCY_MODE => "LOW",
    DUTY_CYCLE_CORRECTION => TRUE,
    FACTORY_JF => x"C080",
    PHASE_SHIFT => 0,
    STARTUP_WAIT => FALSE)   
    port map (
        
        CLK0     => clk0_i,
        CLK180   => open,
        CLK270   => open,
        CLK2X    => open,
        CLK2X180 => open,
        CLK90    => open,
        CLKDV    => open,
        CLKFX    => open,
        CLKFX180 => open,
        LOCKED   => locked_i,
        PSDONE   => open,
        STATUS   => open,
        CLKFB    => clkfb_i,
        CLKIN    => MGT_REF_CLK,
        DSSEN    => tied_to_ground_i,
        PSCLK    => tied_to_ground_i,
        PSEN     => tied_to_ground_i,
        PSINCDEC => tied_to_ground_i,
        RST      => reset_local);
    
    -- BUFG for the feedback clock.  The feedback signal is phase aligned to the input
    -- and must come from the CLK0 or CLK2X output of the DCM.  In this case, we use
    -- the CLK0 output.	
    feedback_clock_net_i : BUFG   
    port map (		
        I => clk0_i,
        O => clkfb_i);
    
    -- The User Clock is the same as the feedback clock
    USER_CLK <= clkfb_i;
    
    -- DCM_LOCKED mapping	
    DCM_LOCKED <= locked_i;
    
    -- manage the reset circuit
    inst_dcm_reset : dcm_reset
    port map(
        CLK => MGT_REF_CLK,
        RST_IN => RST,
        DCM_RST => reset_local);
    
    
end MAPPED;
