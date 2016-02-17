---------------------------------------------------------------------------------------------------
--
-- Title       : TMI_IDELAY_tune
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description :  
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;        
library Common_HDL;     
use Common_HDL.all;  

entity TMI_IDELAY_tune is
   generic(                      
      SIM_TUNE  : boolean := FALSE;  -- Perform IDELAY tuning during simulation;  
      Delay_Adjust      : boolean := TRUE;   -- Perform IDELAY Adjustment
      Fixed_Delay       : integer := 0;      -- Delay to use if Delay_Adjust is false.
      SIM_TEST : boolean := TRUE -- Permit to write test data in memory
      );
   port(  
      --------------------------------
      -- Memtest port (CLK domain)
      --------------------------------   
      START_TEST  : out std_logic;        
      TEST_DONE   : in  std_logic;
      TEST_PASS   : in  std_logic;
      --------------------------------
      -- IDELAY Interface (CLK200 domain)
      --------------------------------
      DLY_EN         : out std_logic;
      DLY_INC        : out std_logic;     
      DLY_CTRL_RDY   : in  std_logic; -- IDELAY_CTRL is ready (NOT SYNCHRONOUS)      
      --------------------------------
      -- Memory Controller Interface (CLK domain)
      --------------------------------      
      EXTRA_CYCLE    : out std_logic;
      --------------------------------
      -- Switch (CLK domain)
      --------------------------------            
      SW_SEL         : out std_logic_vector(1 downto 0);
      --------------------------------
      -- Status (CLK domain)
      --------------------------------       
      VALID_WINDOW   : out std_logic_vector(5 downto 0); 
      TUNING_DONE    : out std_logic;
      --------------------------------
      -- Others IOs
      --------------------------------       
      ARESET      : in  std_logic;
      CLK         : in  std_logic;                 
      CLK200      : in  std_logic -- For IDELAY stuff
      );
end TMI_IDELAY_tune;

architecture RTL of TMI_IDELAY_tune is      
   
   type t_detect_fsm_state is (Init, Read1, Read2, Write1, Write2, AnalyzeResponse1, AnalyzeResponse2, AnalyzeResponse3, FindDelayLimits, AdjustDelay, WaitForStableDelay, Done, unused13, unused14, unused15, unused16);
   constant DLYLEN   : integer := 6;                     
   constant max_delay : integer := 63;
   signal dly_en_i : std_logic;  
   
   signal sreset : std_logic;
   
   signal dly_inc_i : std_logic;
   
   signal extra_cycle_i  : std_logic := '0';
   signal start_test_i : std_logic := '0';
   signal busy_ad : std_logic := '1';
   
   signal test_pass_hold : std_logic := '0';
   signal test_done_hold : std_logic := '0';
   
   signal DLY_CTRL_RDY_sync : std_logic;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component double_sync 
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D : in std_logic;
         Q : out std_logic := '0';
         RESET : in std_logic;
         CLK : in std_logic
         );
   end component;
   
   component sync_rising_edge is
      port(
         Pulse : in STD_LOGIC;
         CLK : in STD_LOGIC;
         Pulse_out_sync : out STD_LOGIC
         );
   end component;
   
