---------------------------------------------------------------------------------------------------
--
-- Title       : fp32tofi21
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
---------------------------------------------------------------------------------------------------
--
-- Description : This LocalLink module converts a 32-bit floating point dataflow to a 21-bit block
--               floating point flow (aka fixed-point with explicit exponent). It is pipelined to
--               achieve 100 MHz in a V2Pro-5.
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.Telops.all; 

entity fp32tofi21 is
   generic(
      Support_Unsigned  : boolean := TRUE; -- If false, less logic because always signed.
      Support_16Bit     : boolean := TRUE; 
      Support_TDM       : boolean := TRUE  -- Support Time Division Multiplexed Flow
      );
   port(                                             
      EXTRA_EXPON : in  std_logic_vector(7 downto 0);
      EXPON1      : in  std_logic_vector(7 downto 0);
      EXPON2      : in  std_logic_vector(7 downto 0); -- 2nd exponent used for TDM flow
      
      SIGNED_FI   : in  std_logic;
      TDM_FLOW    : in  std_logic;
      FORCE_16BIT : in  std_logic;
      AVOID_ZERO  : in  std_logic;  -- Convert 0 value to +1 (to avoid possible divide by zero problems later on)
      
      RX_LL_MOSI  : in  t_ll_mosi32;
      RX_LL_MISO  : out t_ll_miso;
      
      TX_LL_MOSI  : out t_ll_mosi21;
      TX_LL_MISO  : in  t_ll_miso;   
      
      OVERFLOW    : out std_logic;
      UNDERFLOW   : out std_logic;
      
      ARESET      : in  STD_LOGIC;
      CLK         : in  STD_LOGIC		 		 		 
      );
end fp32tofi21;     

-- Declare these librairies only for the architecture
library IEEE;
use ieee.numeric_std.all;
library IEEE_proposed_2010;
use ieee_proposed_2010.fixed_float_types.all;
use IEEE_proposed_2010.fixed_pkg.all;
use IEEE_proposed_2010.float_pkg.all;
-- pragma translate_off
library Common_HDL;
use Common_HDL.sim_pkg.all;
-- pragma translate_on


architecture RTL of fp32tofi21 is    
   -- Registers
   signal hold_dval        : std_logic;
   signal exp_dval         : std_logic;
   signal exp_sel          : std_logic;
   signal exp_override     : std_logic;
   signal block_next_dval  : std_logic;
   signal Sel              : std_logic;
   signal tx_sof           : std_logic;
   
   -- Signals
   signal convert_ce    : std_logic;   
   signal fi_data_final : std_logic_vector(20 downto 0); -- This signal should be in convert_block but xst crashes if it is.                                                  
   signal fi_dval_final : std_logic; 
   signal EXPON1_out    : std_logic_vector(7 downto 0); 
   
   signal RESET         : std_logic;  
   signal RX_BUSYi      : std_logic;
   signal TDM_FLOWi     : std_logic; 
   signal SIGNED_FIi    : std_logic;
   signal FORCE_16BITi  : std_logic;
   
   -- Buffers
   signal RX_DVALi      : std_logic;
   signal TX_DVALi      : std_logic;
   
   -- Shift registers
   constant Latency     : integer := 5; -- Number of stage in the pipeline   
   signal EOF_sr        : std_logic_vector(Latency downto 0);        
   signal dval_sr       : std_logic_vector(Latency downto 0); 
   
   -- Debugging
   -- translate_off
   signal SB_Min        : unsigned(16 downto 0);
   signal SB_Max        : unsigned(16 downto 0);    
   -- translate_on     
   
