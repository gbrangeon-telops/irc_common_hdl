-------------------------------------------------------------------------------
--
-- Title       : TMI_MDP_ZBT_Ctrl_a21_d24
-- Author      : Patrick Dubois
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--  $Revision$
--  $Author$
--  $LastChangedDate$
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;   
use IEEE.numeric_std.all;
library Common_HDL;
use Common_HDL.Telops.all;


entity TMI_MDP_ZBT_Ctrl_a21_d24 is
   generic(             
      ALEN : natural := 21;
      Gen_IDLY_CTRL : boolean := false; 
      Random_Pattern : boolean := true;
      SIM_TEST : boolean := true
      );
   port(
      ARESET   : in STD_LOGIC;
      CLK      : in STD_LOGIC;
      CLK200   : in STD_LOGIC; 
      
      TMI1_MOSI : in  t_tmi_mosi_a21_d24;
      TMI1_MISO : out t_tmi_miso_d24;
      
      TMI2_MOSI : in  t_tmi_mosi_a21_d24;
      TMI2_MISO : out t_tmi_miso_d24;  
      
      ZBT_ADV_LD_N : out STD_LOGIC;
      ZBT_BWA_N : out STD_LOGIC;
      ZBT_BWB_N : out STD_LOGIC;
      ZBT_BWC_N : out STD_LOGIC;
      ZBT_BWD_N : out STD_LOGIC;
      ZBT_CE_N : out STD_LOGIC;
      ZBT_MODE : out STD_LOGIC;
      ZBT_OE_N : out STD_LOGIC;
      ZBT_WE_N : out STD_LOGIC;
      ZBT_ADD : out STD_LOGIC_VECTOR(20 downto 0);
      ZBT_DATA : inout STD_LOGIC_VECTOR(23 downto 0);        
      
      SEL : in STD_LOGIC_VECTOR(1 downto 0);      
      IDELAY_CTRL_RDY : in STD_LOGIC;  
      TUNING_DONE : out std_logic;
      VALID_WINDOW : out STD_LOGIC_VECTOR(5 downto 0)
      );
end TMI_MDP_ZBT_Ctrl_a21_d24;

architecture RTL of TMI_MDP_ZBT_Ctrl_a21_d24 is
   
   signal zbt_add_i :  STD_LOGIC_VECTOR(ALEN-1 downto 0);      
   signal tmi1_add  : std_logic_vector(ALEN-1 downto 0);
   signal tmi2_add  : std_logic_vector(ALEN-1 downto 0);     
   
	component tmi_mdp_zbt_ctrl
	generic(
		ALEN : NATURAL := 21;
		DLEN : NATURAL := 23;
		Gen_IDLY_CTRL : BOOLEAN := false;
		Random_Pattern : BOOLEAN := true;
		SIM_tune : BOOLEAN := false;
		Fixed_Delay : INTEGER := 0;
		Delay_Adjust : BOOLEAN := true;
      SIM_TEST : BOOLEAN := true);
	port(
		ARESET : in STD_LOGIC;
		CLK : in STD_LOGIC;
		CLK200 : in STD_LOGIC;
		IDELAY_CTRL_RDY : in STD_LOGIC;
		TMI1_DVAL : in STD_LOGIC;
		TMI1_RNW : in STD_LOGIC;
		TMI2_DVAL : in STD_LOGIC;
		TMI2_RNW : in STD_LOGIC;
		SEL : in STD_LOGIC_VECTOR(1 downto 0);
		TMI1_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
		TMI1_WR_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
		TMI2_ADD : in STD_LOGIC_VECTOR(ALEN-1 downto 0);
		TMI2_WR_DATA : in STD_LOGIC_VECTOR(DLEN-1 downto 0);
		TMI1_BUSY : out STD_LOGIC;
		TMI1_ERROR : out STD_LOGIC;
		TMI1_IDLE : out STD_LOGIC;
		TMI1_RD_DVAL : out STD_LOGIC;
		TMI2_BUSY : out STD_LOGIC;
		TMI2_ERROR : out STD_LOGIC;
		TMI2_IDLE : out STD_LOGIC;
		TMI2_RD_DVAL : out STD_LOGIC;
		TUNING_DONE : out STD_LOGIC;
		ZBT_ADV_LD_N : out STD_LOGIC;
		ZBT_BWA_N : out STD_LOGIC;
		ZBT_BWB_N : out STD_LOGIC;
		ZBT_BWC_N : out STD_LOGIC;
		ZBT_BWD_N : out STD_LOGIC;
		ZBT_CE2 : out STD_LOGIC;
		ZBT_CE2_N : out STD_LOGIC;
		ZBT_CE_N : out STD_LOGIC;
		ZBT_CKE_N : out STD_LOGIC;
		ZBT_MODE : out STD_LOGIC;
		ZBT_OE_N : out STD_LOGIC;
		ZBT_WE_N : out STD_LOGIC;
		ZBT_ZZ : out STD_LOGIC;
		TMI1_RD_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		TMI2_RD_DATA : out STD_LOGIC_VECTOR(DLEN-1 downto 0);
		VALID_WINDOW : out STD_LOGIC_VECTOR(5 downto 0);
		ZBT_ADD : out STD_LOGIC_VECTOR(ALEN-1 downto 0);
		ZBT_DATA : inout STD_LOGIC_VECTOR(DLEN-1 downto 0));
	end component;   
   
