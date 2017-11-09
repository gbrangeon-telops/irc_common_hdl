------------------------------------------------------------------
--!   @file : fastrd_wdow_mem_output_ctler
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
use work.fpa_common_pkg.all; 

entity fastrd_wdow_mem_output_ctler is
   port(
      
      ARESET            : in std_logic;
      CLK               : in std_logic;
      
      IN_FIFO_RD_EN     : out std_logic;
      IN_FIFO_DATA      : in std_logic_vector(42 downto 0);
      IN_FIFO_DVAL      : in std_logic;
      IN_FIFO_DCNT      : in std_logic_vector(9 downto 0);
      
      OUT_FIFO_WR_EN    : out std_logic;
      OUT_FIFO_DATA     : out std_logic_vector(42 downto 0);
      OUT_FIFO_DCNT     : in std_logic_vector(9 downto 0);
      OUT_FIFO_RDY      : out std_logic
      
      );  
end fastrd_wdow_mem_output_ctler;


architecture rtl of fastrd_wdow_mem_output_ctler is 
   
   constant FAST_DOUT_WEIGHT_M1 : integer := DEFINE_FPA_FAST_PCLK_RATE_FACTOR - 1;
   constant SLOW_DOUT_WEIGHT_M1 : integer := DEFINE_FPA_PCLK_RATE_FACTOR - 1;
   
   component sync_reset
      port(
         ARESET                 : in std_logic;
         SRESET                 : out std_logic;
         CLK                    : in std_logic);
   end component;
   
   type ctler_fsm_type is (idle, send_st_1, send_st_2);
   --type window_info_pipe_type is array (0 to 1) of window_info_type;
   
   
   signal ctler_fsm             : ctler_fsm_type;
   signal window_info           : window_info_type;
   signal in_fifo_info          : window_info_type;
   --signal window_info_pipe      : window_info_pipe_type;
   
   signal sreset                : std_logic;
   signal fast_dout_weight_sup_1: std_logic := '0';
   signal slow_dout_weight_sup_1: std_logic := '0';
   
   signal dout_weight_M1        : integer range -1 to MAX(FAST_DOUT_WEIGHT_M1, SLOW_DOUT_WEIGHT_M1);
   signal dout_weight_M1_latch  : integer range -1 to MAX(FAST_DOUT_WEIGHT_M1, SLOW_DOUT_WEIGHT_M1);
   signal counter               : integer range 0 to MAX(FAST_DOUT_WEIGHT_M1, SLOW_DOUT_WEIGHT_M1) + 1;
   signal update_input_data     : std_logic;
   signal out_fifo_rdy_i        : std_logic;
   signal window_info_dval      : std_logic;
   signal in_fifo_info_dval     : std_logic;
   signal imminent_clk_change_latch : std_logic;
   signal imminent_sol_latch    : std_logic;
   signal init_data_cnt         : unsigned(4 downto 0);
   signal imminent_lsync_latch  : std_logic;
   
