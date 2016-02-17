---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  Author: 
--
--  File: axis_16_to_32.vhd
--
--  Use:  Block for converting a 16 bit axi stream Bus into a 32 bit axi stream Bus
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.TEL2000.all;

entity axis_16_to_32 is
   port(
      CLK       : in  std_logic;
      ARESET    : in  std_logic;
      RX_MOSI   : in  t_axi4_stream_mosi16;
      RX_MISO   : out t_axi4_stream_miso;
      TX_MOSI   : out t_axi4_stream_mosi32;
      TX_MISO   : in  t_axi4_stream_miso);
end axis_16_to_32;

architecture rtl of axis_16_to_32 is
   
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
   
   -- MISO signal mapping
   RX_MISO.TREADY <= TX_MISO.TREADY and not sreset;
   TX_MOSI.TID <= RX_MOSI.TID;
   TX_MOSI.TDEST <= RX_MOSI.TDEST;
   -- AXIS data path 16bit to 32bit mapping
   Data_16_to_32_Map : process(CLK)
      variable path        : std_logic := '0'; 
      variable path_valid  : std_logic := '0';
   begin
      if (CLK'event and CLK = '1') then   
         if sreset = '1' then 
            TX_MOSI.TVALID <= '0';
            path    := '1';
            path_valid :='1';            
         else 
            if TX_MISO.TREADY = '1'  then 
               if RX_MOSI.TVALID = '1' then  -- synchronize lane choice with SOF
                  
                  if path = '1' and path_valid = '0' then -- START OF FRAME
                     path := '0';
                     path_valid := '1';
                  else   -- only switch paths on valid data
                     path := not path;
                  end if;
               
               
                  if path_valid = '1' then   -- path_valid mis à '1' par SOF et  reste à '1' tant qu'on n'a pas un EOF , une fois le EOF obtenu, on met Path_valid à '0'
                     if path = '0' then  -- first half of 16 bit data path
                        TX_MOSI.TDATA(15 downto 0) <= RX_MOSI.TDATA;
                        TX_MOSI.TUSER(3 downto 0) <= RX_MOSI.TUSER;
                        TX_MOSI.TVALID <= '0';
                        if RX_MOSI.TLAST = '1' then      -- cas où EOF arrive sur un pixel impair 
                           TX_MOSI.TLAST  <= '1';                             
                           TX_MOSI.TVALID <= '1'; -- PDU: À ne pas oublier!                                                    
                           path_valid :='0';
                           
                           if RX_MOSI.TKEEP = "11" then
                              TX_MOSI.TKEEP <= "0011"; -- Only bits 31:16 are valid
                              TX_MOSI.TSTRB <= "0011"; -- Only bits 31:16 are valid                               
                              -- translate_off                       
                              TX_MOSI.TDATA(31 downto 16) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           elsif RX_MOSI.TKEEP = "01" then
                              TX_MOSI.TKEEP <= "0001"; -- Only bits 31:24 are valid
                              TX_MOSI.TSTRB <= "0001"; -- Only bits 31:24 are valid                              
                              -- translate_off
                              TX_MOSI.TDATA(31 downto 8) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           end if;
                           
                        end if;
                     else  -- second half of 16 bit data path 
                        TX_MOSI.TDATA(31 downto 16) <= RX_MOSI.TDATA;
                        TX_MOSI.TUSER(7 downto 4) <= RX_MOSI.TUSER;
                        TX_MOSI.TVALID <= '1';
                        TX_MOSI.TKEEP <= "1111";
                        TX_MOSI.TSTRB <= "1111";
                        TX_MOSI.TLAST  <= RX_MOSI.TLAST;
                        if RX_MOSI.TLAST = '1' then 
                           path_valid :='0';
                           
                           if RX_MOSI.TKEEP = "0001" then
                              TX_MOSI.TKEEP <= "0111"; -- Only bits 31:8 are valid                                  
                              TX_MOSI.TSTRB <= "0111"; -- Only bits 31:8 are valid 
                              -- translate_off
                              TX_MOSI.TDATA(31 downto 24) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           end if;                           
                           
                        end if;                           
                     end if;
                  else   -- si path_valid = '0'  
                     TX_MOSI.TVALID <= '0';   
                     TX_MOSI.TLAST  <= '0';
                  end if;
               else 
                  TX_MOSI.TVALID <= '0';
                  TX_MOSI.TLAST  <= '0';
               end if;
            end if;
         end if;         
      end if;
   end process Data_16_to_32_Map;
   

end rtl;
