library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 


package LL_TMI_pkg is    
	
   type t_ll_tmi_cfg_a21_x9 is record
      START_ADD  : std_logic_vector(20 downto 0);  -- Memory start address
      END_ADD    : std_logic_vector(20 downto 0);  -- Memory stop address 
      STEP_ADD   : std_logic_vector(8 downto 0);   -- step between each read/write adresse
      WIDTH      : std_logic_vector(8 downto 0);   -- Width of each image. When the number of addresses increments (add_cnt) reaches add_cnt % WIDTH = 0, a number of addresses will be skipped.
      SKIP       : std_logic_vector(21 downto 0);   -- Number of addresses to skip when add_cnt % WIDTH = 0
      CONTROL    : std_logic_vector(2 downto 0);   -- CONTROL(0): START. Start the module                                   
                                                   -- CONTROL(1): STOP. Normal stop, stop after reaching END_ADD (only used if LOOP=1)                                                         
                                                   -- CONTROL(2): IMMEDIATE_STOP. Emergency stop, do not wait until END_ADD      
      CONFIG     : std_logic_vector(4 downto 0);   -- CONFIG(0): LOOP. When END_ADD is reached, don't stop. Instead, restart at START_ADD.
                                                   -- CONFIG(1): Start Of Address. Generate a SOF at START_ADD.
                                                   -- CONFIG(2): End Of Address. Generate a EOF at END_ADD.
                                                   -- CONFIG(3): Start Of Line. Generate a SOF at the beginning of a line (just after skipping addresses)
                                                   -- CONFIG(4): End Of Line. Generate a EOF at the end of a line (just before skipping addresses)
   end record;
   
      type t_ll_tmi_cfg_a21_x11 is record
      START_ADD  : std_logic_vector(20 downto 0);  -- Memory start address
      END_ADD    : std_logic_vector(20 downto 0);  -- Memory stop address 
      STEP_ADD   : std_logic_vector(11 downto 0);   -- step between each read/write adresse
      WIDTH      : std_logic_vector(10 downto 0);   -- Width of each image. When the number of addresses increments (add_cnt) reaches add_cnt % WIDTH = 0, a number of addresses will be skipped.
      SKIP       : std_logic_vector(21 downto 0);   -- Number of addresses to skip when add_cnt % WIDTH = 0
      CONTROL    : std_logic_vector(2 downto 0);   -- CONTROL(0): START. Start the module                                   
                                                   -- CONTROL(1): STOP. Normal stop, stop after reaching END_ADD (only used if LOOP=1)                                                         
                                                   -- CONTROL(2): IMMEDIATE_STOP. Emergency stop, do not wait until END_ADD      
      CONFIG     : std_logic_vector(4 downto 0);   -- CONFIG(0): LOOP. When END_ADD is reached, don't stop. Instead, restart at START_ADD.
                                                   -- CONFIG(1): Start Of Address. Generate a SOF at START_ADD.
                                                   -- CONFIG(2): End Of Address. Generate a EOF at END_ADD.
                                                   -- CONFIG(3): Start Of Line. Generate a SOF at the beginning of a line (just after skipping addresses)
                                                   -- CONFIG(4): End Of Line. Generate a EOF at the end of a line (just before skipping addresses)
   end record; 
                                                   
end LL_TMI_pkg;

package body LL_TMI_pkg is

end package body LL_TMI_pkg; 
