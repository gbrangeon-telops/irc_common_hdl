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
use work.TEL2000.all;

entity axis_32_to_64 is
   port(
      CLK       : in  std_logic;
      ARESET    : in  std_logic;
      RX_MOSI   : in  t_axi4_stream_mosi32;
      RX_MISO   : out t_axi4_stream_miso;
      TX_MOSI   : out t_axi4_stream_mosi64;
      TX_MISO   : in  t_axi4_stream_miso);
end axis_32_to_64;

architecture rtl of axis_32_to_64 is
   
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
   -- AXIS data path 32bit to 64bit mapping
   Data_32_to_64_Map : process(CLK)
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
                     if path = '0' then  -- first half of 32 bit data path
                        TX_MOSI.TDATA(31 downto 0) <= RX_MOSI.TDATA;
                        TX_MOSI.TUSER(7 downto 0) <= RX_MOSI.TUSER;
                        TX_MOSI.TVALID <= '0';
                        if RX_MOSI.TLAST = '1' then      -- cas où EOF arrive sur un pixel impair 
                           TX_MOSI.TLAST  <= '1';                             
                           TX_MOSI.TVALID <= '1'; -- PDU: À ne pas oublier!                                                    
                           path_valid :='0';
                           
                           if RX_MOSI.TKEEP = x"F" then
                              TX_MOSI.TKEEP <= x"0F"; -- Only bits 63:32 are valid
                              TX_MOSI.TSTRB <= x"0F"; -- Only bits 63:32 are valid                               
                              -- translate_off                       
                              TX_MOSI.TDATA(63 downto 32) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           elsif RX_MOSI.TKEEP = x"3" then
                              TX_MOSI.TKEEP <= x"03"; -- Only bits 63:48 are valid
                              TX_MOSI.TSTRB <= x"03"; -- Only bits 63:32 are valid                              
                              -- translate_off
                              TX_MOSI.TDATA(63 downto 16) <= (others =>'X');  -- This data is invalid.
                              -- translate_on
                           end if;
                           
                        end if;
                     else  -- second half of 32 bit data path 
                        TX_MOSI.TDATA(63 downto 32) <= RX_MOSI.TDATA;
                        TX_MOSI.TUSER(15 downto 8) <= RX_MOSI.TUSER;
                        TX_MOSI.TVALID <= '1';
                        TX_MOSI.TKEEP <= x"FF";
                        TX_MOSI.TSTRB <= x"FF";
                        TX_MOSI.TLAST  <= RX_MOSI.TLAST;
                        if RX_MOSI.TLAST = '1' then 
                           path_valid :='0';
                           
                           if RX_MOSI.TKEEP = x"3" then
                              TX_MOSI.TKEEP <= x"3F"; -- Only bits 63:16 are valid                                  
                              TX_MOSI.TSTRB <= x"3F"; -- Only bits 63:16 are valid 
                              -- translate_off
                              TX_MOSI.TDATA(63 downto 48) <= (others =>'X');  -- This data is invalid.
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
   end process Data_32_to_64_Map;
   

end rtl;
