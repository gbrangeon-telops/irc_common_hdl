-------------------------------------------------------------------------------
--
-- Title       : tmi_bram
-- Author      : Khalid Bensadek
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Single-Port RAM with Synchronous Read (Read Through), directly
--               mapped onto block-ram. Heavily inspired by the XST user guide.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
library Common_HDL;
use Common_HDL.telops.all;
library UNISIM;             
use UNISIM.VCOMPONENTS.ALL;

entity tmi_bram_a21_d32 is
   generic(C_TMI_ALEN : integer := 8;
            C_INIT_FILE : string := "zero");        
   port (      
      --------------------------------
      -- TMI Interface
      --------------------------------      
      TMI_MOSI    : in t_tmi_mosi_a21_d32;
      TMI_MISO    : out  t_tmi_miso_d32;
      ---
      TMI_CLK     : in  std_logic;
      ARESET      : in std_logic
      );
   
   
end tmi_bram_a21_d32;     

architecture bram_a21_d32 of tmi_bram_a21_d32 is

component tmi_bram_v2
   generic(
      C_TMI_DLEN : integer := 32;	 -- Data length	
      C_TMI_ALEN : integer := 8;	 -- Adress length
      C_READ_LATENCY : integer := 1; -- Read Latency: between 1 and 16      
      C_BUSY_GENERATE : boolean := false;	-- Generate Pseudo-random TMI_BUSY signal  
      C_RANDOM_SEED : std_logic_vector(3 downto 0) := x"1"; -- --Pseudo-random generator seed
      C_BUSY_DURATION : integer := 20;
      C_INIT_FILE : string := "zero");  -- Duration of TMI_BUSY signal in clock cycles
   port (      
      
      TMI_IDLE                      : out  std_logic;
      TMI_ERROR                     : out  std_logic;
      TMI_RNW                       : in std_logic;
      TMI_ADD                       : in std_logic_vector(C_TMI_ALEN-1 downto 0);
      TMI_DVAL                      : in std_logic;
      TMI_BUSY                      : out  std_logic;
      TMI_RD_DATA                   : out  std_logic_vector(C_TMI_DLEN-1 downto 0);
      TMI_RD_DVAL                   : out  std_logic;
      TMI_WR_DATA                   : in std_logic_vector(C_TMI_DLEN-1 downto 0);
      TMI_CLK                       : in  std_logic;
      ARESET			    : in std_logic
      );
end component;         
   
begin

U0_tmi_bram : tmi_bram_v2
        generic map(
                C_TMI_DLEN      => 32,
                C_TMI_ALEN      => C_TMI_ALEN,
                C_READ_LATENCY  => 1, 
                C_BUSY_GENERATE => FALSE,
                C_RANDOM_SEED   => x"1",
                C_BUSY_DURATION => 20,
                C_INIT_FILE     => C_INIT_FILE
                )
        port map(
                TMI_IDLE        => TMI_MISO.IDLE,          
                TMI_ERROR       => TMI_MISO.ERROR,  
                TMI_RNW         => TMI_MOSI.RNW,  
                TMI_ADD         => TMI_MOSI.ADD(C_TMI_ALEN-1 downto 0),  
                TMI_DVAL        => TMI_MOSI.DVAL,  
                TMI_BUSY        => TMI_MISO.BUSY,  
                TMI_RD_DATA     => TMI_MISO.RD_DATA,  
                TMI_RD_DVAL     => TMI_MISO.RD_DVAL,  
                TMI_WR_DATA     => TMI_MOSI.WR_DATA ,  
                TMI_CLK         => TMI_CLK,  
                ARESET		=> ARESET                           
        );

   
end bram_a21_d32;