begin
   
   ---------------------------------------------------
   --  output map 
   ---------------------------------------------------
   OUT_FIFO_RDY <= out_fifo_rdy_i;
   
   OUT_FIFO_WR_EN <= window_info_dval;
   
   OUT_FIFO_DATA(42 downto 41)   <= window_info.data_id; 
   OUT_FIFO_DATA(40)             <= window_info.imminent_clk_change;   
   OUT_FIFO_DATA(39)             <= window_info.fast_clk_en;
   OUT_FIFO_DATA(38)             <= window_info.slow_clk_en;   
   -- raw area                   
   OUT_FIFO_DATA(37)             <= window_info.raw.imminent_lsync;  
   OUT_FIFO_DATA(36)             <= window_info.raw.lsync;
   OUT_FIFO_DATA(35)             <= window_info.raw.fval;
   OUT_FIFO_DATA(34)             <= window_info.raw.sof;   
   OUT_FIFO_DATA(33)             <= window_info.raw.eof;   
   OUT_FIFO_DATA(32)             <= window_info.raw.sol;   
   OUT_FIFO_DATA(31)             <= window_info.raw.eol;   
   OUT_FIFO_DATA(30)             <= window_info.raw.lval;  
   OUT_FIFO_DATA(29)             <= window_info.raw.dval;
   OUT_FIFO_DATA(28 downto 19)   <= std_logic_vector(window_info.raw.line_cnt);
   OUT_FIFO_DATA(18 downto 9)    <= std_logic_vector(window_info.raw.line_pclk_cnt); 
   -- user area
   OUT_FIFO_DATA(8)              <= window_info.user.imminent_sol;
   OUT_FIFO_DATA(7)              <= window_info.user.spare_flag;
   OUT_FIFO_DATA(6)              <= window_info.user.fval;
   OUT_FIFO_DATA(5)              <= window_info.user.sof;
   OUT_FIFO_DATA(4)              <= window_info.user.eof;
   OUT_FIFO_DATA(3)              <= window_info.user.sol;
   OUT_FIFO_DATA(2)              <= window_info.user.eol;
   OUT_FIFO_DATA(1)              <= window_info.user.lval;
   OUT_FIFO_DATA(0)              <= window_info.user.dval;
   
   IN_FIFO_RD_EN <= update_input_data;
   
   ---------------------------------------------------
   --  input map 
   ---------------------------------------------------
   in_fifo_info.data_id              <=  IN_FIFO_DATA(42 downto 41);
   in_fifo_info.imminent_clk_change  <=  IN_FIFO_DATA(40); 
   in_fifo_info.fast_clk_en          <=  IN_FIFO_DATA(39);            
   in_fifo_info.slow_clk_en          <=  IN_FIFO_DATA(38); 
   -- raw area                       
   in_fifo_info.raw.imminent_lsync   <=  IN_FIFO_DATA(37);
   in_fifo_info.raw.lsync            <=  IN_FIFO_DATA(36);            
   in_fifo_info.raw.fval             <=  IN_FIFO_DATA(35);            
   in_fifo_info.raw.sof              <=  IN_FIFO_DATA(34);            
   in_fifo_info.raw.eof              <=  IN_FIFO_DATA(33);            
   in_fifo_info.raw.sol              <=  IN_FIFO_DATA(32);            
   in_fifo_info.raw.eol              <=  IN_FIFO_DATA(31);            
   in_fifo_info.raw.lval             <=  IN_FIFO_DATA(30);            
   in_fifo_info.raw.dval             <=  IN_FIFO_DATA(29);            
   in_fifo_info.raw.line_cnt         <=  unsigned(IN_FIFO_DATA(28 downto 19));  
   in_fifo_info.raw.line_pclk_cnt    <=  unsigned(IN_FIFO_DATA(18 downto 9));
   -- user area
   in_fifo_info.user.imminent_sol    <=  IN_FIFO_DATA(8);
   in_fifo_info.user.spare_flag      <=  IN_FIFO_DATA(7);             
   in_fifo_info.user.fval            <=  IN_FIFO_DATA(6);             
   in_fifo_info.user.sof             <=  IN_FIFO_DATA(5);             
   in_fifo_info.user.eof             <=  IN_FIFO_DATA(4);             
   in_fifo_info.user.sol             <=  IN_FIFO_DATA(3);             
   in_fifo_info.user.eol             <=  IN_FIFO_DATA(2);             
   in_fifo_info.user.lval            <=  IN_FIFO_DATA(1);             
   in_fifo_info.user.dval            <=  IN_FIFO_DATA(0); 
   in_fifo_info_dval                 <=  IN_FIFO_DVAL;   
   
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
   -- analyse et sortie des données 
   --------------------------------------------------
   U3: process(CLK) 
      variable incr : unsigned(1 downto 0);
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            ctler_fsm <= idle;
            update_input_data <= '0';
            fast_dout_weight_sup_1 <= '0'; 
            slow_dout_weight_sup_1 <= '0';
            out_fifo_rdy_i <= '0';
            window_info_dval <= '0';
            init_data_cnt <= (others => '0');
            
         else 
            
            -- OUT_FIFO: ENO 19 juin 2017: on s'assure de suffisamment de données dans le fifo avant de decalrer rdy sinon... pb 
            if unsigned(OUT_FIFO_DCNT) > 64 then 
               out_fifo_rdy_i <= '1';
            else
               out_fifo_rdy_i <= '0';
            end if;
            
            ------------------------------------------------
            -- détermination du poids/cardinal des données
            ------------------------------------------------            
            if FAST_DOUT_WEIGHT_M1 > 0  then                       -- ie  FAST_DOUT_WEIGHT > 1
               fast_dout_weight_sup_1 <= in_fifo_info.fast_clk_en;
            end if;
            
            if SLOW_DOUT_WEIGHT_M1 > 0 then                        -- ie  SLOW_DOUT_WEIGHT > 1
               slow_dout_weight_sup_1 <= in_fifo_info.slow_clk_en;
            end if;
            
            --------------------------------------------
            -- pipe 0
            --------------------------------------------             
            case ctler_fsm is
               
               when idle =>      
                  update_input_data <= in_fifo_info_dval; 
                  window_info_dval <= '0';
                  if in_fifo_info_dval = '1' and in_fifo_info.raw.imminent_lsync = '1' and update_input_data = '1' then  -- update_input_data permet de s'assurer que in_fifo_info.raw.imminent_lsync est lue et doncl sivante est bien un LSYNC                     update_input_data <= '0';
                     ctler_fsm <= send_st_1;
                     update_input_data <= '0';
                  end if;
               
               when send_st_1 =>
                  counter <= 1;  -- initialisation du compteur de cardinal
                  window_info <= in_fifo_info;
                  window_info_dval <= in_fifo_info_dval;
                  if in_fifo_info.slow_clk_en = '1' then
                     dout_weight_M1_latch <= SLOW_DOUT_WEIGHT_M1;
                  elsif in_fifo_info.fast_clk_en = '1' then
                     dout_weight_M1_latch <= FAST_DOUT_WEIGHT_M1;
                  else
                     
                  end if;
                  update_input_data <= in_fifo_info_dval;
                  
                  imminent_clk_change_latch <= in_fifo_info.imminent_clk_change;
                  imminent_sol_latch <= in_fifo_info.user.imminent_sol;
                  imminent_lsync_latch <= in_fifo_info.raw.imminent_lsync;
                  
                  window_info.imminent_clk_change <= '0';         
                  window_info.user.imminent_sol <= '0';
                  window_info.raw.imminent_lsync <= '0';
                  
                  if in_fifo_info_dval = '1' and (slow_dout_weight_sup_1 = '1' or fast_dout_weight_sup_1 = '1') then -- pas besoin de dval puisque déja contenu dans slow_dout_weight_sup_1 et fast_dout_weight_sup_1                      
                     ctler_fsm <= send_st_2;                     -- on va dans l'etat ou on va s'occuper du poids de la donnée 
                  end if;
                  
                  if in_fifo_info_dval = '1' and window_info.raw.fval = '1' and in_fifo_info.raw.fval = '0' then 
                     ctler_fsm <= idle;   -- on a écrit un fval = '0' dans le fifo. Le downstream saura l'interprêter                     
                  end if;
               
               when send_st_2 => 
                  update_input_data <= '0';                   
                  counter <= counter + 1;                  
                  if  counter = dout_weight_M1_latch  then
                     window_info.imminent_clk_change <= imminent_clk_change_latch;         
                     window_info.user.imminent_sol   <= imminent_sol_latch;
                     window_info.raw.imminent_lsync  <= imminent_lsync_latch;
                     ctler_fsm <= send_st_1;
                  end if;               
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
   
   
   
end rtl;
