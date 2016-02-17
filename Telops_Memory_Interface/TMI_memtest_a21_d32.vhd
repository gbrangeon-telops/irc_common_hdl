--------------------------------------------------------------------------------------------------
--
-- Title       : TMI_memtest_a21_d32
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author: rd\ssavary $
-- $LastChangedDate: 2010-05-12 16:39:08 -0400 (mer., 12 mai 2010) $
-- $Revision: 7905 $ 
---------------------------------------------------------------------------------------------------
--
-- Description :  
--
---------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;
library work;
use work.LfsrStd_Pkg.all;

entity TMI_memtest_a21_d32 is
   generic(
      Random_Pattern : boolean := TRUE;   -- Pseudo-random data pattern for self-test. Linear data is false.
      Random_dval : boolean := FALSE; -- pseudo-random dval pattern
      random_dval_seed : std_logic_vector(3 downto 0) := x"1" -- --Pseudo-random generator seed
      );
   port(
      --------------------------------
      -- Control port
      --------------------------------
      START_TEST  : in  std_logic;        -- Needs a 0 to 1 transition to trigger another test. Can be tied to '1' to execute test once after reset.
      TEST_DONE   : out std_logic;
      TEST_PASS   : out std_logic;
      ERR_FLAG    : out std_logic_vector(1 downto 0);
      --------------------------------
      -- TMI Interface
      --------------------------------  
      TMI_MOSI   : out t_tmi_mosi_a21_d32;
      TMI_MISO   : in  t_tmi_miso_d32;       
      
      --------------------------------
      -- Others IOs
      --------------------------------
      ARESET      : in  std_logic;
      CLK         : in  std_logic              
      );
end TMI_memtest_a21_d32;

architecture RTL of TMI_memtest_a21_d32 is
   
   
begin
   
   test : entity tmi_memtest
   generic map(
      Random_Pattern => Random_Pattern,
      Random_dval => Random_dval,
      random_dval_seed => random_dval_seed,
      DLEN => 32,
      ALEN => 21
      )
   port map(
      START_TEST => START_TEST,
      TEST_DONE => TEST_DONE,
      TEST_PASS => TEST_PASS,
      ERR_FLAG => ERR_FLAG,
      TMI_IDLE => TMI_MISO.IDLE,
      TMI_ERROR => TMI_MISO.ERROR,
      TMI_RNW => TMI_MOSI.RNW,
      TMI_ADD => TMI_MOSI.ADD,
      TMI_DVAL => TMI_MOSI.DVAL,
      TMI_BUSY => TMI_MISO.BUSY,
      TMI_RD_DATA => TMI_MISO.RD_DATA,
      TMI_RD_DVAL => TMI_MISO.RD_DVAL,
      TMI_WR_DATA => TMI_MOSI.WR_DATA,
      ARESET => ARESET,
      CLK => CLK
      );
   
end RTL;
