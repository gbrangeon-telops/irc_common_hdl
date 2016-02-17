--
--      Project:  Aurora Module Generator version 2.4
--
--         Date:  $Date$
--          Tag:  $Name: i+J-30+116697 $
--         File:  $RCSfile: clock_module_v4_vhd.ejava,v $
--          Rev:  $Revision$
--
--      Company:  Xilinx
-- Contributors:  R. K. Awalt, B. L. Woodard, N. Gulstone
--
--   Disclaimer:  XILINX IS PROVIDING THIS DESIGN, CODE, OR
--                INFORMATION "AS IS" SOLELY FOR USE IN DEVELOPING
--                PROGRAMS AND SOLUTIONS FOR XILINX DEVICES.  BY
--                PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
--                ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
--                APPLICATION OR STANDARD, XILINX IS MAKING NO
--                REPRESENTATION THAT THIS IMPLEMENTATION IS FREE
--                FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE
--                RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY
--                REQUIRE FOR YOUR IMPLEMENTATION.  XILINX
--                EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH
--                RESPECT TO THE ADEQUACY OF THE IMPLEMENTATION,
--                INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
--                REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
--                FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES
--                OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
--                PURPOSE.
--
--                (c) Copyright 2004 Xilinx, Inc.
--                All rights reserved.
--

--
--  Aurora_Clocks_V4
--
--  Author: Nigel Gulstone
--          Xilinx - Embedded Networking System Engineering Group
--
--  VHDL Translation: Brian Woodard
--                    Xilinx - Garden Valley Design Team
--
--  Description: A module provided as a convenience for desingners using 4-byte
--               lane Aurora Modules. This module takes the MGT reference clock as
--               input, and produces a divided clock on a global clock net suitable
--               for driving application logic connected to the Aurora User Interface.
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- synthesis translate_off
library UNISIM;
use UNISIM.all;
-- synthesis translate_on

entity Aurora_Clocks_V4 is
   
   port (
      
      MGT_CLK                 : in std_logic;
      MGT_CLK_LOCKED          : in std_logic;
      USER_CLK                : out std_logic;
      SYNC_CLK                : out std_logic;
      DCM_NOT_LOCKED          : out std_logic
      
      );
   
end Aurora_Clocks_V4; 

-- translate_off
architecture asim of Aurora_Clocks_V4 is       
   signal SYNC_CLKi : std_logic;
begin                
   
   SYNC_CLK <= not SYNC_CLKi; 
   USER_CLK <= MGT_CLK;
   
   clock_proc : process (MGT_CLK)
      variable delay : integer range 0 to 31 := 0;
   begin          
      if MGT_CLK_LOCKED = '0' then
         DCM_NOT_LOCKED <= '1';
      elsif rising_edge(MGT_CLK) then
         if delay < 31 then
            delay := delay + 1;
         end if;                                
         if delay > 25 then
            DCM_NOT_LOCKED <= '0';
         else              
            DCM_NOT_LOCKED <= '1';
         end if;     
         if delay < 3 then
            SYNC_CLKi <= '0';   
         else
            SYNC_CLKi <= not SYNC_CLKi;
         end if;
      end if;
      
   end process;   
   
end asim;
-- translate_on

