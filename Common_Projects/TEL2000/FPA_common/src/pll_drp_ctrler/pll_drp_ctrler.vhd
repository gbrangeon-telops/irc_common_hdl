------------------------------------------------------------------
--!   @file : pll_drp_ctrler.vhd
--!   @brief : PLL DRP Inteface Controller
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
-- 
-- Reference: Application Note XAPP888 de Xilinx, "MMCM and PLL DynamicReconfiguration", 2019.
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.plle2_drp_define.ALL;

entity pll_drp_ctrler is
  Port (
    -- User interface
    SRESET      : in std_logic;                             -- Synchronous Reset
    CLK         : in std_logic;                             -- User Clock
    RSTROBE     : in std_logic;                             -- Read Strobe
    RADDR       : in std_logic_vector(6 downto 0);          -- Read Address
    RDOUT       : out std_logic_vector(15 downto 0);        -- Read Data
    RDVAL       : out std_logic;                            -- Read Data Valid
    NEW_CFG     : in std_logic;                             -- New Config Valid
    PHASES      : in phase_array_t(0 to 4);                 -- New Phase Configs (5 clocks)
    PLL_RDY     : out std_logic;                            -- PLL Ready Status
    -- PLL status and control signals
    PLL_RESET  : out std_logic;                             -- PLL Reset Control    
    PLL_LOCKED : in std_logic;                              -- PLL Locked Status
    -- DRP interface
    DRP_DADDR : out std_logic_vector(6 downto 0);           -- DRP Address
    DRP_DCLK  : out std_logic;                              -- DRP Clock
    DRP_DEN   : out std_logic;                              -- DRP Enable
    DRP_DIN   : out std_logic_vector(15 downto 0);          -- DRP Data In
    DRP_DOUT  : in std_logic_vector(15 downto 0);           -- DRP Data Out
    DRP_DWE   : out std_logic;                              -- DRP Write Enable
    DRP_DRDY  : in std_logic                                -- DRP Ready Status
  );
end pll_drp_ctrler;

architecture RTL of pll_drp_ctrler is

component double_sync is
   generic(
      INIT_VALUE : bit := '0'
   );
	port(
		D : in STD_LOGIC;
		Q : out STD_LOGIC := '0';
		RESET : in STD_LOGIC;
		CLK : in STD_LOGIC
		);
end component double_sync;

-- Clock Config Register Addresses Type
type clkout_config_addr_type is
record
    reg1_addr : std_logic_vector(6 downto 0);
    reg2_addr : std_logic_vector(6 downto 0);
end record; 

-- Clock Configuration Addresses Table
constant CLKOUT_ID_MAX : natural := 4;
type clkout_config_addr_array_type is array(0 to CLKOUT_ID_MAX) of clkout_config_addr_type;
constant CLKOUT_CONFIG_ADDR_TABLE : clkout_config_addr_array_type := ( 
      (DRP_CLKOUT0_REG1_ADDR, DRP_CLKOUT0_REG2_ADDR),
      (DRP_CLKOUT1_REG1_ADDR, DRP_CLKOUT1_REG2_ADDR),
      (DRP_CLKOUT2_REG1_ADDR, DRP_CLKOUT2_REG2_ADDR),
      (DRP_CLKOUT3_REG1_ADDR, DRP_CLKOUT3_REG2_ADDR),
      (DRP_CLKOUT4_REG1_ADDR, DRP_CLKOUT4_REG2_ADDR));
      
-- Phase MUX table
type phase_mux_array_type is array(0 to CLKOUT_ID_MAX) of std_logic_vector(2 downto 0);
signal phase_mux_table : phase_mux_array_type;    

-- Phase Delay Time table
type phase_delay_time_array_type is array(0 to CLKOUT_ID_MAX) of std_logic_vector(5 downto 0);
signal phase_delay_time_table : phase_delay_time_array_type;    
  
