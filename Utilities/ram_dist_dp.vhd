---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: ram_dist_dp.vhd
--  Use: infered distributed ram with dual port (dual read port only)
--  By: Olivier Bourgois
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

entity ram_dist_dp is
    -- Dual port mapped onto distributed (LUT) ram (dual port has only read functionality)
    generic (
        D_WIDTH : integer := 16;
        A_WIDTH : integer := 8);
    port (
        CLK : in std_logic;
        WEA : in std_logic;
        ADDRA : in std_logic_vector(A_WIDTH-1 downto 0);
        DIA : in std_logic_vector(D_WIDTH-1 downto 0);
        DOA : out std_logic_vector(D_WIDTH-1 downto 0);
        ADDRB : in std_logic_vector(A_WIDTH-1 downto 0);
        DOB : out std_logic_vector(D_WIDTH-1 downto 0));
end ram_dist_dp;

architecture syn of ram_dist_dp is
   type ram_type is array ((2**A_WIDTH)-1 downto 0) of std_logic_vector (D_WIDTH-1 downto 0);  
   
   signal RAM : ram_type 
   -- translate_off
   := (others => (others => '0'))
   -- translate_on
   ;
   
   attribute ram_style: string;
   attribute ram_style of RAM: signal is "distributed";    
begin
    
    process (CLK)
    begin
        if (CLK'event and CLK = '1') then
            if (WEA = '1') then
                RAM(conv_integer(ADDRA)) <= DIA;
            end if;
        end if;
    end process;
    DOA <= RAM(conv_integer(ADDRA));
    DOB <= RAM(conv_integer(ADDRB));
    
end syn;