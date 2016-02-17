---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: gen_areset.vhd
--  Hierarchy:
--  Use: makes sure all DCMs are locked before ARESET is de-asserted. EXT_RESET is active high, ARESET
--          is active high.
--
--  Revision history:  (use SVN for exact code history)
--    SSA : Thu Apr 26 10:12:19 2007
--
--  Notes:
--
--  $Revision$ 
--  $Author$
--  $LastChangedDate$
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- pragma translate_off
library unisim;
-- pragma translate_on

entity gen_areset is
   generic(NUM_DCM : integer := 1);
   port(
      EXT_RESET      : in STD_LOGIC;
      DCM_NOT_LOCKED : in STD_LOGIC_VECTOR(NUM_DCM-1 downto 0);
      ARESET         : out STD_LOGIC  -- active high
      );
end gen_areset;


architecture rtl of gen_areset is
   signal all_not_locked : std_logic_vector(NUM_DCM-1 downto 0);
   
   component OR2 is
      port(
         O : out std_ulogic;
         
         I0 : in std_ulogic;
         I1 : in std_ulogic
         );
   end component;
   
   -- pragma translate_off
   for all: or2 use entity unisim.or2;
   -- pragma translate_on
   
begin
   all_not_locked(0) <= DCM_NOT_LOCKED(0);
   
   or2_gates: for i in 0 to NUM_DCM-2 generate
      or2_inst: or2 port map(I0 => all_not_locked(i), I1 => DCM_NOT_LOCKED(i+1), O => all_not_locked(i+1));
   end generate;
   
   o2_inst: or2 port map(I0 => all_not_locked(NUM_DCM-1), I1 => EXT_RESET, O => ARESET);  
   
end rtl;
