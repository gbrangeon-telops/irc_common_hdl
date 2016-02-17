-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- This design is confidential and proprietary of Xilinx, All Rights Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /   Vendor             : Xilinx
-- \   \   \/    Version            : $Name: i+IP+125372 $
--  \   \        Application        : MIG
--  /   /        Filename           : mem_interface_top_data_write_0.vhd
-- /___/   /\    Date Last Modified : $Date: 2007/04/18 13:49:26 $
-- \   \  /  \   Date Created       : Mon May 2 2005
--  \___\/\___\
--
-- Device      : Virtex-4
-- Design Name : DDR SDRAM
-- Description: Splits the user data into the rise data and the fall data.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.mem_interface_top_parameters_0.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity mem_interface_top_data_write_0 is
  port(
    CLK                 : in  std_logic;
    CLK90               : in  std_logic;
    RESET90             : in  std_logic;
    WDF_DATA            : in  std_logic_vector((data_width*2 -1) downto 0);
    MASK_DATA           : in  std_logic_vector((data_mask_width*2 -1) downto 0);
    dummy_write_pattern : in  std_logic;
    CTRL_WREN           : in  std_logic;
    CTRL_DQS_RST        : in  std_logic;
    CTRL_DQS_EN         : in  std_logic;
    dqs_rst             : out std_logic;
    dqs_en              : out std_logic;
    wr_en               : out std_logic;
    wr_data_rise        : out std_logic_vector((data_width -1) downto 0);
    wr_data_fall        : out std_logic_vector((data_width -1) downto 0);
    mask_data_rise      : out std_logic_vector((data_mask_width -1) downto 0);
    mask_data_fall      : out std_logic_vector((data_mask_width -1) downto 0)
    );
end mem_interface_top_data_write_0;

architecture arch of mem_interface_top_data_write_0 is

  signal wr_en_clk270_r1         : std_logic;
  signal wr_en_clk90_r3          : std_logic;
  signal dqs_rst_r1              : std_logic;
  signal dqs_en_r1               : std_logic;
  signal dqs_en_r2               : std_logic;
  signal dummy_flag              : std_logic;
  signal dummy_rise_pattern      : std_logic_vector((data_width-1) downto 0);
  signal dummy_fall_pattern      : std_logic_vector((data_width-1) downto 0);
  signal dummy_write_pattern_270 : std_logic;
  signal dummy_write_pattern_90  : std_logic;
  signal dummy_flag1             : std_logic;

  signal patA    : std_logic_vector(143 downto 0);
  signal pat5    : std_logic_vector(143 downto 0);
  signal pat9    : std_logic_vector(143 downto 0);
  signal pat6    : std_logic_vector(143 downto 0);
  signal rst90_r : std_logic;
begin

  dqs_rst <= dqs_rst_r1;
  dqs_en  <= dqs_en_r2;
  wr_en   <= wr_en_clk90_r3;

  patA <= X"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
  pat5 <= X"555555555555555555555555555555555555";
  pat9 <= X"999999999999999999999999999999999999";
  pat6 <= X"666666666666666666666666666666666666";

  process(CLK90)
  begin
    if(CLK90'event and CLK90 = '1') then
      rst90_r <= RESET90;
    end if;
  end process;

  process(CLK90)
  begin
    if(CLK90'event and CLK90 = '0') then
        wr_en_clk270_r1 <= CTRL_WREN;
        dqs_rst_r1      <= CTRL_DQS_RST;
        dqs_en_r1       <= not CTRL_DQS_EN;
    end if;
  end process;


  process(CLK)
  begin
    if(CLK'event and CLK = '0') then
        dqs_en_r2 <= dqs_en_r1;
    end if;
  end process;

  process(CLK90)
  begin
    if(CLK90'event and CLK90 = '1') then
        wr_en_clk90_r3 <= wr_en_clk270_r1;
    end if;
  end process;

  process(CLK90)
  begin
    if(CLK90'event and CLK90 = '0') then
        dummy_write_pattern_270 <= dummy_write_pattern;
    end if;
  end process;

  process(CLK90)
  begin
    if(CLK90'event and CLK90 = '1') then
        dummy_write_pattern_90 <= dummy_write_pattern_270;
    end if;
  end process;

  process(CLK90)
  begin
   if(CLK90'event and CLK90 = '1') then
     if(rst90_r = '1') then
        dummy_flag <= '0';
     elsif(dummy_write_pattern_90 = '1') then
        if(dummy_flag = '1') then
                dummy_rise_pattern <= patA((data_width-1) downto 0);
        else    
                dummy_rise_pattern <= pat9((data_width-1) downto 0);
        end if;
        dummy_flag <= not dummy_flag;
     end if;
   end if;
  end process;
  
  process(CLK90)
  begin
   if(CLK90'event and CLK90 = '1') then
     if(rst90_r = '1') then
        dummy_flag1 <= '0';
     elsif(dummy_write_pattern_90 = '1') then
        if(dummy_flag1 = '1') then
                dummy_fall_pattern <= pat5((data_width-1) downto 0);
        else    
                dummy_fall_pattern <= pat6((data_width-1) downto 0);
        end if;
        dummy_flag1 <= not dummy_flag1;
     end if;
   end if;
  end process;


  wr_data_rise <= dummy_rise_pattern when (dummy_write_pattern_90 = '1')
                   else WDF_DATA((data_width*2 -1) downto data_width);
  wr_data_fall <= dummy_fall_pattern when (dummy_write_pattern_90 = '1')
                   else WDF_DATA((data_width-1) downto 0);
  
  mask_data_rise <= (others => '0') when (dummy_write_pattern_90 = '1' or
                                          wr_en_clk90_r3 = '0') else 
                    MASK_DATA((data_mask_width*2 -1) downto data_mask_width);
  mask_data_fall <= (others => '0') when (dummy_write_pattern_90 = '1' or
                                          wr_en_clk90_r3 = '0') else 
                    MASK_DATA((data_mask_width-1) downto 0);


end arch;
