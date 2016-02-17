-------------------------------------------------------------------------------
--
-- Title       : LL_sqrt_float32.vhd
-- Design      : VP30
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description :
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_sqrt_float32 is   
   port(
      A_MOSI   : in  t_ll_mosi32;
      A_MISO   : out t_ll_miso;

      RES_MOSI : out t_ll_mosi32;
      RES_MISO : in  t_ll_miso;

      ERR      : out std_logic;

      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC
      );
end LL_sqrt_float32;

-- pragma translate_off
library IEEE_proposed;
use ieee_proposed.float_pkg.all;
-- pragma translate_on

architecture RTL of LL_sqrt_float32 is

-----------------------------------------------------------
-- To change the core latency, you have to regenerate it!!!
-----------------------------------------------------------
Constant LATENCY : integer := 26;
---------------------------------------------------------

   -- Declaration needed because this is a black box
component fp_sqrt_float32_L26
	port (
	a: IN std_logic_VECTOR(31 downto 0);
	operation_nd: IN std_logic;
	operation_rfd: OUT std_logic;
	clk: IN std_logic;
	sclr: IN std_logic;
	ce: IN std_logic;
	result: OUT std_logic_VECTOR(31 downto 0);
	invalid_op: OUT std_logic;
	rdy: OUT std_logic);
end component;

   -- Errors
   signal invalid_op         : std_logic;
   signal not_ready_err    : std_logic;

   -- Handshaking
   signal operation_nd     : std_logic;
   signal operation_rfd    : std_logic;
   signal ce               : std_logic;
   --signal ce_inv           : std_logic;
   signal rdy              : std_logic;
   signal sqrt_dval      : std_logic;
   signal sync_busy        : std_logic;

   -- Registers
   signal hold_dval        : std_logic;
   signal ce_reg           : std_logic;

   -- Buffers
   signal result           : std_logic_vector(31 downto 0);
   signal RES_DVALi        : std_logic;

   -- Shift registers
   signal SOF_sr           : std_logic_vector(LATENCY downto 0);
   signal EOF_sr           : std_logic_vector(LATENCY downto 0);

   -- Misc
   signal RESET            : std_logic;

   -- pragma translate_off
   signal a_real           : real;
   signal result_real      : real;
   -- pragma translate_on

   signal a                : std_logic_vector(31 downto 0);

   signal FoundGenCase : boolean := FALSE;

   component sync_reset
	port(
		ARESET : in std_logic;
		SRESET : out std_logic;
		CLK : in std_logic);
	end component;


begin

   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);

   operation_nd <= A_MOSI.DVAL;

   not_ready_err <= operation_nd and not operation_rfd;

   ERR <= invalid_op;

   RES_MOSI.SUPPORT_BUSY <= '1';
   RES_DVALi <= sqrt_dval or hold_dval;
   RES_MOSI.DVAL <= RES_DVALi;
   RES_MOSI.DATA <= result;
   RES_MOSI.SOF <= SOF_sr(LATENCY);
   RES_MOSI.EOF <= EOF_sr(LATENCY);

   ce <= (not RES_MISO.AFULL) and (not RES_MISO.BUSY);
   --ce_inv <= not ce;
   sqrt_dval <= rdy and ce_reg;

   SOF_sr(0) <= A_MOSI.SOF;
   EOF_sr(0) <= A_MOSI.EOF;

   sync_busy <= not ce or not operation_rfd;

   A_MISO.BUSY <= sync_busy;
   A_MISO.AFULL <= '0';

   -- pragma translate_off
   a_real <= to_real(to_float(A_MOSI.DATA));
   result_real <= to_real(to_float(result));
   -- pragma translate_on

   a <= Uto0(A_MOSI.DATA) when FALSE
   -- pragma translate_off
   or A_MOSI.DVAL = '0'
   -- pragma translate_on
   else A_MOSI.DATA;

   gen_sqrt_float_L26 : if LATENCY = 26 generate
   begin
      FoundGenCase <= true;
      u0_fp_sqrt_float32_l8 : fp_sqrt_float32_L26
	   	port map (
	   		a => a,
	   		operation_nd => operation_nd,
	   		operation_rfd => operation_rfd,
	   		clk => CLK,
	   		sclr => RESET,
	   		ce => ce,
	   		result => result,
	   		invalid_op => invalid_op,
	   		rdy => rdy
	   );
   end generate;

   main : process(CLK)
      -- pragma translate_off
      variable cnt_in, cnt_out : integer := 1;
      -- pragma translate_on
   begin
      if rising_edge(CLK) then
         ce_reg <= ce;

         -- DVALID latch (when destination is not ready, all we have to do is hold the DVal signal, the data stays valid at the core output)
         if RESET = '1' then
            hold_dval <= '0';
         else
            hold_dval <= RES_MISO.BUSY and RES_DVALi;
         end if;

         -- SOF & EOF shift registers
         if ce = '1' then
            SOF_sr(LATENCY downto 1) <= SOF_sr(LATENCY-1 downto 0);
            EOF_sr(LATENCY downto 1) <= EOF_sr(LATENCY-1 downto 0);
         end if;

         if RESET = '0' then
            -- pragma translate_off
            assert (A_MOSI.SUPPORT_BUSY = '1') report "A Upstream module must support the BUSY signal" severity FAILURE;

            if sqrt_dval = '1' then
               assert (invalid_op = '0') report "SQRT invalid_op" severity ERROR;
            end if;
--            assert (not_ready_err = '0') report "AddSub not_ready_err" severity ERROR;
--            if operation_nd='1' and ce='1' then
--               assert (operation_rfd='1') report "AddSub not ready!" severity ERROR;
--            end if;
            -- pragma translate_on
         end if;

         -- Debug counters
         -- pragma translate_off
         if operation_nd = '1' and ce = '1' then
            if A_MOSI.SOF = '1' then
               cnt_in := 2;
            else
               cnt_in := cnt_in + 1;
            end if;
         end if;
         if rdy = '1' and ce = '1' then
            if SOF_sr(LATENCY) = '1' then
               cnt_out := 2;
            else
               cnt_out := cnt_out + 1;
            end if;
         end if;
         -- pragma translate_on
      end if;
   end process;

end RTL;
