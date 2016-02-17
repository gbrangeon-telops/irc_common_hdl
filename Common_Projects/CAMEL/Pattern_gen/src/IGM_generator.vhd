-----------------------------------------------------------------------------------------------------------------------
--
-- IGM_generator                             
--
-- This generator is used to feed "realistic" data to the pattern generator. Each pixel will be exactly the same
-- but the IGMs will be taken from block ram. This is used to generate data for testing the calibration block.
--                                                                                                            
-- Author: Patrick Dubois
-- Date: September 2008
--
-- Telops inc.
--
-----------------------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;   

library Common_HDL;
use Common_HDL.Telops.all;                                               
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL; 

entity IGM_generator is 
   port(            
      --------------------------------
      -- Control
      --------------------------------
      PG_CONFIG      : in  PatgenConfig;      
      --------------------------------
      -- LocalLink Interface
      --------------------------------
      TX_MISO        : in  t_ll_miso;
      TX_MOSI        : out t_ll_mosi32;               
      --------------------------------
      -- Other IOs
      --------------------------------        
      ARESET         : in  std_logic;                    
      CLK            : in  std_logic                     
      );
end IGM_generator;

architecture RTL of IGM_generator is 
   
   signal RESET : std_logic;
   signal not_busy : std_logic;
   
   signal hot_bb_data   : std_logic_vector(15 downto 0);
   signal cold_bb_data  : std_logic_vector(15 downto 0);
   signal scene_data    : std_logic_vector(15 downto 0); 
   signal igm_index     : integer range 0 to DIAGROMLEN-1;  
   
   signal img_cnt       : unsigned(IMGLEN-1 downto 0);
   signal z_cnt         : unsigned(ZLEN-1 downto 0);         
   
   component sync_reset
   port(
      ARESET : in std_logic;
      SRESET : out std_logic;
      CLK : in std_logic);
   end component;       
   
   component hot_bb_igm
   port(
      INDEX : in INTEGER range 0 to DIAGROMLEN-1;
      DATA : out std_logic_vector(15 downto 0);
      CE    : in  std_logic;
      CLK : in std_logic);
   end component;      
   
   component cold_bb_igm
   port(
      INDEX : in INTEGER range 0 to DIAGROMLEN-1;
      DATA : out std_logic_vector(15 downto 0);
      CE    : in  std_logic;
      CLK : in std_logic);
   end component;  
   
   component scene_igm
   port(
      INDEX : in INTEGER range 0 to DIAGROMLEN-1;
      DATA : out std_logic_vector(15 downto 0);
      CE    : in  std_logic;
      CLK : in std_logic);
   end component; 
      
begin
   
   TX_MOSI.SUPPORT_BUSY <= '1';
   TX_MOSI.DREM <= "11";
   TX_MOSI.DATA <= cold_bb_data & cold_bb_data when (PG_CONFIG.DiagMode = PG_BSQ_COLD) else    
   hot_bb_data & hot_bb_data when (PG_CONFIG.DiagMode = PG_BSQ_HOT) else
   scene_data & scene_data;      
   
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);        
   
   not_busy <= not TX_MISO.BUSY;
   
   Hot_rom : hot_bb_igm
   port map(
      INDEX => igm_index,
      DATA => hot_bb_data,
      CE   => not_busy,
      CLK => CLK);   
   
   Cold_rom : cold_bb_igm
   port map(
      INDEX => igm_index,
      DATA => cold_bb_data,
      CE   => not_busy,
      CLK => CLK);
   
   Scene_rom : scene_igm
   port map(
      INDEX => igm_index,
      DATA => scene_data,
      CE   => not_busy,
      CLK => CLK);   
      
      main : process(CLK)
      begin
         if rising_edge(CLK) then
            
            if TX_MISO.BUSY = '0' then
               if TX_MISO.AFULL = '0' then  
                  
                  -- Default values
                  TX_MOSI.DVAL <= '1';   
                  TX_MOSI.SOF <= '0';
                  TX_MOSI.EOF <= '0';
                  
                  if z_cnt = PG_CONFIG.ZSIZE and img_cnt = (PG_CONFIG.IMGSIZE/2) then  
                     -- Cube is finished
                     TX_MOSI.EOF <= '1';
                     img_cnt   <= to_unsigned(2, IMGLEN);  
                     z_cnt     <= to_unsigned(1, ZLEN);  
                     igm_index <= to_integer(unsigned(PG_CONFIG.ROM_INIT_INDEX));
                  else
                     img_cnt <= img_cnt + 2;
                     if img_cnt = (PG_CONFIG.IMGSIZE/2) then 
                        TX_MOSI.EOF <= '1';
                        img_cnt <= to_unsigned(2, IMGLEN); -- Restart at beginning of image next time.
                        z_cnt <= z_cnt + 1; 
                        if Z_cnt(15 downto 0) >= PG_CONFIG.ROM_Z_START and igm_index < DIAGROMLEN-1 then
                           igm_index <= igm_index + 1;
                        end if;                        
                     end if;               
                  end if;
                  
                  -- Manage SOF
                  if img_cnt = 2 then
                     TX_MOSI.SOF <= '1';
                  end if;                                   
                  
               else
                  TX_MOSI.DVAL <= '0';
               end if;
            end if;
            
            if RESET = '1' or PG_CONFIG.Trig = '1' then 
               img_cnt   <= to_unsigned(2, IMGLEN);  
               z_cnt     <= to_unsigned(1, ZLEN);  
               igm_index <= to_integer(unsigned(PG_CONFIG.ROM_INIT_INDEX));
               TX_MOSI.DVAL <= '0';
            end if;
         end if;  
      end process;
   
end RTL;          



