-------------------------------------------------------------------------------
--
-- Title       : LL_fill_void_64
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
-- $Revision$
-- $Author$
-- $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description : This module "fills void" in the data flow. The output data is
--               garanteed not to have any void, i.e. DREM is always "111".       
--               Warning : SOF and EOF are always '0'.
--                                                                         
-- Usage       : Can be used to feed a module that cannot accept "voids" or
--               "holes" in the dataflow, such as the CameraLink interface.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_fill_void_64 is
   port(
      CLK      : in  std_logic;
      ARESET   : in  std_logic;
      RX_MOSI  : in  t_ll_mosi64;
      RX_MISO  : out t_ll_miso;
      TX_MOSI  : out t_ll_mosi64; 
      TX_MISO  : in  t_ll_miso);
end LL_fill_void_64;

architecture rtl of LL_fill_void_64 is     
   
   type t_pixels is array (natural range <>) of std_logic_vector(15 downto 0);
   
   function to_slv (a: t_pixels) return std_logic_vector is
      variable y : std_logic_vector(63 downto 0);
   begin  
      if a'length = 4 then
         y := a(1) & a(2) & a(3) & a(4);
      end if;
      return y;
   end to_slv;  
   
   function to_pixels (a: std_logic_vector(63 downto 0)) return t_pixels is
      variable y : t_pixels(1 to 4);
   begin           
      y(1) := a(63 downto 48);
      y(2) := a(47 downto 32);
      y(3) := a(31 downto 16);
      y(4) := a(15 downto 0);
      return y;
   end to_pixels;    
   
   -- declaring components explicitly eases synthesis file ordering mess!
   component SYNC_RESET is
      port(
         CLK    : in std_logic;
         ARESET : in std_logic;
         SRESET : out std_logic);
   end component;
   
   signal sreset        : std_logic;
   signal reg_pixels    : t_pixels(1 to 3);   
   
   signal rx_pixels     : t_pixels(1 to 4);
   signal tx_pixels     : t_pixels(1 to 4);
   
   signal pixels_in_reg : integer range 0 to 3;     
   
   signal rx_dval       : std_logic;
   signal rx_busy       : std_logic;
   signal tx_dval       : std_logic;   
   
