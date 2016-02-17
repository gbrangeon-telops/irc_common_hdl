-------------------------------------------------------------------------------------------------

-- Title       : fp32tofix
-- Author      : Patrick Dubois
-- Company     : Telops/COPL

-------------------------------------------------------------------------------------------------

-- Description : This LocalLink module converts a 32-bit floating point dataflow to a 32-bit block
--               floating point flow (aka fixed-point with explicit exponent). It is pipelined to
--               achieve 100 MHz in a V2Pro-5.
--               TX = RX * 2^-EXP
-- KBE   : removed exponent from LL data flow and modified the module to be always 32-bit data
--         output width and added generics.
--
-------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity fp32tofix is
   generic(
      Verbose     : boolean := false;
      SIGNED_FI   : boolean := TRUE; -- If false, less logic because always signed.
      TX_DLEN     : natural := 12 -- valid data length on the 32-bit data OUTPUT. Input is always 32 bits
      );
   port(
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      EXP         : in  signed(7 downto 0);  -- Same length as float_exponent_width

      RX_MOSI     : in  t_ll_mosi32;
      RX_MISO     : out t_ll_miso;

      TX_MOSI     : out t_ll_mosi32;
      TX_MISO     : in  t_ll_miso;

      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;

      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC
      );
end fp32tofix;

--Declare these librairies only for the architecture
library IEEE_proposed_2010;
use ieee_proposed_2010.fixed_float_types.all;
use IEEE_proposed_2010.fixed_pkg.all;
use IEEE_proposed_2010.float_pkg.all;
library Common_HDL;
--use Common_HDL.sync_reset;

architecture RTL of fp32tofix is
   -- Registers
   signal hold_dval        : std_logic;
   --signal exp_dval         : std_logic;
   --signal block_next_dval  : std_logic;
   signal Sel              : std_logic;
   --signal tx_sof           : std_logic;

   -- Signals
   signal convert_ce    : std_logic;
   signal fi_data_final : std_logic_vector(TX_DLEN-1 downto 0); -- This signal should be in convert_block but xst crashes if it is.
   signal fi_dval_final : std_logic;

   signal RESET         : std_logic;
   signal RX_BUSYi      : std_logic;

   -- Buffers
   signal RX_DVALi      : std_logic;
   signal TX_DVALi      : std_logic;

   -- Shift registers
   constant Latency     : integer := 5; -- Number of stage in the pipeline
   signal SOF_sr        : std_logic_vector(Latency downto 0);
   signal EOF_sr        : std_logic_vector(Latency downto 0);
   signal dval_sr       : std_logic_vector(Latency downto 0);
   
   component sync_reset
   port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;


