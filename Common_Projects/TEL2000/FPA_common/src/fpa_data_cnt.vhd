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
       G_INCR      : integer range 1 to 8 := 4
      );   
   port(
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC;
      DVAL        : in STD_LOGIC;
      TLAST       : in STD_LOGIC;
      HIGH_LENGTH : out STD_LOGIC_VECTOR(31 downto 0);
      DONE        : out STD_LOGIC
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
   signal tlast_pipe : std_logic_vector(2 downto 0); 
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
            
            tlast_pipe(0) <= TLAST; 
            tlast_pipe(1) <= tlast_pipe(0);
            tlast_pipe(2) <= tlast_pipe(1);
            --
            if DVAL = '1' then 
               meas_count <= meas_count + G_INCR;
            end if;                  
            
            --
            if tlast_pipe(2) = '1' then 
               meas_count <= (others => '0'); 
            end if; 
            
            --
            DONE <= tlast_pipe(0);
            
            
         end if;
      end if;
   end process;
   
   
end RTL;
