-------------------------------------------------------------------------------
--
-- Title       : fp32tofix_16u
-- Author      : PDU / KBE
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Wripper for fixtofp32.vhd to fix the geniric whith the desired
--                Valuse before synthesis.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity fp32tofix_16u is      
   port(
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      EXP         : in  signed(7 downto 0);  -- Same length as float_exponent_width
      
      RX_MOSI     : in  t_ll_mosi32;
      RX_MISO     : out t_ll_miso;
      
      TX_MOSI     : out t_ll_mosi32;
      TX_MISO     : in  t_ll_miso;
      
      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;
      
      ARESET     : in  std_logic;
      CLK        : in  std_logic
      );
end fp32tofix_16u;

architecture RTL of fp32tofix_16u is
   
   component fp32tofix
      generic(  
         Verbose     : boolean := false;
         SIGNED_FI   : boolean := TRUE; -- If false, less logic because always signed.
         TX_DLEN     : natural := 12 -- valid data length on the 32-bit data OUTPUT. Input is always 32 bits
         );
      port(
         AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
         EXP         : in  signed(7 downto 0);  -- Same length as float_exponent_width
         
         RX_MOSI     : in  t_ll_mosi32;
         RX_MISO     : out t_ll_miso;
         
         TX_MOSI     : out t_ll_mosi32;
         TX_MISO     : in  t_ll_miso;
         
         OVERFLOW    : out std_logic;
         UNDERFLOW   : out std_logic;
         
         ARESET      : in  STD_LOGIC;
         CLK         : in  STD_LOGIC
         );
   end component;
   
begin
   
   u0fp32tofix_16u : fp32tofix
   generic map(      
      Verbose     => FALSE,
      SIGNED_FI   => FALSE,
      TX_DLEN     => 16
      )
   port map(
      AVOID_ZERO  => AVOID_ZERO,
      EXP         => EXP,
      
      RX_MOSI     => RX_MOSI,
      RX_MISO     => RX_MISO,
      
      TX_MOSI     => TX_MOSI,
      TX_MISO     => TX_MISO,
      
      OVERFLOW    => OVERFLOW,
      UNDERFLOW   => UNDERFLOW,
      
      ARESET      => ARESET,
      CLK         => CLK
      );
   
end RTL;


