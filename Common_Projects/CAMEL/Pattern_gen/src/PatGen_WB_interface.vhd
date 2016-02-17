-------------------------------------------------------------------------------
--
-- Title       : PatGen_WB_interface
-- Design      : Pattern_gen
-- Author      : Edem Nofodjie
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {PatGen_WB_interface} architecture {PatGen_WB_interface}}

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library Common_HDL; 	 
use Common_HDL.all;
use Common_HDL.Telops.all;
library work;
use work.DPB_define.all;
use work.CAMEL_define.all;


entity PatGen_WB_interface is
   port(
      CLK            : in STD_LOGIC;
      KERNEL_DONE    : in std_logic;
      ARESET         : in STD_LOGIC;
      WB_MOSI        : in t_wb_mosi;
      DONE           : out std_logic; 
      FPGA_ID        : in std_logic;
      WB_MISO        : out t_wb_miso;
      ODD_EVENn      : out std_logic;
      PG_CTRL        : out PatgenConfig;
      DP_CONF_ARRAY32: out DPconfig_array32
      );
end entity PatGen_WB_interface;



architecture RTL of PatGen_WB_interface is
   constant DPConfig_array32_length : integer :=19;
   -- diagram signals declarations
   signal Cfg              : PatgenConfig;
   signal Config           : STD_LOGIC_VECTOR (7 downto 0);  -- Config word send by PPC : (CONFIG(0) ='0' <=> Config à traiter = PG_CONFIG),(CONFIG(0) ='1' <=> Config à traiter = DP_CONFIG en testbench uniquement) 
   signal Control          : STD_LOGIC_VECTOR (7 downto 0);--   (CONROL(0) ='1' <=> lancer le PatternGen
   signal Status           : STD_LOGIC; 
   signal run_PG           : STD_LOGIC; -- permet de lancer le PatterGen
   signal Last_KERNEL_DONE : STD_LOGIC;  -- permet de detecter le front montant  de KERNEL done correspondant à un signal de fin de la part du KERNEL.
   signal DiagMode_from_ppc: std_logic_vector(DIAGMODELEN-1 downto 0);
   signal sreset           : std_logic;
   
   -- GRAY ENCODED state machine: WSHB_Interface_SM
   attribute enum_encoding: string;
   type WSHB_Interface_SM_type is 
   (Run, Wait_PPC, Idle);
   attribute enum_encoding of WSHB_Interface_SM_type: type is
   "00 " &		-- Run
   "01 " &		-- Wait_PPC
   "11" ; 		-- Idle
   
   signal WSHB_Interface_SM: WSHB_Interface_SM_type;
   
	component sync_reset
	port(
		ARESET : in std_logic;
		SRESET : out std_logic;
		CLK : in std_logic);
	end component;  
   
begin  
   sync_RST : sync_reset
   port map(ARESET => ARESET, SRESET => sreset, CLK => CLK);      
   
   -- concurrent signals assignments
   cfg.DiagMode  <= (others =>'0') when Config(0) = '1'  -- le mode de diagnostic "00" permet de desactiver la FSM du KERNEL et de tenir compte de la Config de DP en testbench uniquement
   else DiagMode_from_ppc;
   
   PG_CTRL       <= Cfg;
   
   ODD_EVENn     <= not FPGA_ID;  
   -------------------------------------------------------------------------------------------------------------------
   --     FEEDBACK:  VERIFICATION DES COMMANDES ENVOYÉES
   -------------------------------------------------------------------------------------------------------------------
   wb_rd : process(CLK)
   begin
      if rising_edge(CLK) then
         WB_MISO.ACK <= WB_MOSI.STB;
         case WB_MOSI.ADR(7 downto 0) is
            when X"00" =>  WB_MISO.DAT <= x"0000";
            when X"01" =>  WB_MISO.DAT <= (15 downto cfg.DiagMode'LENGTH => '0') & cfg.DiagMode     ;
            when X"02" =>  WB_MISO.DAT <= (15 downto ZLEN-16 => '0') & std_logic_vector(cfg.ZSIZE(ZLEN-1 downto 16));
            when X"03" =>  WB_MISO.DAT <= std_logic_vector(cfg.ZSIZE(15 downto 0));
            when X"04" =>  WB_MISO.DAT <= x"0000";
            when X"05" =>  WB_MISO.DAT <= (15 downto XLEN => '0')   & std_logic_vector(cfg.XSIZE);
            when X"06" =>  WB_MISO.DAT <= x"0000";
            when X"07" =>  WB_MISO.DAT <= (15 downto YLEN => '0')   & std_logic_vector(cfg.YSIZE);
            when X"08" =>  WB_MISO.DAT <= x"0000";
            when X"09" =>  WB_MISO.DAT <= (15 downto TAGLEN => '0') & std_logic_vector(cfg.TAGSIZE);
            when X"0A" =>  WB_MISO.DAT <= x"0000";
            when X"0B" =>  WB_MISO.DAT <= std_logic_vector(Cfg.DiagSize);
            when X"0C" =>  WB_MISO.DAT <= (15 downto PLLEN-16 => '0') & std_logic_vector(cfg.PAYLOADSIZE(PLLEN-1 downto 16));
            when X"0D" =>  WB_MISO.DAT <= std_logic_vector(cfg.PayloadSize(15 downto 0)); 
            when X"0E" =>  WB_MISO.DAT <= (others => '0');
            when X"0F" =>  WB_MISO.DAT <= std_logic_vector(cfg.ImagePause);
            
            when X"10" =>  WB_MISO.DAT <= x"0000";
            when X"11" =>  WB_MISO.DAT <= std_logic_vector(cfg.ROM_Z_START);  
            when X"12" =>  WB_MISO.DAT <= x"0000";
            when X"13" =>  WB_MISO.DAT <= std_logic_vector(cfg.ROM_INIT_INDEX);            
            when X"14" =>  WB_MISO.DAT <= (15 downto IMGLEN-16 => '0') & std_logic_vector(cfg.IMGSIZE(IMGLEN-1 downto 16));
            when X"15" =>  WB_MISO.DAT <= std_logic_vector(cfg.IMGSIZE(15 downto 0));            
               
            when X"16" =>  WB_MISO.DAT <= x"0000";            
            when X"17" =>  WB_MISO.DAT <= (15 downto CONFIG'LENGTH => '0') & CONFIG;     
               
            when X"18" =>  WB_MISO.DAT <= (15 downto CONTROL'LENGTH => '0') & CONTROL;
            when X"19" =>  WB_MISO.DAT <= (15 downto 1 => '0') & STATUS;    -- l'adresse du statut peut changer      
            when others => WB_MISO.DAT <= X"FFFF";
         end case;
      end if;
   end process;
   -------------------------------------------------------------------------------------------------------------------
   --       RECEPTION DES COMMANDES ENVOYÉES
   -------------------------------------------------------------------------------------------------------------------
   wb_wr : process(CLK)   
      variable subindex : integer range 1 to 64;
   begin
      if rising_edge(CLK) then
         if sreset = '1' then
            CONTROL(0)  <= '0';      -- contrôle de la FSM  avec  PG_Config
            CONFIG(0)   <='0';       -- contrôle de la FSM  avec  DP_Config
         elsif (WB_MOSI.STB and WB_MOSI.WE) = '1' then
            -- WB_MISO.ACK <= WB_MOSI.STB; 
            case WB_MOSI.ADR(7 downto 6) is   --subdivision en sous groupe de 32 adresses  chaque
               
               when "00" =>                   -- ie Adresse 0 à 31
                  case WB_MOSI.ADR(5 downto 0) is    
                     when "000000" => -- Do nothing
                     when "000001" => DiagMode_from_ppc <= WB_MOSI.DAT(DIAGMODELEN-1 downto 0);  
                     when "000010" => cfg.ZSIZE(ZLEN-1 downto 16)<= unsigned(WB_MOSI.DAT(ZLEN-17 downto 0));
                     when "000011" => cfg.ZSIZE(15 downto 0)<= unsigned(WB_MOSI.DAT);     
                     when "000100" => -- Do nothing;
                     when "000101" => cfg.XSIZE <= unsigned(WB_MOSI.DAT(XLEN-1 downto 0));  
                                      assert(WB_MOSI.DAT(1 downto 0) = "00") report "XSize must be a multiple of 4!" severity FAILURE;
                     when "000110" => -- Do nothing
                     when "000111" => cfg.YSIZE <= unsigned(WB_MOSI.DAT(YLEN-1 downto 0));   
                     when "001000" => -- Do nothing   
                     when "001001" => cfg.TAGSIZE  <= unsigned(WB_MOSI.DAT(TAGLEN-1 downto 0));
                                      assert(WB_MOSI.DAT(1 downto 0) = "00") report "TagSize must be a multiple of 4!" severity FAILURE;
                     when "001010" => -- Do nothing
                     when "001011" => cfg.DIAGSIZE <= unsigned(WB_MOSI.DAT(DIAGSIZELEN-1 downto 0)); 
                     when "001100" => cfg.PAYLOADSIZE(PLLEN-1 downto 16)<= unsigned(WB_MOSI.DAT(PLLEN-17 downto 0));  
                     when "001101" => cfg.PAYLOADSIZE(15 downto 0)<= unsigned(WB_MOSI.DAT); 
                     when "001110" => -- Do nothing
                     when "001111" => cfg.ImagePause(15 downto 0)<= unsigned(WB_MOSI.DAT);  
                     
                     when "010000" => -- Do nothing                                           
                     when "010001" => cfg.ROM_Z_START                 <= unsigned(WB_MOSI.DAT);  
                     when "010010" => -- Do nothing
                     when "010011" => cfg.ROM_INIT_INDEX              <= unsigned(WB_MOSI.DAT);                                      
                     when "010100" => cfg.IMGSIZE(IMGLEN-1 downto 16) <= unsigned(WB_MOSI.DAT(IMGLEN-17 downto 0));  
                     when "010101" => cfg.IMGSIZE(15 downto 0)        <= unsigned(WB_MOSI.DAT);                     
                     
                     when "010110" => -- Do nothing              
                     when "010111" => CONFIG  <= WB_MOSI.DAT(CONFIG'LENGTH-1 downto 0); -- à revoir 
                     when "011000" => CONTROL <= WB_MOSI.DAT(CONTROL'LENGTH-1 downto 0);  -- le controle est envoyé à l'adresse X"10" 
                     when others =>   -- Do nothing
                  end case;
               when "01" =>   -- la CMD61 ou  DP_CONFIG est envoyée en testbench ici (adresse 32 à 63)
                  subindex := to_integer(unsigned(WB_MOSI.ADR(5 downto 0))) + 2; -- le  + 2 en vue de laisser le premier Q-Word aux données d'identification de la frame      //subindex := to_integer(unsigned(WB_MOSI.ADR(5 downto 0))) + 2;
                  DP_CONF_ARRAY32(1)  <= x"61" & std_logic_vector(to_unsigned(DPConfig_array32_length,24)); -- les parametres d'identification de la frame DP_Config
                  case WB_MOSI.ADR(0) is 
                     when '0' =>
                        -- DP_CONF_ARRAY32(subindex)(31 downto 16) <= WB_MOSI.DAT;
                     when '1' =>
                        -- DP_CONF_ARRAY32(subindex)(15 downto 0) <= WB_MOSI.DAT;
                     when others => 
                     -- Do nothing
                  end case;
               when others => 
               -- Do nothing
            end case;    
         end if;
      end if;
      --end if;
   end process;
   -------------------------------------------------------------------------------------------------------------------
   --          ASSIGNATION DE LA CONFIGURATION AU KERNEL  :  KERNEL OTHER PARAMETERS
   -------------------------------------------------------------------------------------------------------------------
   
   Frm_Type : process(CLK)
   begin
      if rising_edge(CLK) then
         if   Config(0)='1' then 
            Cfg.FrameType <= PROC_CONFIG_FRAME; 
         else              -- Diagmode n'a de sens que lorsque le PPC  n'envoie pas la config 61 pour testbench
            case cfg.DiagMode is
               when PG_CAM_CNT => -- Camera Frame simple pix inc;
                  Cfg.FrameType <= ROIC_CAMERA_FRAME;
               when PG_CAM_VIS => -- Camera Frame Visible pattern;
                  Cfg.FrameType <= ROIC_CAMERA_FRAME;
               when PG_BSQ_XYZ => -- BSQ DCube simple pix inc. In this case, send header, BSQ Cube  and Footer  -- KERNEL State Machine set to TRUE;
                  Cfg.FrameType <= ROIC_DCUBE_FRAME;
                  -- header Definition
                  --                  ROIC_HEADER.Direction  <= '0';
                  --                  ROIC_HEADER.Acq_Number <= resize(cfg.DIAGSIZE,ACQLEN);
                  --                  ROIC_HEADER.Code_Rev   <= x"C0DE";
                  --                  ROIC_HEADER.Status     <= x"12345678";
                  --                  ROIC_HEADER.Xmin       <= resize('1'&x"BB",RXLEN);
                  --                  -- aka FOVStartX
                  --                  ROIC_HEADER.Ymin       <= resize("01"&x"CC",RYLEN);
                  --                  -- aka FOVStartY
                  --                  ROIC_HEADER.StartTimeStamp  <= x"ABCDEF23";
                  --                  -- Footer  Definition
                  --                  ROIC_FOOTER.Direction  <= '0';
                  --                  ROIC_FOOTER.Acq_Number <= resize(cfg.DIAGSIZE,ACQLEN);
                  --                  ROIC_FOOTER.Write_No   <= resize(cfg.ZSIZE,FRINGELEN);
                  --                  ROIC_FOOTER.Trig_No    <= resize(cfg.ZSIZE,FRINGELEN);
                  --                  ROIC_FOOTER.Status     <= x"12345678";
                  --                  -- aka FOVStartX
                  --                  ROIC_FOOTER.ZPDPosition<= resize(x"01",FRINGELEN);
                  --                  -- aka FOVStartY
                  --                  ROIC_FOOTER.ZPDPeakVal <= (x"ABCD");
                  --                  ROIC_FOOTER.EndTimeStamp  <= (x"FBCD1234");
               when PG_BIP_XYZ => -- Dcube frame Dirac
               when others    => -- do nothing
            end case;
         end if;
      end if;
   end process;
   
   ----------------------------------------------------------------------
   -- Machine: WSHB_Interface_SM
   ----------------------------------------------------------------------
   WSHB_Interface_SM_machine: process (CLK)
   begin
      if CLK'event and CLK = '1' then
         if sreset ='1' then	
            WSHB_Interface_SM <= Idle;
            -- Set default values for outputs, signals and variables
            -- ...
            Cfg.Trig <= '0'; 
            STATUS <='0';          
            Last_KERNEL_DONE <='1'; -- car au depart  , KERNEL_DONE est supposé à '1'
            
         else 
            Last_KERNEL_DONE <=KERNEL_DONE;      -- pour tracker la remontée de kernel_done
            case WSHB_Interface_SM is
               when Idle =>
                  Cfg.Trig <= '0';
                  STATUS      <= '1';
                  if CONTROL(0) ='1' then	 -- Control pour lancer le Patgen apres avoir envoyer Pat_Gen_Config , et config pour le lancer apres avoir envoyé le DP_config
                     WSHB_Interface_SM <= Run;
                     Cfg.Trig <= '1';
                     STATUS      <= '0';
                     -- for triggering a pattern
                  end if;           
               when Run =>
                  Cfg.Trig <= '0';
                  if KERNEL_DONE ='1'and last_KERNEL_DONE ='0' then	  -- remintée de Kernel_done correspondant à la fin de la generation du Pattern
                     WSHB_Interface_SM <= Wait_PPC;   
                  end if;
               when Wait_PPC =>                               -- on attend que le PPC prenne en compte le statut qu'on lui envoie 
                  STATUS      <= '1';
                  if CONTROL(0) ='0'  then	-- une fois que le PPC en tient compte, CONTROL(0) tombe à '0' 
                     WSHB_Interface_SM <= Idle;
                  end if;
               when others =>
               -- trap state
               WSHB_Interface_SM <= Idle;
            end case;
         end if;
      end if;
   end process;
   
   
end RTL;
