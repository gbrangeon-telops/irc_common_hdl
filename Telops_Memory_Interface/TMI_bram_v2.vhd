-------------------------------------------------------------------------------
--
-- Title       : tmi_bram_v2
-- Author      : Patrick Daraiche
-- Company     : Telops
--
-------------------------------------------------------------------------------
--
-- Description : Single-Port RAM with Synchronous Read (Read Through), directly
--               mapped onto block-ram. Heavily inspired by the XST user guide.
--               
--             Diff with v1:
--             RAM is a variable and can be modified during simulation.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;
use IEEE.math_real.all;
library UNISIM;             
use UNISIM.VCOMPONENTS.ALL;
library common_hdl;
use common_hdl.Telops.all;

entity tmi_bram_v2 is
   generic(
      C_TMI_DLEN : integer := 32;	 -- Data length	
      C_TMI_ALEN : integer := 8;	 -- Adress length
      C_READ_LATENCY : integer := 1; -- Read Latency: between 1 and 16      
      C_BUSY_GENERATE : boolean := false;	-- Generate Pseudo-random TMI_BUSY signal  
      C_RANDOM_SEED : std_logic_vector(3 downto 0) := x"1"; -- --Pseudo-random generator seed
      C_BUSY_DURATION : integer := 20; -- Duration of TMI_BUSY signal in clock cycles
      C_INIT_FILE : string := "one");  
   port (      
      
      TMI_IDLE                      : out  std_logic;
      TMI_ERROR                     : out  std_logic;
      TMI_RNW                       : in std_logic;
      TMI_ADD                       : in std_logic_vector(C_TMI_ALEN-1 downto 0);
      TMI_DVAL                      : in std_logic;
      TMI_BUSY                      : out  std_logic;
      TMI_RD_DATA                   : out  std_logic_vector(C_TMI_DLEN-1 downto 0);
      TMI_RD_DVAL                   : out  std_logic;
      TMI_WR_DATA                   : in std_logic_vector(C_TMI_DLEN-1 downto 0);
      TMI_CLK                       : in  std_logic;
      ARESET						: in std_logic
      );
   
   
end tmi_bram_v2;     

architecture bram of tmi_bram_v2 is
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component shift_reg
      generic(
         DLEN : NATURAL := 32;
         SR_LENGTH : NATURAL := 16);
      port(
         CLK : in STD_LOGIC;
         INPUT : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
         OUTPUT : out STD_LOGIC_VECTOR(DLEN-1 downto 0));
   end component;
   
   
   type ram_type is array (0 to (2**C_TMI_ALEN)-1) of std_logic_vector(C_TMI_DLEN-1 downto 0);
   
   impure function InitRamFromFile (RamFileName : in string) return ram_type is
      FILE RamFile : TEXT open READ_MODE is RamFileName;
      variable String_line : line;
      variable RAM : ram_type;
      -- Seed values for random generator 
      variable seed1, seed2: positive; 
      -- Random real-number value in range 0 to 1.0 
      variable rand:  real; 
      -- Random integer value in range 0..65535 
      variable int_rand: integer; 
   begin
      
      -- synthesis off
      if RamFileName = "zero" then
         RAM := (others => (others => '0'));
      elsif RamFileName = "one" then
      -- synthesis on
         RAM := (others => (others => '1'));
      -- synthesis off
      elsif RamFileName = "random" then
         for I in ram_type'range loop
            UNIFORM(seed1, seed2, rand); 
            int_rand := INTEGER(TRUNC(rand * real(2**C_TMI_DLEN))); 
            RAM(I) := std_logic_vector(to_unsigned(int_rand, C_TMI_DLEN));
         end loop;
      else
         for I in ram_type'range loop
            if not endfile(RamFile) then
               readline(RamFile, String_line);
               read(String_line, RAM(I));
            else
               RAM(I) := (others => '0');
            end if;
         end loop;
      end if;
      -- synthesis on
      return RAM;
   end function;
   
   signal RAM : ram_type := InitRamFromFile(C_INIT_FILE);
   
   attribute ram_style: string;
   
   attribute ram_style of RAM: signal is "block";   
   
   signal read_a : unsigned(C_TMI_ALEN-1 downto 0);       
   signal mem_rd_ena    : std_logic;
   signal tmi_busy_s	: std_logic;   
   signal busy_cnt : unsigned(7 downto 0);
   signal bram_ena : std_logic;
   signal lfsr     : std_logic_vector(15 downto 0) := (others => '0');   -- To avoid X in simulation
   signal lfsr_in  : std_logic;
   signal tmi_rd_dval_s : std_logic_vector(0 downto 0);
   signal tmi_rd_dval_dly_s : std_logic_vector(0 downto 0);
   signal A : unsigned(3 downto 0);
   signal sreset : std_logic;
   signal tmi_idle_s : std_logic;
   signal RdLatCnt_s : unsigned(3 downto 0);   
   signal tmi_rd_data_s : std_logic_vector (C_TMI_DLEN-1 downto 0);  
   
