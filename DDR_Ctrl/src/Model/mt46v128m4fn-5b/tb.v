/****************************************************************************************
*
*    File Name:  tb.v
*      Version:  5.7
*        Model:  BUS Functional
*
* Dependencies:  mt46v128m4fn_5b.v, ddr_parameters.v
*
*  Description:  Micron SDRAM DDR (Double Data Rate) test bench
*
*         Note:  - Set simulator resolution to "ps" accuracy
*                - Set Debug = 0 to disable $display messages
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2003 Micron Technology, Inc. All rights reserved.
*
* Rev  Author Date        Changes
* --------------------------------------------------------------------------------
* 2.1  SPH    03/19/2002  - Second Release
*                         - Fix tWR and several incompatability
*                           between different simulators
* 3.0  TFK    02/18/2003  - Added tDSS and tDSH timing checks.
*                         - Added tDQSH and tDQSL timing checks.
* 3.1  CAH    05/28/2003  - update all models to release version 3.1
*                           (no changes to this model)
* 3.2  JMK    06/16/2003  - updated all DDR400 models to support CAS Latency 3
* 3.3  JMK    09/11/2003  - Added initialization sequence checks.
* 4.0  JMK    12/01/2003  - Grouped parameters into "ddr_parameters.v"
*                         - Fixed tWTR check
* 4.1  JMK    01/14/2001  - Grouped specify parameters by speed grade
*                         - Fixed mem_sizes parameter
* 4.2  JMK    03/19/2004  - Fixed pulse width checking on Dqs
* 4.3  JMK    04/27/2004  - Changed BL wire size in tb module
*                         - Changed Dq_buf size to [15:0]
* 5.0  JMK    06/16/2004  - Added read to write checking.
*                         - Added read with precharge truncation to write checking.
*                         - Added associative memory array to reduce memory consumption.
*                         - Added checking for required DQS edges during write.
* 5.1  JMK    08/16/2004  - Fixed checking for required DQS edges during write.
*                         - Fixed wdqs_valid window.
* 5.2  JMK    09/24/2004  - Read or Write without activate will be ignored.
* 5.3  JMK    10/27/2004  - Added tMRD checking during Auto Refresh and Activate.
*                         - Added tRFC checking during Load Mode and Precharge.
* 5.4  JMK    12/13/2004  - The model will not respond to illegal command sequences.
* 5.5  SPH    01/13/2005  - The model will issue a halt on illegal command sequences.
*      JMK    02/11/2005  - Changed the display format for numbers to hex.
* 5.6  JMK    04/22/2005  - Fixed Write with auto precharge calculation.
* 5.7  JMK    08/05/2005  - Changed conditions for read with precharge truncation error.
*                         - Renamed parameters file with .vh extension.
****************************************************************************************/

