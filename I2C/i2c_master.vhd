--------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: i2c_master.vhd
--  Hierarchy: Sub-module file
--  Use: I2C/SMBus serial interface master controler
--	 Project: POF2005 - Temperature sensing diodes SMBus peripheral access
--	 By: Olivier Bourgois
--
--  Revision history:  (use CVS for exact code history)
--    OBO : Dec 22, 2005 - original implementation started
--    OBO : Jan 18, 2006 - working version
--    OBO : Mar 14, 2006 - overhauled completely, cleaner implementation and interface
--    OBO : Jul 03, 2006 - fixed I2C reset bug (SDA level needs to start High)
--
--  References:
--    I2C and SMBus protocols
--
--  Current core restrictions:
--    1) There is no provision for multi-mastering.  This core assumes it is the only master
--       on the bus and does not implement backoff.
--    2) No clock stretching support is implemented. Slaves must not attempt to stretch the
--       clock low time. (this feature would require a strong pullup to drive clk high and 
--       rise times are out of spec when using FPGA internal pullup)
--    3) SCL4XSRC frequency must be at least 6 times slower than CLK for proper operation in
--       simulation
--    4) When slave drives the bus only the pullup on SDA drives '1' so we must take RC rise time
--       of the SDA line in consideration when using this core.
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity i2c_master is
   port(
      CLK          : in    std_logic;
      ARESET       : in    std_logic;
      SCL4XSRC     : in    std_logic;
      I2C_ADR      : in    std_logic_vector(6 downto 0);
      I2C_STB      : in    std_logic;
      I2C_WE       : in    std_logic;
      I2C_NACK     : in    std_logic;
      I2C_ACK      : out   std_logic;
      I2C_ERR      : out   std_logic;
      I2C_ACT      : out   std_logic;
      I2C_TX       : in    std_logic_vector(7 downto 0);
      I2C_RX       : out   std_logic_vector(7 downto 0);   
      I2C_SCL_PIN  : out   std_logic;
      I2C_SDA_PIN  : inout std_logic);
end entity i2c_master;

architecture rtl of i2c_master is
   
   type state is (OFF, START, TX, WS0, WS1, RX, ACKTST, STOP, IDLE);
   signal cs_sm    : state;
   
   signal rst_sync : std_logic;
   signal sdi      : std_logic;
   signal sd_lvl   : std_logic;
   signal sc_lvl   : std_logic;
   signal clk4x_en : std_logic;
   signal rx_byte  : std_logic_vector(7 downto 0);
   signal tx_byte  : std_logic_vector(7 downto 0);
   signal we       : std_logic; 
   signal ack      : std_logic;
   signal err      : std_logic;
   signal adrcyc   : std_logic;
   --signal sd_drv   : std_logic;
   signal sd_lvl_old : std_logic;
   
