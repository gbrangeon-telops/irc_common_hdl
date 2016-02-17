---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: temp_reader.vhd
--  Hierarchy: Sub-module file
--  Use: Temperature reading over I2C/SMBus serial interface
--	 Project: POF2005 - Temperature sensing diodes SMBus peripheral access
--	 By: Olivier Bourgois
--
--  Revision history:  (use CVS for exact code history)
--    OBO : Jan 18, 2006 - original implementation
--    OBO : Mar 15, 2006 - separated into 2 state machines for clarity
--    OBO : Jul 03, 2006 - fixed formating
--
--  References:
--    MAX1617 & ADM1023 data sheets
--
--  Implementation Notes:
--    - MAX1617 is operated in continuous mode at the maximum refresh rate (8Hz)
--    - need to divide 100Mhz clock by at least 250 to get 100KHz SCL max clock rate
--    - The ADD(1:0) pins of the chip are only read at Power on, so I2C slave address 
--      depends on FPGA Power on levels of these pins (Set to pull-up or Hi-Z by FPGA jumpers)
--    - none of the temperature alarm features are currently used
--    - state sequence is as follows:
--        1) RST is asserted
--        2) Configuration and conversion rate bytes are written once (registers 0x09 & 0x0A)
--        3) Status, Local and remote temperatures are continuously read 
--           (registers 0x02 & 0x00 & 0x01)
--  Bugs:
--    - currently the clk4x is divided by 1024 resulting in a 25 KHz I2C clock. For some reason
--      division by 256 does not work even though it is within spec for the ADM1023
--      
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;             
library Common_HDL;            
use Common_HDL.Telops.all;

entity temp_reader is
   generic(
      I2C_ADR         : std_logic_vector(6 downto 0) := "0011000"; -- MAX1617 ADD(1:0) = "00";
      OVERTMP_THRES   : natural := 100                             -- Overtemperature threshold
      );  
   port(
      CLK          : in    std_logic;
      ARESET       : in    std_logic;  
      OVERTMP      : out   std_logic;
      FPGA_TEMP    : out   std_logic_vector(7 downto 0);
      EXT_TEMP     : out   std_logic_vector(7 downto 0);
      I2C_SCL_PIN  : out   std_logic;        
      I2C_SDA_PIN  : inout std_logic);
end entity temp_reader;

architecture rtl of temp_reader is
   
   -- component declarations
   component i2c_master
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
   end component;
   
   -- state machine states
   type rem_st is 
   (IDLE, REGADR, REGDATA);
   
   type lp_st is 
   (CONF, RATE, ONESHOT, STAT, CHIP, FPGA);
   
   -- signal declarations
   signal cs_rem     : rem_st;
   signal cs_lp      : lp_st;
   signal rst_sync   : std_logic;
   signal scl4xsrc   : std_logic;
   signal i2c_stb    : std_logic;
   signal i2c_we     : std_logic;
   signal i2c_err    : std_logic;
   signal i2c_act    : std_logic;
   signal i2c_ack    : std_logic;
   signal i2c_tx     : std_logic_vector(7 downto 0);
   signal i2c_rx     : std_logic_vector(7 downto 0);
   signal adr        : std_logic_vector(7 downto 0);
   signal din        : std_logic_vector(7 downto 0);
   signal dout       : std_logic_vector(7 downto 0);
   signal we         : std_logic;
   signal ack        : std_logic;  
   signal FPGA_TEMPi : std_logic_vector(7 downto 0);
   
   -- always NACK the ADM1023 as bytes are transfered one by one
   constant i2c_nack : std_logic := '1';
   
   -- chipscope keep attributes
   attribute keep : string;
   attribute keep of FPGA_TEMP : signal is "true";
   attribute keep of EXT_TEMP : signal is "true";
   
