-------------------------------------------------------------------------------
--
-- Title       : TMI_aFifo
-- Author      : Interface: PDU. Core: KBE
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- $Author: rd\pdubois $
-- $LastChangedDate: 2010-03-26 14:28:59 -0400 (ven., 26 mars 2010) $
-- $Revision: 7590 $
-------------------------------------------------------------------------------
-- Description : TMI Ansychronous Fifo.
--               This fifo has a fixed depth of 16. It should only be used to
--               cross clock domains. If you need a deeper fifo, you should
--               use TMI_sFifo instead.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;     
library Common_HDL;

entity TMI_aFifo is
   generic(
      DLEN  : natural := 32;
      ALEN  : natural := 21);
   port(
      --------------------------------
      -- Client Interface (aka IN)
      --------------------------------
      TMI_IN_ADD       : in  std_logic_vector(ALEN-1 downto 0);
      TMI_IN_RNW       : in  std_logic;
      TMI_IN_DVAL      : in  std_logic;
      TMI_IN_BUSY      : out std_logic;
      TMI_IN_RD_DATA   : out std_logic_vector(DLEN-1 downto 0);
      TMI_IN_RD_DVAL   : out std_logic;
      TMI_IN_WR_DATA   : in  std_logic_vector(DLEN-1 downto 0);
      TMI_IN_IDLE      : out std_logic;
      TMI_IN_ERROR     : out std_logic;
      TMI_IN_CLK       : in  std_logic;
      --------------------------------
      -- Controller Interface (aka OUT)
      --------------------------------
      TMI_OUT_ADD        : out std_logic_vector(ALEN-1 downto 0);
      TMI_OUT_RNW        : out std_logic;
      TMI_OUT_DVAL       : out std_logic;
      TMI_OUT_BUSY       : in  std_logic;
      TMI_OUT_RD_DATA    : in  std_logic_vector(DLEN-1 downto 0);
      TMI_OUT_RD_DVAL    : in  std_logic;
      TMI_OUT_WR_DATA    : out std_logic_vector(DLEN-1 downto 0);
      TMI_OUT_IDLE       : in  std_logic;
      TMI_OUT_ERROR      : in  std_logic;
      TMI_OUT_CLK        : in  std_logic;
      --------------------------------
      -- Common Interface
      --------------------------------
      ARESET      : in std_logic
      );
end TMI_aFifo;

