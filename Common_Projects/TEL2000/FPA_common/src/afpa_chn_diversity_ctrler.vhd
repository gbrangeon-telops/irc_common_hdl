------------------------------------------------------------------
--!   @file : afpa_chn_diversity_ctrler
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
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.Fpa_Common_Pkg.all;
use work.fpa_define.all;
use work.proxy_define.all;
use work.tel2000.all;

entity afpa_chn_diversity_ctrler is
   port(
      ARESET        : in std_logic;
      CLK           : in std_logic;
      
      QUAD2_ENABLED : in std_logic;
      
      QUAD1_MOSI    : in t_ll_ext_mosi72;
      QUAD1_MISO    : out t_ll_ext_miso;
      
      QUAD2_MOSI    : in t_ll_ext_mosi72;
      QUAD2_MISO    : out t_ll_ext_miso;
      
      DOUT_MOSI     : out t_ll_ext_mosi72; 
      DOUT_MISO     : in t_ll_ext_miso;
      
      ERR           : out std_logic
      );
end afpa_chn_diversity_ctrler;


architecture rtl of afpa_chn_diversity_ctrler is
   
   type chn_dsity_fsm_type is (quad1_out_st, quad2_out_st);
   
   component sync_reset
      port (
         ARESET : in std_logic;
         CLK    : in std_logic;
         SRESET : out std_logic := '1'
         );
   end component;
   
   component fwft_sfifo_w76_d256
      port (
         clk : in std_logic;
         srst : in std_logic;
         din : in std_logic_vector(75 downto 0);
         wr_en : in std_logic;
         rd_en : in std_logic;
         dout : out std_logic_vector(75 downto 0);
         full : out std_logic;
         overflow : out std_logic;
         empty : out std_logic;
         valid : out std_logic
         );
   end component;
   
   signal err_i           : std_logic; 
   signal sreset          : std_logic;
   signal dout_mosi_i     : t_ll_ext_mosi72;
   signal chn_dsity_fsm   : chn_dsity_fsm_type;
   signal quad1_fifo_din  : std_logic_vector(75 downto 0);
   signal quad1_fifo_wr_en: std_logic;                    
   signal quad1_fifo_dout : std_logic_vector(75 downto 0);
   signal quad1_fifo_rd_en: std_logic;
   signal quad1_fifo_dval : std_logic;
   signal quad1_fifo_ovfl : std_logic;
   
   signal quad2_fifo_din  : std_logic_vector(75 downto 0);
   signal quad2_fifo_wr_en: std_logic;
   signal quad2_fifo_dout : std_logic_vector(75 downto 0);
   signal quad2_fifo_rd_en: std_logic;
   signal quad2_fifo_dval : std_logic;
   signal quad2_fifo_ovfl : std_logic;
   
   signal quad1_dout_mosi : t_ll_ext_mosi72;
   signal quad2_dout_mosi : t_ll_ext_mosi72;
   
