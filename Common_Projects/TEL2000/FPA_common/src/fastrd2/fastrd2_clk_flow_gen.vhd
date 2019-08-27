------------------------------------------------------------------
--!   @file : fastrd2_clk_flow_gen
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
use IEEE.std_logic_misc.all;
use work.fastrd2_define.all;

entity fastrd2_clk_flow_gen is
   
   generic(
      G_FIFO_FULL_THRESHOLD : integer := 896
      );      
   
   port(
      
      ARESET               : in std_logic;
      CLK                  : in std_logic;
      
      CLKID_FIFO_RD        : out std_logic;
      CLKID_FIFO_DVAL      : in std_logic;
      CLKID_FIFO_DATA      : in std_logic_vector(3 downto 0);
      
      CTLED_CLK_RD         : out std_logic_vector(7 downto 0);
      CTLED_CLK_DVAL       : in std_logic_vector(7 downto 0);
      CTLED_FPA_CLK        : in fpa_clk_info_type;
      CTLED_CLK_RDY        : in std_logic;      
      
      CLK_FLOW_DVAL        : out std_logic;
      CLK_FLOW_DATA        : out std_logic_vector(2 downto 0);
      CLK_FLOW_DCNT        : in std_logic_vector(10 downto 0);
      ERR                  : out std_logic
      
      );
end fastrd2_clk_flow_gen;



architecture rtl of fastrd2_clk_flow_gen is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK    : in std_logic);
   end component; 
   type ctler_fsm_type is (wait_rdy_st, idle, active_flow_st);
   
   signal sreset              : std_logic;
   signal clkid_fifo_rd_i     : std_logic;
   signal ctled_clk_rd_i      : std_logic_vector(CTLED_CLK_RD'LENGTH-1 downto 0);
   signal clk_flow_dval_i     : std_logic;
   signal clk_flow_data_i     : fpa_clk_base_info_type;   
   signal ctler_fsm           : ctler_fsm_type;
   signal err_i               : std_logic;
   signal clk_flow_afull_i    : std_logic;
   
begin
   --------------------------------------------------
   -- output maps
   --------------------------------------------------  
   CLKID_FIFO_RD <= clkid_fifo_rd_i;
   CTLED_CLK_RD  <= ctled_clk_rd_i;
   CLK_FLOW_DVAL <= clk_flow_dval_i;
   CLK_FLOW_DATA <= clk_flow_data_i.sof & clk_flow_data_i.eof & clk_flow_data_i.clk;
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
   -- Ecriture dans le fifo                               
   -------------------------------------------------- 
   U2: process(CLK) 
      variable clk_id_i : integer range 0 to FPA_MCLK_NUM_MAX - 1;
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            clk_flow_afull_i <= '0'; 
            clk_flow_dval_i <= '0';
            ctler_fsm <= wait_rdy_st;
            err_i <= '0';
            
         else             
            
            --------------------------------------------
            -- quues signaux
            -------------------------------------------
            if unsigned(CLK_FLOW_DCNT) > G_FIFO_FULL_THRESHOLD then
               clk_flow_afull_i <= '1'; 
            else
               clk_flow_afull_i <= '0';  
            end if;
            
            clk_flow_data_i <= CTLED_FPA_CLK.MCLK(clk_id_i);
            clk_flow_dval_i <= clkid_fifo_rd_i; 
            
            --------------------------------------------
            -- fsm d'ecriture dans le fifo
            --------------------------------------------             
            case ctler_fsm is
               
               when wait_rdy_st =>
                  if CTLED_CLK_RDY = '1' then 
                     ctler_fsm <= wait_rdy_st;
                  end if;
               
               when idle =>
                  ctled_clk_rd_i <= (others => '0');
                  clkid_fifo_rd_i <= '0';
                  clk_id_i := to_integer(unsigned(CLKID_FIFO_DATA));
                  if CLKID_FIFO_DVAL = '1' and CTLED_CLK_DVAL(clk_id_i) = '1' and clk_flow_afull_i =  '0' then
                     clkid_fifo_rd_i <= '1';
                     ctled_clk_rd_i(clk_id_i) <= '1';
                     ctler_fsm <= active_flow_st;
                  end if;
               
               when active_flow_st =>
                  clkid_fifo_rd_i <= '0';
                  err_i <= not and_reduce(CTLED_CLK_DVAL);  -- ne devrait jamais arriver
                  if CTLED_FPA_CLK.MCLK(clk_id_i).EOF = '1' then
                     ctler_fsm <= idle; 
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;  
   
end rtl;
