---------------------------------------------------------------------------------------------------
--  Copyright (c) Telops Inc. 2007
--
--  File: caml_receiver.vhd
--  Use:  This block generates debug signals from cameralink stream and saves binary dcube files
--        as in the real hardware
--  By:   Patrick Dubois & Olivier Bourgois
--
--  note: logging to file has not been re-implemented to prevent clutter and unnecessary
--  maintenance overhead. Standard binary datacubes can be readily analyzed with our standard
--  matlab scripts
--
--  $Revision$
--  $Author$
--  $LastChangedDate$
--
---------------------------------------------------------------------------------------------------
-- translate_off
library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Common_HDL;
use Common_HDL.telops_testing.all; -- added binary file functions to telops_testing package
use work.DPB_Define.all;

entity caml_receiver is
   generic(
      filepath : string := "$DSN\log\dcubes\";
      filename : string := "datacube_";
      endianness : string := "big"); 
   port(
      CAML_A : in STD_LOGIC_vector(7 downto 0);
      CAML_B : in STD_LOGIC_vector(7 downto 0);
      CAML_C : in STD_LOGIC_vector(7 downto 0);
      CAML_X_CLK : in std_logic;
      CAML_X_DVAL : in std_logic;
      CAML_X_FVAL : in std_logic;
      CAML_X_LVAL : in std_logic;
      CAML_D : in STD_LOGIC_vector(7 downto 0);
      CAML_E : in STD_LOGIC_vector(7 downto 0);
      CAML_F : in STD_LOGIC_vector(7 downto 0);
      CAML_Y_CLK : in std_logic;
      CAML_Y_DVAL : in std_logic;
      CAML_Y_FVAL : in std_logic;
      CAML_Y_LVAL : in std_logic;
      CAML_G : in STD_LOGIC_vector(7 downto 0);
      CAML_H : in STD_LOGIC_vector(7 downto 0);
      CAML_Z_CLK : in std_logic;
      CAML_Z_DVAL : in std_logic;
      CAML_Z_FVAL : in std_logic;
      CAML_Z_LVAL : in std_logic;
      CONFIG_PARAM : in DPBConfig
      );
end caml_receiver;

architecture asim of caml_receiver is
   
   signal DCUBE_header_data : DCUBE_Header_Part1_array_v4;--DCUBE_HEADER_V3_array;
   signal DCUBE_footer_data : DCUBE_Header_Part2_array_v4;--;DCUBE_FOOTER_V3_array;
   
   --signal DCUBE_footer_struct : DCUBE_Header_Part2_v4; -- Not implemented yet for V4
   
   constant climit1 : integer := DCUBE_header_data'length;
   constant climit2 : integer := DCUBE_footer_data'length;
   
   constant FFT_H : integer := 20;
   constant FFT_WIDTH : integer := 21;
   
   signal exponent : std_logic_vector(4 downto 0);
   signal real_part : signed(FFT_H downto 0);
   signal imag_part : signed(FFT_H downto 0);
   signal Img_Tag : std_logic_vector(FFT_H downto 0);
   signal FFTSIZE : unsigned(15 downto 0);         
   
   file BinFile : BINARY;
   
