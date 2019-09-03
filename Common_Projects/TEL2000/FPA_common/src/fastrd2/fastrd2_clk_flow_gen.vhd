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
use work.fpa_define.all;

entity fastrd2_clk_flow_gen is
   
   generic(
      G_FIFO_FULL_THRESHOLD : integer := 896
      );      
   
   port(
      
      ARESET               : in std_logic;
      CLK                  : in std_logic;
      
      CLKID_FIFO_RD        : out std_logic;
      CLKID_FIFO_DVAL      : in std_logic;
      CLKID_FIFO_DATA      : in std_logic_vector(7 downto 0);
      
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
   type ctled_clk_fsm_type is (wait_rdy_st, pause_st, active_flow_sof, active_flow_eof);
   
   signal sreset              : std_logic;
   signal clkid_fifo_rd_i     : std_logic;
   signal ctled_clk_rd_i      : std_logic_vector(CTLED_CLK_RD'LENGTH-1 downto 0);
   signal clk_flow_dval_i     : std_logic;
   signal clk_flow_data_i     : fpa_clk_base_info_type;   
   signal ctled_clk_fsm       : ctled_clk_fsm_type;
   signal ctlid_fsm           : ctled_clk_fsm_type;
   signal err_i               : std_logic;
   signal clk_flow_afull_i    : std_logic;
   signal clkid               : integer range 0 to DEFINE_FPA_MCLK_NUM-1;
   signal imminent_clkid      : integer range 0 to DEFINE_FPA_MCLK_NUM-1;
   signal clkid_latch         : integer range 0 to DEFINE_FPA_MCLK_NUM-1;
   
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
   -- input maps
   -------------------------------------------------- 
   imminent_clkid <= to_integer(unsigned(CLKID_FIFO_DATA(7 downto 4)));
   clkid <= to_integer(unsigned(CLKID_FIFO_DATA(3 downto 0)));
   
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
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            clk_flow_afull_i <= '0';            
            err_i <= '0';
            
         else             
            
            err_i <= '0';
            
            --------------------------------------------
            -- outputs
            -------------------------------------------
            if unsigned(CLK_FLOW_DCNT) > G_FIFO_FULL_THRESHOLD then
               clk_flow_afull_i <= '1'; 
            else
               clk_flow_afull_i <= '0';  
            end if;
            
         end if;
      end if;
   end process;  
   
   -------------------------------------------------- 
   -- ctled_clk_fsm                               
   -------------------------------------------------- 
   U3: process(CLK)
      variable clk_id_latch_i      : integer range 0 to FPA_MCLK_NUM_MAX-1;
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then
            ctled_clk_rd_i <= (others => '0');
            ctled_clk_fsm <= wait_rdy_st;
            clk_flow_dval_i <= '0';
         
         else             
               
            clk_flow_dval_i <= or_reduce(ctled_clk_rd_i);
                    
            --------------------------------------------
            -- fsm de generation clk_flow
            --------------------------------------------             
            case ctled_clk_fsm is
               
               when wait_rdy_st =>
                  if and_reduce(CTLED_CLK_DVAL(DEFINE_FPA_MCLK_NUM-1 downto 0)) = '1' then 
                     ctled_clk_fsm <= pause_st;
                  end if;
               
               when pause_st => 
                  ctled_clk_rd_i <= (others => '0');
                  if clk_flow_afull_i = '0' and CLKID_FIFO_DVAL = '1' then
                     ctled_clk_fsm <= active_flow_sof; 
                  end if;
               
               when active_flow_sof =>
                  ctled_clk_rd_i <= (others => '0');
                  ctled_clk_rd_i(clkid) <= CLKID_FIFO_DVAL;
                  clk_flow_data_i <= CTLED_FPA_CLK.MCLK(clkid);
                  if CTLED_FPA_CLK.MCLK(clkid).EOF = '1' and CLKID_FIFO_DVAL = '1' then
                     ctled_clk_rd_i <= (others => '0');
                     ctled_clk_rd_i(imminent_clkid) <= '1';
                     if clk_flow_afull_i = '1' then
                       ctled_clk_fsm <= pause_st;
                       ctled_clk_rd_i <= (others => '0');
                     end if;
                  end if;               
               
               when others =>                   
               
            end case;       
            
         end if;
      end if;
   end process;
   
   clkid_fifo_rd_i <= CTLED_FPA_CLK.MCLK(clkid).EOF;
   
end rtl;
