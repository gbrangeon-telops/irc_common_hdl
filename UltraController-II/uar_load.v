//
//     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
//     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR
//     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION
//     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION
//     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS
//     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
//     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
//     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
//     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
//     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
//     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
//     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//     FOR A PARTICULAR PURPOSE.
//     
//     (c) Copyright 2005 Xilinx, Inc.
//     All rights reserved.
//
//---------------------------------------------------------------------------
//
//  uar_load.v: Design to convert USR_ACCESS data, written through bitstream,
//              into tck/tms/tdi data connected to JTGC405 signals on the PPC.
//              Useful for loading cache, among other uses.
//
//              Output tck is one half the frequency of clk.  When the
//              bitstream is converted (via genmcs.pl) and downloaded, the CCLK
//              frequency (USRCCLKO signal on STARTUP_VIRTEX4 block) must be 
//              less than or equal to half the frequency of clk.
//
//---------------------------------------------------------------------------

module uar_load (clk, rst, tck, tms, tdi, uar_data_out, uar_datavalid, uar_done);
  input clk;
  input rst;

  output tck, tms, tdi;
  output [31:0] uar_data_out;
  output uar_datavalid, uar_done;

  wire [31:0] uar_data;
  wire datavalid;
  wire uar_edgedetect, uar_edgedetect_skip1;
  wire jtagcount_ce, preload_count_ce;

  reg tcki, datavalid_reg, datavalid_reg2;
  reg uar_active, word_done, uar_done; 
  reg uar_firstword;
  reg jtag_ce, count_is_zero;

  reg [15:0] uar_data_tms, uar_data_tdi;
  reg [3:0] jtagcount;
  reg [27:0] uar_count;

  assign uar_data_out  = uar_data;
  assign uar_datavalid = datavalid;

  USR_ACCESS_VIRTEX4 USR_ACCESS_VIRTEX4_inst (
    .DATA(uar_data), 
    .DATAVALID(datavalid)
  );

  always @(posedge clk)
    if (rst) datavalid_reg <= 0;
    else datavalid_reg <= datavalid;

  always @(posedge clk)
    if (rst) datavalid_reg2 <= 0;
    else datavalid_reg2 <= datavalid_reg;

  assign uar_edgedetect = (datavalid_reg && ! datavalid_reg2);
  assign uar_edgedetect_skip1 = (datavalid_reg && ! datavalid_reg2) && uar_firstword;
  assign preload_count_ce = (datavalid_reg && ! datavalid_reg2) && ! uar_firstword;

  always @(posedge clk)
    if (rst) uar_firstword <= 0;
    else uar_firstword <= (uar_firstword || uar_edgedetect);

  always @(posedge clk)
    if (rst) uar_count <= 28'hfffffff;  // all ones, 1 bit more than uar_data max (27 bits)
    else if (preload_count_ce) 
                             uar_count <= { 1'b0, uar_data[26:0] };
    else if (uar_edgedetect_skip1) uar_count <= (uar_count - 1);

  always @(posedge clk)
    if (rst) uar_active <= 0;
    else uar_active <= (uar_edgedetect_skip1 || uar_active) && (! word_done);

  always @(posedge clk)
    if (rst) count_is_zero <= 0;
    else count_is_zero <= (uar_count == 28'b0);

  always @(posedge clk)
    if (rst) uar_done <= 0;
    else uar_done <= uar_done || ((count_is_zero) && (! uar_active));

  always @(posedge clk)
    if (rst || ! uar_active) jtag_ce <= 0;
    else if (uar_active) jtag_ce <= ! jtag_ce;

  always @(posedge clk)
    if (rst) tcki <= 1;
    else tcki <= (! tcki || ! (uar_edgedetect_skip1 || uar_active));

  always @(posedge clk)
    if (rst) uar_data_tms <= 0;
    else if (uar_edgedetect_skip1) 
       uar_data_tms <= { uar_data[7], uar_data[5], uar_data[3], uar_data[1],
                         uar_data[15], uar_data[13], uar_data[11], uar_data[9],
                         uar_data[23],  uar_data[21], uar_data[19], uar_data[17],
                         uar_data[31],  uar_data[29],  uar_data[27],  uar_data[25]  };
    else if (jtag_ce) uar_data_tms <= { uar_data_tms[14:0], 1'b0 };

  always @(posedge clk)
    if (rst) uar_data_tdi <= 0;
    else if (uar_edgedetect_skip1) 
       uar_data_tdi <= { uar_data[6], uar_data[4], uar_data[2], uar_data[0],
                         uar_data[14], uar_data[12], uar_data[10], uar_data[8],
                         uar_data[22],  uar_data[20], uar_data[18], uar_data[16],
                         uar_data[30],  uar_data[28],  uar_data[26],  uar_data[24]  };
    else if (jtag_ce) uar_data_tdi <= { uar_data_tdi[14:0], 1'b0 };

  assign jtagcount_ce = uar_edgedetect_skip1 || (jtag_ce && uar_active);

  always @(posedge clk)
    if (rst) jtagcount <= 0;
    else if (jtagcount_ce) jtagcount <= jtagcount + 1;

  always @(posedge clk)
    if (rst) word_done <= 0;
    else word_done <= (jtagcount[3] && jtagcount[2] && jtagcount[1] && jtagcount[0]) && jtag_ce;

  assign tck = tcki;
  assign tms = uar_data_tms[15];
  assign tdi = uar_data_tdi[15];

endmodule

