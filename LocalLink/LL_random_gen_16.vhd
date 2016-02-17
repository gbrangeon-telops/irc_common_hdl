-------------------------------------------------------------------------------
--
-- Title       : LL_random_gen_16
-- Design      : FFT
-- Author      : ENO.
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : LL_random_gen_16.vhd
-- Generated   : Thu Jan 17 10:42:11 2008
-- From        : interface description file
-- By          : ENO
--
-------------------------------------------------------------------------------
--
-- Description :  
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {LL_random_gen_16} architecture {rtl}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
library common_HDL;
use common_HDL.Telops.all;
--use work.Image_Pkg.all; 
use common_HDL.LfsrStd_Pkg.all;

entity LL_random_gen_16 is 
   Generic( 
      datavector_length      : integer := 4096; -- taille du processus aleatoire
      rand_mean              : integer := 0;    -- moyenne du processus aleatoire
      rand_std_deviation     : integer := 10;   -- deviation standard du processus aleatoire
      rand_seed              : integer := 100   
      );
   port(
      CLK            : in std_logic;
      ARESET         : in std_logic;
      RUN            : in std_logic;
      TX_MISO        : in t_ll_miso;
      DATA_WIDTH_ERR : out std_logic;
      TX_MOSI        : out t_ll_mosi
      );
end LL_random_gen_16;

--}} End of automatically maintained section

architecture rtl of LL_random_gen_16 is
   
   --constant provenant de la loi uniforme
   constant Ymax                 : integer := maximum(integer(1.73*real(rand_std_deviation)) ,1);
   constant Ymin                 : integer := -Ymax;
   constant LFSR_dataWidth       : integer := log2(Ymax) + 1 ;
   constant DataWidth            : integer := log2(Ymax + rand_mean) + 2;  -- plus +1 pour avoir le nombre de bits total et +1 pour le bit de signe
   -- component
   component sync_reset is
      port(
         ARESET : in std_logic;
         SRESET : out std_logic := '1';
         CLK    : in std_logic
         );
   end component;
   -- signaux 
   type RandSend_SM_type is (idle,senddata);
   signal RandSend_SM : RandSend_SM_type;
   signal Sreset : std_logic;
   
   
   
begin
   --sync_reset Gen
   Sync_rst : sync_reset 
   port map (ARESET => ARESET , SRESET => Sreset, CLK => CLK);
   
   -- calcul
   U1: process(CLK)
   begin
      if rising_edge(CLK) then
         if Sreset ='1' then   
            DATA_WIDTH_ERR <= '0';
         else
            DATA_WIDTH_ERR <= BoolToStd(DataWidth >TX_MOSI.DATA'LENGTH );
         end if;      
      end if;
   end process;   
   
   U2: process(CLK) 
      variable data_count : integer range 0 to datavector_length;
      variable rand_data  : signed (LFSR_dataWidth-1 downto 0);
   begin 
      if rising_edge(CLK) then
         if Sreset ='1' then 
            RandSend_SM <= idle; 
            TX_MOSI.SUPPORT_BUSY <= '1';
            TX_MOSI.DVAL <= '0';           
         else 
            if  TX_MISO.BUSY='0' then 
               case RandSend_SM is 
                  when idle => 
                     TX_MOSI.SOF  <= '0';
                     TX_MOSI.DVAL <= '0';
                     TX_MOSI.EOF  <= '0';
                     rand_data  := to_signed(rand_seed,LFSR_dataWidth);
                     if rand_data  = 0 then 
                        rand_data   :=  to_signed(rand_seed + 1,LFSR_dataWidth);
                     end if;  
                     data_count  := 0;
                     if  RUN ='1' then 
                        RandSend_SM <= senddata; 
                  end if;
                  when senddata => 
                     --valeur par defaut
                     TX_MOSI.SOF    <= '0';
                     TX_MOSI.EOF    <= '0';
                     TX_MOSI.DVAL   <= '0';
                     ----
                     if TX_MISO.AFULL='0'  then 
                        data_count:= data_count + 1;
                        TX_MOSI.SOF   <= BoolToStd(data_count =1);                    
                        rand_data     := signed(LFSR(std_logic_vector(rand_data)));
                        --    if rand_data  = 0 then 
                        --                           rand_data   :=  to_signed(1,LFSR_dataWidth);
                        --                        end if;  
                        TX_MOSI.DATA  <= std_logic_vector( resize(rand_data,TX_MOSI.DATA'LENGTH) +  to_signed(rand_mean,TX_MOSI.DATA'LENGTH));
                        TX_MOSI.DVAL  <= '1';                    
                        if  data_count =datavector_length then 
                           TX_MOSI.EOF   <= '1'; 
                           if RUN ='1' then 
                              data_count     := 0;
                              rand_data      :=  to_signed(rand_seed,LFSR_dataWidth);
                              if rand_data  = 0 then 
                                 rand_data   :=  to_signed(rand_seed + 1,LFSR_dataWidth);
                              end if;  
                           else 
                              RandSend_SM <= idle;  
                           end if;   
                        end if;                    
                     end if; 
                  
                  when others =>        
                     --trap state
                  RandSend_SM <= idle; 
               end case;
               
            end if;
         end if;      
      end if;
   end process;
   
   
end rtl;