begin
   
  -- DCUBE_footer_struct <= to_DCUBE_header_part2_V4(DCUBE_footer_data);
   
   -- new binary write process which really write to binary and supports cameralink full when CAML_Z_DVAL activity is detected
   binary_write : process  
      variable previous_fval : std_logic;  
      variable word16 : std_logic_vector(15 downto 0); 
      variable cube_number : integer := 1;
      variable linebuf : LINE;
      
   begin       
      main_loop : loop        
         wait until rising_edge(CAML_X_CLK);                     
         
         if CAML_X_FVAL='1' and CAML_X_LVAL='1' then
            -- file open as necessary when a new fval starts
            if previous_fval = '0' then
               --bin_filename := filepath & filename & cube_number'IMAGE & ".raw";
               write(linebuf, filepath);
               write(linebuf, filename); 
               write(linebuf, integer'IMAGE(cube_number));  
               write(linebuf, string'(".raw")); 
               file_open(BinFile, linebuf.all, WRITE_MODE); 
               deallocate(linebuf);
            end if;  
            
            if endianness = "big" then
               if CAML_Z_FVAL = '1' then
                  -- full mode transfer 
                  write(BinFile, CAML_B);
                  write(BinFile, CAML_A);
                  write(BinFile, CAML_D);
                  write(BinFile, CAML_C);
                  write(BinFile, CAML_F);
                  write(BinFile, CAML_E);
                  write(BinFile, CAML_H);
                  write(BinFile, CAML_G);
               else
                  -- base mode transfer 
                  write(BinFile, CAML_B);
                  write(BinFile, CAML_A);
               end if;
            elsif endianness = "little" then
               if CAML_Z_FVAL = '1' then
                  -- full mode transfer 
                  write(BinFile, CAML_A);
                  write(BinFile, CAML_B);
                  write(BinFile, CAML_C);
                  write(BinFile, CAML_D);
                  write(BinFile, CAML_E);
                  write(BinFile, CAML_F);
                  write(BinFile, CAML_G);
                  write(BinFile, CAML_H);
               else
                  -- base mode transfer 
                  write(BinFile, CAML_A);
                  write(BinFile, CAML_B);
               end if;
           end if;       
            
         end if;  
         
         if CAML_X_FVAL='0' and previous_fval = '1' then
            -- We need to close the file.
            file_close(BinFile);
            cube_number := cube_number + 1;
         end if;
         
         previous_fval := CAML_X_FVAL;
         
      end loop main_loop;
   end process;
   
   main_proc : process
      variable i: integer := 1;
      variable j: integer := 1;
      variable k: integer := 1;
      variable L : line;
      variable HeaderSize : unsigned(15 downto 0);
   begin		 
      
      main_loop : loop
         -- wait for defined CAML_FVAL
         wait until CAML_X_FVAL = '0';
         
         -- wait for new frame
         wait until rising_edge(CAML_X_FVAL);
         i := 1;
         j := 1;
         k := 1;       
         HeaderSize := to_unsigned(300, 16);
         while i <= HeaderSize loop
            wait until rising_edge(CAML_X_CLK);
            exponent <= (others => 'U'); 
            real_part <= (others => 'U');
            imag_part <= (others => 'U');
            wait for 0.5 ns;
            if CAML_X_LVAL='1' and CAML_X_DVAL='1' and CAML_X_FVAL='1' then
               if i <= climit1 then
                  DCUBE_header_data(i) <= CAML_B & CAML_A;
               elsif j <= climit2 then 
                  --HeaderSize := 
                  DCUBE_footer_data(i-climit1) <= CAML_B & CAML_A;
                  j := j + 1;
               end if;
               i := i + 1;
            end if;
         end loop;
         
         --if CONFIG_PARAM.DP_Mode = "01" then
         if FALSE then
            -- Configure FFTSIZE
            if CONFIG_PARAM.SpectralBand_Param.Mode = "00" then
               if CONFIG_PARAM.Fringe_Total <= 64 then
                  FFTSIZE <= to_unsigned(64, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 128 then
                  FFTSIZE <= to_unsigned(128, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 256 then
                  FFTSIZE <= to_unsigned(256, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 512 then
                  FFTSIZE <= to_unsigned(512, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 1024 then
                  FFTSIZE <= to_unsigned(1024, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 2048 then
                  FFTSIZE <= to_unsigned(2048, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 4096 then
                  FFTSIZE <= to_unsigned(4096, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 8192 then
                  FFTSIZE <= to_unsigned(8192, FFTSIZE'LENGTH);
               elsif CONFIG_PARAM.Fringe_Total <= 16384 then
                  FFTSIZE <= to_unsigned(16384, FFTSIZE'LENGTH);
               else
                  FFTSIZE <= (others => '0');
               end if;	  
            else
               FFTSIZE <= resize(2*(CONFIG_PARAM.SpectralBand_Param.Max - CONFIG_PARAM.SpectralBand_Param.Min + 1), FFTSIZE'LENGTH);
            end if;			
            
            -- Acquire Image Tags
            i := 1;
            while i <= (to_integer(CONFIG_PARAM.TAGSIZE) * to_integer(CONFIG_PARAM.Fringe_Total)) loop
               wait until rising_edge(CAML_X_CLK);
               wait for 0.5 ns;
               if CAML_X_LVAL='1' and CAML_X_DVAL='1' and CAML_X_FVAL='1' then  
                  if FFT_WIDTH = 20 then
                     Img_Tag <= CAML_C(3 downto 0) & CAML_B & CAML_A;
                  elsif FFT_WIDTH = 16 then
                     Img_Tag <= CAML_B & CAML_A;	
                  else
                  end if;
                  i := i + 1;
               else
                  Img_Tag <= (others => 'U');
               end if;
               wait for 0.5 ns;
            end loop;
            
            xy_loop : while k <= (to_integer(CONFIG_PARAM.XSIZE) * to_integer(CONFIG_PARAM.YSIZE)) loop
               
               j := 1;
               -- Acquire exponent
               loop
                  wait until rising_edge(CAML_X_CLK);
                  real_part <= (others => 'U');
                  imag_part <= (others => 'U');
                  wait for 0.5 ns;
                  if CAML_X_LVAL='1' and CAML_X_DVAL='1' and CAML_X_FVAL='1' then
                     exponent <= CAML_A(4 downto 0);
                     exit;
                  end if;
               end loop;
               
               z_loop : while j <= (to_integer(FFTSIZE)/2 + 1) loop
                  -- Acquire real part
                  loop
                     wait until rising_edge(CAML_X_CLK);
                     wait for 0.5 ns;
                     if CAML_X_LVAL='1' and CAML_X_DVAL='1' and CAML_X_FVAL='1' then  
                        if FFT_WIDTH = 20 then
                           real_part <= signed(CAML_C(3 downto 0) & CAML_B & CAML_A);
                        elsif FFT_WIDTH = 16 then 
                           real_part <= signed(CAML_B & CAML_A);	
                        else
                        end if;
                        exit;
                     else
                        real_part <= (others => 'U');	
                     end if;
                  end loop;
                  
                  
                  -- Acquire imaginary part
                  loop
                     wait until rising_edge(CAML_X_CLK);
                     wait for 0.5 ns;
                     if CAML_X_LVAL='1' and CAML_X_DVAL='1' and CAML_X_FVAL='1' then 
                        if FFT_WIDTH = 20 then
                           imag_part <= signed(CAML_C(3 downto 0) & CAML_B & CAML_A);
                        elsif FFT_WIDTH = 16 then 
                           imag_part <= signed(CAML_B & CAML_A);	
                        else
                        end if;
                        exit;
                     else
                        imag_part <= (others => 'U');	
                     end if;
                  end loop;
                  
                  j := j + 1;	
               end loop z_loop;
               
               k := k + 1;
            end loop xy_loop; 
         end if;
         
      end loop main_loop;
      
   end process;
   
end asim;
-- translate_on
