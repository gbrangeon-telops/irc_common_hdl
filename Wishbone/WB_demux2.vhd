
library ieee;
use ieee.std_logic_1164.all;   

library Common_HDL;
use Common_HDL.Telops.all;

----------------------------------------------------------------------
-- Entity declaration.
----------------------------------------------------------------------

entity WB_demux2 is       
   port (
      M0_WB_MOSI : in   t_wb_mosi32;
      M0_WB_MISO : out  t_wb_miso32;
      
      SEL        : in   std_logic;
      
      S0_WB_MOSI : out  t_wb_mosi32;
      S0_WB_MISO : in   t_wb_miso32;
      
      S1_WB_MOSI : out  t_wb_mosi32;
      S1_WB_MISO : in   t_wb_miso32
      );
   
end entity WB_demux2;


----------------------------------------------------------------------
-- Architecture definition.
----------------------------------------------------------------------

architecture RTL of WB_demux2 is  
   
begin 
   
   M0_WB_MISO  <= S0_WB_MISO when SEL = '0' else S1_WB_MISO;
   
   S0_WB_MOSI.DAT    <= M0_WB_MOSI.DAT;
   S0_WB_MOSI.SEL    <= M0_WB_MOSI.SEL;
   S0_WB_MOSI.WE     <= M0_WB_MOSI.WE;
   S0_WB_MOSI.ADR    <= M0_WB_MOSI.ADR;
   S0_WB_MOSI.CYC    <= M0_WB_MOSI.CYC;
   S0_WB_MOSI.STB    <= M0_WB_MOSI.STB when SEL = '0' else '0';
   
   S1_WB_MOSI.DAT    <= M0_WB_MOSI.DAT;
   S1_WB_MOSI.SEL    <= M0_WB_MOSI.SEL;
   S1_WB_MOSI.WE     <= M0_WB_MOSI.WE;
   S1_WB_MOSI.ADR    <= M0_WB_MOSI.ADR;
   S1_WB_MOSI.CYC    <= M0_WB_MOSI.CYC;
   S1_WB_MOSI.STB    <= M0_WB_MOSI.STB when SEL = '1' else '0';
   
end architecture RTL;

