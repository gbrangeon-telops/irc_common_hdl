---------------------------------------------------------------------------------------------------
--
-- Title       : uc2_wb_master
-- Design      : uc2
-- Author      : Patrick Dubois
-- Company     : Telops
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;  
library Common_HDL;
use Common_HDL.all;
use Common_HDL.Telops.all;

entity uc2_wb_master is
   port(                                
      -- WISHBONE Signals  
      WB_MOSI : out t_wb_mosi;
      WB_MISO : in  t_wb_miso;
      
      CLK:  in  std_logic;

      ARESET:  in  std_logic;

      UC2_IN   : out STD_LOGIC_VECTOR(31 downto 0);
      UC2_OUT  : in  std_logic_vector(31 downto 0)
      );
end uc2_wb_master;

architecture RTL of uc2_wb_master is
   alias ACK_I : std_logic is WB_MISO.ACK;
   alias DAT_I : std_logic_vector(WB_MISO.DAT'LENGTH-1 downto 0) is WB_MISO.DAT;
   alias ADR_O : std_logic_vector(WB_MOSI.ADR'LENGTH-1 downto 0) is WB_MOSI.ADR;
   alias CYC_O : std_logic is WB_MOSI.CYC;
   alias DAT_O : std_logic_vector(WB_MOSI.DAT'LENGTH-1 downto 0) is WB_MOSI.DAT;
   alias STB_O : std_logic is WB_MOSI.STB;
   alias WE_O  : std_logic is WB_MOSI.WE;
   
   
   alias uc2_we_o  : std_logic is UC2_OUT(28);
   alias uc2_cyc_o : std_logic is UC2_OUT(29);
   alias uc2_ack_o : std_logic is UC2_OUT(30);
   alias uc2_val_o : std_logic is UC2_OUT(31);
   
   signal uc2_ack_i : std_logic; -- uc2 command executed (if Read, then valid data is present on UC2_IN)
   signal DAT_I_reg : std_logic_vector(15 downto 0);
   signal CYC_O_buf : std_logic;
   
   type t_state is (Idle, Write, Read, WaitUC2Ack);
   signal state: t_state;    
   
   attribute keep : string;
   attribute keep of uc2_ack_i : signal is "true"; 
   attribute keep of DAT_I_reg : signal is "true";
   
   signal RST_I : std_logic;
   
begin   
   sync_RESET_inst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RST_I, CLK => CLK);        
   ------------------------------------------------------
   -- UC2 pin assignments  
   --------
   -- UC2_OUT(15 downto 0) : DAT_O
   -- UC2_OUT(27 downto 16) : ADR_O
   -- UC2_OUT(28) : uc2_we_o
   -- UC2_OUT(29) : uc2_cyc_o (bus cycle request)
   -- UC2_OUT(30) : uc2_ack_o (bus read acknowledge)
   -- UC2_OUT(31) : uc2_val_o (data valid on UC2_OUT)
   --------
   -- UC2_IN(15 downto 0) : DAT_I
   -- UC2_IN(16) : uc2_val_i (data valid on UC2_IN)
   ------------------------------------------------------
   
   UC2_IN <= X"000" & "000" & uc2_ack_i & DAT_I_reg;
   
   STB_O <= CYC_O_buf;         
   CYC_O <= CYC_O_buf;    
   
   
   wb_master_proc : process(CLK)
   begin
      if rising_edge(CLK) then    
         
         -- These signals must be registered for best timing performance...
         DAT_O <= UC2_OUT(15 downto 0);
         ADR_O <= UC2_OUT(27 downto 16); 
         --         STB_O <= CYC_O_buf;         
         --         CYC_O <= CYC_O_buf;   
         
         if RST_I = '1' then
            CYC_O_buf <= '0';            
            state <= Idle;   
            DAT_I_reg <= (others => '0');
            uc2_ack_i <= '0';
         else  
            
            case state is     
               
               --------------------------------
               -- Idle State
               --------------------------------
               when Idle =>  
                  DAT_I_reg <= (others => '0');
                  CYC_O_buf <= '0';
                  uc2_ack_i <= '0';
                  if uc2_val_o = '1' and uc2_cyc_o = '1' then
                     if uc2_we_o = '1' then
                        state <= Write;
                     else              
                        state <= Read;
                     end if;
                  end if;
                  
               when Write =>
                  CYC_O_buf <= '1';
                  WE_O <= '1';
                  if ACK_I = '1' then
                     CYC_O_buf <= '0';
                     uc2_ack_i <= '1';                     
                     state <= WaitUC2Ack;                    
                  end if;    
                  
               when WaitUC2Ack =>
                  if uc2_val_o = '1' and uc2_ack_o = '1' and uc2_cyc_o = '0' then
                     uc2_ack_i <= '0';
                     state <= Idle;
                  end if;
                  
               when Read =>
                  CYC_O_buf <= '1';
                  WE_O <= '0';                  
                  if ACK_I = '1' then
                     CYC_O_buf <= '0';
                     uc2_ack_i <= '1'; 
                     DAT_I_reg <= DAT_I;
                     state <= WaitUC2Ack;                    
                  end if;               
                  
               when others =>
               state <= Idle;
               
               
            end case;
            
         end if;
      end if;
      
   end process;
   
   
   
end RTL;
