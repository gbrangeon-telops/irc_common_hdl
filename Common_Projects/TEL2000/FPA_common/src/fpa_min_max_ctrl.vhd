-------------------------------------------------------------------------------
--
-- Title       : fpa_min_max_ctrl
-- Design      : FIR_00180_Sofradir
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180\FIR_00180_Sofradir\src\min_max_ctrl.vhd
-- Generated   : Tue Nov 22 12:13:49 2011
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
--library COMMON_HDL;
--use COMMON_HDL.Telops.all;

entity fpa_min_max_ctrl is
   port(
      MEAS_DATA      : in std_logic_vector(31 downto 0);
      MEAS_DONE      : in std_logic;
      ARESET         : in std_logic;
      CLK            : in std_logic;
      MEAS_MIN       : out STD_LOGIC_VECTOR(31 downto 0);
      MEAS_MAX       : out STD_LOGIC_VECTOR(31 downto 0)
      );
end fpa_min_max_ctrl;



architecture RTL of fpa_min_max_ctrl is
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;   
   
   signal sreset              : std_logic := '1';
   signal sreset_in           : std_logic;
   signal meas_min_i          : unsigned(31 downto 0);
   signal meas_max_i          : unsigned(31 downto 0);
   signal rst_cnt             : unsigned(31 downto 0);
   
   -- attribute dont_touch : string; 
   -- attribute dont_touch of meas_min_i   : signal is "true";
   -- attribute dont_touch of meas_max_i   : signal is "true"; 
   
begin
   
   MEAS_MIN <=  std_logic_vector(meas_min_i); 
   MEAS_MAX <=  std_logic_vector(meas_max_i);
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1A : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset_in
      );  
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1B : process(CLK)
   begin
      if rising_edge(CLK) then
         if sreset_in = '1' then
            rst_cnt <= (others => '0');
            sreset <= '1';
         else
            rst_cnt <= rst_cnt + 1;
            if rst_cnt = 200_000_000 then -- le reest dure 2 secondes de plus 
               sreset <= '0';
            end if;
            -- pragma translate_off
              sreset <= '0';
            -- pragma translate_on
            
         end if;
      end if;
   end process;    
   
   --------------------------------------------------
   -- detection de l'horloge par mesure de sa periode
   --------------------------------------------------  
   U2 : process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then 
            meas_min_i <= (others => '1');
            meas_max_i <= (others => '0');
         else 
            if MEAS_DONE = '1' then
               if unsigned(MEAS_DATA(31 downto 0)) < meas_min_i then 
                  meas_min_i <= unsigned(MEAS_DATA(31 downto 0));
               end if;
               if unsigned(MEAS_DATA(31 downto 0)) > meas_max_i then 
                  meas_max_i <= unsigned(MEAS_DATA(31 downto 0));
               end if;
               
            end if;
       
         end if;
      end if;
   end process;
   
   
   
end RTL;
