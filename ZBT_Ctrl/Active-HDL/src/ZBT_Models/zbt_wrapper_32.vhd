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

entity zbt_wrapper_32 is
   port(
      CLK : in STD_LOGIC;		
      CKE_N : in STD_LOGIC; 
      CE2 : in STD_LOGIC;
      CE1_N : in std_logic;
      CE2_N : in std_logic;
      ADV_LD_N : in STD_LOGIC;
      WE_N : in STD_LOGIC;
      OE_N : in STD_LOGIC;
      LBO_N : in STD_LOGIC;
      BWA_N : in STD_LOGIC;
      BWB_N : in STD_LOGIC;
      BWC_N : in STD_LOGIC;
      BWD_N : in STD_LOGIC;
      ZZ : in std_logic;
      ADD : in std_logic_vector(17 downto 0);
      DQ : inout STD_LOGIC_VECTOR(31 downto 0)
      );
end zbt_wrapper_32;     

architecture mt55l256l32p of zbt_wrapper_32 is
   
begin
   
   ram : entity mt55l256l32p
   generic map(
      addr_bits => 18,
      data_bits => 32
      )
   port map(
      Dq => DQ,
      Addr => ADD,
      Lbo_n => LBO_n,
      Clk => CLK,
      Cke_n => Cke_n,
      Ld_n => ADV_Ld_n,
      Bwa_n => Bwa_n,
      Bwb_n => Bwb_n,
      Bwc_n => Bwc_n,
      Bwd_n => Bwd_n,
      Rw_n => WE_n,
      Oe_n => Oe_n,
      Ce_n => Ce1_n,
      Ce2_n => Ce2_n,
      Ce2 => Ce2,
      Zz => Zz
      );   
end mt55l256l32p;   

architecture idt71v65603 of zbt_wrapper_32 is
   constant GND : std_logic := '0';	  
   signal float : std_logic := 'Z';
begin                
   
   
   ram : entity idt71v65603
   generic map(
      InstancePath => DefaultInstancePath,
      TimingChecksOn => FALSE,
      MsgOn => TRUE,
      XOn => DefaultXon,
      SeverityMode => WARNING,
      TimingModel => DefaultTimingModel
      )
   port map(
      A0       => ADD(0),       
      A1       => ADD(1),       
      A2       => ADD(2),       
      A3       => ADD(3),       
      A4       => ADD(4),       
      A5       => ADD(5),       
      A6       => ADD(6),       
      A7       => ADD(7),       
      A8       => ADD(8),       
      A9       => ADD(9),       
      A10      => ADD(10),       
      A11      => ADD(11),       
      A12      => ADD(12),       
      A13      => ADD(13),       
      A14      => ADD(14),       
      A15      => ADD(15),       
      A16      => ADD(16),       
      A17      => ADD(17),
      DQA0 => DQ(0),       
      DQA1 => DQ(1),       
      DQA2 => DQ(2),       
      DQA3 => DQ(3),       
      DQA4 => DQ(4),       
      DQA5 => DQ(5),       
      DQA6 => DQ(6),       
      DQA7 => DQ(7),
      DQA8 => float,
      DQB0 => DQ(8), 
      DQB1 => DQ(9), 
      DQB2 => DQ(10),
      DQB3 => DQ(11),
      DQB4 => DQ(12),
      DQB5 => DQ(13),
      DQB6 => DQ(14),
      DQB7 => DQ(15),
      DQB8 => float,
      DQC0 => DQ(16), 
      DQC1 => DQ(17), 
      DQC2 => DQ(18),
      DQC3 => DQ(19),
      DQC4 => DQ(20),
      DQC5 => DQ(21),
      DQC6 => DQ(22),
      DQC7 => DQ(23),
      DQC8 => float,
      DQD0 => DQ(24), 
      DQD1 => DQ(25), 
      DQD2 => DQ(26),
      DQD3 => DQ(27),
      DQD4 => DQ(28),
      DQD5 => DQ(29),
      DQD6 => DQ(30),
      DQD7 => DQ(31),
      DQD8 => float,
      ADV      => ADV_LD_N,            
      R        => WE_N,
      CLKENNeg => CKE_N,
      BWDNeg => BWD_N,
      BWCNeg => BWC_N,
      BWBNeg => BWB_N,
      BWANeg => BWA_N,
      CE1Neg => CE1_N,
      CE2Neg => CE2_N,
      CE2 => CE2,
      CLK => CLK,
      ZZ => ZZ,
      LBONeg => LBO_N,
      OENeg => OE_N
      );    
   
   
end idt71v65603;
