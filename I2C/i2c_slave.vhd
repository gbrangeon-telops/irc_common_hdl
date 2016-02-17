---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: i2c_slave.vhd
--  Hierarchy: Sub-module file
--  Use: I2C/SMBus serial interface slave
--	 Project: POF2005 - Testing of i2c_master core, may be useful in itself
--	 By: Olivier Bourgois
--
--  Revision history:  (use CVS for exact code history)
--    OBO : Jan 09, 2006 - original implementation started
--
--  References:
--    I2C and SMBus protocols
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity i2c_slave is
  generic(
    SLV_ADR     : std_logic_vector(6 downto 0) := "1010101");
  port(
    CLK         : in    std_logic;
    ARESET      : in    std_logic;
    ADR         : out   std_logic_vector(7 downto 0);
    WE          : out   std_logic;
    I2C_TX      : in    std_logic_vector(7 downto 0);
    I2C_RX      : out   std_logic_vector(7 downto 0);
    I2C_SCL_PIN : in    std_logic;
    I2C_SDA_PIN : inout std_logic);
end entity i2c_slave;

architecture rtl of i2c_slave is

  -- i2C ACK bit position (bit 9)
  constant LST_BIT   : std_logic_vector(3 downto 0) := "1000";
  constant FIRST_BIT : std_logic_vector(3 downto 0) := "0000";
  
  -- i2c event type decleration
  type event is (NOP, START, STOP, RISE, FALL);
  
  -- i2c slave status type decleration
  type slvstat is (IDLE, GETCMD, WR, RD, INACTIVE);
  
  -- signal declarations
  signal i2c_event   : event;
  signal i2c_slvstat : slvstat;
  signal scl_level   : std_logic;
  signal sda_level   : std_logic;
  signal slv_shr     : std_logic_vector(7 downto 0);
  signal bit_pos     : std_logic_vector(3 downto 0);
  signal sda_drv     : std_logic;
  signal adr_q       : std_logic_vector(7 downto 0);
  signal adr_incr    : std_logic;
  signal ld_data     : std_logic;
  signal rw_bit      : std_logic;
  signal rst_sync    : std_logic;
  
begin
   
   -- drive the ADR output
   ADR <= adr_q;
   
   -- i2c event detection
   i2c_events_detect : process(CLK)
   variable i2c_hist : std_logic_vector(3 downto 0);
   begin
     if (CLK'event and CLK = '1') then
       if (rst_sync = '1') then
         i2c_event <= NOP;
       else
         i2c_hist(3) := i2c_hist(2);
         i2c_hist(2) := scl_level; 
         i2c_hist(1) := i2c_hist(0);
         i2c_hist(0) := sda_level;
         case i2c_hist is
           when "1110" =>
             i2c_event <= START;
           when "1101" =>
             i2c_event <= STOP;
           when "0100" | "0111" =>
             i2c_event <= RISE;
           when "1000" | "1011" =>
             i2c_event <= FALL;
           when others =>
             i2c_event <= NOP;
         end case;
       end if;
     end if;
   end process i2c_events_detect;

   -- debending on i2c event detected take appropriate action
   i2c_event_action : process(CLK)
   begin
     if (CLK'event and CLK = '1') then
       if (rst_sync = '1') then
         WE          <= '0';
         adr_q       <= X"FF";
         i2c_slvstat <= IDLE;
         sda_drv     <= '1';
         rw_bit      <= '0';
         adr_incr    <= '0';
         ld_data     <= '0';
       else
         case i2c_event is
           when START =>
             WE          <= '0';
             bit_pos     <= "0000";                        -- reset the bit position counter
             sda_drv     <= '1';                           -- pull up SDA
             i2c_slvstat <= IDLE;                          -- we must go to IDLE on a restart
           when RISE =>                                    -- shift register on SCL rising edge
             WE <= '0';
             if (bit_pos = FIRST_BIT and i2c_slvstat = RD) then
               slv_shr <= I2C_TX;                          -- load the shift register with next read data
             else
               slv_shr(7 downto 1) <= slv_shr(6 downto 0);
               slv_shr(0) <= sda_level;
             end if;
           when FALL =>
             if (bit_pos = LST_BIT) then                   -- ACK bit position is where we make decisions
               bit_pos <= "0000";                          -- loop the bit position back to zero (last pos)
               case i2c_slvstat is
                 when IDLE =>
                   if (slv_shr(7 downto 1) = SLV_ADR) then -- check for matching slave address
                     if (slv_shr(0) = '0') then            
                       i2c_slvstat <= GETCMD;              -- go to getcmd state if rw bit is low
                     else                                  -- else go to read state if rw bit is high
                       i2c_slvstat <= RD;                  -- go to read state if rw bit is high
                       ld_data <= '1';
                     end if;
                     sda_drv <= '0';                       -- ack the master if slave selected
                     rw_bit <= slv_shr(0);                 -- keep a copy of the rw_bit
                   else
                     i2c_slvstat <= INACTIVE;
                     sda_drv <= '1';                       -- nack the master if not selected
                   end if;
                 when GETCMD =>
                   adr_q  <= slv_shr(7 downto 0);          -- register the command
                   if (rw_bit = '0') then            
                     i2c_slvstat <= WR;
                   else
                     i2c_slvstat <= INACTIVE;              -- we need to restart if its a read
                   end if;
                   sda_drv <= '0';                         -- ack the master
                   WE <= '0';
                 when RD =>
                   sda_drv <= '1';                         -- do not ack the master on RD
                   adr_incr <= '1';                        -- increment the address next clock
                   WE <= '0';
                 when WR =>
                   I2C_RX  <= slv_shr(7 downto 0);         -- register the received byte
                   sda_drv <= '0';                         -- ack the master
                   adr_incr <= '1';                        -- increment the address next clock (after the write)
                   WE <= '1';
                 when INACTIVE =>                          -- keep high if another slave is selected
                   null;
               end case;
             else
               bit_pos <= bit_pos + 1;
               case i2c_slvstat is
                 when RD =>
                   sda_drv <= slv_shr(7);
                 when others =>
                   sda_drv <= '1';
               end case;
             end if;
           when STOP =>
             i2c_slvstat <= IDLE;
           when NOP =>
             if (adr_incr = '1') then
               adr_incr <= '0';
               adr_q <= adr_q + 1;                        -- increment the address
             end if;
             WE <= '0';
         end case;
       end if;
     end if;
   end process i2c_event_action;
   
   -- I2C interface TX
   I2C_SDA_PIN <= '0' when (sda_drv = '0') else 'Z';

  -- I2C interface RX with double buffering on async inputs
  async_ins : process(CLK)
  variable sda_ibuf : std_logic_vector(1 downto 0);
  variable scl_ibuf : std_logic_vector(1 downto 0);
  begin
    if (CLK'event and CLK = '1') then
      sda_ibuf(1) := sda_ibuf(0);
      sda_ibuf(0) := To_X01(I2C_SDA_PIN);
      sda_level <= sda_ibuf(1);
      scl_ibuf(1) := scl_ibuf(0);
      scl_ibuf(0) := To_X01(I2C_SCL_PIN);
      scl_level <= scl_ibuf(1);
    end if;
  end process async_ins;
  
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