-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : 
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : 
-- Generated   : Mon Dec 20 13:46:24 2010
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all; 
use work.fpa_common_pkg.all;

entity concat_1_to_8 is
   generic(
      INPUT_1st_BIT_IS_MSB : boolean:= true 
      );
   port (
      ARESET  : in std_logic;
      CLK     : in std_logic;
      RX_MOSI : in t_ll_ext_mosi1; 
      RX_MISO : out t_ll_ext_miso;
      TX_MOSI : out t_ll_ext_mosi8;
      TX_MISO : in t_ll_ext_miso;   
      ERR     : out std_logic
      );
end concat_1_to_8; 

architecture RTL of concat_1_to_8 is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;  
   
   signal temp_mosi           : t_ll_ext_mosi8; 
   signal tx_mosi_i           : t_ll_ext_mosi8;
   signal sreset              : std_logic;
   signal err_i               : std_logic;
   signal dval_reg            : std_logic_vector(7 downto 0); 
   signal data_reg            : std_logic_vector(7 downto 0);
   signal sof_reg             : std_logic_vector(7 downto 0);
   signal eof_reg             : std_logic_vector(7 downto 0); 
   signal downtream_busy      : std_logic; 
   signal dreg_7_last         : std_logic;
   
begin  
   
   --------------------------------------------------
   -- map
   -------------------------------------------------- 
   TX_MOSI <= tx_mosi_i;
   RX_MISO <= TX_MISO; 
   ERR <= err_i;
   
   downtream_busy <= TX_MISO.BUSY;
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1 : sync_reset
   port map(ARESET => ARESET, CLK => CLK, SRESET => sreset); 	
   
   
   --------------------------------------------------
   -- ctrl
   --------------------------------------------------  
   U2: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            dval_reg <= "00000001";    -- registre à propagation du '1'
            dreg_7_last <= dval_reg(7);
            temp_mosi.dval <= '0'; 
            temp_mosi.sof <= '0';  
            temp_mosi.eof <= '0'; 
            temp_mosi.support_busy <= '1';
            err_i <= '0';
         else
            
            -- erreur si SOF ou EOF rentre alors qu'on n'a moins de 8 données
            err_i <= (not dval_reg(0) and RX_MOSI.SOF and RX_MOSI.DVAL) or (not dval_reg(7) and RX_MOSI.EOF and RX_MOSI.DVAL);
            
            -- generation
            if downtream_busy = '0' then 
               if RX_MOSI.DVAL = '1' then              
                  -- donnée
                  data_reg(0) <= RX_MOSI.DATA;
                  data_reg(7 downto 1) <= data_reg(6 downto 0);
                  
                  -- sof
                  sof_reg(0) <= RX_MOSI.SOF;
                  sof_reg(7 downto 1) <= sof_reg(6 downto 0); 
                  
                  
                  -- eof
                  eof_reg(0) <= RX_MOSI.EOF;
                  eof_reg(7 downto 1) <= eof_reg(6 downto 0); 
                  
                  
                  -- registre à propagation 
                  dval_reg(0) <= dval_reg(7); -- 
                  dval_reg(7 downto 1) <= dval_reg(6 downto 0);
               else
                  temp_mosi.dval <= '0';                  
               end if; 
               
               -- generation de la sortie
               dreg_7_last <= dval_reg(7); 
               temp_mosi.data <= data_reg; 
               temp_mosi.sof <= sof_reg(7); 
               temp_mosi.eof <= eof_reg(0);
               temp_mosi.dval <= dreg_7_last and dval_reg(0);
               
            end if;
         end if;
      end if;      
   end process;    
   
   --------------------------------------------------
   -- mapping des données selon INPUT_1st_BIT_IS_LSB
   --------------------------------------------------  
   U3: process(CLK)
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            tx_mosi_i.dval <=  '0';
            tx_mosi_i.support_busy <= '1';
         else
            
            if downtream_busy = '0' then 
               tx_mosi_i.sof  <=  temp_mosi.sof;
               tx_mosi_i.eof  <=  temp_mosi.eof;
               tx_mosi_i.dval <=  temp_mosi.dval;
               tx_mosi_i.support_busy <=  temp_mosi.support_busy;
               
               if INPUT_1st_BIT_IS_MSB then
                  tx_mosi_i.data <= temp_mosi.data;
               else
                  for i in 0 to 7 loop
                     tx_mosi_i.data(7 -i) <= temp_mosi.data(i);
                  end loop;
               end if;               
            end if;   
            
         end if;
      end if;      
   end process;  
   
end RTL;
