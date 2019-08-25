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

entity fastrd2_clk_area_gen is
   generic(
      AREA_CLK_ID       : integer range 0 to FPA_MCLK_NUM_MAX-1 := 0
      );   
   port (
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      
      CLK_AREA_CFG      : in area_cfg_type;
      
      AREA_INFO_I       : in area_info_type;      
      AREA_INFO_O       : out area_info_type    
      );  
end fastrd2_clk_area_gen;


architecture rtl of fastrd2_clk_area_gen is   
   
   type area_info_pipe_type is array (0 to 3) of area_info_type;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   signal sreset               : std_logic;
   signal area_info_pipe       : area_info_pipe_type;
   signal clk_stamp_en         : std_logic_vector(3 downto 0);
   
begin
   
   --------------------------------------------------
   -- Outputs map
   --------------------------------------------------                       
   AREA_INFO_O <= area_info_pipe(3);   -- pour fins de synchro
   
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
               area_info_pipe(ii).raw <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0');
               area_info_pipe(ii).user <= ((others => '0'), '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', (others => '0'), (others => '0'), '0');
               clk_stamp_en <= (others => '0');
            end loop;
            -- pragma translate_on
            
         else           
            
            --------------------------------------------------------
            -- pipe 0 : reperage premiere ligne à marquer
            ------------------------------------------------
            area_info_pipe(0) <= AREA_INFO_I;
            if  AREA_INFO_I.RAW.LINE_CNT >= CLK_AREA_CFG.LINE_START_NUM then 
               clk_stamp_en(0) <= '1';            
            else                       
               clk_stamp_en(0) <= '0';
            end if;                  
            
            --------------------------------------------------------
            -- pipe 1 : reperage derniere ligne à marquer (fin)
            --------------------------------------------------------      
            area_info_pipe(1) <= area_info_pipe(0);        
            if  area_info_pipe(0).raw.line_cnt <= CLK_AREA_CFG.LINE_END_NUM then 
               clk_stamp_en(1) <= clk_stamp_en(0);
            else
               clk_stamp_en(1) <= '0';
               clk_stamp_en(0) <= '0';
            end if;         
            
            --------------------------------------------------------
            -- pipe 2 : reperage des colonnes à marquer
            --------------------------------------------------------
            area_info_pipe(2) <= area_info_pipe(1);
            if area_info_pipe(1).raw.line_pclk_cnt = CLK_AREA_CFG.SOL_POSL_PCLK then
               clk_stamp_en(2) <= clk_stamp_en(1);
            elsif area_info_pipe(1).raw.line_pclk_cnt = CLK_AREA_CFG.EOL_POSL_PCLK_P1 then
               clk_stamp_en(2) <= '0';
            end if;  
            
            --------------------------------------------------------
            -- pipe 3 : marquage des zones
            --------------------------------------------------------
            area_info_pipe(3) <= area_info_pipe(2);
            if clk_stamp_en(2) = '1' then
               area_info_pipe(3).clk_id <= to_unsigned(AREA_CLK_ID, area_info_pipe(3).clk_id'length);
            end if; 
            
         end if;
      end if;
   end process; 
   
end rtl;
