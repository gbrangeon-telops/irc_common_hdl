------------------------------------------------------------------
--!   @file : signal_filter
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
use IEEE.NUMERIC_STD.all;
use work.tel2000.all;

entity signal_filter is
   generic(
      SCAN_WINDOW_LEN : natural range 3 to 127 := 64 -- c'Est la longueur en coups de CLK d'obersvation du signal SIG_IN
      );    
   port(
      --ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC;
      SIG_IN   : in STD_LOGIC;
      SIG_OUT  : out STD_LOGIC
      );
end signal_filter;



architecture rtl of signal_filter is
   
   constant RAW_SIG_WINDOW_LEN       : natural := SCAN_WINDOW_LEN;   -- etendue de la fenetre d'observation
   constant OUT_HIGH_THRESHOLD_VALUE : natural := (2*RAW_SIG_WINDOW_LEN)/3;
   constant OUT_LOW_THRESHOLD_VALUE  : natural := RAW_SIG_WINDOW_LEN/3;
   
   --   component sync_reset
   --      port (
   --         ARESET : in std_logic;
   --         CLK    : in std_logic;
   --         SRESET : out std_logic := '1'
   --         );
   --   end component;  
   
   --   signal sreset                      : std_logic;
   signal raw_sig_pipe                : std_logic_vector(RAW_SIG_WINDOW_LEN downto 1) := (others => '0');
   signal incr                        : integer range -1 to 1 := 0;
   signal pipe_one_num                : integer range 0 to RAW_SIG_WINDOW_LEN := 0;
   signal sig_out_i                   : std_logic := '0';
   
   attribute dont_touch              : string;
   attribute dont_touch of sig_out_i         : signal is "true";
   attribute dont_touch of raw_sig_pipe      : signal is "true";
   
begin
   
   
   SIG_OUT <= sig_out_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   --   U1 : sync_reset
   --   port map(
   --      ARESET => ARESET,
   --      CLK    => CLK,
   --      SRESET => sreset
   --      ); 
   --   
   --------------------------------------------------
   -- signal entrant dans IOB
   -------------------------------------------------- 
   U3 : process(CLK)
      
      variable raw_sig_pipe_1 : std_logic_vector(1 downto 0);
      variable raw_sig_pipe_N : std_logic_vector(1 downto 0);
      
   begin          
      if rising_edge(CLK) then 
         
         raw_sig_pipe(1) <= SIG_IN;
         raw_sig_pipe(RAW_SIG_WINDOW_LEN downto 2) <= raw_sig_pipe(RAW_SIG_WINDOW_LEN-1 downto 1);         
         
         raw_sig_pipe_1 := '0' & raw_sig_pipe(1);                                    -- fait ainsi pour eviter pb de synthèse
         raw_sig_pipe_N := '0' & raw_sig_pipe(RAW_SIG_WINDOW_LEN);                   -- fait ainsi pour eviter pb de synthèse
         
         incr <= to_integer(unsigned(raw_sig_pipe_1)) - to_integer(unsigned(raw_sig_pipe_N)); 
         
         pipe_one_num <=  pipe_one_num + incr; -- Nombre de '1' dans le pipe;
         
         if pipe_one_num >= OUT_HIGH_THRESHOLD_VALUE then         -- s'il y a au moins 2/3 de '1' alors on estime etre dans une zone stable de '1'
            sig_out_i <= '1';            
         elsif  pipe_one_num <= OUT_LOW_THRESHOLD_VALUE  then     -- s'il y a au moins 2/3 de '0' et donc moins de 1/3 de '1' alors on est dans une zone de '0'
            sig_out_i <= '0';
         else                                                     -- s'il y a entre 1/3 et 2/3 de '1' ne pas changer d'état car on est possiblement en zone instable 
            
         end if;                                          
         
      end if;
      
   end process;
   
   
end rtl;
