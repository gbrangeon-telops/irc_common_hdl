-------------------------------------------------------------------------------
--
-- Title       : wb_intercon_8s
-- Author      : Patrick Dubois
-- Company     : Radiocommunication and Signal Processing Laboratory (LRTS)
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
library Common_HDL;
use Common_HDL.Telops.all;

entity wb_intercon_8s is
   port(	
      M0_WB_MOSI : in t_wb_mosi;
      M0_WB_MISO : out t_wb_miso;
      
      M1_DAT_O : in std_logic_vector(15 downto 0);  
      M1_ACK_I : out std_logic;   
      M1_DAT_I : out std_logic_vector(15 downto 0);  
      M1_WE_O  : in std_logic;
      M1_STB_O : in std_logic;
      M1_ADR_O : in std_logic_vector(11 downto 0);	
      M1_CYC_O : in std_logic;      
      
      S0_WB_MISO : in t_wb_miso;
      S0_WB_MOSI : out t_wb_mosi;
      
      S1_WB_MISO : in t_wb_miso;
      S1_WB_MOSI : out t_wb_mosi;
      
      S2_WB_MISO : in t_wb_miso;
      S2_WB_MOSI : out t_wb_mosi;
      
      S3_WB_MISO : in t_wb_miso;
      S3_WB_MOSI : out t_wb_mosi; 
      
      S4_WB_MISO : in t_wb_miso;
      S4_WB_MOSI : out t_wb_mosi; 
      
      S5_WB_MISO : in t_wb_miso;
      S5_WB_MOSI : out t_wb_mosi;       
      
      S6_WB_MISO : in t_wb_miso;
      S6_WB_MOSI : out t_wb_mosi;
      
      S7_WB_MISO : in t_wb_miso;
      S7_WB_MOSI : out t_wb_mosi;      

      CLK		: in std_logic;
      ARESET   : in std_logic
      
      );
end wb_intercon_8s;

