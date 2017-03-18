------------------------------------------------------------------
--!   @file : afpa_int_signal_gen
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
use IEEE.numeric_std.all;
use work.fpa_define.all;
--use work.tel2000.all;

entity afpa_int_signal_gen is
   port(
      ARESET            : in std_logic;
      MCLK_SOURCE       : in std_logic; -- doit valoir au moins 2 x FPA_MCLK_RATE
      
      FPA_INTF_CFG      : in fpa_intf_cfg_type;
      
      
      FPA_MCLK          : in std_logic;  --c'est un clk enable
      
      ACQ_TRIG          : in std_logic;
      XTRA_TRIG         : in std_logic;
      PROG_TRIG         : in std_logic; -- xtra_trig suite à une programmation du detecteur
      
      FRAME_ID          : out std_logic_vector(31 downto 0);
      INT_INDX          : out std_logic_vector(7 downto 0);
      INT_TIME          : out std_logic_vector(31 downto 0);    -- c'est le temps d'integration latché pour l'image dont l'id est FRAME_ID. C'est lui qui doit aller dans le header. Ne jamais se fier au temps d'intégration dans FPA_INTF_CFG  
      
      ACQ_INT           : out std_logic;
      FPA_INT           : out std_logic;
      
      PERMIT_INT_CHANGE : out std_logic
      );
end afpa_int_signal_gen;


architecture rtl of afpa_int_signal_gen is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component;
   
   component double_sync is
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D     : in std_logic;
         Q     : out std_logic := '0';
         RESET : in std_logic;
         CLK   : in std_logic
         );
   end component;
   
   type int_gen_fsm_type is (idle, post_prog_param_st, xtra_trig_param_st, acq_trig_param_st, check_int_cnt_st, int_gen_st, check_end_st, end_st);
   
   signal int_gen_fsm               : int_gen_fsm_type;
   signal frame_id_i                : unsigned(31 downto 0);
   signal int_time_i                : unsigned(31 downto 0);
   signal acq_int_i                 : std_logic;
   signal fpa_int_i                 : std_logic;
   signal sreset                    : std_logic;
   signal int_cnt                   : unsigned(31 downto 0);
   signal acq_frame                 : std_logic;
   signal int_indx_i                : std_logic_vector(7 downto 0);
   signal fpa_mclk_last             : std_logic;
   signal fpa_mclk_rising_edge      : std_logic;
   signal permit_int_change_i       : std_logic;
   signal acq_trig_i                : std_logic;
   signal xtra_trig_i               : std_logic;
   signal prog_trig_i               : std_logic;
   