begin        
   process(clk)
   begin       
      if rising_edge(clk) then 
         FPGA_TEMP <= Uto0(FPGA_TEMPi);
         if FPGA_TEMPi > OVERTMP_THRES then 
            OVERTMP <= '1';
         else 
            OVERTMP <= '0';
         end if;
      end if;
   end process;
   -- Instantiate i2c_master
   i2c_master_inst : i2c_master
   port map (
      CLK => CLK,
      ARESET => ARESET,
      SCL4XSRC => scl4xsrc,
      I2C_STB => i2c_stb,
      I2C_WE => i2c_we,
      I2C_NACK => i2c_nack,
      I2C_ACK => i2c_ack,
      I2C_ERR => i2c_err,
      I2C_ACT => i2c_act,
      I2C_ADR => I2C_ADR,
      I2C_TX => i2c_tx,
      I2C_RX => i2c_rx,
      I2C_SCL_PIN => I2C_SCL_PIN,
      I2C_SDA_PIN => I2C_SDA_PIN);
   
   -- divide clock by 256 to drive I2C master (beter SRL implementation eventually?)
   scl4xsrc_proc : process (clk)
      variable count : std_logic_vector(9 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            count := (others => '0');
         else
            count := count + 1;
         end if;
         scl4xsrc <= count(9);
      end if;
   end process scl4xsrc_proc;
   
   -- state machine for temperature reading loop
   loop_proc : process (CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            cs_lp <= CONF;
            EXT_TEMP <= (others => '0');
            FPGA_TEMPi <= (others => '0');
         else
            case cs_lp is
               when CONF =>
                  adr  <= x"09";     -- write configuration byte command
                  dout <= x"C0";     -- disable ALERT and put in standby mode
                  we   <= '1';
                  if (ack = '1') then
                     cs_lp <= RATE;
                  end if;
               when RATE =>
                  adr  <= x"0A";      -- write rate byte command
                  dout <= x"07";      -- 8Hz conversion rate setting
                  we   <= '1';
                  if (ack = '1') then
                     cs_lp <= ONESHOT;
                  end if;
               when ONESHOT =>
                  adr  <= x"0F";      -- write to one shot register
                  dout <= x"FF";      -- data is don't care
                  we   <= '1';
                  if (ack = '1') then
                     cs_lp <= STAT;
                  end if;            
               when STAT =>
                  adr <= x"02";       -- read status register to check if conversion done
                  we  <= '0';
                  if (ack = '1' and din(7) = '0') then
                     cs_lp <= CHIP;
                  end if;
               when CHIP =>
                  adr <= x"00";       -- read local temp byte command 
                  we  <= '0';
                  if (ack = '1') then
                     cs_lp <= FPGA;
                     if din = x"FF" then
                        EXT_TEMP <= (others => '0');
                     else
                        EXT_TEMP <= Uto0(din);
                     end if;                     
                  end if;
               when FPGA =>
               adr <= x"01";      -- read remote temp byte command
               we   <= '0';
               if (ack = '1') then
                  cs_lp <= ONESHOT;
                  if din = x"FF" then
                     FPGA_TEMPi <= (others => '0');
                  else
                     FPGA_TEMPi <= din;
                  end if;
               end if;
            end case;
         end if;
      end if;
   end process loop_proc;
   
   -- state machine for reading / writing remote registers via I2C bus
   remote_proc : process (CLK)
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            cs_rem    <= IDLE;
            
         else
            case cs_rem is
               when IDLE =>
                  i2c_we  <= '1';
                  i2c_tx  <= adr;
                  ack <= '0';
                  if (i2c_act = '0') then
                     i2c_stb <= '1';
                     cs_rem  <= REGADR;
                  else
                     i2c_stb <= '0';
                  end if;
               when REGADR =>
                  if (i2c_ack = '1') then
                     i2c_tx <= dout;
                     i2c_we <= we;
                     cs_rem <= REGDATA;
                  else
                     cs_rem <= REGADR;
                  end if;
               when REGDATA =>
               din <= i2c_rx;
               if (i2c_ack = '1') then
                  i2c_stb <= '0';
                  ack <= '1';
                  cs_rem <= IDLE;
               else
                  i2c_stb <= '1';
                  ack <= '0';
                  cs_rem <= REGDATA;
               end if;
               
            end case;
         end if;
      end if;
   end process remote_proc;
   
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

-- simulation architecture for faster operation
-- translate_off
architecture asim of temp_reader is 
   signal rst_sync : std_logic;
   
begin              
   OVERTMP <= '0';
   
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
   
   -- Fast simulation of reader
   sim_proc : process(CLK)
      variable fpga_temp_loc : std_logic_vector(7 downto 0);
      variable ext_temp_loc : std_logic_vector(7 downto 0);
   begin
      if (CLK'event and CLK = '1') then
         if (rst_sync = '1') then
            fpga_temp_loc := x"63";
            ext_temp_loc  := x"44";
         else
            --fpga_temp_loc := fpga_temp_loc + 1;
            --ext_temp_loc  := ext_temp_loc + 1;
         end if;
      end if;
      FPGA_TEMP <= Uto0(fpga_temp_loc);
      EXT_TEMP  <= Uto0(ext_temp_loc);
   end process sim_proc;
   
   I2C_SCL_PIN <= 'H';
   I2C_SDA_PIN <= 'H';
   
end asim;
-- translate_on


