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
use work.fastrd2_define.all; 

entity fastrd2_misc_flags_gen is
   generic(
      AREA_CLK_ID       : integer range 0 to FPA_MCLK_NUM_MAX-1 := 0
      );   
   port (
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      
      AREA_INFO_I       : in area_info_type;      
      AREA_INFO_O       : out area_info_type    
      );  
end fastrd2_misc_flags_gen;


architecture rtl of fastrd2_misc_flags_gen is   
   
   type area_info_pipe_type is array (0 to 2) of area_info_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal area_info_pipe       : area_info_pipe_type;
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------                       
   AREA_INFO_O <= area_info_pipe(1);   
   
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
   --  generation des identificateurs 
   --------------------------------------------------
   U5: process(CLK)
   begin
      if rising_edge(CLK) then
         if sreset ='1' then 
            -- pragma translate_off
            for ii in 0 to 2 loop
               area_info_pipe(ii).raw <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'));
               area_info_pipe(ii).user <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'));
            end loop;
            -- pragma translate_on
            
         else           
            
            --------------------------------------------------------
            -- pipe 0 : 
            ------------------------------------------------
            area_info_pipe(0) <= AREA_INFO_I;                
            
            --------------------------------------------------------
            -- pipe 1 : imminent_clk_change and imminent_aoi
            --------------------------------------------------------      
            area_info_pipe(1) <= area_info_pipe(0);        
            if AREA_INFO_I.CLK_ID /= area_info_pipe(0).clk_id then 
               area_info_pipe(1).raw.imminent_clk_change <= '1';
            else
               area_info_pipe(1).raw.imminent_clk_change <= '0';
            end if;         
            area_info_pipe(1).raw.imminent_aoi <= not area_info_pipe(0).user.sol and AREA_INFO_I.USER.SOL;
                        
            
         end if;
      end if;
   end process; 
   
end rtl;
