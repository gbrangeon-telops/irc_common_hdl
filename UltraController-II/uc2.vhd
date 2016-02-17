-------------------------------------------------------------------------------
-- uc2.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity uc2 is
  port (
    sys_clk : in std_logic;
    sys_rst : in std_logic;
    gpio_in : in std_logic_vector(0 to 31);
    gpio_out : out std_logic_vector(0 to 31);
    interrupt : in std_logic;
    sys_rst_out : out std_logic;
    jtag_tck : in std_logic;
    jtag_tms : in std_logic;
    jtag_tdi : in std_logic;
    jtag_tdo : out std_logic;
    jtag_tdoen : out std_logic
  );
end uc2;

architecture STRUCTURE of uc2 is

  attribute box_type : STRING;

  component debughalt_0_wrapper is
    port (
      CPU_HALT_N : in std_logic;
      CPU_HALT : in std_logic;
      DEASSERT_HALT : in std_logic;
      ASSERT_HALT : in std_logic;
      DEBUGHALT_HALT : out std_logic
    );
  end component;

  attribute box_type of debughalt_0_wrapper: component is "black_box";

  component vl_0_wrapper is
    port (
      Op1 : in std_logic_vector(0 to 0);
      Op2 : in std_logic_vector(0 to 0);
      Res : out std_logic_vector(0 to 0)
    );
  end component;

  attribute box_type of vl_0_wrapper: component is "black_box";

  component ff_0_wrapper is
    port (
      Clk : in std_logic;
      RST : in std_logic;
      SET : in std_logic;
      CE : in std_logic;
      D : in std_logic_vector(0 to 0);
      Q : out std_logic_vector(0 to 0)
    );
  end component;

  attribute box_type of ff_0_wrapper: component is "black_box";

  component ppc405_0_wrapper is
    port (
      C405CPMCORESLEEPREQ : out std_logic;
      C405CPMMSRCE : out std_logic;
      C405CPMMSREE : out std_logic;
      C405CPMTIMERIRQ : out std_logic;
      C405CPMTIMERRESETREQ : out std_logic;
      C405XXXMACHINECHECK : out std_logic;
      CPMC405CLOCK : in std_logic;
      CPMC405CORECLKINACTIVE : in std_logic;
      CPMC405CPUCLKEN : in std_logic;
      CPMC405JTAGCLKEN : in std_logic;
      CPMC405TIMERCLKEN : in std_logic;
      CPMC405TIMERTICK : in std_logic;
      MCBCPUCLKEN : in std_logic;
      MCBTIMEREN : in std_logic;
      MCPPCRST : in std_logic;
      PLBCLK : in std_logic;
      DCRCLK : in std_logic;
      C405RSTCHIPRESETREQ : out std_logic;
      C405RSTCORERESETREQ : out std_logic;
      C405RSTSYSRESETREQ : out std_logic;
      RSTC405RESETCHIP : in std_logic;
      RSTC405RESETCORE : in std_logic;
      RSTC405RESETSYS : in std_logic;
      C405PLBICUABUS : out std_logic_vector(0 to 31);
      C405PLBICUBE : out std_logic_vector(0 to 7);
      C405PLBICURNW : out std_logic;
      C405PLBICUABORT : out std_logic;
      C405PLBICUBUSLOCK : out std_logic;
      C405PLBICUU0ATTR : out std_logic;
      C405PLBICUGUARDED : out std_logic;
      C405PLBICULOCKERR : out std_logic;
      C405PLBICUMSIZE : out std_logic_vector(0 to 1);
      C405PLBICUORDERED : out std_logic;
      C405PLBICUPRIORITY : out std_logic_vector(0 to 1);
      C405PLBICURDBURST : out std_logic;
      C405PLBICUREQUEST : out std_logic;
      C405PLBICUSIZE : out std_logic_vector(0 to 3);
      C405PLBICUTYPE : out std_logic_vector(0 to 2);
      C405PLBICUWRBURST : out std_logic;
      C405PLBICUWRDBUS : out std_logic_vector(0 to 63);
      C405PLBICUCACHEABLE : out std_logic;
      PLBC405ICUADDRACK : in std_logic;
      PLBC405ICUBUSY : in std_logic;
      PLBC405ICUERR : in std_logic;
      PLBC405ICURDBTERM : in std_logic;
      PLBC405ICURDDACK : in std_logic;
      PLBC405ICURDDBUS : in std_logic_vector(0 to 63);
      PLBC405ICURDWDADDR : in std_logic_vector(0 to 3);
      PLBC405ICUREARBITRATE : in std_logic;
      PLBC405ICUWRBTERM : in std_logic;
      PLBC405ICUWRDACK : in std_logic;
      PLBC405ICUSSIZE : in std_logic_vector(0 to 1);
      PLBC405ICUSERR : in std_logic;
      PLBC405ICUSBUSYS : in std_logic;
      C405PLBDCUABUS : out std_logic_vector(0 to 31);
      C405PLBDCUBE : out std_logic_vector(0 to 7);
      C405PLBDCURNW : out std_logic;
      C405PLBDCUABORT : out std_logic;
      C405PLBDCUBUSLOCK : out std_logic;
      C405PLBDCUU0ATTR : out std_logic;
      C405PLBDCUGUARDED : out std_logic;
      C405PLBDCULOCKERR : out std_logic;
      C405PLBDCUMSIZE : out std_logic_vector(0 to 1);
      C405PLBDCUORDERED : out std_logic;
      C405PLBDCUPRIORITY : out std_logic_vector(0 to 1);
      C405PLBDCURDBURST : out std_logic;
      C405PLBDCUREQUEST : out std_logic;
      C405PLBDCUSIZE : out std_logic_vector(0 to 3);
      C405PLBDCUTYPE : out std_logic_vector(0 to 2);
      C405PLBDCUWRBURST : out std_logic;
      C405PLBDCUWRDBUS : out std_logic_vector(0 to 63);
      C405PLBDCUCACHEABLE : out std_logic;
      C405PLBDCUWRITETHRU : out std_logic;
      PLBC405DCUADDRACK : in std_logic;
      PLBC405DCUBUSY : in std_logic;
      PLBC405DCUERR : in std_logic;
      PLBC405DCURDBTERM : in std_logic;
      PLBC405DCURDDACK : in std_logic;
      PLBC405DCURDDBUS : in std_logic_vector(0 to 63);
      PLBC405DCURDWDADDR : in std_logic_vector(0 to 3);
      PLBC405DCUREARBITRATE : in std_logic;
      PLBC405DCUWRBTERM : in std_logic;
      PLBC405DCUWRDACK : in std_logic;
      PLBC405DCUSSIZE : in std_logic_vector(0 to 1);
      PLBC405DCUSERR : in std_logic;
      PLBC405DCUSBUSYS : in std_logic;
      BRAMDSOCMCLK : in std_logic;
      BRAMDSOCMRDDBUS : in std_logic_vector(0 to 31);
      DSARCVALUE : in std_logic_vector(0 to 7);
      DSCNTLVALUE : in std_logic_vector(0 to 7);
      DSOCMBRAMABUS : out std_logic_vector(8 to 29);
      DSOCMBRAMBYTEWRITE : out std_logic_vector(0 to 3);
      DSOCMBRAMEN : out std_logic;
      DSOCMBRAMWRDBUS : out std_logic_vector(0 to 31);
      DSOCMBUSY : out std_logic;
      BRAMISOCMCLK : in std_logic;
      BRAMISOCMRDDBUS : in std_logic_vector(0 to 63);
      ISARCVALUE : in std_logic_vector(0 to 7);
      ISCNTLVALUE : in std_logic_vector(0 to 7);
      ISOCMBRAMEN : out std_logic;
      ISOCMBRAMEVENWRITEEN : out std_logic;
      ISOCMBRAMODDWRITEEN : out std_logic;
      ISOCMBRAMRDABUS : out std_logic_vector(8 to 28);
      ISOCMBRAMWRABUS : out std_logic_vector(8 to 28);
      ISOCMBRAMWRDBUS : out std_logic_vector(0 to 31);
      C405DCRABUS : out std_logic_vector(0 to 9);
      C405DCRDBUSOUT : out std_logic_vector(0 to 31);
      C405DCRREAD : out std_logic;
      C405DCRWRITE : out std_logic;
      DCRC405ACK : in std_logic;
      DCRC405DBUSIN : in std_logic_vector(0 to 31);
      EICC405CRITINPUTIRQ : in std_logic;
      EICC405EXTINPUTIRQ : in std_logic;
      C405JTGCAPTUREDR : out std_logic;
      C405JTGEXTEST : out std_logic;
      C405JTGPGMOUT : out std_logic;
      C405JTGSHIFTDR : out std_logic;
      C405JTGTDO : out std_logic;
      C405JTGTDOEN : out std_logic;
      C405JTGUPDATEDR : out std_logic;
      MCBJTAGEN : in std_logic;
      JTGC405BNDSCANTDO : in std_logic;
      JTGC405TCK : in std_logic;
      JTGC405TDI : in std_logic;
      JTGC405TMS : in std_logic;
      JTGC405TRSTNEG : in std_logic;
      C405DBGMSRWE : out std_logic;
      C405DBGSTOPACK : out std_logic;
      C405DBGWBCOMPLETE : out std_logic;
      C405DBGWBFULL : out std_logic;
      C405DBGWBIAR : out std_logic_vector(0 to 29);
      DBGC405DEBUGHALT : in std_logic;
      DBGC405EXTBUSHOLDACK : in std_logic;
      DBGC405UNCONDDEBUGEVENT : in std_logic;
      C405TRCCYCLE : out std_logic;
      C405TRCEVENEXECUTIONSTATUS : out std_logic_vector(0 to 1);
      C405TRCODDEXECUTIONSTATUS : out std_logic_vector(0 to 1);
      C405TRCTRACESTATUS : out std_logic_vector(0 to 3);
      C405TRCTRIGGEREVENTOUT : out std_logic;
      C405TRCTRIGGEREVENTTYPE : out std_logic_vector(0 to 10);
      TRCC405TRACEDISABLE : in std_logic;
      TRCC405TRIGGEREVENTIN : in std_logic
    );
  end component;

  attribute box_type of ppc405_0_wrapper: component is "black_box";

  component uc2_reset_0_wrapper is
    port (
      UC2_sync_clk : in std_logic;
      Ext_Reset_In : in std_logic;
      Core_Reset_Req : in std_logic;
      Chip_Reset_Req : in std_logic;
      System_Reset_Req : in std_logic;
      Reset405out : out std_logic
    );
  end component;

  attribute box_type of uc2_reset_0_wrapper: component is "black_box";    
  attribute keep : string;

  -- Internal signals

  signal C405DBGMSRWE : std_logic;                      
  attribute keep of C405DBGMSRWE : signal is "true";
  signal addr_ff_0 : std_logic_vector(0 to 0);
  signal dbgc405debughalt : std_logic;                                  
  attribute keep of dbgc405debughalt : signal is "true";
  signal icu_req_to_addrack : std_logic;
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd2 : std_logic_vector(0 to 1);
  signal net_gnd32 : std_logic_vector(0 to 31);
  signal net_gnd4 : std_logic_vector(0 to 3);
  signal net_gnd64 : std_logic_vector(0 to 63);
  signal net_vcc0 : std_logic;
  signal pgassign1 : std_logic_vector(0 to 3);
  signal pgassign2 : std_logic_vector(0 to 63);
  signal pgassign3 : std_logic_vector(0 to 1);
  signal pgassign4 : std_logic_vector(0 to 7);
  signal pgassign5 : std_logic_vector(0 to 7);
  signal pgassign6 : std_logic_vector(0 to 63);
  signal pgassign7 : std_logic_vector(0 to 7);
  signal pgassign8 : std_logic_vector(0 to 0);
  signal proc_sys_reset_0_Rstc405resetsys : std_logic;
  --signal sys_clk_in : std_logic;
  signal system_reset_in : std_logic;
  attribute keep of system_reset_in : signal is "true";
  signal system_reset_req_from_ppc405 : std_logic;
  signal tck : std_logic;
  signal tdi : std_logic;
  signal tdo : std_logic;
  signal tdoen : std_logic;
  signal tms : std_logic;
  signal wdaddr : std_logic_vector(0 to 0);

