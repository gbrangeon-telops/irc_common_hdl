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
--use work.fpa_common_pkg.all; 

entity fastrd_user_area_gen is
   port (
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;
      
      WINDOW_INFO_I     : in window_info_type;      
      WINDOW_INFO_O     : out window_info_type    
      );  
end fastrd_user_area_gen;


architecture rtl of fastrd_user_area_gen is   
   
   type raw_pipe_type is array (0 to 3) of raw_area_type;
   type user_pipe_type is array (0 to 3) of user_area_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal raw_pipe             : raw_pipe_type;
   signal user_pipe            : user_pipe_type;
   signal active_line_temp     : std_logic;
   signal active_line          : std_logic;
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------                       
   WINDOW_INFO_O.RAW <= raw_pipe(3);   -- pour fins de synchro
   WINDOW_INFO_O.USER <= user_pipe(3);
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
            -- pragma translate_off
            for ii in 0 to 3 loop
               raw_pipe(ii) <= ('0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0', '0');
               user_pipe(ii) <= ('0', '0', '0', '0', '0', '0', '0', '0', '0');
            end loop;
            -- pragma translate_on
            
         else
            
            
            -------------------------
            -- pipe 0 pour generation identificateurs 
            -------------------------
            raw_pipe(0) <= WINDOW_INFO_I.RAW;
            if WINDOW_INFO_I.RAW.LINE_PCLK_CNT = FPA_INTF_CFG.USER_AREA.SOL_POSL_PCLK then          -- lval
               user_pipe(0).lval <= '1';
            elsif WINDOW_INFO_I.RAW.LINE_PCLK_CNT = FPA_INTF_CFG.USER_AREA.EOL_POSL_PCLK_P1 then
               user_pipe(0).lval <= '0';
            end if;    
            
            if WINDOW_INFO_I.RAW.LINE_PCLK_CNT = FPA_INTF_CFG.USER_AREA.SOL_POSL_PCLK then          -- sol
               user_pipe(0).sol <= '1';                                  
            else
               user_pipe(0).sol <= '0';
            end if;
            
            if WINDOW_INFO_I.RAW.LINE_PCLK_CNT = FPA_INTF_CFG.USER_AREA.EOL_POSL_PCLK then         -- eol
               user_pipe(0).eol <= '1';
            else
               user_pipe(0).eol <= '0';
            end if;
            
            -- user_fval            
            if WINDOW_INFO_I.RAW.LINE_CNT >= FPA_INTF_CFG.USER_AREA.LINE_START_NUM then
               user_pipe(0).fval <= WINDOW_INFO_I.RAW.FVAL;
            else
               user_pipe(0).fval <= '0';
            end if;
            
            --------------------------------------------------------
            -- pipe 1 pour generation premisse dval et sof
            --------------------------------------------------------      
            raw_pipe(1) <= raw_pipe(0);
            user_pipe(1) <= user_pipe(0);            
            -- sof
            if  raw_pipe(0).line_cnt = FPA_INTF_CFG.USER_AREA.LINE_START_NUM then 
               user_pipe(1).sof <= user_pipe(0).sol;
            else
               user_pipe(1).sof <= '0';
            end if;         
            -- premisse dval
            if  raw_pipe(0).line_cnt >= FPA_INTF_CFG.USER_AREA.LINE_START_NUM then 
               active_line_temp <= '1';            
            else                       
               active_line_temp <= '0';
            end if;                  
            
            -------------------------------------------------------
            -- pipe 2 pour generation active_line et eof et sync_flag        
            -------------------------------------------------------
            raw_pipe(2) <= raw_pipe(1);
            user_pipe(2) <= user_pipe(1);  
            -- eof
            if  raw_pipe(1).line_cnt = FPA_INTF_CFG.USER_AREA.LINE_END_NUM then 
               user_pipe(2).eof <= user_pipe(1).eol;
            else
               user_pipe(2).eof <= '0';
            end if;
            -- active_line
            if raw_pipe(1).line_cnt <= FPA_INTF_CFG.USER_AREA.LINE_END_NUM then  
               active_line <= active_line_temp; 
            else
               active_line <= '0';
            end if;
            -- spare_flag
            user_pipe(2).spare_flag <= '0';
            
            -------------------------------------------------------
            -- pipe 3 pour generation misc signals        
            -------------------------------------------------------
            raw_pipe(3) <= raw_pipe(2);
            user_pipe(3) <= user_pipe(2);
            user_pipe(3).sol <= user_pipe(2).sol and active_line;    
            user_pipe(3).eol <= user_pipe(2).eol and active_line;
            user_pipe(3).lval <= user_pipe(2).lval and active_line;
            user_pipe(3).dval <= user_pipe(2).lval and active_line;
            user_pipe(3).fval <= user_pipe(2).fval;
            
         end if;
      end if;
   end process; 
   
end rtl;
