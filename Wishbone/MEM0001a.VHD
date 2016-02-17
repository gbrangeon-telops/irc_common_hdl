----------------------------------------------------------------------
-- Module name:     MEM0001a.VHD
--
-- Description:     An 8 x 32-bit memory interface with a WISHBONE
--                  SLAVE interface for a Xilinx distributed,
--                  synchronous RAM.  For more information, please
--                  refer to the WISHBONE Public Domain Library
--                  Technical Reference Manual.
--
--
-- History:         Project complete:           SEP 13, 2001
--                                              WD Peterson
--                                              Silicore Corporation
--
-- Release:         Notice is hereby given that this document is not
--                  copyrighted, and has been placed into the public
--                  domain.  It may be freely copied and distributed
--                  by any means.
--
-- Disclaimer:      In no event shall Silicore Corporation be liable
--                  for incidental, consequential, indirect or special
--                  damages resulting from the use of this file.  The
--                  user assumes all responsibility for its use.
--
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Load the IEEE 1164 library and make it visible.
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;   
-- synopsys translate_off
library UNISIM;
use UNISIM.Vcomponents.ALL;
-- synopsys translate_on   
library Common_HDL;
use Common_HDL.Telops.all;

----------------------------------------------------------------------
-- Entity declaration.
----------------------------------------------------------------------

entity MEM0001a is
   port (
      WB_MOSI : in t_wb_mosi;
      WB_MISO : out  t_wb_miso;
      
      CLK:  in  std_logic
      );
   
end entity MEM0001a;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture MEM0001a1 of MEM0001a is 
--   alias ACK_O : std_logic is WB_MISO.ACK;
--   alias DAT_O : std_logic_vector(WB_MISO.DAT'LENGTH-1 downto 0) is WB_MISO.DAT;
--   alias ADR_I : std_logic_vector(WB_MOSI.ADR'LENGTH-1 downto 0) is WB_MOSI.ADR;
--   alias DAT_I : std_logic_vector(WB_MOSI.DAT'LENGTH-1 downto 0) is WB_MOSI.DAT;
--   alias STB_I : std_logic is WB_MOSI.STB;
--   alias WE_I  : std_logic is WB_MOSI.WE;

   signal ACK_O : std_logic;
   signal DAT_O : std_logic_vector(WB_MISO.DAT'LENGTH-1 downto 0);
   signal ADR_I : std_logic_vector(WB_MOSI.ADR'LENGTH-1 downto 0);
   signal DAT_I : std_logic_vector(WB_MOSI.DAT'LENGTH-1 downto 0);
   signal STB_I : std_logic;
   signal WE_I  : std_logic;
   
   
   ------------------------------------------------------------------
   -- Define the memory component.
   ------------------------------------------------------------------
   
	-- Component declaration of the "ram16x8s(ram16x8s_v)" unit defined in
	-- file: "./src/unisim_vital.vhd"
	component ram16x8s
	generic(
		INIT_00 : BIT_VECTOR(15 downto 0) := X"0000";
		INIT_01 : BIT_VECTOR(15 downto 0) := X"0000";
		INIT_02 : BIT_VECTOR(15 downto 0) := X"0000";
		INIT_03 : BIT_VECTOR(15 downto 0) := X"0000";
		INIT_04 : BIT_VECTOR(15 downto 0) := X"0000";
		INIT_05 : BIT_VECTOR(15 downto 0) := X"0000";
		INIT_06 : BIT_VECTOR(15 downto 0) := X"0000";
		INIT_07 : BIT_VECTOR(15 downto 0) := X"0000");
	port(
		O : out std_logic_vector(7 downto 0);
		A0 : in std_ulogic;
		A1 : in std_ulogic;
		A2 : in std_ulogic;
		A3 : in std_ulogic;
		D : in std_logic_vector(7 downto 0);
		WCLK : in std_ulogic;
		WE : in std_ulogic);
	end component;    
   -- pragma translate_off
	for all: ram16x8s use entity unisim.ram16x8s(ram16x8s_v);
   -- pragma translate_on

   
   
   ------------------------------------------------------------------
   -- Define internal signals.
   ------------------------------------------------------------------
   
   signal  LACK_O:     std_logic;
   signal  LADR:       std_logic_vector(  3 downto 0 );
   signal  LDAT_O:     std_logic_vector( 31 downto 0 );
   signal  LDAT_I:     std_logic_vector( 31 downto 0 );
   signal  WE:         std_logic;
   
   
begin
   
   ------------------------------------------------------------------
   -- Connect up the signals on the individual components.
   ------------------------------------------------------------------
   
   WB_MISO.ACK <= ACK_O; 
   WB_MISO.DAT <= DAT_O; 
   ADR_I <= WB_MOSI.ADR;
   DAT_I <= WB_MOSI.DAT;
   STB_I <= WB_MOSI.STB;
   WE_I  <= WB_MOSI.WE;   
   
--   U00: component ram08x32
--   port map(
--      A       =>  LADR,
--      CLK     =>  CLK,
--      D       =>  LDAT_I,
--      WE      =>  WE,
--      SPO     =>  LDAT_O
--      );
   
   -- RAM16X8S: 16 x 8 posedge write distributed => LUT RAM
   -- Virtex-II/II-Pro
   -- Xilinx HDL Language Template version 6.1i
   LSB_RAM : RAM16X8S
   port map (
      O => DAT_O(7 downto 0), -- 8-bit RAM data output
      A0 => ADR_I(0), -- RAM address[0] input
      A1 => ADR_I(1), -- RAM address[1] input
      A2 => ADR_I(2), -- RAM address[2] input
      A3 => ADR_I(3), -- RAM address[3] input
      D => DAT_I(7 downto 0), -- 8-bit RAM data input
      WCLK => CLK, -- Write clock input
      WE => WE -- Write enable input
      );    
      
   MSB_RAM : RAM16X8S
   port map (
      O => DAT_O(15 downto 8), -- 8-bit RAM data output
      A0 => ADR_I(0), -- RAM address[0] input
      A1 => ADR_I(1), -- RAM address[1] input
      A2 => ADR_I(2), -- RAM address[2] input
      A3 => ADR_I(3), -- RAM address[3] input
      D => DAT_I(15 downto 8), -- 8-bit RAM data input
      WCLK => CLK, -- Write clock input
      WE => WE -- Write enable input
      );      
   
   
 
   
   ------------------------------------------------------------------
   -- Generate the write enable signal.
   ------------------------------------------------------------------
   
   WRITE_ENABLE: process( STB_I, WE_I )
   begin
      WE <= STB_I and WE_I;
      
   end process WRITE_ENABLE;
   
   
   ------------------------------------------------------------------
   -- Generate the [ACK_O] acknowledge signal.  Since these memories
   -- will operate at zero wait states, the [ACK_O] signal can be
   -- asserted whenever the [STB_I] signal is asserted.
   ------------------------------------------------------------------
   
   ACKNOWLEDGE: process( STB_I )
   begin
      
      LACK_O <= STB_I;
      
   end process ACKNOWLEDGE;
   
   
   ------------------------------------------------------------------
   -- Make some of the local signals visible outside of the entity.
   ------------------------------------------------------------------
   
   MAKE_VISIBLE: process( LACK_O, LDAT_O, LDAT_I )
   begin
      
      ACK_O <= LACK_O;
      --DAT_O <= LDAT_O(15 downto 0);            
      --LDAT_I <= X"0000" & DAT_I;
      
   end process MAKE_VISIBLE;
   
   
end architecture MEM0001a1;

