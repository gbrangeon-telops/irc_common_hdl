-------------------------------------------------------------------------------
--
-- Title       : No Title
-- Design      : simple_mem
-- Author      : Jean-Philippe Déry
-- Company     : Telops Inc.
--
-------------------------------------------------------------------------------
--
-- File        : simple_mem.vhd
-- Generated   : Wed May 23 17:53:36 2007
--
-------------------------------------------------------------------------------
--
-- Description : Some code is taken from mt46v128m4.vhd full ddr model.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity simple_mem is
   generic(
      Sections_bits : integer := 15;-- An Arbitrary number of address MSBs can be assigned to memory sections.
      SectWidth_bits: integer := 12;-- With more (smaller) sections, each memory allocation will be smaller,
                                    -- but more frequent. Smaller sections are usefull when accessing memory
                                    -- in non-linear or random pattern. When a section is accessed for
                                    -- the first time, memory is allocated to store data of all section width.
      data_bits : integer := 8;     -- All address bits are used, so if some LSBs are always 0, don't connect them (to save memory)
      latency   : integer := 5 -- Latency for read accesses (0 gives data on clock cycle after U_CMD_VALID)
   );
   port(
      CLK            : in  std_logic;
      DATA_VLD       : out std_logic;
      DATA_RD        : out std_logic_vector(data_bits-1 downto 0);
      DATA_WR        : in  std_logic_vector(data_bits-1 downto 0);
      U_ADDR         : in  std_logic_vector(Sections_bits+SectWidth_bits-1 downto 0);
      U_CMD          : in  std_logic;  -- '0' for write access, '1' for read access
      U_CMD_VALID    : in  std_logic
   );
end simple_mem;

architecture SIMPLE of simple_mem is

   -- Array for Memory Access
   TYPE Array_ram_type IS ARRAY (2**SectWidth_bits - 1 DOWNTO 0) OF STD_LOGIC_VECTOR (data_bits - 1 DOWNTO 0);
   TYPE Array_ram_pntr IS ACCESS Array_ram_type;
   TYPE Array_ram_stor IS ARRAY (2**Sections_bits - 1 DOWNTO 0) OF Array_ram_pntr;
   TYPE Array_Strb_pipe is array (latency downto 0) of std_logic;
   TYPE Array_Data_pipe is array (latency downto 0) of std_logic_vector(data_bits-1 downto 0);

begin
   --
   -- Main Process
   --
   state_register : PROCESS(CLK)
      VARIABLE Width_addr : STD_LOGIC_VECTOR (SectWidth_bits - 1 DOWNTO 0);
      VARIABLE Sect_addr : STD_LOGIC_VECTOR (Sections_bits - 1 DOWNTO 0);
      -- Memory Banks
      VARIABLE Memory : Array_ram_stor;
      -- Latency pipe
      VARIABLE Data_vld_pipe : Array_Strb_pipe;
      VARIABLE Data_rd_pipe  : Array_Data_pipe;
      -- Initialize empty sections
      PROCEDURE Init_mem (Sect_index : INTEGER) IS
         VARIABLE i, j : INTEGER := 0;
      BEGIN
         IF Memory (Sect_index) = NULL THEN                    -- Check to see if section empty
           Memory (Sect_index) := NEW Array_ram_type;          -- Open new section for access
           FOR i IN (2**SectWidth_bits - 1) DOWNTO 0 LOOP      -- Filled section with zeros
               FOR j IN (data_bits - 1) DOWNTO 0 LOOP
                   Memory (Sect_index) (i) (j) := '0';
               END LOOP;
           END LOOP;
         END IF;
      END;
   BEGIN

      if CLK'event and CLK = '1' then
         -- Read latency pipes
         if latency /= 0 then
            Data_vld_pipe(latency downto 1) := Data_vld_pipe(latency-1 downto 0);
            Data_rd_pipe(latency downto 1)  := Data_rd_pipe(latency-1 downto 0);
         end if;
         Data_vld_pipe(0) := '0';
         Data_rd_pipe(0)  := (others => '0');

         if U_CMD_VALID = '1' then
            Sect_addr  := U_ADDR(Sections_bits+SectWidth_bits-1 downto SectWidth_bits);
            Width_addr := U_ADDR(SectWidth_bits-1 downto 0);
            -- Initialize Memory
            Init_mem (CONV_INTEGER(Sect_addr));
            -- Write
            if U_CMD = '0' then
               Memory (CONV_INTEGER(Sect_addr)) (CONV_INTEGER(Width_addr)) := DATA_WR;
            -- Read
            elsif U_CMD = '1' then
               Data_rd_pipe(0) := Memory (CONV_INTEGER(Sect_addr)) (CONV_INTEGER(Width_addr));
               Data_vld_pipe(0) := '1';
            end if;
         end if;
         -- Read output
         DATA_RD  <= Data_rd_pipe(latency);
         DATA_VLD <= Data_vld_pipe(latency);
      end if;

   END PROCESS;
   
end SIMPLE;