`timescale 1ns / 1ps

module tb;

`include "ddr_parameters.vh"

    reg                         CLK         ;
    reg                         CLK_N       ;
    reg                         CKE         ;
    reg                         CS_N        ;
    reg                         RAS_N       ;
    reg                         CAS_N       ;
    reg                         WE_N        ;
    reg                 [1 : 0] BA          ;
    reg     [ADDR_BITS - 1 : 0] ADDR        ;
    reg                         dq_en       ;
    reg       [DM_BITS - 1 : 0] dm_out      ;
    reg       [DQ_BITS - 1 : 0] dq_out      ;
    reg         [DM_BITS-1 : 0] dm_fifo [0 : 13];
    reg         [DQ_BITS-1 : 0] dq_fifo [0 : 13];
    reg                  [31:0] dq_in_pos   ;
    reg                  [31:0] dq_in_neg   ;
    reg                         dqs_en      ;
    reg      [DQS_BITS - 1 : 0] dqs_out     ;

    reg                [12 : 0] mode_reg    ;                   //Mode Register
    reg                [12 : 0] ext_mode_reg;                   //Extended Mode Register

    wire                        BO       = mode_reg[3];         //Burst Order
    wire                [7 : 0] BL       = (1<<mode_reg[2:0]);  //Burst Length
    wire                [2 : 0] CL       = (mode_reg[6:4] == 3'b110) ? 2.5 : mode_reg[6:4]; //CAS Latency
    wire                [3 : 0] RL       = CL               ;   //Read Latency
    wire                [3 : 0] WL       = 1                ;   //Write Latency

    wire      [DM_BITS - 1 : 0] DM       = dq_en ? dm_out : {DM_BITS{1'bz}};
    wire    [DQ_BITS   - 1 : 0] DQ       = dq_en ? dq_out : {DQ_BITS{1'bz}};
    wire     [DQS_BITS - 1 : 0] DQS      = dqs_en ? dqs_out : {DQS_BITS{1'bz}};

    wire                [3 : 0] dqs_in   = DQS;
    wire               [31 : 0] dq_in    = DQ;

    mt46v128m4fn_5b sdramddr (
        DQ, 
        DQS, 
        ADDR, 
        BA, 
        CLK, 
        CLK_N, 
        CKE, 
        CS_N, 
        RAS_N, 
        CAS_N, 
        WE_N, 
        DM
    );

    initial CLK <= 1'b1;
    initial CLK_N <= 1'b0;
    always @(posedge CLK) begin
      CLK   <= #(tCK/2) 1'b0;
      CLK_N <= #(tCK/2) 1'b1;
      CLK   <= #(tCK) 1'b1;
      CLK_N <= #(tCK) 1'b0;
    end

    task power_up;
        begin
            CKE     =  1'b0;
            repeat(10) @(negedge CLK);
            $display ("%m at time %t TB:  A 200 us delay is required before CKE can be brought high.", $time);
            @ (negedge CLK) CKE     =  1'b1;
            nop (400/tCK+1);
        end
    endtask

    task load_mode;
        input             [1 : 0] ba;
        input [ADDR_BITS - 1 : 0] addr;
        begin
            case (ba)
                0:     mode_reg = addr;
                1: ext_mode_reg = addr;
            endcase
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b0;
            CAS_N   = 1'b0;
            WE_N    = 1'b0;
            BA      =   ba;
            ADDR    = addr;
            @(negedge CLK);
        end
    endtask

    task refresh;
        begin
            CKE     =  1'b1;
            CS_N    =  1'b0;
            RAS_N   =  1'b0;
            CAS_N   =  1'b0;
            WE_N    =  1'b1;
            @(negedge CLK);
        end
    endtask
     
    task burst_term;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b1;
            CAS_N   = 1'b1;
            WE_N    = 1'b0;
            @(negedge CLK);
        end
    endtask

    task self_refresh;
        input count;
        integer count;
        begin
            CKE     =  1'b0;
            CS_N    =  1'b0;
            RAS_N   =  1'b0;
            CAS_N   =  1'b0;
            WE_N    =  1'b1;
            repeat(count) @(negedge CLK);
        end
    endtask

    task precharge;
        input             [1 : 0] ba;
        input                     ap; //precharge all
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b0;
            CAS_N   = 1'b1;
            WE_N    = 1'b0;
            BA      =   ba;
            ADDR    = (ap<<10);
            @(negedge CLK);
        end
    endtask
     
    task activate;
        input             [1 : 0] ba;
        input [ADDR_BITS - 1 : 0] row;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b0;
            CAS_N   = 1'b1;
            WE_N    = 1'b1;
            BA      =   ba;
            ADDR    =  row;
            @(negedge CLK);
        end
    endtask

    //write task supports burst lengths <= 16
    task write;
        input              [1 : 0] ba;
        input   [COL_BITS - 1 : 0] col;
        input                      ap; //Auto Precharge
        input [16*DM_BITS - 1 : 0] dm;
        input [16*DQ_BITS - 1 : 0] dq;
        reg    [ADDR_BITS - 1 : 0] a [1:0];
        integer i;
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b1;
            CAS_N   = 1'b0;
            WE_N    = 1'b0;
            BA      =   ba;
            a[0] = col & 10'h3ff;   //ADDR[ 9: 0] = COL[ 9: 0]
            a[1] = (col>>10)<<11;   //ADDR[ N:11] = COL[ N:10]
            ADDR = a[0] | a[1] | (ap<<10);
            for (i=0; i<=BL; i=i+1) begin
                dqs_en <= #(WL*tCK + i*tCK/2) 1'b1;
                if (i%2 === 0) begin
                    dqs_out <= #(WL*tCK + i*tCK/2) {DQS_BITS{1'b0}};
                end else begin
                    dqs_out <= #(WL*tCK + i*tCK/2) {DQS_BITS{1'b1}};
                end

                case (i)
                    15: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[16*DM_BITS-1 : 15*DM_BITS];
                    14: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[15*DM_BITS-1 : 14*DM_BITS];
                    13: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[14*DM_BITS-1 : 13*DM_BITS];
                    12: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[13*DM_BITS-1 : 12*DM_BITS];
                    11: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[12*DM_BITS-1 : 11*DM_BITS];
                    10: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[11*DM_BITS-1 : 10*DM_BITS];
                     9: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[10*DM_BITS-1 :  9*DM_BITS];
                     8: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 9*DM_BITS-1 :  8*DM_BITS];
                     7: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 8*DM_BITS-1 :  7*DM_BITS];
                     6: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 7*DM_BITS-1 :  6*DM_BITS];
                     5: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 6*DM_BITS-1 :  5*DM_BITS];
                     4: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 5*DM_BITS-1 :  4*DM_BITS];
                     3: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 4*DM_BITS-1 :  3*DM_BITS];
                     2: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 3*DM_BITS-1 :  2*DM_BITS];
                     1: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 2*DM_BITS-1 :  1*DM_BITS];
                     0: dm_out <= #(WL*tCK + i*tCK/2 + tCK/4) dm[ 1*DM_BITS-1 :  0*DM_BITS];
                endcase
                case (i)
                    15: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[16*DQ_BITS-1 : 15*DQ_BITS];
                    14: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[15*DQ_BITS-1 : 14*DQ_BITS];
                    13: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[14*DQ_BITS-1 : 13*DQ_BITS];
                    12: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[13*DQ_BITS-1 : 12*DQ_BITS];
                    11: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[12*DQ_BITS-1 : 11*DQ_BITS];
                    10: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[11*DQ_BITS-1 : 10*DQ_BITS];
                     9: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[10*DQ_BITS-1 :  9*DQ_BITS];
                     8: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 9*DQ_BITS-1 :  8*DQ_BITS];
                     7: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 8*DQ_BITS-1 :  7*DQ_BITS];
                     6: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 7*DQ_BITS-1 :  6*DQ_BITS];
                     5: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 6*DQ_BITS-1 :  5*DQ_BITS];
                     4: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 5*DQ_BITS-1 :  4*DQ_BITS];
                     3: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 4*DQ_BITS-1 :  3*DQ_BITS];
                     2: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 3*DQ_BITS-1 :  2*DQ_BITS];
                     1: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 2*DQ_BITS-1 :  1*DQ_BITS];
                     0: dq_out <= #(WL*tCK + i*tCK/2 + tCK/4) dq[ 1*DQ_BITS-1 :  0*DQ_BITS];
                endcase
                dq_en  <= #(WL*tCK + i*tCK/2 + tCK/4) 1'b1;
            end
            dqs_en <= #(WL*tCK + BL*tCK/2 + tCK/2) 1'b0;
            dq_en  <= #(WL*tCK + BL*tCK/2 + tCK/4) 1'b0;
            @(negedge CLK);  
        end
    endtask

    task read;
        input              [1 : 0] ba;
        input   [COL_BITS - 1 : 0] col;
        input                      ap; //Auto Precharge
        reg    [ADDR_BITS - 1 : 0] a [1:0];
        begin
            CKE     = 1'b1;
            CS_N    = 1'b0;
            RAS_N   = 1'b1;
            CAS_N   = 1'b0;
            WE_N    = 1'b1;
            BA      =   ba;
            a[0] = col & 10'h3ff;   //ADDR[ 9: 0] = COL[ 9: 0]
            a[1] = (col>>10)<<11;   //ADDR[ N:11] = COL[ N:10]
            ADDR = a[0] | a[1] | (ap<<10);
            @(negedge CLK);
        end
    endtask

    // read with data verification
    task read_verify;
        input              [1 : 0] ba;
        input   [COL_BITS - 1 : 0] col;
        input                      ap; //Auto Precharge
        input [16*DM_BITS - 1 : 0] dm; //Expected Data Mask
        input [16*DQ_BITS - 1 : 0] dq; //Expected Data
        integer i;
        reg                  [2:0] brst_col;
        begin
            read (ba, col, ap);
            for (i=0; i<BL; i=i+1) begin
                // perform burst ordering
                brst_col = col ^ i;
                if (!BO) begin
                    brst_col[1:0] = col + i;
                end
                dm_fifo[2*RL + i] = dm >> (brst_col*DM_BITS);
                dq_fifo[2*RL + i] = dq >> (brst_col*DQ_BITS);
            end
        end
    endtask

    task nop;
        input  count;
        integer count;
        begin
            CKE     =  1'b1;
            CS_N    =  1'b0;
            RAS_N   =  1'b1;
            CAS_N   =  1'b1;
            WE_N    =  1'b1;
            repeat(count) @(negedge CLK);
        end
    endtask

    task deselect;
        input  count;
        integer count;
        begin
            CKE     =  1'b1;
            CS_N    =  1'b1;
            RAS_N   =  1'b1;
            CAS_N   =  1'b1;
            WE_N    =  1'b1;
            repeat(count) @(negedge CLK);
        end
    endtask

    task power_down;
        input  count;
        integer count;
        begin
            CKE     =  1'b0;
            CS_N    =  1'b1;
            RAS_N   =  1'b1;
            CAS_N   =  1'b1;
            WE_N    =  1'b1;
            repeat(count) @(negedge CLK);
        end
    endtask

    // receiver(s) for data_verify process
    always @(dqs_in[0]) begin #(tDQSQ); dqs_receiver(0); end
    always @(dqs_in[1]) begin #(tDQSQ); dqs_receiver(1); end
    always @(dqs_in[2]) begin #(tDQSQ); dqs_receiver(2); end
    always @(dqs_in[3]) begin #(tDQSQ); dqs_receiver(3); end

    task dqs_receiver;
    input i;
    integer i;
    begin
        if (dqs_in[i]) begin
            case (i)
                0: dq_in_pos[ 7: 0] <= dq_in[ 7: 0];
                1: dq_in_pos[15: 8] <= dq_in[15: 8];
                2: dq_in_pos[23:16] <= dq_in[23:16];
                3: dq_in_pos[31:24] <= dq_in[31:24];
            endcase
        end else if (!dqs_in[i]) begin
            case (i)
                0: dq_in_neg[ 7: 0] <= dq_in[ 7: 0];
                1: dq_in_neg[15: 8] <= dq_in[15: 8];
                2: dq_in_neg[23:16] <= dq_in[23:16];
                3: dq_in_neg[31:24] <= dq_in[31:24];
            endcase
        end
    end
    endtask

    
    // perform data verification as a result of read_verify task call
    always @(CLK) begin : data_verify
        integer i;
        reg [DM_BITS-1 : 0] data_mask;
        reg [8*DM_BITS-1 : 0] bit_mask;
        
        for (i=0; i<=14; i=i+1) begin
            dm_fifo[i] = dm_fifo[i+1];
            dq_fifo[i] = dq_fifo[i+1];
        end
        data_mask = dm_fifo[0];
        for (i=0; i<DM_BITS; i=i+1) begin
            bit_mask = {bit_mask, {8{~data_mask[i]}}};
        end
        if (CLK) begin
            if ((dq_in_neg & bit_mask) != (dq_fifo[0] & bit_mask))
                $display ("%m at time %t: ERROR: Read data miscompare: Expected = %h, Actual = %h, Mask = %h", $time, dq_fifo[0], dq_in_neg, bit_mask);
        end else begin
            if ((dq_in_pos & bit_mask) != (dq_fifo[0] & bit_mask))
                $display ("%m at time %t: ERROR: Read data miscompare: Expected = %h, Actual = %h, Mask = %h", $time, dq_fifo[0], dq_in_pos, bit_mask);
        end
    end

    initial begin : test
        CKE     =  1'bz;
        CS_N    =  1'bz;
        RAS_N   =  1'bz;
        CAS_N   =  1'bz;
        WE_N    =  1'bz;
        BA      =  2'bzz;
        ADDR    =  {ADDR_BITS{1'bz}};
        dq_en   =  1'b0;
        dqs_en  =  1'b0;

        // POWERUP SECTION 
        power_up;

        // INITIALIZE SECTION
        precharge       (0, 1);                       // Precharge all banks
        nop             (tRP/tCK);
        
        load_mode       (1, 12'b000000000000);        // Extended Mode Register with DLL Enable
        nop             (tMRD);
        
        load_mode       (0, 12'b00010_010_0_010);     // Mode Register with DLL Reset (CL=2, BL=4)
        nop             (tMRD);
        
        precharge       (0, 1);                       // Precharge all banks
        nop             (tRP/tCK);
        
        refresh;
        nop             (tRFC/tCK);

        refresh;
        nop             (tRFC/tCK);
        
        load_mode       (0, 12'b00000_010_0_010);     // Mode Register without DLL Reset (CL=2, BL=4)
        nop             (tMRD);

        // DLL RESET ENABLE - you will need 200 tCK before any read command.
        nop             (200);

        // WRITE SECTION
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);
        write           (0, 0, 1, 0, 'h0123);         // Write  Bank 0, Col 0

        activate        (1, 0);                       // Activate Bank 1, Row 0
        nop             (tRCD/tCK);
        write           (1, 0, 1, 0, 'h4567);         // Write  Bank 1, Col 0

        activate        (2, 0);                       // Activate Bank 2, Row 0
        nop             (tRCD/tCK);
        write           (2, 0, 1, 0, 'h89AB);         // Write  Bank 2, Col 0

        activate        (3, 0);                       // Activate Bank 3, Row 0
        nop             (tRCD/tCK);
        write           (3, 0, 1, 0, 'hCDEF);         // Write  Bank 3, Col 0
        nop             (BL/2 + tWR/tCK + tRP/tCK + 1);

        // READ SECTION
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRRD/tCK);
        activate        (1, 0);                       // Activate Bank 1, Row 0
        nop             (tRRD/tCK);
        activate        (2, 0);                       // Activate Bank 2, Row 0
        nop             (tRRD/tCK);
        activate        (3, 0);                       // Activate Bank 3, Row 0
        read_verify     (0, 0, 1, 0, 'h0123);         // Read   Bank 0, Col 0
        nop             (BL/2);
        read_verify     (1, 1, 1, 0, 'h4567);         // Read   Bank 1, Col 1
        nop             (BL/2);
        read_verify     (2, 2, 1, 0, 'h89AB);         // Read   Bank 2, Col 2
        nop             (BL/2);
        read_verify     (3, 3, 1, 0, 'hCDEF);         // Read   Bank 3, Col 3
        nop             (RL + BL/2);

        // ACTIVATE SECTION
        activate        (1, 0);                       // Activate Bank 1, Row 0
        nop             (tRRD/tCK);
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);

        // WRITE SECTION
        $display("%m At time %t: WRITE Burst", $time);
        write           (0, 10, 0, 0, 10);            // Write  Bank 0, Col 10
        nop             (BL/2);

        $display("%m At time %t: Consecutive WRITE to WRITE", $time);
        write           (0, 10, 0, 0, 10);            // Write  Bank 0, Col 10
        nop             (1);
        write           (0, 20, 0, 0, 20);            // Write  Bank 0, Col 20
        nop             (BL/2);

        $display("%m At time %t: Nonconsecutive WRITE to WRITE", $time);
        write           (0, 10, 0, 0, 10);            // Write  Bank 0, Col 10
        nop             (2);
        write           (0, 20, 0, 0, 20);            // Write  Bank 0, Col 20
        nop             (BL/2);

        $display("%m At time %t: Random WRITE Cycles", $time);
        write           (0, 10, 0, 0, 10);            // Write  Bank 0, Col 10
        write           (0, 20, 0, 0, 20);            // Write  Bank 0, Col 20
        write           (0, 30, 0, 0, 30);            // Write  Bank 0, Col 30
        write           (0, 40, 0, 0, 40);            // Write  Bank 0, Col 40
        nop             (BL/2);

        $display("%m At time %t: WRITE to READ - Uninterrupting", $time);
        write           (0, 10, 0, 0, 10);            // Write  Bank 0, Col 10
        nop             (3);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: WRITE to READ - Interrupting", $time);
        write           (0, 10, 0, {{2*DM_BITS{1'b1}},{2*DM_BITS{1'b0}}}, 10);  // Write  Bank 0, Col 10
        nop             (2);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: WRITE to READ - Odd Number of Data, Interrupting", $time);
        write           (0, 10, 0, {{2*DM_BITS+DM_BITS{1'b1}},{2*DM_BITS-DM_BITS{1'b0}}}, {4*DQ_BITS{1'b1}});  // Write  Bank 0, Col 10
        nop             (2);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: WRITE to PRECHARGE - Uninterrupting", $time);
        write           (0, 10, 0, 0, 10);            // Write  Bank 0, Col 10
        nop             (BL/2 + tWR/tCK);
        precharge       (0, 0);                       // Precharge Bank 0
        nop             (tRP/tCK);
        
        $display("%m At time %t: WRITE to PRECHARGE - Interrupting", $time);
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);
        write           (0, 10, 0, {{2*DM_BITS{1'b1}},{2*DM_BITS{1'b0}}}, 10);  // Write  Bank 0, Col 10
        nop             (1 + tWR/tCK);
        precharge       (0, 0);                       // Precharge Bank 0
        nop             (tRP/tCK);

        $display("%m At time %t: WRITE to PRECHARGE - Odd Number of Data - Interrupting", $time);
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);
        write           (0, 10, 0, {{2*DM_BITS+DM_BITS{1'b1}},{2*DM_BITS-DM_BITS{1'b0}}}, 10);  // Write  Bank 0, Col 10
        nop             (1 + tWR/tCK);
        precharge       (0, 0);                       // Precharge Bank 0
        nop             (tRP/tCK);

        $display("%m At time %t: WRITE with AUTO PRECHARGE", $time);
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);
        write           (0, 10, 1, 0, 10);            // Write  Bank 0, Col 10
        nop             (BL/2 + tWR/tCK + tRP/tCK + 1);

        // READ SECTION
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRCD/tCK);

        $display("%m At time %t: READ Burst", $time);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        nop             (3+BL/2);

        $display("%m At time %t: Consecutive READ Bursts", $time);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        nop             (BL/2-1);
        read            (0, 20, 0);                   // Read   Bank 0, Col 20
        nop             (3+BL/2);
        
        $display("%m At time %t: Nonconsecutive READ Bursts", $time);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        nop             (BL/2);
        read            (0, 20, 0);                   // Read   Bank 0, Col 20
        nop             (3+BL/2);

        $display("%m At time %t: Random READ Accesses", $time);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        read            (0, 20, 0);                   // Read   Bank 0, Col 20
        read            (0, 30, 0);                   // Read   Bank 0, Col 30
        read            (0, 40, 0);                   // Read   Bank 0, Col 40
        nop             (3+BL/2);
        
        $display("%m At time %t: Terminating a READ Burst", $time);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        burst_term;
        nop             (BL/2);

        $display("%m At time %t: READ to WRITE", $time);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        burst_term;
        nop             (1);
        write           (0, 10, 0, 0, 10);            // Write  Bank 0, Col 10
        nop             (1+BL/2);

        $display("%m At time %t: READ to PRECHARGE", $time);
        read            (0, 10, 0);                   // Read   Bank 0, Col 10
        nop             (1);        
        precharge       (0, 1);                       // Precharge all banks
        nop             (tRP/tCK);

        $display("%m At time %t: READ with AUTO PRECHARGE", $time);
        activate        (0, 0);                       // Activate Bank 0, Row 0
        nop             (tRAS/tCK);
        read            (0, 10, 1);                   // Read   Bank 0, Col 10
        nop             (2 + BL/2 + tRP/tCK);

        $stop;
        $finish;
    end

endmodule
