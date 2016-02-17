----------------------------------------------------------------------------
-- Copyright (c) 2001, Ben Cohen.   All rights reserved. 
-- Author of following books 
-- * Component Design by Example ... a Step-by-Step Process Using 
-- VHDL with UART as Vehicle", 2001 isbn 0-9705394-0-1
-- * VHDL Coding Styles and Methodologies, 2nd Edition, 1999 isbn 0-7923-8474-1
-- * VHDL Answers to Frequently Asked Questions, 2nd Edition, isbn 0-7923-8115
-- 
-- This source file for the WIRE model with delay may be used and
-- distributed without restriction provided that this copyright
-- statement is not removed from the file and that any derivative work
-- contains this copyright notice.

-- File name  : wiredly.vhd
-- Description: This package, entity, and architecture provide
--   the definition of a zero ohm component (A, B).
--
--   The applications of this component include:
--     . Normal operation of a jumper wire (data flowing in both directions)
--
--   The component consists of 2 ports:
--      . Port A: One side of the pass-through switch
--      . Port B: The other side of the pass-through switch

--   The model is sensitive to transactions on all ports.  Once a
--   transaction is detected, all other transactions are ignored
--   for that simulation time (i.e. further transactions in that 
--   delta time are ignored). 
--
-- Model Limitations and Restrictions:
--   Signals asserted on the ports of the error injector should not have
--   transactions occuring in multiple delta times because the model
--   is sensitive to transactions on port A, B ONLY ONCE during
--   a simulation time.  Thus, once fired, a process will
--   not refire if there are multiple transactions occuring in delta times.
--   This condition may occur in gate level simulations with
--   ZERO delays because transactions may occur in multiple delta times.
--
--
--
--=================================================================
-- Revisions:
--   Date   Author       Revision  Comment
-- 2/28/01 Ben Cohen    Rev A     Creation
--          VhdlCohen@aol.com
-------------------------------------------------------------
library IEEE;  
  use IEEE.Std_Logic_1164.all;

entity WireDelay is
  generic (Delay_g : time);
  port
    (A : inout Std_Logic;
     B : inout Std_Logic
     );
end WireDelay;


architecture WireDelay_a of WireDelay is
begin
  ABC0_Lbl: process
    variable ThenTime_v : time;
  begin
    wait on A'transaction, B'transaction 
                      until ThenTime_v /= now;
    -- Break
    wait for Delay_g;                   -- wire delay
    ThenTime_v := now;
    A <= 'Z';
    B <= 'Z';
    wait for 0 ns;

    -- Make
    A <= B;
    B <= A;
  end process ABC0_Lbl;
 end WireDelay_a;

--architecture WireDelay_a of WireDelay is
--	signal A_in : std_logic;
--	signal A_out : std_logic;
--	signal B_in : std_logic;
--	signal B_out : std_logic;
--begin
--	A_in <= to_X01(A);
--	A_in <= 'H';
--	
--	B_in <= to_X01(B);
--	B_in <= 'H';
--	
--	A <= A_out;
--	B <= B_out;
--	
--	A_out <= transport B_in after Delay_g + 1 ps;
--	B_out <= transport A_in after Delay_g;
--
--end WireDelay_a;







