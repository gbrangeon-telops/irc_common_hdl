---------------------------------------------------------------------------------------------------
--
-- Title       : VP7_Error_Detect
-- Design      : VP7
-- Author      : Patrick Dubois
-- Company     : Telops
--
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
-- pragma translate_off
library Common_HDL; -- Components Clk_Divider and double_sync are in library Common_HDL for simulation only
-- pragma translate_on
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;

entity VP7_Error_Detect is
   port(        
      SW_CNT_ERR        : in std_logic;  
      IMG_CNT_ERR       : in std_logic;
      SW_WR_ERR         : in std_logic;
      --CONFIG_ERR        : in std_logic;
      CLINK_TIMEOUT_ERR : in std_logic; -- This timeout should ONLY happen if the CameraLink settings are bad.
      CLINK_FIFO_RD_ERR : in std_logic;
      CLINK_FIFO_WR_ERR : in std_logic;
      CLINK_FIFO_FULL   : in std_logic; -- can be omitted if need space for more errors
      CLINK_CFG_ERR     : in std_logic;
      FPGA2_FIFO_FULL   : in std_logic;
      FPGA1_FIFO_FULL   : in std_logic;
      RIO21_ERR         : in std_logic;
      RIO6_ERR          : in std_logic;
      RS232_ERR         : in std_logic;
      FRAME_ERR         : in std_logic;
      FPGA_TEMP         : in std_logic_vector(7 downto 0);
      EXT_TEMP          : in std_logic_vector(7 downto 0);
      VP7_STATUS        : out VP7StatusInfo;
      ARESET            : in STD_LOGIC;
      CLK               : in STD_LOGIC;
      LED               : buffer STD_LOGIC_VECTOR(2 downto 0)
      );
end VP7_Error_Detect;

architecture VP7_Error_Detect of VP7_Error_Detect is

   signal CLK_Led : std_logic; 
   signal flip : std_logic;
   
   signal Error_Code : std_logic_vector(3 downto 0); 
   
   signal CLK_LED_sync : std_logic; -- Resync clock generated by clock divider
   
   signal FPGA1_FIFO_FULL_sync : std_logic;
   signal FPGA2_FIFO_FULL_sync : std_logic;
   signal RIO21_ERR_sync : std_logic;
   signal RIO6_ERR_sync : std_logic;
   signal CLINK_FIFO_FULL_sync : std_logic;
   signal CLINK_TIMEOUT_ERR_sync : std_logic;
   signal CLINK_FIFO_RD_ERR_sync : std_logic;
   signal FRAME_ERR_sync : std_logic;
	signal VP7_STATUS_reg : VP7StatusInfo;     
   
   signal RESET : std_logic;
   
