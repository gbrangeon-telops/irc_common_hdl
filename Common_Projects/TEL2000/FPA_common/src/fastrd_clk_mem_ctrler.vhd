------------------------------------------------------------------
--!   @file : fastrd_clk_mem_ctrler
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

entity fastrd_clk_mem_ctrler is
   port( 
      
      ARESET         : in std_logic;
      CLK            : in std_logic;
      
      RAW_FPA_CLK    : in std_logic;
      
      WR_DATA        : out std_logic_vector(2 downto 0);
      WR_DVAL        : out std_logic;
      
      RD_DATA        : in std_logic_vector(2 downto 0);
      RD_DVAL        : in std_logic;
      
      FIFO_RDY       : out std_logic
      );
end fastrd_clk_mem_ctrler;

architecture rtl of fastrd_clk_mem_ctrler is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component; 
   
   type wr_fifo_fsm_type is (pause_st, wr_fifo_st, wait_end_st, wr_end_st, recycling_st);
   
   signal wr_fifo_fsm      : wr_fifo_fsm_type;
   signal sreset           : std_logic;
   signal re_count         : unsigned(3 downto 0) := (others => '0');
   signal re_pipe          : std_logic_vector(1 downto 0);
   signal pipe             : std_logic_vector(2 downto 0);
   signal wr_dval_i        : std_logic;
   signal wr_data_i        : std_logic_vector(2 downto 0); 
   signal sof_i            : std_logic;
   signal eof_i            : std_logic;
   signal fifo_rdy_i       : std_logic;
   signal sof_count        : unsigned(2 downto 0);
   
begin 
   
   WR_DATA  <= wr_data_i;
   WR_DVAL  <= wr_dval_i;
   FIFO_RDY <= fifo_rdy_i;
   
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
   -- generation des edges d'horloge
   --------------------------------------------------
   U2: process(CLK)
   begin
      if rising_edge(CLK) then 
         
         pipe(2 downto 0) <= pipe(1 downto 0) & RAW_FPA_CLK;
         re_pipe(1 downto 0) <= re_pipe(0) & (not pipe(0) and RAW_FPA_CLK);
         
      end if;
   end process;       
   
   
   --------------------------------------------------
   -- remplissage du fifo avec une periode d'horloge
   --------------------------------------------------
   -- sof_i  = rising_edge de l'horloge
   -- eof_i  = fin de l'horloge, soit juste avant le prochain rising_edge
   
   U3: process(CLK)      
      variable incr          : std_logic_vector(1 downto 0) :=  "00";
      
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then            
            wr_fifo_fsm <= pause_st;
            wr_dval_i <= '0';
            fifo_rdy_i <= '0';
            re_count <= (others => '0');
            
         else 
            
            incr := '0' & re_pipe(0);            
            re_count <= re_count + to_integer(unsigned(incr));           
            
            -- définition des identificateurs de trame
            sof_i <=  re_pipe(1); --and re_count(0);
            eof_i <=  re_pipe(0); -- and re_count(0);
            
            -- definition des données dans le fifo
            wr_data_i(2) <= sof_i;  
            wr_data_i(1) <= eof_i;  
            wr_data_i(0) <= pipe(2);
            
            -- fsm pour mémorisation d'une prériode dans un fifo            
            case wr_fifo_fsm is                          
               
               when pause_st =>          -- on laisse passer 7 MCLK, on est ainsi certain d'être dans la zone de stabilité des périodes 
                  sof_count <= (others => '0');
                  if re_count = 7 then 
                     wr_fifo_fsm <= wr_fifo_st;
                  end if;
               
               when wr_fifo_st =>        -- début                  
                  wr_dval_i <= sof_i;                  
                  if sof_i = '1' then 
                     wr_fifo_fsm <= wait_end_st;
                     sof_count <= to_unsigned(1, sof_count'length);
                  end if;
               
               when wait_end_st =>       -- fin de memorisation de deux trames de période
                  if sof_i = '1' then
                     sof_count <= sof_count + 1;
                  end if;
                  if eof_i = '1' and sof_count(2) = '1' then  -- on ecrit au moins 4 periodes
                     wr_fifo_fsm <= wr_end_st;
                  end if;
               
               when wr_end_st =>
                  wr_dval_i <= '0';      -- ENO : 08 juin 2017:  wr_dval_i est mis ici express après simulation (correcte sans pb de timing) pour englober eof et sof. ne plus y toucher                 
                  wr_fifo_fsm <= recycling_st;
               
               when recycling_st =>      -- recyclage de trames de périodes
                  fifo_rdy_i <= '1';     -- permet de s'assurer qu'une période complète est écrite dans le fifo
                  wr_data_i <= RD_DATA;
                  wr_dval_i <= RD_DVAL;                  
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process;
   
end rtl;
