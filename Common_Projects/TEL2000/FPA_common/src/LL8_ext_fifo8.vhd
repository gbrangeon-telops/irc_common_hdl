---------------------------------------------------------------------------------------------------
--                                                      ..`??!````??!..
--                                                  .?!                `1.
--                                               .?`                      i
--                                             .!      ..vY=!``?74.        i
--.........          .......          ...     ?      .Y=` .+wA..   ?,      .....              ...
--"""HMM"""^         MM#"""5         .MM|    :     .H\ .JQgNa,.4o.  j      MM#"MMN,        .MM#"WMF
--   JM#             MMNggg2         .MM|   `      P.;,jMt   `N.r1. ``     MMmJgMM'        .MMMNa,.
--   JM#             MM%````         .MM|   :     .| 1A Wm...JMy!.|.t     .MMF!!`           . `7HMN
--   JMM             MMMMMMM         .MMMMMMM!     W. `U,.?4kZ=  .y^     .!MMt              YMMMMB=
--                                          `.      7&.  ?1+...JY'     J
--                                           ?.        ?""""7`       .?`
--                                             :.                ..?`
--                                               `!...........??`
---------------------------------------------------------------------------------------------------
--
-- Title       : LocalLink_Fifo
-- Design      : VP30
-- Author      : Patrick Daraiche
-- Company     : Telops Inc.
--
--  $Revision: 
--  $Author: 
--  $LastChangedDate:
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;    
use work.fpa_common_pkg.all;

entity LL8_ext_fifo8 is
   generic(
      FifoSize		   : integer := 256;  -- 256
      Latency        : integer := 32;  -- Input module latency (to control RX_LL_MISO.AFULL)      
      ASYNC          : boolean := true);	-- Use asynchronous fifos
   port(
      --------------------------------
      -- FIFO RX Interface
      --------------------------------
      RX_LL_MOSI  : in  t_ll_ext_mosi8;
      RX_LL_MISO  : out t_ll_ext_miso;
      CLK_RX 		: in 	std_logic;
      FULL        : out std_logic;
      WR_ERR      : out std_logic;
      --------------------------------
      -- FIFO TX Interface
      --------------------------------
      TX_LL_MOSI  : out t_ll_ext_mosi8;
      TX_LL_MISO  : in  t_ll_ext_miso;
      CLK_TX 		: in 	std_logic;
      EMPTY       : out std_logic; -- This signal should actually be called "IDLE"
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET		: in std_logic
      );
end LL8_ext_fifo8;

architecture RTL of LL8_ext_fifo8 is 
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component t_axi4_stream16_sfifo_d256
      port(
         s_aclk           : in std_logic;
         s_aresetn        : in std_logic;
         s_axis_tvalid    : in std_logic;
         s_axis_tready    : out std_logic;
         s_axis_tdata     : in std_logic_vector(15 downto 0);
         s_axis_tstrb     : in std_logic_vector(1 downto 0);
         s_axis_tkeep     : in std_logic_vector(1 downto 0);
         s_axis_tlast     : in std_logic;
         s_axis_tid       : in std_logic_vector(0 downto 0);
         s_axis_tdest     : in std_logic_vector(2 downto 0);
         s_axis_tuser     : in std_logic_vector(3 downto 0);
         m_axis_tvalid    : out std_logic;
         m_axis_tready    : in std_logic;
         m_axis_tdata     : out std_logic_vector(15 downto 0);
         m_axis_tstrb     : out std_logic_vector(1 downto 0);
         m_axis_tkeep     : out std_logic_vector(1 downto 0);
         m_axis_tlast     : out std_logic;
         m_axis_tid       : out std_logic_vector(0 downto 0);
         m_axis_tdest     : out std_logic_vector(2 downto 0);
         m_axis_tuser     : out std_logic_vector(3 downto 0);
         axis_data_count  : out std_logic_vector(8 downto 0);
         axis_overflow    : out std_logic);
   end component;
   
   signal areset_n        : std_logic;
   signal s_axis_tvalid   : std_logic;
   signal s_axis_tready   : std_logic;
   signal s_axis_tdata    : std_logic_vector(15 downto 0);
   signal s_axis_tstrb    : std_logic_vector(1 downto 0);
   signal s_axis_tkeep    : std_logic_vector(1 downto 0);
   signal s_axis_tlast    : std_logic;
   signal s_axis_tid      : std_logic_vector(0 downto 0);
   signal s_axis_tdest    : std_logic_vector(2 downto 0);
   signal s_axis_tuser    : std_logic_vector(3 downto 0);
   signal m_axis_tvalid   : std_logic;
   signal m_axis_tready   : std_logic;
   signal m_axis_tdata    : std_logic_vector(15 downto 0);
   signal FoundGenCase    : boolean;
   signal full_i          : std_logic;
   signal empty_i         : std_logic;
   signal wr_err_i        : std_logic;
   signal data_cnt_i      : std_logic_vector(8 downto 0);
   signal sreset_rx       : std_logic;
   signal sreset_tx       : std_logic;
   
begin      
   
   -----------------------------------------------------
   --  signaux generiques
   -----------------------------------------------------   
   areset_n <= not ARESET;
   TX_LL_MOSI.SUPPORT_BUSY <= '1';
   
   U0A: sync_reset
   port map(ARESET => ARESET, CLK => CLK_RX, SRESET => sreset_rx);
   U0B: sync_reset
   port map(ARESET => ARESET, CLK => CLK_TX, SRESET => sreset_tx);
   
   
   -----------------------------------------------------
   --  slave side map                               
   -----------------------------------------------------
   s_axis_tdata(15 downto 10) <= (others => '0');
   s_axis_tdata(9 downto 0)   <= RX_LL_MOSI.SOF & RX_LL_MOSI.EOF & RX_LL_MOSI.DATA;
   s_axis_tvalid              <= RX_LL_MOSI.DVAL;
   s_axis_tstrb               <= (others => '1');
   s_axis_tkeep               <= (others => '1');
   s_axis_tlast               <= RX_LL_MOSI.EOF; 
   s_axis_tid                 <= (others => '0');
   s_axis_tdest               <= (others => '0');
   s_axis_tuser               <= (others => '0');
   RX_LL_MISO.BUSY            <= not s_axis_tready;
   RX_LL_MISO.AFULL           <= '0';
   WR_ERR <= '0';
   FULL <= full_i;
   
   -----------------------------------------------------
   --  master side map                               
   -----------------------------------------------------   
   m_axis_tready              <= not TX_LL_MISO.BUSY; 
   TX_LL_MOSI.SOF             <= m_axis_tdata(9);
   TX_LL_MOSI.EOF             <= m_axis_tdata(8);
   TX_LL_MOSI.DVAL            <= m_axis_tvalid;
   TX_LL_MOSI.DATA            <= m_axis_tdata(7 downto 0);
   EMPTY                      <= empty_i;
   
   ----------------------------------------------------- 
   --  fifo map                                   
   ----------------------------------------------------- 
   gen_8_256 : if (FifoSize > 32 and FifoSize <= 256 and not ASYNC) generate
      begin
      FoundGenCase <= true;
      
      t_axi4_stream16_sfifo_d256_inst : t_axi4_stream16_sfifo_d256
      port map(
         
         s_aclk           =>  CLK_RX,      
         s_aresetn        =>  areset_n,
         
         s_axis_tvalid    =>  s_axis_tvalid, 
         s_axis_tready    =>  s_axis_tready, 
         s_axis_tdata     =>  s_axis_tdata,  
         s_axis_tstrb     =>  s_axis_tstrb,  
         s_axis_tkeep     =>  s_axis_tkeep,  
         s_axis_tlast     =>  s_axis_tlast,  
         s_axis_tid       =>  s_axis_tid,    
         s_axis_tdest     =>  s_axis_tdest,  
         s_axis_tuser     =>  s_axis_tuser,  
         
         m_axis_tvalid    =>  m_axis_tvalid, 
         m_axis_tready    =>  m_axis_tready, 
         m_axis_tdata     =>  m_axis_tdata,  
         m_axis_tstrb     =>  open,  
         m_axis_tkeep     =>  open,  
         m_axis_tlast     =>  open,  
         m_axis_tid       =>  open,    
         m_axis_tdest     =>  open,  
         m_axis_tuser     =>  open,
         
         axis_data_count  =>  data_cnt_i,
         axis_overflow    =>  full_i
         );
      
   end generate;
   
   U1A: process(CLK_TX)
   begin
      if rising_edge(CLK_TX) then
         if sreset_tx = '1' then 
            empty_i <= '1'; 
         else
            if unsigned(data_cnt_i) > 0 then 
               empty_i <= '0'; 
            else
               empty_i <= '1'; 
            end if;         
         end if;
      end if; 
   end process;
   
end RTL;
