-------------------------------------------------------------------------------
--
-- Title       : ddr_wishbone
-- Design      : FIR_00186
-- Author      : JDE
-- Company     : Telops Inc.
--
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.all;
use Common_HDL.Telops.all;

entity ddr_wishbone is
   port(
      ARESET         : in std_logic;
      CLK            : in std_logic;
      WB_MOSI        : in t_wb_mosi;
      WB_MISO        : out t_wb_miso;
      CORE_INITDONE  : in std_logic;
      TEST_STATUS    : in std_logic_vector(1 downto 0);
      ADDR_ERR_BITS  : in std_logic_vector(27 downto 0);
      DATA_ERR_BITS  : in std_logic_vector(71 downto 0);
      CORE_RESET     : out std_logic;
      TEST_RESET     : out std_logic
      );
end ddr_wishbone;

architecture RTL of ddr_wishbone is

   signal SRESET : std_logic;
   signal restart_core_cmd : std_logic;
   signal restart_test_cmd : std_logic;
   signal reset_core_cmd : std_logic;
   signal reset_test_cmd : std_logic;

begin
   process(CLK, ARESET)
      variable temp : std_logic;
   begin
      if ARESET = '1' then
         SRESET <= '1'; 
         temp := '1'; 
      elsif rising_edge(CLK) then
         SRESET <= temp;
         temp := ARESET;
      end if;
   end process;   

   wb_rd : process(CLK)
   begin
      if rising_edge(CLK) then
         WB_MISO.ACK <= WB_MOSI.STB;
         
         case WB_MOSI.ADR(7 downto 0) is 
            when X"00" => WB_MISO.DAT <= (15 downto 3 => '0') & TEST_STATUS & CORE_INITDONE;
            when X"02" => WB_MISO.DAT <= ADDR_ERR_BITS(15 downto 0);
            when X"03" => WB_MISO.DAT <= "0000" & ADDR_ERR_BITS(27 downto 16);
            when X"04" => WB_MISO.DAT <= DATA_ERR_BITS(15 downto 0);
            when X"05" => WB_MISO.DAT <= DATA_ERR_BITS(31 downto 16);
            when X"06" => WB_MISO.DAT <= DATA_ERR_BITS(47 downto 32);
            when X"07" => WB_MISO.DAT <= DATA_ERR_BITS(63 downto 48);
            when X"08" => WB_MISO.DAT <= "00000000" & DATA_ERR_BITS(71 downto 64);
            when others => WB_MISO.DAT <= X"0000";
         end case;
      end if;     
   end process;   
   
   wb_wr : process(CLK)
   begin
      if rising_edge(CLK) then
         restart_core_cmd <= '0';
         restart_test_cmd <= '0';
         if SRESET = '1' then
            reset_core_cmd <= '0';
            reset_test_cmd <= '0';
         elsif( (WB_MOSI.STB and WB_MOSI.WE) = '1' ) then
            case WB_MOSI.ADR(7 downto 0) is
               when X"00" =>
                  restart_core_cmd <= WB_MOSI.DAT(0);
                  restart_test_cmd <= WB_MOSI.DAT(1);
               when X"01" =>
                  reset_core_cmd <= WB_MOSI.DAT(0);
                  reset_test_cmd <= WB_MOSI.DAT(1);
               when others =>
            end case;
         end if;
      end if;
   end process;

   outputs : process(CLK)
      variable core_cnt : integer range 0 to 15 := 0;
      variable test_cnt : integer range 0 to 15 := 0;
   begin
      if rising_edge(CLK) then
         if SRESET = '1' then
            CORE_RESET <= '1';
            TEST_RESET <= '1';
            core_cnt := 0;
            test_cnt := 0;
         else
            if restart_core_cmd = '1' or reset_core_cmd = '1'then
               CORE_RESET <= '1';
               core_cnt := 0;
            elsif core_cnt /= 15 then
               core_cnt := core_cnt + 1;
            else
               CORE_RESET <= '0';
            end if;

            if restart_test_cmd = '1' or reset_test_cmd = '1' or CORE_INITDONE = '0' then
               TEST_RESET <= '1';
               test_cnt := 0;
            elsif test_cnt /= 15 then
               test_cnt := test_cnt + 1;
            else
               TEST_RESET <= '0';
            end if;
         end if;
      end if;
   end process;

end RTL;
