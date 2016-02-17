---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: mcbsp_rx.vhd
--  Hierarchy: Sub-module file
--  Use: McBSP serial interface for reception
--
--  Revision history:  (use SVN for exact code history)
--    BCO : original implementation
--    SSA : MAR 30, 2007 - adaptation
--
--  Notes:
--
--  $Revision$ 
--  $Author$
--  $LastChangedDate$
---------------------------------------------------------------------------------------------------

library IEEE;
library common_hdl;				
use common_hdl.all;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mcbsp_rx is 
   generic(
      WIDTH : integer := 32
      );
   port(
      CLK : in std_logic; -- FPGA clock  
      McBSP_CLKR : in std_logic;  -- DSP clock
      McBSP_DR : in std_logic;
      McBSP_FSR : in std_logic;
      DOUT : out std_logic_vector(WIDTH-1 downto 0); -- FPGA clock domain
      DOUT_EN : out std_logic -- FPGA clock domain
      );
end mcbsp_rx;

architecture RTL of mcbsp_rx is			 
   signal data_sr: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
   signal fs_sr: std_logic_vector(WIDTH downto 0) := (others => '0');   -- 1 extra bit for FS
   signal data_hold_sync, data_hold: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
   signal Word_Received: std_logic := '0';
   signal Sync_data_en, Sync_data_en_1p: std_logic := '0';
   signal sreset: std_logic := '0';
   component sync_pulse is
      port(
         Pulse : in STD_LOGIC;
         Clk : in STD_LOGIC;
         Pulse_out_sync : out STD_LOGIC
         );
   end component;
begin
   
   sync_pulse_inst : sync_pulse
   port map (
      Pulse => Word_Received,
      Clk => CLK,
      Pulse_out_sync => Sync_data_en);
   
   DOUT <=  data_hold_sync;
   DOUT_EN <= Sync_data_en_1p;	
   
   shift_data: process(McBSP_CLKR)
      
   begin
      if falling_edge(McBSP_CLKR) then
         if McBSP_FSR = '1' then
            data_sr <= (others => '0');
            fs_sr <= (0=>'1', others => '0');
            Word_Received <= '0';
         elsif fs_sr(WIDTH) = '0' then -- When '1' we have received 32 bits
            data_sr <= data_sr(WIDTH-2 downto 0) & McBSP_DR;
            fs_sr <= fs_sr(WIDTH-1 downto 0) & '0';
         end if;
         
         if fs_sr(WIDTH) = '1' then -- We are only sensitive to the rising edge
            Word_Received <= '1';	-- of Word_Received, doesnt matter if it stays high
            data_hold <= data_sr;	
         else
            Word_Received <= '0';
         end if;
      end if;
   end process;
   
   Sync_data : process(CLK)
   begin
      if rising_edge(CLK) then
         Sync_data_en_1p <= Sync_data_en;
         if Sync_data_en = '1' then
            data_hold_sync <= data_hold;
         end if;
      end if;
   end process; 
   
end RTL;
