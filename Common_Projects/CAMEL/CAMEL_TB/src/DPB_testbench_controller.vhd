---------------------------------------------------------------------------------------------------
--
-- Title       : DPB_testbench_controller
-- Design      : Global_SIM
-- Author      : Patrick Dubois
-- Company     : Telops
--
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
--
-- Description : 
--
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.numeric_std.ALL;    
use ieee.math_real.all;
library Common_HDL;
use work.CAMEL_Define.ALL;
use work.DPB_Define.ALL;

library IEEE_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.float_pkg.all;

entity DPB_testbench_controller is
   generic(
      Vp7Only           : boolean := true);
   port(  
      INPUT_FILE        : out string(1 to 255);  
      USE_FILE          : out std_logic;
      QUERY_94          : out std_logic;
      VP30_DONE         : in  std_logic;
      HEADER43          : out DCUBE_HEADER_array;
      HEADER44          : out DCUBE_Header_part1_array8_v4;
      CAML_FVAL         : in  std_logic;
      CLINK_DONE        : in  std_logic;
      ROIC_EMPTY        : in  std_logic;
      DIAG_DONE         : in  std_logic;
      ROIC_DONE         : in  std_logic;
      RS232_DONE 			: in 	std_logic;
      CONFIG_PARAM 		: buffer DPBConfig;
      CLINK_CONFIG 		: buffer CLinkConfig;
      PROC_CONFIG 		: buffer DPConfig;     
      MISSING_IMAGES    : out integer;
      RS232_SEND_CFG 	: out std_logic; 
      VP7_JMP				: out std_logic_vector(3 downto 0);
      RS232_TYPE 			: out t_RS232;
      RESET_OUT_N			: out	std_logic;
      RS232_MODE			: out std_logic_vector(2 downto 0); 
      DIAG_ACQ_NUM      : out std_logic_vector(3 downto 0);
      MODE_INPUT_SEL    : out std_logic;
      CLK 					: in 	std_logic;
      ROIC_PG_CTRL      : out PatGenConfig;
      ROIC_PG_RESET     : out std_logic
      );
end DPB_testbench_controller;

architecture sim of DPB_testbench_controller is    
   signal acq_num : integer;
   signal avg_acq : integer;
   signal Diag_Source : std_logic; 
   signal one : integer := 1;
   signal DP_Mode : std_logic_vector(DPMODELEN-1 downto 0);
   signal ImagePause : unsigned(15 downto 0) := (others => '0');                                            
   
   function to_SB_Min_RS232(SB_Min_Wavenumber: real; Sampling_Distance: real; ZSIZE: unsigned) return natural is
      constant Laser_Wavelength_CM : real := 6.328e-5; 
      variable dx : real; -- Delta X, Optical Path Difference between each sample point
      variable ds : real; -- Delta Sigma, wavenumber grid spacing  
      variable SB_Min_RS232 : natural;         
   begin

      dx := Laser_Wavelength_CM * Sampling_Distance;
      ds := 1.0/(real(to_integer(ZSIZE))*dx);
      SB_Min_RS232 := natural(floor(SB_Min_Wavenumber / ds));
      
      return SB_Min_RS232;
   end to_SB_Min_RS232;  
   
   function to_SB_Max_RS232(SB_Max_Wavenumber: real; Sampling_Distance: real; ZSIZE: unsigned) return natural is
      constant Laser_Wavelength_CM : real := 6.328e-5; 
      variable dx : real; -- Delta X, Optical Path Difference between each sample point
      variable ds : real; -- Delta Sigma, wavenumber grid spacing  
      variable SB_Max_RS232 : natural;         
   begin

      dx := Laser_Wavelength_CM * Sampling_Distance;
      ds := 1.0/(real(to_integer(ZSIZE))*dx);
      SB_Max_RS232 := natural(ceil(SB_Max_Wavenumber / ds));
      
      return SB_Max_RS232;
   end to_SB_Max_RS232;     
   
begin 
   
   CONFIG_PARAM <= to_DPBConfig(PROC_CONFIG, CLINK_CONFIG);
   
 
   
   sim_proc : process
      procedure Init is
      begin            
         USE_FILE <= '0';
         INPUT_FILE <= (others => nul);
         RS232_SEND_CFG <= '0';				
         VP7_JMP <= "1111";	
         MISSING_IMAGES <= 0;
         RESET_OUT_N <= '0';	
         QUERY_94 <= '0';
         ROIC_PG_RESET <= '1';
         ROIC_PG_CTRL.Trig <= '0';
         ROIC_PG_CTRL.FrameType <= x"00";
         ROIC_PG_CTRL.XSize <= (others => '0');
         ROIC_PG_CTRL.YSize <= (others => '0');
         ROIC_PG_CTRL.ZSize <= (others => '0');
         ROIC_PG_CTRL.DiagSize <= (others => '0');
         ROIC_PG_CTRL.PayloadSize <= (others => '0');
         ROIC_PG_CTRL.TagSize <= (others => '0');
         ROIC_PG_CTRL.DiagMode <= (others => '0');
         ROIC_PG_CTRL.ImagePause <= (others => '0');
         wait for 1 us;		  
         RESET_OUT_N <= '1';           
         wait for 1 us;		  
      end procedure Init;   
      
      procedure SendCmd43 is
      begin
         -- Send new config
         if RS232_DONE = '0' then
            wait until RS232_DONE = '1';
         end if;
         RS232_TYPE <= CMD_43;
         RS232_SEND_CFG <= '1'; 		  
         wait until RS232_DONE = '0';
         RS232_SEND_CFG <= '0';	
         wait until RS232_DONE = '1'; 
         wait for 4 us; -- wait for config to reach VP30	      
      end procedure SendCmd43; 
      
      procedure SendCmd44 is
      begin
         -- Send new config
         if RS232_DONE = '0' then
            wait until RS232_DONE = '1';
         end if;
         RS232_TYPE <= CMD_44;
         RS232_SEND_CFG <= '1'; 		  
         wait until RS232_DONE = '0';
         RS232_SEND_CFG <= '0';	
         wait until RS232_DONE = '1'; 
         wait for 4 us; -- wait for config to reach DPB
      end procedure SendCmd44; 
                  
      procedure WaitForDPBDone is
      begin
         QUERY_94 <= '1';
         wait for 1 us;
         if RS232_DONE = '0' then              
            wait until RS232_DONE = '1';
         end if; 
         
         wait_for_done_loop : 
            while VP30_DONE = '0' loop
            wait for 1 us;
            if RS232_DONE = '0' then              
               wait until RS232_DONE = '1';
            end if;   
         end loop wait_for_done_loop;
         
         QUERY_94 <= '0';                           
      end procedure WaitForDPBDone;  
      
      procedure SendCLinkConfig is
      begin
         -- Send new config
         if RS232_DONE = '0' then              
            wait until RS232_DONE = '1';
         end if; 
         
         RS232_TYPE <= CMD_60;
         RS232_SEND_CFG <= '1'; 		  
         wait until RS232_DONE = '0';
         RS232_SEND_CFG <= '0';	
         wait until RS232_DONE = '1';      
         
      end procedure SendCLinkConfig;   
      
      procedure SendDPConfig is
      begin
         -- Send new config
         if RS232_DONE = '0' then              
            wait until RS232_DONE = '1';
         end if; 
         
         RS232_TYPE <= CMD_61;
         RS232_SEND_CFG <= '1'; 		  
         wait until RS232_DONE = '0';
         RS232_SEND_CFG <= '0';	
         wait until RS232_DONE = '1';         
         
         --wait for 5 us; -- wait for config to reach VP30	
      end procedure SendDPConfig;        
      
      procedure SendRS232Config is
      begin
         SendCLinkConfig;
         SendDPConfig;
      end procedure SendRS232Config;   
      
      procedure StartROICDiag (signal ACQ_NUM : in integer; signal ImagePause : in unsigned(15 downto 0)) is
         constant CameraMode : boolean := false;
      begin
         -- Start acquisition
         ROIC_PG_CTRL.FrameType <= X"00";
         ROIC_PG_CTRL.XSize <= PROC_CONFIG.XSIZE;
         ROIC_PG_CTRL.YSize <= PROC_CONFIG.YSIZE;
         ROIC_PG_CTRL.ZSize <= PROC_CONFIG.ZSIZE;
         ROIC_PG_CTRL.DiagSize <= to_unsigned(ACQ_NUM,DIAGSIZELEN);
         ROIC_PG_CTRL.PayloadSize <= to_unsigned(to_integer(PROC_CONFIG.XSIZE * PROC_CONFIG.YSIZE) + to_integer(PROC_CONFIG.TAGSIZE), PLLEN);
         ROIC_PG_CTRL.TagSize <= PROC_CONFIG.TAGSIZE;
         ROIC_PG_CTRL.DiagMode <= PG_BSQ_XYZ;
         ROIC_PG_CTRL.ImagePause <= ImagePause;

         ROIC_PG_RESET <= '0';
         wait for 50 ns;
         ROIC_PG_CTRL.Trig <= '1';
         wait for 50 ns;
         ROIC_PG_CTRL.Trig <= '0';
         wait for 20 us; -- Give enough time to bring the DONE status bit to 0.
