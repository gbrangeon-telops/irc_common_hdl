------------------------------------------------------------------
--!   @file : afpa_prog_mux
--!   @brief
--!   @details
--!
--!   $Rev$
--!   $Author$
--!   $Date$
--!   $Id$
--!   $URL$
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity afpa_prog_mux is
   port( 
      
      -- signaux generaux
      CLK      : in std_logic;
      ARESET   : in std_logic;
      
      -- client side
      CL_RQST  : in std_logic_vector(3 downto 0);
      CL_EN    : out std_logic_vector(3 downto 0);
      CL_DONE  : in std_logic_vector(3 downto 0);
      
      -- server side
      RQST     : out std_logic;
      EN       : in std_logic;
      DONE     : out std_logic
      );
   
end afpa_prog_mux;

architecture rtl of afpa_prog_mux is
   
   type mux_fsm_type is (idle, server_en_st, client_id_st, client_en_st, wait_end_st);
   
   -- sync_reset
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;    
   
   signal mux_fsm          : mux_fsm_type;
   signal sreset           : std_logic;
   signal cl_en_i          : std_logic_vector(3 downto 0);
   signal client_id        : natural range 0 to 3;
   
   signal done_i           : std_logic;
   signal rqst_i           : std_logic;
   

   
begin
   
   
   
   CL_EN <= cl_en_i;
   
   
   RQST <= rqst_i;
   DONE <= done_i; 
   
   
   
   --------------------------------------------------
   -- Sync reset
   -------------------------------------------------- 
   U1: sync_reset
   port map(ARESET => ARESET, CLK => CLK, SRESET => sreset);    
   
   --------------------------------------------------
   -- requests manager
   -------------------------------------------------- 
   U2: process(CLK)   
   begin
      if rising_edge(CLK) then 
         if sreset = '1' then 
            mux_fsm <=  idle;
            cl_en_i <= (others => '0');
            done_i <= '0';
            rqst_i <= '0';
         else                   
            
            --fsm de contrôle
            
            case  mux_fsm is 
               
               -- attente d'une demande 
               when idle =>
                  cl_en_i <= (others => '0');
                  done_i <= '1';
                  rqst_i <= '0';
                  if unsigned(CL_RQST) /= 0 then                     
                     mux_fsm <= server_en_st;
                  end if;
                  
               -- on relaie la demande au serveur
               when server_en_st => 
                  rqst_i <= '1';
                  if EN = '1' then 
                     rqst_i <= '0'; 
                     done_i <= '0';
                     mux_fsm <= client_id_st;
                  end if;
               
               -- on cherche le client demandeur  
               when client_id_st =>   
                  mux_fsm <= client_en_st;               
                  if CL_RQST(0) = '1' then      -- priorité par nnumero selon numero d'id croissant
                     client_id <= 0;          
                  elsif CL_RQST(1) = '1' then            
                     client_id <= 1;                  
                  elsif CL_RQST(2) = '1' then            
                     client_id <= 2;
                  elsif CL_RQST(3) = '1' then            
                     client_id <= 3;
                  else
                     mux_fsm <= idle;          -- si aucune demande on retourne à idle
                  end if;                   
                  
               -- on relaie l'accord au client 
               when client_en_st =>     
                  cl_en_i(client_id) <= '1';                 
                  if CL_DONE(client_id) = '0' then
                     mux_fsm <= wait_end_st;
                  end if;
                  
               -- attente de la fin de transaction
               when  wait_end_st =>  
                  cl_en_i <= (others =>'0');
                  if CL_DONE(client_id) = '1' then
                     mux_fsm <= client_id_st;       -- on regarde si une demande en attente avant de redonner la main au server
                  end if;               
               
               when others =>
               
            end case;
            
         end if;
      end if;   
   end process;
   
   
   
end rtl;
