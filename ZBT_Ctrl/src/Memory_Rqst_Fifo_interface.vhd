-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : FIR_00180
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : d:\Telops\FIR-00180\compile\Memory_Rqst_Fifo_interface.vhd
-- Generated   : 10/05/10 19:39:31
-- From        : 
-- By          : 
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
library COMMON_HDL;
use common_hdl.telops.all;

entity memory_rqst_fifo_interface is 
   generic (
      ALEN: integer := 21;
      DLEN: integer := 16 );
   port (
      ARESET           : in std_logic;
      CLK_CORE         : in std_logic;  
      
      -- entrées données à ecrire
      WRF_DOUT         : in std_logic_vector(ALEN+DLEN-1 downto 0);
      WRF_EMPTY        : in std_logic;
      WRF_RD_ACK       : in std_logic;
      WRF_RD_EN        : out std_logic;
      
      -- entrées adresses de lecture 
      RAF_RD_EN        : out std_logic;
      RAF_DOUT         : in std_logic_vector(ALEN-1 downto 0);
      RAF_EMPTY        : in std_logic;
      RAF_RD_ACK       : in std_logic;      
      
      -- entrées données lues
      DATA_FROM_MEM    : in std_logic_vector(DLEN-1 downto 0);      
      DATA_READ_VALID  : in std_logic;
      
      -- sorties vers memoire		
      ADDRESS          : out std_logic_vector(ALEN-1 downto 0);
      CMD_VALID        : out std_logic;
      DATA_TO_MEM      : out std_logic_vector(DLEN-1 downto 0);
      WRITE_EN_N       : out std_logic;
      
      -- sorties des donnees lues 		
      RDF_DIN          : out std_logic_vector(DLEN-1 downto 0); 
      RDF_AFULL        : in std_logic;
      RDF_WR_EN        : out std_logic
      --SELF_TEST_EN     : in std_logic
      );
end memory_rqst_fifo_interface;

architecture rtl of Memory_Rqst_Fifo_interface is
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   type ctrl_fsm_type is (idle, wr_st, rd_st);
   signal ctrl_fsm          : ctrl_fsm_type;   
   signal sreset            : std_logic;
   signal raf_rd_en_i       : std_logic;
   signal wrf_rd_en_i       : std_logic; 
   signal rdf_wr_en_i       : std_logic;
   signal cmd_valid_i       : std_logic;
   signal address_i         : std_logic_vector(ALEN-1 downto 0);
   signal data_to_mem_i     : std_logic_vector(DLEN-1 downto 0); 
   signal rdf_din_i         : std_logic_vector(DLEN-1 downto 0);
   signal write_en_n_i      : std_logic;
   
   
begin  
   
   ------------------------------------------------------------------
   -- outputs
   ------------------------------------------------------------------ 
   RAF_RD_EN   <= raf_rd_en_i;
   WRF_RD_EN   <= wrf_rd_en_i; 
   ADDRESS     <= address_i; 
   CMD_VALID   <= cmd_valid_i;
   DATA_TO_MEM <= data_to_mem_i;
   WRITE_EN_N  <= write_en_n_i;
   RDF_DIN     <= rdf_din_i; 
   RDF_WR_EN   <= rdf_wr_en_i;
   
   
   ------------------------------------------------------------------
   -- sync_reset
   ------------------------------------------------------------------ 
   
   sync_RST : component  sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK_CORE);
   
   
   ----------------------------------------------------------------------
   -- demande d'ecriture / lecture
   ----------------------------------------------------------------------
   memory_Write_read: process(CLK_CORE)
   begin
      if  rising_edge(CLK_CORE) then
         if sreset = '1' then
            cmd_valid_i <= '0';
            write_en_n_i <= '1';
         else
            if  wrf_rd_en_i = '1' then  -- write part
               data_to_mem_i <= WRF_DOUT(DLEN-1 downto 0);
               address_i <= WRF_DOUT(ALEN+DLEN-1 downto DLEN);
               write_en_n_i <= '0';
               cmd_valid_i <= WRF_RD_ACK;
            elsif raf_rd_en_i = '1' then 
               write_en_n_i <= '1';
               cmd_valid_i <= RAF_RD_ACK;
               address_i <= RAF_DOUT;
            else
               cmd_valid_i <= '0';
               write_en_n_i <= '1';
            end if;
         end if;
      end if;
   end process;
   
   
   ----------------------------------------------------------------------
   -- Machine: donnees en provenance de la memoire
   ----------------------------------------------------------------------
   rdf_proc: process(CLK_CORE)
   begin
      if  rising_edge(CLK_CORE) then
         if sreset = '1' then
            rdf_wr_en_i <= '0';
         else
            rdf_din_i <= DATA_FROM_MEM;
            rdf_wr_en_i <= DATA_READ_VALID;
         end if;
      end if;
   end process;
   
   
   ----------------------------------------------------------------------
   -- Machine: ctrl_fsm
   ----------------------------------------------------------------------
   ctrl_fsm_machine: process (CLK_CORE)
   begin
      if rising_edge(CLK_CORE) then
         if sreset ='1' then	
            ctrl_fsm <= idle;
            wrf_rd_en_i  <= '0';
            raf_rd_en_i <='0';
         else
            
            case ctrl_fsm is
               
               when idle =>
                  wrf_rd_en_i <= '0';
                  raf_rd_en_i <= '0';
                  if WRF_RD_ACK = '1' then	
                     ctrl_fsm <= wr_st;
                  elsif RAF_RD_ACK = '1' and RDF_AFULL = '0' then	
                     ctrl_fsm <= rd_st;
                  end if;  
                  
               when wr_st =>
                  wrf_rd_en_i <= '1';
                  raf_rd_en_i <= '0';
                  if RAF_RD_ACK = '1' and RDF_AFULL = '0' then	
                     ctrl_fsm <= rd_st;
                  elsif WRF_RD_ACK = '0' then	
                     ctrl_fsm <= idle;
                  end if;   
                  
               when rd_st =>
                  wrf_rd_en_i <= '0';
                  raf_rd_en_i <= '1';
                  if WRF_RD_ACK = '1' then	
                     ctrl_fsm <= wr_st;
                  elsif (RAF_RD_ACK = '0' or RDF_AFULL = '1')then	
                     ctrl_fsm <= idle;
                  end if; 
                  
               when others =>                
               
            end case;
         end if;
      end if;
   end process;
   
end rtl;