signal clkout_id : natural := 0;
signal pll_reset_i : std_logic := '1';
signal pll_locked_i : std_logic;
signal pll_rdy_i : std_logic := '0';
signal drp_rd_addr_i : std_logic_vector(6 downto 0) := (others=>'0');
signal drp_wr_addr_i : std_logic_vector(6 downto 0) := (others=>'0');
signal drp_addr_i : std_logic_vector(6 downto 0) := (others=>'0');
signal drp_din_i : std_logic_vector(15 downto 0) := (others=>'0');
signal drp_dwe_i : std_logic := '0';
signal drp_dwe_i_d : std_logic := '0';
signal drp_den_i : std_logic := '0';
signal drp_drdy_i : std_logic := '0';
signal rd_den_i : std_logic := '0';
signal wr_den_i : std_logic := '0';
signal rdout_i : std_logic_vector(15 downto 0) := (others=>'0');
signal rdval_i : std_logic := '0';
signal start_read_i : std_logic := '0';
signal start_write_i : std_logic := '0';
signal read_in_progress_i : std_logic := '0';
signal write_in_progress_i : std_logic := '0';
signal read_finished_i : std_logic := '0';
signal write_finished_i : std_logic := '0';

-- DRP FSMs
type drp_main_fsm_type is (ST_RST, ST_WAIT_LOCK, ST_IDLE, ST_DEBUG_READ, ST_WAIT_DEBUG_READ_FINISH, ST_PLL_RESET,
                           ST_WRITE_POWER_REG, ST_WAIT_WRITE1_FINISH, ST_READ_CLKOUTN_REG1, ST_WAIT_READ1_FINISH,
                           ST_NEW_CLKOUTN_REG1, ST_WRITE_CLKOUTN_REG1, ST_WAIT_WRITE2_FINISH, ST_READ_CLKOUTN_REG2, 
                           ST_WAIT_READ2_FINISH, ST_NEW_CLKOUTN_REG2, ST_WRITE_CLKOUTN_REG2, ST_WAIT_WRITE3_FINISH,
                           ST_VERIFY_CLOCK_COUNT 
                          );
type drp_read_fsm_type is (ST_IDLE, ST_START_READ, ST_WAIT_DRDY);
type drp_write_fsm_type is (ST_IDLE, ST_START_WRITE, ST_WAIT_DRDY);
signal main_state : drp_main_fsm_type := ST_RST;
signal read_state : drp_read_fsm_type := ST_IDLE;
signal write_state : drp_write_fsm_type := ST_IDLE;

