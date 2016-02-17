--------------------------------------------------------------------------------------------------
--
-- Title       : TMI_memtest
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
library work;
use work.LfsrStd_Pkg.all;

entity TMI_memtest is
   generic(
      Random_Pattern : boolean := TRUE;   -- Pseudo-random data pattern for self-test. Linear data is false.
      Random_dval : boolean := FALSE; -- pseudo-random dval pattern
      random_dval_seed : std_logic_vector(3 downto 0) := x"1"; -- --Pseudo-random generator seed
      DLEN : natural := 32;
      ALEN : natural := 21);
   port(
      --------------------------------
      -- Control port
      --------------------------------
      START_TEST  : in  std_logic;        -- Needs a 0 to 1 transition to trigger another test. Can be tied to '1' to execute test once after reset.
      TEST_DONE   : out std_logic;
      TEST_PASS   : out std_logic;
      ERR_FLAG    : out std_logic_vector(1 downto 0);
      --------------------------------
      -- TMI Interface
      --------------------------------
      TMI_IDLE    : in  std_logic;
      TMI_ERROR   : in  std_logic;
      TMI_RNW     : out std_logic;
      TMI_ADD     : out std_logic_vector(ALEN-1 downto 0);
      TMI_DVAL    : out std_logic;
      TMI_BUSY    : in  std_logic;
      TMI_RD_DATA : in  std_logic_vector(DLEN-1 downto 0);
      TMI_RD_DVAL : in  std_logic;
      TMI_WR_DATA : out std_logic_vector(DLEN-1 downto 0);
      
      --------------------------------
      -- Others IOs
      --------------------------------
      ARESET      : in  std_logic;
      CLK         : in  std_logic              
      );
end TMI_memtest;

architecture RTL of TMI_memtest is
   
   signal SIM : std_logic;
   constant TESTLEN : integer := ALEN
   -- translate_off
   - (ALEN-7)
   -- translate_on
   ;              
   signal long_seed_WR   : std_logic_vector(19 downto 0);
   signal long_seed_RD   : std_logic_vector(19 downto 0);
   signal LFSR_seed_WR   : std_logic_vector(TESTLEN-1 downto 0);
   signal LFSR_seed_RD   : std_logic_vector(TESTLEN-1 downto 0);
   
   --pragma translate_off
   signal random_vec : unsigned(7 downto 0) := (others => '0');
   --pragma translate_on
   
   signal busy       : std_logic := '0';
   signal request_st : std_logic := '0';
   
   signal test_pass_i : std_logic := '0';
   signal test_done_i : std_logic := '0';
   signal test_pass_r1 : std_logic := '0';
   signal test_done_r1 : std_logic := '0';
   
   signal rd_data_i  : std_logic_vector(DLEN-1 downto 0);
   signal rd_data_i_r1 : std_logic_vector(DLEN-1 downto 0);
   signal rd_data_i_r2 : std_logic_vector(DLEN-1 downto 0);
   signal data_golden : std_logic_vector(DLEN-1 downto 0);
   signal data_golden_r1 : std_logic_vector(DLEN-1 downto 0);
   signal rd_dval_i : std_logic := '0';
   signal rd_dval_i_r1 : std_logic := '0';
   signal rd_dval_i_r2 : std_logic := '0';
   signal wr_data_i : std_logic_vector(DLEN-1 downto 0);
   signal err_flag_i : std_logic_vector(1 downto 0) := (others=>'0');
   signal err_flag_r1 : std_logic_vector(1 downto 0) := (others=>'0');
   
   signal wr_data_r1 : std_logic_vector(DLEN-1 downto 0);
   signal tmi_add_i : std_logic_vector(ALEN-1 downto 0);
   signal tmi_add_r1 : std_logic_vector(ALEN-1 downto 0);
   signal tmi_dval_r1 : std_logic := '0';
   signal tmi_dval_i : std_logic;
   signal tmi_rnw_i : std_logic;
   signal tmi_rnw_r1 : std_logic;
   signal tmi_idle_r1 : std_logic;
   signal tmi_idle_i : std_logic;
   
   signal sreset    : std_logic := '0';
   
   signal enable	: std_logic := '1';
   signal lfsr_reg     : std_logic_vector(15 downto 0) := (others => '0');   -- To avoid X in simulation
   signal lfsr_in  : std_logic;
   
   type fsm_state_t is (Idle, Init, DoTest, EndTest, WaitForIdle, Done, unused7, unused8);
   signal state : fsm_state_t;
   
   constant NO_ERR_FLAG : std_logic_vector(1 downto 0) := "00";
   constant TEST_FAILED_FLAG : std_logic_vector(1 downto 0) := "01";
   constant TMI_ERR_FLAG : std_logic_vector(1 downto 0) := "10";
   
   attribute keep : string;
   attribute keep of TEST_PASS : signal is "true";
   attribute keep of TEST_DONE : signal is "true";
   
   function RESIZE (ARG: STD_LOGIC_VECTOR; NEW_SIZE: NATURAL) return
      STD_LOGIC_VECTOR is
   begin
      return(STD_LOGIC_VECTOR(RESIZE(UNSIGNED(ARG), NEW_SIZE)));
   end;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