begin
   
   ERR <= err_i;
   QUAD1_MISO <= DOUT_MISO;
   QUAD2_MISO <= DOUT_MISO;
   DOUT_MOSI <= dout_mosi_i;
   
   
   --------------------------------------------------
   -- synchro reset 
   --------------------------------------------------   
   U1 : sync_reset
   port map(
      ARESET => ARESET,
      CLK    => CLK,
      SRESET => sreset
      );
   
   
   ------------------------------------------------
   -- données entrant dans les fifos
   ------------------------------------------------
   quad1_fifo_din  <= QUAD1_MOSI.SOF & QUAD1_MOSI.EOF & QUAD1_MOSI.SOL & QUAD1_MOSI.EOL & QUAD1_MOSI.DATA;
   quad1_fifo_wr_en <= QUAD1_MOSI.DVAL;   
   quad2_fifo_din  <= QUAD2_MOSI.SOF & QUAD2_MOSI.EOF & QUAD2_MOSI.SOL & QUAD2_MOSI.EOL & QUAD2_MOSI.DATA;
   quad2_fifo_wr_en <= QUAD2_MOSI.DVAL; 
   
   
   ------------------------------------------------
   -- données sortant des fifos
   ------------------------------------------------
   quad1_dout_mosi.data <=  quad1_fifo_dout(71 downto 0);
   quad1_dout_mosi.eol  <=  quad1_fifo_dout(72);
   quad1_dout_mosi.sol  <=  quad1_fifo_dout(73);
   quad1_dout_mosi.eof  <=  quad1_fifo_dout(74);
   quad1_dout_mosi.sof  <=  quad1_fifo_dout(75);
   quad1_dout_mosi.dval <=  quad1_fifo_dval;
   
   quad2_dout_mosi.data <=  quad2_fifo_dout(71 downto 0);
   quad2_dout_mosi.eol  <=  quad2_fifo_dout(72);
   quad2_dout_mosi.sol  <=  quad2_fifo_dout(73);
   quad2_dout_mosi.eof  <=  quad2_fifo_dout(74);
   quad2_dout_mosi.sof  <=  quad2_fifo_dout(75);
   quad2_dout_mosi.dval <=  quad2_fifo_dval;  
   
   --------------------------------------------------
   -- fifo fwft quad1_DATA 
   -------------------------------------------------- 
   U2A : fwft_sfifo_w76_d256
   port map (
      srst => sreset,
      clk => CLK,
      din => quad1_fifo_din,
      wr_en => quad1_fifo_wr_en,
      rd_en => quad1_fifo_rd_en,
      dout => quad1_fifo_dout,
      valid  => quad1_fifo_dval,
      full => open,
      overflow => quad1_fifo_ovfl,
      empty => open
      ); 
   
   
   --------------------------------------------------
   -- fifo fwft quad1_DATA 
   -------------------------------------------------- 
   U2B : fwft_sfifo_w76_d256
   port map (
      srst => sreset,
      clk => CLK,
      din => quad2_fifo_din,
      wr_en => quad2_fifo_wr_en,
      rd_en => quad2_fifo_rd_en,
      dout => quad2_fifo_dout,
      valid  => quad2_fifo_dval,
      full => open,
      overflow => quad2_fifo_ovfl,
      empty => open
      );
   
   
   --------------------------------------------------
   -- multiplexage
   -------------------------------------------------- 
   U3 :  process(CLK) 
   begin
      if rising_edge(CLK) then
         if sreset = '1' then  
            dout_mosi_i.dval <= '0';	
            chn_dsity_fsm <= quad1_out_st;
            quad1_fifo_rd_en <= '0';
            quad2_fifo_rd_en <= '0';
            -- pragma translate_off
            dout_mosi_i.sof <= '0';
            dout_mosi_i.eof <= '0';          
            -- pragma translate_on 
            err_i <= '0';
            
         else
            
            if (DOUT_MISO.BUSY and (QUAD1_MOSI.DVAL or QUAD2_MOSI.DVAL))= '1' or quad1_fifo_ovfl = '1' or quad2_fifo_ovfl = '1' then
               err_i <= '1';
            end if;
            
            -- valeurs par defaut
            quad1_fifo_rd_en <= '0';
            quad2_fifo_rd_en <= '0';
            
            case chn_dsity_fsm is 
               
               when quad1_out_st =>                     
                  dout_mosi_i <= quad1_dout_mosi;           -- pix1, pix2, pix3, pix4            
                  dout_mosi_i.eof <= quad1_dout_mosi.eof and not QUAD2_ENABLED;     -- si la diversité des canaux n'est activée alors qu'on est en mode 8 canaux, c'est qu'on est en mode 8 taps (jupiter  par exemple). Dans ce cas,  pas de eof supplémentaire. Le eof proviendra des quad2
                  dout_mosi_i.eol <= quad1_dout_mosi.eol and not QUAD2_ENABLED;  
                  if QUAD2_ENABLED = '1' then 
                     if quad1_dout_mosi.dval = '1' then   -- FPA_INTF_CFG.ADC_QUAD2_EN provient du microBlaze et dit s'il faille envoyer les pix5, pix6, pix7, pix8
                        chn_dsity_fsm <= quad2_out_st;
                        quad1_fifo_rd_en <= '1';
                     end if;
                  else
                     quad1_fifo_rd_en <= '1';
                     quad2_fifo_rd_en <= '1';             -- n si quad2 n'est pas activé, laisser couler le fifo
                  end if;
               
               when quad2_out_st =>
                  dout_mosi_i <= quad2_dout_mosi;         -- pix5, pix6, pix7, pix8
                  dout_mosi_i.sof  <= '0';
                  dout_mosi_i.sol  <= '0';
                  if quad2_dout_mosi.dval = '1' then 
                     chn_dsity_fsm <= quad1_out_st;
                     quad2_fifo_rd_en <= '1';
                  end if;
               
               when others =>
               
            end case; 	
            
         end if;
      end if;
      
   end process;
   
end rtl;