--         WaitForDPBDone;
--         wait until ROIC_DONE = '1';
--         wait until ROIC_EMPTY = '1';
--         ROIC_PG_RESET <= '1';
--         if CLINK_DONE = '0' then
--            wait until CLINK_DONE = '1';
--         end if;
      end procedure StartROICDiag;
      
      procedure StartCameraDiag (signal ACQ_NUM : in integer) is
      begin
         -- Start acquisition for 3 cubes
         wait for 100 ns;
         wait until ROIC_DONE = '1';
         wait until ROIC_EMPTY = '1';  
      end procedure StartCameraDiag;      
      
      procedure StartDPBDiag (signal ACQ_NUM : in integer; signal DP_Mode : std_logic_vector(DPMODELEN-1 downto 0)) is
      begin
         if Vp7Only then
--            StartROICDiag(ACQ_NUM);
--            WaitForDPBDone;
--            ROIC_PG_RESET <= '1';
--            if CLINK_DONE = '0' then
--               wait until CLINK_DONE = '1';
--            end if;
         else
            -- Start acquisition in Fake Datacube from VP30 mode
            if RS232_DONE = '0' then
               wait until RS232_DONE = '1';
            end if;
            
            SendCLinkConfig;
            
            WaitForDPBDone;
            
            --            PROC_CONFIG.Mode <= DP_STOP;
            --            wait for 0 ns;
            --            SendDPConfig;
            
            PROC_CONFIG.Mode <= DP_Mode;
            wait for 0 ns;
            SendDPConfig;
            
            assert FALSE report "RS232 config sent, now waiting 20 us for VP30 to start" severity NOTE;
            wait for 20 us; -- Wait until VP30 really starts
            WaitForDPBDone;
            
            PROC_CONFIG.Mode <= DP_STOP;
            wait for 0 ns;
            SendDPConfig;
            
            assert FALSE report "RS232 STOP sent, now waiting 20 us for VP30 to stop" severity NOTE;
            wait for 20 us; -- Wait until VP30 registers the stop (20 us is worst case)
            --WaitForDPBDone;
            
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            
         end if;
      end procedure StartDPBDiag;
      
      -- 32x7x1, 8 tags, BIP (GATOR test case)
      procedure Do_Test1a (signal ACQ_NUM : in integer; 
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin  
         
         -- "Custom" config
         PROC_CONFIG.Mode	     <= DP_IGM;                           
         PROC_CONFIG.Interleave <= BIP;                  
         
         PROC_CONFIG.XSIZE    <= to_unsigned(32,10);
         PROC_CONFIG.YSIZE    <= to_unsigned(7,10);
         PROC_CONFIG.IMGSIZE  <= to_unsigned(32*7,20);
         PROC_CONFIG.TAGSIZE  <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE  <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE    <= to_unsigned(1,24);     
         PROC_CONFIG.SB_Mode  <= "00";
         PROC_CONFIG.SB_Min   <= (others => '0');
         PROC_CONFIG.SB_Max   <= (others => '0');
         
         CLINK_CONFIG.LValSize   <=  to_unsigned(32,16);
         CLINK_CONFIG.FValSize   <=  to_unsigned(17,16);
         CLINK_CONFIG.HeaderSize <=  to_unsigned(312,16);
         CLINK_CONFIG.LValPause  <=  to_unsigned(0,16);   
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');                            
         
         if Diag_Source = '0' then
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
--            WaitForDPBDone;
--            ROIC_PG_RESET <= '1';
--            if CLINK_DONE = '0' then
--               wait until CLINK_DONE = '1';
--            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 0 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #1a done.";
      end procedure Do_Test1a;
      
      -- 32x7x1, 8 tags BSQ (GATOR test case)
      procedure Do_Test1b (signal ACQ_NUM : in integer; 
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave <= BSQ;         
         PROC_CONFIG.Mode	     <= DP_IGM;  
         PROC_CONFIG.XSIZE <= to_unsigned(32,10);
         PROC_CONFIG.YSIZE <= to_unsigned(7,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(32*7,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(1,24);     
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');
         CLINK_CONFIG.LValSize      <=  to_unsigned(32,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(312,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         if Diag_Source = '0' then 
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #1b done.";
      end procedure Do_Test1b;      
      
      -- 4 x 3 x 10, with 8 tag BIP 
      -- No averaging
      procedure Do_Test2a (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= BIP;
         PROC_CONFIG.Mode	     <= DP_IGM;  
         
         PROC_CONFIG.XSIZE <= to_unsigned(4,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(12,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(10,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');
         CLINK_CONFIG.LValSize      <=  to_unsigned(20,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(62,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(1040,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');          
         
         wait for 0 ns;
         HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
         wait for 0 ns;         

         if Diag_Source = '0' then 
            SendCmd44;                        
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            SendCmd44;                        
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #2a done.";
      end Do_Test2a;           
      
      -- 4 x 3 x 10, with 8 tag BSQ  
      -- No averaging
      procedure Do_Test2b (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= BSQ;     
         PROC_CONFIG.Mode	     <= DP_IGM;      
         
         PROC_CONFIG.XSIZE <= to_unsigned(4,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(12,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(10,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);   
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');         
         CLINK_CONFIG.LValSize      <=  to_unsigned(20,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(62,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(1040,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         wait for 0 ns;
         HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
         wait for 0 ns;         

         if Diag_Source = '0' then    
            SendCmd44;                        
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            SendCmd44;                        
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);  
         end if;  
         report "Test #2b done.";
      end Do_Test2b;      
      
      -- 16 x 3 x 10, with 8 tag BIP 
      -- Averaging: 4 
      procedure Do_Test2c (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave <= BIP;     
         PROC_CONFIG.Mode	     <= DP_IGM;
         
         PROC_CONFIG.XSIZE <= to_unsigned(16,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(16*3,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(10,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(4,6);
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');
         CLINK_CONFIG.LValSize      <=  to_unsigned(56,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(21,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(616,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"4";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');
         
         wait for 0 ns;
         HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
         wait for 0 ns;         
         
         if Diag_Source = '0' then  
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);
         end if;  
         report "Test #2c done.";
      end Do_Test2c;    
      
      -- 4 x 3 x 64 FFT, with 8 tag        
      -- No averaging      
      procedure Do_Test3 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave  <= BIP;     
         
         PROC_CONFIG.SB_Mode     <= "00";
         PROC_CONFIG.SB_Min      <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max      <= to_unsigned(243,16);         
         PROC_CONFIG.XSIZE       <= to_unsigned(4,10);
         PROC_CONFIG.YSIZE       <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE     <= to_unsigned(12,20);
         PROC_CONFIG.TAGSIZE     <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE     <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE       <= to_unsigned(64,24);
         CLINK_CONFIG.LValSize   <=  to_unsigned(68,16);
         CLINK_CONFIG.FValSize   <=  to_unsigned(35,16);
         CLINK_CONFIG.HeaderSize <=  to_unsigned(1064,16);
         CLINK_CONFIG.LValPause  <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal <= (others => '0');
         PROC_CONFIG.SB_Max_Cal <= (others => '0');         

         if Diag_Source = '0' then     
            PROC_CONFIG.Mode	      <= DP_RAW_SPC;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
            wait for 0 ns;         
            SendCmd44;                        
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else  
            PROC_CONFIG.Mode	      <= DP_DIAG_RAW_SPC;
            DP_Mode    <= DP_DIAG_RAW_SPC;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
            wait for 0 ns;         
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode); 
         end if;      
         report "Test #3 done.";
      end Do_Test3;
      
      -- 4 x 3 x 64 FFT, with 8 tag        
      -- No averaging      
      procedure Do_Test3a (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave  <= BIP;     
         PROC_CONFIG.SB_Mode     <= "00";
         PROC_CONFIG.SB_Min      <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max      <= to_unsigned(243,16);         
         PROC_CONFIG.XSIZE       <= to_unsigned(4,10);
         PROC_CONFIG.YSIZE       <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE     <= to_unsigned(12,20);
         PROC_CONFIG.TAGSIZE     <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE     <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE       <= to_unsigned(64,24);
         CLINK_CONFIG.LValSize   <=  to_unsigned(512,16);
         CLINK_CONFIG.FValSize   <=  to_unsigned(8,16);
         CLINK_CONFIG.HeaderSize <=  to_unsigned(1500,16);
         CLINK_CONFIG.LValPause  <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal <= (others => '0');
         PROC_CONFIG.SB_Max_Cal <= (others => '0');         

         if Diag_Source = '0' then     
            PROC_CONFIG.Mode	      <= DP_RAW_SPC_N_IGM;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
            wait for 0 ns;         
            SendCmd44;                        
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else  
            PROC_CONFIG.Mode	      <= DP_DIAG_RAW_SPC_N_IGM;
            DP_Mode    <= DP_DIAG_RAW_SPC_N_IGM;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
            wait for 0 ns;         
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode); 
         end if;      
         report "Test #3a done.";
      end Do_Test3a;

      -- 4 x 3 x 64 FFT, with 8 tags        
      -- 5 averaging     
      -- One image missing
      procedure Do_Test3b (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin

         PROC_CONFIG.Interleave <= "01";
         PROC_CONFIG.Mode	     <= DP_RAW_SPC_N_IGM;
         MISSING_IMAGES         <= 1;
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max <= to_unsigned(243,16);         
         PROC_CONFIG.XSIZE <= to_unsigned(4,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(12,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(5,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);

         CLINK_CONFIG.LValSize      <=  to_unsigned(512,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(22,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(8668,16);	 
         CLINK_CONFIG.LValPause  <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');   
         
         wait for 0 ns;
         HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"04"); 
         wait for 0 ns;         
         
         if Diag_Source = '0' then     
            SendCmd44;                        
            SendRS232Config;       
            -- Change ROIC FringeTotal to cause an error
            PROC_CONFIG.ZSIZE <= to_unsigned(63,24);            
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else  
            DP_Mode    <= DP_DIAG_RAW_SPC_N_IGM;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode); 
         end if;        
         
         report "Test #3b done.";
      end Do_Test3b;      
      
      -- 2 x 3 x 64, with 6 tag
      -- Averaging: 5
      procedure Do_Test4 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(6,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(5,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         CLINK_CONFIG.LValSize      <=  to_unsigned(64,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(320,16);	  
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         if Diag_Source = '0' then
            for i in 1 to ACQ_NUM*5 loop
               StartROICDiag(one, ImagePause);  
               WaitForDPBDone;
               ROIC_PG_RESET <= '1';
               if CLINK_DONE = '0' then
                  wait until CLINK_DONE = '1';
               end if;
               wait for 11 us;
            end loop;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;
         report "Test #4 done.";
      end Do_Test4;   
      
      -- 16x16x100, with 8 tag
      -- 3 Averaging      
      procedure Do_Test5 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave <= BIP;     
         PROC_CONFIG.Mode	     <= DP_IGM;
         
         PROC_CONFIG.XSIZE <= to_unsigned(16,10);
         PROC_CONFIG.YSIZE <= to_unsigned(16,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(16*16,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(100,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(3,6);
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');         
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(100,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(270,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(600,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');         
         
         if Diag_Source = '0' then  
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode); 
         end if;      
         report "Test #5 done.";
      end Do_Test5;      
      
      -- Missing one image, causes size_error
      -- 2x3x64 8 tags, No averaging, BIP 
      -- It is normal that the last 3 images are erroneous, perfect recovery is not supported.
      procedure Do_Test6 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave <= BIP;     
         PROC_CONFIG.Mode	     <= DP_IGM;
         
         PROC_CONFIG.SB_Mode     <= "00";
         PROC_CONFIG.SB_Min      <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max      <= to_unsigned(243,16); 
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8); 
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         CLINK_CONFIG.LValSize      <=  to_unsigned(64,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(19,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(320,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');              
         
         SendRS232Config;
         
         -- Change ROIC FringeTotal to cause an error
         PROC_CONFIG.ZSIZE <= to_unsigned(63,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);
         WaitForDPBDone;
         ROIC_PG_RESET <= '1';
         if CLINK_DONE = '0' then
            wait until CLINK_DONE = '1';
         end if;
         
         wait for 3 us;
         
         -- Change ROIC FringeTotal back to normal
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24); 
         
         if Diag_Source = '0' then  
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;
         report "Test #6 done.";
      end Do_Test6;                          
      
      -- Missing one image, causes size_error
      -- 2x3x64 8 tags, No averaging, BSQ 
      procedure Do_Test6b (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave <= BSQ;     
         PROC_CONFIG.Mode	     <= DP_IGM;
         
         PROC_CONFIG.SB_Mode     <= "00";
         PROC_CONFIG.SB_Min      <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max      <= to_unsigned(243,16);          
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8); 
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         CLINK_CONFIG.LValSize      <=  to_unsigned(14,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(86,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(308,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');            
         
         SendRS232Config;
         
         -- Change ROIC FringeTotal to cause an error
         PROC_CONFIG.ZSIZE <= to_unsigned(63,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);
         WaitForDPBDone;
         ROIC_PG_RESET <= '1';
         if CLINK_DONE = '0' then
            wait until CLINK_DONE = '1';
         end if;
         
         wait for 3 us;
         
      end Do_Test6b;                          
      
      -- Missing one image, causes timeout errors
      -- 2x3x64, 8 tags, BIP
      -- Averaging: 4      
      procedure Do_Test6c (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic;
         signal one : integer) is      
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8); 
         PROC_CONFIG.AVGSIZE <= to_unsigned(4,6);
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(64,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(19,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(320,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         
         -- Change ROIC FringeTotal to cause an error
         PROC_CONFIG.ZSIZE <= to_unsigned(63,24);
         
         for i in 1 to ACQ_NUM*4 loop
            StartROICDiag(one, ImagePause);  
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            wait for 11 us;
         end loop;
         
         -- Change ROIC FringeTotal back to normal
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24); 
         
         if Diag_Source = '0' then
            for i in 1 to ACQ_NUM*4 loop
               StartROICDiag(one, ImagePause);  
               WaitForDPBDone;
               ROIC_PG_RESET <= '1';
               if CLINK_DONE = '0' then
                  wait until CLINK_DONE = '1';
               end if;
               wait for 11 us;
            end loop;            
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if; 
         report "Test #6c done.";
      end Do_Test6c;            
      
      -- Missing SEVERAL images, causes size_error
      -- 2x3x64 8 tags, No averaging, BSQ 
      procedure Do_Test6d (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "00";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8); 
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         CLINK_CONFIG.LValSize      <=  to_unsigned(14,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(86,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(308,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);  
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         
         -- Change ROIC FringeTotal to cause an error
         PROC_CONFIG.ZSIZE <= to_unsigned(2,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);
         WaitForDPBDone;
         ROIC_PG_RESET <= '1';
         if CLINK_DONE = '0' then
            wait until CLINK_DONE = '1';
         end if;
         
         wait for 3 us;
         
         --         -- Change ROIC FringeTotal back to normal
         --         PROC_CONFIG.ZSIZE <= to_unsigned(64,24); 
         --         
         --         if Diag_Source = '0' then
         --            StartROICDiag(ACQ_NUM);
--                     WaitForDPBDone;
--                     ROIC_PG_RESET <= '1';
--                     if CLINK_DONE = '0' then
--                        wait until CLINK_DONE = '1';
--                     end if;
         --         else   
         --            StartDPBDiag(ACQ_NUM);   
         --         end if; 
         --         report "Test #6b done.";
      end Do_Test6d;                          
      
      
      -- 2 x 3 x 17, with 8 tag BIP 
      -- No averaging
      procedure Do_Test7a (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is    
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(17,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(32,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(306,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if; 
         report "Test #7a done.";
      end Do_Test7a;                 
      
      -- 2 x 3 x 17, with 8 tag BIP 
      -- 32 averaging
      procedure Do_Test7c (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is 
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(17,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(32,6);
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(32,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(306,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);  
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         if Diag_Source = '0' then
            for i in 1 to ACQ_NUM*32 loop
               StartROICDiag(one, ImagePause);  
               WaitForDPBDone;
               ROIC_PG_RESET <= '1';
               if CLINK_DONE = '0' then
                  wait until CLINK_DONE = '1';
               end if;
               wait for 11 us;
            end loop;            
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if; 
         report "Test #7c done.";
      end Do_Test7c; 		
      
      -- 2 x 3 x 31, with 8 tag BIP 
      -- No averaging
      procedure Do_Test8a (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         
         PROC_CONFIG.Interleave <= "01";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(31,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);     
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');         
         CLINK_CONFIG.LValSize      <=  to_unsigned(31,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(24,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(310,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');         
         
         if Diag_Source = '0' then 
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #8a done.";
      end Do_Test8a;           
      
      -- 32 x 12 x 17, 8 tags, BIP, no FFT, no avg
      procedure Do_Test9 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is 
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(32,10);
         PROC_CONFIG.YSIZE <= to_unsigned(12,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(32*12,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(17,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(68,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(223,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(8500,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);      
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if; 
         report "Test #9 done.";
      end Do_Test9; 
      
      -- 32 x 12 x 17, 8 tags, BSQ, no FFT, no avg
      procedure Do_Test9b (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(32,10);
         PROC_CONFIG.YSIZE <= to_unsigned(12,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(32*12,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(17,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);       
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');         
         CLINK_CONFIG.LValSize      <=  to_unsigned(392,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(19,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(784,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');        
         
         if Diag_Source = '0' then 
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #9b done.";
      end Do_Test9b;      
      
      -- Missing several images, causes timeout errors
      -- 2x3x17, 8 tags, BIP    
      procedure Do_Test10 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic;
         signal one : integer) is     
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(17,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(32,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(306,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);	   
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         
         -- Change ROIC FringeTotal to cause an error
         PROC_CONFIG.ZSIZE <= to_unsigned(5,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);         
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         PROC_CONFIG.ZSIZE <= to_unsigned(8,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);  
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         PROC_CONFIG.ZSIZE <= to_unsigned(9,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);         
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         PROC_CONFIG.ZSIZE <= to_unsigned(16,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);         
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         PROC_CONFIG.ZSIZE <= to_unsigned(17,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);         
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         report "Test #10 done.";
      end Do_Test10;      		     
      
      -- 64x8x790 BIP 
      -- FFT with cropping
      -- Used to produce a CameraLink fifo underflow 
      procedure Do_Test11 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is  
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "01";
         PROC_CONFIG.XSIZE <= to_unsigned(64,10);
         PROC_CONFIG.YSIZE <= to_unsigned(8,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(512,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(790,24);
         
         PROC_CONFIG.SB_Mode <= "01";
         PROC_CONFIG.SB_Min <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max <= to_unsigned(243,16);  
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(2476,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(43,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(8500,16);	  
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;   
         report "Test #11 done.";
      end Do_Test11;	  
      
      
      -- 16 x 16 x 64 FFT, with 6 tag        
      -- 5 averaging      
      procedure Do_Test12 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "01";  
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max <= to_unsigned(243,16);         
         PROC_CONFIG.XSIZE <= to_unsigned(16,10);
         PROC_CONFIG.YSIZE <= to_unsigned(16,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(16*16,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(6,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(5,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(67,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(277,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(1023,16);	
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if; 
         report "Test #12 done.";
      end Do_Test12;      
      
      
      -- 2 x 3 x 64 FFT, with 6 tag (0 pad)           
      procedure Do_ZeroPad0 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is  
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "01";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(6,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         
         CLINK_CONFIG.LValSize      <=  to_unsigned(67,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(353,16);	
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');           
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;
      end Do_ZeroPad0;
      -- 2 x 3 x 64 FFT, with 6 tag (1 pad)           
      procedure Do_ZeroPad1 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "01";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(6,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(63,24);
         --CONFIG_PARAM.HeaderVersion <= x"2";
         CLINK_CONFIG.LValSize      <=  to_unsigned(67,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(359,16);	
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;
      end Do_ZeroPad1;
      -- 2 x 3 x 64 FFT, with 6 tag (2 pad)          
      procedure Do_ZeroPad2 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "01";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(6,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(62,24);
         --CONFIG_PARAM.HeaderVersion <= x"2";
         CLINK_CONFIG.LValSize      <=  to_unsigned(67,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(17,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(365,16);	
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;
      end Do_ZeroPad2;
      -- 2 x 3 x 64 FFT, with 6 tag (3 pad)          
      procedure Do_ZeroPad3 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "01";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(6,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(61,24);
         --CONFIG_PARAM.HeaderVersion <= x"2";
         CLINK_CONFIG.LValSize      <=  to_unsigned(67,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(16,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(304,16);	
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;
      end Do_ZeroPad3;
      -- 2 x 3 x 64 FFT, with 6 tag (4 pad)          
      procedure Do_ZeroPad4 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "01";
         --CONFIG_PARAM.DP_Mode <= "01";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(6,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(60,24);
         --CONFIG_PARAM.HeaderVersion <= x"2";
         CLINK_CONFIG.LValSize      <=  to_unsigned(67,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(16,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(310,16);	
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;
      end Do_ZeroPad4;
      
      -- 31x100x1 BIP    
      -- Caused a bug in hardware
      procedure Do_Test13 (signal ACQ_NUM : in integer; 
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "01";         
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(31,10);
         PROC_CONFIG.YSIZE <= to_unsigned(100,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(31*100,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(1,24);
         --CONFIG_PARAM.HeaderVersion <= x"2";
         CLINK_CONFIG.LValSize      <=  to_unsigned(124,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(32,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(860,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(149,16);
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;  
         report "Test #13 done.";
      end procedure Do_Test13;      
      
      -- 2x3x100 BIP              
      -- Caused a bug in hardware
      procedure Do_Test14 (signal ACQ_NUM : in integer; 
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "01";         
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(100,24);
         --CONFIG_PARAM.HeaderVersion <= x"2";
         CLINK_CONFIG.LValSize      <=  to_unsigned(400,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(6,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(1000,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(480,16);
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;  
         report "Test #14 done.";
      end procedure Do_Test14;      
      
      -- 32 x 12 x 5, 8 tags, BSQ, no FFT, no avg
      procedure Do_Test15 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "00";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(32,10);
         PROC_CONFIG.YSIZE <= to_unsigned(12,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(32*12,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(5,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         --CONFIG_PARAM.HeaderVersion <= x"2";
         CLINK_CONFIG.LValSize      <=  to_unsigned(392,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(7,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(784,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if; 
         report "Test #15 done.";
      end Do_Test15;      
      
      -- Bad CameraLink settings, causes Cameralink timeout.
      -- 2x3x63 8 tags, No averaging, BSQ 
      procedure Do_Test16 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "00";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(63,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8); 
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         CLINK_CONFIG.LValSize      <=  to_unsigned(14,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(86,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(308,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         SendRS232Config;
         
         StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         wait for 3 us;
      end Do_Test16;                          
      
      -- Missing image pixels.
      -- 2x3x64 8 tags, No averaging, BSQ 
      procedure Do_Test17 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "00";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8); 
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         CLINK_CONFIG.LValSize      <=  to_unsigned(14,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(86,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(308,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         SendRS232Config; 
         
         -- Change YSize to cause an error.
         PROC_CONFIG.YSIZE <= to_unsigned(2,10);
         
         StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         wait for 3 us;
      end Do_Test17;                                         
      
      -- One extra image!
      -- 2x3x64 8 tags, No averaging, BSQ 
      procedure Do_Test18 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "00";
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(6,20);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8); 
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         CLINK_CONFIG.LValSize      <=  to_unsigned(14,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(86,16);
         CLINK_CONFIG.HeaderSize      <= to_unsigned(308,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         SendRS232Config; 
         
         -- Change YSize to cause an error.
         PROC_CONFIG.ZSIZE <= to_unsigned(65,24);
         
         StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         
         wait for 3 us;
      end Do_Test18;                          
      
      -- 128x128x2 BSQ    
      -- Caused a bug in hardware
      procedure Do_Test19 (signal ACQ_NUM : in integer; 
         signal Diag_Source : in std_logic) is
      begin         
         PROC_CONFIG.Interleave <= "00";         
         --CONFIG_PARAM.DP_Mode <= "00";
         PROC_CONFIG.XSIZE <= to_unsigned(128,10);
         PROC_CONFIG.YSIZE <= to_unsigned(128,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(128*128,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(0,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(2,24);
         CLINK_CONFIG.LValSize      <=  to_unsigned(16384,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(3,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(16384,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         SendRS232Config;
         if Diag_Source = '0' then
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else   
            --StartDPBDiag(ACQ_NUM);   
         end if;  
         report "Test #19 done.";
      end procedure Do_Test19;      
      
      procedure Do_Test20 (signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin        
         
         CLINK_CONFIG.LValSize      <= to_unsigned(21, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(19, FVALLEN);
         CLINK_CONFIG.HeaderSize    <= to_unsigned(315, HEADERLEN);
         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         --CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                      
         --CLINK_CONFIG.Mode          <= "001";        
         --CLINK_CONFIG.DiagSize      <= to_unsigned(1, 16);
         
         PROC_CONFIG.ZSIZE      <= to_unsigned(120, ZLEN);
         PROC_CONFIG.XSIZE	     <= to_unsigned(2,XLEN);
         PROC_CONFIG.YSIZE		  <= to_unsigned(2,YLEN);
         PROC_CONFIG.IMGSIZE    <= to_unsigned(2*2,IMGLEN);
         PROC_CONFIG.TAGSIZE	  <= to_unsigned(0, TAGLEN);                  
         PROC_CONFIG.SB_Min     <= to_unsigned(26, 16);
         PROC_CONFIG.SB_Max     <= to_unsigned(45, 16);
         PROC_CONFIG.SB_Mode    <= "01";                    
         PROC_CONFIG.Interleave <= BIP;         
         PROC_CONFIG.AVGSIZE	  <= to_unsigned(1, AVGLEN);
         PROC_CONFIG.DiagSize   <= to_unsigned(1, DIAGLEN);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         
         PROC_CONFIG.SB_Min_Cal   <= (others => '0'); -- This exponent is used to
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');
         
         --PROC_CONFIG.Lh_Exp     <= to_signed(-4, 8);
         --PROC_CONFIG.DLbb_Exp   <= to_signed(-27, 8);                    
         
         -- Send cold BB              
         INPUT_FILE(1 to 63)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\bb_cold_4x20.dat";
         USE_FILE               <= '1';  
         PROC_CONFIG.BB_Temp    <= to_unsigned(29199, 16); 
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_COLD_BB_STORE;
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;            
            SendRS232Config;
            StartROICDiag(one, ImagePause);               
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else 
            DP_Mode             <= DP_DIAG_COLD_BB_STORE;
            PROC_CONFIG.Mode    <= DP_DIAG_COLD_BB_STORE;
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;             
            StartDPBDiag(ACQ_NUM, DP_Mode);     
         end if;
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;
         
         -- Send hot BB
         INPUT_FILE(1 to 62)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\bb_hot_4x20.dat";
         PROC_CONFIG.BB_Temp    <= to_unsigned(30110, 16);  
         USE_FILE               <= '1';   
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_HOT_BB_STORE;  
            SendRS232Config;
            StartROICDiag(one, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else            
            DP_Mode             <= DP_DIAG_HOT_BB_STORE;
            wait for 0 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);                     
         end if;                                                         
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;         
         
         -- Send scene   
         INPUT_FILE(1 to 61)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\scene_4x20.dat";
         USE_FILE               <= '1';       
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_CAL_SPC_ONLY;   
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;            
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);  
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else              
            DP_Mode             <= DP_DIAG_CAL_SPC_ONLY;
            PROC_CONFIG.Mode	  <= DP_DIAG_CAL_SPC_ONLY;   
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;
            StartDPBDiag(ACQ_NUM, DP_Mode);           
         end if;     
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;                     
         
         report "Test #20 done.";
      end procedure Do_Test20;      
      
      -- Same as #20 but output everything to reproduce the data
      procedure Do_Test20b (signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin           
         CLINK_CONFIG.LValSize      <= to_unsigned(120, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(7, FVALLEN);
         CLINK_CONFIG.HeaderSize    <= to_unsigned(360, HEADERLEN);
         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         --CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                      
         --CLINK_CONFIG.Mode          <= "001";        
         --CLINK_CONFIG.DiagSize      <= to_unsigned(1, 16);
         
         PROC_CONFIG.ZSIZE      <= to_unsigned(120, ZLEN);
         PROC_CONFIG.XSIZE	     <= to_unsigned(2,XLEN);
         PROC_CONFIG.YSIZE		  <= to_unsigned(2,YLEN);
         PROC_CONFIG.IMGSIZE    <= to_unsigned(2*2,IMGLEN);
         PROC_CONFIG.TAGSIZE	  <= to_unsigned(0, TAGLEN);                  
         PROC_CONFIG.SB_Min     <= to_unsigned(26, 16);
         PROC_CONFIG.SB_Max     <= to_unsigned(45, 16);
         PROC_CONFIG.SB_Mode    <= "01";                    
         PROC_CONFIG.Interleave <= BIP;         
         PROC_CONFIG.AVGSIZE	  <= to_unsigned(1, AVGLEN);
         PROC_CONFIG.DiagSize   <= to_unsigned(1, DIAGLEN);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         
         PROC_CONFIG.SB_Min_Cal   <= (others => '0'); -- This exponent is used to
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');
         
         --PROC_CONFIG.Lh_Exp     <= to_signed(-4, 8);
         --PROC_CONFIG.DLbb_Exp   <= to_signed(-27, 8);         
         
         -- Send cold BB              
         INPUT_FILE(1 to 63)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\bb_cold_4x20.dat";
         USE_FILE               <= '1';  
         PROC_CONFIG.BB_Temp    <= to_unsigned(29199, 16); 
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_COLD_BB_OUT;             
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;            
            SendRS232Config;
            StartROICDiag(one, ImagePause);               
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else 
            DP_Mode             <= DP_DIAG_COLD_BB_OUT; 
            PROC_CONFIG.Mode    <= DP_DIAG_COLD_BB_OUT;
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;            
            StartDPBDiag(ACQ_NUM, DP_Mode);     
         end if;
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;
         
         -- Send hot BB
         INPUT_FILE(1 to 62)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\bb_hot_4x20.dat";
         PROC_CONFIG.BB_Temp    <= to_unsigned(30110, 16);  
         USE_FILE               <= '1';   
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_HOT_BB_OUT;  
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;            
            SendRS232Config;
            StartROICDiag(one, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else            
            DP_Mode             <= DP_DIAG_HOT_BB_OUT;
            PROC_CONFIG.Mode    <= DP_DIAG_HOT_BB_OUT;
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG); 
            wait for 0 ns;
            SendCmd43;            
            wait for 0 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);                     
         end if;                                                         
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;         
         
         -- Send scene   
         CLINK_CONFIG.LValSize      <= to_unsigned(12, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(72, FVALLEN);  
         CLINK_CONFIG.HeaderSize    <= to_unsigned(300, HEADERLEN);
         INPUT_FILE(1 to 61)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\scene_4x20.dat";          
         USE_FILE               <= '1';                      
         
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_CAL_SPC_N_IGM;   
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG);
            wait for 0 ns;
            SendCmd43;                                         
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);  
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else              
            DP_Mode             <= DP_DIAG_CAL_SPC_N_IGM;  
            PROC_CONFIG.Mode	  <= DP_DIAG_CAL_SPC_N_IGM;  
            wait for 0 ns;
            HEADER43 <= to_DCUBE_HEADER_array(PROC_CONFIG, CLINK_CONFIG);
            wait for 0 ns;
            SendCmd43;                         
            StartDPBDiag(ACQ_NUM, DP_Mode);           
         end if;     
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns; 
         
         --         CLINK_CONFIG.LValSize      <= to_unsigned(20, LVALLEN);
         --         CLINK_CONFIG.FValSize      <= to_unsigned(27, FVALLEN);
         --         CLINK_CONFIG.HeaderSize    <= to_unsigned(300, HEADERLEN);
         --         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         --         --CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         --         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         --         CLINK_CONFIG.HeaderVersion <= x"3";                      
         --         --CLINK_CONFIG.Mode          <= "001";        
         --         --CLINK_CONFIG.DiagSize      <= to_unsigned(1, 16);        
         --         
         --         PROC_CONFIG.ZSIZE      <= to_unsigned(20, ZLEN);
         --         PROC_CONFIG.XSIZE	     <= to_unsigned(2,XLEN);
         --         PROC_CONFIG.YSIZE		  <= to_unsigned(2,YLEN);
         --         PROC_CONFIG.IMGSIZE    <= to_unsigned(2*2,IMGLEN);
         --         PROC_CONFIG.TAGSIZE	  <= to_unsigned(8, TAGLEN);                  
         --         PROC_CONFIG.SB_Min     <= to_unsigned(12, 16);
         --         PROC_CONFIG.SB_Max     <= to_unsigned(22, 16);
         --         PROC_CONFIG.SB_Mode    <= "01";                    
         --         PROC_CONFIG.Interleave <= BIP;         
         --         PROC_CONFIG.AVGSIZE	  <= to_unsigned(1, AVGLEN);
         --         PROC_CONFIG.DiagSize   <= to_unsigned(1, DIAGLEN);
         --         dOPD := to_float(2.5312e-4);
         --         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         --         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);         
         --         PROC_CONFIG.Gain_Exp   <= to_signed(-21, 8); -- This exponent is used to
         --         PROC_CONFIG.SB_Max_Cal    <= (others => '0');         
         --         PROC_CONFIG.Lh_Exp     <= to_signed(-4, 8);
         --         PROC_CONFIG.DLbb_Exp   <= to_signed(-27, 8);    
         --         
         --         -- Send cold BB
         --         INPUT_FILE(1 to 63)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\bb_cold_4x20.dat";
         --         USE_FILE               <= '1';          
         --         PROC_CONFIG.Mode	     <= DP_COLD_BB_OUT;   
         --         PROC_CONFIG.BB_Temp    <= to_unsigned(29199, 16);                              
         --         SendRS232Config;
         --         StartROICDiag(one);    
--                     WaitForDPBDone;
--                     ROIC_PG_RESET <= '1';
--                     if CLINK_DONE = '0' then
--                        wait until CLINK_DONE = '1';
--                     end if;
         --         USE_FILE               <= '0';
         --         INPUT_FILE             <= (others => nul);
         --         wait for 20 ns;              
         --         
         --         -- Send hot BB
         --         INPUT_FILE(1 to 62)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\bb_hot_4x20.dat";
         --         USE_FILE               <= '1';         
         --         PROC_CONFIG.Mode	     <= DP_HOT_BB_OUT;   
         --         PROC_CONFIG.BB_Temp    <= to_unsigned(30110, 16);                              
         --         SendRS232Config;
         --         StartROICDiag(one);  
--                     WaitForDPBDone;
--                     ROIC_PG_RESET <= '1';
--                     if CLINK_DONE = '0' then
--                        wait until CLINK_DONE = '1';
--                     end if;
         --         USE_FILE               <= '0';
         --         INPUT_FILE             <= (others => nul);
         --         wait for 20 ns;         
         --         
         --         -- Send scene
         --         CLINK_CONFIG.LValSize      <= to_unsigned(16, LVALLEN);
         --         CLINK_CONFIG.FValSize      <= to_unsigned(66, FVALLEN);
         --         CLINK_CONFIG.HeaderSize    <= to_unsigned(304, HEADERLEN);
         --         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         --         --CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         --         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         --         CLINK_CONFIG.HeaderVersion <= x"3";                      
         --         --CLINK_CONFIG.Mode          <= "001";        
         --         --CLINK_CONFIG.DiagSize      <= to_unsigned(ACQ_NUM, 16);                    
         --         
         --         INPUT_FILE(1 to 61)    <= "D:\Telops\FIR-00085\src\Testbench\dataset_4x20\scene_4x20.dat";
         --         USE_FILE               <= '1';         
         --         PROC_CONFIG.Mode	     <= DP_CAL_SPC_N_IGM;                               
         --         SendRS232Config;
         --         StartROICDiag(ACQ_NUM);    
--                     WaitForDPBDone;
--                     ROIC_PG_RESET <= '1';
--                     if CLINK_DONE = '0' then
--                        wait until CLINK_DONE = '1';
--                     end if;
         --         USE_FILE               <= '0';
         --         INPUT_FILE             <= (others => nul);
         --         wait for 20 ns;                     
         
         report "Test #20b done.";
      end procedure Do_Test20b;      
      

      -- 4 x 2 x 1185, with 8 tag BIP 
      -- No averaging
      procedure Do_Test21 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= BIP;
         PROC_CONFIG.Mode	     <= DP_IGM;  
         
         PROC_CONFIG.XSIZE <= to_unsigned(4,10);
         PROC_CONFIG.YSIZE <= to_unsigned(2,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(8,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(1185,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');
         CLINK_CONFIG.LValSize      <=  to_unsigned(16,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(1249,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(1024,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');
         
         USE_FILE               <= '0';
         
         wait for 0 ns;
         HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
         wait for 0 ns;

         if Diag_Source = '0' then 
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #21 done.";
      end Do_Test21;           
            
      
      -- 12 x 10 x 10, with 8 tag BIP 
      -- No averaging
      procedure Do_Test22 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin         
         PROC_CONFIG.Interleave <= BIP;
         PROC_CONFIG.Mode	     <= DP_IGM;  
         
         PROC_CONFIG.XSIZE <= to_unsigned(12,10);
         PROC_CONFIG.YSIZE <= to_unsigned(10,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(120,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.ZSIZE <= to_unsigned(10,24);
         PROC_CONFIG.AVGSIZE <= to_unsigned(1,6);
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= (others => '0');
         PROC_CONFIG.SB_Max <= (others => '0');
         CLINK_CONFIG.LValSize      <=  to_unsigned(40,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(245,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(8520,16);
         CLINK_CONFIG.LValPause      <=  to_unsigned(48,16);
         
         -- Usual "standard" config
         --CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                      
         --CLINK_CONFIG.Mode          <= CL_NORMAL;        
         --CLINK_CONFIG.DiagSize      <= to_unsigned(ACQ_NUM, 16);               
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');        
         
         if Diag_Source = '0' then 
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #22 done.";
      end Do_Test22;           
      
      -- 2 x 2 x 128 FFT, with 0 tag        
      -- No averaging      
      procedure Do_Test23 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         PROC_CONFIG.Interleave  <= BIP;     
         PROC_CONFIG.Mode	      <= DP_RAW_SPC_N_IGM;
         
         PROC_CONFIG.SB_Mode     <= "00";
         PROC_CONFIG.SB_Min      <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max      <= to_unsigned(243,16);         
         PROC_CONFIG.XSIZE       <= to_unsigned(2,10);
         PROC_CONFIG.YSIZE       <= to_unsigned(2,10);
         PROC_CONFIG.IMGSIZE     <= to_unsigned(4,20);
         PROC_CONFIG.TAGSIZE     <= to_unsigned(2,8);
         PROC_CONFIG.AVGSIZE     <= to_unsigned(1,6);
         PROC_CONFIG.ZSIZE       <= to_unsigned(128,24);
         CLINK_CONFIG.LValSize   <=  to_unsigned(18,16);
         CLINK_CONFIG.FValSize   <=  to_unsigned(103,16);
         CLINK_CONFIG.HeaderSize <=  to_unsigned(306,16);	
         CLINK_CONFIG.LValPause  <=  to_unsigned(0,16);
         
         -- Usual "standard" config
         --CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                      
         --CLINK_CONFIG.Mode          <= CL_NORMAL;        
         --CLINK_CONFIG.DiagSize      <= to_unsigned(ACQ_NUM, 16);               
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');
         --PROC_CONFIG.Lh_Exp     <= to_signed(-4, 8);
         --PROC_CONFIG.DLbb_Exp   <= to_signed(-27, 8);          
         
         if Diag_Source = '0' then   
            SendRS232Config;
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else          
            DP_Mode    <= DP_DIAG_RAW_SPC_N_IGM;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);   
         end if;  
         report "Test #23 done.";
      end Do_Test23;
      
      -- 4 x 3 x 64 FFT, with 8 tags        
      -- 5 averaging     
      -- One image missing
      procedure Do_Test24 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin

         PROC_CONFIG.Interleave <= "01";
         PROC_CONFIG.Mode	     <= DP_RAW_SPC_N_IGM;
         MISSING_IMAGES         <= 0;
         PROC_CONFIG.SB_Mode <= "00";
         PROC_CONFIG.SB_Min <= to_unsigned(155,16);
         PROC_CONFIG.SB_Max <= to_unsigned(243,16);         
         PROC_CONFIG.XSIZE <= to_unsigned(4,10);
         PROC_CONFIG.YSIZE <= to_unsigned(3,10);
         PROC_CONFIG.IMGSIZE <= to_unsigned(12,20);
         PROC_CONFIG.TAGSIZE <= to_unsigned(8,8);
         PROC_CONFIG.AVGSIZE <= to_unsigned(5,6);
         PROC_CONFIG.ZSIZE <= to_unsigned(64,24);

         CLINK_CONFIG.LValSize      <=  to_unsigned(512,16);
         CLINK_CONFIG.FValSize      <=  to_unsigned(22,16);
         CLINK_CONFIG.HeaderSize      <=  to_unsigned(8668,16);	 
         CLINK_CONFIG.LValPause  <=  to_unsigned(0,16);
         
         -- Usual "standard" config 
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, CLINK_CONFIG.FramesPerCube'LENGTH);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";                                   
         
         PROC_CONFIG.DiagSize   <= to_unsigned(ACQ_NUM, DIAGLEN);
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         dOPD := to_float(2.5312e-4);
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(32000, 16);
         PROC_CONFIG.SB_Min_Cal   <= (others => '0');
         PROC_CONFIG.SB_Max_Cal    <= (others => '0');   
         
         wait for 0 ns;
         HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01"); 
         wait for 0 ns;         
         
         if Diag_Source = '0' then     
            SendCmd44;                        
            SendRS232Config;       
            StartROICDiag(ACQ_NUM, ImagePause);            
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else  
            DP_Mode    <= DP_DIAG_RAW_SPC_N_IGM;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode); 
         end if;        
         
         report "Test #24 done.";
      end Do_Test24;      

      -- Test with InSb data
      procedure Do_Test25 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin        
         
         CLINK_CONFIG.LValSize      <= to_unsigned(256, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(20, FVALLEN);
         CLINK_CONFIG.HeaderSize    <= to_unsigned(1024, HEADERLEN);
         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";
         
         PROC_CONFIG.ZSIZE      <= to_unsigned(256, ZLEN);
         PROC_CONFIG.XSIZE	     <= to_unsigned(4,XLEN);
         PROC_CONFIG.YSIZE		  <= to_unsigned(2,YLEN);
         PROC_CONFIG.IMGSIZE    <= to_unsigned(8,IMGLEN);
         PROC_CONFIG.TAGSIZE	  <= to_unsigned(8, TAGLEN);     
         wait for 0 ns; -- To update values above
         PROC_CONFIG.SB_Min     <= to_unsigned(to_SB_Min_RS232(1500.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max     <= to_unsigned(to_SB_Max_RS232(5000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Mode    <= "01";
         PROC_CONFIG.Interleave <= BIP;
         PROC_CONFIG.AVGSIZE	  <= to_unsigned(1, AVGLEN);
         PROC_CONFIG.DiagSize   <= to_unsigned(1, DIAGLEN);
         dOPD := to_float(6.3280e-005); -- Every HeNe fringe
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(57300, 16);
         PROC_CONFIG.SB_Min_Cal <= to_unsigned(to_SB_Min_RS232(1800.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max_Cal <= to_unsigned(to_SB_Max_RS232(4000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         
         -- Send cold BB
         INPUT_FILE             <= (others => nul);
         INPUT_FILE(1 to 81)    <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\Data_Sets\InSb_cold_4x256.dat";
         wait for 20 ns;
         USE_FILE               <= '1';  
         PROC_CONFIG.BB_Temp    <= to_unsigned(38300, 16); 
         report "Test #25 Cold BB Begin.";
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_COLD_BB_OUT;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(one, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            wait for 20 us;
            WaitForDPBDone;
         else 
            PROC_CONFIG.Mode	     <= DP_DIAG_COLD_BB_OUT;
            DP_Mode                <= DP_DIAG_COLD_BB_OUT;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(one, DP_Mode);
         end if;
         report "Test #25 Cold BB Done.";
         
         -- Send hot BB
         INPUT_FILE             <= (others => nul);
         INPUT_FILE(1 to 80)    <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\Data_Sets\InSb_hot_4x256.dat";
         PROC_CONFIG.BB_Temp    <= to_unsigned(40300, 16);
         wait for 20 ns;
         report "Test #25 Hot BB Begin.";
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_HOT_BB_OUT;  
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(one, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            wait for 20 us;
            WaitForDPBDone;
         else
            PROC_CONFIG.Mode	     <= DP_DIAG_HOT_BB_OUT;  
            DP_Mode                <= DP_DIAG_HOT_BB_OUT;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(one, DP_Mode);
         end if;
         report "Test #25 Hot BB Done.";
         
         CLINK_CONFIG.LValSize      <= to_unsigned(256, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(30, FVALLEN);
         CLINK_CONFIG.HeaderSize    <= to_unsigned(1064, HEADERLEN);
         
         -- Send scene   
         INPUT_FILE             <= (others => nul);
         INPUT_FILE(1 to 82)    <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\Data_Sets\InSb_scene_4x256.dat";
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         wait for 20 ns;
         report "Test #25 Data Begin.";
         if Diag_Source = '0' then
            PROC_CONFIG.Mode	     <= DP_CAL_SPC_N_IGM;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(ACQ_NUM, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            wait for 20 us;
            WaitForDPBDone;
         else
            PROC_CONFIG.Mode	     <= DP_DIAG_CAL_SPC_N_IGM;
            DP_Mode                <= DP_DIAG_CAL_SPC_N_IGM;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(ACQ_NUM, DP_Mode);
         end if;
         report "Test #25 Data Done.";
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;
         
         report "Test #25 done.";
      end procedure Do_Test25;

      -- Averaging (4) IGM
      procedure Do_Test26 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin        
         
         CLINK_CONFIG.LValSize      <= to_unsigned(256, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(20, FVALLEN);
         CLINK_CONFIG.HeaderSize    <= to_unsigned(1024, HEADERLEN);
         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";
         
         PROC_CONFIG.Mode	     <= DP_IGM;
         PROC_CONFIG.ZSIZE      <= to_unsigned(256, ZLEN);
         PROC_CONFIG.XSIZE	     <= to_unsigned(4,XLEN);
         PROC_CONFIG.YSIZE		  <= to_unsigned(2,YLEN);
         PROC_CONFIG.IMGSIZE    <= to_unsigned(8,IMGLEN);
         PROC_CONFIG.TAGSIZE	  <= to_unsigned(8, TAGLEN);     
         wait for 0 ns; -- To update values above
         PROC_CONFIG.SB_Min     <= to_unsigned(to_SB_Min_RS232(1500.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max     <= to_unsigned(to_SB_Max_RS232(5000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Mode    <= "01";
         PROC_CONFIG.Interleave <= BIP;
         PROC_CONFIG.AVGSIZE	  <= to_unsigned(4, AVGLEN);
         PROC_CONFIG.DiagSize   <= to_unsigned(1, DIAGLEN);
         dOPD := to_float(6.3280e-005); -- Every HeNe fringe
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(57300, 16);
         PROC_CONFIG.SB_Min_Cal <= to_unsigned(to_SB_Min_RS232(1800.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max_Cal <= to_unsigned(to_SB_Max_RS232(4000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         
         INPUT_FILE             <= (others => nul);
         INPUT_FILE(1 to 82)    <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\Data_Sets\InSb_scene_4x256.dat";
         wait for 20 ns;
         USE_FILE               <= '1';  
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         wait for 20 ns;
         avg_acq <= ACQ_NUM*4;
         if Diag_Source = '0' then
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(avg_acq, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            wait for 20 us;
            WaitForDPBDone;
         else
            DP_Mode                <= DP_IGM;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(avg_acq, DP_Mode);
         end if;
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;
         
         report "Test #26 done.";
      end procedure Do_Test26;

      -- Averaging (4) RAW SPC
      procedure Do_Test27 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         
         CLINK_CONFIG.LValSize      <= to_unsigned(1036, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(5, FVALLEN);
         CLINK_CONFIG.HeaderSize    <= to_unsigned(1060, HEADERLEN);
         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";
         
         PROC_CONFIG.Mode	     <= DP_RAW_SPC;
         PROC_CONFIG.ZSIZE      <= to_unsigned(256, ZLEN);
         PROC_CONFIG.XSIZE	     <= to_unsigned(4,XLEN);
         PROC_CONFIG.YSIZE		  <= to_unsigned(2,YLEN);
         PROC_CONFIG.IMGSIZE    <= to_unsigned(8,IMGLEN);
         PROC_CONFIG.TAGSIZE	  <= to_unsigned(8, TAGLEN);     
         wait for 0 ns; -- To update values above
         PROC_CONFIG.SB_Min     <= to_unsigned(to_SB_Min_RS232(1500.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max     <= to_unsigned(to_SB_Max_RS232(5000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Mode    <= "00";
         PROC_CONFIG.Interleave <= BIP;
         PROC_CONFIG.AVGSIZE	  <= to_unsigned(4, AVGLEN);
         PROC_CONFIG.DiagSize   <= to_unsigned(1, DIAGLEN);
         dOPD := to_float(6.3280e-005); -- Every HeNe fringe
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(57300, 16);
         PROC_CONFIG.SB_Min_Cal <= to_unsigned(to_SB_Min_RS232(1800.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max_Cal <= to_unsigned(to_SB_Max_RS232(4000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         
         INPUT_FILE             <= (others => nul);
         INPUT_FILE(1 to 82)    <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\Data_Sets\InSb_scene_4x256.dat";
         wait for 20 ns;
         USE_FILE               <= '1';  
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         wait for 20 ns;
         avg_acq <= ACQ_NUM*4;
         if Diag_Source = '0' then
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(avg_acq, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            wait for 20 us;
            WaitForDPBDone;
         else
            DP_Mode                <= DP_RAW_SPC;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(avg_acq, DP_Mode);
         end if;
         
         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;
         
         report "Test #27 done.";
      end procedure Do_Test27;

      -- Averaging (4) RAW SPC x2
      -- Averaging (4) avec 1 cube manquant
      -- Changement de configuration
      -- Averaging (4) RAW SPC x2 (IGM différent)
      procedure Do_Test28 (signal ACQ_NUM : in integer;
         signal Diag_Source : in std_logic) is
         variable dOPD  : float32;
      begin
         
         CLINK_CONFIG.LValSize      <= to_unsigned(1036, LVALLEN);
         CLINK_CONFIG.FValSize      <= to_unsigned(5, FVALLEN);
         CLINK_CONFIG.HeaderSize    <= to_unsigned(1060, HEADERLEN);
         CLINK_CONFIG.LValPause     <= to_unsigned(0, 16);
         CLINK_CONFIG.FramesPerCube <= to_unsigned(1, 16);
         CLINK_CONFIG.CLinkMode     <= CLINK_BASE_MODE;
         CLINK_CONFIG.HeaderVersion <= x"3";
         
         PROC_CONFIG.Mode	     <= DP_RAW_SPC;
         PROC_CONFIG.ZSIZE      <= to_unsigned(256, ZLEN);
         PROC_CONFIG.XSIZE	     <= to_unsigned(4,XLEN);
         PROC_CONFIG.YSIZE		  <= to_unsigned(2,YLEN);
         PROC_CONFIG.IMGSIZE    <= to_unsigned(8,IMGLEN);
         PROC_CONFIG.TAGSIZE	  <= to_unsigned(8, TAGLEN);     
         wait for 0 ns; -- To update values above
         PROC_CONFIG.SB_Min     <= to_unsigned(to_SB_Min_RS232(1500.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max     <= to_unsigned(to_SB_Max_RS232(5000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Mode    <= "00";
         PROC_CONFIG.Interleave <= BIP;
         PROC_CONFIG.AVGSIZE	  <= to_unsigned(4, AVGLEN);
         PROC_CONFIG.DiagSize   <= to_unsigned(1, DIAGLEN);
         dOPD := to_float(6.3280e-005); -- Every HeNe fringe
         PROC_CONFIG.Delta_OPD  <= to_slv(dOPD);
         PROC_CONFIG.Max_Temp   <= to_unsigned(57300, 16);
         PROC_CONFIG.SB_Min_Cal <= to_unsigned(to_SB_Min_RS232(1800.0,1.0,PROC_CONFIG.ZSIZE), 16);
         PROC_CONFIG.SB_Max_Cal <= to_unsigned(to_SB_Max_RS232(4000.0,1.0,PROC_CONFIG.ZSIZE), 16);
         
         INPUT_FILE             <= (others => nul);
         INPUT_FILE(1 to 82)    <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\Data_Sets\InSb_scene_4x256.dat";
         wait for 20 ns;
         USE_FILE               <= '1';  
         PROC_CONFIG.BB_Temp    <= to_unsigned(30000, 16);
         avg_acq <= 8;
         report "Send 2 avg cubes.";
         wait for 20 ns;
         if Diag_Source = '0' then
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(avg_acq, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            WaitForDPBDone;
         else
            DP_Mode                <= DP_RAW_SPC;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(avg_acq, DP_Mode);
         end if;
         avg_acq <= 3;
         report "Send 3/4 of avg cube.";
         wait for 20 ns;
         if Diag_Source = '0' then
            StartROICDiag(avg_acq, ImagePause);
            report "Wait 150 us.";
            wait for 150 us;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
         else
            DP_Mode                <= DP_RAW_SPC;
            wait for 0 ns;
            StartDPBDiag(avg_acq, DP_Mode);
            report "Wait 150 us.";
            wait for 150 us;
         end if;
         
         INPUT_FILE             <= (others => nul);
         INPUT_FILE(1 to 81)    <= "D:\Telops\Common_HDL\Common_Projects\CAMEL\CAMEL_TB\Data_Sets\InSb_cold_4x256.dat";
         wait for 0 ns;
         avg_acq <= 8;
         wait for 20 ns;
         report "Send New Config and 2 avg cubes.";
         if Diag_Source = '0' then
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            SendRS232Config;
            wait for 20 us;
            StartROICDiag(avg_acq, ImagePause);
            WaitForDPBDone;
            ROIC_PG_RESET <= '1';
            if CLINK_DONE = '0' then
               wait until CLINK_DONE = '1';
            end if;
            wait for 20 us;
            WaitForDPBDone;
         else
            DP_Mode                <= DP_RAW_SPC;
            wait for 0 ns;
            HEADER44 <= to_DCUBE_Header_part1_array8_v4(PROC_CONFIG, CLINK_CONFIG, x"01");
            wait for 0 ns;
            SendCmd44;
            wait for 20 ns;
            StartDPBDiag(avg_acq, DP_Mode);
         end if;

         USE_FILE               <= '0';
         INPUT_FILE             <= (others => nul);
         wait for 20 ns;
         
         report "Test #28 done.";
      end procedure Do_Test28;

   begin 
      Init; 
      --wait for 5 us;
      
      --         -- Test command 0x04
      --         if RS232_DONE = '0' then
      --            wait until RS232_DONE = '1';
      --         end if;
      --         RS232_TYPE <= CMD_94;
      --         RS232_SEND_CFG <= '1'; 		  
      --         wait until RS232_DONE = '0';
      --         RS232_SEND_CFG <= '0';	
      --         wait until RS232_DONE = '1'; 
      --         wait for 4 us; -- wait for config to reach VP30	      
      
      ----------------------------------
      -- Camera mode, ROIC + DPB + VP7     
      ----------------------------------
      --      acq_num <= 2; 
      --      Diag_Source <= '0';
      --      wait for 0 ns;
      --      SendCmd43;                    
      --      
      --      --Do_Test1a(acq_num, Diag_Source);  
      --      --Do_Test2b(acq_num, Diag_Source);
      --      Do_Test14(acq_num, Diag_Source);     
      ----------------------------------
      
      ----------------------------------
      -- Spectro mode, ROIC + DPB + VP7     
      ---------------------------------- 
      acq_num <= 2; 
      Diag_Source <= '0';
      wait for 0 ns;
      
      --Do_Test1a(acq_num, Diag_Source);        
      --Do_Test1b(acq_num, Diag_Source);              
      --Do_Test2a(acq_num, Diag_Source);  -- OK BSQ
      --Do_Test2b(acq_num, Diag_Source);  -- OK BIP
      --Do_Test2c(acq_num, Diag_Source);      
      --Do_Test3(acq_num, Diag_Source);   -- OK FFT
      --Do_Test3a(acq_num, Diag_Source);  -- ?? FFT IGM+RAW_SPC
      --Do_Test3b(acq_num, Diag_Source);
      --Do_Test4(acq_num, Diag_Source);
      --Do_Test5(acq_num, Diag_Source);
      --      Do_Test6(acq_num, Diag_Source);
      --      --Do_Test6b(acq_num, Diag_Source);
      --      Do_Test6c(acq_num, Diag_Source, one);
      --      Do_Test7a(acq_num, Diag_Source);
      --      --Do_Test7c(acq_num, Diag_Source);	-- Very long...
      --Do_Test8a(acq_num, Diag_Source); -- Redundant
      --Do_Test9(acq_num, Diag_Source);
      --Do_Test9b(acq_num, Diag_Source);
      --      Do_Test10(acq_num, Diag_Source,1 one);		 
      --      --Do_Test11(acq_num, Diag_Source);
      --Do_Test12(acq_num, Diag_Source);
      --Do_Test20(Diag_Source);      
      --Do_Test20b(Diag_Source);          
      --Do_Test21(acq_num, Diag_Source); -- Fonctionne 24 août 2009
      --Do_Test22(acq_num, Diag_Source);  
      --Do_Test23(acq_num, Diag_Source);   
      --Do_Test24(acq_num, Diag_Source);      
      --Do_Test25(acq_num, Diag_Source); -- Fonctionne 21 août 2009
      --Do_Test26(acq_num, Diag_Source); -- Fonctionne 24 août 2009
      --Do_Test27(acq_num, Diag_Source); -- Fonctionne 24 août 2009
      Do_Test28(acq_num, Diag_Source); -- Fonctionne 24 août 2009
      ---------------------------------- 
      
      ----------------------------------
      -- Spectro mode, ROIC + VP7 only
      ---------------------------------- 
      --      Do_Test1b(acq_num, Diag_Source);                                      
      --      Do_Test15(acq_num, Diag_Source);
      --      --Do_Test19(acq_num, Diag_Source);
      --      Do_Test6b(acq_num, Diag_Source); -- Do not use in camera mode, too limit
      --      Do_Test6d(acq_num, Diag_Source); -- Do not use in camera mode, too limit
      --      --      Do_Test16(acq_num, Diag_Source); -- Do not use in camera mode, too limit
      --      Do_Test17(acq_num, Diag_Source); -- Do not use in camera mode, too limit
      --      Do_Test18(acq_num, Diag_Source); -- Do not use in camera mode, too limit
      --      Do_Test2b(acq_num, Diag_Source); -- Do not use in camera mode, too limit
      --      Do_Test9b(acq_num, Diag_Source);       
      ----------------------------------       
      
      assert false report "NONE. Test." severity warning;
      
      if CLINK_DONE = '0' then
         wait until CLINK_DONE = '1';
      end if;
      if CAML_FVAL = '1' then
         wait until CAML_FVAL = '0';
      end if;
      wait for 20 us;                                                 
      if CLINK_DONE = '0' then
         wait until CLINK_DONE = '1';
      end if;
      if CAML_FVAL = '1' then
         wait until CAML_FVAL = '0';
      end if;      
      assert false report "NONE. End of simulation." severity failure;
      
   end process sim_proc;
end sim;   


