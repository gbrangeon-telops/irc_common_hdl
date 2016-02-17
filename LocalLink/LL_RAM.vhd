-------------------------------------------------------------------------------
--
-- Title       : LL_RAM
-- Author      : Patrick Dubois
-- Company     : Telops/COPL
--
-------------------------------------------------------------------------------
--
-- Description : LocalLink RAM. This module is very simular to a deep fifo 
--               but there are no simulataneous reads and writes. In addition,
--               one can read the fifo over and over again, the data is never
--               flushed, it is only overwritten by the RX interface. The 
--               maximum length is fixed but the run-time length is
--               adjusted automatically with SOF-EOF.       
--               The memory used is block ram.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity LL_RAM is
   generic(
      D_WIDTH   : integer := 18; -- Data width, maximum 21 (because of LocalLink interface)
      RAM_DEPTH : integer := 7  -- Ram depth in bits.
      );   
   port(
      RST_PTR  : in  std_logic;  -- Reset address pointer (for both RX and TX interface)
      LOAD     : in  std_logic;  -- When asserted, the RX interface accepts new data and TX is busy.
      
      RX_MOSI  : in  t_ll_mosi21; -- LocalLink input, must be enclosed with SOF-EOF.
      RX_MISO  : out t_ll_miso;            
      
      TX_MOSI  : out t_ll_mosi21;
      TX_MISO  : in  t_ll_miso;
      
      ARESET   : in  std_logic;
      CLK      : in  std_logic       
      );
end LL_RAM;


architecture RTL of LL_RAM is 

   -- Signals
   signal ram_we     : std_logic;   
   signal ram_add    : std_logic_vector(RAM_DEPTH-1 downto 0);
   signal ram_din    : std_logic_vector(D_WIDTH-1 downto 0);
   signal ram_dout   : std_logic_vector(D_WIDTH-1 downto 0); 
   signal ram_dval   : std_logic;
   
   -- Buffers
   signal RX_DVALi   : std_logic;
   signal TX_DVALi   : std_logic;
   signal RX_BUSYi   : std_logic;   
   
   -- Registers                  
   signal RESET      : std_logic;
   signal ram_en     : std_logic;
   signal ram_en_reg : std_logic;
   signal loading    : std_logic; 
   signal loading_reg: std_logic; 
   signal ram_we_reg : std_logic;  
   signal hold_dval  : std_logic;
   signal add_ptr    : unsigned(RAM_DEPTH-1 downto 0); 
   signal length_m1  : unsigned(RAM_DEPTH-1 downto 0); -- Length minus two   
   
begin 
   
   sync_rst : entity sync_reset
   port map(ARESET => ARESET, SRESET => RESET, clk => CLK); 
   
   bram : entity sp_ram
   generic map(
      D_WIDTH => D_WIDTH,
      A_WIDTH => RAM_DEPTH
      )
   port map(
      clk => CLK,
      en => ram_en,
      we => ram_we,
      add => ram_add,
      din => ram_din,
      dout => ram_dout
      );  
   
   ram_add <= (others => '0') when (RX_DVALi='1' and RX_MOSI.SOF='1') else std_logic_vector(add_ptr);
   ram_din <= RX_MOSI.DATA(D_WIDTH-1 downto 0); 
   --TX_MOSI.DATA <= (20 downto D_WIDTH => ram_dout(ram_dout'HIGH)) & ram_dout; -- Only valid if data is signed
   TX_MOSI.DATA <= (20 downto D_WIDTH => '0') & ram_dout;
   TX_MOSI.DVAL <= TX_DVALi;
   TX_DVALi <= ram_dval or hold_dval;
   TX_MOSI.SUPPORT_BUSY <= '1';
   
   RX_DVALi <= RX_MOSI.DVAL and not RX_BUSYi;
   RX_MISO.BUSY <= RX_BUSYi;
   RX_MISO.AFULL <= '0';
   ram_we <= RX_DVALi;  
   ram_dval <= not ram_we_reg and not loading and not loading_reg and not LOAD and ram_en_reg;
   
   dval_proc : process(CLK, ARESET)
   begin          
      -- DVALID latch (when destination is not ready, all we have to do is hold the DVal signal
      if ARESET = '1' then
         hold_dval <= '0';      
      elsif rising_edge(CLK) then                  
         hold_dval <= TX_MISO.BUSY and TX_DVALi;           
      end if;      
   end process;
   
   ram_en <= '1' when loading = '1' else not TX_MISO.BUSY;-- and not TX_MISO.AFULL;
   
   ctrl : process(CLK)
   begin
      if rising_edge(CLK) then
         if RESET = '1' then
            add_ptr <= (others => '0');
            loading <= '0';
            loading_reg <= '0';
            TX_MOSI.EOF <= '0';
         else
            loading <= LOAD;
            loading_reg <= loading;
            RX_BUSYi <= not LOAD; 
            ram_we_reg <= ram_we; 
            ram_en_reg <= ram_en;
            
            -- Loading control
            if RX_DVALi = '1' then              
               if RX_MOSI.SOF = '1' then
                  add_ptr <= to_unsigned(1, add_ptr'LENGTH);  
               else
                  add_ptr <= add_ptr + 1;
               end if;                  
               if RX_MOSI.EOF = '1' then
                  length_m1 <= add_ptr;
               end if;
            end if;
            
            if RST_PTR = '1' or (loading='1' and LOAD='0') then  -- First LOAD 1 to 0 transition
               add_ptr <= (others => '0');
            end if;
            
            if loading = '0' and LOAD = '0' and TX_MISO.BUSY = '0' then -- If busy is 0, 
               if add_ptr = length_m1 then
                  add_ptr <= (others => '0');
                  TX_MOSI.EOF <= '1';
               else
                  add_ptr <= add_ptr + 1;
                  TX_MOSI.EOF <= '0';
               end if;     
               if add_ptr = 0 then
                  TX_MOSI.SOF <= '1';  
               else
                  TX_MOSI.SOF <= '0';
               end if;
            end if;            
         end if;
      end if;
   end process;
   
   
end RTL;
