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
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fastrd2_define.all; 

entity fastrd2_imm_flags_tool is
   
   port (
      ARESET              : in std_logic;
      CLK                 : in std_logic; 
      
      SINGLE_AREA_INFO    : in area_info_type;      
      DOUBLE_AREA_INFO    : out double_area_info_type;
      
      ERR                 : out std_logic
      );  
end fastrd2_imm_flags_tool;


architecture rtl of fastrd2_imm_flags_tool is   
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   
   type ctrl_fsm_type is (idle, dval_st, end_st); 
   type area_info_pipe_type is array (0 to 1) of area_info_type;
   
   signal sreset               : std_logic;
   signal ctrl_fsm             : ctrl_fsm_type;
   signal err_i                : std_logic;
   -- signal double_area_info_i   : double_area_info_type;
   signal area_info_pipe       : area_info_pipe_type;
   -- signal info_dval_last       : std_logic;
   signal info_dval_i          : std_logic;
   
begin
   
   --------------------------------------------------
   -- outputs map
   --------------------------------------------------                       
   DOUBLE_AREA_INFO.INFO_DVAL <= info_dval_i;
   DOUBLE_AREA_INFO.PRESENT <= area_info_pipe(1);
   DOUBLE_AREA_INFO.FUTURE <= area_info_pipe(0);
   
   ERR <= err_i;
   
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
   --  fsm de contrôle
   --------------------------------------------------
   -- on genere le futur à partir du présent :)
   
   U3: process(CLK)
   begin
      if rising_edge(CLK) then
         if sreset = '1' then 
            info_dval_i <= '0';
            ctrl_fsm <= idle;
            err_i <= '0';
            
         else
            
            -- pipe
            if SINGLE_AREA_INFO.INFO_DVAL = '1' then         -- chaque nouvelle enrtrée pousse la précédente vers la sortie du pipe. pas de nouvelle entrée, le pipe ne bouge pas. Ainsi, on aura certainement le présent et le futur
               area_info_pipe(0) <= SINGLE_AREA_INFO;
               area_info_pipe(1) <= area_info_pipe(0);
            end if;      
            
            -- fsm de contrôle
            case ctrl_fsm is
               
               when idle =>
                  info_dval_i <= '0';
                  if SINGLE_AREA_INFO.INFO_DVAL = '1' then
                     ctrl_fsm <= dval_st;
                  end if;                  
               
               when dval_st => 
                  info_dval_i <= SINGLE_AREA_INFO.INFO_DVAL;
                  if SINGLE_AREA_INFO.RAW.RD_END = '1' then 
                     ctrl_fsm <= end_st;
                  end if;
               
               when end_st => 
                  area_info_pipe(1) <= area_info_pipe(0);  -- le RD_END est forcément pris dans area_info_pipe(0). On le fait sortirpar tous les moyens
                  info_dval_i <= '1';
                  ctrl_fsm <= idle; 
               
               when others =>
               
            end case;         
            
         end if;
      end if;
   end process; 
   
end rtl;