begin

    -- Phase Configs Decoding
    phase_mux_table(0) <= PHASES(0)(2 downto 0);
    phase_mux_table(1) <= PHASES(1)(2 downto 0);
    phase_mux_table(2) <= PHASES(2)(2 downto 0);
    phase_mux_table(3) <= PHASES(3)(2 downto 0);
    phase_mux_table(4) <= PHASES(4)(2 downto 0);
    phase_delay_time_table(0) <= PHASES(0)(8 downto 3); 
    phase_delay_time_table(1) <= PHASES(1)(8 downto 3);
    phase_delay_time_table(2) <= PHASES(2)(8 downto 3);
    phase_delay_time_table(3) <= PHASES(3)(8 downto 3);
    phase_delay_time_table(4) <= PHASES(4)(8 downto 3);

    -- PLL reset
    PLL_RESET <= pll_reset_i;

    -- DRP clock
    DRP_DCLK <= CLK;
    
    -- PLL status synchronization
    U0 : double_sync port map(D => PLL_LOCKED, Q => pll_locked_i, RESET => SRESET, CLK => CLK);
    U1 : double_sync port map(D => DRP_DRDY, Q => drp_drdy_i, RESET => SRESET, CLK => CLK);
    
    -- PLL Ready
    PLL_RDY <= pll_locked_i;
    
    -- DRP address
    DRP_DADDR <= drp_addr_i;
    DRP_ADDR_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if SRESET = '1' then
               drp_addr_i <= (others=>'0'); 
            elsif read_in_progress_i = '1' then
                drp_addr_i <= drp_rd_addr_i;
            elsif write_in_progress_i = '1' then
                drp_addr_i <= drp_wr_addr_i;
            else
                drp_addr_i <= (others=>'0');
            end if; 
        end if;
    end process;
    
    
    -- DRP write enable
    DRP_DWE <= drp_dwe_i_d;
    DWE_PROC : process(clk)
    begin
        if rising_edge(clk) then
            if SRESET = '1' then
                drp_dwe_i_d <= '0';    
            else
                drp_dwe_i_d <= drp_dwe_i;
            end if;
        end if;
    end process;
    
    -- DRP enable
    DRP_DEN <= drp_den_i;
    DEN_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            if SRESET = '1' then
                drp_den_i <= '0';
            elsif read_in_progress_i = '1' then
                drp_den_i <= rd_den_i;
            elsif write_in_progress_i = '1' then
                drp_den_i <= wr_den_i;
            else
                drp_den_i <= '0';                    
            end if;
        end if;
    end process;
    
    -- DRP data in
    DRP_DIN <= drp_din_i;
    
    -- Read Data Out
    RDOUT <= rdout_i;
    RDVAL <= rdval_i;
    RDATA_PROC : process(clk)
    begin
        if rising_edge(clk) then
            rdout_i <= DRP_DOUT;
        end if;
    end process;

    --
    -- DRP Main FSM
    --
    MAIN_FSM_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            -- synchronous reset
            if SRESET = '1' then
                clkout_id <= 0;
                pll_reset_i <= '1';
                drp_rd_addr_i <= (others=>'0');
                drp_wr_addr_i <= (others=>'0');
                drp_din_i <= (others=>'0');
                rdval_i <= '0';
                start_read_i <= '0';
                start_write_i <= '0';
                read_in_progress_i <= '0';
                write_in_progress_i <= '0';
                main_state <= ST_RST;
            else
                -- default outputs
                rdval_i <= '0';
                start_read_i <= '0';
                start_write_i <= '0';
                
                -- FSM state switching
                case (main_state) is
                 when ST_RST =>
                    if (SRESET = '0') then
                        main_state <= ST_WAIT_LOCK;
                    end if;

                 when ST_WAIT_LOCK =>
                    pll_reset_i <= '0';
                    drp_rd_addr_i <= (others=>'0');
                    drp_wr_addr_i <= (others=>'0');
                    drp_din_i <= (others=>'0');
                    
                    if pll_locked_i = '1' then
                        main_state <= ST_IDLE;
                    end if;

                 when ST_IDLE =>
                    if RSTROBE = '1' then
                        main_state <= ST_DEBUG_READ;
                    elsif NEW_CFG = '1' then
                        clkout_id <= 0;
                        main_state <= ST_PLL_RESET;
                    else
                        main_state <= ST_IDLE;
                    end if;

                 when ST_DEBUG_READ =>
                    drp_rd_addr_i <= RADDR;
                    start_read_i <= '1';
                    read_in_progress_i <= '1';
                    main_state <= ST_WAIT_DEBUG_READ_FINISH;
        
                  when ST_WAIT_DEBUG_READ_FINISH =>
                    if read_finished_i = '1' then
                        rdval_i <= '1';
                        read_in_progress_i <= '0';
                        main_state <= ST_IDLE;    
                    end if;
                    
                 when ST_PLL_RESET =>
                    pll_reset_i <= '1';
                    main_state <= ST_WRITE_POWER_REG;

                 when ST_WRITE_POWER_REG =>
                    drp_wr_addr_i <= DRP_POWER_REG_ADDR;
                    drp_din_i <= X"FFFF";
                    start_write_i <= '1';
                    write_in_progress_i <= '1';
                    main_state <= ST_WAIT_WRITE1_FINISH;
                    
                 when ST_WAIT_WRITE1_FINISH =>                    
                    if write_finished_i = '1' then
                        write_in_progress_i <= '0';
                        main_state <= ST_READ_CLKOUTN_REG1;    
                    end if;
                    
                 when ST_READ_CLKOUTN_REG1 =>
                    drp_rd_addr_i <= CLKOUT_CONFIG_ADDR_TABLE(clkout_id).reg1_addr;
                    start_read_i <= '1';
                    read_in_progress_i <= '1';
                    main_state <= ST_WAIT_READ1_FINISH;

                 when ST_WAIT_READ1_FINISH =>
                    if read_finished_i = '1' then
                        read_in_progress_i <= '0';
                        main_state <= ST_NEW_CLKOUTN_REG1;    
                    end if;

                 when ST_NEW_CLKOUTN_REG1 =>
                    drp_din_i <= (rdout_i and not DRP_CLKOUTN_PHASE_MUX_MASK) or 
                                  (phase_mux_table(clkout_id) & "0000000000000");
                    main_state <= ST_WRITE_CLKOUTN_REG1;
                    
                 when ST_WRITE_CLKOUTN_REG1 =>
                    drp_wr_addr_i <= CLKOUT_CONFIG_ADDR_TABLE(clkout_id).reg1_addr;
                    start_write_i <= '1';
                    write_in_progress_i <= '1';
                    main_state <= ST_WAIT_WRITE2_FINISH;
                    
                 when ST_WAIT_WRITE2_FINISH =>                    
                    if write_finished_i = '1' then
                        write_in_progress_i <= '0';
                        main_state <= ST_READ_CLKOUTN_REG2;    
                    end if;
                    
                 when ST_READ_CLKOUTN_REG2 =>
                    drp_rd_addr_i <= CLKOUT_CONFIG_ADDR_TABLE(clkout_id).reg2_addr;
                    start_read_i <= '1';
                    read_in_progress_i <= '1';
                    main_state <= ST_WAIT_READ2_FINISH;
                        
                 when ST_WAIT_READ2_FINISH =>
                    if read_finished_i = '1' then
                        read_in_progress_i <= '0';
                        main_state <= ST_NEW_CLKOUTN_REG2;    
                    end if;

                 when ST_NEW_CLKOUTN_REG2 =>
                   drp_din_i <= ((rdout_i and not DRP_CLKOUTN_DELAY_TIME_MASK) or 
                                ("0000000000" & phase_delay_time_table(clkout_id))) and not DRP_CLKOUTN_MX_MASK; 
                    main_state <= ST_WRITE_CLKOUTN_REG2;
              
                 when ST_WRITE_CLKOUTN_REG2 =>
                    drp_wr_addr_i <= CLKOUT_CONFIG_ADDR_TABLE(clkout_id).reg2_addr;
                    start_write_i <= '1';
                    write_in_progress_i <= '1';
                    main_state <= ST_WAIT_WRITE3_FINISH;
                    
                 when ST_WAIT_WRITE3_FINISH =>
                    if write_finished_i = '1' then
                        write_in_progress_i <= '0';
                        main_state <= ST_VERIFY_CLOCK_COUNT;    
                    end if;
                 
                 when ST_VERIFY_CLOCK_COUNT =>
                    if clkout_id = CLKOUT_ID_MAX then
                        main_state <= ST_WAIT_LOCK;
                    else
                        clkout_id <= clkout_id + 1;
                        main_state <= ST_READ_CLKOUTN_REG1;
                    end if;

                 when others =>
                    main_state <= ST_WAIT_LOCK;
                end case;
            end if;    
        end if;
    end process;

    --
    -- DRP Read FSM
    --
    Read_FSM_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            -- synchronous reset
            if SRESET = '1' then
                read_state <= ST_IDLE;
                rd_den_i <= '0';
                read_finished_i <= '0';
            else
                -- default outputs
                rd_den_i <= '0';
                read_finished_i <= '0';
                
                -- FSM state switching
                case (read_state) is
                 when ST_IDLE =>
                    if start_read_i = '1' then
                        read_state <= ST_START_READ;
                    end if;
                    
                 when ST_START_READ =>
                    rd_den_i <= '1';
                    read_state <= ST_WAIT_DRDY;
        
                  when ST_WAIT_DRDY =>
                    if drp_drdy_i = '1' then
                        read_finished_i <= '1';
                        read_state <= ST_IDLE;    
                    end if;                                

                 when others =>
                    read_state <= ST_IDLE;
                end case;
            end if;    
        end if;
    end process;

    --
    -- DRP Write FSM
    --
    WRITE_FSM_PROC : process(CLK)
    begin
        if rising_edge(CLK) then
            -- synchronous reset
            if SRESET = '1' then
                write_state <= ST_IDLE;
                wr_den_i <= '0';
                drp_dwe_i <= '0';
                write_finished_i <= '0';
            else
               -- default outputs
                wr_den_i <= '0';
                drp_dwe_i <= '0';
                write_finished_i <= '0';
            
                -- FSM state switching
                case (write_state) is
                 when ST_IDLE =>
                    if start_write_i = '1' then
                        write_state <= ST_START_WRITE;
                    end if;

                 when ST_START_WRITE =>
                    wr_den_i <= '1';
                    drp_dwe_i <= '1';
                    write_state <= ST_WAIT_DRDY;
                    
                  when ST_WAIT_DRDY =>
                    if drp_drdy_i = '1' then
                        write_finished_i <= '1';
                        write_state <= ST_IDLE;    
                    end if;                                
                    
                 when others =>
                    write_state <= ST_IDLE;
                 end case;
            end if;
         end if;
    end process;

end RTL;