begin
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);

   -------------------------------------------------------
   -- LocalLink interface
   -------------------------------------------------------
   RX_DVALi <= RX_MOSI.DVAL and not RX_BUSYi;
   dval_sr(0) <= RX_DVALi;
   RX_MISO.BUSY <= RX_BUSYi;
   RX_BUSYi <= not convert_ce;
   RX_MISO.AFULL <= TX_MISO.AFULL or RESET;
   SOF_sr(0) <= RX_MOSI.SOF;
   EOF_sr(0) <= RX_MOSI.EOF;

   convert_ce <= (not TX_MISO.AFULL) and (not TX_MISO.BUSY) and not RESET;

   TX_MOSI.SUPPORT_BUSY <= '1';
   TX_MOSI.DVAL <= TX_DVALi;
   TX_DVALi <= fi_dval_final or hold_dval;


   TX_MOSI.DATA(TX_DLEN-1 downto 0) <= fi_data_final;
   signed_data: if SIGNED_FI generate
        TX_MOSI.DATA(31 downto TX_DLEN) <= (others => fi_data_final(fi_data_final'high)); 
   end generate;
   
   usigned_data: if not(SIGNED_FI) generate
        TX_MOSI.DATA(31 downto TX_DLEN) <= (others => '0'); 
   end generate;
   

   TX_MOSI.SOF <= SOF_sr(Latency);
   TX_MOSI.EOF <= EOF_sr(Latency);

   -------------------------------------------------------
   -- Flow control
   -------------------------------------------------------
   flow_control : process(CLK, ARESET)
      variable exp_rx_exp_ready : std_logic;
      variable wait_for_eof : std_logic;
      -- translate_off
      variable cnt_in        : integer;
      variable cnt_out       : integer;
      -- translate_on
   begin

      -- Debug counters
      -- translate_off
      if ARESET = '1' then
         cnt_in := 1;
         cnt_out := 1;
      elsif rising_edge(CLK) then
         if RX_DVALi = '1' then
            cnt_in := cnt_in + 1;
         end if;
         if TX_DVALi='1' and TX_MISO.BUSY='0' then
            cnt_out := cnt_out + 1;
         end if;
      end if;
      -- translate_on

      -- DVALID latch (when destination is not ready, all we have to do is hold the DVal signal, the data stays valid at the converter output)
      if ARESET = '1' then
         hold_dval <= '0';
      elsif rising_edge(CLK) then
         hold_dval <= TX_MISO.BUSY and TX_DVALi;
      end if;

      -- SOF shift register
      if rising_edge(CLK) then
         if convert_ce = '1' then
            SOF_sr(Latency downto 1) <= SOF_sr(Latency-1 downto 0);
         end if;
      end if;

      -- EOF shift register
      if rising_edge(CLK) then
         if convert_ce = '1' then
            EOF_sr(Latency downto 1) <= EOF_sr(Latency-1 downto 0);
         end if;
      end if;

      if ARESET = '0' then
         -- translate_off
         assert (RX_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;
         -- translate_on
      end if;

   end process;

   -------------------------------------------------------
   -- Perform actual conversion
   -------------------------------------------------------
   convert_block : block
      -- Stage 1
      signal sign1         : std_logic;
      signal exp1          : unsigned(float_exponent_width-1 downto 0);
      signal fract1        : std_logic_vector(float_fraction_width-1 downto 0);

      -- Stage 2
      signal fp_data2      : float32;

      -- Stage 3
      signal fi_data3      : std_logic_vector(TX_DLEN-1 downto 0);

      -- Stage 4
      signal fi_data4      : std_logic_vector(TX_DLEN-1 downto 0);
      signal overflow4     : std_logic;
      signal underflow4    : std_logic;

      -- Misc
      signal ce_reg        : std_logic;

      -- translate_off
      signal float_in_real : real;
      -- translate_on

      begin

      -- This signal will only pulse once per data valid, even if ce is held low.
      fi_dval_final <= dval_sr(Latency) and ce_reg;

      convert_proc : process(CLK, ARESET)
         variable sign2         : std_logic;
         variable fract2        : std_logic_vector(float_fraction_width-1 downto 0);
         variable exp2          : unsigned(float_exponent_width-1 downto 0);
         variable exp2_full     : signed(float_exponent_width downto 0);
         -- translate_off
         variable fp_data2_real  : real;
         variable valData_cnt : std_logic_vector(16 downto 0) := (others => '0');
         -- translate_on
      begin
         if rising_edge(CLK) then
            ce_reg <= convert_ce;
         end if;

         if rising_edge(CLK) and convert_ce = '1' then
            -- Dval shift register
            dval_sr(Latency downto 1) <= dval_sr(Latency-1 downto 0);

            -- Stage 1, register input data
            sign1 <= RX_MOSI.DATA(RX_MOSI.DATA'high);
            exp1 <= unsigned(RX_MOSI.DATA(RX_MOSI.DATA'high-1 downto RX_MOSI.DATA'high-float_exponent_width));
            fract1 <= RX_MOSI.DATA(float_fraction_width-1 downto 0);
            -- translate_off
            float_in_real <= to_real(to_float(RX_MOSI.DATA));
            -- translate_on

            -- Stage 2, add exponent
            -- Make sure that there is no overflow. We saturate to 0 and 255.
            -- Adder_Sat will saturate to either -256 or +255 in 9-bit mode.
            -- The saturation to +255 is okay but we just need to add saturation to 0.
            exp2_full := Adder_Sat(signed(resize(exp1, float_exponent_width+1)), -EXP);
            if exp2_full(float_exponent_width) = '1' then -- negative overflow, must saturate to 0
               exp2 := (others => '0');
            else
               exp2 := unsigned(exp2_full(float_exponent_width-1 downto 0));
            end if;

            sign2 := sign1;
            fract2 := fract1;
            fp_data2 <= to_float(sign2 & std_logic_vector(exp2) & fract2);
            -- translate_off
            fp_data2_real := to_real(to_float(sign2 & std_logic_vector(exp2) & fract2));
            -- translate_on

            -- Stage 3, convert floating-point number into fixed-point (expensive)
            if SIGNED_FI then
               fi_data3 <= std_logic_vector( to_signed (
               arg         => fp_data2,
               size        => fi_data3'LENGTH,
               check_error => float_check_error,--));--,
               round_style => round_zero));  -- was float_round_style
            else
               --assert false report "Unsigned 21-bit not supported!" severity FAILURE;
               fi_data3 <= std_logic_vector( to_unsigned (
               arg         => fp_data2,
               size        => fi_data3'LENGTH,
               check_error => float_check_error,--));--,
               round_style => round_zero));  -- was float_round_style
            end if;

            -- Stage 4, detect overflow and underflow
            fi_data4 <= fi_data3;
            if SIGNED_FI then
               if fi_data3 = ('0' & x"FFFFF") and dval_sr(3) = '1' then
                  overflow4 <= '1';
                  if Verbose then
                     assert FALSE report "Positive overflow in floating point to fixed-point convertion" severity ERROR;
                  end if;

               elsif fi_data3 = ('1' & x"00000") and dval_sr(3) = '1' then
                  overflow4 <= '1';
                  if Verbose then
                     assert FALSE report "Negative overflow in floating point to fixed-point convertion" severity ERROR;
                  end if;

               else
                  overflow4 <= '0';
               end if;

               if fi_data3 = ('0' & x"00000") and dval_sr(3) = '1' then
                  underflow4 <= '1';
                  if Verbose then
                     assert FALSE report "Positive underflow in floating point to fixed-point convertion" severity ERROR;
                  end if;

               elsif fi_data3 = ('1' & x"FFFFF") and dval_sr(3) = '1' then
                  underflow4 <= '1';
                  if Verbose then
                     assert FALSE report "Negative underflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
               else
                  underflow4 <= '0';
               end if;

            else
               if fi_data3(15 downto 0) = x"FFFF" and dval_sr(3) = '1' then
                  overflow4 <= '1';
                  if Verbose then
                     assert FALSE report "Overflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
               else
                  overflow4 <= '0';
               end if;

               if fi_data3(15 downto 0) = x"0000" and dval_sr(3) = '1' then
                  underflow4 <= '1';
                  if Verbose then
                     assert FALSE report "Underflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
               else
                  underflow4 <= '0';
               end if;
            end if;

            -- Stage 5
            if AVOID_ZERO = '1' and underflow4 = '1' and fi_data4(fi_data4'high) = '0' then
               fi_data_final(0) <= '1';
               fi_data_final(fi_data_final'high downto 1) <= (others=>'0');
            else
               fi_data_final <= fi_data4;
            end if;
            OVERFLOW <= overflow4;
            UNDERFLOW <= underflow4;

         end if;

         if ARESET = '1' then
            dval_sr(dval_sr'HIGH downto 1) <= (others => '0');
            OVERFLOW <= '0';
            UNDERFLOW <= '0';
         end if;

      end process;

   end block;
   -------------------------------------------------------


end RTL;
