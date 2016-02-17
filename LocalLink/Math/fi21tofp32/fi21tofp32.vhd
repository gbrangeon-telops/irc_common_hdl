-------------------------------------------------------------------------------
--
-- Title       : fi21tofp32
-- Author      : Patrick
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : 21-bit Fixed Point to 32-bit Floating Point conversion. The 21
--               bit dataflow is assumed to be block floating-point.
--               THIS CODE SHOULD NOT BE COMPILED BY XST, IT DOESN'T SUPPORT
--               VHDL-200x well.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;       
library Common_HDL;
use Common_HDL.Telops.all; 

entity fi21tofp32 is
   generic(    
      Support_TDM : boolean := TRUE;  -- Support Time Division Multiplexed Flow
      signed_fi   : boolean := TRUE
      );
   port(           
      RX_LL_MOSI  : in  t_ll_mosi21;
      RX_LL_MISO  : out t_ll_miso;   
      
      TX_LL_MOSI  : out t_ll_mosi32;
      TX_LL_MISO  : in  t_ll_miso;   
      
      TDM_FLOW    : in  std_logic;
      
      ARESET      : in STD_LOGIC;
      CLK         : in STD_LOGIC      
      );
end fi21tofp32;  

-- Declare these librairies only for the architecture
library IEEE;
use ieee.numeric_std.all;
library IEEE_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

architecture RTL of fi21tofp32 is
   
   -- Signals
   signal convert_ce    : std_logic; 
   signal TDM_FLOWi     : std_logic; 
   signal RX_DVALi      : std_logic;
   
   -- Registers
   signal sof           : std_logic;   
   signal fi1_expon     : signed(float_exponent_width-1 downto 0);
   signal fi2_expon     : signed(float_exponent_width-1 downto 0);
   signal fp_data3_slv  : std_logic_vector(31 downto 0);
   signal fp_dval3      : std_logic;
   signal hold_dval     : std_logic; 
   signal Sel           : std_logic;
   
   -- Buffers/Alias 
   signal TX_DVALi      : std_logic; 
   signal RX_BUSYi      : std_logic;
   
   -- Shift registers
   constant Latency     : integer := 3;    
   signal SOF_sr        : std_logic_vector(Latency downto 0);
   signal EOF_sr        : std_logic_vector(Latency downto 0);
   
   -- pragma translate_off
   signal fp_data3_debug : real;
   -- pragma translate_on
