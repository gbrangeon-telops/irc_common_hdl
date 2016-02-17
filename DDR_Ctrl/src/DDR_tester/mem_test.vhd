---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2005
--
--  File: addr_test.vhd
--  Hierarchy: Sub-module file
--	 By: JDE
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_test is
   generic(
      ADDR_BITS : integer := 28;
      DATA_BITS : integer := 144;
      CMD_BITS  : integer := 3;
      CMD_WRITE : std_logic_vector(7 downto 0) := "00000100";
      CMD_READ  : std_logic_vector(7 downto 0) := "00000101"
   );
	port(
      -- mux control
      CLK            : in std_logic;
		ARESET         : in std_logic;
      ADDR_TEST_DONE : out std_logic;
      ADDR_TEST_PASS : out std_logic;
		-- address bits tester
		A_AFULL        : in  std_logic;
		A_DATA_OUT     : in  std_logic_vector(DATA_BITS-1 downto 0);
		A_DATA_VLD     : in  std_logic;
		A_CMD          : out std_logic_vector(CMD_BITS-1 downto 0);
		A_CMD_VALID    : out std_logic;
		A_ADDR         : out std_logic_vector(ADDR_BITS-1 downto 0);
		A_DATA_IN      : out std_logic_vector(DATA_BITS-1 downto 0);
      -- Error vectors
      DATA_BIT_ERR   : out std_logic_vector(DATA_BITS/2-1 downto 0);
      ADDR_BIT_ERR   : out std_logic_vector(ADDR_BITS-1 downto 0)
   );
end entity mem_test;

architecture rtl of mem_test is

   constant A_ONE : std_logic_vector(ADDR_BITS-1 downto 0) := (1 => '1', others => '0');
   constant A_LAST : std_logic_vector(ADDR_BITS-1 downto 0) := (0 => '0', others => '1');
   constant A_LAST_SIM : std_logic_vector(ADDR_BITS-1 downto 0) := (27 downto 11 => '0', 0 => '0', others => '1');
   constant A_ZEROS : std_logic_vector(ADDR_BITS-1 downto 0) := (others => '0');
   constant D_ZEROS : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
   constant D_ONES : std_logic_vector(DATA_BITS-1 downto 0) := (others => '1');
   type Addr_State_t is (DDR_WRITE, DDR_READ, DDR_READ_WAIT, DDR_WRITE_INV, DDR_READ_INV, DDR_READ_INV_WAIT, FINISHED);
   signal SRESET : std_logic;
   signal Addr_State : Addr_State_t;
   signal address_w : std_logic_vector(ADDR_BITS-1 downto 0);
   signal address_r : std_logic_vector(ADDR_BITS-1 downto 0);
   signal data : std_logic_vector(DATA_BITS-1 downto 0);
   signal DATA_BIT_ERR_i : std_logic_vector(DATA_BITS/2-1 downto 0);
   signal ADDR_BIT_ERR_i : std_logic_vector(ADDR_BITS-1 downto 0);

