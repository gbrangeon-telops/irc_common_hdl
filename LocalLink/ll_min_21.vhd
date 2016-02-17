---------------------------------------------------------------------------------------------------
--
-- Title       : ll_min_21
-- Author      : Patrick Daraiche
-- Company     : Telops Inc.
--
---------------------------------------------------------------------------------------------------
-- $Author$
-- $LastChangedDate$
-- $Revision$ 
---------------------------------------------------------------------------------------------------
--
-- File        : d:\Telops\Common_HDL\Telops_Memory_Interface\TMI_LL_LUT\src\ll_min_21.vhd
-- Generated   : Mon May 17 09:07:00 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : Module that output the minimum value of two local_link inputs
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ll_min_21} architecture {ll_min_21}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library common_hdl;
use Common_HDL.all;
use common_hdl.telops.all;

entity ll_min_21 is
    generic(
      SOF_EOF_Mode : natural := 0 -- 0: SOF_EOF taken from A, 1: SOF_EOF taken from B, 2, SOF from A, EOF from B 
      );
	 port(
		 A_MOSI : in t_ll_mosi21;
		 ARESET : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 B_MOSI : in t_ll_mosi21;
		 RES_MISO : in t_ll_miso;
		 A_MISO : out t_ll_miso;
		 B_MISO : out t_ll_miso;
		 RES_MOSI : out t_ll_mosi21
	     );
end ll_min_21;

--}} End of automatically maintained section

architecture ll_min_21 of ll_min_21 is

   signal sync_busy  : std_logic;
   signal sync_dval  : std_logic;   
   
   signal break_mosi : t_ll_mosi21;
   signal break_miso : t_ll_miso;
   
   signal SOF           : std_logic;
   signal EOF           : std_logic;
   
   signal a_data     : std_logic_vector(20 downto 0);
   signal b_data     : std_logic_vector(20 downto 0);

begin

   sync_A_B : entity ll_sync_flow
   port map(
      RX0_DVAL => A_MOSI.DVAL,
      RX0_BUSY => A_MISO.BUSY,
      RX0_AFULL => A_MISO.AFULL,
      RX1_DVAL => B_MOSI.DVAL,
      RX1_BUSY => B_MISO.BUSY,
      RX1_AFULL => B_MISO.AFULL,
      SYNC_BUSY => sync_busy,
      SYNC_DVAL => sync_dval
      ); 
   sync_busy <= break_MISO.BUSY; 
   
   a_data <= Uto0(A_MOSI.DATA) when FALSE
   -- translate_off
   or A_MOSI.DVAL = '0'
   -- translate_on
   else A_MOSI.DATA; 
      
   b_data <= Uto0(B_MOSI.DATA) when FALSE
   -- translate_off
   or B_MOSI.DVAL = '0'
   -- translate_on
   else B_MOSI.DATA;
      
   --SOF_EOF GENERATE
   SOF_EOF_0 : if (SOF_EOF_Mode = 0) generate
      SOF <= A_MOSI.SOF;
      EOF <= A_MOSI.EOF; 
   end generate SOF_EOF_0;
   
   SOF_EOF_1 : if (SOF_EOF_Mode = 1) generate
      SOF <= B_MOSI.SOF;
      EOF <= B_MOSI.EOF; 
   end generate SOF_EOF_1;
   
   SOF_EOF_2 : if (SOF_EOF_Mode = 2) generate
      SOF <= A_MOSI.SOF;
      EOF <= B_MOSI.EOF; 
   end generate SOF_EOF_2;
   
   break_MOSI.SOF <= SOF;
   break_MOSI.EOF <= EOF;   
      
      
      
   --break_MOSI.SOF <= '0';
   --break_MOSI.EOF <= '0';
   break_MOSI.DATA <= A_MOSI.DATA when unsigned(a_data) <= unsigned(b_data) else b_data; 
   break_MOSI.DVAL <= sync_dval; 
   break_MOSI.SUPPORT_BUSY <= '1';
   
   -- Provide output registers
   reg : entity ll_busybreak_21
   port map(
      RX_MOSI => break_mosi,
      RX_MISO => break_miso,
      TX_MOSI => RES_MOSI,
      TX_MISO => RES_MISO,
      ARESET => ARESET,
      CLK => CLK
      );   

end ll_min_21;
