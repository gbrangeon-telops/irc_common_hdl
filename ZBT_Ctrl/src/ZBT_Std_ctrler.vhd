-------------------------------------------------------------------------------
--
-- Title       : ZBT_Std_ctrler
-- Design      : ZBT_Ctrl
-- Author      : Edem Nofodjie
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : D:\Telops\Common_HDL\ZBT_Ctrl\Active-HDL\src\ZBT_Std_ctrler.vhd
-- Generated   : Mon Apr 23 12:08:42 2007
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.20
--
-------------------------------------------------------------------------------
--
-- Description : Controleur ZBT standard. Inspiré du modele VHDL de la ZBT  MT55l256l32p
--               Toutes les sorties sont synchrones sauf le bus bidirectionnel
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;     
use ieee.numeric_std.all;                
library Common_HDL;   
-- translate_off 
library VIRTEX4;
use IEEE.vital_timing.all;
-- translate_on 


entity zbt_std_ctrler is
   generic(  
      Instantiate_IDLY_CTRL : boolean := false;
      ALEN : INTEGER := 19;
      DLEN : INTEGER := 32
      );
   port(                            
      DLY_CTRL_CLK   : in std_logic;
      DLY_CTRL_RDY   : out std_logic;   
      
      DLY_CLK        : in std_logic;
      DLY_EN         : in std_logic;
      DLY_INC        : in std_logic;    
      DLY_RST        : in std_logic;
      EXTRA_CYCLE    : in std_logic;
      
      ARESET         : in STD_LOGIC;
      CLK_CORE       : in STD_LOGIC;
      BURST          : in STD_LOGIC;
      CMD_VALID      : in STD_LOGIC;
      WRITE_N        : in STD_LOGIC;
      ADDRESS        : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
      SLEEP_MODE     : in STD_LOGIC;
      IGNORE_CLK     : in STD_LOGIC;
      BURST_MODE     : in STD_LOGIC;
      BWA_N_IN       : in STD_LOGIC;
      BWB_N_IN       : in STD_LOGIC;
      BWC_N_IN       : in STD_LOGIC;
      BWD_N_IN       : in STD_LOGIC;
      WR_DATA        : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
      DATA_RD        : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
      DATA_VALID     : out STD_LOGIC;       
      
      ZBT_ADD        : out STD_LOGIC_VECTOR(ALEN-1 downto 0);
      ZBT_CE_N       : out STD_LOGIC;
      ZBT_OE_N       : out STD_LOGIC;
      ZBT_WE_N       : out STD_LOGIC;
      ZBT_ADV_LD_N   : out STD_LOGIC;
      ZBT_MODE       : out STD_LOGIC;
      ZBT_CKE_N      : out STD_LOGIC;     
      ZBT_CE2_N      : out STD_LOGIC;
      ZBT_CE2        : out STD_LOGIC;
      ZBT_ZZ         : out STD_LOGIC;
      ZBT_BWA_N      : out STD_LOGIC;
      ZBT_BWB_N      : out STD_LOGIC;
      ZBT_BWC_N      : out STD_LOGIC;
      ZBT_BWD_N      : out STD_LOGIC;
      ZBT_DATA       : inout STD_LOGIC_VECTOR(DLEN-1 downto 0)
      );
end zbt_std_ctrler;

--}} End of automatically maintained section


