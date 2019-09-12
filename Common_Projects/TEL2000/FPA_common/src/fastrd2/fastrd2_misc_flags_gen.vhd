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
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.fastrd2_define.all; 

entity fastrd2_misc_flags_gen is
   generic(
      G_FIFO_FULL_THRESHOLD   : integer := 448
      );   
   port (
      ARESET            : in std_logic;
      CLK               : in std_logic; 
      
      AREA_INFO_I       : in area_info_type;      
      AREA_INFO_O       : out area_info_type;
      
      AFULL_I           : in std_logic;
      AFULL_O           : out std_logic
      );  
end fastrd2_misc_flags_gen;


architecture rtl of fastrd2_misc_flags_gen is   
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component fwft_sfifo_w72_d16
      port (
         clk       : in std_logic;
         srst       : in std_logic;
         din       : in std_logic_vector(71 downto 0);
         wr_en     : in std_logic;
         rd_en     : in std_logic;
         dout      : out std_logic_vector(71 downto 0);
         valid     : out std_logic;
         full      : out std_logic;
         overflow  : out std_logic;
         empty     : out std_logic
         );
   end component; 
   
   type writer_fsm_type is (idle, wait_end_st, last_wr_st); 
   
   signal sreset               : std_logic;
   signal area_info_s          : area_info_type;
   signal writer_fsm           : writer_fsm_type;
   signal fifo1_rd             : std_logic;
   signal fifo2_rd             : std_logic;
   signal fifo1_wr             : std_logic;
   signal fifo2_wr             : std_logic;
   signal fifo1_dval           : std_logic;
   signal fifo2_dval           : std_logic;
   signal area_info1           : area_info_type;
   signal area_info2           : area_info_type;
   signal fifo_din             : std_logic_vector(71 downto 0);
   signal fifo1_dout           : std_logic_vector(71 downto 0);
   signal fifo2_dout           : std_logic_vector(71 downto 0);
   signal fifo1_dcnt           : std_logic_vector(9 downto 0);
   signal last_write_i         : std_logic;
   signal fifo2_enabled_i      : std_logic;
   
begin
   
   --------------------------------------------------
   -- outputs map
   --------------------------------------------------                       
   AREA_INFO_O <= area_info_s;
   AFULL_O <= AFULL_I;
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1: sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      ); 
   
   ----------------------------------------------------
   -- les fifos
   ----------------------------------------------------   
   U2A : fwft_sfifo_w72_d16
   port map(
      clk         => CLK,
      srst        => sreset,
      din         => fifo_din,
      wr_en       => fifo1_wr,   
      dout        => fifo1_dout,
      rd_en       => fifo2_dval,
      valid       => fifo1_dval,     
      empty       => open,
      full        => open,
      overflow    => open  
      );
   area_info1 <= vector_to_area_info_func(fifo1_dout);
   
   U2B : fwft_sfifo_w72_d16
   port map(
      clk         => CLK,
      srst        => sreset,
      din         => fifo_din,
      wr_en       => fifo2_wr,   
      dout        => fifo2_dout,
      rd_en       => fifo2_dval,
      valid       => fifo2_dval,      
      empty       => open,
      full        => open,
      overflow    => open  
      );
   area_info2 <= vector_to_area_info_func(fifo2_dout);
   
   --------------------------------------------------
   --  lecture des fifos
   --------------------------------------------------   
   fifo1_rd <= fifo1_dval and fifo2_dval;  -- ne pas oublier qu'une lecture de deux fwft en mode synchro doit se faire en combinatoire 
   fifo2_rd <= fifo1_dval and fifo2_dval; 
   
   --------------------------------------------------
   --  ecriture dans les fifos
   --------------------------------------------------
   -- on debalance le fifo 2 au depart, pour avoir le futur du fifo1
   U3: process(CLK)
   begin
      if rising_edge(CLK) then
         if sreset ='1' then 
            writer_fsm <= idle;
            fifo2_enabled_i <= '0';
            fifo1_wr <= '0';
            fifo2_wr <= '0';
            last_write_i <= '0';
            
         else           
            
            fifo1_wr <= AREA_INFO_I.INFO_DVAL;                     -- on ecrit tout dans le fifo 1
            fifo2_wr <= (AREA_INFO_I.INFO_DVAL and fifo2_enabled_i) or last_write_i;           
            fifo_din <= std_logic_vector(resize(unsigned(area_info_to_vector_func(AREA_INFO_I)), fifo_din'length));
            
            case writer_fsm is 
               
               when idle =>
                  fifo2_enabled_i <= '0';
                  last_write_i <= '0';
                  if AREA_INFO_I.INFO_DVAL = '1' then
                     fifo2_enabled_i <= '1';                       -- on debalance le fifo 2 pour avoir le futur du fifo1
                     writer_fsm <= wait_end_st;  
                  end if;
               
               when wait_end_st =>                                 -- on attend la fin de la trame
                  if AREA_INFO_I.INFO_DVAL = '1' and AREA_INFO_I.RAW.RD_END = '1' then
                     writer_fsm <= last_wr_st;  
                  end if;
               
               when last_wr_st =>                                   -- on rebalance les fifos pour que rd_end sorte
                  if AREA_INFO_I.INFO_DVAL = '0' then
                     last_write_i <= '1';
                     writer_fsm <= idle; 
                  end if;
               
               when others =>
               
            end case;
            
         end if;
      end if;
   end process; 
   
   --------------------------------------------------
   --  generation des misc flags 
   --------------------------------------------------
   U4: process(CLK)
   begin
      if rising_edge(CLK) then
         
         area_info_s <= vector_to_area_info_func(fifo1_dout);
         area_info_s.info_dval <= fifo1_dval and fifo2_dval;
         
         -- les miscellaneous flags 
         area_info_s.raw.imminent_aoi <= area_info2.user.sol and not area_info1.user.sol; 
         if area_info1.clk_id /= area_info2.clk_id then 
            area_info_s.raw.imminent_clk_change <= '1';
         else
            area_info_s.raw.imminent_clk_change <= '0';
         end if;
         
      end if;
   end process; 
   
end rtl;
