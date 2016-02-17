---------------------------------------------------------------------------------------------------
--
-- Title       : LL_AOI_Add_Gen
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- Description : LocalLink Area Of Interrest Address Generator.
--               This module generates LocalLink addresses for a subwindow, a.k.a. Area Of Interest
--               or AOI.
--
---------------------------------------------------------------------------------------------------

library IEEE;
library COMMON_HDL;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use common_hdl.all;

entity LL_AOI_Add_Gen is
   generic(          
      XLEN : natural := 9;
      ALEN : natural := 21);  
   port(  
      --------------------------------
      -- Configuration port (can be mapped to Wishbone)
      --------------------------------   
      CFG_START_ADD  : in  std_logic_vector(ALEN-1 downto 0);  -- Memory start address
      CFG_END_ADD    : in  std_logic_vector(ALEN-1 downto 0);  -- Memory stop address 
      CFG_STEP_ADD   : in  std_logic_vector(XLEN downto 0);  -- SIGNED - STEP between each adresse
      CFG_WIDTH      : in  std_logic_vector(XLEN-1 downto 0);  -- Width of each image. When the number of addresses increments (add_cnt) reaches add_cnt % WIDTH = 0, a number of addresses will be skipped.
      CFG_SKIP       : in  std_logic_vector(ALEN downto 0);  -- SIGNED -Number of addresses to skip when add_cnt % WIDTH = 0
      CFG_CONTROL    : in  std_logic_vector(2 downto 0);       -- CFG_CONTROL(0): START. Start the reading of data from memory                                   
      -- CFG_CONTROL(1): STOP. Normal stop, stop after reaching END_ADD (only used if LOOP=1)                                                         
      -- CFG_CONTROL(2): IMMEDIATE_STOP. Emergency stop, do not wait until END_ADD    
      CFG_DONE       : out std_logic;                          -- Done is 1 when all activity is done, no more pending memory transactions (TMI_IDLE = 1) and no more data in fifos.
      CFG_IN_PROGRESS: out std_logic;                          -- Done is 1 when at least one address is out on the ADD_LL link.
      CFG_CONFIG     : in  std_logic_vector(4 downto 0);       -- CFG_CONFIG(0): LOOP. When END_ADD is reached, don't stop and restart at START_ADD.
      -- CFG_CONFIG(1): Start Of Address. Generate a SOF at START_ADD.
      -- CFG_CONFIG(2): End Of Address. Generate a EOF at END_ADD.
      -- CFG_CONFIG(3): Start Of Line. Generate a SOF at the beginning of a line (just after skipping addresses)
      -- CFG_CONFIG(4): End Of Line. Generate a EOF at the end of a line (just before skipping addresses)
      
      --------------------------------
      -- Outgoing Addresses
      --------------------------------   
      ADD_LL_SOF	 : out std_logic;
      ADD_LL_EOF	 : out std_logic;
      ADD_LL_DATA  : out std_logic_vector(ALEN-1 downto 0);      
      ADD_LL_DVAL	 : out std_logic;
      ADD_LL_SUPPORT_BUSY : out std_logic;
      ADD_LL_BUSY  : in  std_logic;      
      ADD_LL_AFULL : in  std_logic;
      --------------------------------
      -- Others IOs
      -------------------------------- 
      IDLE        : in  std_logic;
      ERROR       : out std_logic;
      ARESET      : in  std_logic;
      CLK_DATA    : in  std_logic;                 -- Clk domain for TMI and LocalLink ports
      CLK_CTRL    : in  std_logic                  -- Clk domain for CFG port
      );
end LL_AOI_Add_Gen;