begin
   
   
   -------------------------------------------------
   -- mappings                                                   
   -------------------------------------------------
   INT_INDX <= int_indx_i;                    -- synchronsié avec ACQ_INT et FPA_INT
   FRAME_ID <= std_logic_vector(frame_id_i);  -- synchronsié avec ACQ_INT
   INT_TIME <= std_logic_vector(int_time_i);
   
   ACQ_INT <= acq_int_i;                      -- acq_int_i n'existe pas en extraTrig. De plus il signale à coup sûre une integration. Ainsi toute donnée de detecteur ne faisant pas suite à acq_trig, provient de extra_trig
   FPA_INT <= fpa_int_i;                      -- fpa_int_i existe pour toute integration (que l'image soit à envoyer dans la chaine ou non)
   PERMIT_INT_CHANGE <= permit_int_change_i;
   
   --------------------------------------------------
   -- synchro 
   --------------------------------------------------   
   U1A : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => MCLK_SOURCE,
      SRESET => sreset
      );
   
   U1B : double_sync
   port map(
      CLK => MCLK_SOURCE,
      D   => ACQ_TRIG,
      Q   => acq_trig_i,
      RESET => sreset
      );
   
   U1C : double_sync
   port map(
      CLK => MCLK_SOURCE,
      D   => XTRA_TRIG,
      Q   => xtra_trig_i,
      RESET => sreset
      );
   
   U1D : double_sync
   port map(
      CLK => MCLK_SOURCE,
      D   => PROG_TRIG,
      Q   => prog_trig_i,
      RESET => sreset
      );
   
   --------------------------------------------------
   --  generation de acq_int_i et fpa_int_i
   --------------------------------------------------
   -- acq_int_i
   -- acq_int_i est destiné à signifier aux modules externes (TimeStamper, SFW etc...) le véritable instant de l'intégration
   U6 : process(MCLK_SOURCE)
   begin
      if rising_edge(MCLK_SOURCE) then 
         if sreset = '1' then 
            int_gen_fsm <= idle;
            acq_int_i <= '0'; 
            frame_id_i <= (others => '0');
            acq_frame <= '0';
            permit_int_change_i <= '0';  
            
         else
            
            fpa_mclk_last <= FPA_MCLK;
            fpa_mclk_rising_edge <= not fpa_mclk_last and FPA_MCLK;
            
            -- fsm de generation de acq_int_i           
            case  int_gen_fsm is 
               
               when idle =>
                  acq_int_i <= '0';
                  int_cnt <= (others => '0');                 
                  acq_frame <= '0';
                  fpa_int_i <= '0';
                  permit_int_change_i <= not acq_trig_i and not xtra_trig_i and not prog_trig_i;
                  if acq_trig_i = '1' then        -- acq_trig_i uniquement car ne jamais envoyer acq_int_i en mode xtra_trig_i
                     acq_frame <= '1';
                     int_gen_fsm <= acq_trig_param_st;
                  end if;
                  if xtra_trig_i = '1' then    --                      
                     acq_frame <= '0';
                     int_gen_fsm <= xtra_trig_param_st;
                  end if;
                  if prog_trig_i = '1' then    --                      
                     acq_frame <= '0';
                     int_gen_fsm <= post_prog_param_st;
                  end if;
               
               when xtra_trig_param_st =>
                  int_cnt <= to_unsigned(DEFINE_FPA_XTRA_TRIG_INT_TIME, int_cnt'length); 
                  int_gen_fsm <= check_int_cnt_st;
               
               when post_prog_param_st =>
                  int_cnt <= to_unsigned(DEFINE_FPA_PROG_INT_TIME, int_cnt'length); 
                  int_gen_fsm <= check_int_cnt_st;
               
               when acq_trig_param_st =>          -- pour ameliorer timings et aussi pour sortir les données avant le signal de validation qu'est acq_int.
                  frame_id_i <= frame_id_i + 1;   -- on ne change pas d'ID en xtraTrig pour que le client ne voit aucune discontinuité dans les ID
                  int_indx_i <= FPA_INTF_CFG.INT_INDX;
                  int_time_i <= FPA_INTF_CFG.INT_TIME;                  
                  int_cnt <= FPA_INTF_CFG.INT_SIGNAL_HIGH_TIME;
                  int_gen_fsm <= check_int_cnt_st;
               
               when check_int_cnt_st =>
                  if int_cnt = 0 then 
                     int_cnt <= to_unsigned(1, int_cnt'length);
                  end if;
                  int_gen_fsm <= int_gen_st;                             
               
               when int_gen_st =>           
                  if fpa_mclk_rising_edge = '1' then                   
                     int_cnt <= int_cnt - 1;     -- un countdown est toujours plus fiable
                     fpa_int_i <= '1'; 
                     acq_int_i <= acq_frame;   -- le module digio_intf decidera s'il faille l'envoyer au detecteur ou pas.           
                     int_gen_fsm <= check_end_st;
                  end if;
               
               when check_end_st =>           -- l'introduction de cet état ameliorera les timings mais suppose que MCLK_SOURCE doit valoir au moins 2 x FPA_MCLK_RATE
                  if int_cnt = 0 then    -- INT_HIGH_TIME est la durée pendant laquelle lever le signal d'integration pour avoir le temps d'integration souhaiteé. Il depnd des offsets de temps d'integration
                     int_gen_fsm <= end_st;
                  else
                     int_gen_fsm <= int_gen_st;
                  end if;
               
               when end_st =>
                  if fpa_mclk_rising_edge = '1' then
                     fpa_int_i <= '0';
                     acq_int_i <= '0';
                     int_gen_fsm <= idle;
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process; 
   
   
end rtl;
