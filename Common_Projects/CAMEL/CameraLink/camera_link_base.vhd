---------------------------------------------------------------------------------------------------
--                                                      ..`??!````??!..
--                                                  .?!                `1.
--                                               .?`                      i
--                                             .!      ..vY=!``?74.        i
--.........          .......          ...     ?      .Y=` .+wA..   ?,      .....              ...
--"""HMM"""^         MM#"""5         .MM|    :     .H\ .JQgNa,.4o.  j      MM#"MMN,        .MM#"WMF
--   JM#             MMNggg2         .MM|   `      P.;,jMt   `N.r1. ``     MMmJgMM'        .MMMNa,.
--   JM#             MM%````         .MM|   :     .| 1A Wm...JMy!.|.t     .MMF!!`           . `7HMN
--   JMM             MMMMMMM         .MMMMMMM!     W. `U,.?4kZ=  .y^     .!MMt              YMMMMB=
--                                          `.      7&.  ?1+...JY'     .J
--                                           ?.        ?""""7`       .?`
--                                             :.                ..?`
--
---------------------------------------------------------------------------------------------------
--
-- Title       : Camera_Link_Base
-- Design      : VP7
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.VP7_Define.all;

library Common_HDL; 
use Common_HDL.Telops.all;
use work.DPB_Define.ALL;

entity camera_link_base is  
   Generic( 
      Latency : integer := 10;      -- MUST be at least 10 (there is latency in the fifo counter AND because of the clock-crossing flip-flops)
      LargeFifo : boolean := true); 
   Port (   
      --------------------------------
      -- Flow Control (FIFO interface)
      -------------------------------- 
      RX_LL_MOSI     : in  t_ll_mosi;
      RX_LL_MISO     : out t_ll_miso;
      
      FIFO_EMPTY     : out std_logic;
      FIFO_RD_ERR    : out std_logic;
      FIFO_WR_ERR    : out std_logic;
      INIT           : in  std_logic; -- This will flush the fifo and stop the CameraLink frame immediately.
      FORCE_END      : in  std_logic; -- This will flush the fifo and stop CameraLink gracefully (with zeros).
      
      FIFO_FULL_ERR  : out std_logic;
      TIMEOUT_ERR    : out std_logic;  
      DONE           : out std_logic;
      
      --------------------------------
      -- Configuration Parameters
      -------------------------------- 
      CONFIG         : in  CLinkConfig;
      --------------------------------
      -- Others IOs
      --------------------------------
      CLK_USR        : in  std_logic; -- User clock 
      ARESET         : in  std_logic;
      --------------------------------
      -- Signals to Camera Link PHY
      --------------------------------
      --FVAL_TRIG    : out std_logic;
      
      CLK_CAML0      : in  std_logic;
      CLK_CAML90     : in  std_logic;
      CLK_CAML180    : in  std_logic;
      CLK_CAML270    : in  std_logic;
      CAML_X_LVAL    : out std_logic;
      CAML_X_FVAL    : out std_logic;
      CAML_X_DVAL    : out std_logic;
      CAML_X_SPARE   : out std_logic;
      CAML_PORT_C    : out std_logic_vector(7 downto 0);
      CAML_PORT_B    : out std_logic_vector(7 downto 0);
      CAML_PORT_A    : out std_logic_vector(7 downto 0);
      CAML_X_CLK     : out std_logic;
      CAML_PDWN_N    : out std_logic);
   ---------------------------------
   
end camera_link_base;

architecture Behavioral of camera_link_base is 
   
   signal FIFO_LL_MOSI : t_ll_mosi;
   signal FIFO_LL_MISO : t_ll_miso;
   
   -- State machine
   type   t_state is (Reset1, Send_Data,Wait_For_Next_Frame, Wait_For_fifo_filled_enough, Wait_For_VB, Wait_For_HB, Flush_Sifo_State);
   signal state : t_state := reset1; 
   
   signal fifo_empty_i : std_logic; 
   signal fifo_dout : std_logic_vector(15 downto 0); 
   signal caml_busy : std_logic;
   
   signal LValSize_cnt : integer range 0 to 65535;
   signal LValSize : unsigned(LVALLEN-1 downto 0);
   signal FValSize : unsigned(FVALLEN-1 downto 0);
   
   signal VB : integer range 0 to 131071; -- Desired Vertical Blanking
   signal LValPause : unsigned(LPAUSELEN-1 downto 0);
   signal HB_cnt    : unsigned(LPAUSELEN-1 downto 0);  -- Horizontal Blanking Counter (4 clocks minimum)
   signal VB_cnt    : integer range 1 to 65535;   -- Vertical Blanking Counter (1 line minimum)
   
   signal fifo_rd_count13 : unsigned(13 downto 0);
   signal fifo_rd_count14 : unsigned(14 downto 0);
   signal std_fifo_rd_count13 : std_logic_vector(13 downto 0);
   signal std_fifo_rd_count14 : std_logic_vector(14 downto 0);
   signal VP30_fifo_filled_enough : std_logic;     
   signal VP30_fifo_filled_enough_async : std_logic;
   signal fifo_filled_enough : std_logic;
   signal ChannelLink_RDY : std_logic;
   signal ChannelLink_RDY_sync, INIT_sync : std_logic;
   signal FORCE_END_sync, FORCE_END_reg : std_logic;
   signal output_debug : t_output_debug;
   signal RESET_FIFO, Flush_FIFO : std_logic;
   signal shift_Flush_FIFO : std_logic_vector(2 downto 0);
   signal fifo_full : std_logic;   
   signal FIFO_RD_ERR_sync : std_logic;
   signal FIFO_RD_ERR_async : std_logic;
   
   signal CAML_debug : std_logic_vector(15 downto 0);   
   signal RESET_CAML0 : std_logic; 
   signal RESET_USR : std_logic;
   signal TIMEOUT_ERR_async : std_logic;
   
   signal DVAL : std_logic; 
   signal fifo_dval : std_logic;         
   signal DONE_async : std_logic;
   
   
   -- Buffers before retiming (can be used for Chipscope capture)
   signal CAML_X_DVAL_buf : std_logic;
   signal CAML_X_LVAL_buf : std_logic;
   signal CAML_X_FVAL_buf : std_logic;
   signal CAML_PORT_A_buf : std_logic_vector(7 downto 0);
   signal CAML_PORT_B_buf : std_logic_vector(7 downto 0);
   --signal CAML_PORT_C_buf : std_logic_vector(7 downto 0);
   
   -- Extra registers that should be located in the IOBs
   signal CAML_X_DVAL_reg : std_logic;
   signal CAML_X_LVAL_reg : std_logic;
   signal CAML_X_FVAL_reg : std_logic;
   signal CAML_PORT_A_reg : std_logic_vector(7 downto 0);
   signal CAML_PORT_B_reg : std_logic_vector(7 downto 0);
   --signal CAML_PORT_C_reg : std_logic_vector(7 downto 0);    
   
   attribute IOB : string;
   attribute IOB of CAML_X_DVAL_reg : signal is "TRUE"; 
   attribute IOB of CAML_X_LVAL_reg : signal is "TRUE";
   attribute IOB of CAML_X_FVAL_reg : signal is "TRUE";   
   attribute IOB of CAML_PORT_A_reg : signal is "TRUE"; 
   attribute IOB of CAML_PORT_B_reg : signal is "TRUE";
   --attribute IOB of CAML_PORT_C_reg : signal is "TRUE";
   
   attribute keep : string;                           
   attribute keep of fifo_filled_enough : signal is "true";
   
   --   signal fifo_wr_ack : std_logic;
   --   signal fifo_wr_cnt : unsigned(31 downto 0);                       
   --   signal fifo_rd_cnt : unsigned(31 downto 0);                       
   --   signal dval_cnt : unsigned(31 downto 0);
   --   signal cnt_err : std_logic;
   --   attribute keep of fifo_wr_cnt : signal is "true";
   --   attribute keep of fifo_rd_cnt : signal is "true";
   --   attribute keep of cnt_err : signal is "true";
   
   signal Wait_cnt : unsigned (22 downto 0); 
   
begin    
   --CAML_PORT_C_buf <= (others => '0');
   CAML_PORT_C <= (others => '0');    
   
   gen_SmallFifo : if (not LargeFifo) generate
      begin   
      fifo_filled_enough <= '1' when ( ((fifo_rd_count13 >= to_integer(LValSize-1) or fifo_rd_count13 >= (16383-Latency-100)) and fifo_rd_count13 >= 2) ) else '0';            
      
      FIFO_LL_MISO.AFULL <= '0';
      FIFO_LL_MISO.BUSY <= caml_busy;
      
      fifo_dout <= FIFO_LL_MOSI.DATA;
      fifo_dval <= FIFO_LL_MOSI.DVAL and not caml_busy; 
      
      fifo_rd_count13 <= unsigned(std_fifo_rd_count13);        
      
      fifo : entity work.CAML_Fifo
      generic map(
         FifoSize => 16383,
         Latency => Latency,
         ASYNC => true,
         SOF_EOF => false)
      port map(
         RX_LL_MOSI => RX_LL_MOSI,
         RX_LL_MISO => RX_LL_MISO,
         CLK_RX => CLK_USR,
         FULL => fifo_full,
         WR_ERR => FIFO_WR_ERR,
         --RD_ERR => FIFO_RD_ERR_async,
         TX_LL_MOSI => FIFO_LL_MOSI,
         TX_LL_MISO => FIFO_LL_MISO, 
         RD_CNT => std_fifo_rd_count13,
         CLK_TX => CLK_CAML0,
         EMPTY => fifo_empty_i, -- This signal is synchronous to CLK_CAML0
         ARESET => RESET_FIFO
         );
      
   end generate gen_SmallFifo;   
   
   gen_LargeFifo : if (LargeFifo) generate
      begin  
      fifo_filled_enough <= '1' when ( ((fifo_rd_count14 >= to_integer(LValSize-1) or fifo_rd_count14 >= (32767-Latency-100)) and fifo_rd_count14 >= 2) ) else '0';            
      
      FIFO_LL_MISO.AFULL <= '0';
      FIFO_LL_MISO.BUSY <= caml_busy;
      
      fifo_dout <= FIFO_LL_MOSI.DATA;
      fifo_dval <= FIFO_LL_MOSI.DVAL and not caml_busy; 
      
      fifo_rd_count14 <= unsigned(std_fifo_rd_count14);        
      
      fifo : entity work.CAML_Fifo
      generic map(
         FifoSize => 32767,
         Latency => Latency,
         ASYNC => true,
         SOF_EOF => false)
      port map(
         RX_LL_MOSI => RX_LL_MOSI,
         RX_LL_MISO => RX_LL_MISO,
         CLK_RX => CLK_USR,
         FULL => fifo_full,
         WR_ERR => FIFO_WR_ERR,
         --RD_ERR => FIFO_RD_ERR_async,
         TX_LL_MOSI => FIFO_LL_MOSI,
         TX_LL_MISO => FIFO_LL_MISO, 
         RD_CNT => std_fifo_rd_count14,
         CLK_TX => CLK_CAML0,
         EMPTY => fifo_empty_i, -- This signal is synchronous to CLK_CAML0
         ARESET => RESET_FIFO
         );                       
      
   end generate gen_LargeFifo;   
   
   --DVAL <= fifo_dval or (FORCE_END and fifo_empty_i);
   DVAL <= fifo_dval;
   
   -- FIFO_FULL_ERR management (no error if fifo_full caused by flush_fifo)
   FIFO_FULL_ERR <= fifo_full and not Flush_FIFO and not shift_Flush_FIFO(2) and not shift_Flush_FIFO(1) and not  shift_Flush_FIFO(0);                    
   FIFO_RD_ERR <= FIFO_RD_ERR_sync and not FORCE_END;
   
   ---------------------------------------------
   -- Synchronisation toward CLK_CAML0 domain
   ---------------------------------------------
   sync_RESET_CAML0 : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET_CAML0, CLK => CLK_CAML0);   
   
   sync_ChannelLink : entity double_sync
   port map(d => ChannelLink_RDY, q => ChannelLink_RDY_sync, reset => ARESET, clk => CLK_CAML0);   
   
   sync_INIT : entity double_sync
   port map(d => INIT, q => INIT_sync, reset => ARESET, clk => CLK_CAML0);    
   
   sync_FORCE : entity double_sync
   port map(d => FORCE_END, q => FORCE_END_sync, reset => ARESET, clk => CLK_CAML0);         
   ---------------------------------------------
   
   
   ---------------------------------------------
   -- Synchronisation toward CLK_USR domain
   --------------------------------------------- 
   sync_RESET_USR : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET_USR, CLK => CLK_USR);  
   
   -- Sync between CLK_USR and CLK_CAML0
   sync_FIFO_RD_ERR : entity double_sync
   port map(d => FIFO_RD_ERR_async, q => FIFO_RD_ERR_sync, reset => ARESET, clk => CLK_USR);     
   
   -- Sync between CLK_USR and CLK_CAML0
   sync_FIFO_EMPTY : entity double_sync
   port map(d => fifo_empty_i, q => FIFO_EMPTY, reset => ARESET, clk => CLK_USR);   
   
   -- Sync between CLK_USR and CLK_CAML0
   sync_DONE : entity double_sync
   port map(d => DONE_async, q => DONE, reset => ARESET, clk => CLK_USR);    
   
   sync_TIMEOUT_ERR : entity double_sync
   port map(d => TIMEOUT_ERR_async, q => TIMEOUT_ERR, reset => ARESET, clk => CLK_USR);   
   ---------------------------------------------                                    g
   
   
   CAML_X_SPARE <= '0'; -- Unused but assigned to not leave it floating
   
   -- Add 20 ms delay to wait for the PLL inside the Channel Link chips to lock
   Channel_Link_Wait_20_ms : process(CLK_USR) -- Wait 20 ms if CLK_USR is 50 MHz or 10 ms if 100 MHz
      variable CL_cnt : integer range 1 to 1000000;      
   begin 
      if rising_edge(CLK_USR) then
         if RESET_USR = '1' then
            CL_cnt := 1;
            ChannelLink_RDY <= '0'; 
         else 
            if CL_cnt >= 1000000 then
               ChannelLink_RDY <= '1';
               -- synopsys translate_off
            elsif true then
               ChannelLink_RDY <= '1'; 
               -- synopsys translate_on
            else 
               CL_cnt := CL_cnt + 1;
            end if;
         end if;   
      end if;
   end process; 
   
   state_machine : process (CLK_CAML0)
      variable FSIZE_cnt : integer range 1 to 65535;
      --variable Wait_cnt : integer range 0 to 1000000;    -- Once its limit is reached, the frame is considered "incomplete"      
      variable LVal_On : std_logic;
      variable FVal_On : std_logic;
      variable FORCE_END_internal : std_logic; 
      variable pause_cnt : unsigned(2 downto 0);     
      variable ForceZero : std_logic;
   begin  
      if rising_edge(CLK_CAML0) then
         if RESET_CAML0 = '1' then
            CAML_X_LVAL_buf <= '0';
            CAML_X_FVAL_buf <= '0';
            CAML_X_DVAL_buf   <= '0';
            LValSize_cnt <= 1;
            FSIZE_cnt := 1;
            HB_cnt <= (others => '0');
            VB_cnt <= 1;
            CAML_PDWN_N <= '0'; -- Power down
            state <= Reset1;            
            Wait_cnt <= (others => '0');
            Flush_FIFO <= '0';            
            TIMEOUT_ERR_async <= '0';
            shift_Flush_FIFO <= (others => '0');            
            LVal_On := '0';
            FVal_On := '0';  
            CAML_PORT_A_buf <= (others => '0');
            CAML_PORT_B_buf <= (others => '0');     
            FORCE_END_internal := '0';
            --CAML_PORT_C_buf <= (others => '0');                           
            --            fifo_rd_cnt <= (others => '0');
            --            dval_cnt <= (others => '0');
            --            cnt_err <= '0';
            caml_busy <= '1';
         else                       
            VB <= to_integer(LValSize+LValPause);
            
            --            if fifo_dval = '1' and LargeFifo then
            --               fifo_rd_cnt <= fifo_rd_cnt + 1;
            --            end if;   
            --            if CAML_X_DVAL_buf = '1' and LargeFifo then
            --               dval_cnt <= dval_cnt + 1;
            --            end if;
            --            if (dval_cnt - fifo_rd_cnt) > 2 then
            --               cnt_err <= '1';
            --            end if;
            
            ---------------------------------------------
            -- Shift register for Flush_Fifo        
            ---------------------------------------------
            shift_Flush_FIFO(2) <= Flush_FIFO;
            shift_Flush_FIFO(1 downto 0) <= shift_Flush_FIFO(2 downto 1);               
            ---------------------------------------------             
            
            CAML_PDWN_N <= '1'; -- Now that we have a clock we can enable the Channel Link chips.            
            
            if ChannelLink_RDY_sync = '1' then
               case state is
                  when Reset1 =>                     
                     CAML_X_LVAL_buf <= '0';
                     CAML_X_FVAL_buf <= '0';
                     CAML_X_DVAL_buf <= '0'; 
                     LValSize_cnt <= 1;
                     FSIZE_cnt := 1;
                     HB_cnt <= (others => '0');
                     VB_cnt <= 1;
                     TIMEOUT_ERR_async <= '0';
                     state <= Wait_For_Next_Frame;
                     LVal_On := '0';
                     FVal_On := '0';
                     caml_busy <= '1';
                     Flush_FIFO <= '1';
                     FIFO_RD_ERR_async <= '0';
                     DONE_async <= '1';     
                     FORCE_END_internal := '0';   
                     pause_cnt := (others => '0');
                     FORCE_END_reg <= '0';   
                     
                  when Wait_For_Next_Frame =>
                     caml_busy <= '1';
                     Flush_FIFO <= '0';
                     DONE_async <= '1';  
                     FORCE_END_internal := '0';
                     -- This latching of parameters crosses clock domain
                     LValSize   <= CONFIG.LvalSize;
                     FValSize   <= CONFIG.FvalSize;
                     LValPause  <= CONFIG.LValPause; 
                     
                     LVal_On := '0';                                                                 
                     
                     if fifo_empty_i = '0' then                        
                        state <= Wait_For_fifo_filled_enough;
                        DONE_async <= '0';
                     end if;
                     
                  when Wait_For_fifo_filled_enough =>
                     caml_busy <= '1';
                     LVal_On := '0';
                     if fifo_filled_enough = '1' or FORCE_END_sync = '1' then
                        Wait_cnt <= (others => '0');
                        state <= Send_Data;
                     elsif RX_LL_MOSI.DVAL = '1' then
                        Wait_cnt <= (others => '0');
                     else             
                        -- This timeout should ONLY happen if the CameraLink settings are bad.
                        if Wait_cnt(22) = '0' -- 2^22 * 20 ns = 84 ms. 
                           -- pragma translate_off
                           and Wait_cnt < 7000 
                           -- pragma translate_on
                           then 
                           Wait_cnt <= Wait_Cnt + 1;
                        else   
                           TIMEOUT_ERR_async <= '1';
                           FORCE_END_internal := '1';                        
                           state <= Send_Data;
                        end if;
                     end if; 
                     
                  when Send_Data =>        
                     if (FORCE_END_sync = '1' or FORCE_END_internal = '1') and DVAL = '0' and caml_busy = '0' then
                        ForceZero := '1';
                     else
                        ForceZero := '0';
                     end if;             
                     
                     if ForceZero = '1' then
                        CAML_PORT_A_buf <= (others => '0');
                        CAML_PORT_B_buf <= (others => '0');
                        CAML_X_DVAL_buf <= '1';                        
                     else
                        CAML_PORT_A_buf <= fifo_dout(7 downto 0);
                        CAML_PORT_B_buf <= fifo_dout(15 downto 8);                  
                        CAML_X_DVAL_buf <= DVAL;                     
                     end if;
                     
                     CAML_debug  <= fifo_dout; 
                     FIFO_RD_ERR_async <= '0';
                     
                     caml_busy <= '0'; 
                     
                     if DVAL = '1' or ForceZero = '1' then
                        CAML_X_LVAL_buf <= '1';
                        CAML_X_FVAL_buf <= '1';
                        if LValSize_cnt >= to_integer(LValSize) then
                           if FSIZE_cnt >= FValSize then
                              FSIZE_cnt := 1;
                              LValSize_cnt <= 1;
                              VB_cnt <= 1;
                              caml_busy <= '1'; 
                              if FORCE_END_reg = '1' or FORCE_END_internal = '1' then
                                 state <= Flush_Sifo_State;
                              else                               
                                 state <= Wait_For_VB;
                              end if;
                           else
                              FSIZE_cnt := FSIZE_cnt + 1;
                              LValSize_cnt <= 1;
                              HB_cnt <= (others => '0');
                              caml_busy <= '1';
                              state <= Wait_For_HB;
                           end if;
                        else
                           LValSize_cnt <= LValSize_cnt + 1;
                        end if;
                     else
                        if CAML_X_LVAL_buf = '1' then -- LVal is already started but DVAL is not '1'
                           FIFO_RD_ERR_async <= '1';
                        end if;
                     end if;
                     
                     
                  when Wait_For_HB =>
                     caml_busy <= '1';
                     CAML_X_LVAL_buf <= '0';
                     CAML_X_DVAL_buf <= '0';
                     if (LValPause > 4 and HB_cnt >= LValPause) or (LValPause <= 4 and HB_cnt >= 4) then 
                        state <= Wait_For_fifo_filled_enough;
                     else
                        HB_cnt <= HB_cnt + 1;
                     end if;
                     
                     
                  when Wait_For_VB =>
                     caml_busy <= '1';
                     CAML_X_LVAL_buf <= '0';
                     CAML_X_DVAL_buf <= '0';
                     CAML_X_FVAL_buf <= '0';    
                     if VB_cnt >= VB then                          
                        state <= Wait_For_Next_Frame;
                     else
                        VB_cnt <= VB_cnt + 1;
                     end if;        
                     
                  when Flush_Sifo_State =>
                     if pause_cnt = 0 then
                        Flush_FIFO <= '1';
                     else
                        Flush_FIFO <= '0';
                     end if;
                     FORCE_END_internal := '0';
                     FORCE_END_reg <= '0';
                     if pause_cnt = 7 then
                        pause_cnt := (others => '0');
                        state <= Wait_For_VB;  
                     else
                        pause_cnt := pause_cnt + 1;
                     end if;
                     
                     
                  when others =>
                  state <= Reset1; 
               end case;
               
               ---------------------------------------
               -- Special cases handling
               ---------------------------------------
               if INIT_sync = '1' then
                  state <= Reset1;
               end if;             
               
               if FORCE_END_sync = '1' then
                  FORCE_END_reg <= '1';               
               end if; 
               
               --               if FORCE_END_sync = '1' or FORCE_END_internal = '1' then
               --                  Flush_FIFO <= '1';               
               --               end if;          
               
            end if; -- if ChannelLink_RDY_sync = '1'
         end if;         
      end if;
   end process;
   
   RESET_FIFO <= Flush_FIFO or ARESET;   
   
   ----------------------------------------------------------------
   -- Retiming flip-flops
   ----------------------------------------------------------------
   CAML_X_CLK <= CLK_CAML180;
   
   CAML_PORT_A <= CAML_PORT_A_reg; 
   CAML_PORT_B <= CAML_PORT_B_reg; 
   CAML_X_DVAL <= CAML_X_DVAL_reg; 
   CAML_X_LVAL <= CAML_X_LVAL_reg; 
   CAML_X_FVAL <= CAML_X_FVAL_reg;    
   
   process(CLK_CAML0)
   begin       
      if rising_edge(CLK_CAML0) then                 
         -- synopsys translate_off
         output_debug <= to_output_debug(CAML_PORT_B_buf & CAML_PORT_A_buf);
         -- synopsys translate_on            
         CAML_PORT_A_reg <= CAML_PORT_A_buf;            
         CAML_PORT_B_reg <= CAML_PORT_B_buf;                        
         CAML_X_DVAL_reg <= CAML_X_DVAL_buf;   
         CAML_X_LVAL_reg <= CAML_X_LVAL_buf;
         CAML_X_FVAL_reg <= CAML_X_FVAL_buf;                       
      end if;
   end process;  
   
   
   ----------------------------------------------------------------
   -- Debug CameraLink
   ----------------------------------------------------------------
   
   --   process(CLK_CAML180)
   --   begin       
   --      if rising_edge(CLK_CAML180) then
   --         CAML_PORT_A_recapture <= CAML_PORT_A_buf;           
   --         CAML_PORT_B_recapture <= CAML_PORT_B_buf;           
   --         CAML_PORT_C_recapture <= CAML_PORT_C_buf;           
   --         CAML_X_DVAL_recapture <= CAML_X_DVAL_buf;  
   --         CAML_X_LVAL_recapture <= CAML_X_LVAL_buf;
   --         CAML_X_FVAL_recapture <= CAML_X_FVAL_buf;
   --         
   --         if CAML_X_LVAL_buf = '1' and (CAML_PORT_C_buf /= not CAML_PORT_C_recapture) then
   --            error_detected <= '1';  
   --         else
   --            error_detected <= '0';  
   --         end if;
   --         
   --      end if;                        
   --   end process;
   
   
   ----------------------------------------------------------------
end Behavioral;
