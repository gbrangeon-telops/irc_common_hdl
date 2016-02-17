---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  Author: Olivier Bourgois
--
--  File: ll_32_to_64.vhd
--  Use:  Block for converting a 32 bit Localink Bus into a 64 bit LocalLink Bus
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL; 
use Common_HDL.Telops.all;

entity ll_32_to_64 is
   port(
      CLK       : in  std_logic;
      ARESET    : in  std_logic;
      RX_MOSI   : in  t_ll_mosi32;
      RX_MISO   : out t_ll_miso;
      TX_MOSI   : out t_ll_mosi64;
      TX_MISO   : in  t_ll_miso);
end ll_32_to_64;

architecture rtl of ll_32_to_64 is
   
   signal sreset  : std_logic;
   signal rx_sof_buf_i : std_logic;
	
	component sync_reset
	port(
		ARESET : in STD_LOGIC;
		SRESET : out STD_LOGIC;
		CLK : in STD_LOGIC);
	end component;
   
begin
   
   the_sync_RESET : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);    
   
   TX_MOSI.SUPPORT_BUSY <= '1';
   
   -- MISO signal mapping
   RX_MISO.AFULL <= TX_MISO.AFULL or sreset;
   RX_MISO.BUSY <= TX_MISO.BUSY or sreset;     
   
   --TX_MOSI.DVAL <= tx_dval and not sreset;
   
   -- LocalLink data path 32bit to 64bit mapping
   Data_32_to_64_Map : process(CLK)
      variable path        : std_logic := '0'; 
      variable path_valid  : std_logic := '0';
   begin
      if (CLK'event and CLK = '1') then   
         if sreset = '1' then 
            TX_MOSI.DVAL <= '0';
            path    := '0';
            path_valid :='0';            
         else 
            if TX_MISO.BUSY = '0'  then 
               if RX_MOSI.DVAL = '1' then  -- synchronize lane choice with SOF
                  if RX_MOSI.SOF = '1' then
                     path := '0';
                     path_valid := '1';
                  else   -- only switch paths on valid data
                     path := not path;
                  end if;
                  
                  if path_valid = '1' then   -- path_valid mis à '1' par SOF et  reste à '1' tant qu'on n'a pas un EOF , une fois le EOF obtenu, on met Path_valid à '0'
                     if path = '0' then  -- first half of 32 bit data path
                        TX_MOSI.DATA(63 downto 32) <= RX_MOSI.DATA;
                        TX_MOSI.DVAL <= '0';
                        rx_sof_buf_i  <= RX_MOSI.SOF;
                        if RX_MOSI.EOF = '1' then      -- cas où EOF arrive sur un pixel impair 
                           TX_MOSI.EOF  <= '1';                             
                           TX_MOSI.DVAL <= '1'; -- PDU: À ne pas oublier!                                                    
                           path_valid :='0';
                           
                           if RX_MOSI.DREM = "11" then
                              TX_MOSI.DREM <= "011"; -- Only bits 63:32 are valid    
                              -- translate_off                       
                              TX_MOSI.DATA(31 downto 0) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           elsif RX_MOSI.DREM = "01" then
                              TX_MOSI.DREM <= "001"; -- Only bits 63:48 are valid                                  
                              -- translate_off
                              TX_MOSI.DATA(47 downto 0) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           end if;
                           
                        end if;
                     else  -- second half of 32 bit data path 
                        TX_MOSI.DATA(31 downto 0) <= RX_MOSI.DATA;
                        TX_MOSI.DVAL <= '1';
                        TX_MOSI.DREM <= "111";
                        TX_MOSI.SOF  <= rx_sof_buf_i;
                        TX_MOSI.EOF  <= RX_MOSI.EOF;
                        if RX_MOSI.EOF = '1' then 
                           path_valid :='0';
                           
                           if RX_MOSI.DREM = "01" then
                              TX_MOSI.DREM <= "101"; -- Only bits 63:16 are valid                                  
                              -- translate_off
                              TX_MOSI.DATA(15 downto 0) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           end if;                           
                           
                        end if;                           
                     end if;
                  else   -- si path_valid = '0'  
                     TX_MOSI.DVAL <= '0';   
                     TX_MOSI.EOF  <= '0';
                     TX_MOSI.SOF  <= '0';
                  end if;
               else 
                  TX_MOSI.DVAL <= '0';
                  TX_MOSI.EOF  <= '0';
                  TX_MOSI.SOF  <= '0';
               end if;
            end if;
         end if;         
      end if;
   end process Data_32_to_64_Map;
   
   -- tell downstream modules that we support busy
   TX_MOSI.SUPPORT_BUSY <= '1';
   
   -- make sure upstream modules support LocalLink Busy signal
   -- pragma translate_off
   assert_proc : process(CLK)
   begin       
      if rising_edge(CLK) then
         if sreset = '0' then
            assert (RX_MOSI.SUPPORT_BUSY = '1') report "ll_32_to_64 RX Upstream module must support the BUSY signal" severity WARNING;
         end if;
      end if;
   end process;
   -- pragma translate_on
   
end rtl;
