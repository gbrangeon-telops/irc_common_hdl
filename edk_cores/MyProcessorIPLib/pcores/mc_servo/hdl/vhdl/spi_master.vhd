---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005-2007
--
--  File: spi_master.vhd
--  Use: SSI / SPI serial interface master controler
--  Author: Olivier Bourgois
--
--  $Revision: 1959 $
--  $Author: rd\obourgois $
--  $LastChangedDate$
--
--  References:
--    SPI and Microwire protocols
--
--  Notes:
--    Hardwired to 24 bit transfers, SPI_NBITS can limit this and only send MSBs
--    Future improvements: generic clock division, better bit width scalling, spi_slave
--    module for future applications 
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity spi_master is
generic(
	SLAVES     : natural := 3);
port(
	CLK        : in    std_logic;
	ARST       : in    std_logic;                       -- async reset
	SCL2XSRC   : in    std_logic;                       -- enable at twice SPI Clk Freq
	SPI_DIN    : in    std_logic_vector(23 downto 0);
	SPI_DOUT   : out   std_logic_vector(23 downto 0);
	SPI_STB    : in    std_logic;                       -- Strobe = 1 to initiate SPI transfer
	SPI_CPOL   : in    std_logic;                       -- SPI Clk polarity
	SPI_CPHA   : in    std_logic;                       -- rising or falling edge of SPI Clk
	SPI_NBITS  : in    std_logic_vector(4 downto 0);    -- nb bits total to transfer
	SPI_EN_SSn : in    std_logic_vector(SLAVES-1 downto 0);
	SPI_DNE    : out   std_logic;                       -- goes 1 when transfer complete
	SPI_SCK    : out   std_logic;
	SPI_MOSI   : out   std_logic;
	SPI_MISO   : in    std_logic;
	SPI_SSn    : out   std_logic_vector(SLAVES-1 downto 0));
end entity spi_master;

architecture rtl of spi_master is

type state is 
(IDLE, SLV_SEL, PHASE0, PHASE1, RECOVER, END_XFER);

-- signal declarations
signal cs_spi         : state;
signal ns_spi         : state;
signal clk2x_en       : std_logic;
signal act            : std_logic;
signal done           : std_logic;
signal ss_n           : std_logic;
signal ld_dreg        : std_logic;
signal sh_dreg        : std_logic;
signal dreg           : std_logic_vector(23 downto 0);
signal bit_cnt        : std_logic_vector(4 downto 0);
signal last_bit       : std_logic;
signal rst_sync       : std_logic;

begin

  -- drive external signals
  SPI_MOSI <= dreg(23);
  SPI_DNE  <= not act;
  
  slave_csn : for i in SPI_EN_SSn'range generate
    SPI_SSn(i) <= ss_n or SPI_EN_SSn(i);
  end generate slave_csn;
  
  -- SPI 2X clock enable pulse generation from SCL2XSRC signal with any duty cycle
  clk2x_en_proc : process (CLK)
  variable clksrc_hist : std_logic_vector(1 downto 0);
  begin
    if (CLK'event and CLK = '1') then
      clksrc_hist(1) := clksrc_hist(0);
      clksrc_hist(0) := SCL2XSRC;
      if (clksrc_hist = "01") then -- detect rising edge
        clk2x_en <= '1';
      else
        clk2x_en <= '0';
      end if;
    end if;
  end process clk2x_en_proc;
  
   -- activate the interface when strobed, deactivate when done  
  get_strobe_proc : process (CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (rst_sync = '1' or (done = '1' and clk2x_en = '1')) then
        act <= '0';
        SPI_DOUT <= dreg;
      elsif (SPI_STB = '1') then
        act <= '1';
      end if;
    end if;
  end process get_strobe_proc;
 
   -- bit counter
  bit_cnt_proc : process (CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (clk2x_en = '1') then
        if (ld_dreg = '1') then
          bit_cnt <= SPI_NBITS;
        elsif (sh_dreg = '1') then
          bit_cnt <= bit_cnt -1;
		end if;
		if (bit_cnt <= "00001") then
          last_bit <= '1';
        else
          last_bit <= '0';
        end if;
      end if;
    end if;  
  end process bit_cnt_proc;
  
  -- synchronous part of state machine
  sync_sm_proc : process (CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (rst_sync = '1') then
        cs_spi <= IDLE;
      elsif (clk2x_en = '1') then
        cs_spi <= ns_spi;
      end if;
    end if;  
  end process sync_sm_proc;
  
  -- combinational part of state machine
  comb_sm_proc : process (act, cs_spi, last_bit)
  begin
    case cs_spi is
      when IDLE =>
        if (act = '1') then
          ns_spi <= SLV_SEL;
        else
          ns_spi <= IDLE;
        end if;
      when SLV_SEL =>
          ns_spi <= PHASE0;
      when PHASE0 =>
          ns_spi <= PHASE1;
      when PHASE1 =>
	     if (last_bit = '1') then
		    ns_spi <= RECOVER;
		  else
          ns_spi <= PHASE0;
		  end if;
      when RECOVER =>
        ns_spi <= END_XFER;        
      when END_XFER =>
        ns_spi <= IDLE;

    end case; 
  end process comb_sm_proc;
  
  -- registered moore outputs of state machine
  out_sm_proc : process (CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (clk2x_en = '1') then
        case ns_spi is
          when IDLE =>
            done    <= '0';
            ld_dreg <= '1';
            sh_dreg <= '0';
            ss_n    <= '1';
            spi_sck <= SPI_CPOL;
          when SLV_SEL =>
            done    <= '0';
            ld_dreg <= '1';
            sh_dreg <= '0';
            ss_n    <= '0';
            spi_sck <= SPI_CPOL;
          when PHASE0 =>
            done    <= '0';
            ld_dreg <= '0';
            sh_dreg <= '0';
            ss_n    <= '0';
            spi_sck <= SPI_CPOL xor SPI_CPHA;
          when PHASE1 =>
            done    <= '0';
            ld_dreg <= '0';
            sh_dreg <= '1';
            ss_n    <= '0';
            spi_sck <= not (SPI_CPOL xor SPI_CPHA);
          when RECOVER =>
            done    <= '0';
            ld_dreg <= '0';
            sh_dreg <= '0';
            ss_n    <= '0';
            spi_sck <= SPI_CPOL;
          when END_XFER =>
            done    <= '1';
            ld_dreg <= '0';
            sh_dreg <= '0';
            ss_n    <= '1';
            spi_sck <= SPI_CPOL;
        end case;
      end if;
    end if;
  end process out_sm_proc;
  
  -- infer master data shift register
  -- note: no double buffering required on SPI_DIN since we are the clock master
  shift_reg_proc : process (CLK)
  begin
    if (CLK'event and CLK = '1') then
      if (clk2x_en = '1') then
        if (ld_dreg = '1') then
          dreg    <= SPI_DIN;
        elsif (sh_dreg = '1' ) then
          dreg(23 downto 1) <= dreg(22 downto 0);
          dreg(0) <= SPI_MISO;
        end if;
      end if;
    end if;
  end process shift_reg_proc;
  
  -- manage a roc or external reset
  roc_rst : process(CLK)
  variable rst_sr : std_logic_vector(1 downto 0):= "11";
  begin
    if (CLK'event and CLK = '1') then
      rst_sr(1) := rst_sr(0);
      rst_sr(0) := To_X01(ARST);
      rst_sync <= rst_sr(1);
    end if;
  end process roc_rst;

end rtl;