architecture RTL of LL_AOI_Add_Gen is      
   
   signal add_cnt : signed(ALEN downto 0);    -- This signal increments every time ADD_LL_DATA changes.
   signal width_cnt : signed(XLEN+1 downto 0);    -- This signal increments every time ADD_LL_DATA changes and reset after each line.
   signal sreset_data : std_logic;
   signal sreset_ctrl : std_logic;
   signal cfg_Done_i : std_logic;
   signal cfg_Start_i : std_logic;   
   signal cfg_Stop_i : std_logic;
   signal cfg_StopImmediate_i : std_logic;
   signal cfg_Start_i_p1 : std_logic;
   signal cfg_Start_REdge : std_logic; 
   signal CFG_START_ADD_reg : signed(ALEN downto 0);  -- Copy in case it changes in the middle of an image (it can and it will).
   signal CFG_END_ADD_reg : signed(ALEN downto 0);    -- Copy in case it changes in the middle of an image (it can and it will).
   signal CFG_STEP_ADD_reg : signed(XLEN downto 0);    -- Copy in case it changes in the middle of an image (it can and it will).
   signal CFG_SKIP_ADD_reg : signed(ALEN downto 0);   -- Copy in case it changes in the middle of an image (it can and it will).
   signal CFG_WIDTH_ADD_reg : signed(XLEN downto 0);   -- Copy in case it changes in the middle of an image (it can and it will).   
   signal in_progress : std_logic;
   
   signal last_pixel_add : signed(ALEN downto 0);
   
   signal add_dval : std_logic;
   
   signal Stop_Request : std_logic; 
   signal Pending_Done : std_logic;
   
   type State_t is (sIdle, sRunning);
   signal ll_state : State_t;
   
   component sync_reset is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   component double_sync
      generic(
         INIT_VALUE : BIT := '0');
      port(
         D : in STD_LOGIC;
         Q : out STD_LOGIC;
         RESET : in STD_LOGIC;
         CLK : in STD_LOGIC);
   end component;
   
   
   alias aStart : std_logic is CFG_CONTROL(0);  -- Start
   alias aStop : std_logic is CFG_CONTROL(1);   -- Stop in loop mode
   alias aStopImmediate : std_logic is CFG_CONTROL(2);   -- Immediate Stop
   alias aLoop : std_logic is CFG_CONFIG(0); -- Loop mode
   alias aSOA : std_logic is CFG_CONFIG(1);  -- Start of address
   alias aEOA : std_logic is CFG_CONFIG(2);  -- End of address
   alias aSOL : std_logic is CFG_CONFIG(3);  -- Start of line
   alias aEOL : std_logic is CFG_CONFIG(4);  -- End of line
   
   
   --signal sm_done : std_logic;
   
   