begin

  -- Internal assignments

  --sys_clk_in <= sys_clk;
  system_reset_in <= sys_rst;
  sys_rst_out <= system_reset_req_from_ppc405;
  tck <= jtag_tck;
  tms <= jtag_tms;
  tdi <= jtag_tdi;
  jtag_tdo <= tdo;
  jtag_tdoen <= tdoen;
  pgassign2(0 to 63) <= X"4bff3ffa38000001";
  pgassign3(0 to 1) <= B"01";
  pgassign4(0 to 7) <= X"01";
  pgassign5(0 to 7) <= X"81";
  pgassign6(0 to 63) <= X"7C1BFBA64BFF3FFE";
  pgassign7(0 to 7) <= X"00";
  pgassign8(0 to 0) <= B"0";
  pgassign1(0 to 0) <= B"0";
  pgassign1(1 to 1) <= B"0";
  pgassign1(2 to 2) <= wdaddr(0 to 0);
  pgassign1(3 to 3) <= B"0";
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd2(0 to 1) <= B"00";
  net_gnd32(0 to 31) <= B"00000000000000000000000000000000";
  net_gnd4(0 to 3) <= B"0000";
  net_gnd64(0 to 63) <= B"0000000000000000000000000000000000000000000000000000000000000000";
  net_vcc0 <= '1';

  debughalt_0 : debughalt_0_wrapper
    port map (
      CPU_HALT_N => net_vcc0,
      CPU_HALT => net_gnd0,
      DEASSERT_HALT => C405DBGMSRWE,
      ASSERT_HALT => net_gnd0,
      DEBUGHALT_HALT => dbgc405debughalt
    );

  vl_0 : vl_0_wrapper
    port map (
      Op1 => wdaddr(0 to 0),
      Op2 => net_gnd1(0 to 0),
      Res => addr_ff_0(0 to 0)
    );

  ff_0 : ff_0_wrapper
    port map (
      Clk => sys_clk,
      RST => net_gnd0,
      SET => net_gnd0,
      CE => net_gnd0,
      D => addr_ff_0(0 to 0),
      Q => wdaddr(0 to 0)
    );

  ppc405_0 : ppc405_0_wrapper
    port map (
      C405CPMCORESLEEPREQ => open,
      C405CPMMSRCE => open,
      C405CPMMSREE => open,
      C405CPMTIMERIRQ => open,
      C405CPMTIMERRESETREQ => open,
      C405XXXMACHINECHECK => open,
      CPMC405CLOCK => sys_clk,
      CPMC405CORECLKINACTIVE => net_gnd0,
      CPMC405CPUCLKEN => net_vcc0,
      CPMC405JTAGCLKEN => net_vcc0,
      CPMC405TIMERCLKEN => net_vcc0,
      CPMC405TIMERTICK => net_vcc0,
      MCBCPUCLKEN => net_vcc0,
      MCBTIMEREN => net_vcc0,
      MCPPCRST => net_vcc0,
      PLBCLK => sys_clk,
      DCRCLK => net_gnd0,
      C405RSTCHIPRESETREQ => open,
      C405RSTCORERESETREQ => open,
      C405RSTSYSRESETREQ => system_reset_req_from_ppc405,
      RSTC405RESETCHIP => proc_sys_reset_0_Rstc405resetsys,
      RSTC405RESETCORE => proc_sys_reset_0_Rstc405resetsys,
      RSTC405RESETSYS => proc_sys_reset_0_Rstc405resetsys,
      C405PLBICUABUS => open,
      C405PLBICUBE => open,
      C405PLBICURNW => open,
      C405PLBICUABORT => open,
      C405PLBICUBUSLOCK => open,
      C405PLBICUU0ATTR => open,
      C405PLBICUGUARDED => open,
      C405PLBICULOCKERR => open,
      C405PLBICUMSIZE => open,
      C405PLBICUORDERED => open,
      C405PLBICUPRIORITY => open,
      C405PLBICURDBURST => open,
      C405PLBICUREQUEST => icu_req_to_addrack,
      C405PLBICUSIZE => open,
      C405PLBICUTYPE => open,
      C405PLBICUWRBURST => open,
      C405PLBICUWRDBUS => open,
      C405PLBICUCACHEABLE => open,
      PLBC405ICUADDRACK => icu_req_to_addrack,
      PLBC405ICUBUSY => net_gnd0,
      PLBC405ICUERR => net_gnd0,
      PLBC405ICURDBTERM => net_gnd0,
      PLBC405ICURDDACK => net_vcc0,
      PLBC405ICURDDBUS => pgassign2,
      PLBC405ICURDWDADDR => pgassign1,
      PLBC405ICUREARBITRATE => net_gnd0,
      PLBC405ICUWRBTERM => net_gnd0,
      PLBC405ICUWRDACK => net_gnd0,
      PLBC405ICUSSIZE => pgassign3,
      PLBC405ICUSERR => net_gnd0,
      PLBC405ICUSBUSYS => net_gnd0,
      C405PLBDCUABUS => open,
      C405PLBDCUBE => open,
      C405PLBDCURNW => open,
      C405PLBDCUABORT => open,
      C405PLBDCUBUSLOCK => open,
      C405PLBDCUU0ATTR => open,
      C405PLBDCUGUARDED => open,
      C405PLBDCULOCKERR => open,
      C405PLBDCUMSIZE => open,
      C405PLBDCUORDERED => open,
      C405PLBDCUPRIORITY => open,
      C405PLBDCURDBURST => open,
      C405PLBDCUREQUEST => open,
      C405PLBDCUSIZE => open,
      C405PLBDCUTYPE => open,
      C405PLBDCUWRBURST => open,
      C405PLBDCUWRDBUS => open,
      C405PLBDCUCACHEABLE => open,
      C405PLBDCUWRITETHRU => open,
      PLBC405DCUADDRACK => net_gnd0,
      PLBC405DCUBUSY => net_gnd0,
      PLBC405DCUERR => net_gnd0,
      PLBC405DCURDBTERM => net_gnd0,
      PLBC405DCURDDACK => net_gnd0,
      PLBC405DCURDDBUS => net_gnd64,
      PLBC405DCURDWDADDR => net_gnd4,
      PLBC405DCUREARBITRATE => net_gnd0,
      PLBC405DCUWRBTERM => net_gnd0,
      PLBC405DCUWRDACK => net_gnd0,
      PLBC405DCUSSIZE => net_gnd2,
      PLBC405DCUSERR => net_gnd0,
      PLBC405DCUSBUSYS => net_gnd0,
      BRAMDSOCMCLK => net_gnd0,
      BRAMDSOCMRDDBUS => gpio_in,
      DSARCVALUE => pgassign4,
      DSCNTLVALUE => pgassign5,
      DSOCMBRAMABUS => open,
      DSOCMBRAMBYTEWRITE => open,
      DSOCMBRAMEN => open,
      DSOCMBRAMWRDBUS => open,
      DSOCMBUSY => open,
      BRAMISOCMCLK => sys_clk,
      BRAMISOCMRDDBUS => pgassign6,
      ISARCVALUE => pgassign7,
      ISCNTLVALUE => pgassign5,
      ISOCMBRAMEN => open,
      ISOCMBRAMEVENWRITEEN => open,
      ISOCMBRAMODDWRITEEN => open,
      ISOCMBRAMRDABUS => open,
      ISOCMBRAMWRABUS => open,
      ISOCMBRAMWRDBUS => gpio_out,
      C405DCRABUS => open,
      C405DCRDBUSOUT => open,
      C405DCRREAD => open,
      C405DCRWRITE => open,
      DCRC405ACK => net_gnd0,
      DCRC405DBUSIN => net_gnd32,
      EICC405CRITINPUTIRQ => net_gnd0,
      EICC405EXTINPUTIRQ => interrupt,
      C405JTGCAPTUREDR => open,
      C405JTGEXTEST => open,
      C405JTGPGMOUT => open,
      C405JTGSHIFTDR => open,
      C405JTGTDO => tdo,
      C405JTGTDOEN => tdoen,
      C405JTGUPDATEDR => open,
      MCBJTAGEN => net_vcc0,
      JTGC405BNDSCANTDO => net_gnd0,
      JTGC405TCK => tck,
      JTGC405TDI => tdi,
      JTGC405TMS => tms,
      JTGC405TRSTNEG => net_vcc0,
      C405DBGMSRWE => C405DBGMSRWE,      
      C405DBGSTOPACK => open,
      C405DBGWBCOMPLETE => open,
      C405DBGWBFULL => open,
      C405DBGWBIAR => open,
      DBGC405DEBUGHALT => dbgc405debughalt,
      DBGC405EXTBUSHOLDACK => net_gnd0,
      DBGC405UNCONDDEBUGEVENT => net_gnd0,
      C405TRCCYCLE => open,
      C405TRCEVENEXECUTIONSTATUS => open,
      C405TRCODDEXECUTIONSTATUS => open,
      C405TRCTRACESTATUS => open,
      C405TRCTRIGGEREVENTOUT => open,
      C405TRCTRIGGEREVENTTYPE => open,
      TRCC405TRACEDISABLE => net_gnd0,
      TRCC405TRIGGEREVENTIN => net_gnd0
    );

  uc2_reset_0 : uc2_reset_0_wrapper
    port map (
      UC2_sync_clk => sys_clk,
      Ext_Reset_In => system_reset_in,
      Core_Reset_Req => net_gnd0,
      Chip_Reset_Req => net_gnd0,
      System_Reset_Req => system_reset_req_from_ppc405,
      Reset405out => proc_sys_reset_0_Rstc405resetsys
    );

end architecture STRUCTURE;

