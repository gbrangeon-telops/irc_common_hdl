-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : Header_extractor
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\Common_Projects\CAMEL\Header_extractor\Active-HDL\compile\HX_WB_Interface.vhd
-- Generated   : 06/14/07 15:52:29
-- From        : D:\Telops\Common_HDL\Common_Projects\CAMEL\Header_extractor\src\HX_WB_Interface.asf
-- By          : FSM2VHDL ver. 5.0.0.9
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library Common_HDL; 	
use Common_HDL.all;
use Common_HDL.Telops.all;
use work.CAMEL_Define.all;

entity hx_wb_interface is 
   port (
      ARESET               : in STD_LOGIC;
      CLK                  : in STD_LOGIC;  
      
      RX_WB_MOSI           : in t_WB_MOSI;     -- Rx pour designer l'interface avec le PPC via Wishbone
      RX_WB_MISO           : out t_wb_miso;
      
      TX_WB_MOSI           : out t_wb_mosi; 
      TX_WB_MISO           : in t_wb_miso;     -- Tx pour designer l'interface avec le HX_Kernel 
      
      FRAME_TYPE           : in STD_LOGIC_VECTOR (7 downto 0);
      NEW_FRAME            : in STD_LOGIC;
      
      PPC_SW_SEL           : out STD_LOGIC_VECTOR (1 downto 0); 
      
      NEW_CUBE             : out STD_LOGIC;
      EOF_CUBE             : out STD_LOGIC);
end hx_wb_interface;

architecture hx_wb_interface of HX_WB_Interface is
   signal sreset                 : std_logic;   
   signal PPC_SW_SEL_i           : std_logic_vector(1 downto 0);
   
   function to_std(x:boolean) return std_logic is
      variable	y : std_logic;
   begin
      if x then
         y := '1';
      else
         y := '0';
      end if;
      return y;
   end to_std;      
   
	component sync_reset
	port(
		ARESET : in std_logic;
		SRESET : out std_logic;
		CLK : in std_logic);
	end component;
   
begin  
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);  
   
   -- envoie des données lues en memoire  , l'adresse x"FF est reservée au switch
   TX_WB_MOSI  <=  RX_WB_MOSI;
   RX_WB_MISO.DAT  <= TX_WB_MISO.DAT when RX_WB_MOSI.ADR(7 downto 0) /= x"FF"
   else  RX_WB_MOSI.DAT;  
   RX_WB_MISO.ACK  <= TX_WB_MISO.ACK when RX_WB_MOSI.ADR(7 downto 0) /= x"FF"
   else RX_WB_MOSI.STB;
   
   PPC_SW_SEL <= PPC_SW_SEL_i;   
   
   SWITCH_CMD: process(clk)
   begin 
      if rising_edge(clk) then 
         if sreset ='1' then 
            PPC_SW_SEL_i <= "11";
         else 
            if RX_WB_MOSI.ADR(7 downto 0) = x"FF" and RX_WB_MOSI.STB = '1' and RX_WB_MOSI.WE = '1' then
               PPC_SW_SEL_i <= RX_WB_MOSI.DAT(1 downto 0); 
            end if;
         end if; 
      end if;
   end process;  
   
   CUBE_DETECTION: process(clk)
      --variable Cube_valid_var : std_logic;
   begin 
      if rising_edge(clk) then 
         if sreset ='1' then  
            NEW_CUBE   <= '0';  
            EOF_CUBE   <= '0';   
         else 
            
            if (NEW_FRAME='1' and FRAME_TYPE=ROIC_HEADER_FRAME) then
               NEW_CUBE <= '1';     
            else 
               NEW_CUBE <= '0';
            end if;                   
            
            if (NEW_FRAME='1' and FRAME_TYPE=ROIC_FOOTER_FRAME) then
               EOF_CUBE <= '1';
            else 
               EOF_CUBE <= '0';
            end if;   
            
         end if; 
      end if;
   end process;  
   
end HX_WB_Interface;