begin   
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   START_TEST <= start_test_i;         
   TUNING_DONE <= not busy_ad;
   
   -------------------------------------
   -- Synchronize towards CLK domain
   -------------------------------------
   
   sync_DLY_CTRL_RDY :  double_sync
   port map(d => DLY_CTRL_RDY, q => DLY_CTRL_RDY_sync, reset => '0', clk => CLK);   
   -------------------------------------
   
   -------------------------------------
   -- Synchronize towards CLK200 domain
   -------------------------------------
   --sync_dly_enable :  double_sync		     
   --   port map(d => dly_en_i, q => DLY_EN, reset => '0', clk => CLK200); 
   sync_dly_enable : sync_rising_edge
   port map (Pulse => dly_en_i, Pulse_out_sync => DLY_EN, Clk => CLK200);
   
   sync_inc :  double_sync		     
   port map(d => dly_inc_i, q => DLY_INC, reset => '0', clk => CLK200); 
   
   EXTRA_CYCLE <= extra_cycle_i;
   
   SW_SEL <= '0' & busy_ad;
   
   auto_detect_proc : process(CLK)      
      variable detect_state: t_detect_fsm_state;      
      variable delay                : unsigned(DLYLEN-1 downto 0); 
      variable FinalDelay           : std_logic;
      variable FinalCheck           : std_logic;
      variable DelayCnt             : integer range 0 to 15;                   
      constant INC : std_logic      := '1';
      constant DEC : std_logic      := '0'; 
      variable previous_st_pass     : std_logic;    
      variable first_time           : boolean;   
      variable first_pass           : std_logic;
      --constant half_period_taps     : signed(DLYLEN downto 0) := to_signed(40, DLYLEN+1); -- 40 for 160 MHz, 63 for 100 MHz
      variable target_delay         : unsigned(DLYLEN-1 downto 0); 
      variable best_delay           : unsigned(DLYLEN-1 downto 0); 
      variable best_delay_temp      : unsigned(DLYLEN downto 0); 
      variable best_window          : unsigned(DLYLEN-1 downto 0);        
      variable best_extra_cycle     : std_logic;
      variable current_window       : unsigned(DLYLEN-1 downto 0); 
      variable last_transition_delay: unsigned(DLYLEN-1 downto 0); 
      --variable target_delay_signed  : signed(DLYLEN+1 downto 0); 
      constant middle_delay         : unsigned(DLYLEN-1 downto 0) := '0' & (DLYLEN-2 downto 0 => '1');
      constant max_delay            : unsigned(DLYLEN-1 downto 0) := (others => '1'); 
      variable currently_in_valid_window : std_logic;
      
      variable test_done_hist : std_logic_vector(1 downto 0) := (others=>'0'); -- to detect a state change on the TEST_DONE input
      variable test_pass_hist : std_logic_vector(1 downto 0) := (others=>'0'); -- to detect a state change on the TEST_PASS input
      
      --   variable update_delay : std_logic := '0';
      
      constant fixed_delay_uns      : unsigned(DLYLEN-1 downto 0) := to_unsigned(Fixed_Delay, DLYLEN);
      
      attribute keep : string;
      attribute keep of detect_state   		: variable is "true";
      attribute keep of delay          		: variable is "true";
      attribute keep of FinalDelay     		: variable is "true";
      attribute keep of FinalCheck         	: variable is "true";
      attribute keep of DelayCnt           	: variable is "true";
      attribute keep of previous_st_pass   	: variable is "true";
      attribute keep of first_time         	: variable is "true";
      attribute keep of target_delay       	: variable is "true";
      attribute keep of best_window       	: variable is "true";
      attribute keep of current_window       : variable is "true";
      attribute keep of last_transition_delay: variable is "true";
      
   begin        
      
      if rising_edge(CLK) then
         if sreset = '1' then          
            dly_en_i <= '0';
            detect_state := Init;  
            DelayCnt := 0;               
            delay := to_unsigned(0, delay'LENGTH);  -- Only reset the delay during reset, NOT during Init state.
            extra_cycle_i <= '0';
            test_pass_hold <= '0';
            test_done_hold <= '0';
            test_pass_hist := (others => '0');
            test_done_hist := (others => '0');
            busy_ad <= '1';               
            
            start_test_i <= '0'; 
            dly_inc_i <= INC;
            FinalDelay := '0';
            FinalCheck := '0'; 
            best_window := (others => '0'); 
            best_delay  := (others => '0'); 
            best_extra_cycle := '0';
            current_window := (others => '0');           
            currently_in_valid_window := '0';
            last_transition_delay := (others => '0');
            VALID_WINDOW <= (others => '0');
            target_delay := middle_delay;
            first_time := true;   
            first_pass := '1';
         else      
            
            if test_pass_hist = "01" then
               test_pass_hold <= '1';
            end if;
            test_pass_hist := test_pass_hist(0) & TEST_PASS;
            
            if test_done_hist = "01" then
               test_done_hold <= '1';
            end if;
            test_done_hist := test_done_hist(0) & TEST_DONE;
            
            
            case detect_state is
               
               when Init =>    
                  start_test_i <= '0';
                  busy_ad <= '1';
                  dly_en_i <= '0'; 
                  dly_inc_i <= INC;
                  FinalDelay := '0';
                  FinalCheck := '0'; 
                  best_window := (others => '0'); 
                  best_delay  := (others => '0'); 
                  best_extra_cycle := '0';
                  current_window := (others => '0');           
                  currently_in_valid_window := '0';
                  last_transition_delay := (others => '0');
                  VALID_WINDOW <= (others => '0');
                  target_delay := middle_delay;   
                  extra_cycle_i <= '0';
                  first_time := true;   
                  first_pass := '1';
                  if true 
                  -- translate_off
                  and (SIM_TEST)
                  -- translate_on
                  then
                     if DelayCnt = 15 and DLY_CTRL_RDY_sync = '1' then
                        detect_state := Write1;                         
                        DelayCnt := 0;
                     elsif DelayCnt < 15 then
                        DelayCnt := DelayCnt + 1; -- To make sure that all the clocks are stable enough.
                     end if;
                  else
                     detect_state := Done;
                  end if;
               
               when Write1 =>    
                  if FinalDelay = '0' or FinalCheck = '1' then                        
                     start_test_i <= '1';   
                  end if;                                      
                  --previous_st_pass := test_pass_hold;
                  test_pass_hold <= '0';
                  detect_state := AnalyzeResponse2;
               
               when AnalyzeResponse2 =>
                  if FinalDelay = '0' or FinalCheck = '1' then                        
                     start_test_i <= '0';   
                     if DelayCnt = 4 then  
                        DelayCnt := 0; 
                        if test_done_hold = '1' then  
                           test_done_hold <= '0';
                           if first_time then
                              first_time := false;        
                              previous_st_pass := test_pass_hold;
                              if test_pass_hold = '1' then
                                 currently_in_valid_window := '1';
                              end if;
                           end if;
                           detect_state := AnalyzeResponse3;                                                                                                                         
                           
                        end if;   
                     else   
                        DelayCnt := DelayCnt + 1;
                     end if;     
                  else
                     detect_state := AdjustDelay;
                  end if;
                  
               
               when AnalyzeResponse3 =>    
                  
                  if FinalCheck = '1' then
                     detect_state := Done;
                  elsif FinalDelay = '1'  then
                     detect_state := AdjustDelay;
                  else
                     detect_state := FindDelayLimits;
                  end if;                                            
                  
               
               when FindDelayLimits =>   
                  if Delay_Adjust = FALSE 
                     -- translate_off
                     or (SIM_TUNE = FALSE)
                     -- translate_on
                     then
                     target_delay := fixed_delay_uns;  
                     detect_state := AdjustDelay;
                  else  
                     if previous_st_pass = '0' and test_pass_hold = '1' then
                        -- Found BAD -> GOOD transition    
                        current_window := (others => '0');
                        currently_in_valid_window := '1';
                        last_transition_delay := delay;
                        
                     elsif (previous_st_pass = '1' and test_pass_hold = '0') 
                        or (delay = max_delay and currently_in_valid_window = '1') then
                        -- Found GOOD -> BAD transition                          
                        currently_in_valid_window := '0';
                        if current_window > best_window then
                           best_window  := current_window;  
                           best_extra_cycle := extra_cycle_i;
                           VALID_WINDOW <= std_logic_vector(current_window);
                           best_delay_temp := delay + resize(last_transition_delay, best_delay_temp'LENGTH);
                           best_delay := resize(best_delay_temp / 2, best_delay'LENGTH);
                        end if;
                        current_window := (others => '0');  
                     end if;
                     
                     if delay = max_delay then
                        -- Reached limit of the range. Time to make final choice.
                        detect_state := AdjustDelay;   
                        if first_pass = '1' then
                           target_delay := (others => '0');  
                           current_window := (others => '0');  
                           last_transition_delay := (others => '0');
                           extra_cycle_i <= '1'; 
                        else
                           target_delay := best_delay;
                           extra_cycle_i <= best_extra_cycle;
                        end if;
                     else
                        dly_inc_i <= INC;  
                        dly_en_i <= '1';
                        --delay := delay + 1; 
                        if currently_in_valid_window = '1' then
                           current_window := current_window +1 ;
                        end if;
                        detect_state := WaitForStableDelay;
                     end if;                         
                  end if;
               
               when AdjustDelay =>  
                  
                  FinalDelay := '1';
                  previous_st_pass := test_pass_hold;
                  --test_pass_hold <= '0';
                  if delay > target_delay then
                     dly_inc_i <= DEC; -- Decrement delay    
                     dly_en_i <= '1';                                  
                     --delay := delay - 1;
                     detect_state := WaitForStableDelay;
                  elsif delay < target_delay then
                     dly_inc_i <= INC; -- Increment delay   
                     dly_en_i <= '1';                                  
                     --delay := delay + 1;
                     detect_state := WaitForStableDelay;                        
                  else  
                     dly_en_i <= '0';                                 
                     detect_state := Write1;
                     if first_pass = '1' then
                        first_pass := '0';
                        FinalCheck := '0';  
                        FinalDelay := '0';
                     else
                        FinalCheck := '1';                                                                                                                               
                     end if;
                  end if;   
               
               when WaitForStableDelay =>  
                  dly_en_i <= '0';
                  --detect_state := Write1;                                     
                  -- test_pass_hold <= '0';
                  previous_st_pass := test_pass_hold;
                  
                  if DelayCnt = 15 then
                     if dly_inc_i = DEC then
                        delay := delay - 1;
                     else
                        delay := delay + 1;
                     end if;
                     DelayCnt := 0;
                     detect_state := Write1;
                  else
                     DelayCnt := DelayCnt + 1;
                  end if;
               
               when Done =>          
                  busy_ad <= '0';
               
               when others =>
                  detect_state := Init;
               
            end case;               
            
         end if;
      end if;
   end process;
   
end RTL;