architecture MAPPED of Aurora_Clocks_V4 is
   
   -- Wire Declarations --
   
   signal not_connected_i          : std_logic_vector(15 downto 0);
   signal mgt_clk_not_locked_i     : std_logic;
   signal clkfb_i                  : std_logic;
   signal clkdv_i                  : std_logic;
   signal clk0_i                   : std_logic;
   signal locked_i                 : std_logic;
   
   signal tied_to_ground_i         : std_logic;
   
   -- Component Declarations --
   
   component DCM_ADV
      generic( CLK_FEEDBACK : string :=  "1X";
         CLKDV_DIVIDE : real :=  2.0;
         CLKFX_DIVIDE : integer :=  3;
         CLKFX_MULTIPLY : integer :=  4;
         CLKIN_DIVIDE_BY_2 : boolean :=  FALSE;
         CLKIN_PERIOD : real :=  10.0;
         CLKOUT_PHASE_SHIFT : string :=  "NONE";
         DCM_AUTOCALIBRATION : boolean :=  TRUE;
         DCM_PERFORMANCE_MODE : string :=  "MAX_SPEED";
         DESKEW_ADJUST : string :=  "SYSTEM_SYNCHRONOUS";
         DFS_FREQUENCY_MODE : string :=  "LOW";
         DLL_FREQUENCY_MODE : string :=  "LOW";
         DUTY_CYCLE_CORRECTION : boolean :=  TRUE;
         FACTORY_JF : bit_vector :=  x"F0F0";
         PHASE_SHIFT : integer :=  0;
         STARTUP_WAIT : boolean :=  FALSE;
         SIM_DEVICE : string :=  "VIRTEX4");
      port ( CLKIN    : in    std_logic; 
         CLKFB    : in    std_logic; 
         DADDR    : in    std_logic_vector (6 downto 0); 
         DI       : in    std_logic_vector (15 downto 0); 
         DWE      : in    std_logic; 
         DEN      : in    std_logic; 
         DCLK     : in    std_logic; 
         RST      : in    std_logic; 
         PSEN     : in    std_logic; 
         PSINCDEC : in    std_logic; 
         PSCLK    : in    std_logic; 
         CLK0     : out   std_logic; 
         CLK90    : out   std_logic; 
         CLK180   : out   std_logic; 
         CLK270   : out   std_logic; 
         CLKDV    : out   std_logic; 
         CLK2X    : out   std_logic; 
         CLK2X180 : out   std_logic; 
         CLKFX    : out   std_logic; 
         CLKFX180 : out   std_logic; 
         DRDY     : out   std_logic; 
         DO       : out   std_logic_vector (15 downto 0); 
         LOCKED   : out   std_logic; 
         PSDONE   : out   std_logic);
   end component;
   
   
   component BUFG
      
      port (
         
         O : out std_ulogic;
         I : in  std_ulogic
         
         );
      
   end component;
   
   
   component INV
      
      port (
         
         O : out std_ulogic;
         I : in  std_ulogic
         
         );
      
   end component;    
   
   signal GND_BUS_7         : std_logic_vector (6 downto 0);
   signal GND_BUS_16        : std_logic_vector (15 downto 0);   
   
begin                   
   GND_BUS_7(6 downto 0) <= "0000000";
   GND_BUS_16(15 downto 0) <= "0000000000000000";   
   
   tied_to_ground_i <= '0';
   
   -- ************************Main Body of Code *************************--
   
   
   -- Invert the MGT_CLK_LOCKED signal
   mgt_clk_not_locked_i    <=  not MGT_CLK_LOCKED;
   
   -- Instantiate a DCM module to divide the reference clock.
   
   clock_divider_i : DCM_ADV
   generic map( CLK_FEEDBACK => "1X",
   CLKDV_DIVIDE => 2.0,
   CLKFX_DIVIDE => 1,
   CLKFX_MULTIPLY => 4,
   CLKIN_DIVIDE_BY_2 => FALSE,
   CLKIN_PERIOD => 10.000,
   CLKOUT_PHASE_SHIFT => "NONE",
   DCM_AUTOCALIBRATION => FALSE,
   DCM_PERFORMANCE_MODE => "MAX_SPEED",
   DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS",
   DFS_FREQUENCY_MODE => "LOW",
   DLL_FREQUENCY_MODE => "LOW",
   DUTY_CYCLE_CORRECTION => TRUE,
   FACTORY_JF => x"F0F0",
   PHASE_SHIFT => 0,
   STARTUP_WAIT => FALSE)   
   port map
      (                  
      DADDR(6 downto 0)=>GND_BUS_7(6 downto 0),              
      DCLK=>tied_to_ground_i,          
      DEN=>tied_to_ground_i,
      DI(15 downto 0)=>GND_BUS_16(15 downto 0),
      DWE=>tied_to_ground_i,
      DO=>open,
      DRDY=>open,      
      CLK0     => clk0_i,
      CLK180   => open,
      CLK270   => open,
      CLK2X    => open,
      CLK2X180 => open,
      CLK90    => open,
      CLKDV    => clkdv_i,
      CLKFX    => open,
      CLKFX180 => open,
      LOCKED   => locked_i,
      PSDONE   => open,
      CLKFB    => clkfb_i,
      CLKIN    => MGT_CLK,
      PSCLK    => tied_to_ground_i,
      PSEN     => tied_to_ground_i,
      PSINCDEC => tied_to_ground_i,
      RST      => mgt_clk_not_locked_i
      );
   
   
   -- BUFG for the feedback clock.  The feedback signal is phase aligned to the input
   -- and must come from the CLK0 or CLK2X output of the DCM.  In this case, we use
   -- the CLK0 output.
   
   feedback_clock_net_i : BUFG
   port map
      (
      I => clk0_i,
      O => clkfb_i
      );
   
   
   -- The feedback clock is also USER_CLK 
   USER_CLK <= clkfb_i;
   
   
   -- The SYNC CLK  is distributed on a global clock net.
   sync_clk_net_i : BUFG
   port map
      (
      I => clkdv_i,
      O => SYNC_CLK
      );
   
   
   -- The DCM_NOT_LOCKED signal is created by inverting the DCM's locked signal.
   DCM_NOT_LOCKED <= not locked_i;
   
   
end MAPPED;
