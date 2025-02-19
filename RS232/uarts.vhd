-- UARTS.vhd
-- -----------------------------------------------------------------------
--   Synthesizable Simple UART - VHDL Model
--   (c) ALSE - cannot be used without the prior written consent of ALSE
-- -----------------------------------------------------------------------
--  Version  : 4.1
--  Date     : May 2003
--  Author   : Bert CUZEAU
--  Contact  : info@alse-fr.com
--  Web      : http://www.alse-fr.com
-- ---------------------------------------------------------------
--  FUNCTION :
--    Asynchronous RS232 Transceiver with internal Baud rate generator.
--    This model is synthesizable to any technology. No internal Fifo.
--
--    Can use any Xtal but verify that :
--       Fxtal / max(Baudrate) is accurate enough
--    For very high speeds, it is recommended to use specific
--    Xtal frequencies like 18.432 MHz, etc...
--    Transmit & Receive occur with identical format.
--
--    ----------------
--   | Baud |  Rate   |
--   |------|---------|
--   |   1  |  Baud1  |  115200 by default
--   |   0  |  Baud2  |  19.200 by default
--    ----------------
--
--
--  Generics / Default values :
--  -------------------------
--    Fxtal  = Main Clock frequency in Hertz
--    Parity = False if no parity wanted
--    Even   = True / False, ignored if not parity
--    Baud1  = Baud rate # 1
--    Baud2  = Baud rate # 1
--
--   Typical Area :  (depends on division factor)
--     ~ 100 LCs (Flex 10k)
--     ~ 45 CLB slices (Spartan 2)
--   You can use almost any VHDL synthesis tool
--   like LeonardoSpectrum, Synplify, XST (ISE), QuartusII, etc...
--
--   Design notes :
--
--   1. Baud rate divisor constants are computed automatically
--      with the Fxtal Generic value.
--
--   2. Format options (Use of Parity & Even/Odd format)
--     are static choices (Generic map), but they
--     could easily be made dynamic (format inputs)
--
--   3. Invalid characters do not generate an RxRDY.
--     this can be modified easily in RxOVF State.
--
--   4. The Tx & Rx State Machines are resync'd Mealy type, and
--     they could be encoded as binary (one-hot isn't very useful).
--
--   Modifications :
--     Added internal resync FlipFlop on Rx & RTS.
--     you don't have to resynchronize them externally.
--
--  v4.1 :
--   * fixed a bug in the parity calculation
--   * removed RegDin (smaller by 8 x FlipFlops)
--
--   Open Issues :
--     The sampling could be more sophisticated, and we could have more
--     frame checking done.
--     Moreover, framing errors handling could be better.
--     In fact, we assume that there will be no error...
--     which is often the case : this UART has flawlessly exchanged
--     millions of bytes. Moreover, sensitive data should always be
--     checked within a data exchange protocol (CRC, checksum,...).
--
-- ---------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ----------------------------------------------
Entity UARTS is
   -- ----------------------------------------------
   -- Notes :
   --   Nb of Stop bits = 2 (default)
   --   format "N82" is generic map(Fxtal,false,false), >> by default <<
   --   format "8E2" is generic map(Fxtal,true,true)
   
   Generic ( Fxtal   : integer  := 3686400;  -- in Hertz
      Parity  : boolean  := false;
      Even    : boolean  := false;
      Baud1   : integer := 115200;
      --Baud2   : integer := 1562500 -- For faster simulation (exact baud rate generation for 50 MHz clock)
      Baud2   : integer := 6_250_000; -- For faster simulation (exact baud rate generation for 50 MHz clock)
      NbStopBit : integer := 2        -- Number of stop bit
      );
   Port (  CLK     : in  std_logic;  -- System Clock at Fqxtal
      RST     : in  std_logic;  -- Asynchronous Reset active high
      
      Din     : in  std_logic_vector (7 downto 0);
      LD      : in  std_logic;  -- Load, must be pulsed high
      Rx      : in  std_logic;
      
      Baud    : in  std_logic;  -- Baud Rate Select Baud1 (1) / Baud2 (0)
      
      Dout    : out std_logic_vector(7 downto 0);
      Tx      : out std_logic;
      TxBusy  : out std_logic;  -- '1' when Busy sending (LD and Din ignored)
      RxErr   : out std_logic;
      RxRDY   : out std_logic   -- '1' when Data available
      );
end UARTS;

-- ---------------------------------------------------------------
Architecture RTL of UARTS is
   -- ---------------------------------------------------------------
   function myMin ( i, j : integer) return integer is
   begin
      if i <= j then return i; else return j; end if;
   end function;
   
   constant BitCountMax : integer := (7 + NbStopBit);
   
   constant Debug : integer := 0;
   constant MaxFactor : integer := Fxtal / MyMin (Baud1,Baud2);
   
   constant Divisor1 : integer := (Fxtal / Baud1) / 2;
   constant Divisor2 : integer := (Fxtal / Baud2) / 2;
   
   Type TxFSM_State is (Idle, Load_Tx, Shift_TX, Parity_Tx, Stop_Tx  );
   signal TxFSM : TxFSM_State;
   
   Type RxFSM_State is (Idle, Start_Rx, Shift_RX, Edge_Rx,
   Parity_Rx, Parity_2, Stop_Rx, RxOVF );
   signal RxFSM : RxFSM_State;
   
   signal Tx_Reg : std_logic_vector (8 downto 0); -- for 2 stop bits
   signal Rx_Reg : std_logic_vector (7 downto 0);
   
   signal RxDivisor: integer range 0 to MaxFactor/2; -- Rx division factor
   signal TxDivisor: integer range 0 to MaxFactor;   -- Tx division factor
   
   signal RxDiv : integer range 0 to MaxFactor/2;
   signal TxDiv : integer range 0 to MaxFactor;
   
   signal TopTx : std_logic;
   signal TopRx : std_logic;
   
   signal TxBitCnt : integer range 0 to BitCountMax;
   
   signal RxBitCnt : integer range 0 to 15;
   signal ClrDiv   : std_logic;
   signal RxRDYi   : std_logic;
   signal Rx_Par   : std_logic; -- Receive parity built
   signal Tx_Par   : std_logic; -- Transmit parity built
   
   signal Rx_r    : std_logic;  -- resync FlipFlop for Rx input
   
   --------
begin
   --------
   
   RxRDY <= RxRDYi;
   
   -- -----------------------------------
   --  Rx input resynchronization
   -- -----------------------------------
   process (RST, CLK)
   begin			 
      if rising_edge(CLK) then
         if RST='1' then
            Rx_r  <= '1';  -- avoid false start bit at powerup
         else
            Rx_r <= Rx;
         end if;
      end if;
   end process;
   
   -- --------------------------
   --  Baud Rate conversion
   -- --------------------------
   -- Note that constants are (actual_divisor - 1)
   -- You can easily add more BaudRates by extending the "case" instruction...
   process (RST, CLK)
   begin	
      if rising_edge(CLK) then
         if RST='1' then
            RxDivisor <= 0;
            TxDivisor <= 0;
         else
            case Baud is
               when '0' =>    RxDivisor <= Divisor2 - 1;
                  TxDivisor <= (2 * Divisor2) - 1;
               when '1' =>    RxDivisor <= Divisor1 - 1;
                  TxDivisor <= (2  * Divisor1) - 1;
               when others => RxDivisor <= 1;   -- n.u.
               TxDivisor <= 1;
            end case;
         end if; 
      end if;
   end process;
   
   -- ------------------------------
   --  Rx Clock Generation
   -- ------------------------------
   -- Periodicity : bit time / 2
   
   process (RST, CLK)
   begin		  
      if rising_edge(CLK) then
         if RST='1' then
            RxDiv <= 0;
            TopRx <= '0';
         else
            TopRx <= '0';
            if ClrDiv='1' then
               RxDiv <= 1;
            elsif RxDiv >= RxDivisor then
               RxDiv <= 0;
               TopRx <= '1';
            else
               RxDiv <=  RxDiv + 1;
            end if;
         end if; 
      end if;
   end process;
   
   
   -- --------------------------
   --  Tx Clock Generation
   -- --------------------------
   -- Periodicity : bit time
   
   process (RST, CLK)
   begin					 
      if rising_edge(CLK) then
         if RST='1' then
            TxDiv <= 0;
            TopTx <= '0';
         else
            TopTx <= '0';
            if TxDiv = TxDivisor then
               TxDiv <= 0;
               TopTx <= '1';
            else
               TxDiv <=  TxDiv + 1;
            end if;
         end if;	
      end if;
   end process;
   
   -- --------------------------
   --  Desynchronisation
   -- --------------------------
   -- Process to add a worst case desynchronisation for simulation
   desync_process : process (Tx_Reg(0), Baud)
      -- pragma translate_off
      variable delai : time; 
      -- pragma translate_on
   begin						 
      
      if Baud = '1' then
         -- pragma translate_off
         delai := (1_000_000_000/(2*Baud1)) * 1 ns;
      elsif Baud = '0' then							
         delai := (1_000_000_000/(2*Baud2)) * 1 ns;
      else
         delai := 0 ns; -- if Baud is undefined
         -- pragma translate_on
      end if;						
      
      if FALSE then
         TX <= '0'; -- never happens
         -- pragma translate_off
      elsif	TRUE then													  
         TX <= transport Tx_Reg(0) after delai; -- LSB first
         -- pragma translate_on
      else -- always this case for synthesis																	
         TX <= Tx_Reg(0); -- LSB first
      end if;				
   end process;
   
   -- --------------------------
   --  TRANSMIT State Machine
   -- --------------------------
   Tx_FSM: process (RST, CLK)
   begin	 
      if rising_edge(CLK) then
         if RST='1' then
            Tx_Reg   <= (others => '1'); -- Line=Vcc when no Xmit
            TxFSM    <= Idle;
            TxBitCnt <= 0;
            TxBusy   <= '0';
            Tx_Par   <= '0';
            
         else
            
            TxBusy <= '1';  -- Except when explicitly '0'
            
            case TxFSM is
               
               when Idle =>
                  if LD='1' then
                     Tx_Reg <= Din & '1';      -- Latch input data immediately.
                     TxBusy <= '1';
                     TxFSM <= Load_Tx;
                  else
                     Tx_Reg(0) <= '1';
                     TxBusy <= '0';
                  end if;
                  
               when Load_Tx =>
                  if TopTx='1' then
                     TxFSM  <= Shift_Tx;
                     Tx_Reg(0) <= '0'; -- Start bit
                     TxBitCnt <= BitCountMax;
                     if Parity then      -- Start + Data + Parity
                        if Even  then
                           Tx_Par <= '0';
                        else
                           Tx_Par <= '1';
                        end if;
                     end if;
                  end if;
                  
               when Shift_Tx =>
                  if TopTx='1' then     -- Shift Right with a '1'
                     TxBitCnt <= TxBitCnt - 1;
                     Tx_Par <= Tx_Par xor Tx_Reg(1);  -- <<< error in v4.0 fixed in v4.1
                     Tx_Reg <= '1' & Tx_Reg (Tx_Reg'high downto 1);
                     if TxBitCnt=1 then
                        if not parity then
                           TxFSM <= Stop_Tx;
                        else
                           Tx_Reg(0) <= Tx_Par;
                           TxFSM <= Parity_Tx;
                        end if;
                     end if;
                  end if;
                  
               when Parity_Tx =>       -- Parity bit
                  if TopTx='1' then
                     Tx_Reg(0) <= '1'; -- Stop bit value
                     TxFSM <= Stop_Tx;
                  end if;
                  
               when Stop_Tx =>         -- Stop bit
                  if TopTx='1' then
                     Tx_Reg(0) <= '1'; -- Stop bit value
                     TxFSM <= Idle;
                     TxBusy <= '0'; -- Ajout PDU
                  end if;
                  
               when others =>
               TxFSM <= Idle;
               TxBusy <= '0'; -- Ajout PDU
               
            end case;
         end if;		 
      end if;
   end process;
   
   
   -- ------------------------
   --  RECEIVE State Machine
   -- ------------------------
   
   Rx_FSM: process (RST, CLK)
      variable Ignore_TopRx : boolean; -- JPA 1 FEB 2006
      
   begin	  
      if rising_edge(CLK) then
         if RST='1' then
            Rx_Reg   <= (others => '0');
            Dout     <= (others => '0');
            RxBitCnt <= 0;
            RxFSM    <= Idle;
            RxRdyi   <= '0';
            ClrDiv   <= '0';
            RxErr    <= '0';
            Rx_Par   <= '0';
            
         else
            
            ClrDiv   <= '0';
            if RxRdyi='1' then  -- Clear error bit when a word has been received...
               RxErr  <= '0';
               RxRdyi <= '0';
            end if;
            
            case RxFSM is
               
               when Idle =>      -- Wait until start bit occurs
                  RxBitCnt <= 0;
                  if Even then Rx_Par<='0'; else Rx_Par<='1'; end if;
                  if Rx_r='0' then
                     RxFSM  <= Start_Rx;
                     Ignore_TopRx := true;
                     ClrDiv <='1';
                  end if;
                  
               when Start_Rx =>  -- Wait on first data bit
                  if Ignore_TopRx then		-- JPA 1 FEB 2006
                     Ignore_TopRx := false;	-- Sometimes the TopRx was already synchronized and the Top Rx was considered right away, then the Edge and Shift state were inverted...
                  else
                     if TopRx = '1' then
                        if Rx_r='1' then -- framing error
                           RxFSM <= RxOVF;
                           -- pragma translate_off
                           assert (debug < 1) report "Start bit error."
                           severity warning;
                           -- pragma translate_on
                        else
                           RxFSM <= Edge_Rx;
                        end if;
                     end if;
                  end if;	
                  
               when Edge_Rx =>   -- should be near Rx edge
                  if TopRx = '1' then
                     RxFSM <= Shift_Rx;
                     if RxBitCnt = 8 then
                        if Parity then
                           RxFSM <= Parity_Rx;
                        else
                           RxFSM <= Stop_Rx;
                        end if;
                     else
                        RxFSM <= Shift_Rx;
                     end if;
                  end if;
                  
               when Shift_Rx =>  -- Sample data !
                  if TopRx = '1' then
                     RxBitCnt <= RxBitCnt + 1;
                     Rx_Reg <= Rx_r & Rx_Reg (Rx_Reg'high downto 1); -- shift right
                     Rx_Par <= Rx_Par xor Rx_r;
                     RxFSM <= Edge_Rx;
                  end if;
                  
               when Parity_Rx => -- Sample the parity
                  if TopRx = '1' then
                     if (Rx_Par = Rx_r) then
                        RxFSM <= Parity_2;
                     else
                        RxFSM <= RxOVF;
                     end if;
                  end if;
                  
               when Parity_2 =>  -- second half Bit period wait
                  if TopRx = '1' then
                     RxFSM <= Stop_Rx;
                  end if;
                  
               when Stop_Rx =>   -- here during Stop bit
                  if TopRx = '1' then
                     if Rx_r='1' then
                        Dout <= Rx_reg;
                        RxRdyi <='1';
                        RxFSM <= Idle;
                        -- pragma translate_off
                        assert (debug < 1)
                        report "Character received in decimal is : "
                        & integer'image(to_integer(unsigned(Rx_Reg)))
                        & " - '" & character'val(to_integer(unsigned(Rx_Reg))) & "'"
                        severity note;
                        -- pragma translate_on
                     else
                        RxFSM <= RxOVF;
                     end if;
                  end if;
                  
                  
                  -- ERROR HANDLING COULD BE IMPROVED :
                  -- Here, we could try to re-synchronize !
               when RxOVF =>     -- Overflow / Error : should we RxRDY ?
                  
                  RxRdyi <='0'; -- or '1' : to be defined by the project
                  RxErr <= '1';
                  if Rx='1' then  -- return to idle as soon as Rx goes inactive
                     -- pragma translate_off
                     report "Error in character received. " severity warning;
                     -- pragma translate_on
                     RxFSM <= Idle;
                  end if;
                  
               when others => -- in case it would be encoded as safe + binary...
               RxFSM <= Idle;
               
            end case;
         end if;				 
      end if;
   end process;
   
end RTL;

-- speed up simulation
-- synthesis off
-- translate_off
--library common_hdl;
--use common_hdl.telops_testing.all;

--architecture asim of UARTS is
--   
--   -- example baud rate calc: 10ns * 54 * 16 = 8680ns ~115200bps (115740bps really)
--   -- remember need to feed pico_uart at 16x its operating baud rate 
--   constant baud_ratio : integer := integer(Fxtal/(16*Baud2))-1; -- calculate the clock division factor
--   signal baud16x : std_logic;
--   
--   ---------------------------------------------------------------------------------------------------
--   signal bps_ok : boolean := true;
--   --    type mem_t is array (0 to 15) of std_logic_vector(7 downto 0);
--   --    signal rx_fifo_mem : mem_t;
--   --    signal rx_wr_ptr : integer range 0 to 15;
--   --    signal tx_fifo_mem : mem_t;
--   --    signal tx_rd_ptr : integer range 0 to 15;
--   ---------------------------------------------------------------------------------------------------
--   
--   
--begin
--   
--   sim_model : if (baud_ratio <= 0) generate
--      begin
--      
--      bps_ok <= false;
--      assert bps_ok report "pico_uart_bps: => Generating simulation model because the baud rate setting is too high for the given fclk" severity warning;
--      assert (Baud2 <= 10*Fxtal) report "pico_uart_bps => Too fast bps setting! The RX Fifo will overflow even if you read at every clock tick" severity failure;
--      
--      
--      RxErr <= '0';  -- never error during sim
--           
--      -- simulated UART receiver
--      rxloop : process
--         variable byte : std_logic_vector(7 downto 0);
--      begin
--         --rx_wr_ptr <= 0;
--         loop
--            RxRDY <= '0';
--            rx_uart(byte,Baud2,rx);
--            Dout <= byte;
--            RxRDY <= '1';
--            wait until clk'event and clk = '1';                    
--         end loop;
--         wait;
--      end process rxloop;
--      
--      
--      txloop : process
--         variable data : std_logic_vector(7 downto 0);
--      begin
--         TxBusy <= '0';
--         tx <= '1';
--         loop
--            wait until CLK'event and CLK = '1' and LD = '1';             
--            data := Din;                                     
--            TxBusy <= '1';
--            tx_uart(data, Baud2, tx);
--            wait until CLK'event and CLK = '1';
--            TxBusy <= '0';                
--         end loop;
--         wait;
--      end process txloop;
--      
--      
--   end generate sim_model;
--   
--end asim;
-- synthesis on
-- translate_on