begin       
   
   ZBT_ADD <= std_logic_vector(resize(unsigned(zbt_add_i), 21));
   tmi1_add <= TMI1_MOSI.ADD(ALEN-1 downto 0);
   tmi2_add <= TMI2_MOSI.ADD(ALEN-1 downto 0);       
      
   U1 : tmi_mdp_zbt_ctrl
   generic map(
      ALEN => ALEN,
      DLEN => 24,
      Gen_IDLY_CTRL => Gen_IDLY_CTRL,
      Random_Pattern => Random_Pattern,
      SIM_tune => false,
      Fixed_Delay => 37,
      Delay_Adjust => true,
      SIM_TEST => SIM_TEST
      )                       
   port map(
      ARESET => ARESET,
      CLK => CLK,
      CLK200 => CLK200,
      IDELAY_CTRL_RDY => IDELAY_CTRL_RDY,
      TMI1_DVAL => TMI1_MOSI.DVAL,
      TMI1_RNW => TMI1_MOSI.RNW,
      TMI2_DVAL => TMI2_MOSI.DVAL,
      TMI2_RNW => TMI2_MOSI.RNW,
      SEL => SEL,
      TMI1_ADD => tmi1_add,
      TMI1_WR_DATA => TMI1_MOSI.WR_DATA,
      TMI2_ADD => tmi2_add,
      TMI2_WR_DATA => TMI2_MOSI.WR_DATA,
      TMI1_BUSY => TMI1_MISO.BUSY,
      TMI1_ERROR => TMI1_MISO.ERROR,
      TMI1_IDLE => TMI1_MISO.IDLE,
      TMI1_RD_DVAL => TMI1_MISO.RD_DVAL,
      TMI2_BUSY => TMI2_MISO.BUSY,
      TMI2_ERROR => TMI2_MISO.ERROR,
      TMI2_IDLE => TMI2_MISO.IDLE,
      TMI2_RD_DVAL => TMI2_MISO.RD_DVAL,
      ZBT_ADV_LD_N => ZBT_ADV_LD_N,
      ZBT_BWA_N => ZBT_BWA_N,
      ZBT_BWB_N => ZBT_BWB_N,
      ZBT_BWC_N => ZBT_BWC_N,
      ZBT_BWD_N => ZBT_BWD_N,
      ZBT_CE2 => open,
      ZBT_CE2_N => open,
      ZBT_CE_N => ZBT_CE_N,
      ZBT_CKE_N => open,
      ZBT_MODE => ZBT_MODE,
      ZBT_OE_N => ZBT_OE_N,
      ZBT_WE_N => ZBT_WE_N,
      ZBT_ZZ => open,
      TMI1_RD_DATA => TMI1_MISO.RD_DATA,
      TMI2_RD_DATA => TMI2_MISO.RD_DATA,
      VALID_WINDOW => VALID_WINDOW,  
      TUNING_DONE => TUNING_DONE,
      ZBT_ADD => zbt_add_i,
      ZBT_DATA => ZBT_DATA
      );
   
end RTL;
