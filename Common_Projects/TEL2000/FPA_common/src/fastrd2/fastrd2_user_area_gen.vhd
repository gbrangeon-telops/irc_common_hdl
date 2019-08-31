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
      
      AREA_INFO_I       : in area_info_type;      
      AREA_INFO_O       : out area_info_type    
      );  
end fastrd2_user_area_gen;


architecture rtl of fastrd2_user_area_gen is   
   
   type area_info_pipe_type is array (0 to 3) of area_info_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal area_info_pipe       : area_info_pipe_type;
   signal active_line_temp     : std_logic;
   signal active_line          : std_logic;
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------                       
   AREA_INFO_O <= area_info_pipe(3); 
   
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
               area_info_pipe(ii).raw <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'));
               area_info_pipe(ii).user <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'));
               area_info_pipe(ii).info_dval <= '0';
            end loop;
            -- pragma translate_on
            
         else           
            
            -------------------------
            -- pipe 0 pour generation identificateurs 
            -------------------------
            area_info_pipe(0) <= AREA_INFO_I;
            if AREA_INFO_I.RAW.LINE_PCLK_CNT = USER_AREA_CFG.SOL_POSL_PCLK then          -- lval
               area_info_pipe(0).user.lval <= '1';
            elsif AREA_INFO_I.RAW.LINE_PCLK_CNT > USER_AREA_CFG.EOL_POSL_PCLK then
               area_info_pipe(0).user.lval <= '0';
            end if;    
            
            if AREA_INFO_I.RAW.LINE_PCLK_CNT = USER_AREA_CFG.SOL_POSL_PCLK then          -- sol
               area_info_pipe(0).user.sol <= '1';                                  
            else
               area_info_pipe(0).user.sol <= '0';
            end if;
            
            if AREA_INFO_I.RAW.LINE_PCLK_CNT = USER_AREA_CFG.EOL_POSL_PCLK then         -- eol
               area_info_pipe(0).user.eol <= '1';
            else
               area_info_pipe(0).user.eol <= '0';
            end if;
            
            -- user_fval            
            if AREA_INFO_I.RAW.LINE_CNT >= USER_AREA_CFG.LINE_START_NUM then
               area_info_pipe(0).user.fval <= AREA_INFO_I.RAW.FVAL;
            else
               area_info_pipe(0).user.fval <= '0';
            end if;
            
            --------------------------------------------------------
            -- pipe 1 pour generation premisse dval et sof
            --------------------------------------------------------      
            area_info_pipe(1) <= area_info_pipe(0);           
            -- sof
            if  area_info_pipe(0).raw.line_cnt = USER_AREA_CFG.LINE_START_NUM then 
               area_info_pipe(1).user.sof <= area_info_pipe(0).user.sol;
            else
               area_info_pipe(1).user.sof <= '0';
            end if;         
            -- premisse dval
            if  area_info_pipe(0).raw.line_cnt >= USER_AREA_CFG.LINE_START_NUM then 
               active_line_temp <= '1';            
            else                       
               active_line_temp <= '0';
            end if;                  
            
            -------------------------------------------------------
            -- pipe 2 pour generation active_line et eof et sync_flag        
            -------------------------------------------------------
            area_info_pipe(2) <= area_info_pipe(1); 
            -- eof
            if  area_info_pipe(1).raw.line_cnt = USER_AREA_CFG.LINE_END_NUM then 
               area_info_pipe(2).user.eof <= area_info_pipe(1).user.eol;
            else
               area_info_pipe(2).user.eof <= '0';
            end if;
            -- active_line
            if area_info_pipe(1).raw.line_cnt <= USER_AREA_CFG.LINE_END_NUM then  
               active_line <= active_line_temp; 
            else
               active_line <= '0';
            end if;
            
            -------------------------------------------------------
            -- pipe 3 pour generation misc signals        
            -------------------------------------------------------
            area_info_pipe(3)              <= area_info_pipe(2);
            area_info_pipe(3).user.sol     <= area_info_pipe(2).user.sol and active_line;    
            area_info_pipe(3).user.eol     <= area_info_pipe(2).user.eol and active_line;
            area_info_pipe(3).user.lval    <= area_info_pipe(2).user.lval and active_line;
            area_info_pipe(3).user.dval    <= area_info_pipe(2).user.lval and active_line;
            area_info_pipe(3).user.fval    <= area_info_pipe(2).user.fval;
            area_info_pipe(3).user.rd_end  <= area_info_pipe(2).user.eof;
            
         end if;
      end if;
   end process; 
   
end rtl;
