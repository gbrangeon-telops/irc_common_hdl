------------------------------------------------------------------
--!   @file : fastrd_stretching_area_gen
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

library work;
use work.fpa_define.all;

entity fastrd_stretching_area_gen is
   port(
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      FPA_INTF_CFG  : in fpa_intf_cfg_type;
      
      WINDOW_INFO_I : in window_info_type;
      WINDOW_INFO_O : out window_info_type
      );
end fastrd_stretching_area_gen;

architecture rtl of fastrd_stretching_area_gen is
   
   type raw_pipe_type is array (0 to 2) of raw_area_type;
   type user_pipe_type is array (0 to 2) of user_area_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal raw_pipe             : raw_pipe_type;
   signal user_pipe            : user_pipe_type;
   signal stretch_pipe         : std_logic_vector(2 downto 0);
   signal unused_line_area     : std_logic;
   signal stretch_cfg_valid    : std_logic;
   
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------                       
   WINDOW_INFO_O.RAW <= raw_pipe(2);   -- pour fins de synchro
   WINDOW_INFO_O.USER <= user_pipe(2);
   WINDOW_INFO_O.STRETCH <= stretch_pipe(2);
   --WINDOW_INFO_O.PCLK_SAMPLE <= WINDOW_INFO_I.PCLK_SAMPLE;  -- pas besoin de pipe
   
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
            for ii in 0 to 2 loop
               raw_pipe(ii) <= ('0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0', '0');
               user_pipe(ii) <= ('0', '0', '0', '0', '0', '0', '0', '0', '0');
               stretch_pipe(ii) <= '0';
            end loop;
            stretch_cfg_valid <= '0';
            
         else              
            
            if FPA_INTF_CFG.STRETCH_AREA.SOL_POSL_PCLK <= FPA_INTF_CFG.STRETCH_AREA.EOL_POSL_PCLK then 
               stretch_cfg_valid <= '1';
            else
               stretch_cfg_valid <= '0';
            end if;
            
            -------------------------------------------------------------------
            -- pipe 0 pour determiner les parties de lignes non utilisées
            ------------------------------------------------------------------
            unused_line_area <= WINDOW_INFO_I.RAW.ACTIVE_WINDOW and WINDOW_INFO_I.RAW.LVAL and not WINDOW_INFO_I.USER.LVAL; -- cela implique automatiquement que le stretching ne peut se faire en pleine fenetre. ce qui est normal.
            raw_pipe(0) <= WINDOW_INFO_I.RAW;
            user_pipe(0) <= WINDOW_INFO_I.USER;
            
            -------------------------------------------------------------------
            -- pipe 1 pour determiner la partie etirée de la ligne (phase 1)
            ------------------------------------------------------------------
            if raw_pipe(0).line_pclk_cnt >= FPA_INTF_CFG.STRETCH_AREA.SOL_POSL_PCLK then 
               stretch_pipe(1) <= unused_line_area;
            else
               stretch_pipe(1) <= '0';
            end if;
            raw_pipe(1) <= raw_pipe(0);
            user_pipe(1) <= user_pipe(0);
            
            -------------------------------------------------------------------
            -- pipe 2 pour determiner la partie etirée de la ligne (phase 2)
            ------------------------------------------------------------------            
            if raw_pipe(1).line_pclk_cnt <= FPA_INTF_CFG.STRETCH_AREA.EOL_POSL_PCLK then 
               stretch_pipe(2) <= stretch_pipe(1);
            else
               stretch_pipe(2) <= '0';
            end if;
            raw_pipe(2) <= raw_pipe(1);
            user_pipe(2) <= user_pipe(1);            
            
         end if;
      end if;
   end process; 
   
end rtl;