begin
   
   sync_RESET_IN :   sync_reset port map(ARESET => ARESET, SRESET => sreset,  CLK => TMI_CLK);
   
   TMI_ERROR <= '0'; -- Alwyas 0 for now.		
   
   -----------------------------------------------
   -- BRAM memory
   -----------------------------------------------	
   -- Memory enable signal
   bram_ena <= TMI_DVAL and not(tmi_busy_s);
   
   -- Process to infer BRAM
   process (TMI_CLK)
   
   begin
      if rising_edge(TMI_CLK) then
         if bram_ena = '1' then
            if TMI_RNW = '0' then
               --   	            	RAM(to_integer(unsigned(TMI_ADD))) <= to_integer(unsigned(TMI_WR_DATA));
               RAM(to_integer(unsigned(TMI_ADD))) <= TMI_WR_DATA;
            end if;
            read_a <= unsigned(TMI_ADD);  
         end if;
         --mem_rd_ena <= bram_ena and TMI_RNW;
      end if;
   end process;
   tmi_rd_data_s <= RAM(to_integer(read_a)); 
   
   -- Process to handel read data valid (TMI_RD_DVAL) signal. 
   mem_rd_ena <= bram_ena and TMI_RNW;
   process (TMI_CLK)
   begin
      if rising_edge(TMI_CLK) then
         if sreset = '1' then
            tmi_rd_dval_s(0) <= '0';   				
         else
            tmi_rd_dval_s(0) <= mem_rd_ena;     				
         end if;
      end if;
   end process;
   
   ReadLatency_gen0: if (C_READ_LATENCY = 1  or C_READ_LATENCY < 1 or C_READ_LATENCY > 16) generate
      tmi_rd_dval_dly_s <= tmi_rd_dval_s;
      -- TMI_RD_DATA have already one clock delay
      TMI_RD_DATA <= tmi_rd_data_s;
   end generate ReadLatency_gen0; 
   
   ReadLatency_gen1: if (C_READ_LATENCY > 1 and C_READ_LATENCY < 17) generate
      
      -- Delay for RD_DVAL	
      ReadLat_sreg_dval : shift_reg
      generic map(
         DLEN => 1,
         SR_LENGTH => (C_READ_LATENCY-1)
         )
      port map(
         CLK => TMI_CLK,
         INPUT => tmi_rd_dval_s,
         OUTPUT => tmi_rd_dval_dly_s
         );
      
      -- Delay for RD_DATA
      ReadLat_sreg_data : shift_reg
      generic map(
         DLEN => C_TMI_DLEN,
         SR_LENGTH => (C_READ_LATENCY-1)
         )
      port map(
         CLK => TMI_CLK,
         INPUT => tmi_rd_data_s,
         OUTPUT => TMI_RD_DATA
         );		           
      
   end generate ReadLatency_gen1;   	
   
   TMI_RD_DVAL <= tmi_rd_dval_dly_s(0);
   
   BusyEmulate_gen0:if C_BUSY_GENERATE = false generate
      ------------------------------------------------
      -- Process to handel TMI_BUSY in the case it's
      -- not emulated/used 
      ------------------------------------------------   		
      process (TMI_CLK)
      begin
         if rising_edge(TMI_CLK) then
            if sreset = '1' then   					
               tmi_busy_s <= '1'; -- Busy at reset time					
            else   					   					
               tmi_busy_s <= '0'; -- Busy at reset time					
            end if;
         end if;
      end process;   				
      TMI_BUSY <= tmi_busy_s;   					
   end generate BusyEmulate_gen0;
   
   
   BusyEmulate_gen1:if C_BUSY_GENERATE= true generate    	
      ------------------------------------------------
      -- Process for pseudo-random generator
      ------------------------------------------------
      lfsr_in <= lfsr(1) xor lfsr(2) xor lfsr(4) xor lfsr(15);
      process(TMI_CLK)
      begin
         if rising_edge(TMI_CLK) then
            lfsr(0) <= lfsr_in;
            lfsr(15 downto 2) <= lfsr(14 downto 1);
            
            if sreset = '1' then
               lfsr(0) <= C_RANDOM_SEED(0); -- We need at least one '1' in the LFSR to activate it.
               lfsr(2) <= C_RANDOM_SEED(1);
               lfsr(3) <= C_RANDOM_SEED(2); 
               lfsr(5) <= C_RANDOM_SEED(3);
            else
               lfsr(1) <= lfsr(0);   
            end if;
         end if;
      end process;			
      
      ------------------------------------------------
      -- Process to emulate a memory BUSY (TMI_BUSY)
      -- signal.
      ------------------------------------------------
      process(TMI_CLK)
      begin
         if rising_edge(TMI_CLK) then
            if sreset = '1' then
               tmi_busy_s <= '1'; -- Busy at reset time					
               busy_cnt <= (others =>'0');
            else					
               -- Count the busy signal duration				
               if (tmi_busy_s = '1') then
                  busy_cnt <= busy_cnt + 1;
                  if busy_cnt = to_unsigned(C_BUSY_DURATION-1,8) then	-- Clear busy signal
                     busy_cnt <= (others =>'0');
                     tmi_busy_s <= '0';
                  end if;					
               elsif lfsr(7) = '1' then -- Randomly set busy signal						
                  tmi_busy_s <= '1';	
               end if;
            end if;
         end if;
      end process;
      TMI_BUSY <= tmi_busy_s;		
   end generate BusyEmulate_gen1; 				 	
   
   
   --------------------------------------------------
   -- Process to handel TMI_IDLE signal
   -- This signal is handled only durig Read command
   -- Write take only 1 clock cycle.	
   --------------------------------------------------	
   process(TMI_CLK)
   begin
      if rising_edge(TMI_CLK) then
         if sreset = '1' then
            tmi_idle_s <= '0';				
            RdLatCnt_s <= (others=>'0');				
         else
            
            -- Count the duration of TMI_IDLE signal
            if (tmi_idle_s = '0')then
               RdLatCnt_s <= RdLatCnt_s +1;
            end if;
            
            -- Maintain TMI_IDLE signale for the C_READ_LATENCY duration
            if (RdLatCnt_s = to_unsigned(C_READ_LATENCY-1, 4)) then
               RdLatCnt_s <= (others=>'0');			      
               tmi_idle_s <= '1';			     
            end if;   
            
            -- As soon as we have a valid transaction, clear TMI_IDLE signal
            if bram_ena = '1' then
               tmi_idle_s <= '0';			      
               RdLatCnt_s <= (others=>'0');			      
            end if;
            
         end if;
      end if;
   end process;
   TMI_IDLE <= tmi_idle_s;	
   
   
   
   
end bram;