begin
   
   -- translate_off
   -- these pullups must be real in the physical system
   I2C_SCL_PIN <= 'H';
   I2C_SDA_PIN <= 'H';
   -- translate_on
   
   -- I2C pin driving (pulled up open collector style, be careful of interface operating frequency)
   -- note: clock also open collector to eventually implement slave clock stretch feature
   I2C_SCL_PIN <= sc_lvl;
   I2C_SDA_PIN <= '0' when (sd_lvl = '0') else 'Z';
   
   -- map signals
   I2C_ERR <= err;
   
   -- bit driving state machine
   bit_machine : process (CLK)
      variable cnt : integer range 1 to 9;
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            sd_lvl  <= '1';
            sc_lvl  <= '1';
            I2C_ACT <= '1';
            err     <= '0';
            ack     <= '0';
            cnt     := 1;
            cs_sm   <= STOP; -- do a clean stop on reset
         else
            if (clk4x_en = '1') then
               case cs_sm is
                  
                  when OFF =>
                     sd_lvl   <= '1';
                     sc_lvl   <= '1';
                     if (I2C_STB = '1') then
                        cs_sm <= START;
                     else
                        cs_sm <= OFF;
                     end if;
                     cnt := 1;
                     err <= '0';
                     I2C_ACT <= '0';
                     
                  when START =>
                     sd_lvl   <= '0';
                     sc_lvl   <= '1';
                     tx_byte  <= I2C_ADR & not I2C_WE;
                     we       <= I2C_WE;
                     cs_sm    <= RX;
                     adrcyc   <= '1';
                     I2C_ACT  <= '1';
                     
                  when IDLE =>
                     sd_lvl  <= '0';
                     sc_lvl  <= '0';
                     tx_byte <= I2C_TX;
                     if (I2C_STB = '1' and we = I2C_WE and err = '0') then
                        cs_sm <= TX;
                     else
                        cs_sm <= STOP;
                        ack <= err;
                     end if;
                     cnt := 1;
                     adrcyc  <= '0';
                     
                  when TX =>
                     if (cnt /=9 and (we = '1' or adrcyc = '1')) then
                        sd_lvl <= tx_byte(7);
                        tx_byte(7 downto 1) <= tx_byte(6 downto 0);
                     elsif (cnt = 9 and we = '0' and adrcyc = '0') then
                        sd_lvl <= I2C_NACK;
                     else
                        sd_lvl <= '1';
                     end if;
                     sc_lvl <= '0';
                     cs_sm  <= WS0;
                     ack    <= '0';
                     
                  when WS0 =>
                     sc_lvl <= '1';
                     cs_sm  <= WS1;    
                     
                  when WS1 =>
                     if (cnt = 9) then
                        cs_sm <= ACKTST;
                     else
                        cs_sm <= RX;
                        cnt := cnt + 1;
                     end if;
                     sc_lvl <= '1';
                     
                  when ACKTST =>
                     ack <= not adrcyc;              -- do not ack during addressing cycle byte
                     err <= sdi and (we or adrcyc);  -- error if slave does not respond
                     I2C_RX <= rx_byte;
                     adrcyc <= '0';
                     sc_lvl <= '0';
                     sd_lvl <= '0';
                     cs_sm  <= IDLE; 
                     
                  when RX =>
                     rx_byte(7 downto 1) <= rx_byte(6 downto 0);
                     rx_byte(0) <= sdi; 
                     sc_lvl <= '0';
                     cs_sm  <= TX; 
                     
                  when STOP =>
                  case cnt is
                     when 1 =>
                        sd_lvl <= '0';
                        sc_lvl <= '1';
                     when 2 =>
                        sd_lvl <= '1';
                        sc_lvl <= '1';                
                     when 8 =>
                        cs_sm  <= OFF;
                     when others =>
                     null;
                  end case;
                  cnt := cnt + 1;
                  
               end case;
            end if;
         end if;
      end if;
   end process bit_machine;
   
   -- I2C 4X clock enable pulse generation from SCL4XSRC signal with any duty cycle
   clk4x_en_proc : process (CLK)
      variable clksrc_hist : std_logic_vector(1 downto 0);
   begin
      if (CLK'event and CLK = '1') then   
         if rst_sync = '1' then
            clksrc_hist := (others => '0');
         else
            clksrc_hist(1) := clksrc_hist(0);
            clksrc_hist(0) := SCL4XSRC;
            if (clksrc_hist = "01") then -- detect rising edge
               clk4x_en <= '1';
            else
               clk4x_en <= '0';
            end if;     
         end if;
      end if;
   end process clk4x_en_proc;
   
   -- Manage the I2C_ACKs, pulse once @ system clock freq
   ack_proc : process (CLK)
      variable ack_hist : std_logic_vector(1 downto 0);
   begin
      if (CLK'event and CLK = '1') then   
         if rst_sync = '1' then
            ack_hist := (others => '0');
         else
            ack_hist(1) := ack_hist(0);
            ack_hist(0) := ack;
            if (ack_hist = "01") then -- detect rising edge
               I2C_ACK <= '1';
            else
               I2C_ACK <= '0';
            end if;        
         end if;
      end if;
   end process ack_proc;
   
   -- I2C_SDA pin async input double buffering and resolving
   async_sda_in : process(CLK)
      variable sda_ibuf : std_logic_vector(1 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         sda_ibuf(1) := sda_ibuf(0);
         sda_ibuf(0) := To_X01(I2C_SDA_PIN);
         sdi <= sda_ibuf(1);
      end if;
   end process async_sda_in;
   
   -- Potentially asynchronous reset local double buffering
   rst_dbuf : process(CLK)
      variable rst_hist : std_logic_vector(1 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         rst_hist(1) := rst_hist(0);
         rst_hist(0) := To_X01(ARESET);
         rst_sync <= rst_hist(1);
      end if;
   end process rst_dbuf;
   
end rtl;
