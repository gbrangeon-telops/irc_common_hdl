-------------------------------------------------------------------------------
--
-- Title       : fpa_data_cnt
-- Design      : FIR_00180_Sofradir
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180\FIR_00180_Sofradir\src\high_duration.vhd
-- Generated   : Tue Nov 22 11:24:34 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity fpa_data_cnt is 
   
   generic(
      G_INCR              : integer range 1 to 8 := 4;
      TLAST_DVAL_REQUIRED : boolean := true    -- à "true" lorsque le TLAST doit être aligné sur son DVAL
      );   
   port(
      ARESET      : in std_logic;
      CLK         : in std_logic;
      DVAL        : in std_logic;
      TLAST       : in std_logic;
      HIGH_LENGTH : out std_logic_vector(31 downto 0);
      DONE        : out std_logic
      );
end fpa_data_cnt;


architecture RTL of fpa_data_cnt is 
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;   
   
   signal meas_count : unsigned(31 downto 0);
   signal tlast_pipe : std_logic_vector(7 downto 0); 
   signal sreset     : std_logic;
   
   
begin
   
   HIGH_LENGTH <=  std_logic_vector(meas_count);
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );  
   
   
   --------------------------------------------------
   -- detection de l'horloge par mesure de sa periode
   --------------------------------------------------  
   U2 : process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            meas_count <= (others => '0');
            DONE <= '0';
            tlast_pipe <= (others => '0');
            
         else
            
            --
            if TLAST_DVAL_REQUIRED then
               tlast_pipe(0) <= TLAST and DVAL;
            else
               tlast_pipe(0) <= TLAST;
            end if;
            tlast_pipe(7 downto 1) <= tlast_pipe(6 downto 0);
            
            --
            if DVAL = '1' then 
               meas_count <= meas_count + G_INCR;
            end if;                  
            
            --
            if tlast_pipe(7) = '1' then 
               meas_count <= (others => '0'); 
            end if; 
            
            --
            DONE <= tlast_pipe(0) and not tlast_pipe(1);
            
            
         end if;
      end if;
   end process;
   
   
end RTL;
