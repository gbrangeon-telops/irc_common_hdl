------------------------------------------------------------------
--!   @file : mglk_DOUT_DVALiter
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------



library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fpa_define.all;
use work.fpa_common_pkg.all; 

entity fastrd_waste_area_gen is
   port (
      ARESET             : in std_logic;
      CLK                : in std_logic; 
      
      FPA_INTF_CFG       : in fpa_intf_cfg_type;
      
      WINDOW_INFO_I      : in window_info_type;      
      WINDOW_INFO_O      : out window_info_type    
      );  
end fastrd_waste_area_gen;


architecture rtl of fastrd_waste_area_gen is   
   
   type raw_pipe_type is array (0 to 1) of raw_area_type;
   type user_pipe_type is array (0 to 1) of user_area_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal raw_pipe             : raw_pipe_type;
   signal user_pipe            : user_pipe_type;
   signal speedup_lsync        : std_logic := '0';
   signal speedup_sample_row   : std_logic := '0';
   signal speedup_unused_area  : std_logic := '0';
   signal waste_dval           : std_logic := '0';
   signal keep_dval            : std_logic := '0';
   signal data_id_i            : unsigned(1 downto 0) := (others => '0');
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------  
   WINDOW_INFO_O.RAW  <= raw_pipe(1);
   WINDOW_INFO_O.USER  <= user_pipe(1);
   WINDOW_INFO_O.WASTE.DVAL <= waste_dval;
   WINDOW_INFO_O.FAST_CLK_EN <= waste_dval;
   WINDOW_INFO_O.SLOW_CLK_EN <= keep_dval;
   WINDOW_INFO_O.DATA_ID <= std_logic_vector(data_id_i);
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   --------------------------------------------------
   --  generation des identificateurs de trames 
   --------------------------------------------------
   U5: process(CLK)
   begin
      if rising_edge(CLK) then
         if sreset ='1' then 
            -- pragma translate_off
            for ii in 0 to 1 loop
               raw_pipe(ii) <= ('0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0', '0');
               user_pipe(ii) <= ('0', '0', '0', '0', '0', '0', '0', '0', '0');
               speedup_lsync <= '0'; 
               speedup_sample_row <= '0';
               speedup_unused_area <= '0';
               waste_dval <= '0';
               keep_dval <= '0';
            end loop;
            -- pragma translate_on
            
         else
            
            ----------------------------------------------
            -- pipe0 : détection des accélerateurs
            ----------------------------------------------
            -- speed-up lsync
            speedup_lsync <= WINDOW_INFO_I.RAW.LSYNC and FPA_INTF_CFG.SPEEDUP_LSYNC;
            
            -- speed-up sample_row
            if WINDOW_INFO_I.RAW.LINE_CNT = 1 then     -- la premiere ligne est la ligne de test du 0804
               speedup_sample_row <= FPA_INTF_CFG.SPEEDUP_SAMPLE_ROW and WINDOW_INFO_I.RAW.LVAL; 
            else
               speedup_sample_row <= '0';
            end if;
            
            -- speed-up unused area 
            if WINDOW_INFO_I.RAW.ACTIVE_WINDOW = '1' then
               speedup_unused_area <= FPA_INTF_CFG.SPEEDUP_UNUSED_AREA and (WINDOW_INFO_I.RAW.LVAL and (not (WINDOW_INFO_I.USER.LVAL or WINDOW_INFO_I.STRETCH)));
            else
               speedup_unused_area <= '0';
            end if;
            
            --pipe
            raw_pipe(0) <= WINDOW_INFO_I.RAW;
            user_pipe(0) <= WINDOW_INFO_I.USER;
            
            -- data_id
            if WINDOW_INFO_I.RAW.PCLK_SAMPLE = '1' then
               data_id_i <= data_id_i + 1;
            end if;
            
            --------------------------------------------------------
            -- pipe 1 pour generation dval 
            --------------------------------------------------------
            waste_dval <= speedup_lsync or speedup_sample_row or speedup_unused_area;
            keep_dval <= not speedup_lsync and not speedup_sample_row and not speedup_unused_area;
            raw_pipe(1) <= raw_pipe(0);
            user_pipe(1) <= user_pipe(0);
            
         end if;
      end if;
   end process; 
   
end rtl;
