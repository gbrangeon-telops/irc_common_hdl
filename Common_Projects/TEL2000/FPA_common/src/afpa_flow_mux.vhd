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


entity afpa_flow_mux is
   
   
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;  
      READOUT           : in std_logic;
      DIAG_MODE_EN      : out std_logic;
      
      FPA_QUAD_DATA     : in std_logic_vector(61 downto 0);
      FPA_QUAD_DVAL     : in std_logic; 
      
      DIAG_QUAD_DATA    : in std_logic_vector(61 downto 0);
      DIAG_QUAD_DVAL    : in std_logic;
      
      QUAD_DATA         : out std_logic_vector(61 downto 0);
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
   
   
   type mode_fsm_type is (idle, fpa_st, diag_st);
   
   signal mode_fsm                     : mode_fsm_type;
   signal sreset                       : std_logic;
   signal real_data_mode               : std_logic;
   signal diag_mode_en_i               : std_logic;
   signal readout_i                    : std_logic;
   signal quad_data_reg, quad_data_i   : std_logic_vector(QUAD_DATA'length-1 downto 0);
   signal quad_dval_reg, quad_dval_i   : std_logic;
   
begin
   
   DIAG_MODE_EN <= diag_mode_en_i;
   QUAD_DATA <= quad_data_i;
   QUAD_DVAL <= quad_dval_i;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U0: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );
   
   -------------------------------------------------------------------
   -- gestion des differents modes
   -------------------------------------------------------------------  
   U8: process(CLK)
   begin          
      if rising_edge(CLK) then 
         if sreset = '1' then
            real_data_mode <= '0';
            diag_mode_en_i <= '0';
            mode_fsm <= idle;
         else
            
            readout_i <= READOUT;
            
            case mode_fsm is 
               
               when idle =>                  
                  if  FPA_INTF_CFG.COMN.FPA_DIAG_MODE = '1' then   -- mode diag
                     mode_fsm <= diag_st;
                  else
                     mode_fsm <= fpa_st;
                  end if;        
               
               when diag_st => 
                  if readout_i = '0' then 
                     real_data_mode <= '0';
                     diag_mode_en_i <= '1';
                     mode_fsm <= idle;
                  end if;
               
               when fpa_st => 
                  if readout_i = '0' then 
                     real_data_mode <= '1';
                     diag_mode_en_i <= '0';
                     mode_fsm <= idle;
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
         if real_data_mode = '1' then
            quad_data_reg <= FPA_QUAD_DATA;
         else 
            quad_data_reg <= DIAG_QUAD_DATA;            
         end if;  
         quad_dval_reg <= (DIAG_QUAD_DVAL and diag_mode_en_i) or (FPA_QUAD_DVAL and real_data_mode);       
      end if;       
   end process; 
   
   
   --------------------------------------------------
   -- sortie des données 
   --------------------------------------------------   
   --
   U10: process(CLK)
   begin          
      if rising_edge(CLK) then 
         quad_data_i <= quad_data_reg;
         quad_dval_i <= quad_dval_reg;       
      end if;       
   end process; 
   
end rtl;