architecture RTL of wb_intercon_8s is
attribute keep : string;       

   alias M0_ACK_I : std_logic is M0_WB_MISO.ACK;
   alias M0_DAT_I : std_logic_vector(M0_WB_MISO.DAT'LENGTH-1 downto 0) is M0_WB_MISO.DAT;
   alias M0_ADR_O : std_logic_vector(M0_WB_MOSI.ADR'LENGTH-1 downto 0) is M0_WB_MOSI.ADR;
   alias M0_CYC_O : std_logic is M0_WB_MOSI.CYC;
   alias M0_DAT_O : std_logic_vector(M0_WB_MOSI.DAT'LENGTH-1 downto 0) is M0_WB_MOSI.DAT;
   alias M0_STB_O : std_logic is M0_WB_MOSI.STB;
   alias M0_WE_O  : std_logic is M0_WB_MOSI.WE;
    
   alias S0_ACK_O : std_logic is S0_WB_MISO.ACK;
   alias S0_DAT_O : std_logic_vector(S0_WB_MISO.DAT'LENGTH-1 downto 0) is S0_WB_MISO.DAT;
   alias S0_ADR_I : std_logic_vector(S0_WB_MOSI.ADR'LENGTH-1 downto 0) is S0_WB_MOSI.ADR;
   alias S0_DAT_I : std_logic_vector(S0_WB_MOSI.DAT'LENGTH-1 downto 0) is S0_WB_MOSI.DAT;
   alias S0_STB_I : std_logic is S0_WB_MOSI.STB;
   alias S0_WE_I  : std_logic is S0_WB_MOSI.WE;     
   
   alias S1_ACK_O : std_logic is S1_WB_MISO.ACK;
   alias S1_DAT_O : std_logic_vector(S1_WB_MISO.DAT'LENGTH-1 downto 0) is S1_WB_MISO.DAT;
   alias S1_ADR_I : std_logic_vector(S1_WB_MOSI.ADR'LENGTH-1 downto 0) is S1_WB_MOSI.ADR;
   alias S1_DAT_I : std_logic_vector(S1_WB_MOSI.DAT'LENGTH-1 downto 0) is S1_WB_MOSI.DAT;
   alias S1_STB_I : std_logic is S1_WB_MOSI.STB;
   alias S1_WE_I  : std_logic is S1_WB_MOSI.WE;  
   
   alias S2_ACK_O : std_logic is S2_WB_MISO.ACK;
   alias S2_DAT_O : std_logic_vector(S2_WB_MISO.DAT'LENGTH-1 downto 0) is S2_WB_MISO.DAT;
   alias S2_ADR_I : std_logic_vector(S2_WB_MOSI.ADR'LENGTH-1 downto 0) is S2_WB_MOSI.ADR;
   alias S2_DAT_I : std_logic_vector(S2_WB_MOSI.DAT'LENGTH-1 downto 0) is S2_WB_MOSI.DAT;
   alias S2_STB_I : std_logic is S2_WB_MOSI.STB;
   alias S2_WE_I  : std_logic is S2_WB_MOSI.WE;
   
   alias S3_ACK_O : std_logic is S3_WB_MISO.ACK;
   alias S3_DAT_O : std_logic_vector(S3_WB_MISO.DAT'LENGTH-1 downto 0) is S3_WB_MISO.DAT;
   alias S3_ADR_I : std_logic_vector(S3_WB_MOSI.ADR'LENGTH-1 downto 0) is S3_WB_MOSI.ADR;
   alias S3_DAT_I : std_logic_vector(S3_WB_MOSI.DAT'LENGTH-1 downto 0) is S3_WB_MOSI.DAT;
   alias S3_STB_I : std_logic is S3_WB_MOSI.STB;
   alias S3_WE_I  : std_logic is S3_WB_MOSI.WE;
   
   alias S4_ACK_O : std_logic is S4_WB_MISO.ACK;
   alias S4_DAT_O : std_logic_vector(S4_WB_MISO.DAT'LENGTH-1 downto 0) is S4_WB_MISO.DAT;
   alias S4_ADR_I : std_logic_vector(S4_WB_MOSI.ADR'LENGTH-1 downto 0) is S4_WB_MOSI.ADR;
   alias S4_DAT_I : std_logic_vector(S4_WB_MOSI.DAT'LENGTH-1 downto 0) is S4_WB_MOSI.DAT;
   alias S4_STB_I : std_logic is S4_WB_MOSI.STB;
   alias S4_WE_I  : std_logic is S4_WB_MOSI.WE;
   
   alias S5_ACK_O : std_logic is S5_WB_MISO.ACK;
   alias S5_DAT_O : std_logic_vector(S5_WB_MISO.DAT'LENGTH-1 downto 0) is S5_WB_MISO.DAT;
   alias S5_ADR_I : std_logic_vector(S5_WB_MOSI.ADR'LENGTH-1 downto 0) is S5_WB_MOSI.ADR;
   alias S5_DAT_I : std_logic_vector(S5_WB_MOSI.DAT'LENGTH-1 downto 0) is S5_WB_MOSI.DAT;
   alias S5_STB_I : std_logic is S5_WB_MOSI.STB;
   alias S5_WE_I  : std_logic is S5_WB_MOSI.WE;
   
   alias S6_ACK_O : std_logic is S6_WB_MISO.ACK;
   alias S6_DAT_O : std_logic_vector(S6_WB_MISO.DAT'LENGTH-1 downto 0) is S6_WB_MISO.DAT;
   alias S6_ADR_I : std_logic_vector(S6_WB_MOSI.ADR'LENGTH-1 downto 0) is S6_WB_MOSI.ADR;
   alias S6_DAT_I : std_logic_vector(S6_WB_MOSI.DAT'LENGTH-1 downto 0) is S6_WB_MOSI.DAT;
   alias S6_STB_I : std_logic is S6_WB_MOSI.STB;
   alias S6_WE_I  : std_logic is S6_WB_MOSI.WE;
   
   alias S7_ACK_O : std_logic is S7_WB_MISO.ACK;
   alias S7_DAT_O : std_logic_vector(S7_WB_MISO.DAT'LENGTH-1 downto 0) is S7_WB_MISO.DAT;
   alias S7_ADR_I : std_logic_vector(S7_WB_MOSI.ADR'LENGTH-1 downto 0) is S7_WB_MOSI.ADR;
   alias S7_DAT_I : std_logic_vector(S7_WB_MOSI.DAT'LENGTH-1 downto 0) is S7_WB_MOSI.DAT;
   alias S7_STB_I : std_logic is S7_WB_MOSI.STB;
   alias S7_WE_I  : std_logic is S7_WB_MOSI.WE;   
   
   signal GNT        : std_logic_vector(1 downto 0);
   signal GNT3       : std_logic;
   signal GNT2       : std_logic;
   signal GNT1       : std_logic;
   signal GNT0       : std_logic;
--   attribute keep of GNT0 : signal is "true";
--   attribute keep of GNT1 : signal is "true";
   
   signal ADR        : std_logic_vector(11 downto 0);
   signal DRD        : std_logic_vector(15 downto 0);
   signal DWR        : std_logic_vector(15 downto 0);
   signal CYC        : std_logic;
   signal STB        : std_logic;
   signal ACK        : std_logic;
   signal WE         : std_logic;              
   	
--	attribute keep of ADR : signal is "true";   
--   attribute keep of DRD : signal is "true";   
--   attribute keep of DWR : signal is "true";   
--   attribute keep of CYC : signal is "true";   
--   attribute keep of STB : signal is "true";   
--   attribute keep of ACK : signal is "true";   
--   attribute keep of WE  : signal is "true";   
   
   signal S0_ACMP    : std_logic;
   signal S1_ACMP    : std_logic;
   signal S2_ACMP    : std_logic;
   signal S3_ACMP    : std_logic;              
   signal S4_ACMP    : std_logic;
   signal S5_ACMP    : std_logic;
   signal S6_ACMP    : std_logic;
   signal S7_ACMP    : std_logic;
   
--   attribute keep of S0_ACMP : signal is "true";   
--   attribute keep of S1_ACMP : signal is "true";   
     
--   signal S2_STB_I   : std_logic;                           
--   constant S2_ACK_O : std_logic := '0';
--   signal S2_DAT_O   : std_logic_vector(15 downto 0);     
   
--   constant S3_ACK_O : std_logic := '0';
--   signal S3_STB_I   : std_logic;   
--   signal S3_DAT_O   : std_logic_vector(15 downto 0);   
             
             
   signal M2_ACK_I   : std_logic;
   signal M2_ADR_O   : std_logic_vector(11 downto 0);
   signal M2_DAT_O   : std_logic_vector(15 downto 0); 
   signal M2_WE_O    : std_logic;        
   signal M2_STB_O   : std_logic;        
   constant M2_CYC_O : std_logic := '0';
      
   signal M3_ACK_I   : std_logic;       
   signal M3_ADR_O   : std_logic_vector(11 downto 0);   
   signal M3_DAT_O   : std_logic_vector(15 downto 0); 
   signal M3_WE_O    : std_logic;   
   signal M3_STB_O   : std_logic;
   constant M3_CYC_O : std_logic := '0'; 
   
   signal RST : std_logic;      
   
begin                     
   sync_RST : entity sync_reset
   port map(ARESET => ARESET, SRESET => RST, CLK => CLK);     
   ---------------------------------------------
   -- ADDRESS MAP
   ---------------------------------------------
   -- M0: 0x000 to 0x0FF
   -- M1: 0x100 to 0x1FF
   -- S0: 0x200 to 0x2FF
   -- S1: 0x300 to 0x3FF
   -- S2: 0x400 to 0x4FF
   -- S3: 0x500 to 0x5FF
   -- S4: 0x600 to 0x6FF
   -- S5: 0x700 to 0x7FF
   -- S6: 0x800 to 0x8FF
   -- S7: 0x900 to 0x9FF
   ---------------------------------------------
   
   -- Common bus signals
   M0_DAT_I <= DRD;
   M1_DAT_I <= DRD;  
   
   S0_ADR_I <= ADR;
   S1_ADR_I <= ADR;
   S2_ADR_I <= ADR;
   S3_ADR_I <= ADR;
   S4_ADR_I <= ADR;
   S5_ADR_I <= ADR;
   S6_ADR_I <= ADR;
   S7_ADR_I <= ADR;
   
   S0_DAT_I <= DWR;
   S1_DAT_I <= DWR;
   S2_DAT_I <= DWR;
   S3_DAT_I <= DWR;
   S4_DAT_I <= DWR;
   S5_DAT_I <= DWR;
   S6_DAT_I <= DWR;
   S7_DAT_I <= DWR;   
   
   S0_WE_I <= WE;
   S1_WE_I <= WE;    
   S2_WE_I <= WE;
   S3_WE_I <= WE;
   S4_WE_I <= WE;
   S5_WE_I <= WE;
   S6_WE_I <= WE;
   S7_WE_I <= WE;
   
   arbiter : entity arb0001a
   port map(
      CLK   => CLK,
      COMCYC=> CYC,
      CYC3  => M3_CYC_O,
      CYC2  => M2_CYC_O,
      CYC1  => M1_CYC_O,
      CYC0  => M0_CYC_O,
      GNT   => GNT, 
      GNT3  => GNT3,
      GNT2  => GNT2,
      GNT1  => GNT1,
      GNT0  => GNT0,
      RST   => RST
      );              
   
   
   ------------------------------------------------------------------
   -- Generate the address comparator and SLAVE decoders.
   ------------------------------------------------------------------
   
   S0_ACMP <= '1' when ADR(11 downto 8) = X"2" else '0';
   S1_ACMP <= '1' when ADR(11 downto 8) = X"3" else '0';
   S2_ACMP <= '1' when ADR(11 downto 8) = X"4" else '0';
   S3_ACMP <= '1' when ADR(11 downto 8) = X"5" else '0';
   S4_ACMP <= '1' when ADR(11 downto 8) = X"6" else '0';
   S5_ACMP <= '1' when ADR(11 downto 8) = X"7" else '0';
   S6_ACMP <= '1' when ADR(11 downto 8) = X"8" else '0';
   S7_ACMP <= '1' when ADR(11 downto 8) = X"9" else '0';      
   
   -- Address decoding
   S0_STB_I <= '1' when CYC='1' and STB='1' and S0_ACMP='1' else '0';
   S1_STB_I <= '1' when CYC='1' and STB='1' and S1_ACMP='1' else '0';
   S2_STB_I <= '1' when CYC='1' and STB='1' and S2_ACMP='1' else '0';
   S3_STB_I <= '1' when CYC='1' and STB='1' and S3_ACMP='1' else '0';
   S4_STB_I <= '1' when CYC='1' and STB='1' and S4_ACMP='1' else '0';
   S5_STB_I <= '1' when CYC='1' and STB='1' and S5_ACMP='1' else '0';
   S6_STB_I <= '1' when CYC='1' and STB='1' and S6_ACMP='1' else '0';
   S7_STB_I <= '1' when CYC='1' and STB='1' and S7_ACMP='1' else '0';
   
   
   ------------------------------------------------------------------
   -- Generate the ACK signals.
   ------------------------------------------------------------------

   ACK <= S7_ACK_O or S6_ACK_O or S5_ACK_O or S4_ACK_O or S3_ACK_O or S2_ACK_O or S1_ACK_O or S0_ACK_O;

   M3_ACK_I <= ACK and GNT3;
   M2_ACK_I <= ACK and GNT2;
   M1_ACK_I <= ACK and GNT1;
   M0_ACK_I <= ACK and GNT0;   
   
   ------------------------------------------------------------------
   -- Create the signal multiplexors.
   ------------------------------------------------------------------
   
   ADR_MUX: process( M3_ADR_O, M2_ADR_O, M1_ADR_O, M0_ADR_O, GNT)
   begin                                     
      
      case GNT is
         when B"00" =>  ADR <= M0_ADR_O;
         when B"01" =>  ADR <= M1_ADR_O;
         when B"10" =>  ADR <= M2_ADR_O;
         when others => ADR <= M3_ADR_O;
      end case;
      
   end process ADR_MUX;
   
   
   DRD_MUX : with ADR(11 downto 8) select DRD <=
      S0_DAT_O when X"2",
      S1_DAT_O when X"3",
      S2_DAT_O when X"4",
      S3_DAT_O when X"5",
      S4_DAT_O when X"6",
      S5_DAT_O when X"7",
      S6_DAT_O when X"8",
      S7_DAT_O when X"9",
      X"FFFF"  when others;

   
   DWR_MUX: process( M3_DAT_O, M2_DAT_O, M1_DAT_O, M0_DAT_O, GNT )
   begin                                     
      
      case GNT is
         when B"00" =>  DWR <= M0_DAT_O;
         when B"01" =>  DWR <= M1_DAT_O;
         when B"10" =>  DWR <= M2_DAT_O;
         when others => DWR <= M3_DAT_O;
      end case;
      
   end process DWR_MUX;
   
   
   STB_MUX: process( M3_STB_O, M2_STB_O, M1_STB_O, M0_STB_O, GNT )
   begin                                     
      
      case GNT is
         when B"00" =>  STB <= M0_STB_O;
         when B"01" =>  STB <= M1_STB_O;
         when B"10" =>  STB <= M2_STB_O;
         when others => STB <= M3_STB_O;
      end case;
      
   end process STB_MUX;
   
   
   WE_MUX: process( M3_WE_O, M2_WE_O, M1_WE_O, M0_WE_O, GNT )
   begin                                     
      
      case GNT is
         when B"00" =>  WE <= M0_WE_O;
         when B"01" =>  WE <= M1_WE_O;
         when B"10" =>  WE <= M2_WE_O;
         when others => WE <= M3_WE_O;
      end case;
      
   end process WE_MUX;    
   
end RTL;
