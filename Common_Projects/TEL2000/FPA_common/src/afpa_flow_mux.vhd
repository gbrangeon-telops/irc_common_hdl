-------------------------------------------------------------------------------
--
-- Title       : SCPIO_data_dispatcher
-- Design      : 
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180-IRC\src\FPA\SCPIO_Hercules\src\SCPIO_data_dispatcher.vhd
-- Generated   : Mon Jan 10 13:16:11 2011
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Fpa_Common_Pkg.all;
use work.FPA_Define.all;
use work.proxy_define.all;

entity afpa_flow_mux is
   
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;  
      
      FPA_FVAL          : in std_logic;
      DIAG_FVAL         : in std_logic;
      
      DIAG_MODE_EN      : out std_logic;
      FPA_MODE_EN       : out std_logic;
      
      FPA_QUAD_DATA     : in std_logic_vector(95 downto 0);
      FPA_QUAD_DVAL     : in std_logic; 
      
      DIAG_QUAD_DATA    : in std_logic_vector(95 downto 0);
      DIAG_QUAD_DVAL    : in std_logic;
      
      QUAD_DATA         : out std_logic_vector(95 downto 0);
      QUAD_DVAL         : out std_logic
      
      );
end afpa_flow_mux;

architecture rtl of afpa_flow_mux is
   
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component double_sync is
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D : in STD_LOGIC;
         Q : out STD_LOGIC := '0';
         RESET : in STD_LOGIC;
         CLK : in STD_LOGIC
         );
   end component double_sync;
   
   
   type mode_fsm_type is (init_st1, init_st2, idle, fpa_st, diag_st);
   
   signal mode_fsm                     : mode_fsm_type;
   signal sreset                       : std_logic;
   signal fpa_mode_en_i                : std_logic;
   signal diag_mode_en_i               : std_logic;
   signal quad_data_reg, quad_data_i   : std_logic_vector(QUAD_DATA'length-1 downto 0);
   signal quad_dval_reg, quad_dval_i   : std_logic;
   signal active_output_i              : std_logic;
   signal diag_mode_i                  : std_logic;
   signal data_source_i                : std_logic;
   
   
begin
   
   DIAG_MODE_EN   <= diag_mode_en_i;
   FPA_MODE_EN    <= fpa_mode_en_i;
   QUAD_DATA      <= quad_data_i;
   QUAD_DVAL      <= quad_dval_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U0A: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   U0B: double_sync 
   port map (
      D     => FPA_INTF_CFG.COMN.FPA_DIAG_MODE, 
      Q     => diag_mode_i,  
      RESET => sreset, 
      CLK   => CLK
      );   
   
   U0C: double_sync 
   port map (
      D     => FPA_INTF_CFG.COMN.FPA_INTF_DATA_SOURCE, 
      Q     => data_source_i,  
      RESET => sreset, 
      CLK   => CLK
      );
   
   -------------------------------------------------------------------
   -- gestion des differents modes
   -------------------------------------------------------------------  
   U8: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then
            fpa_mode_en_i <= '0';
            diag_mode_en_i <= '0';   
            mode_fsm <= init_st1;
            active_output_i <= '0';
            
         else
            
            case mode_fsm is 
               
               when init_st1 =>    -- premiere image sacrifiee pour raison de synchro
                  diag_mode_en_i <= diag_mode_i;
                  fpa_mode_en_i  <= not diag_mode_i;
                  if FPA_FVAL = '1' or DIAG_FVAL = '1' then 
                     mode_fsm <= init_st2;
                  end if;
                  -- pragma translate_off 
                  if diag_mode_i = '0' or diag_mode_i = '1' then -- pour eviter 'U'
                     mode_fsm <= init_st2;
                  end if;
                  -- pragma translate_on
               
               when init_st2 =>    -- active_output synchronisee
                  if FPA_FVAL = '0' and DIAG_FVAL = '0' then 
                     mode_fsm <= diag_st;
                     active_output_i <= '1';
                  end if;                   
               
               when diag_st => 
                  if DIAG_FVAL = '0' then 
                     diag_mode_en_i <= '1';
                     if  diag_mode_i = '0' or data_source_i = DATA_SOURCE_OUTSIDE_FPGA then
                        diag_mode_en_i <= '0';
                        mode_fsm <= fpa_st;
                     end if;
                  end if;
               
               when fpa_st => 
                  if FPA_FVAL = '0' then 
                     fpa_mode_en_i <= '1';
                     if  diag_mode_i = '1' and data_source_i = DATA_SOURCE_INSIDE_FPGA then
                        fpa_mode_en_i <= '0';
                        mode_fsm <= diag_st;
                     end if;
                  end if;
               
               when others =>                 
               
            end case;
            
         end if;         
      end if;
   end process;
   
   --------------------------------------------------
   -- repartition des données 
   --------------------------------------------------   
   --
   U9: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if fpa_mode_en_i = '1' then
            quad_data_i <= FPA_QUAD_DATA;
         elsif diag_mode_en_i = '1' then 
            quad_data_i <= DIAG_QUAD_DATA;            
         end if;  
         quad_dval_i <= ((DIAG_QUAD_DVAL and diag_mode_en_i) or (FPA_QUAD_DVAL and fpa_mode_en_i)) and active_output_i;       
      end if;       
   end process; 
   
end rtl;
