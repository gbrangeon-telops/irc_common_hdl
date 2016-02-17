-------------------------------------------------------------------------------
--
-- Title       : PatGen_externalIN_TB
-- Design      : Pattern_gen
-- Author      : Jean-Philippe Dery
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : PatGen_externalIN_TB.vhd
-- Generated   : Thu Jul  3 12:00:32 2008
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {PatGen_externalIN_TB} architecture {PatGen_externalIN_TB}}

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library Common_HDL; 
use Common_HDL.Telops.all;
library work;
use work.DPB_define.all;
use work.CAMEL_define.all;

entity PatGen_externalIN_TB is
end PatGen_externalIN_TB;

--}} End of automatically maintained section

architecture PatGen_externalIN_TB of PatGen_externalIN_TB is

   component pattern_gen_32 is
   generic(
      SUPPORT_CONFIG : boolean := true);      -- set to true to be able to generate configuration frames (testbenches)
   port(
      --------------------------------
      -- Control
      --------------------------------
      CLK             : in std_logic;      
      ARESET          : in std_logic;
      PG_CTRL         : in PatGenConfig;      -- configuration and control port of the pattern generator
      DONE            : out std_logic;        -- frame in progress monitoring
      --------------------------------
      -- Configuration Parameters
      --------------------------------
      ODD_EVENn       : in std_logic;         -- set to 1 for odd path, 0 for even.
      CLINK_CONF      : in CLinkConfig;
      DP_CONF_ARRAY32 : in DPConfig_array32;  -- ajouté pour supporter le Tesbench de DP_board. Son premier Q-Word  comporte les elemnts d'identification de la trame.  
      --------------------------------
      -- LocalLink output port
      --------------------------------       
      USE_EXTERNAL_INPUT: in std_logic;
      RX_LL_MOSI      : in t_ll_mosi32;
      RX_LL_MISO      : out  t_ll_miso;    
      TX_LL_MOSI      : out t_ll_mosi32;
      TX_LL_MISO      : in t_ll_miso);
   end component;
   
   type state_t is (Init, Send, Finish);

   signal clk              : std_logic := '0';
   signal rst              : std_logic := '1';
   signal done             : std_logic;
   signal pg_ctrl          : PatGenConfig;
   signal clink_conf       : CLinkConfig;
   signal dp_conf          : DPConfig_array32;
   signal RX_LL_MOSI       : t_ll_mosi32;
   signal RX_LL_MISO       : t_ll_miso;
   signal TX_LL_MOSI       : t_ll_mosi32;
   signal TX_LL_MISO       : t_ll_miso;
   signal state            : state_t := Init;

begin
   
   clk <= not clk after 5 ns;
   rst <= '0' after 10 us;
   
   -- Config generation for pattern generator
   pg_process: process (clk, rst)
   begin
      if rst = '1' then
      elsif clk'event and clk = '1' then
         case state is
            when Init =>
               pg_ctrl.Trig <= '0';
               pg_ctrl.FrameType <= X"00";
               pg_ctrl.XSize <= "0000000100";
               pg_ctrl.YSize <= "0000000010";
               pg_ctrl.ZSize <= X"000010";
               pg_ctrl.DiagSize <= "0000000000000001";
               pg_ctrl.PayloadSize <= X"ABCDEF";
               pg_ctrl.TagSize <= X"08";
               pg_ctrl.DiagMode <= PG_BSQ_XYZ;
               pg_ctrl.ImagePause <= X"0010";
               state <= Send;
            when Send =>
               pg_ctrl.Trig <= '1';
               state <= Finish;
            when Finish =>
               pg_ctrl.Trig <= '0';
         end case;
      end if;
   end process;

   -- Local-Link input data feed
   RX_LL_MOSI.DREM <= "11";
   RX_LL_MOSI.SUPPORT_BUSY <= '1';
   rx: process (clk, rst)
      variable cnt : std_logic_vector(31 downto 0);
   begin
      if rst = '1' then
         cnt := (others => '0');
         RX_LL_MOSI.SOF  <= '0';
         RX_LL_MOSI.EOF  <= '0';
         RX_LL_MOSI.DVAL <= '0';
      elsif clk'event and clk = '1' then
         if RX_LL_MISO.BUSY = '0' then
            if RX_LL_MISO.AFULL = '0' then
               if cnt = X"0000" then
                  RX_LL_MOSI.SOF <= '1';
               else
                  RX_LL_MOSI.SOF <= '0';
               end if;
               RX_LL_MOSI.DATA <= cnt;
               RX_LL_MOSI.DVAL <= '1';
               if cnt = X"000F" then
                  RX_LL_MOSI.EOF <= '1';
                  cnt := (others => '0');
               else
                  RX_LL_MOSI.EOF <= '0';
                  cnt := cnt + 1;
               end if;
            else
               RX_LL_MOSI.SOF <= '0';
               RX_LL_MOSI.EOF <= '0';
               RX_LL_MOSI.DVAL <= '0';
            end if;
         end if;
      end if;
   end process;

   -- Local-Link Pattern Output
   TX_LL_MISO.AFULL <= '0';
   TX_LL_MISO.BUSY <= '0';

   -- Pattern generator
   PatGen: pattern_gen_32
   generic map(
      SUPPORT_CONFIG => FALSE
   )
   port map(
      --------------------------------
      -- Control
      --------------------------------
      CLK             => clk,
      ARESET          => rst,
      PG_CTRL         => pg_ctrl,
      DONE            => done,
      --------------------------------
      -- Configuration Parameters
      --------------------------------
      ODD_EVENn       => '0',
      CLINK_CONF      => clink_conf,
      DP_CONF_ARRAY32 => dp_conf,
      --------------------------------
      -- LocalLink output port
      --------------------------------       
      USE_EXTERNAL_INPUT => '1',
      RX_LL_MOSI      => RX_LL_MOSI,
      RX_LL_MISO      => RX_LL_MISO,    
      TX_LL_MOSI      => TX_LL_MOSI,
      TX_LL_MISO      => TX_LL_MISO
      );

end PatGen_externalIN_TB;
