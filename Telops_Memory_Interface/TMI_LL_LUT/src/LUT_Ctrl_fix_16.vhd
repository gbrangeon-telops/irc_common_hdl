-------------------------------------------------------------------------------
--
-- Title       : LUT_Ctrl_fix_16
-- Author      : Patrick Dubois (arch) / Patrick Daraiche (code)
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--  $Revision$
--  $Author$
--  $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description :
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library COMMON_HDL;
use COMMON_HDL.TELOPS.all;

entity LUT_Ctrl_fix_16 is
   port(
      --------------------------------
      -- Wishbone
      --------------------------------    
      WB_MOSI     : in  t_wb_mosi32;
      WB_MISO     : out t_wb_miso32;
      --------------------------------
      -- X_to_ADD
      -------------------------------- 
      END_ADD     : out std_logic_vector(15 downto 0);
      LUTSIZE_M1  : out std_logic_vector(15 downto 0);
      START_ADD   : out std_logic_vector(15 downto 0);
      X_MIN       : out std_logic_vector(15 downto 0);
      X_RANGE     : out std_logic_vector(15 downto 0); 
      --------------------------------
      -- LL_TMI_Read
      --------------------------------       
      TMI_IDLE    : in  std_logic;
      --------------------------------
      -- Others
      -------------------------------- 
      ARESET      : in  std_logic;
      ARESET_OUT  : out std_logic;
      CLK         : in  std_logic
      );
end LUT_Ctrl_fix_16;


architecture RTL of LUT_Ctrl_fix_16 is

   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;      

   component double_sync
      generic(
         INIT_VALUE : BIT := '0');
      port(
         D : in STD_LOGIC;
         Q : out STD_LOGIC;
         RESET : in STD_LOGIC;
         CLK : in STD_LOGIC);
   end component;

   signal sreset : std_logic;
   signal wr_ack : std_logic;
   signal rd_ack : std_logic; 
  
   
   signal rXmin         : std_logic_vector(X_MIN'range);
   signal rXrange       : std_logic_vector(X_RANGE'range);
   signal rLut_size_m1  : std_logic_vector(LUTSIZE_M1'range);
   signal rStart_add    : std_logic_vector(START_ADD'range);
   signal rEnd_add      : std_logic_vector(END_ADD'range);
   signal rStatus       : std_logic_vector (1 downto 0); -- rStatus(0) = TMI_IDLE
                                                         -- rStatus(1) = Areset_out feedback
   signal rAreset_out   : std_logic;
   
   signal TMI_Idle_i    : std_logic;   
   
   
begin

   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);    

   TMI_Idle_double_sync : double_sync
   port map(D => TMI_IDLE, Q => TMI_Idle_i, RESET => sreset, CLK => CLK);
   

   ARESET_OUT <= rAreset_out or sreset;
   
   X_MIN <= rXmin;
   X_RANGE <= rXrange;
   LUTSIZE_M1 <= rLut_size_m1;
   START_ADD <= rStart_add;
   END_ADD <= rEnd_add;
   WB_MISO.ACK <= wr_ack or rd_ack;
   
   wb_wr : process(CLK)
   begin
      if rising_edge(CLK) then         
         if (sreset = '1') then
            rXmin <= (others => '0');
            rXrange <= (others => '0');  
            rLut_size_m1 <= (others => '0');    
            rStart_add <= (others => '0');     
            rEnd_add <= (others => '0');  
            rAreset_out <= '0';   
            wr_ack <= '0';
         else
            wr_ack <= '0';
            if( (WB_MOSI.STB and WB_MOSI.WE) = '1') then -- Master write
               wr_ack <= '1';
               case WB_MOSI.ADR(7 downto 0) is
                  when X"00" =>
                  rXmin <= WB_MOSI.DAT(rXmin'RANGE);
                  when X"04" =>
                  rXrange <= WB_MOSI.DAT(rXrange'RANGE);
                  when X"08" =>
                  rLut_size_m1 <= WB_MOSI.DAT(rLut_size_m1'RANGE);
                  when X"0C" =>
                  rStart_add <= WB_MOSI.DAT(rStart_add'RANGE);
                  when X"10" =>
                  rEnd_add <= WB_MOSI.DAT(rEnd_add'RANGE);
                  when X"14" =>
                  rAreset_out <= WB_MOSI.DAT(0);
                  when others => --do nothing
               end case;
            end if;
         end if;
      end if;
   end process;
   
   wb_rd : process(CLK)
   begin 
      if rising_edge(CLK) then        
         if (sreset = '1') then
            WB_MISO.DAT <= (others => '0');
            rd_ack <= '0';
            rStatus <= (others => '0');
         else
            rd_ack <= '0';
            rStatus <= rAreset_out & TMI_Idle_i;
            if (WB_MOSI.STB = '1' and WB_MOSI.WE = '0') then              
               rd_ack <= '1';
               WB_MISO.DAT <= (others => '0');
               case WB_MOSI.ADR(7 downto 0) is
                  when X"00" =>
                  WB_MISO.DAT <= std_logic_vector(resize(unsigned(rXmin),32));
                  when X"04" =>
                  WB_MISO.DAT <= std_logic_vector(resize(unsigned(rXrange),32));
                  when X"08" =>
                  WB_MISO.DAT <= std_logic_vector(resize(unsigned(rLut_size_m1),32));
                  when X"0C" =>
                  WB_MISO.DAT <= std_logic_vector(resize(unsigned(rStart_add),32));
                  when X"10" =>
                  WB_MISO.DAT <= std_logic_vector(resize(unsigned(rEnd_add),32));
                  when X"14" =>
                  WB_MISO.DAT(0) <= rAreset_out;
                  when X"18" =>
                  WB_MISO.DAT(1 downto 0) <= rStatus;
                  when others => --do nothing
               end case; 
            end if;      
         end if;
      end if;
   end process;   
   

end RTL;
