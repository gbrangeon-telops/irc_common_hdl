-------------------------------------------------------------------------------
--
-- Title       : LL_div_21x6
-- Author      : Patrick
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;   
use ieee.numeric_std.all;

library Common_HDL; 
use Common_HDL.all;
use Common_HDL.Telops.all;

entity LL_div_21x6 is
   port(
      NUM_MOSI    : in  t_ll_mosi21;
      NUM_MISO    : out t_ll_miso;
      
      DEN_MOSI    : in  t_ll_mosi21;
      DEN_MISO    : out t_ll_miso;      
      
      QUOT_MOSI   : out t_ll_mosi21;
      QUOT_MISO   : in  t_ll_miso; 
      
      ERR         : out std_logic;
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC	
      );
end LL_div_21x6;

architecture RTL of LL_div_21x6 is  
   
   signal div_ce  : std_logic; 
   signal div_rfd : std_logic;
   signal div_dval : std_logic;
   
   signal sync_busy  : std_logic;
   signal sync_dval  : std_logic; 
   
   signal fifo_mosi  : t_ll_mosi21;
   signal fifo_miso  : t_ll_miso;   
   
   signal RESET            : std_logic;
   
   component div_w21x6
      port (
         dividend: IN std_logic_VECTOR(20 downto 0);
         divisor: IN std_logic_VECTOR(5 downto 0);
         quot: OUT std_logic_VECTOR(20 downto 0);
         remd: OUT std_logic_VECTOR(5 downto 0);
         clk: IN std_logic;
         rfd: OUT std_logic;
         ce: IN std_logic);
   end component;   

begin                                     
   
   sync_RST : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);                  
   
   div_ce <= not fifo_miso.AFULL; 
   fifo_MOSI.SUPPORT_BUSY <= '0';
   fifo_MOSI.SOF <= '0';
   fifo_MOSI.EOF <= '0';                
   
   
   sync_A_B : entity ll_sync_flow
   port map(
      RX0_DVAL => NUM_MOSI.DVAL,
      RX0_BUSY => NUM_MISO.BUSY,
      RX0_AFULL => NUM_MISO.AFULL,
      RX1_DVAL => DEN_MOSI.DVAL,
      RX1_BUSY => DEN_MISO.BUSY,
      RX1_AFULL => DEN_MISO.AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => sync_dval
      ); 
   sync_busy <= not div_rfd or not div_ce;   
   
   divider : div_w21x6
   port map (
      dividend => NUM_MOSI.DATA,
      divisor => DEN_MOSI.DATA(5 downto 0),
      quot => fifo_MOSI.DATA,
      remd => open,
      clk => CLK,
      rfd => div_rfd,
      ce => div_ce);     
   
   div_dval_inst : entity div_gen_dval
   generic map (     
      -- Now 23 instead of 24 because the divider now does one division per clock and the formula is M+2 = 21+2 = 23
      Latency => 23) 
   port map (
      CLK => CLK,
      RST => RESET,
      DIV_CE => div_ce,
      DIV_RFD => div_rfd,
      DIV_IN_DVAL => sync_dval,
      DIV_OUT_DVAL => div_dval);
      fifo_MOSI.dval <= div_dval and div_ce;
   
   fifo : entity locallink_fifo21
   generic map(
      FifoSize => 32,
      Latency => 3,
      ASYNC => FALSE
      )
   port map(
      RX_LL_MOSI => fifo_MOSI,
      RX_LL_MISO => fifo_MISO,
      CLK_RX => CLK,
      FULL => open,
      WR_ERR => ERR,
      TX_LL_MOSI => QUOT_MOSI,
      TX_LL_MISO => QUOT_MISO,
      CLK_TX => CLK,
      EMPTY => open,
      ARESET => ARESET
      );      
   
end RTL;
