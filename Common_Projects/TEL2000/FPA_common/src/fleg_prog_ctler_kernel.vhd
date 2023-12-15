------------------------------------------------------------------
--!   @file : fleg_prog_ctler_kernel
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
use IEEE.numeric_std.all;
use work.fpa_common_pkg.all; 
use work.FPA_Define.all;
use work.proxy_define.all;
use work.fleg_brd_define.all; 

entity fleg_prog_ctler_kernel is
   port(
      
      CLK            : in std_logic;
      ARESET         : in std_logic;
      
      USER_CFG       : in fpa_intf_cfg_type;
      
      RQST           : out std_logic;
      EN             : in std_logic;
      DONE           : out std_logic;     
      
      DAC_ID         : out std_logic_vector(3 downto 0);
      DAC_CMD        : out std_logic_vector(3 downto 0);
      DAC_DATA       : out std_logic_vector(13 downto 0);
      DAC_EN         : out std_logic;
      DAC_DONE       : in std_logic
      
      );
end fleg_prog_ctler_kernel;

architecture rtl of fleg_prog_ctler_kernel is
   
   constant DAC_NUM : integer := 8;
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component;  
   
   type new_data_pending_fsm_type  is (idle, check_done_st, init_cfg_mode_st, launch_cfg_mode_st, wait_cfg_mode_end_st, count_limit_st, check_new_data_st, launch_prog_st, check_limit_st1, check_limit_st2, count_inc_st, new_data_pending_st, rqst_st, check_cfg_gen_st, wait_prog_end_st, update_dac_data_latch_reg_st);
   type dac_cfg_fsm_type is (cfg_idle_st, data_idle_st, cfg_mode_st1, cfg_mode_st2, cfg_mode_st3, cfg_mode_end_st, idle, prog_dac_st, wait_prog_end_st);
   
   signal new_data_pending_fsm : new_data_pending_fsm_type;
   signal dac_cfg_fsm          : dac_cfg_fsm_type;
   signal dac_new_data         : fleg_vdac_value_type;
   signal sreset               : std_logic;
   signal dac_new_data_pending : std_logic;
   signal done_i               : std_logic;
   signal dac_actual_cfg       : fleg_vdac_value_type;
   signal rqst_i               : std_logic;
   signal dac_cfg_done         : std_logic;
   signal dac_cnt              : integer range 0 to (DAC_NUM + 1) := 0;
   signal dac_new_data_reg     : std_logic_vector(dac_new_data(1)'length-1 downto 0);
   signal dac_id_reg           : integer range 1 to DAC_NUM;
   signal dac_en_i             : std_logic;
   signal dac_done_i           : std_logic;
   signal dac_cmd_i            : std_logic_vector(DAC_CMD'length-1 downto 0);
   signal dac_data_i           : std_logic_vector(dac_new_data_reg'length-1 downto 0);
   signal dac_id_i             : std_logic_vector(DAC_ID'length-1 downto 0);
   signal dac_done_last        : std_logic;
   
   
begin
   
   
   RQST <= rqst_i;
   DONE <= done_i;
   
   DAC_EN <= dac_en_i;
   DAC_CMD <= dac_cmd_i;
   DAC_DATA <= dac_data_i;
   DAC_ID <= dac_id_i;
   
   --------------------------------------------------
   -- inputs mapping 
   -------------------------------------------------- 
   U0 : for ii in 1 to 8 generate 
      dac_new_data(ii) <=  USER_CFG.VDAC_VALUE(ii); 
   end generate;
   
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
   -- Detection d'un DAC à programmer
   --------------------------------------------------   
   U2 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            dac_new_data_pending <= '0';
            new_data_pending_fsm <= check_done_st;
            done_i <= '0';
            rqst_i <= '0';
            for ii in 1 to DAC_NUM loop
               dac_actual_cfg(ii) <= DEFINE_DAC_VALUE_DEFAULT; -- dans fleg_define
            end loop;
            dac_cnt <= 0;
            
         else    
            
            -- la machine a états comporte plusieurs états afin d'ameliorer les timings	
            case new_data_pending_fsm is            
               
               when check_done_st => 
                  if dac_cfg_done = '1' then
                     new_data_pending_fsm <= init_cfg_mode_st;
                  end if;
               
               when init_cfg_mode_st => 
                  done_i <= '1';
                  rqst_i <= '1';
                  if EN = '1' then 
                     new_data_pending_fsm <= launch_cfg_mode_st;
                  end if;  
               
               when launch_cfg_mode_st =>
                  done_i <= '0';
                  rqst_i <= '0';
                  dac_new_data_pending <= '1';
                  if dac_cfg_done = '0' then
                     new_data_pending_fsm <= wait_cfg_mode_end_st;
                  end if;              
               
               when wait_cfg_mode_end_st =>
                  dac_new_data_pending <= '0';
                  if dac_cfg_done = '1' then
                     new_data_pending_fsm <= idle;
                  end if; 
               
               when idle =>                -- en attente que le programmateur soit à l'écoute avant de rechercher le dac à configurer
                  done_i <= '1';
                  rqst_i <= '0';
                  if dac_cfg_done = '1' then
                     new_data_pending_fsm <= count_inc_st; 
                  end if;
               
               when count_inc_st =>        -- ce compteur permet de balayer lentement les configs des 8 dacs
                  dac_cnt <= dac_cnt + 1;
                  new_data_pending_fsm <= count_limit_st;
               
               when count_limit_st =>      -- Remise  
                  if dac_cnt > DAC_NUM then
                     dac_cnt <= 1;
                  end if;
                  new_data_pending_fsm <= check_new_data_st;
               
               when check_new_data_st =>  
                  if dac_new_data(dac_cnt) /= dac_actual_cfg(dac_cnt) then
                     new_data_pending_fsm <= check_limit_st1;					 
                  else
                     new_data_pending_fsm <= idle;
                  end if;
               
               when check_limit_st1 =>     
                  if dac_new_data(dac_cnt) > DEFINE_DAC_LIMIT(dac_cnt).MAX_WORD then
                     new_data_pending_fsm <= idle;
                  else
                     new_data_pending_fsm <= check_limit_st2;
                  end if;
               
               when check_limit_st2 =>     
                  if dac_new_data(dac_cnt) < DEFINE_DAC_LIMIT(dac_cnt).MIN_WORD then
                     new_data_pending_fsm <= idle;
                  else
                     new_data_pending_fsm <= rqst_st;
                  end if;
               
               when rqst_st =>
                  rqst_i <= '1';
                  if EN = '1' then 
                     new_data_pending_fsm <= check_cfg_gen_st; 
                  end if;
               
               when check_cfg_gen_st =>
                  rqst_i <= '0';
                  done_i <= '0'; 
                  if dac_cfg_done = '1' then
                     new_data_pending_fsm <= launch_prog_st;
                  end if;
               
               when launch_prog_st => 
                  dac_new_data_pending <= '1'; 
                  dac_new_data_reg <= std_logic_vector(dac_new_data(dac_cnt));
                  dac_id_reg <= dac_cnt;             
                  if dac_cfg_done = '0' then
                     new_data_pending_fsm <= wait_prog_end_st;
                  end if;
               
               when wait_prog_end_st =>
                  dac_new_data_pending <= '0';
                  if dac_cfg_done = '1' then
                     new_data_pending_fsm <= update_dac_data_latch_reg_st;
                  end if;  
               
               when update_dac_data_latch_reg_st =>
                  dac_actual_cfg(dac_cnt) <= unsigned(dac_new_data_reg);
                  new_data_pending_fsm <= idle;                  
               
               when others => 
               
            end case;
            
         end if;
      end if;
   end process; 
   
   --------------------------------------------------
   -- generateur de commandes pour les dacs
   --------------------------------------------------
   U3 : process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            dac_en_i <= '0';
            dac_cfg_fsm <= cfg_idle_st;
            dac_cfg_done <= '0';
            dac_done_last <= '0';
            dac_done_i <= '0';
            -- pragma translate_off
            dac_data_i <= (others => '0');
            dac_id_i <= (others => '0');       -- ENO: 19 sept 2020: c'est juste pour eviter des 'X' en simuation car en fait, la config d'initialisation des DACs ne prend pas en consideration le num du DAC. En effet, dans la config d'init, le num est un un "don't care".
            -- pragma translate_on
         else    
            
            dac_done_i <= DAC_DONE;
            dac_done_last <= dac_done_i;
            
            case dac_cfg_fsm is            
               
               when cfg_idle_st =>                -- en attente que le lien spi soit libéré
                  dac_en_i <= '0';
                  dac_cfg_done <= '1';
                  if dac_new_data_pending = '1' then
                     dac_cfg_fsm <= cfg_mode_st1; 
                  end if;                 
               
               when cfg_mode_st1 =>               -- ldac_mode cmd
                  dac_cfg_done <= '0';
                  dac_cmd_i <= ldac_mode;
                  dac_en_i <= dac_done_i;
                  if dac_done_last = '1' and dac_done_i = '0' then
                     dac_cfg_fsm <= cfg_mode_st2;
                  end if;
               
               when cfg_mode_st2 =>               -- int_reference_mode cmd
                  dac_cmd_i <= int_reference_mode;
                  dac_en_i <= dac_done_i;
                  if dac_done_last = '1' and dac_done_i = '0' then
                     dac_cfg_fsm <= cfg_mode_st3;
                  end if;
               
               when cfg_mode_st3 =>               -- normal_op_mode cmd
                  dac_cmd_i <= normal_op_mode;
                  dac_en_i <= dac_done_i;
                  if dac_done_last = '1' and dac_done_i = '0' then
                     dac_cfg_fsm <= cfg_mode_end_st;
                  end if;
               
               when cfg_mode_end_st =>            -- ce mode permet de s'assurer que le dernier mode est programmé avant d'aller à idle.
                  if dac_done_i = '1' then
                     dac_cfg_fsm <= data_idle_st;
                  end if;
               
               when data_idle_st =>
                  dac_cfg_done <= '1';
                  if dac_new_data_pending = '1' then
                     dac_cfg_fsm <= prog_dac_st;
                  end if;                  
               
               when prog_dac_st =>
                  dac_cfg_done <= '0';
                  dac_cmd_i <= wr_and_update_dacN;
                  dac_data_i <= dac_new_data_reg;
                  dac_id_i <= std_logic_vector(to_unsigned(dac_id_reg, dac_id_i'length));
                  dac_en_i <= '1';
                  if dac_done_i = '0' then
                     dac_cfg_fsm <= wait_prog_end_st;
                  end if;
               
               when wait_prog_end_st =>     
                  dac_en_i <= '0';
                  if dac_done_i = '1' then
                     dac_cfg_fsm <= data_idle_st;
                  end if;     
               
               when others => 
               
            end case;
            
         end if;
      end if;
   end process; 
   
end rtl;
