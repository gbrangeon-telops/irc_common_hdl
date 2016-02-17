-------------------------------------------------------------------------------
--
-- Title       : fixtofp32
-- Author      : PDU / KBE
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : xx-bit Fixed Point to 32-bit Floating Point conversion. The
--               fixed-point dataflow is assumed to be block floating-point with
--               an external input port for the exponent.
--               THIS CODE SHOULD NOT BE COMPILED BY XST WITHOUT POST-SYNTHESIS
--               SIMULATION, IT DOESN'T SUPPORT VHDL-2008 well.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;   
use ieee.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity fixtofp32 is
   generic(
      signed_fi   : boolean := FALSE;
      DLEN        : natural := 12 -- valid data length on the 32-bit data input
      );
   port(
      RX_MOSI    : in  T_LL_MOSI32;
      TX_MISO    : in  T_LL_MISO;
      RX_MISO    : out T_LL_MISO;
      TX_MOSI    : out T_LL_MOSI32;

      RX_EXP     : in signed(7 downto 0);
      ARESET     : in  std_logic;
      CLK        : in  std_logic
      );
end fixtofp32;

-- Declare these librairies only for the architecture
library IEEE;
use ieee.numeric_std.all;
library IEEE_proposed_2010;
use IEEE_proposed_2010.fixed_pkg.all;
use IEEE_proposed_2010.float_pkg.all;

architecture RTL of fixtofp32 is

   -- Signals
   signal convert_ce    : std_logic;
   signal RX_DVALi      : std_logic;

   -- Registers
   signal fp_data4_slv  : std_logic_vector(31 downto 0);
   --signal fp_dval3      : std_logic;
   signal fp_dval4      : std_logic;
   signal hold_dval     : std_logic;

   -- Buffers/Alias
   signal TX_DVALi      : std_logic;
   signal RX_BUSYi      : std_logic;

   -- Shift registers
   constant Latency     : integer := 4;
   signal SOF_sr        : std_logic_vector(Latency downto 0);
   signal EOF_sr        : std_logic_vector(Latency downto 0);

   -- translate_off
   signal fp_data4_debug : real;
   signal fp_data2_debug : real;
   -- translate_on

   signal In_fix_data : std_logic_vector(DLEN-1 downto 0);

   signal rx_exp_in    : signed(float_exponent_width-1 downto 0);
   
   signal sreset : std_logic;
   signal temp : std_logic;

