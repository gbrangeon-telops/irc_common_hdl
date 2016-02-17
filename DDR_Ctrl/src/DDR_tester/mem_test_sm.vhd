library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity mem_test_sm is 
   port (
      CLK: in std_logic;
      -- user interface
      CORE_INITDONE: in std_logic;
      RD_DVAL : in std_logic;
      DDRT_TRIG : in std_logic;
      DDRT_STAT : out std_logic_vector (1 downto 0);
      WR_EN : out std_logic;
      WR_AFULL : in std_logic;
      RD_ADD_EN : out std_logic;
      RD_DATA_EN : out std_logic;
      RD_AFULL : in std_logic;
      -- control signals
      DAT_EQ : in std_logic;
      DAT_PEND : in std_logic;
      LST_ADR : in std_logic;
      DAT_INV : out std_logic;
      NXT_ADR : out std_logic;
      NXT_DAT : out std_logic;
      RST_GEN : out std_logic);
   
end mem_test_sm;

architecture rtl of mem_test_sm is
   
   
   constant DDR_NOTEST: std_logic_vector (1 downto 0) := "00";
   constant DDR_PASS: std_logic_vector (1 downto 0) := "01";
   constant DDR_FAIL: std_logic_vector (1 downto 0) := "11";
   
   signal dat_inv_i: std_logic;
   type ddr_test_sm_t is (IDLE, WRITE, READ, RD_END);
   signal ddr_test_sm: ddr_test_sm_t;
   
begin
   
   DAT_INV <= dat_inv_i;
   
   -- state machine
   sm_proc: process (CLK)
   begin
      if CLK'event and CLK = '1' then
         
         if (CORE_INITDONE /= '1') then
            dat_inv_i <= '0';
            ddr_test_sm <= IDLE;
            DDRT_STAT <= DDR_NOTEST;
            RST_GEN <= '1';
            
         else
            
            case ddr_test_sm is
               
               when IDLE =>
                  dat_inv_i  <= '0';
                  RST_GEN   <= '1';
                  DDRT_STAT <= DDR_NOTEST;
                  
                  if DDRT_TRIG = '1' then
                     RST_GEN <= '0';
                     ddr_test_sm <= WRITE;
                  end if;
                  
               when WRITE =>
                  
                  if (WR_AFULL = '0' and LST_ADR = '1') then
                     RST_GEN <= '1';
                     ddr_test_sm <= READ;
                  end if;
                  
                  
               when READ =>
                  RST_GEN <= '0';
                  
                  if (RD_DVAL = '1') then
                     if (DAT_EQ = '0') then	
                        DDRT_STAT <= DDR_FAIL;
                        RST_GEN <= '1';
                        ddr_test_sm <= IDLE;
                     elsif (LST_ADR = '1') then
                        ddr_test_sm <= RD_END;
                     end if;
                  end if;
                  
               when RD_END =>
                  if (DAT_PEND = '0') and (dat_inv_i = '0') then
                     RST_GEN   <= '1';
                     ddr_test_sm <= WRITE;
                     dat_inv_i <= '1';
                  elsif DAT_PEND = '0' then
                     RST_GEN   <= '1';
                     DDRT_STAT <= DDR_PASS;
                     ddr_test_sm <= IDLE;
                  elsif DAT_EQ = '0' then	
                     RST_GEN   <= '1';
                     DDRT_STAT <= DDR_FAIL;
                     ddr_test_sm <= IDLE;
                  end if;
                  
               when others =>
               -- trap state
               ddr_test_sm <= IDLE;
               
            end case;
         end if;
      end if;
   end process sm_proc;
   
   -- signal assignment statements for combinatorial outputs
   sm_comb: process (ddr_test_sm, WR_AFULL, RD_AFULL, RD_DVAL)
   begin
      case ddr_test_sm is
         
         when WRITE =>
            RD_DATA_EN <= '0';
            RD_ADD_EN <= '0';
            WR_EN <= not WR_AFULL;
            NXT_ADR <= not WR_AFULL;
            NXT_DAT <= not WR_AFULL;
            
         when READ =>
            RD_DATA_EN <= '1';
            RD_ADD_EN <= not RD_AFULL;
            WR_EN <= '0';
            NXT_ADR <= not RD_AFULL;
            NXT_DAT <= RD_DVAL;
            
         when RD_END =>
            RD_DATA_EN <= '1';
            RD_ADD_EN <= '0';
            WR_EN <= '0';
            NXT_ADR <= '0';
            NXT_DAT <= '0';
            
         when others =>
         RD_DATA_EN <= '0';
         RD_ADD_EN <= '0';
         WR_EN <= '0';
         NXT_ADR <= '0';
         NXT_DAT <= '0';
         
      end case;
   end process sm_comb;
   
   
end rtl;