architecture RTL of ZBT_Std_ctrler is         
   
   component sync_reset
      port(
         ARESET : in std_logic;
         SRESET : out std_logic;
         CLK : in std_logic);
   end component;
   
   component OFD
      port (
         C : in STD_LOGIC;
         D : in STD_LOGIC;
         Q : out STD_LOGIC
         );
   end component;   
   
   type data_delay_type is array (2 downto 0) of std_logic_vector(DLEN-1 downto 0);
   SIGNAL Data_to_mem                                 : std_logic_vector(DLEN-1 downto 0);
   SIGNAL valid_read_cmd, data_valid_out              : std_logic :='0';
   
   signal we_n_reg_d          : std_logic;
   signal ZBT_WE_Ni2          : std_logic; -- Simply copy to permit IOB registers
   signal zbt_wr_delay1       : std_logic;
   signal zbt_data_oe         : std_logic_vector(DLEN-1 downto 0);  
   signal sreset              : std_logic;
   
   attribute equivalent_register_removal : string;      
   attribute equivalent_register_removal of Data_to_mem             : signal is "NO"; 
   attribute equivalent_register_removal of DATA_RD                 : signal is "NO"; 
   attribute equivalent_register_removal of zbt_data_oe             : signal is "NO"; -- 
   attribute equivalent_register_removal of data_valid_out          : signal is "NO"; 
   
   --This is to enable to pack registers into IOB. Each data IOB needs a separate output enable.            
   attribute IOB : string;
   attribute IOB of Data_to_mem                                     : signal is "FORCE";      
   attribute IOB of DATA_RD                                         : signal is "FORCE";      
   attribute IOB of zbt_data_oe                                     : signal is "FORCE";
   attribute IOB of data_valid_out                                  : signal is "FORCE";     
   
   signal zbt_data_delayed : STD_LOGIC_VECTOR(DLEN-1 downto 0);    
   
   signal idelay_rst : std_logic;
   
   component idelay
      generic(
         IOBDELAY_TYPE : STRING := "DEFAULT";
         IOBDELAY_VALUE : INTEGER := 0);
      port(
         O : out std_ulogic;
         C : in std_ulogic;
         CE : in std_ulogic;
         I : in std_ulogic;
         INC : in std_ulogic;
         RST : in std_ulogic);
   end component;             
   
   component idelayctrl
      port(
         RDY : out std_ulogic;
         REFCLK : in std_ulogic;
         RST : in std_ulogic);
   end component;
   