architecture RTL of TMI_aFifo is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component afifo_w1_d16
      port (
         din: IN std_logic_VECTOR(0 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(0 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;   
   
   component afifo_w32_d16
      port (
         din: IN std_logic_VECTOR(31 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(31 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;
   
   component afifo_w22_d16
      port (
         din: IN std_logic_VECTOR(21 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(21 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;
   
   component afifo_w9_d16
      port (
         din: IN std_logic_VECTOR(8 downto 0);
         rd_clk: IN std_logic;
         rd_en: IN std_logic;
         rst: IN std_logic;
         wr_clk: IN std_logic;
         wr_en: IN std_logic;
         dout: OUT std_logic_VECTOR(8 downto 0);
         empty: OUT std_logic;
         full: OUT std_logic;
         overflow: OUT std_logic;
         valid: OUT std_logic);
   end component;
   
   component double_sync
      generic(
         INIT_VALUE : bit := '0'
         );
      port(
         D : in STD_LOGIC;
         Q : out STD_LOGIC := '0';
         RESET : in STD_LOGIC;
         CLK : in STD_LOGIC
         );
   end component;
   
   signal FoundGenCase : boolean := FALSE;
   signal Sreset_Client  : std_logic;
   signal Sreset_Ctrler  : std_logic;
   
   signal cmd_din_s8,
   cmd_dout_s8     : std_logic_vector(8 downto 0); -- ALEN-1+1 = ALEN, +1 because we add TMI_IN_RNW bit
   signal cmd_din_s21,
   cmd_dout_s21     : std_logic_vector(21 downto 0); -- ALEN-1+1 = ALEN, +1 because we add TMI_IN_RNW bit   
   signal data_full_s   : std_logic;
   signal cmd_full_s  : std_logic;
   signal cmd_valid_s   : std_logic;
   signal cmd_rd_ens_s : std_logic;
   signal data_valid_s : std_logic;
   signal cmd_empty_s : std_logic;
   
   
   signal RdData_wr_en_s   : std_logic;
   signal RdData_rd_en_s   : std_logic;
   signal RdData_empty_s   : std_logic;
   signal RdData_valid_s   : std_logic;
   signal cmd_overflow_s   : std_logic;
   signal Wrdata_valid_s   : std_logic;
   signal WrData_rd_ens_s : std_logic;
   signal WrData_wr_en_s   : std_logic;
   signal cmd_wr_en_s      : std_logic;
   signal RdData_overflow_s : std_logic;
   signal tmi_in_idle_s     : std_logic;
   signal error_sig_ClienterSide   : std_logic;
   signal error_sig_CtrlerSide   : std_logic;
   signal tmi_idle_CtrlerSide : std_logic;
   signal tmi_idle_ClientSide : std_logic;
   signal tmi_out_dval_s    : std_logic;
   signal WrData_din_s32,
   WrData_dout_s32        : std_logic_vector(31 downto 0);
   signal RdData_din_s32,
   RdData_dout_s32        : std_logic_vector(31 downto 0);
   signal WrData_din_s1,
   WrData_dout_s1        : std_logic_vector(0 downto 0);
   signal RdData_din_s1,
   RdData_dout_s1        : std_logic_vector(0 downto 0);   
   
   
   
begin
   
   -- synchronize reset locally.
   sync_RESET_Client :   sync_reset port map(ARESET => ARESET, SRESET => Sreset_Client,  CLK => TMI_IN_CLK);
   sync_RESET_Ctrler :   sync_reset port map(ARESET => ARESET, SRESET => Sreset_Ctrler,  CLK => TMI_OUT_CLK);
   
   gen_d32 : if (DLEN > 1 and DLEN <= 32) generate       
      
      WrData_din_s32    <= std_logic_vector(resize(unsigned(TMI_IN_WR_DATA), 32));
      TMI_OUT_WR_DATA   <= Wrdata_dout_s32(DLEN-1 downto 0); 
      RdData_din_s32    <= std_logic_vector(resize(unsigned(TMI_OUT_RD_DATA),32));
      TMI_IN_RD_DATA    <= RdData_dout_s32(DLEN-1 downto 0);      
      
      Wr_data_fifo : afifo_w32_d16
      port map (
         din 		   => WrData_din_s32,
         rd_clk 		=> TMI_OUT_CLK,
         rd_en 		=> WrData_rd_ens_s,
         rst 		   => ARESET,
         wr_clk 		=> TMI_IN_CLK,
         wr_en 		=> WrData_wr_en_s,
         dout 		   => Wrdata_dout_s32,
         empty 		=> open,
         full 		   => open, -- Not needed, we use cmd_full_s instead.
         overflow	   => open, -- We use cmd_overflow_s instead.
         valid 		=> Wrdata_valid_s);       
      
      Rd_data_fifo : afifo_w32_d16
      port map (
         din 		   => RdData_din_s32,
         rd_clk 		=> TMI_IN_CLK,
         rd_en 		=> RdData_rd_en_s,
         rst 		   => ARESET,
         wr_clk 		=> TMI_OUT_CLK,
         wr_en 		=> RdData_wr_en_s,
         dout		   => RdData_dout_s32,
         empty 		=> RdData_empty_s,
         full 		   => open,          -- No flow ctrl: Read data from memory have to go somewher
         overflow	   => RdData_overflow_s,      -- We can only notice the oveflow error.
         valid 		=> RdData_valid_s);         
   end generate gen_d32;  
   
   gen_d1 : if (DLEN = 1) generate 
      
      WrData_din_s1     <= TMI_IN_WR_DATA;
      TMI_OUT_WR_DATA   <= Wrdata_dout_s1(DLEN-1 downto 0);
      RdData_din_s1     <= TMI_OUT_RD_DATA;
      TMI_IN_RD_DATA    <= RdData_dout_s1(DLEN-1 downto 0);      
      
      Wr_data_fifo : afifo_w1_d16
      port map (
         din 		   => WrData_din_s1,
         rd_clk 		=> TMI_OUT_CLK,
         rd_en 		=> WrData_rd_ens_s,
         rst 		   => ARESET,
         wr_clk 		=> TMI_IN_CLK,
         wr_en 		=> WrData_wr_en_s,
         dout 		   => Wrdata_dout_s1,
         empty 		=> open,
         full 		   => open, -- Not needed, we use cmd_full_s instead.
         overflow	   => open, -- We use cmd_overflow_s instead.
         valid 		=> Wrdata_valid_s);       
      
      Rd_data_fifo : afifo_w1_d16
      port map (
         din 		   => RdData_din_s1,
         rd_clk 		=> TMI_IN_CLK,
         rd_en 		=> RdData_rd_en_s,
         rst 		   => ARESET,
         wr_clk 		=> TMI_OUT_CLK,
         wr_en 		=> RdData_wr_en_s,
         dout		   => RdData_dout_s1,
         empty 		=> RdData_empty_s,
         full 		   => open,          -- No flow ctrl: Read data from memory have to go somewher
         overflow	   => RdData_overflow_s,      -- We can only notice the oveflow error.
         valid 		=> RdData_valid_s);         
   end generate gen_d1;    
   
   ---------------------------------------------------
   -- Write/In/Client side
   ---------------------------------------------------      
   WrData_wr_en_s    <= cmd_wr_en_s;-- and not(TMI_IN_RNW);   
   WrData_rd_ens_s   <= cmd_rd_ens_s;   
   
   ---------------------------------------------------
   -- Read/Out/Controller side
   ---------------------------------------------------      
   RdData_wr_en_s    <= TMI_OUT_RD_DVAL;
   RdData_rd_en_s    <= not(RdData_empty_s);   
   TMI_IN_RD_DVAL    <= RdData_valid_s;   
   
   ---------------------------------------------------
   -- Command side
   ---------------------------------------------------
   gen_a9 : if (ALEN <= 8) generate
      cmd_din_s8      <= std_logic_vector(resize(unsigned(TMI_IN_ADD), 8)) & TMI_IN_RNW;      
      TMI_OUT_ADD    <= cmd_dout_s8(ALEN downto 1);
      TMI_OUT_RNW    <= cmd_dout_s8(0);      
      cmd_fifo : afifo_w9_d16
      port map (
         din 		   => cmd_din_s8,
         rd_clk 		=> TMI_OUT_CLK,
         rd_en 		=> cmd_rd_ens_s,
         rst 		   => ARESET,
         wr_clk 		=> TMI_IN_CLK,
         wr_en 		=> cmd_wr_en_s,
         dout 		   => cmd_dout_s8,
         empty 		=> cmd_empty_s,
         full 		   => cmd_full_s,
         overflow	   => cmd_overflow_s,
         valid 		=> cmd_valid_s);
      --
      FoundGenCase <= true;              
   end generate gen_a9;
   
   gen_a21 : if (ALEN > 8 and ALEN <= 21) generate    
      cmd_din_s21      <= std_logic_vector(resize(unsigned(TMI_IN_ADD), 21)) & TMI_IN_RNW;
      TMI_OUT_ADD    <= cmd_dout_s21(ALEN downto 1);
      TMI_OUT_RNW    <= cmd_dout_s21(0);      
      cmd_fifo : afifo_w22_d16
      port map (
         din 		   => cmd_din_s21,
         rd_clk 		=> TMI_OUT_CLK,
         rd_en 		=> cmd_rd_ens_s,
         rst 		   => ARESET,
         wr_clk 		=> TMI_IN_CLK,
         wr_en 		=> cmd_wr_en_s,
         dout 		   => cmd_dout_s21,
         empty 		=> cmd_empty_s,
         full 		   => cmd_full_s,
         overflow	   => cmd_overflow_s,
         valid 		=> cmd_valid_s);
      --
      FoundGenCase <= true;      
   end generate gen_a21;   
   
   cmd_wr_en_s    <= TMI_IN_DVAL and not(cmd_full_s);
   TMI_IN_BUSY    <= cmd_full_s;
   cmd_rd_ens_s <= not(TMI_OUT_BUSY) and not(cmd_empty_s);
   
   --Process to hold DVAL when BUSY apears the clock cycle after fifo_ren was = 1.
   process(TMI_OUT_CLK)
   begin
      if rising_edge(TMI_OUT_CLK)then
         if Sreset_Ctrler = '1' then
            tmi_out_dval_s <= '0';
         else
            if TMI_OUT_BUSY = '0' then
               tmi_out_dval_s <= cmd_rd_ens_s;
            end if;
         end if;
      end if;
   end process;
   TMI_OUT_DVAL   <= tmi_out_dval_s;
   
   ----------------------------------------------------
   -- Other signals
   ----------------------------------------------------
   
   ---------- Error signal ----------------
   TMI_IN_ERROR <= cmd_overflow_s or error_sig_ClienterSide;
   error_sig_CtrlerSide <= TMI_OUT_ERROR or RdData_overflow_s;
   
   -- Bring the TMI_OUT_ERROR to the client clock domain
   error_DoubleSync: double_sync
   generic map (
      INIT_VALUE => '0'
      )
   port map(
      D        => error_sig_CtrlerSide,
      Q        => error_sig_ClienterSide,
      RESET    => Sreset_Client,
      CLK      => TMI_IN_CLK
      );
   ----------------------------------------
   
   ---------- IDLE signal ----------------
   -- To client TMI_IDLE is when there is no pending data in the fifos
   -- and the memory controler is idle too.
   TMI_IN_IDLE <= tmi_idle_ClientSide and RdData_empty_s;
   tmi_idle_CtrlerSide <= TMI_OUT_IDLE and cmd_empty_s ;
   
   -- Bring resulting idle signal to client clock domain.
   Idle_DoubleSync: double_sync
   generic map (
      INIT_VALUE => '0'
      )
   port map(
      D        => tmi_idle_CtrlerSide,
      Q        => tmi_idle_ClientSide,
      RESET    => Sreset_Client,
      CLK      => TMI_IN_CLK
      );
   ----------------------------------------
   
   
   process (TMI_IN_CLK)
   begin
      if rising_edge(TMI_IN_CLK) then
         --         if Sreset_Client = '1' then
         --         else
         
         -- translate_off
         assert (FoundGenCase) report "Invalid TMI fifo generic settings!" severity FAILURE;
         --            if FoundGenCase then
         --               assert (TMI_IN_ERROR = '0') report "LocalLink fifo overflow!!!" severity ERROR;
         --            end if;
         -- translate_on
         
         --         end if;
      end if;
   end process;
   
end RTL;