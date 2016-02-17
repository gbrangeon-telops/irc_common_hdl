---------------------------------------------------------------------------------------------------
--
-- Title       : zbt_wrapper
-- Design      : DPB_CACHE
-- Author      : Patrick Dubois
-- Company     : Telops
--
---------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;	
USE work.gen_utils.ALL;

entity zbt_wrapper_v2 is  
   generic(
      ALEN : natural := 20;
      DLEN : natural := 16;
      INIT_FILE_BANK0 : string := "zero";
      INIT_FILE_BANK1 : string := "zero");
   port(
      CLK : in STD_LOGIC;		
      --CKE_N : in STD_LOGIC; 
      --CE2 : in STD_LOGIC;
      --CE1_N : in std_logic;
      CE2_N : in std_logic;
      ADV_LD_N : in STD_LOGIC;
      WE_N : in STD_LOGIC;
      OE_N : in STD_LOGIC;
      LBO_N : in STD_LOGIC;
      BWA_N : in STD_LOGIC;
      BWB_N : in STD_LOGIC; 
      BWC_N : in STD_LOGIC;
      BWD_N : in STD_LOGIC;      
      --ZZ : in std_logic;
      ADD : in std_logic_vector(ALEN-1 downto 0);
      DQ : inout STD_LOGIC_VECTOR(DLEN-1 downto 0)
      );
end zbt_wrapper_v2;    

--architecture flexible of zbt_wrapper is
--   constant GND : std_logic := '0';	  
--   signal dummy : std_logic_vector(1 downto 0) := "ZZ";
--begin   
--   
--   RAM : entity mt55l256l32p
--   generic map (
--      addr_bits => ALEN,
--      data_bits => DLEN,
--      tAVKH => 1.4 ns,
--      tCVKH => 1.4 ns,
--      tDVKH => 1.4 ns,
--      tEVKH => 1.4 ns,
--      tKHAX => 0.4 ns,
--      tKHCX => 0.4 ns,
--      tKHDX => 0.4 ns,
--      tKHEX => 0.4 ns,
--      tKHKH => 5.0 ns,
--      tKHKL => 2.0 ns,
--      tKHQV => 3.1 ns,
--      tKLKH => 2.0 ns
--      )
--   port map(
--      Addr => ADD,
--      Bwa_n => BWA_N,
--      Bwb_n => BWB_N,
--      Bwc_n => BWC_N,
--      Bwd_n => BWD_N,
--      Ce2 => '1',
--      Ce2_n => CE2_N,
--      Ce_n => '0',
--      Cke_n => '0',
--      Clk => CLK,
--      Dq => DQ,
--      Lbo_n => LBO_N,
--      Ld_n => ADV_LD_N,
--      Oe_n => OE_N,
--      Rw_n => WE_N,
--      Zz => '0'
--      );    
--end flexible;	

architecture generic_zbt_v2 of zbt_wrapper_v2 is
   constant GND : std_logic := '0';	  
   signal dummy : std_logic_vector(1 downto 0) := "ZZ";
begin
   
   ram : ENTITY generic_zbt_v2
   generic map(   
      ALEN => ALEN,
      DLEN => DLEN,
      INIT_FILE_BANK0 => INIT_FILE_BANK0,
      INIT_FILE_BANK1 => INIT_FILE_BANK1,
      timing_checks_on => FALSE
      )
   
   PORT MAP(	  	 
      Dq	      => DQ,  
      Addr	   => ADD,
      Mode	   =>	LBO_N,
      Clk		=>	CLK,
      CEN_N		=>	'0',
      AdvLd_n	=>	ADV_LD_N,
      Bwa_n		=>	BWA_N,
      Bwb_n		=>	BWB_N,
      Rw_n		=>	WE_N,
      Oe_n		=>	OE_N,
      Ce1_n		=>	'0',
      Ce2		=>	'1',
      Ce3_n		=>	CE2_N,
      Zz			=>	'0'
      );          
end generic_zbt_v2;	  

--architecture NOT_WORKING_DO_NOT_USE of zbt_wrapper is
--	constant GND : std_logic := '0';	  
--	signal dummy : std_logic_vector(1 downto 0) := "ZZ";
--begin
--
--		ram : ENTITY work.idt71v65803	 
--		GENERIC MAP(
--			-- generic control parameters
--			InstancePath        => DefaultInstancePath,
--			TimingChecksOn      => FALSE,
--			MsgOn               => TRUE,
--			XOn                 => DefaultXon,
--			SeverityMode        => WARNING,
--			-- For FMF SDF technology file usage
--			TimingModel         => DefaultTimingModel
--			)	
--		PORT MAP(
--			A0       => ADD(0),       
--			A1       => ADD(1),       
--			A2       => ADD(2),       
--			A3       => ADD(3),       
--			A4       => ADD(4),       
--			A5       => ADD(5),       
--			A6       => ADD(6),       
--			A7       => ADD(7),       
--			A8       => ADD(8),       
--			A9       => ADD(9),       
--			A10      => ADD(10),       
--			A11      => ADD(11),       
--			A12      => ADD(12),       
--			A13      => ADD(13),       
--			A14      => ADD(14),       
--			A15      => ADD(15),       
--			A16      => ADD(16),       
--			A17      => ADD(17),       
--			A18      => ADD(18),       
--			DQA0     => DQ(0),       
--			DQA1     => DQ(1),       
--			DQA2     => DQ(2),       
--			DQA3     => DQ(3),       
--			DQA4     => DQ(4),       
--			DQA5     => DQ(5),       
--			DQA6     => DQ(6),       
--			DQA7     => DQ(7),       
--			DQA8     => DQ(8),       
--			DQB0     => DQ(9),       
--			DQB1     => DQ(10),       
--			DQB2     => DQ(11),       
--			DQB3     => DQ(12),       
--			DQB4     => DQ(13),       
--			DQB5     => DQ(14),       
--			DQB6     => DQ(15),       
--			DQB7     => open,       
--			DQB8     => open,       
--			ADV      => ADV_LD_N,            
--			R        => WE_N,              
--			CLKENNeg => CKE_N,       
--			BWBNeg   => BWA_N,         
--			BWANeg   => BWB_N,         
--			CE1Neg   => CE1_N,         
--			CE2Neg   => CE2_N,         
--			CE2      => CE2,            
--			CLK      => CLK,            
--			ZZ       => ZZ,             
--			LBONeg   => MODE,         
--			OENeg    => OE_N          
--			);
--	
--end idt71v65803;