begin     
   sync_RESET_inst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);   
   
	VP7_STATUS <= VP7_STATUS_reg;
   
   -- Error Latching Process
   process (CLK, RESET)
      variable delay_cnt : integer range 0 to 65535;
   begin       
      if rising_edge(CLK) then   
         if RESET = '1' then
            Error_Code <= "0000";
            delay_cnt := 0;
				VP7_STATUS_reg <= VP7StatusInfo_default;
         else
            -- Error Latching
            if delay_cnt >= 65535 
               -- pragma translate_off
               or delay_cnt >= 100
               -- pragma translate_on
               then   
               -- Start registering status inputs after reset delay
					VP7_STATUS_reg.ExtTemp              <= EXT_TEMP;
					VP7_STATUS_reg.IntTemp              <= FPGA_TEMP;
					               
               VP7_STATUS_reg.Stat(12)   <= IMG_CNT_ERR;
               VP7_STATUS_reg.Stat(11)   <= CLINK_FIFO_WR_ERR;
					VP7_STATUS_reg.Stat(10)   <= CLINK_FIFO_RD_ERR;
					VP7_STATUS_reg.Stat(9)    <= CLINK_FIFO_FULL_sync;
					VP7_STATUS_reg.Stat(8)    <= CLINK_CFG_ERR;
					VP7_STATUS_reg.Stat(5)    <= FPGA1_FIFO_FULL_sync;
					VP7_STATUS_reg.Stat(6)    <= FPGA2_FIFO_FULL_sync;
					VP7_STATUS_reg.Stat(5)    <= CLINK_TIMEOUT_ERR_sync;
					VP7_STATUS_reg.Stat(4)    <= RIO21_ERR_sync;
					VP7_STATUS_reg.Stat(3)    <= RIO6_ERR_sync;
					VP7_STATUS_reg.Stat(2)    <= '0';
					VP7_STATUS_reg.Stat(1)    <= RS232_ERR;
					VP7_STATUS_reg.Stat(0)    <= FRAME_ERR_sync;
               if Error_Code = "0000" then -- only change led once
                  if CLINK_FIFO_RD_ERR_sync = '1' then   
                     Error_Code <= "0001";
                     assert false report "CLINK_FIFO_RD_ERR Error in VP7!!" severity ERROR;
                  elsif CLINK_CFG_ERR = '1' then 
                     Error_Code <= "0010";
                     assert false report "CLINK_CFG_ERR Error in VP7!!" severity ERROR;
                  elsif FPGA1_FIFO_FULL_sync = '1' then 
                     Error_Code <= "0011";
                     assert false report "FPGA1_FIFO_FULL_sync Error in VP7!!" severity ERROR;
                  elsif FPGA2_FIFO_FULL_sync = '1' then 
                     Error_Code <= "0100";
                     assert false report "FPGA2_FIFO_FULL_sync Error in VP7!!" severity ERROR;
                  elsif CLINK_FIFO_WR_ERR = '1' then
                     Error_Code <= "0101";
                     assert false report "CLINK_FIFO_WR_ERR Error in VP7!!" severity ERROR;
                  elsif SW_WR_ERR = '1' then
                     Error_Code <= "0110";
                     assert false report "SW_WR_ERR Error in VP7!!" severity ERROR; 
                  elsif IMG_CNT_ERR = '1' then
                     Error_Code <= "0111";
                     assert false report "IMG_CNT_ERR Error in VP7!!" severity ERROR;                         
                  elsif RS232_ERR = '1' then 
                     Error_Code <= "1001";
                     assert false report "RS232_ERR Error in VP7!!" severity ERROR;
                  elsif FRAME_ERR_sync = '1' then
                     Error_Code <= "1010";                                                
                     assert false report "RS232 FRAME Error in VP7!!" severity ERROR;
                  elsif RIO21_ERR_sync = '1' then
                     Error_Code <= "1011";                                                
                     assert false report "RIO21_ERR Error in VP7!!" severity ERROR;                     
                  elsif RIO6_ERR_sync = '1' then
                     Error_Code <= "1011";                                                
                     assert false report "RIO6_ERR Error in VP7!!" severity ERROR;                       
                  elsif CLINK_FIFO_FULL_sync = '1' then 
                     Error_Code <= "1100"; 
                     assert false report "CLINK_FIFO_FULL_sync Error in VP7!!" severity ERROR;
                  elsif CLINK_TIMEOUT_ERR_sync = '1' then 
                     Error_Code <= "1101"; 
                     assert false report "CLINK_TIMEOUT_ERR Error in VP7!!" severity ERROR;
                  elsif SW_CNT_ERR = '1' then 
                     Error_Code <= "1110"; 
                     assert false report "SW_CNT_ERR Error in VP7!!" severity ERROR; 
                  end if; -- if CLINK_FIFO_RD_ERR_sync = '1'
               end if; -- if Error_Code = "0000" then    
            else         
               delay_cnt := delay_cnt + 1;                  
            end if; -- if delay_cnt >= 65535 
         end if;
      end if;
   end process;
   
   LED_CLK_Divider : entity Clk_Divider
   Generic map( Factor => 25000000) -- 2 Hz output for 50 MHz input. 
   Port map(      
      Clock    => CLK,     -- UART Reference Input Clock
      Reset    => RESET,
      Clk_div  => CLK_Led);
   
   -- Led Driving Process
   process (CLK, RESET)
   begin 
      if rising_edge(CLK) then
         if RESET = '1' then
            flip <= '0';
            LED <= "000";
         else
            if CLK_LED_sync = '1' then
               flip <= not flip;
               if Error_Code(3) = '1' and flip = '0' then
                  LED <= "111";
               else
                  LED <= Error_Code(2 downto 0);
               end if;
            end if;
         end if;
      end if;
   end process;
   
   U1 : entity double_sync
   port map( D => FPGA1_FIFO_FULL,
      Q => FPGA1_FIFO_FULL_sync,
      RESET => RESET,
      CLK => CLK);
   
   U2 : entity double_sync
   port map( D => FPGA2_FIFO_FULL,
      Q => FPGA2_FIFO_FULL_sync,
      RESET => RESET,
      CLK => CLK);
   
   U3 : entity double_sync
   port map( D => CLINK_TIMEOUT_ERR,
      Q => CLINK_TIMEOUT_ERR_sync,
      RESET => RESET,
      CLK => CLK);   
   
   U4 : entity double_sync
   port map( D => CLINK_FIFO_RD_ERR,
      Q => CLINK_FIFO_RD_ERR_sync,
      RESET => RESET,
      CLK => CLK);      
   
   U5 : entity double_sync
   port map( D => RIO21_ERR,
      Q => RIO21_ERR_sync,
      RESET => RESET,
      CLK => CLK);
   
   U6 : entity double_sync
   port map( D => RIO6_ERR,
      Q => RIO6_ERR_sync,
      RESET => RESET,
      CLK => CLK); 
   
   U7 : entity double_sync
   port map( D => CLINK_FIFO_FULL,
      Q => CLINK_FIFO_FULL_sync,
      RESET => RESET,
      CLK => CLK);
   
   U8 : entity double_sync
   port map( D => CLK_LED,
      Q => CLK_LED_sync,
      RESET => RESET,
      CLK => CLK);      
   
   U9 : entity double_sync
   port map( D => FRAME_ERR,
      Q => FRAME_ERR_sync,
      RESET => RESET,
      CLK => CLK);      
   
end VP7_Error_Detect;
