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
-- use work.fpa_define.all;
use work.fastrd2_define.all; 

entity fastrd2_user_area_gen is
   port (
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      
      USER_AREA_CFG     : in area_cfg_type;
      
      AREA_INFO_I     : in area_info_type;      
      AREA_INFO_O     : out area_info_type    
      );  
end fastrd2_user_area_gen;


architecture rtl of fastrd2_user_area_gen is   
   
   type area_pipe_type is array (0 to 3) of area_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal raw_pipe             : area_pipe_type;
   signal user_pipe            : area_pipe_type;
   signal active_line_temp     : std_logic;
   signal active_line          : std_logic;
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------                       
   AREA_INFO_O.RAW <= raw_pipe(3);   -- pour fins de synchro
   AREA_INFO_O.USER <= user_pipe(3);
   --AREA_INFO_O.PCLK_SAMPLE <= AREA_INFO_I.PCLK_SAMPLE;  -- pas besoin de pipe
   
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
               raw_pipe(ii) <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0');
               user_pipe(ii) <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0');
            end loop;
            -- pragma translate_on
            
         else           
            
            -------------------------
            -- pipe 0 pour generation identificateurs 
            -------------------------
            raw_pipe(0) <= AREA_INFO_I.RAW;
            if AREA_INFO_I.RAW.LINE_PCLK_CNT = USER_AREA_CFG.SOL_POSL_PCLK then          -- lval
               user_pipe(0).lval <= '1';
            elsif AREA_INFO_I.RAW.LINE_PCLK_CNT = USER_AREA_CFG.EOL_POSL_PCLK_P1 then
               user_pipe(0).lval <= '0';
            end if;    
            
            if AREA_INFO_I.RAW.LINE_PCLK_CNT = USER_AREA_CFG.SOL_POSL_PCLK then          -- sol
               user_pipe(0).sol <= '1';                                  
            else
               user_pipe(0).sol <= '0';
            end if;
            
            if AREA_INFO_I.RAW.LINE_PCLK_CNT = USER_AREA_CFG.EOL_POSL_PCLK then         -- eol
               user_pipe(0).eol <= '1';
            else
               user_pipe(0).eol <= '0';
            end if;
            
            -- user_fval            
            if AREA_INFO_I.RAW.LINE_CNT >= USER_AREA_CFG.LINE_START_NUM then
               user_pipe(0).fval <= AREA_INFO_I.RAW.FVAL;
            else
               user_pipe(0).fval <= '0';
            end if;
            
            --------------------------------------------------------
            -- pipe 1 pour generation premisse dval et sof
            --------------------------------------------------------      
            raw_pipe(1) <= raw_pipe(0);
            user_pipe(1) <= user_pipe(0);            
            -- sof
            if  raw_pipe(0).line_cnt = USER_AREA_CFG.LINE_START_NUM then 
               user_pipe(1).sof <= user_pipe(0).sol;
            else
               user_pipe(1).sof <= '0';
            end if;         
            -- premisse dval
            if  raw_pipe(0).line_cnt >= USER_AREA_CFG.LINE_START_NUM then 
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
            if  raw_pipe(1).line_cnt = USER_AREA_CFG.LINE_END_NUM then 
               user_pipe(2).eof <= user_pipe(1).eol;
            else
               user_pipe(2).eof <= '0';
            end if;
            -- active_line
            if raw_pipe(1).line_cnt <= USER_AREA_CFG.LINE_END_NUM then  
               active_line <= active_line_temp; 
            else
               active_line <= '0';
            end if;
            
            -------------------------------------------------------
            -- pipe 3 pour generation misc signals        
            -------------------------------------------------------
            raw_pipe(3)          <= raw_pipe(2);
            user_pipe(3)         <= user_pipe(2);
            user_pipe(3).sol     <= user_pipe(2).sol and active_line;    
            user_pipe(3).eol     <= user_pipe(2).eol and active_line;
            user_pipe(3).lval    <= user_pipe(2).lval and active_line;
            user_pipe(3).dval    <= user_pipe(2).lval and active_line;
            user_pipe(3).fval    <= user_pipe(2).fval;
            user_pipe(3).rd_end  <= user_pipe(2).eof;
            
         end if;
      end if;
   end process; 
   
end rtl;