begin
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => SRESET, CLK => CLK);
   
   TEST_PASS <= test_pass_r1;
   TEST_DONE <= test_done_r1;
   
   TMI_WR_DATA <= wr_data_r1;
   rd_data_i <= TMI_RD_DATA;
   rd_dval_i <= TMI_RD_DVAL;
   TMI_ADD <= tmi_add_r1;
   TMI_RNW <= tmi_rnw_r1;
   TMI_DVAL <= tmi_dval_r1;
   tmi_idle_i <= TMI_IDLE;
   
   ERR_FLAG <= err_flag_r1;
   
   -- start the test only when a pulse is detected on START_TEST and the server side is not busy
   detect_start_test: process(CLK)
      variable start_test_hist : std_logic_vector(1 downto 0) := "00";
   begin
      if rising_edge(CLK) then
         if SRESET = '1' then
            start_test_hist := (others => '0');
            request_st <= '0';
         else
            if start_test_hist = "01" then
               request_st <= '1';
            elsif busy = '1' then
               request_st <= '0';
            end if;
            start_test_hist := start_test_hist(0) & START_TEST;
         end if;
      end if;
   end process;
   
   Random_Pattern_TRUE : if Random_Pattern generate
      long_seed_WR <= x"E9D30";
      long_seed_RD <= x"A1E24";
      LFSR_seed_WR <= resize(long_seed_WR, TESTLEN);
      LFSR_seed_RD <= resize(long_seed_RD, TESTLEN);
   end generate Random_Pattern_TRUE;
   
   Random_Pattern_FALSE : if not Random_Pattern generate
      long_seed_WR <= (others => '0');
      long_seed_RD <= (others => '0');
      LFSR_seed_WR <= (others => '0');
      LFSR_seed_RD <= (others => '0');
   end generate Random_Pattern_FALSE;
   
   Rand_dval_false : if Random_dval = false generate	
      enable <= '1';
   end generate Rand_dval_false;
   
   Rand_dval_true : if Random_dval= true generate 
      
      ------------------------------------------------
      -- Process for pseudo-random generator
      ------------------------------------------------
      lfsr_in <= lfsr_reg(1) xor lfsr_reg(2) xor lfsr_reg(4) xor lfsr_reg(15);
      process(CLK)
      begin
         if rising_edge(CLK) then
            lfsr_reg(0) <= lfsr_in;
            lfsr_reg(15 downto 2) <= lfsr_reg(14 downto 1);
            
            if sreset = '1' then
               lfsr_reg(0) <= random_dval_seed(0); -- We need at least one '1' in the LFSR to activate it.
               lfsr_reg(2) <= random_dval_seed(1);
               lfsr_reg(3) <= random_dval_seed(2); 
               lfsr_reg(5) <= random_dval_seed(3);
            else
               lfsr_reg(1) <= lfsr_reg(0);   
            end if;
         end if;
      end process;			
      
      ------------------------------------------------
      -- Process to emulate a memory BUSY (TMI_BUSY)
      -- signal.
      ------------------------------------------------
      process(CLK)
      begin
         if rising_edge(CLK) then
            if sreset = '1' then
               enable <= '1';					
            else		
               enable <= lfsr_reg(7);
            end if;
         end if;
      end process;	
   end generate Rand_dval_true;
   
   SIM <= 'L';
   -- pragma translate_off
   SIM <= '1';
   -- pragma translate_on
   
   pipe_outputs : process(CLK)
   begin
      if rising_edge(CLK) then
         if TMI_BUSY = '0' then
            wr_data_r1 <= wr_data_i;
            tmi_dval_r1 <= tmi_dval_i;
            tmi_rnw_r1 <= tmi_rnw_i;
            tmi_add_r1 <= tmi_add_i;
         end if;
         test_pass_r1 <= test_pass_i;
         test_done_r1 <= test_done_i;
         err_flag_r1 <= err_flag_i;
      end if;
   end process;
   
   pipe_inputs : process(CLK)
   begin
      if rising_edge(CLK) then
         rd_data_i_r1 <= rd_data_i;
         rd_data_i_r2 <= rd_data_i_r1;
         data_golden_r1 <= data_golden;
         rd_dval_i_r1 <= rd_dval_i;
         rd_dval_i_r2 <= rd_dval_i_r1;
         tmi_idle_r1 <= tmi_idle_i;
      end if;
   end process;
   
   self_test_proc : process(CLK)
      variable wr_add_test : std_logic_vector(TESTLEN-1 downto 0) := (others=>'0');
      variable wr_add_test_full : std_logic_vector(ALEN-1 downto 0) := (others=>'0');
      variable rd_add_test : std_logic_vector(TESTLEN-1 downto 0) := (others=>'0');
      variable rd_add_test_full : std_logic_vector(ALEN-1 downto 0) := (others=>'0');
      variable rd_add_check : std_logic_vector(TESTLEN-1 downto 0) := (others=>'0');
      variable enable_read : std_logic;
      variable enable_write : std_logic;
      variable error_found : std_logic;
      variable error_found_r1 : std_logic;
      
      variable wr_looped_once : std_logic;
      variable rd_looped_once : std_logic;
      
      variable test_phase : std_logic := '0'; -- '0' write action, '1' read action
      variable validate_readout : std_logic := '0'; -- used to compute golden sdata and compare over 2 CLK cycles instead of one
      
      constant WRITE_PHASE : std_logic := '0';
      constant READ_PHASE : std_logic := '1';
      
      function ADD_to_DATA(add : std_logic_vector; seed : std_logic_vector) return std_logic_vector is
         variable data : unsigned(DLEN-1 downto 0);
         variable add_full : unsigned(ALEN-1 downto 0);
      begin
         
         -- First, adjust address length
         add_full := resize(unsigned(add), ALEN);
         
         -- Do xor with seed to scramble data
         data := resize(add_full, DLEN) xor resize(unsigned(seed), DLEN); -- This is to make data different than address.
         
         if ALEN > DLEN then
            -- Add the address LSBs to make sure that the data doesn't repeat (if there are more address bits than data bits).
            data := data + add_full(ALEN-1 downto DLEN);
         else
            -- Make sure to fill the whole data range with data and not zeros
            data := resize(data(ALEN-1 downto 0) & data(ALEN-1 downto 0), DLEN);
         end if;
         
         return std_logic_vector(data);
         
      end function ADD_to_DATA;
      
      function myLFSR(S : Std_Logic_Vector) return Std_Logic_Vector is
      begin
         if Random_Pattern then
            return LFSR(S);
         else
            return Std_Logic_Vector(unsigned(S) + 1);
         end if;
      end function;
      
   begin  
      
      if rising_edge(CLK) then
         if sreset = '1' then
            state <= Idle;
            busy <= '0';
            test_pass_i <= '0';
            test_done_i <= '0';
            error_found := '0';
            tmi_dval_i <= '0';
            tmi_rnw_i <= '0';
            tmi_add_i <= (others=>'0');
            err_flag_i <= NO_ERR_FLAG;
         else
            error_found_r1 := error_found;
            
            case state is
               
               when Idle =>         
                  busy <= '0';
                  if request_st = '1' and TMI_BUSY = '0' then
                     state <= Init;
                     busy <= '1';
                  end if;
               
               when Init =>
                  busy <= '1';
                  tmi_dval_i <= '0';
                  wr_add_test := LFSR_seed_WR;
                  rd_add_test := LFSR_seed_RD;
                  rd_add_check := LFSR_seed_RD;
                  enable_write := '1';
                  enable_read := '0';
                  test_pass_i <= '0';
                  test_done_i <= '0';
                  error_found := '0';
                  state <= DoTest;
                  wr_looped_once := '0';
                  rd_looped_once := '0';
                  test_phase := WRITE_PHASE;
                  err_flag_i <= NO_ERR_FLAG;
                  
                  -- write address computed for next write phase
                  wr_add_test := myLFSR(wr_add_test);                         
                  wr_add_test_full := std_logic_vector(resize(wr_add_test, ALEN)); 
                  
               
               when DoTest =>   
                  if TMI_BUSY = '0' then
                     if enable = '1' then 
                        if test_phase = WRITE_PHASE then
                           if enable_write = '1' then
                              busy <= '1';   
                              tmi_dval_i <= '1'; 
                              tmi_rnw_i <= '0';
                              
                              -- wr_add_test := myLFSR(wr_add_test);                         
                              --wr_add_test_full := std_logic_vector(resize(wr_add_test, ALEN)); 
                              tmi_add_i <= wr_add_test_full;    
                              wr_data_i <= ADD_to_DATA(wr_add_test_full, long_seed_WR);
                              
                              -- Stop the write process when we went through all addresses twice.
                              if wr_add_test = LFSR_seed_WR then -- We looped once thru the addresses.
                                 if wr_looped_once = '1' then
                                    enable_write := '0'; -- We stop.
                                 else
                                    enable_read := '1'; 
                                    wr_looped_once := '1';
                                 end if;
                              end if;
                              
                              if enable_read = '1' then
                                 test_phase := READ_PHASE;
                                 -- compute read address for next write phase
                                 rd_add_test := myLFSR(rd_add_test);           
                              end if;
                              -- else
                              --                                 -- compute write address for next read phase
                              wr_add_test := myLFSR(wr_add_test);                         
                              wr_add_test_full := std_logic_vector(resize(wr_add_test, ALEN)); 
                              --                              end if;
                              
                           else
                              tmi_dval_i <= '0'; 
                           end if;
                           
                        else -- read phase
                           if enable_read = '1' then
                              tmi_rnw_i <= '1'; 
                              tmi_dval_i <= '1'; 
                              
                              --rd_add_test := myLFSR(rd_add_test);                                                                                                                   
                              tmi_add_i <= std_logic_vector(resize(rd_add_test, ALEN));                          
                              
                              -- Stop the read process when we went through all addresses twice.    
                              if rd_add_test = LFSR_seed_RD then -- We looped once thru the addresses.
                                 if rd_looped_once = '1' then
                                    enable_read := '0'; -- We stop.
                                 else                              
                                    rd_looped_once := '1';
                                 end if;
                              end if;                        
                              
                              if enable_write = '1' then
                                 test_phase := WRITE_PHASE;
                                 -- compute write address for next read phase
                                 --wr_add_test := myLFSR(wr_add_test);                         
                                 --                                 wr_add_test_full := std_logic_vector(resize(wr_add_test, ALEN)); 
                              else
                                 -- compute read address for next read phase
                                 rd_add_test := myLFSR(rd_add_test);
                              end if;
                           else   
                              tmi_dval_i <= '0';
                           end if;
                        end if; 
                     else
                        tmi_dval_i <= '0'; 
                     end if; 
                     
                  end if;
                  
                  if rd_dval_i_r2 = '1' then
                     if rd_data_i_r2 /= data_golden_r1 then 
                        error_found := '1';    
                        assert FALSE report "ZBT self-test error found!" severity ERROR;                        
                     end if;
                  end if;
                  
                  -- Process read data
                  if busy = '1' and rd_dval_i = '1' then
                     
                     -- compute golden_data and defer comparison to the next CLK cycle
                     rd_add_check := myLFSR(rd_add_check);                             
                     data_golden <= ADD_to_DATA(rd_add_check, long_seed_WR);
                     
                     --        if rd_data_i /= data_golden then 
                     --                     error_found := '1';    
                     --                     assert FALSE report "ZBT self-test error found!" severity ERROR;                        
                     --                  end if;   
                  end if;
                  
                  -- Release hold from self-test when done
                  if (enable_read = '0' and enable_write = '0' and tmi_idle_r1 = '1') or error_found_r1 = '1' then                        
                     --if error_found_r1 = '0' then
                     --                        test_pass_i <= '1';
                     --                        err_flag_i <= NO_ERR_FLAG;
                     --                     else
                     --                        err_flag_i <= TEST_FAILED_FLAG;
                     --                     end if;  
                     tmi_dval_i <= '0';
                     state <= EndTest;
                  end if;
               
               when EndTest =>
                  if error_found = '0' then
                     if TMI_ERROR = '1' then
                        test_pass_i <= '0';
                        err_flag_i <= TMI_ERR_FLAG;
                     else
                        test_pass_i <= '1';
                        err_flag_i <= NO_ERR_FLAG;
                     end if;
                  else
                     err_flag_i <= TEST_FAILED_FLAG;
                  end if;
                  state <= WaitForIdle;
               
               when WaitForIdle =>
                  if tmi_idle_r1 = '1' then
                     state <= Done;
                     busy <= '0';
                  end if;
               
               when Done =>
                  test_done_i <= '1';
                  if request_st = '1' then
                     state <= Init;
                  end if;
               
               when others =>
               state <= Idle;
            end case;
            
            if TMI_ERROR = '1' then
               tmi_dval_i <= '0';
               state <= WaitForIdle;
               err_flag_i <= TMI_ERR_FLAG;
            end if;
         end if; -- if reset else
      end if; -- rising_edge
   end process;
   
end RTL;