begin                      
   
   sync_RST_ctrl : sync_reset
   port map(ARESET => ARESET, SRESET => sreset_ctrl, CLK => CLK_CTRL); 
   
   sync_RST_data : sync_reset
   port map(ARESET => ARESET, SRESET => sreset_data, CLK => CLK_DATA);      
   
   CFG_Done_double_sync : double_sync
   port map(D => cfg_Done_i, Q => CFG_DONE, RESET => sreset_ctrl, CLK => CLK_CTRL);
   
   CFG_progress_sync : double_sync
   port map(D => in_progress, Q => CFG_IN_PROGRESS, RESET => sreset_ctrl, CLK => CLK_CTRL);   
   
   CFG_Start_double_sync : double_sync
   port map(D => aStart, Q => cfg_Start_i, RESET => sreset_data, CLK => CLK_DATA);
   
   CFG_Stop_double_sync : double_sync
   port map(D => aStop, Q => cfg_Stop_i, RESET => sreset_data, CLK => CLK_DATA);
   
   CFG_StopImmediate_double_sync : double_sync
   port map(D => aStopImmediate, Q => cfg_StopImmediate_i, RESET => sreset_data, CLK => CLK_DATA);
   
   ERROR <= '0';
   ADD_LL_SUPPORT_BUSY <= '1'; 
   
   ADD_LL_DVAL <= add_dval;
   
   -- Rising edge detection
   process(CLK_DATA)
   begin 
      if rising_edge(CLK_DATA) then
         if (sreset_data = '1')  then
            cfg_Start_REdge <= '0';
            cfg_Start_i_p1 <= '0';
         else
            cfg_Start_i_p1 <= cfg_Start_i;
            if(cfg_Start_i = '1' and cfg_Start_i_p1 = '0') then
               cfg_Start_REdge <= '1';
            elsif(ADD_LL_BUSY = '0') then
               cfg_Start_REdge <= '0';
            end if;
         end if;
      end if;
   end process;
   
   -- Local Link State.  Domain clock CLK_DATA
   
   
   
   process(CLK_DATA)
   begin
      if(rising_edge(CLK_DATA)) then
         if (sreset_data = '1') then
            --sm_done <= '0';  --- Like is busy.
            ll_state <= sIdle;       
            add_dval <= '0';
            ADD_LL_SOF <= '0';
            ADD_LL_EOF <= '0';
            ADD_LL_DATA <= (others => '0');
            Stop_Request <= '0'; 
            Pending_Done <= '1';
            cfg_Done_i <= '0';   
            in_progress <= '0';
			   CFG_END_ADD_reg <= (others => '0');
            CFG_STEP_ADD_reg <= (others => '0');
            last_pixel_add <= (others => '0');
         else      
			
            if (cfg_Stop_i = '1') then
               Stop_Request <= '1';
            end if;                               
            
            if (Pending_Done = '1' and IDLE = '1') then
               cfg_Done_i <= '1'; 
               Pending_Done <= '0';
            end if;        
            
            if (ADD_LL_BUSY = '0' and add_dval = '1') then 
               in_progress <= '1';    
            end if;
            
            case ll_state is
               when sIdle =>    
                  in_progress <= '0';
                  if (ADD_LL_BUSY = '0') then
                     if (ADD_LL_AFULL = '0') then
                        ADD_LL_SOF <= '0';
                        ADD_LL_EOF <= '0';
                        add_dval <= '0';
                        --sm_done <= '1'; 
                        Stop_Request <= '0';
                        if(cfg_Start_REdge = '1') then
                           cfg_Done_i <= '0';  
                           --sm_done <= '0'; 
                           ll_state <= sRunning;
                           add_cnt <= signed('0' & CFG_START_ADD);
                           CFG_START_ADD_reg <= signed('0' & CFG_START_ADD);
                           CFG_END_ADD_reg <= signed('0' & CFG_END_ADD);
                           CFG_STEP_ADD_reg <= signed(CFG_STEP_ADD);
                           CFG_SKIP_ADD_reg <= signed(CFG_SKIP);
                           CFG_WIDTH_ADD_reg <= signed('0' & CFG_WIDTH);
                           last_pixel_add <= signed('0' & CFG_END_ADD);
                           width_cnt <= (others => '0');
                        end if;        
                     end if;
                  end if;                        

               when sRunning =>
                  --sm_done <= '0'; 
                  if (ADD_LL_BUSY = '0') then
                     if (ADD_LL_AFULL = '0') then                          
                        add_dval <= '1';
                        ADD_LL_SOF <= '0';
                        ADD_LL_EOF <= '0';
                        ADD_LL_DATA <= std_logic_vector(add_cnt(ALEN-1 downto 0));
                        add_cnt <= add_cnt + CFG_STEP_ADD_reg;
                        width_cnt <= width_cnt + abs(CFG_STEP_ADD_reg);
                        -- Check if Start of address or Start of line
                        if((width_cnt = 0 and aSOL = '1') or (add_cnt = CFG_START_ADD_reg and aSOA = '1')) then
                           ADD_LL_SOF <= '1';
                        end if;
                        -- Check if End of address or End of line
                        if((width_cnt >= CFG_WIDTH_ADD_reg and aEOL = '1') or (((add_cnt = last_pixel_add )  and aEOA = '1'))) then
                           ADD_LL_EOF <= '1';
                        end if;
                        -- Check if end of width then skip
                        if (width_cnt >= CFG_WIDTH_ADD_reg) then
                           add_cnt <= (add_cnt + CFG_SKIP_ADD_reg);
                           width_cnt <= (others => '0');
                        end if;
                        -- Check if end of address then stop or contiue
                        --if((add_cnt  >= last_pixel_add) and aLOOP = '0') then
                        if((add_cnt  = last_pixel_add) and aLOOP = '0') then   
                           ll_state <= sIdle;
                           Pending_Done <= '1';
                        elsif((add_cnt  = last_pixel_add) and aLoop = '1') then
                           add_cnt <= signed('0' & CFG_START_ADD);
                           CFG_START_ADD_reg <= signed('0' & CFG_START_ADD);
                           CFG_END_ADD_reg <= signed('0' & CFG_END_ADD);
                           CFG_WIDTH_ADD_reg <= signed('0' & CFG_WIDTH);
                           CFG_STEP_ADD_reg <= signed(CFG_STEP_ADD);
                           CFG_SKIP_ADD_reg <= signed(CFG_SKIP);
                           last_pixel_add <= signed('0' & CFG_END_ADD);
                           if (Stop_Request = '1') then
                              ll_state <= sIdle;
                              Pending_Done <= '1';
                           end if;
                        end if;
                     else
                        add_dval <= '0';
                     end if; -- if (ADD_LL_AFULL = '0')
                  end if; -- if (ADD_LL_BUSY = '0')
                  
                  -- Check if Immediate Stop
                  if(cfg_StopImmediate_i = '1') then
                     ll_state <= sIdle;                     
                     add_dval <= '0';
                  end if;                  
                  
            end case;
         end if; -- if (sreset_data = '1')
      end if; -- if(rising_edge(CLK_DATA))
   end process;
   
end RTL;
