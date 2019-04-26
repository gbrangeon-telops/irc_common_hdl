------------------------------------------------------------------
--!   @file : edge_counter
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


entity edge_counter is
   port(
      ARESET     : in std_logic;
      CLK        : in std_logic;
      SIG        : in std_logic;
      EDGE_CNT   : out std_logic_vector(15 downto 0)
      );
end edge_counter;

architecture rtl of edge_counter is
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
   
   signal sreset     : std_logic;
   signal sig_i      : std_logic;
   signal sig_last   : std_logic;
   signal edge_cnt_i : unsigned(EDGE_CNT'LENGTH-1 downto 0);
   
begin 
   
   EDGE_CNT <= std_logic_vector(edge_cnt_i);
   
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
      D   => SIG,
      Q   => sig_i,
      RESET => sreset
      ); 
   ------------------------------------------------------
   --  le compteur
   ------------------------------------------------------
   U4: process(CLK)
      
   begin
      if rising_edge(CLK) then
         if sreset = '1' then 
            edge_cnt_i  <= (others => '0');
            sig_last <= '0';
         else 
            
            sig_last <= sig_i;
            
            if sig_last = '0' and sig_i = '1' then 
               edge_cnt_i <= edge_cnt_i + 1; 
            end if;
            
         end if;
      end if;
   end process;   
   
   
end rtl;