begin                
   -------------------------------------------------------
   -- Generics support
   -------------------------------------------------------       
   gen_tdm : if Support_TDM generate
      TDM_FLOWi <= TDM_FLOW;
   end generate gen_tdm;
   gen_no_tdm : if not Support_TDM generate
      TDM_FLOWi <= '0';
   end generate gen_no_tdm;  
   
   -------------------------------------------------------
   -- LocalLink interface
   -------------------------------------------------------   
   RX_LL_MISO.BUSY <= RX_BUSYi;
   RX_BUSYi <= not convert_ce or ARESET;
   RX_LL_MISO.AFULL <= TX_LL_MISO.AFULL;
   SOF_sr(0) <= sof;
   EOF_sr(0) <= RX_LL_MOSI.EOF; 
   
   RX_DVALi <= RX_LL_MOSI.DVAL and not RX_BUSYi;
   
   convert_ce <= (not TX_LL_MISO.AFULL) and (not TX_LL_MISO.BUSY); 
   
   TX_LL_MOSI.SUPPORT_BUSY <= '1';      
   TX_LL_MOSI.DVAL <= TX_DVALi;
   TX_DVALi <= fp_dval3 or hold_dval;
   TX_LL_MOSI.DATA <= fp_data3_slv;
   TX_LL_MOSI.SOF <= SOF_sr(Latency);
   TX_LL_MOSI.EOF <= EOF_sr(Latency);    
   
   flow_control : process(CLK, ARESET)      
   begin    
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
      
      -- SOF & EOF shift registers
      if rising_edge(CLK) then        
         if convert_ce = '1' then
            SOF_sr(Latency downto 1) <= SOF_sr(Latency-1 downto 0);
            EOF_sr(Latency downto 1) <= EOF_sr(Latency-1 downto 0);
         end if;
      end if;
   end process;
   
   -------------------------------------------------------
   -- Exponent extraction
   -------------------------------------------------------   
   expon_extract : process(CLK, ARESET)
   begin
      if rising_edge(CLK) then     
         --if RX_LL_MOSI.DVAL='1' and TX_LL_MISO.BUSY='0' then
         if RX_DVALi = '1' then
            if RX_LL_MOSI.SOF='1' then
               fi1_expon <= signed(RX_LL_MOSI.DATA(fi1_expon'HIGH downto 0)); 
               sof <= '1';            
            end if;     
            if sof = '1' then                                                 
               sof <= '0'; 
               if Sel='1' and Support_TDM and TDM_FLOWi='1' then                                                 
                  fi2_expon <= signed(RX_LL_MOSI.DATA(fi1_expon'HIGH downto 0)); 
               end if;
            end if;
         end if; 
      end if;   
      if ARESET = '1' then
         sof <= '0';   
      end if;
      if ARESET = '0' then    
         -- pragma translate_off
         assert (RX_LL_MOSI.SUPPORT_BUSY = '1') report "RX Upstream module must support the BUSY signal" severity FAILURE;                    
         -- pragma translate_on
      end if;      
   end process;
   
   -------------------------------------------------------
   -- Perform actual conversion
   -------------------------------------------------------
   convert_block : block
      -- Stage 1                      
      signal Sel1          : std_logic;
      signal fi_data1      : std_logic_vector(20 downto 0);   
      signal stage1_dval   : std_logic;
      -- Stage 2
      signal Sel2          : std_logic;
      signal fp_data2      : float32;      
      signal stage2_dval   : std_logic;
      -- Stage 3
      signal stage3_dval   : std_logic;
      -- Misc
      signal ce_reg        : std_logic;
      
      begin 
      
      -- This signal will only pulse once per data valid, even if ce is held low.
      fp_dval3 <= stage3_dval and ce_reg;   
      
      convert_proc : process(CLK, ARESET)
         variable fp_data2_slv  : std_logic_vector(31 downto 0);
         variable sign2         : std_logic;                                    
         variable exp2          : signed(float_exponent_width-1 downto 0);
         variable fract2        : std_logic_vector(float_fraction_width-1 downto 0);
         variable exp3          : signed(float_exponent_width-1 downto 0);
      begin 
         if rising_edge(CLK) then
            ce_reg <= convert_ce;
         end if;
         
         if rising_edge(CLK) and convert_ce = '1' then
            -- Stage 1, register input data 
            Sel1 <= Sel;
            fi_data1 <= RX_LL_MOSI.DATA;
            stage1_dval <= RX_DVALi and not RX_LL_MOSI.SOF and not (sof and TDM_Flowi); -- Do not propagate exponent
            
            -- Stage 2, convert signed/unsigned to float (expensive)
            Sel2 <= Sel1;
            if signed_fi then
               fp_data2 <= to_float(signed(fi_data1));   
            end if;            
            if not signed_fi then
               fp_data2 <= to_float(unsigned(fi_data1));
            end if; 
            stage2_dval <= stage1_dval;
            
            -- Stage 3, add exponent
            fp_data2_slv := to_slv(fp_data2);
            sign2 := fp_data2_slv(fp_data2_slv'high);
            exp2 := signed(fp_data2_slv(fp_data2_slv'high-1 downto fp_data2_slv'high-float_exponent_width));
            fract2 := fp_data2_slv(float_fraction_width-1 downto 0);
            if Sel2='0' or not Support_TDM or TDM_FLOWi='0' then
               exp3 := exp2 + fi1_expon;
            elsif Sel2='1' and Support_TDM and TDM_FLOWi='1' then
               exp3 := exp2 + fi2_expon;
            end if;
            
            fp_data3_slv <= sign2 & std_logic_vector(exp3) & fract2;
            stage3_dval <= stage2_dval;
            
         end if;
         
         if ARESET = '1' then  
            stage1_dval <= '0';
            stage2_dval <= '0';
            stage3_dval <= '0';
         end if;
         
      end process;
      
      -- pragma translate_off
      fp_data3_debug  <= to_real(to_float(fp_data3_slv));
      -- pragma translate_on 
   end block;
   -------------------------------------------------------
   
end RTL;
