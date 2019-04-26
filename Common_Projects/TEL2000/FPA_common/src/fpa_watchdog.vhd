------------------------------------------------------------------
--!   @file : fpa_watchdog
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
use IEEE.STD_LOGIC_1164.all;

entity fpa_watchdog is
   
   
   
   
end fpa_watchdog;


architecture rtl of fpa_watchdog is 
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   component double_sync is
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D     : in std_logic;
         Q     : out std_logic := '0';
         RESET : in std_logic;
         CLK   : in std_logic
         );
   end component;
   
   
begin 
   
   
   --------------------------------------------------
   -- synchro 
   --------------------------------------------------   
   U0 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );    
   
   U1 : double_sync
   port map(
      CLK => CLK,
      D   => ACQ_TRIG,
      Q   => acq_trig_i,
      RESET => sreset
      ); 
   
   U2 : double_sync
   port map(
      CLK => CLK,
      D   => ACQ_INT,
      Q   => acq_int_i,
      RESET => sreset
      ); 
   
   U3 : double_sync
   port map(
      CLK => CLK,
      D   => READOUT,
      Q   => readout_i,
      RESET => sreset
      );    
   
   ------------------------------------------------------
   --  les compteurs
   ------------------------------------------------------
   U4: process(CLK)
      
   begin
      if rising_edge(CLK) then
         if sreset = '1' then 
            acq_trig_cnt  <= (others => '0');
            acq_int_cnt   <= (others => '0');
            readout_cnt   <= (others => '0');
            pix_cnt_min   <= (others => '0');
            pix_cnt_max   <= (others => '0');
            acq_trig_last <= '0';
            acq_int_last  <= '0';
            readout_last  <= '0'; 
         else 
            
            acq_trig_last <= acq_trig_i;
            acq_int_last  <= acq_int_i;
            readout_last  <= readout_i;
            
            if acq_trig_last = '0' and acq_trig_i = '1' then 
               acq_trig_cnt <= acq_trig_cnt + 1; 
            end if;
            
            if acq_int_last = '0' and acq_int_i = '1' then 
               acq_int_cnt <= acq_int_cnt + 1; 
            end if;
            
            if readout_last = '0' and readout_i = '1' then 
               readout_cnt <= readout_cnt + 1; 
            end if;
            
         end if;
      end if;
   end process;
   
end rtl;
