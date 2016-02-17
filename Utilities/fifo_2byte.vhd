---========================= Start Description ========================---
--==                                                                  ==--
--== This module is a standalone two byte Autonomous Cascadable Dual  ==--
--== Port FIFO that has a single cycle latency. All the modules IO's  ==--
--== are registered which makes it ideal for use alongside other      ==--
--== modules that do not have time to register their IO's.            ==--
--==                                                                  ==--
---========================== End Description =========================---

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fifo_2byte IS
  GENERIC(
          --== Data Width ==--

          data_width : NATURAL := 32
         );
  PORT(
       --==  General Interface ==--

       RST     : IN  STD_LOGIC;
       CLK     : IN  STD_LOGIC;

       --== Input Interface ==--

       RX_DVAL : IN  STD_LOGIC;
       RX_BUSY : OUT STD_LOGIC;
       RX_DATA : IN  STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);

       --== Output Interface ==--

       TX_DVAL : OUT STD_LOGIC;
       TX_BUSY : IN  STD_LOGIC;
       TX_DOUT : OUT STD_LOGIC_VECTOR(data_width-1 DOWNTO 0)
      );
END fifo_2byte;


ARCHITECTURE rtl OF fifo_2byte IS

   attribute KEEP_HIERARCHY : string;
   attribute KEEP_HIERARCHY of RTL: architecture is "true";

---=======================---
--== Signal Declarations ==--
---=======================---

SIGNAL RX_BUSY_i  : STD_LOGIC;
SIGNAL TX_DVAL_i : STD_LOGIC;
SIGNAL store   : STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);

BEGIN

  ---========================---
  --== FIFO RX_BUSY flag logic ==--
  ---========================---

  PROCESS(CLK)
  BEGIN
    IF RISING_EDGE(CLK) THEN
      IF (RST = '1') THEN
        RX_BUSY_i <= '0'; 
      ELSE
        RX_BUSY_i <= (TX_DVAL_i) AND TX_BUSY AND (RX_BUSY_i OR RX_DVAL);
      END IF;
    END IF;
  END PROCESS;

  RX_BUSY <= RX_BUSY_i or RST;

  ---=========================---
  --== FIFO TX_DVAL flag logic ==--
  ---=========================---

  PROCESS(CLK)
  BEGIN
    IF RISING_EDGE(CLK) THEN
      IF (RST = '1') THEN
        TX_DVAL_i <= '0';
      ELSE
        TX_DVAL_i <= not (NOT(RX_BUSY_i) AND (not RX_DVAL) AND (not TX_DVAL_i OR NOT(TX_BUSY)));
      END IF;
    END IF;
  END PROCESS;

  TX_DVAL <= TX_DVAL_i;

  ---===============---
  --== FIFO memory ==--
  ---===============---

  PROCESS(CLK)
  BEGIN
    IF RISING_EDGE(CLK) THEN
      IF (RST = '1') THEN
        store <= (OTHERS => '0');
      ELSIF (RX_BUSY_i = '0') THEN
        store <= RX_DATA;
      END IF;
    END IF;
  END PROCESS;

  ---=======================---
  --== FIFO data out logic ==--
  ---=======================---

  PROCESS(CLK)
  BEGIN
    IF RISING_EDGE(CLK) THEN
      IF (RST = '1') THEN
        TX_DOUT <= (OTHERS => '0');
      ELSIF (TX_DVAL_i = '0') OR (TX_BUSY = '0') THEN
        CASE RX_BUSY_i IS
          WHEN '0' => TX_DOUT <= RX_DATA;
          WHEN '1' => TX_DOUT <= store;
          WHEN OTHERS => NULL;
        END CASE;
      END IF;
    END IF;
  END PROCESS;

END rtl;