begin                                  
   sync_RST : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, CLK => CLK);
   
   -- translate_off
   SB_Min <= resize(sim.SB_Min, 17) when TDM_FLOW = '0' else (resize((sim.SB_Min+1) & '0',17)-1);
   SB_Max <= resize(sim.SB_Max, 17) when TDM_FLOW = '0' else (resize((sim.SB_Max+1) & '0',17)-1);
   -- translate_on    
   
   -------------------------------------------------------
   -- Generics support
   -------------------------------------------------------
   gen_unsigned : if Support_Unsigned generate
      SIGNED_FIi <= SIGNED_FI;
   end generate gen_unsigned;
   gen_no_unsigned : if not Support_Unsigned generate
      SIGNED_FIi <= '1';
   end generate gen_no_unsigned;     
   
   gen_tdm : if Support_TDM generate
      TDM_FLOWi <= TDM_FLOW;
   end generate gen_tdm;
   gen_no_tdm : if not Support_TDM generate
      TDM_FLOWi <= '0';
   end generate gen_no_tdm;  
   
   gen_16bit : if Support_16Bit generate
      FORCE_16BITi <= FORCE_16BIT;
   end generate gen_16bit;
   gen_no_16bit : if not Support_16Bit generate
      FORCE_16BITi <= '0';
   end generate gen_no_16bit;
   
   -------------------------------------------------------
   -- LocalLink interface
   -------------------------------------------------------
   RX_DVALi <= RX_LL_MOSI.DVAL and not RX_BUSYi;
   dval_sr(0) <= RX_DVALi;
   RX_LL_MISO.BUSY <= RX_BUSYi;
   RX_BUSYi <= not convert_ce or (block_next_dval and RX_LL_MOSI.DVAL);
   RX_LL_MISO.AFULL <= RESET when block_next_dval = '1' else (TX_LL_MISO.AFULL or RESET);
   EOF_sr(0) <= RX_LL_MOSI.EOF;   
   
   convert_ce <= (not TX_LL_MISO.AFULL) and (not TX_LL_MISO.BUSY) and not RESET;
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1'; 
   TX_LL_MOSI.DVAL <= TX_DVALi;
   TX_DVALi <= exp_dval when exp_override='1' else (fi_dval_final or hold_dval);
   TX_LL_MOSI.DATA <= ((TX_LL_MOSI.DATA'high downto EXPON1_out'LENGTH => EXPON1_out(7)) & EXPON1_out) when (exp_override='1' and exp_sel='0') else
   ((TX_LL_MOSI.DATA'high downto EXPON2'LENGTH => EXPON2(7)) & EXPON2) when (exp_override='1' and exp_sel='1') else
   fi_data_final;    
   
   TX_LL_MOSI.SOF <= tx_sof;
   TX_LL_MOSI.EOF <= '0' when exp_override='1' else EOF_sr(Latency); 
   
   -------------------------------------------------------
   -- Flow control
   -------------------------------------------------------   
   flow_control : process(CLK, ARESET)
      variable exp_rx_exp_ready : std_logic; 
      variable wait_for_eof : std_logic;
      -- pragma translate_off
      variable cnt_in        : integer;
      variable cnt_out       : integer;    
      -- pragma translate_on      
   begin         
      
      -- Debug counters
      -- pragma translate_off
      if ARESET = '1' then
         cnt_in := 1; 
         cnt_out := 1;
      elsif rising_edge(CLK) then
         if RX_DVALi = '1' then
            cnt_in := cnt_in + 1;
         end if; 
         if TX_DVALi='1' and TX_LL_MISO.BUSY='0' then
            cnt_out := cnt_out + 1;
         end if;
      end if;         
      -- pragma translate_on 
      
      -- TDM support
      if ARESET = '1' then
         Sel <= '0';   
      elsif rising_edge(CLK) then
         if TDM_FLOWi = '0' then
            Sel <= '0';  
         elsif RX_DVALi = '1' then
            Sel <= not Sel;
         end if;
      end if;
      
      -- DVALID latch (when destination is not ready, all we have to do is hold the DVal signal, the data stays valid at the converter output)
      if ARESET = '1' then
         hold_dval <= '0';      
      elsif rising_edge(CLK) then                  
         hold_dval <= TX_LL_MISO.BUSY and TX_DVALi;           
      end if;               
      
      -- EOF shift register
      if rising_edge(CLK) then        
         if convert_ce = '1' then
            EOF_sr(Latency downto 1) <= EOF_sr(Latency-1 downto 0);
         end if;
      end if;        
      
      if ARESET = '0' then    
         -- pragma translate_off
         assert (RX_LL_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;                    
         -- pragma translate_on
      end if;      
      
      -- Exponent processsing (send with SOF)      
      if ARESET = '1' then
         block_next_dval <= '1';
         exp_dval <= '0'; 
         exp_rx_exp_ready := '0';
         wait_for_eof := '0';
         exp_override <= '0';
         exp_sel <= '0';
      elsif rising_edge(CLK) then 
         EXPON1_out <= std_logic_vector( signed(EXPON1) + signed(EXTRA_EXPON) );
         
         -- Detect incoming data, so we should send TX_SOF
         if RX_LL_MOSI.DVAL='1' and block_next_dval='1' and exp_rx_exp_ready='0' then
            exp_rx_exp_ready := '1';                               
            assert (RX_LL_MOSI.SOF='1') report "RX_LL_MOSI.SOF should be '1'." severity ERROR;
         end if;                    
         
         -- Must wait (because of latency) until TX_EOF is sent
         if TX_DVALi='1' and EOF_sr(Latency)='1' and TX_LL_MISO.BUSY='0' then
            wait_for_eof := '0';
         elsif fi_dval_final = '1' then
            wait_for_eof := '1';
         end if;                           
         
         -- Detect incoming EOF
         if RX_LL_MOSI.DVAL='1' and RX_BUSYi='0' and RX_LL_MOSI.EOF='1' then            
            block_next_dval <= '1';
         end if;                  
         
         -- Send TX_SOF
         if exp_rx_exp_ready = '1' and TX_LL_MISO.AFULL = '0' and wait_for_eof='0' and exp_sel='0' then
            exp_dval <= '1';
            exp_override <= '1';
            tx_sof <= '1';
         end if;                     
         if TX_LL_MISO.BUSY = '0' then
            if exp_dval = '1' then               
               if (exp_sel = '0' and TDM_FLOWi = '1') then
                  exp_sel <= '1';
                  tx_sof <= '0';
               elsif (exp_sel = '1' or TDM_FLOWi = '0') then   
                  exp_dval <= '0'; 
                  exp_sel <= '0';
                  exp_override <= '0';
                  tx_sof <= '0';
                  exp_rx_exp_ready := '0';
                  block_next_dval <= '0';               
               end if; 
            end if;
         end if;      
         
      end if;
   end process;   
   
   -------------------------------------------------------
   -- Perform actual conversion
   -------------------------------------------------------
   convert_block : block
      -- Stage 1 
      signal Sel1          : std_logic;
      signal sign1         : std_logic;                                    
      signal exp1          : signed(float_exponent_width-1 downto 0);
      signal fract1        : std_logic_vector(float_fraction_width-1 downto 0);      
      
      -- Stage 2     
      signal sign2         : std_logic;                          
      signal exp2          : signed(float_exponent_width-1 downto 0);
      signal fract2        : std_logic_vector(float_fraction_width-1 downto 0);   
      
      -- Stage 3
      signal fi_data3      : std_logic_vector(20 downto 0);   
      
      -- Stage 4                                           
      signal fi_data4      : std_logic_vector(20 downto 0);   
      signal overflow4     : std_logic;
      signal underflow4    : std_logic;                       
      
      -- Misc
      signal ce_reg        : std_logic;
      
      -- pragma translate_off
      signal float_in_real : real;
      signal permit_data_dval : std_logic_vector(3 downto 1) := "000";
      -- pragma translate_on
      
      begin
      
      -- This signal will only pulse once per data valid, even if ce is held low.     
      fi_dval_final <= dval_sr(Latency) and ce_reg;         
      
      convert_proc : process(CLK, ARESET)
         variable fp_data2      : float32;
         -- pragma translate_off
         variable fp_data2_real  : real;   
         variable valData_cnt : std_logic_vector(16 downto 0) := (others => '0');
         -- pragma translate_on         
      begin
         if rising_edge(CLK) then
            ce_reg <= convert_ce;
         end if;
         
         if rising_edge(CLK) and convert_ce = '1' then
            -- Dval shift register
            dval_sr(Latency downto 1) <= dval_sr(Latency-1 downto 0);
            
            -- Stage 1, register input data
            Sel1 <= Sel;
            sign1 <= RX_LL_MOSI.DATA(RX_LL_MOSI.DATA'high);
            exp1 <= signed(RX_LL_MOSI.DATA(RX_LL_MOSI.DATA'high-1 downto RX_LL_MOSI.DATA'high-float_exponent_width));
            fract1 <= RX_LL_MOSI.DATA(float_fraction_width-1 downto 0); 
            -- pragma translate_off      
            float_in_real <= to_real(to_float(RX_LL_MOSI.DATA));              
            -- pragma translate_on            
            
            -- Stage 2, add exponent 
            if Sel1 = '0' then
               exp2 <= exp1 - signed(EXPON1);
            else   
               exp2 <= exp1 - signed(EXPON2);
            end if;
            sign2 <= sign1;
            fract2 <= fract1;
            fp_data2 := to_float(sign2 & std_logic_vector(exp2) & fract2); 
            -- pragma translate_off            
            fp_data2_real := to_real(fp_data2);          
            -- pragma translate_on                                                
            
            -- Stage 3, convert floating-point number into fixed-point (expensive)
            if SIGNED_FIi = '1' then
               fi_data3 <= std_logic_vector( to_signed (
               arg         => fp_data2,       
               size        => fi_data3'LENGTH,     
               check_error => float_check_error, 
               round_style => round_zero));  -- was float_round_style                                       
               
            elsif SIGNED_FIi = '0' then
               if FORCE_16BITi = '0' then
                  --assert false report "Unsigned 21-bit not supported!" severity FAILURE;
                  fi_data3 <= std_logic_vector( to_unsigned (
                  arg         => fp_data2,       
                  size        => fi_data3'LENGTH,  
                  check_error => float_check_error, 
                  round_style => round_zero));  -- was float_round_style
               elsif FORCE_16BITi = '1' then                                                    
                  fi_data3(15 downto 0) <= std_logic_vector( to_unsigned (
                  arg         => fp_data2,       
                  size        => 16,     
                  check_error => float_check_error, 
                  round_style => round_zero));  -- was float_round_style 
                  fi_data3(20 downto 16) <= (others => '0');                                
                                    
               end if;
            end if;   
            
            -- pragma translate_off
            permit_data_dval(3 downto 2) <= permit_data_dval(2 downto 1);
            if RX_DVALi = '1' then
               if RX_LL_MOSI.SOF = '1' then
                  valData_cnt := (others => '0');
                  permit_data_dval(1) <= '0';
               else
                  valData_cnt := std_logic_vector(unsigned(valData_cnt) + 1);
               end if;
               
               if unsigned(valData_cnt) = SB_Min then
                  permit_data_dval(1) <= '1';
               end if;
               
               if unsigned(valData_cnt) = SB_Max or RX_LL_MOSI.EOF = '1' then
                  permit_data_dval(1) <= '0';
               end if;
            end if;
            -- pragma translate_on
            
            -- Stage 4, detect overflow and underflow
            fi_data4 <= fi_data3;
            if SIGNED_FIi = '1' then               
               if fi_data3 = ('0' & x"FFFFF") and dval_sr(3) = '1' then
                  overflow4 <= '1';  
                  -- pragma translate_off
                  if permit_data_dval(3) = '1' then
                     assert FALSE report "Positive overflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
                  -- pragma translate_on
               elsif fi_data3 = ('1' & x"00000") and dval_sr(3) = '1' then
                  overflow4 <= '1';  
                  -- pragma translate_off
                  if permit_data_dval(3) = '1' then
                     assert FALSE report "Negative overflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
                  -- pragma translate_on
               else
                  overflow4 <= '0';
               end if;      
               
               if fi_data3 = ('0' & x"00000") and dval_sr(3) = '1' then
                  underflow4 <= '1';  
                  -- pragma translate_off
                  if permit_data_dval(3) = '1' then
                     --assert FALSE report "Positive underflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
                  -- pragma translate_on
               elsif fi_data3 = ('1' & x"FFFFF") and dval_sr(3) = '1' then
                  underflow4 <= '1';  
                  -- pragma translate_off
                  if permit_data_dval(3) = '1' then
                     --assert FALSE report "Negative underflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
                  -- pragma translate_on
               else
                  underflow4 <= '0';
               end if;                          
               
            elsif SIGNED_FIi = '0' then                                                                        
               if fi_data3(15 downto 0) = x"FFFF" and dval_sr(3) = '1' then
                  overflow4 <= '1';  
                  -- pragma translate_off
                  if permit_data_dval(3) = '1' then
                     assert FALSE report "Overflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
                  -- pragma translate_on
               else
                  overflow4 <= '0';
               end if;                    
               
               if fi_data3(15 downto 0) = x"0000" and dval_sr(3) = '1' then
                  underflow4 <= '1';  
                  -- pragma translate_off
                  if (permit_data_dval(3) = '1' and TDM_FLOW = '1') then -- No underflow warnings when the output is a calibrated spectra.
                     assert FALSE report "Underflow in floating point to fixed-point convertion" severity ERROR;
                  end if;
                  -- pragma translate_on
               else
                  underflow4 <= '0';
               end if;                                    
            end if;              
                                    
            -- Stage 5        
            if AVOID_ZERO = '1' and underflow4 = '1' and fi_data4(20) = '0' then
               fi_data_final <= x"00000" & '1';
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
