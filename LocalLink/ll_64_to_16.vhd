---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2006
--
--  File: LL_64_to_16.vhd
--  Use: LocalLink Bus Width Compatibility Block
--
--  Revision history:  (use SVN for exact code history)
--    ENO : october 28,2009 -- premier jet, fonctionne en big endian (mot de 16 bits)
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;
--use work.DPB_Define.all;

entity LL_64_to_16 is
   
   port(
      CLK      : in  std_logic;
      ARESET   : in  std_logic;
      RX_MOSI  : in  t_ll_mosi64;
      RX_MISO  : out t_ll_miso;
      TX_MOSI  : out t_ll_mosi;
      --FIFO_EMPTY : out std_logic;
      TX_MISO  : in  t_ll_miso);
end LL_64_to_16;

architecture rtl of LL_64_to_16 is 

   type data_buf_type is array (1 to 4) of t_ll_mosi;
   type serial_sender_type is (send_st_1, send_st_2);
   
   signal serial_sender_sm    : serial_sender_type; 
   signal input_i             : data_buf_type;          -- input buf
   signal input_latch         : data_buf_type; 
   signal output_buf          : t_ll_mosi;              -- output buff
   signal sreset              : std_logic; 
   signal busy_i              : std_logic;
   signal downstream_busy     : std_logic;
   signal serial_sender_busy  : std_logic;
   signal afull_i             : std_logic;
   signal downstream_afull    : std_logic;
   signal counter             : integer range 1 to 4; 
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   
begin
   
  
   --------------------------------------------------
   -- mapping de sortie
   --------------------------------------------------
   -- TX
   TX_MOSI <= output_buf;               -- non utilisé 
   
   --RX
   busy_i <= downstream_busy or serial_sender_busy; 
   afull_i <= downstream_afull;        -- en tenir compte dans la latence du fifo ou ne pas s'en servir carrement.  
   RX_MISO.AFULL <= afull_i;
   RX_MISO.BUSY <= busy_i or ARESET;
   
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   sreset_map : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );    
   
   --------------------------------------------------
   -- mapping d'entree
   --------------------------------------------------
   
   -- RX   
   input_i(1).sof <= RX_MOSI.SOF; 
   input_i(1).eof <= '0'; 
   input_i(1).dval <= RX_MOSI.DVAL; 
   input_i(1).data <= RX_MOSI.DATA(63 downto 48);
   input_i(1).support_busy <= '1'; 
   
   input_i(2).sof <= '0'; 
   input_i(2).eof <= '0'; 
   input_i(2).dval <= RX_MOSI.DVAL; 
   input_i(2).data <= RX_MOSI.DATA(47 downto 32);
   input_i(2).support_busy <= '1';
   
   input_i(3).sof <= '0'; 
   input_i(3).eof <= '0'; 
   input_i(3).dval <= RX_MOSI.DVAL; 
   input_i(3).data <= RX_MOSI.DATA(31 downto 16);
   input_i(3).support_busy <= '1';
   
   input_i(4).sof <= '0'; 
   input_i(4).eof <= RX_MOSI.EOF; 
   input_i(4).dval <= RX_MOSI.DVAL; 
   input_i(4).data <= RX_MOSI.DATA(15 downto 0);
   input_i(4).support_busy <= '1';
   
   --TX
   downstream_busy <= TX_MISO.BUSY; 
   downstream_afull <= TX_MISO.AFULL;   
   
   ------------------------------------------------------------------------
   --process d'envoi seriel des 4 pixels reçus
   ------------------------------------------------------------------------
   img_regen_kernel_proc: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            serial_sender_sm <= send_st_1;
            output_buf.dval <= '0';
            output_buf.support_busy <= '1';
            serial_sender_busy <= '0';
         else 
            
            if downstream_busy = '0' then                     
               case serial_sender_sm is
                  
                  when send_st_1 => -- envoi du premier pixel des 4 et latch des autres 
                     
                     counter <= 1;  -- initialisation du compteur des pixels
                     
                     if input_i(1).dval = '1' and busy_i = '0' then  -- suppose que les 3 autres pixels aussi sont valides
                        output_buf <= input_i(1);
                        input_latch(2) <= input_i(2);
                        input_latch(3) <= input_i(3);
                        input_latch(4) <= input_i(4);
                        serial_sender_busy <= '1';     
                        serial_sender_sm <= send_st_2; --                                              
                     else
                        output_buf.dval <= '0';
                        serial_sender_busy <= '0';
                     end if;
                  
                  when send_st_2 =>  -- envoi des 3 pixels restants         
                     
                     if counter <= 3 then
                        output_buf <= input_latch(counter + 1);
                        counter <= counter + 1;
                     end if;
                     if  counter = 3 then
                        serial_sender_busy <= '0';
                        serial_sender_sm <= send_st_1;
                     end if;               
                  
                  when others =>
                  
               end case;
               
               
            end if;
         end if;
      end if;
   end process;   
   
end rtl;
--