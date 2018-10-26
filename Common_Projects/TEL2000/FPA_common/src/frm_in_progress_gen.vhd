------------------------------------------------------------------
--!   @file : frm_in_progress_gen
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
use IEEE.numeric_std.all;

entity frm_in_progress_gen is
   port(
      ARESET           : in std_logic;
      DOUT_CLK         : in std_logic;
      
      ACQ_INT          : in std_logic;
      
      DOUT_TLAST       : in std_logic;
      DOUT_TVALID      : in std_logic;
      DOUT_TREADY      : in std_logic;
      
      FRM_IN_PROGRESS : out std_logic
      );
end frm_in_progress_gen;


architecture rtl of frm_in_progress_gen is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
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
   
   signal sreset                       : std_logic;
   signal acq_int_sync                 : std_logic;
   signal acq_int_sync_last            : std_logic;
   signal sof_i                        : std_logic;
   signal eof_i                        : std_logic;
   signal frm_in_progress_i            : std_logic;
   signal frm_count                    : unsigned(7 downto 0);
   
   
begin
   
   
   FRM_IN_PROGRESS <= frm_in_progress_i;
   
   -------------------------------------------------
   -- synchronisation : reset                                
   -------------------------------------------------
   U1 : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => DOUT_CLK);
   
   -------------------------------------------------
   -- double_sync                                
   -------------------------------------------------   
   U2: double_sync
   port map(
      CLK => DOUT_CLK,
      D   => ACQ_INT,
      Q   => acq_int_sync,
      RESET => sreset
      );
   
   -------------------------------------------------
   -- process                                
   -------------------------------------------------   
   U3: process(DOUT_CLK)
   begin          
      if rising_edge(DOUT_CLK) then
         if sreset = '1' then
            frm_count <= (others => '0'); 
            acq_int_sync_last <= '1';
            eof_i <= '0';
            sof_i <= '0';
            frm_in_progress_i <= '0';
            
         else
            
            acq_int_sync_last <= acq_int_sync;        
            eof_i <= DOUT_TLAST and DOUT_TVALID and DOUT_TREADY;
            sof_i <= not acq_int_sync_last and acq_int_sync;
            
            if sof_i = '1' then               
               if eof_i = '0' then 
                  frm_count <= frm_count + 1;
               end if;
            end if;
            
            if eof_i = '1' and frm_count > 0 then
               if sof_i = '0' then
                  frm_count <= frm_count - 1;
               end if;
            end if;
            
            if frm_count = 0 then
               frm_in_progress_i <= '0';               
            else
               frm_in_progress_i <= '1';
            end if;     
            
         end if;     
      end if;    
   end process; 
   
end rtl;