begin

   In_fix_data <= RX_MOSI.DATA(DLEN-1 downto 0);
   rx_exp_in   <= RX_EXP;

   process(CLK, ARESET)
   begin
      if ARESET = '1' then
         sreset <= '1'; 
         temp <= '1'; 
      elsif rising_edge(CLK) then
         temp <= ARESET;
         sreset <= temp;
      end if;
   end process;   

   -------------------------------------------------------
   -- LocalLink interface
   -------------------------------------------------------
   RX_MISO.BUSY <= RX_BUSYi;
   RX_BUSYi <= not convert_ce or sreset;
   RX_MISO.AFULL <= TX_MISO.AFULL;
   SOF_sr(0) <= RX_MOSI.SOF;
   EOF_sr(0) <= RX_MOSI.EOF;


   RX_DVALi <= RX_MOSI.DVAL and not RX_BUSYi;

   convert_ce <= (not TX_MISO.AFULL) and (not TX_MISO.BUSY);

   TX_MOSI.SUPPORT_BUSY <= '1';
   TX_MOSI.DVAL <= TX_DVALi;
   TX_DVALi <= fp_dval4 or hold_dval;
   TX_MOSI.DATA <= fp_data4_slv;
   TX_MOSI.SOF <= SOF_sr(Latency);
   TX_MOSI.EOF <= EOF_sr(Latency);
   TX_MOSI.DREM <= "11";

   flow_control : process(CLK, ARESET)
   begin

      -- DVALID latch (when destination is not ready, all we have to do is hold the DVal signal, the data stays valid at the converter output)
      if ARESET = '1' then
         hold_dval <= '0';
      elsif rising_edge(CLK) then
         hold_dval <= TX_MISO.BUSY and TX_DVALi;
      end if;

      -- SOF & EOF shift registers
      if rising_edge(CLK) then
         if convert_ce = '1' then
            SOF_sr(Latency downto 1) <= SOF_sr(Latency-1 downto 0);
            EOF_sr(Latency downto 1) <= EOF_sr(Latency-1 downto 0);
         end if;
      end if;
   end process;

   -------------------------------------------------------
   -- Assertion: Simmulation must support busy signal
   -------------------------------------------------------
   process(ARESET)
   begin
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
      signal fi_data1      : std_logic_vector(DLEN-1 downto 0);
      signal stage1_dval   : std_logic;
      -- Stage 2
      signal fp_data2      : float32;
      signal stage2_dval   : std_logic;
      -- Stage 3
      signal stage3_dval   : std_logic;
      signal exp3_full     : signed(float_exponent_width downto 0);
      signal fract3        : std_logic_vector(float_fraction_width-1 downto 0);
      signal sign3         : std_logic;
      -- Stage 4
      signal stage4_dval   : std_logic;      
      -- Misc
      signal ce_reg        : std_logic;

      begin

      -- This signal will only pulse once per data valid, even if ce is held low.
      --fp_dval3 <= stage3_dval and ce_reg;
      fp_dval4 <= stage4_dval and ce_reg;

      convert_proc : process(CLK, ARESET)
         variable fp_data2_slv  : std_logic_vector(31 downto 0);         
         variable exp2          : unsigned(float_exponent_width-1 downto 0);
         
         --variable exp3_full     : signed(float_exponent_width downto 0);
         variable exp4          : unsigned(float_exponent_width-1 downto 0);
      begin
         if rising_edge(CLK) then
            ce_reg <= convert_ce;
         end if;

         if rising_edge(CLK) and convert_ce = '1' then
            -- Stage 1, register input data
            fi_data1 <= In_fix_data;
            stage1_dval <= RX_DVALi;

            -- Stage 2, convert signed/unsigned to float (expensive)
            if signed_fi then
               fp_data2 <= to_float(signed(fi_data1));
            end if;
            if not signed_fi then
               fp_data2 <= to_float(unsigned(fi_data1));
            end if;
            stage2_dval <= stage1_dval;

            -- Stage 3, add exponent
            fp_data2_slv := to_slv(fp_data2);
            exp2 := unsigned(fp_data2_slv(fp_data2_slv'high-1 downto fp_data2_slv'high-float_exponent_width));
            sign3 <= fp_data2_slv(fp_data2_slv'high);            
            fract3 <= fp_data2_slv(float_fraction_width-1 downto 0);
            stage3_dval <= stage2_dval;

            -- Make sure that there is no overflow. We saturate to 0 and 255.
            -- Adder_Sat will saturate to either -256 or +255 in 9-bit mode.
            -- The saturation to +255 is okay but we just need to add saturation to 0.
            exp3_full <= Adder_Sat(signed(resize(exp2, float_exponent_width+1)), rx_exp_in);
            
            -- Stage 4, handle saturation
            if exp3_full(float_exponent_width) = '1' then -- negative overflow, must saturate to 0
               exp4 := (others => '0');
            else
               exp4 := unsigned(exp3_full(float_exponent_width-1 downto 0));
            end if;

            fp_data4_slv <= sign3 & std_logic_vector(exp4) & fract3;                        
            stage4_dval <= stage3_dval;

         end if;

         if ARESET = '1' then
            stage1_dval <= '0';
            stage2_dval <= '0';
            stage3_dval <= '0';
            stage4_dval <= '0';
         end if;

      end process;

      -- translate_off
      fp_data4_debug  <= to_real(to_float(fp_data4_slv));
      fp_data2_debug  <= to_real(to_float(to_slv(fp_data2)));
      -- translate_on
   end block;
   -------------------------------------------------------

end RTL;