begin          
   
   -------------------------------------
   -- Synchronize towards CLK_CORE domain
   -------------------------------------
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK_CORE);	
   
   -----------------------------------------------------------------------------------
   -- IDELAY
   -----------------------------------------------------------------------------------  
   idelay_rst <= ARESET or DLY_RST;
   gen_dly : for i in (DLEN-1) downto 0 generate
      
      dly : idelay
      generic map(
         IOBDELAY_TYPE => "VARIABLE",
         IOBDELAY_VALUE => 0
         )
      port map(
         O => zbt_data_delayed(i),
         C => DLY_CLK,
         CE => DLY_EN,
         I => ZBT_DATA(i),
         INC => DLY_INC,
         RST => idelay_rst
         );  
      
   end generate;  
   
   gen_ctrl : if Instantiate_IDLY_CTRL generate        
      dly_ctrl : idelayctrl
      port map(
         RDY => DLY_CTRL_RDY,
         REFCLK => DLY_CTRL_CLK,
         RST => ARESET
         );      
   end generate;
   
   
   -----------------------------------------------------------------------------------
   --          DEFINITION DES ACTIONS DE LECTURE OU D'ÉCRITURE
   -----------------------------------------------------------------------------------   
   valid_read_cmd     <= WRITE_N and CMD_VALID and not SLEEP_MODE;            -- action read valide;
   
   
   
   
   -----------------------------------------------------------------------------------
   --          PARTIE LECTURE: data valide 2 VALIDES CLKS apres la commande de lecture
   -----------------------------------------------------------------------------------	
   ZBT_OE_N  <='0';  
   Read:  process (CLK_CORE)
      VARIABLE read_in,valid_read_cmd_in  : STD_LOGIC_VECTOR(2 downto 0):=(others =>'0');
      
   begin 
      if rising_edge(CLK_CORE)  then 
         if sreset = '1' then 
            read_in:= (others =>'0');
         else      
            if  IGNORE_CLK ='0'  then                                      -- ie si valide Clock et donc CLK non ignoré
               read_in(2)           :=    read_in(1); 
               read_in(1)           :=    read_in(0);                          -- decalage de 1 CLK_CORE
               read_in(0)           :=    WRITE_N;--valid_read_cmd;                      -- CMD read 
               
               if EXTRA_CYCLE = '0' then
                  data_valid_out              <=    valid_read_cmd_in(1);
               else
                  data_valid_out              <=    valid_read_cmd_in(2);
               end if;
               
               valid_read_cmd_in(2)           :=    valid_read_cmd_in(1);                 
               valid_read_cmd_in(1)           :=    valid_read_cmd_in(0);                 
               valid_read_cmd_in(0)           :=    valid_read_cmd;--valid_read_cmd; 
            end if; 
         end if;
      end if;     
   end process;  
   
   -----------------------------------------------------------------------------------
   --          PARTIE ECRITURE: 
   -----------------------------------------------------------------------------------
   write:  process (CLK_CORE, ARESET)
      variable data_delay  :  data_delay_type;
   begin 
      if rising_edge(CLK_CORE) then
         Data_to_mem        <=    data_delay(1);        -- Donnee sortant 2 CLKS apres l'adresse  
         data_delay(2)      :=	 data_delay(1);
         data_delay(1)      :=    data_delay(0);
         data_delay(0)      :=    WR_DATA;
      end if;
      if Areset ='1' then 
         data_delay(0) := (others =>'0');
         data_delay(1) := (others =>'0'); 
         --Data_to_mem  <=  (others =>'0');                
      end if;
   end process;
   
   
   -----------------------------------------------------------------------------------
   --           SIGNAUX DE CONTROLE CLOCKÉS DE LA ZBT 
   -----------------------------------------------------------------------------------
   
   -- Always enable the ZBT ram
   ZBT_CE_n        <=  '0';
   ZBT_CE2_n       <=  '0';
   ZBT_CE2         <=  '1'; 
   
   gen_add_out_reg : for n in 0 to ALEN-1 generate
      REG : OFD
      port map(
         C => CLK_CORE,
         D => ADDRESS(n),
         Q => ZBT_ADD(n)
         );     
   end generate;  
   
   we_n_reg_d <= WRITE_N or not CMD_VALID or Areset;
   we_n_reg : OFD
   port map(
      C => CLK_CORE,
      D => we_n_reg_d,
      Q => ZBT_WE_N
      );
   
   
   OUTPUT_GRP:  process (CLK_CORE)  
   begin 
      
      if rising_edge(CLK_CORE) then 
         ZBT_ZZ        <=   SLEEP_MODE;
         ZBT_CKE_n     <=   IGNORE_CLK; 
         ZBT_ADV_LD_N  <=   BURST;
         ZBT_MODE      <=   BURST_MODE; 
         ZBT_WE_Ni2     <=   WRITE_N or not CMD_VALID; 
      end if;
      
      if Areset ='1' then                    -- aucune action possible
         ZBT_ZZ          <=  '1';
         ZBT_CKE_n       <=  '1';
         ZBT_ADV_LD_N    <=  '0';
         ZBT_MODE        <=  '0';
         ZBT_BWA_N       <=  '0';
         ZBT_BWB_N       <=  '0';
         ZBT_BWC_N       <=  '0';
         ZBT_BWD_N       <=  '0';
         ZBT_WE_Ni2      <=  '1';
      end if;
   end process; 
   
   ----------------------------------------------------------------------------------
   --           ENVOIE DES DATAREAD VERS LA SORTIE DATA_RD de la ZBT
   -----------------------------------------------------------------------------------
   
   Readout: process(CLK_CORE)
   begin
      if rising_edge(CLK_CORE)then 
         if sreset = '1' then
            DATA_RD     <= (others =>'0');
            DATA_VALID  <=   '0';             
         else
            DATA_RD           <= zbt_data_delayed  ;    -- donnees lues envoyées vers l'application cliente   
            DATA_VALID        <= data_valid_out;-- dit à l'application cliente que la donnée est prête (valide)
         end if;
      end if;
   end process;  
   
   
   oe_process : process(CLK_CORE, ARESET)
   begin 
      if rising_edge(CLK_CORE)then       
         zbt_wr_delay1 <= not ZBT_WE_Ni2;
         gen_oe : for i in DLEN-1 downto 0 loop
            zbt_data_oe(i) <= zbt_wr_delay1;
         end loop;          
      end if;     
      --      if ARESET = '1' then
      --         zbt_data_oe <= (others => '0');
      --      end if;
      
   end process;
   
   
   -----------------------------------------------------------------------------------
   --         CONTROL DU BUS TRI-STATE INOUT  
   -----------------------------------------------------------------------------------   
   gen : for i in DLEN-1 downto 0 generate      
      ZBT_DATA(i)         <=    Data_to_mem(i) when zbt_data_oe(i) = '1' else 'Z';
   end generate;     
end RTL;





