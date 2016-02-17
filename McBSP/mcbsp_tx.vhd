---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: mcbsp_tx.vhd
--  Hierarchy: Sub-module file
--  Use: McBSP serial interface for transmission
--
--  Revision history:  (use SVN for exact code history)
--    BCO : Feb 19, 2007 - original implementation
--    SSA : MAR 30, 2007 - adapation
--
--  Notes:
--
--  $Revision$ 
--  $Author$
--  $LastChangedDate$
---------------------------------------------------------------------------------------------------

library IEEE;
library common_hdl;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mcbsp_tx is 
   generic(
      WIDTH : integer := 32
      );
   port(
      CLK : in std_logic;  
      -- McBSP TX interface
      DIN : in std_logic_vector(WIDTH-1 downto 0);
      DIN_EN : in std_logic;    -- trigger a word transmission
      McBSP_CLKX : in std_logic;
      McBSP_DX : out std_logic;
      McBSP_FSX : out std_logic;
      TX_DONE : out std_logic;
      TX_ALMOST_DONE : out std_logic
      );
end mcbsp_tx;

-- This is a MCBSP Tx Block
-- For this block to work, we need a Tx CLK, The data must not be written
-- faster than it can output,  1-data delay mode

architecture RTL of mcbsp_tx is	
   
   signal mcbsp_sr, din_1p: std_logic_vector(WIDTH-1 downto 0);
   signal data_valid: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
   signal mcbsp_stb: std_logic;
   signal fsx_int, dx_int: std_logic;
   signal done_int, almost_done_int : std_logic;
   
   component sync_pulse is
      port(
         Pulse : in STD_LOGIC;
         Clk : in STD_LOGIC;
         Pulse_out_sync : out STD_LOGIC
         );
   end component;
   
begin
   
   TX_DONE <= not data_valid(0);
   TX_ALMOST_DONE <= not data_valid(1); -- bit position should be a generic?
   McBSP_FSX <= fsx_int;
   McBSP_DX <= mcbsp_sr(WIDTH-1);
   
   sync: sync_pulse
   port map(
      Pulse => DIN_EN,
      Clk => McBSP_CLKX,
      Pulse_out_sync => mcbsp_stb);  
   
   pipe_din: process(McBSP_CLKX)
   begin		
      if rising_edge(McBSP_CLKX) then
         din_1p <= DIN;				   
      end if;
   end process;
   
   mcbsp_shift: process(McBSP_CLKX)
      variable wait1: std_logic := '0';
   begin
      if rising_edge(McBSP_CLKX) then
         
         if mcbsp_stb = '1' and data_valid(0) = '0' then
            mcbsp_sr <= din_1p;	
            data_valid <= (others => '1');
            fsx_int <= '1';
            wait1 := '0';
         else
            fsx_int <= '0';
            if wait1 = '1' then -- begin serial data after frame sync
               mcbsp_sr <= mcbsp_sr(WIDTH-2 downto 0) & '0';
               data_valid <= '0' & data_valid(WIDTH-1 downto 1);
            else
               wait1 := '1';
            end if;
         end if;
      end if;
   end process;
   
end RTL;