begin
   -- map outputs
   RX_MISO.AFULL <= TX_MISO.AFULL;
   RX_MISO.BUSY <= rx_busy;
   rx_busy <= TX_MISO.BUSY;
   TX_MOSI.SUPPORT_BUSY <= '1'; 
   rx_pixels <= to_pixels(RX_MOSI.DATA);
   
   TX_MOSI.DREM <= "111"; -- Always complete by design.   
   TX_MOSI.DVAL <= tx_dval;
   TX_MOSI.DATA <= to_slv(tx_pixels);
   
   rx_dval <= RX_MOSI.DVAL and not rx_busy;  
   
   main : process(CLK)
      variable pixels_rx_valid         : integer range 1 to 4; 
      variable pixels_to_use_from_rx   : integer range 0 to 4;  
      variable pixels_to_store_from_rx : integer range 0 to 3;                           
      variable rx_index                : integer range 1 to 5;
      variable tx_index                : integer range 1 to 5;   
      variable send_data_now           : boolean;
   begin
      if rising_edge(CLK) then
         
         if TX_MISO.BUSY = '0' then -- Effectively used as a clock enable
            if rx_dval = '1' then
               -- Default values  
               tx_dval <= '0';  
               TX_MOSI.SOF <= '0';   
               TX_MOSI.EOF <= '0';
               
               -- Determine how many pixels from rx_data can be used
               if RX_MOSI.EOF = '1' then -- Only now do we have a possibility of a non-complete data payload                  
                  case RX_MOSI.DREM is
                     when "001" => pixels_rx_valid := 1;
                     when "011" => pixels_rx_valid := 2;
                     when "101" => pixels_rx_valid := 3;                        
                     when "111" => pixels_rx_valid := 4;
                     when others => assert FALSE report "DREM is invalid!!!" severity FAILURE;
                  end case; 
               else
                  pixels_rx_valid := 4;
               end if;
               
               -- Assign all variables
               if (pixels_rx_valid + pixels_in_reg = 4) then
                  -- Perfect match!       
                  pixels_to_use_from_rx := 4 - pixels_in_reg;  
                  pixels_to_store_from_rx := 0;
                  pixels_in_reg <= 0; 
                  send_data_now := true;
                  
               elsif (pixels_rx_valid + pixels_in_reg > 4) then
                  -- Enough pixels to send output but must also store pixels   
                  pixels_to_use_from_rx := 4 - pixels_in_reg;
                  pixels_to_store_from_rx := pixels_rx_valid - pixels_to_use_from_rx;
                  pixels_in_reg <= pixels_to_store_from_rx;                     
                  send_data_now := true;         
                  
               elsif (pixels_rx_valid + pixels_in_reg < 4) then
                  -- Not enough pixels to send output, just store RX_DATA      
                  pixels_to_use_from_rx := 0;
                  pixels_to_store_from_rx := pixels_rx_valid;
                  pixels_in_reg <= pixels_to_store_from_rx + pixels_in_reg;                      
                  send_data_now := false;
                  
               end if;
               
               -- Reset indexes
               rx_index := 1;
               tx_index := 1;
               
               -- Send all pixels available in reg  
               if send_data_now then                  
                  --tx_pixels(1 to pixels_in_reg) <= reg_pixels(1 to pixels_in_reg);
                  -- The following switch-case could all be replaced by the line above if XST wasn't so 
                  -- dumb and crashed with variable indexes.
                  if pixels_in_reg >=1 then
                     tx_pixels(1) <= reg_pixels(1);
                  end if;                  
                  if pixels_in_reg >=2 then
                     tx_pixels(2) <= reg_pixels(2);
                  end if;    
                  if pixels_in_reg >=3 then
                     tx_pixels(3) <= reg_pixels(3);
                  end if;                  

                  tx_index := tx_index + pixels_in_reg;
               end if;
               
               -- Fill the rest directly with rx_data    
               if send_data_now then
                  tx_dval <= '1';                                
                  --tx_pixels(tx_index to pixels_to_use_from_rx) <= rx_pixels(1 to pixels_to_use_from_rx);
                  -- The following if-then could all be replaced by the single line above if XST wasn't so 
                  -- dumb and crashed with variable indexes.
                  if pixels_to_use_from_rx >= 1 then
                     tx_pixels(tx_index) <= rx_pixels(1);   
                  end if;                   
                  if pixels_to_use_from_rx >= 2 then
                     tx_pixels(tx_index+1) <= rx_pixels(2);   
                  end if;   
                  if pixels_to_use_from_rx >= 3 then
                     tx_pixels(tx_index+2) <= rx_pixels(3);   
                  end if;
                  if pixels_to_use_from_rx >= 4 then
                     tx_pixels(tx_index+3) <= rx_pixels(4);   
                  end if;                                    
                  
                  rx_index := rx_index + pixels_to_use_from_rx;  
               end if;
               
               -- Store the remaning rx_data in reg
               if pixels_to_store_from_rx > 0 then
                  
                  if send_data_now then -- reg_pixel has been emptied                           
                     --reg_pixels(1 to pixels_to_store_from_rx) <= rx_pixels(rx_index to pixels_to_store_from_rx); 
                     if pixels_to_store_from_rx >= 1 then
                        reg_pixels(1) <= rx_pixels(rx_index); 
                     end if;
                     if pixels_to_store_from_rx >= 2 then
                        reg_pixels(2) <= rx_pixels(rx_index+1); 
                     end if;
                     if pixels_to_store_from_rx >= 3 then
                        reg_pixels(3) <= rx_pixels(rx_index+2); 
                     end if;                     
                     
                  else -- make sure not to overwrite existing data in reg_pixel
                     --reg_pixels(pixels_in_reg to pixels_to_store_from_rx) <= rx_pixels(rx_index to pixels_to_store_from_rx);            
                     if pixels_to_store_from_rx >= 1 then
                        reg_pixels(pixels_in_reg+1) <= rx_pixels(rx_index); 
                     end if;
                     if pixels_to_store_from_rx >= 2 then
                        reg_pixels(pixels_in_reg+2) <= rx_pixels(rx_index+1); 
                     end if;
                     if pixels_to_store_from_rx >= 3 then
                        reg_pixels(pixels_in_reg+3) <= rx_pixels(rx_index+2);
                     end if;                     
                  end if;                        
                  
               end if;
               
            else
               tx_dval <= '0';
            end if; -- if rx_dval = '1' then
            
         end if; -- if TX_MISO.BUSY = '0' then
         
         
         if sreset = '1' then
            pixels_in_reg <= 0;    
            tx_dval <= '0';
         end if;           
         
      end if; -- if rising_edge(CLK) then
   end process;
   
   
   -- resync reset
   inst_sync_reset : sync_reset port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);
   
end rtl;
