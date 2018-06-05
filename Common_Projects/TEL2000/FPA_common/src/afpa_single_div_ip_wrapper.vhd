------------------------------------------------------------------
--!   @file : afpa_single_div_ip_wrapper
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.fpa_common_pkg.all;


entity afpa_single_div_ip_wrapper is   
   
   port(      
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      DVDEND_MOSI    : in t_ll_ext_mosi36;
      DVDEND_MISO    : out t_ll_ext_miso;
      
      DVSOR_MOSI     : in t_ll_ext_mosi18;   
      DVSOR_MISO     : out t_ll_ext_miso;
      
      QTIENT_MOSI    : out t_ll_ext_mosi18; 
      QTIENT_MISO    : in t_ll_ext_miso;
      
      ERR            : out std_logic
      );
   
end afpa_single_div_ip_wrapper;

architecture rtl of afpa_single_div_ip_wrapper is
   
   component afpa_single_div_ip
      port (
         aclk                    : in std_logic;
         aresetn                 : in std_logic;
         s_axis_divisor_tvalid   : in std_logic;
         s_axis_divisor_tready   : out std_logic;
         s_axis_divisor_tdata    : in std_logic_vector(23 downto 0);
         s_axis_dividend_tvalid  : in std_logic;
         s_axis_dividend_tready  : out std_logic;
         s_axis_dividend_tuser   : in std_logic_vector(3 downto 0);
         s_axis_dividend_tlast   : in std_logic;
         s_axis_dividend_tdata   : in std_logic_vector(39 downto 0);
         m_axis_dout_tvalid      : out std_logic;
         m_axis_dout_tuser       : out std_logic_vector(4 downto 0);
         m_axis_dout_tlast       : out std_logic;
         m_axis_dout_tdata       : out std_logic_vector(39 downto 0)
         );
   end component;
   
   --   
   --   
   --   
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component;
   
   signal sreset          : std_logic;
   signal areset_n        : std_logic;
   
   signal dividend_tvalid : std_logic;
   signal dividend_tready : std_logic;
   signal dividend_tuser  : std_logic_vector(3 downto 0);
   signal dividend_tlast  : std_logic;
   signal dividend_tdata  : std_logic_vector(39 downto 0);
   
   signal divisor_tready  : std_logic;
   signal divisor_tdata   : std_logic_vector(23 downto 0);
   signal divisor_tvalid  : std_logic;
   
   signal dout_tvalid     : std_logic;
   signal dout_tuser      : std_logic_vector(4 downto 0);
   signal dout_tlast      : std_logic;
   signal dout_tdata      : std_logic_vector(39 downto 0);
   
   
   
begin
   
   
   ----------------------------------------------------
   -- output map
   ----------------------------------------------------
   QTIENT_MOSI.SOF   <= dout_tuser(4);
   QTIENT_MOSI.EOF   <= dout_tlast;
   QTIENT_MOSI.SOL   <= dout_tuser(2);
   QTIENT_MOSI.EOL   <= dout_tuser(1);
   QTIENT_MOSI.DATA  <= dout_tdata(QTIENT_MOSI.DATA'LENGTH-1 downto 0);
   QTIENT_MOSI.DVAL  <= dout_tvalid; 
   
   DVDEND_MISO.BUSY  <= not dividend_tready;
   DVDEND_MISO.AFULL <= '0';
   
   DVSOR_MISO.BUSY  <= not divisor_tready;
   DVSOR_MISO.AFULL <= '0';
   
   
   ERR <= dout_tuser(0);  -- division par zero
   
   ---------------------------------------------------
   -- input map
   ---------------------------------------------------
   divisor_tdata     <=  std_logic_vector(resize(signed(DVSOR_MOSI.DATA), 24));
   divisor_tvalid    <=  DVSOR_MOSI.DVAL;
   
   dividend_tvalid   <=  DVDEND_MOSI.DVAL;
   dividend_tuser    <= (DVDEND_MOSI.SOF & DVDEND_MOSI.EOF & DVDEND_MOSI.SOL & DVDEND_MOSI.EOL);
   dividend_tlast    <=  DVDEND_MOSI.EOF;
   dividend_tdata    <=  std_logic_vector(resize(signed(DVDEND_MOSI.DATA), 40)); 
   
   ----------------------------------------------------
   -- sreset
   ----------------------------------------------------
   areset_n <= not ARESET;
   UA: sync_reset
   Port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
   ----------------------------------------------------
   --
   ----------------------------------------------------
   UB: afpa_single_div_ip
   port  map (
      aclk                    => CLK,
      aresetn                 => areset_n,
      
      s_axis_divisor_tvalid   => divisor_tvalid,   
      s_axis_divisor_tready   => divisor_tready,   
      s_axis_divisor_tdata    => divisor_tdata,    
      
      s_axis_dividend_tvalid  => dividend_tvalid,  
      s_axis_dividend_tready  => dividend_tready,  
      s_axis_dividend_tuser   => dividend_tuser,   
      s_axis_dividend_tlast   => dividend_tlast,   
      s_axis_dividend_tdata   => dividend_tdata,  
      
      m_axis_dout_tvalid      => dout_tvalid,      
      m_axis_dout_tuser       => dout_tuser,       
      m_axis_dout_tlast       => dout_tlast,       
      m_axis_dout_tdata       => dout_tdata       
      );
   
end rtl;