begin
   process(CLK, ARESET)
      variable temp : std_logic;
   begin
      if ARESET = '1' then
         SRESET <= '1'; 
         temp := '1'; 
      elsif rising_edge(CLK) then
         SRESET <= temp;
         temp := ARESET;
      end if;
   end process;   

   state : process(CLK)
	begin
      if rising_edge(CLK) then
         ADDR_TEST_DONE <= '0';
         ADDR_TEST_PASS <= '1';
         A_CMD <= (others => '0');
         A_CMD_VALID <= '0';
         if SRESET = '1' then
            Addr_State <= DDR_WRITE;
         else
            case Addr_State is
               when DDR_WRITE =>
                  if A_AFULL = '0' then
                     if address_w = A_LAST
                     -- translate off
                        or address_w = A_LAST_SIM
                     -- translate on
                     then
                        Addr_State <= DDR_READ;
                     end if;
                     A_CMD <= CMD_WRITE(CMD_BITS-1 downto 0);
                     A_CMD_VALID <= '1';
                  end if;
               when DDR_READ =>
                  if A_AFULL = '0' then
                     if address_r = A_LAST
                     -- translate off
                        or address_r = A_LAST_SIM
                     -- translate on
                     then
                        Addr_State <= DDR_READ_WAIT;
                     end if;
                     A_CMD <= CMD_READ(CMD_BITS-1 downto 0);
                     A_CMD_VALID <= '1';
                  end if;
               when DDR_READ_WAIT =>
                  if (address_w = A_LAST
                  -- translate off
                     or address_w = A_LAST_SIM
                  -- translate on
                     ) and A_DATA_VLD = '1' then
                     Addr_State <= DDR_WRITE_INV;
                  end if;
               when DDR_WRITE_INV =>
                  if A_AFULL = '0' then
                     if address_w = A_LAST
                     -- translate off
                        or address_w = A_LAST_SIM
                     -- translate on
                     then
                        Addr_State <= DDR_READ_INV;
                     end if;
                     A_CMD <= CMD_WRITE(CMD_BITS-1 downto 0);
                     A_CMD_VALID <= '1';
                  end if;
               when DDR_READ_INV =>
                  if A_AFULL = '0' then
                     if address_r = A_LAST
                     -- translate off
                        or address_r = A_LAST_SIM
                     -- translate on
                     then
                        Addr_State <= DDR_READ_INV_WAIT;
                     end if;
                     A_CMD <= CMD_READ(CMD_BITS-1 downto 0);
                     A_CMD_VALID <= '1';
                  end if;
               when DDR_READ_INV_WAIT =>
                  if (address_w = A_LAST
                  -- translate off
                     or address_w = A_LAST_SIM
                  -- translate on
                     ) and A_DATA_VLD = '1' then
                     Addr_State <= FINISHED;
                  end if;
               when FINISHED =>
                  ADDR_TEST_DONE <= '1';
                  if DATA_BIT_ERR_i = D_ZEROS(DATA_BITS/2-1 downto 0) and
                     ADDR_BIT_ERR_i = A_ZEROS then
                     ADDR_TEST_PASS <= '1';
                  else
                     ADDR_TEST_PASS <= '0';
                  end if;
                  Addr_State <= FINISHED;
               when others =>
                  Addr_State <= DDR_WRITE;
            end case;
         end if;
      end if;
	end process state;

   addr : process(CLK)
   begin
      if rising_edge(CLK) then
         if SRESET = '1' then
            address_w      <= (others => '0');
            address_r      <= (others => '0');
            A_ADDR         <= (others => '0');
            A_DATA_IN      <= (others => '0');
            DATA_BIT_ERR_i <= (others => '0');
            ADDR_BIT_ERR_i <= (others => '0');
         else
            if ((Addr_State = DDR_WRITE or Addr_State = DDR_WRITE_INV)and A_AFULL = '0') or (A_DATA_VLD = '1') then
               address_w <= std_logic_vector(unsigned(address_w) + unsigned(A_ONE));
               -- translate off
               if address_w = A_LAST_SIM then
                  address_w      <= (others => '0');
               end if;
               -- translate on
            end if;
            if ((Addr_State = DDR_READ or Addr_State = DDR_READ_INV) and A_AFULL = '0') then
               address_r <= std_logic_vector(unsigned(address_r) + unsigned(A_ONE));
               -- translate off
               if address_r = A_LAST_SIM then
                  address_r      <= (others => '0');
               end if;
               -- translate on
            end if;
            if (Addr_State = DDR_WRITE) or (Addr_State = DDR_WRITE_INV) then
               A_ADDR <= address_w;
            elsif (Addr_State = DDR_READ) or (Addr_State = DDR_READ_INV) then
               A_ADDR <= address_r;
            else
               A_ADDR <= (others => '0');
            end if;
            if Addr_State = DDR_WRITE then
               A_DATA_IN <= data;
            elsif Addr_State = DDR_WRITE_INV then
               A_DATA_IN <= not data;
            else
               A_DATA_IN <= (others => '0');
            end if;
            
            if A_DATA_VLD = '1' then
               DATA_BIT_ERR_i <= DATA_BIT_ERR_i
                                 or (A_DATA_OUT(DATA_BITS-1 downto DATA_BITS/2) xnor A_DATA_OUT(DATA_BITS/2-1 downto 0))
                                 ;
               if Addr_State = DDR_READ or Addr_State = DDR_READ_WAIT then
                  ADDR_BIT_ERR_i <= ADDR_BIT_ERR_i or (A_DATA_OUT(ADDR_BITS - 1 downto 0) xor address_w);
               elsif Addr_State = DDR_READ_INV or Addr_State = DDR_READ_INV_WAIT then
                  ADDR_BIT_ERR_i <= ADDR_BIT_ERR_i or (A_DATA_OUT(ADDR_BITS - 1 downto 0) xnor address_w);
               end if;
            end if;
         end if;
      end if;
   end process;
   
   data <= D_ONES(DATA_BITS/2 - ADDR_BITS - 1 downto 0) & not address_w & D_ZEROS(DATA_BITS/2 - ADDR_BITS - 1 downto 0) & address_w;

   DATA_BIT_ERR <= DATA_BIT_ERR_i;
   ADDR_BIT_ERR <= ADDR_BIT_ERR_i;

end rtl;					